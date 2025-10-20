# frozen_string_literal: true

# Enhanced Script Seed Service with GUID Support
# This service extends the existing ScriptSeed service to use GUID mappings
# It ensures consistent GUID assignment across environments during seeding

module Services
  module ScriptSeedWithGuids
    # Extend the existing ScriptSeed module
    extend ScriptSeed
    
    # Override the import_scripts method to use GUID mappings
    def self.import_scripts(scripts_data, seed_context)
      guid_service = Services::GuidMappingService.new
      
      scripts_to_import = scripts_data.map do |script_data|
        script_name = script_data['name']
        
        # Get or create GUID for this script
        script_guid = guid_service.get_or_create_guid('scripts', script_name)
        
        # Find existing script by name
        existing_script = Unit.find_by(name: script_name)
        
        if existing_script
          # Update existing script with GUID
          existing_script.update!(guid: script_guid) if existing_script.guid.blank?
          existing_script
        else
          # Create new script with GUID
          script_attrs = script_data.except('seeding_key')
          script_attrs['guid'] = script_guid
          Unit.new(script_attrs)
        end
      end
      
      # Import scripts
      Unit.import! scripts_to_import, on_duplicate_key_update: get_columns(Unit)
      
      # Return updated scripts
      Unit.where(name: scripts_data.map { |s| s['name'] })
    end
    
    # Override the import_lessons method to use GUID mappings
    def self.import_lessons(lessons_data, seed_context)
      guid_service = Services::GuidMappingService.new
      
      lessons_to_import = lessons_data.map do |lesson_data|
        lesson_key = lesson_data['key']
        
        # Get or create GUID for this lesson
        lesson_guid = guid_service.get_or_create_guid('lessons', lesson_key)
        
        # Find lesson group by GUID
        lesson_group_guid = lesson_data['seeding_key']['lesson_group.guid']
        lesson_group = seed_context.lesson_groups.find { |lg| lg.guid == lesson_group_guid }
        raise 'No lesson group found' if lesson_group.nil?
        
        # Find existing lesson by key
        existing_lesson = Lesson.find_by(key: lesson_key)
        
        if existing_lesson
          # Update existing lesson with GUID
          existing_lesson.update!(guid: lesson_guid) if existing_lesson.guid.blank?
          existing_lesson
        else
          # Create new lesson with GUID
          lesson_attrs = lesson_data.except('seeding_key')
          lesson_attrs['guid'] = lesson_guid
          lesson_attrs['lesson_group_id'] = lesson_group.id
          Lesson.new(lesson_attrs)
        end
      end
      
      # Import lessons
      Lesson.import! lessons_to_import, on_duplicate_key_update: get_columns(Lesson)
      
      # Return updated lessons
      Lesson.where(key: lessons_data.map { |l| l['key'] })
    end
    
    # Override the import_levels method to use GUID mappings
    def self.import_levels(levels_data, seed_context)
      guid_service = Services::GuidMappingService.new
      
      levels_to_import = levels_data.map do |level_data|
        level_key = level_data['key']
        
        # Get or create GUID for this level
        level_guid = guid_service.get_or_create_guid('levels', level_key)
        
        # Find existing level by key
        existing_level = Level.find_by(key: level_key)
        
        if existing_level
          # Update existing level with GUID
          existing_level.update!(guid: level_guid) if existing_level.guid.blank?
          existing_level
        else
          # Create new level with GUID
          level_attrs = level_data.except('seeding_key')
          level_attrs['guid'] = level_guid
          Level.new(level_attrs)
        end
      end
      
      # Import levels
      Level.import! levels_to_import, on_duplicate_key_update: get_columns(Level)
      
      # Return updated levels
      Level.where(key: levels_data.map { |l| l['key'] })
    end
    
    # Override the import_lesson_groups method to use GUID mappings
    def self.import_lesson_groups(lesson_groups_data, seed_context)
      guid_service = Services::GuidMappingService.new
      
      lesson_groups_to_import = lesson_groups_data.map do |lg_data|
        lg_key = lg_data['key']
        
        # Get or create GUID for this lesson group
        lg_guid = guid_service.get_or_create_guid('lesson_groups', lg_key)
        
        # Find script by GUID
        script_guid = lg_data['seeding_key']['script.guid']
        script = seed_context.script
        raise 'No script found' if script.nil?
        
        # Find existing lesson group by key
        existing_lg = LessonGroup.find_by(key: lg_key)
        
        if existing_lg
          # Update existing lesson group with GUID
          existing_lg.update!(guid: lg_guid) if existing_lg.guid.blank?
          existing_lg
        else
          # Create new lesson group with GUID
          lg_attrs = lg_data.except('seeding_key')
          lg_attrs['guid'] = lg_guid
          lg_attrs['script_id'] = script.id
          LessonGroup.new(lg_attrs)
        end
      end
      
      # Import lesson groups
      LessonGroup.import! lesson_groups_to_import, on_duplicate_key_update: get_columns(LessonGroup)
      
      # Return updated lesson groups
      LessonGroup.where(key: lesson_groups_data.map { |lg| lg['key'] })
    end
    
    # Override the import_lesson_activities method to use GUID mappings
    def self.import_lesson_activities(activities_data, seed_context)
      guid_service = Services::GuidMappingService.new
      
      activities_to_import = activities_data.map do |activity_data|
        activity_key = activity_data['key']
        
        # Get or create GUID for this lesson activity
        activity_guid = guid_service.get_or_create_guid('lesson_activities', activity_key)
        
        # Find lesson by GUID
        lesson_guid = activity_data['seeding_key']['lesson.guid']
        lesson = seed_context.lessons.find { |l| l.guid == lesson_guid }
        raise 'No lesson found' if lesson.nil?
        
        # Find existing lesson activity by key
        existing_activity = LessonActivity.find_by(key: activity_key)
        
        if existing_activity
          # Update existing lesson activity with GUID
          existing_activity.update!(guid: activity_guid) if existing_activity.guid.blank?
          existing_activity
        else
          # Create new lesson activity with GUID
          activity_attrs = activity_data.except('seeding_key')
          activity_attrs['guid'] = activity_guid
          activity_attrs['lesson_id'] = lesson.id
          LessonActivity.new(activity_attrs)
        end
      end
      
      # Import lesson activities
      LessonActivity.import! activities_to_import, on_duplicate_key_update: get_columns(LessonActivity)
      
      # Return updated lesson activities
      LessonActivity.where(key: activities_data.map { |a| a['key'] })
    end
    
    # Override the import_activity_sections method to use GUID mappings
    def self.import_activity_sections(sections_data, seed_context)
      guid_service = Services::GuidMappingService.new
      
      sections_to_import = sections_data.map do |section_data|
        section_key = section_data['key']
        
        # Get or create GUID for this activity section
        section_guid = guid_service.get_or_create_guid('activity_sections', section_key)
        
        # Find lesson activity by GUID
        lesson_activity_guid = section_data['seeding_key']['lesson_activity.guid']
        lesson_activity = seed_context.lesson_activities.find { |la| la.guid == lesson_activity_guid }
        raise 'No lesson activity found' if lesson_activity.nil?
        
        # Find existing activity section by key
        existing_section = ActivitySection.find_by(key: section_key)
        
        if existing_section
          # Update existing activity section with GUID
          existing_section.update!(guid: section_guid) if existing_section.guid.blank?
          existing_section
        else
          # Create new activity section with GUID
          section_attrs = section_data.except('seeding_key')
          section_attrs['guid'] = section_guid
          section_attrs['lesson_activity_id'] = lesson_activity.id
          ActivitySection.new(section_attrs)
        end
      end
      
      # Import activity sections
      ActivitySection.import! sections_to_import, on_duplicate_key_update: get_columns(ActivitySection)
      
      # Return updated activity sections
      ActivitySection.where(key: sections_data.map { |s| s['key'] })
    end
    
    # Override the import_script_levels method to use GUID mappings
    def self.import_script_levels(script_levels_data, seed_context)
      guid_service = Services::GuidMappingService.new
      
      script_levels_to_import = script_levels_data.map do |sl_data|
        # Create composite key for script level
        script_name = sl_data['seeding_key']['script.name']
        lesson_key = sl_data['seeding_key']['lesson.key']
        position = sl_data['position']
        composite_key = "#{script_name}:#{lesson_key}:#{position}"
        
        # Get or create GUID for this script level
        sl_guid = guid_service.get_or_create_guid('script_levels', composite_key)
        
        # Find lesson by GUID
        lesson_guid = sl_data['seeding_key']['lesson.guid']
        lesson = seed_context.lessons.find { |l| l.guid == lesson_guid }
        raise 'No lesson found' if lesson.nil?
        
        # Find existing script level by composite key
        existing_sl = ScriptLevel.find_by(
          script: seed_context.script,
          stage: lesson,
          position: position
        )
        
        if existing_sl
          # Update existing script level with GUID
          existing_sl.update!(guid: sl_guid) if existing_sl.guid.blank?
          existing_sl
        else
          # Create new script level with GUID
          sl_attrs = sl_data.except('seeding_key')
          sl_attrs['guid'] = sl_guid
          sl_attrs['script_id'] = seed_context.script.id
          sl_attrs['stage_id'] = lesson.id
          ScriptLevel.new(sl_attrs)
        end
      end
      
      # Import script levels
      ScriptLevel.import! script_levels_to_import, on_duplicate_key_update: get_columns(ScriptLevel)
      
      # Return updated script levels
      ScriptLevel.where(script: seed_context.script)
    end
    
    # Override the import_levels_script_levels method to use GUID mappings
    def self.import_levels_script_levels(levels_script_levels_data, seed_context)
      guid_service = Services::GuidMappingService.new
      
      levels_script_levels_to_import = levels_script_levels_data.map do |lsl_data|
        # Create composite key for levels script level
        level_key = lsl_data['seeding_key']['level.key']
        script_name = lsl_data['seeding_key']['script_level.script.name']
        lesson_key = lsl_data['seeding_key']['script_level.lesson.key']
        position = lsl_data['seeding_key']['script_level.position']
        composite_key = "#{level_key}:#{script_name}:#{lesson_key}:#{position}"
        
        # Get or create GUID for this levels script level
        lsl_guid = guid_service.get_or_create_guid('levels_script_levels', composite_key)
        
        # Find level by GUID
        level_guid = lsl_data['seeding_key']['level.guid']
        level = seed_context.levels.find { |l| l.guid == level_guid }
        raise 'No level found' if level.nil?
        
        # Find script level by GUID
        script_level_guid = lsl_data['seeding_key']['script_level.guid']
        script_level = seed_context.script_levels.find { |sl| sl.guid == script_level_guid }
        raise 'No script level found' if script_level.nil?
        
        # Find existing levels script level
        existing_lsl = LevelsScriptLevel.find_by(
          level: level,
          script_level: script_level
        )
        
        if existing_lsl
          # Update existing levels script level with GUID
          existing_lsl.update!(guid: lsl_guid) if existing_lsl.guid.blank?
          existing_lsl
        else
          # Create new levels script level with GUID
          lsl_attrs = lsl_data.except('seeding_key')
          lsl_attrs['guid'] = lsl_guid
          lsl_attrs['level_id'] = level.id
          lsl_attrs['script_level_id'] = script_level.id
          LevelsScriptLevel.new(lsl_attrs)
        end
      end
      
      # Import levels script levels
      LevelsScriptLevel.import! levels_script_levels_to_import, on_duplicate_key_update: get_columns(LevelsScriptLevel)
      
      # Return updated levels script levels
      LevelsScriptLevel.joins(:script_level).where(script_levels: { script: seed_context.script })
    end
    
    # Add similar methods for other curriculum entities...
    # (courses, course_offerings, course_versions, objectives, etc.)
    
    private
    
    # Helper method to get columns for import
    def self.get_columns(model_class)
      model_class.column_names - ['id', 'created_at', 'updated_at']
    end
  end
end