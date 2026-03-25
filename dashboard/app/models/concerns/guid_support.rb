# Module: GuidSupport
# Provides GUID-based lookup functionality for curriculum models
# Supports dual-key lookups (both ID and GUID) during migration period

module GuidSupport
  extend ActiveSupport::Concern

  included do
    # Ensure GUID is present and unique
    validates :guid, presence: true, uniqueness: true, if: :guid_column_exists?
    
    # Generate GUID before validation if not present
    before_validation :ensure_guid, if: :guid_column_exists?
  end

  class_methods do
    # Find by ID or GUID - supports both during migration period
    def find_by_id_or_guid(identifier)
      return nil if identifier.blank?
      
      # Try to find by GUID first (newer approach)
      if guid_column_exists? && identifier.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
        find_by(guid: identifier)
      else
        # Fall back to ID lookup
        find_by(id: identifier)
      end
    end

    # Find by ID or GUID with error handling
    def find_by_id_or_guid!(identifier)
      find_by_id_or_guid(identifier) || raise(ActiveRecord::RecordNotFound, "Couldn't find #{name} with identifier '#{identifier}'")
    end

    # Check if GUID column exists (for migration period)
    def guid_column_exists?
      column_names.include?('guid')
    end

    # Find by GUID only (for new code)
    def find_by_guid(guid)
      return nil unless guid_column_exists?
      find_by(guid: guid)
    end

    # Find by GUID with error handling
    def find_by_guid!(guid)
      find_by_guid(guid) || raise(ActiveRecord::RecordNotFound, "Couldn't find #{name} with GUID '#{guid}'")
    end

    # Get all records by GUIDs
    def find_by_guids(guids)
      return none unless guid_column_exists? && guids.present?
      where(guid: guids)
    end

    # Cache key that includes both ID and GUID
    def cache_key_with_guid(identifier)
      if guid_column_exists? && identifier.match?(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
        "guid:#{identifier}"
      else
        "id:#{identifier}"
      end
    end
  end

  # Instance methods
  def identifier
    guid_column_exists? ? guid : id.to_s
  end

  def cache_key_with_guid
    self.class.cache_key_with_guid(identifier)
  end

  private

  def ensure_guid
    self.guid = SecureRandom.uuid if guid_column_exists? && guid.blank?
  end

  def guid_column_exists?
    self.class.guid_column_exists?
  end
end