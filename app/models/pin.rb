class Pin < ApplicationRecord
  STATUSES = ["queued", "pinning", "pinned", "failed", "removed"]
  validates_presence_of :cid
  validates :status, inclusion: { in: STATUSES }

  scope :status, ->(statuses) { where(status: statuses) }
  scope :cids, ->(cids) { where(cid: cids) }
  scope :name_contains, ->(name) { where('lower(name) like ?', "%#{name.downcase}%") }
  scope :before, ->(before) { where('created_at < ?', before) }
  scope :after, ->(after) { where('created_at > ?', after) }
  scope :meta, ->(meta) do
    # NOTE: Using sanitize_sql because interpolating with a placeholder causes a MySQL syntax error.
    where(
      "meta->>'$.#{ActiveRecord::Base.sanitize_sql(meta.first[0])}' = ?",
      meta.first[1]
    )
  end
  scope :not_deleted, -> { where(deleted_at: nil) }

  after_initialize :set_json_defaults

  before_create :check_inlined_cids

  before_save :set_delegates

  belongs_to :user

  def set_delegates
    self.delegates = ipfs_client.id['Addresses'].reject{|a| a.match('127.0.0.1') }
  end

  def ipfs_client
    @client ||= Ipfs::Client.new( "http://#{ENV.fetch("IPFS_URL") { 'localhost' }}:#{ENV.fetch("IPFS_PORT") { '5001' }}")
  end

  def ipfs_add_async
    IpfsAddWorker.perform_async(id)
  end

  def check_inlined_cids
    self.status = 'pinned' if inlined_cids?
  end

  def inlined_cids?
    Cid.decode(cid).multihash.name == 'identity'
  end

  def ipfs_add
    begin
      update_columns(status: 'pinning') unless status == 'pinned'

      origins.each do |origin|
        ipfs_client.swarm_connect(origin)
      end
      ipfs_client.pin_add(cid)

      update_columns(status: 'pinned', storage_size: find_storage_size)
      user.update_used_storage(add: storage_size)
    rescue Ipfs::Commands::Error => e
      puts e
      # TODO record the exception somewhere
      update_columns(status: 'failed')
    end
  end

  def ipfs_remove_async
    IpfsRemoveWorker.perform_async(id)
  end

  def ipfs_remove
    # TODO only unpin cid if this is the only pin with that CID
    begin
      ipfs_client.pin_rm(cid)
      update_columns(status: 'removed')
      user.update_used_storage(remove: storage_size)
    rescue Ipfs::Commands::Error => e
      raise unless JSON.parse(e.message)['Code'] == 0
    end
  end

  def info
    # TODO implement this
    {}
  end

  def mark_deleted
    update_columns(deleted_at: Time.zone.now)
  end

  private

  def set_json_defaults
    self.origins ||= []
    self.delegates ||= []
    self.meta ||= {}
  end

  # Note: Size of directory objects is 0, hence CumulativeSize is being used for them.
  def find_storage_size
    stat = ipfs_client.files_stat(cid)
    stat.fetch('Type') == 'file' ? stat.fetch('Size') : stat.fetch('CumulativeSize')
  end
end
