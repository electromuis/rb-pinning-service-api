class Pin < ApplicationRecord
  STATUSES = ["queued", "pinning", "pinned", "failed"]
  validates_presence_of :cid
  validates :status, inclusion: { in: STATUSES }

  scope :status, ->(statuses) { where(status: statuses) }
  scope :cids, ->(cids) { where(cid: cids) }
  scope :name_contains, ->(name) { where('name ilike ?', "%#{name}%") }
  scope :before, ->(before) { where('created_at < ?', before) }
  scope :after, ->(after) { where('created_at > ?', after) }
  scope :meta, ->(meta) { where("meta->>? = ?", meta.first[0], meta.first[1]) }
  scope :not_deleted, -> { where(deleted_at: nil) }

  before_save :set_delegates

  def set_delegates
    self.delegates = ipfs_client.id['Addresses'].reject{|a| a.match('127.0.0.1') }
  end

  def ipfs_client
    # TODO this needs to be configurable
    @client ||= Ipfs::Client.new( "http://#{ENV.fetch("IPFS_URL") { 'localhost' }}:5001")
  end

  def ipfs_add
    begin
      update_columns(status: 'pinning')
      origins.each do |origin|
        ipfs_client.swarm_connect(origin)
      end
      ipfs_client.pin_add(cid)
      update_columns(status: 'pinned')
    rescue => e
      puts e
      # TODO record the exception somewhere
      update_columns(status: 'failed')
    end
  end

  def ipfs_remove
    # TODO only unpin cid if this is the only pin with that CID
    begin
      ipfs_client.pin_rm(cid)
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
end
