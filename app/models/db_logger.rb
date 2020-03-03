class DbLogger < ApplicationRecord
  def self.dump(msg)
    new_log = self.create(comment: msg)
    logger.warn("###[warn]### debug=#{new_log.id} time=#{Time.now} :: #{msg}")
  end
end
