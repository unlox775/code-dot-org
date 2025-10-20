# frozen_string_literal: true

# GUID Mapping Service
# This service manages GUID mappings for curriculum entities
# It loads mapping files and provides methods to get/set GUIDs for entities

module Services
  class GuidMappingService
    MAPPINGS_DIR = Rails.root.join('config', 'curriculum_guid_mappings')
    
    def initialize
      @mappings_cache = {}
      @mappings_loaded = false
    end
    
    # Get GUID for an entity using its unique identifier
    def get_guid(entity_type, identifier)
      load_mappings_if_needed
      mappings = @mappings_cache[entity_type.to_s]
      return nil unless mappings
      
      mappings[identifier]
    end
    
    # Set GUID for an entity (updates both cache and file)
    def set_guid(entity_type, identifier, guid)
      load_mappings_if_needed
      @mappings_cache[entity_type.to_s] ||= {}
      @mappings_cache[entity_type.to_s][identifier] = guid
      save_mapping_file(entity_type.to_s)
    end
    
    # Get or create GUID for an entity (creates new GUID if not exists)
    def get_or_create_guid(entity_type, identifier)
      existing_guid = get_guid(entity_type, identifier)
      return existing_guid if existing_guid
      
      # Generate new GUID
      new_guid = SecureRandom.uuid
      set_guid(entity_type, identifier, new_guid)
      new_guid
    end
    
    # Check if entity has a GUID mapping
    def has_guid?(entity_type, identifier)
      load_mappings_if_needed
      mappings = @mappings_cache[entity_type.to_s]
      return false unless mappings
      
      mappings.key?(identifier)
    end
    
    # Get all mappings for an entity type
    def get_all_mappings(entity_type)
      load_mappings_if_needed
      @mappings_cache[entity_type.to_s] || {}
    end
    
    # Reload mappings from files
    def reload_mappings
      @mappings_cache.clear
      @mappings_loaded = false
      load_mappings_if_needed
    end
    
    private
    
    def load_mappings_if_needed
      return if @mappings_loaded
      
      # Load all mapping files
      mapping_files = Dir.glob(File.join(MAPPINGS_DIR, '*.json'))
      
      mapping_files.each do |file_path|
        entity_type = File.basename(file_path, '.json')
        next if entity_type == 'mapping_summary'
        
        begin
          mappings = JSON.parse(File.read(file_path))
          @mappings_cache[entity_type] = mappings
        rescue => e
          Rails.logger.warn "Failed to load mapping file #{file_path}: #{e.message}"
        end
      end
      
      @mappings_loaded = true
    end
    
    def save_mapping_file(entity_type)
      file_path = File.join(MAPPINGS_DIR, "#{entity_type}.json")
      mappings = @mappings_cache[entity_type] || {}
      
      File.write(file_path, JSON.pretty_generate(mappings))
    end
  end
end