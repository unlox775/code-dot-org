# frozen_string_literal: true

# Enhanced ScriptSeed with GUID Support
# This module extends the existing ScriptSeed to automatically generate GUIDs
# and create mapping files during the normal seeding process

module Services
  module ScriptSeedWithGuids
    extend ActiveSupport::Concern

    # Override the main seeding method to include GUID generation
    def self.seed_from_hash(data)
      # Call the original seeding method
      result = Services::ScriptSeed.seed_from_hash(data)
      
      # After seeding, generate GUIDs and mapping files
      generate_guids_and_mappings(result)
      
      result
    end

    # Override individual import methods to ensure GUIDs are generated
    def self.import_script(script_data)
      script = Services::ScriptSeed.import_script(script_data)
      
      # Generate GUID if not present
      if script.guid.blank?
        script.update_column(:guid, SecureRandom.uuid)
      end
      
      # Add to mapping file
      add_to_mapping('scripts', script.name, script.guid)
      
      script
    end

    def self.import_lesson_groups(lesson_groups_data, seed_context)
      lesson_groups = Services::ScriptSeed.import_lesson_groups(lesson_groups_data, seed_context)
      
      lesson_groups.each do |lg|
        if lg.guid.blank?
          lg.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('lesson_groups', lg.key, lg.guid)
      end
      
      lesson_groups
    end

    def self.import_lessons(lessons_data, seed_context)
      lessons = Services::ScriptSeed.import_lessons(lessons_data, seed_context)
      
      lessons.each do |lesson|
        if lesson.guid.blank?
          lesson.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('lessons', lesson.key, lesson.guid)
      end
      
      lessons
    end

    def self.import_lesson_activities(activities_data, seed_context)
      activities = Services::ScriptSeed.import_lesson_activities(activities_data, seed_context)
      
      activities.each do |activity|
        if activity.guid.blank?
          activity.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('lesson_activities', activity.key, activity.guid)
      end
      
      activities
    end

    def self.import_activity_sections(sections_data, seed_context)
      sections = Services::ScriptSeed.import_activity_sections(sections_data, seed_context)
      
      sections.each do |section|
        if section.guid.blank?
          section.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('activity_sections', section.key, section.guid)
      end
      
      sections
    end

    def self.import_script_levels(script_levels_data, seed_context)
      script_levels = Services::ScriptSeed.import_script_levels(script_levels_data, seed_context)
      
      script_levels.each do |sl|
        if sl.guid.blank?
          sl.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for script_levels
        composite_key = "#{sl.script.name}:#{sl.lesson.key}:#{sl.position}"
        add_to_mapping('script_levels', composite_key, sl.guid)
      end
      
      script_levels
    end

    def self.import_levels_script_levels(levels_script_levels_data, seed_context)
      levels_script_levels = Services::ScriptSeed.import_levels_script_levels(levels_script_levels_data, seed_context)
      
      levels_script_levels.each do |lsl|
        if lsl.guid.blank?
          lsl.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for levels_script_levels
        composite_key = "#{lsl.level.key}:#{lsl.script_level.script.name}:#{lsl.script_level.lesson.key}:#{lsl.script_level.position}"
        add_to_mapping('levels_script_levels', composite_key, lsl.guid)
      end
      
      levels_script_levels
    end

    def self.import_resources(resources_data, seed_context)
      resources = Services::ScriptSeed.import_resources(resources_data, seed_context)
      
      resources.each do |resource|
        if resource.guid.blank?
          resource.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('resources', resource.key, resource.guid)
      end
      
      resources
    end

    def self.import_lessons_resources(lessons_resources_data, seed_context)
      lessons_resources = Services::ScriptSeed.import_lessons_resources(lessons_resources_data, seed_context)
      
      lessons_resources.each do |lr|
        if lr.guid.blank?
          lr.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for lessons_resources
        composite_key = "#{lr.lesson.key}:#{lr.resource.key}"
        add_to_mapping('lesson_resources', composite_key, lr.guid)
      end
      
      lessons_resources
    end

    def self.import_scripts_resources(scripts_resources_data, seed_context)
      scripts_resources = Services::ScriptSeed.import_scripts_resources(scripts_resources_data, seed_context)
      
      scripts_resources.each do |sr|
        if sr.guid.blank?
          sr.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for scripts_resources
        composite_key = "#{sr.script.name}:#{sr.resource.key}"
        add_to_mapping('script_resources', composite_key, sr.guid)
      end
      
      scripts_resources
    end

    def self.import_scripts_student_resources(scripts_student_resources_data, seed_context)
      scripts_student_resources = Services::ScriptSeed.import_scripts_student_resources(scripts_student_resources_data, seed_context)
      
      scripts_student_resources.each do |ssr|
        if ssr.guid.blank?
          ssr.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for scripts_student_resources
        composite_key = "#{ssr.script.name}:#{ssr.resource.key}"
        add_to_mapping('script_student_resources', composite_key, ssr.guid)
      end
      
      scripts_student_resources
    end

    def self.import_vocabularies(vocabularies_data, seed_context)
      vocabularies = Services::ScriptSeed.import_vocabularies(vocabularies_data, seed_context)
      
      vocabularies.each do |vocab|
        if vocab.guid.blank?
          vocab.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('vocabularies', vocab.key, vocab.guid)
      end
      
      vocabularies
    end

    def self.import_lessons_vocabularies(lessons_vocabularies_data, seed_context)
      lessons_vocabularies = Services::ScriptSeed.import_lessons_vocabularies(lessons_vocabularies_data, seed_context)
      
      lessons_vocabularies.each do |lv|
        if lv.guid.blank?
          lv.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for lessons_vocabularies
        composite_key = "#{lv.lesson.key}:#{lv.vocabulary.key}"
        add_to_mapping('lesson_vocabularies', composite_key, lv.guid)
      end
      
      lessons_vocabularies
    end

    def self.import_lessons_programming_expressions(lessons_programming_expressions_data, seed_context)
      lessons_programming_expressions = Services::ScriptSeed.import_lessons_programming_expressions(lessons_programming_expressions_data, seed_context)
      
      lessons_programming_expressions.each do |lpe|
        if lpe.guid.blank?
          lpe.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for lessons_programming_expressions
        composite_key = "#{lpe.lesson.key}:#{lpe.programming_expression.key}"
        add_to_mapping('lesson_programming_expressions', composite_key, lpe.guid)
      end
      
      lessons_programming_expressions
    end

    def self.import_objectives(objectives_data, seed_context)
      objectives = Services::ScriptSeed.import_objectives(objectives_data, seed_context)
      
      objectives.each do |objective|
        if objective.guid.blank?
          objective.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('objectives', objective.key, objective.guid)
      end
      
      objectives
    end

    def self.import_lessons_standards(lessons_standards_data, seed_context)
      lessons_standards = Services::ScriptSeed.import_lessons_standards(lessons_standards_data, seed_context)
      
      lessons_standards.each do |ls|
        if ls.guid.blank?
          ls.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for lessons_standards
        composite_key = "#{ls.lesson.key}:#{ls.standard.shortcode}"
        add_to_mapping('lesson_standards', composite_key, ls.guid)
      end
      
      lessons_standards
    end

    def self.import_lessons_opportunity_standards(lessons_opportunity_standards_data, seed_context)
      lessons_opportunity_standards = Services::ScriptSeed.import_lessons_opportunity_standards(lessons_opportunity_standards_data, seed_context)
      
      lessons_opportunity_standards.each do |los|
        if los.guid.blank?
          los.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for lessons_opportunity_standards
        composite_key = "#{los.lesson.key}:#{los.standard.shortcode}"
        add_to_mapping('lesson_opportunity_standards', composite_key, los.guid)
      end
      
      lessons_opportunity_standards
    end

    def self.import_rubrics(rubrics_data, seed_context)
      rubrics = Services::ScriptSeed.import_rubrics(rubrics_data, seed_context)
      
      rubrics.each do |rubric|
        if rubric.guid.blank?
          rubric.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('rubrics', rubric.key, rubric.guid)
      end
      
      rubrics
    end

    def self.import_learning_goals(learning_goals_data, seed_context)
      learning_goals = Services::ScriptSeed.import_learning_goals(learning_goals_data, seed_context)
      
      learning_goals.each do |lg|
        if lg.guid.blank?
          lg.update_column(:guid, SecureRandom.uuid)
        end
        add_to_mapping('learning_goals', lg.key, lg.guid)
      end
      
      learning_goals
    end

    def self.import_learning_goals_evidence_levels(learning_goal_evidence_levels_data, seed_context)
      learning_goal_evidence_levels = Services::ScriptSeed.import_learning_goals_evidence_levels(learning_goal_evidence_levels_data, seed_context)
      
      learning_goal_evidence_levels.each do |lgel|
        if lgel.guid.blank?
          lgel.update_column(:guid, SecureRandom.uuid)
        end
        
        # Create composite key for learning_goal_evidence_levels
        composite_key = "#{lgel.learning_goal.key}:#{lgel.evidence_level}"
        add_to_mapping('learning_goal_evidence_levels', composite_key, lgel.guid)
      end
      
      learning_goal_evidence_levels
    end

    private

    # Add a mapping to the appropriate JSON file
    def self.add_to_mapping(table_name, identifier, guid)
      mappings_dir = Rails.root.join('config', 'curriculum_guid_mappings')
      FileUtils.mkdir_p(mappings_dir)
      
      mapping_file = mappings_dir.join("#{table_name}.json")
      
      # Load existing mappings or create new hash
      mappings = if File.exist?(mapping_file)
        JSON.parse(File.read(mapping_file))
      else
        {}
      end
      
      # Add or update the mapping
      mappings[identifier] = guid
      
      # Write back to file
      File.write(mapping_file, JSON.pretty_generate(mappings))
    end

    # Generate GUIDs and mappings for all curriculum tables
    def self.generate_guids_and_mappings(seed_context)
      puts "🔧 Generating GUIDs and mappings for seeded curriculum..."
      
      # Process all curriculum tables
      process_curriculum_table('scripts', Unit.all, :name)
      process_curriculum_table('lessons', Lesson.all, :key)
      process_curriculum_table('levels', Level.all, :key)
      process_curriculum_table('lesson_groups', LessonGroup.all, :key)
      process_curriculum_table('lesson_activities', LessonActivity.all, :key)
      process_curriculum_table('activity_sections', ActivitySection.all, :key)
      process_curriculum_table('courses', Course.all, :key)
      process_curriculum_table('course_offerings', CourseOffering.all, :key)
      process_curriculum_table('course_versions', CourseVersion.all, :key)
      process_curriculum_table('objectives', Objective.all, :key)
      process_curriculum_table('programming_expressions', ProgrammingExpression.all, :key)
      process_curriculum_table('rubrics', Rubric.all, :key)
      process_curriculum_table('learning_goals', LearningGoal.all, :key)
      process_curriculum_table('unit_groups', UnitGroup.all, :key)
      
      # Process join tables with composite keys
      process_script_levels
      process_levels_script_levels
      process_course_scripts
      process_unit_group_resources
      process_unit_group_student_resources
      process_script_resources
      process_script_student_resources
      process_lesson_resources
      process_lesson_standards
      process_lesson_vocabularies
      process_lesson_programming_expressions
      process_learning_goal_evidence_levels
      process_lesson_opportunity_standards
      
      puts "✅ GUID generation and mapping complete!"
    end

    def self.process_curriculum_table(table_name, records, identifier_method)
      mappings = {}
      
      records.each do |record|
        identifier = record.send(identifier_method)
        next if identifier.blank?
        
        if record.guid.blank?
          record.update_column(:guid, SecureRandom.uuid)
        end
        
        mappings[identifier] = record.guid
      end
      
      write_mapping_file(table_name, mappings) if mappings.any?
    end

    def self.process_script_levels
      mappings = {}
      
      ScriptLevel.includes(:script, :lesson).each do |sl|
        if sl.guid.blank?
          sl.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{sl.script.name}:#{sl.lesson.key}:#{sl.position}"
        mappings[composite_key] = sl.guid
      end
      
      write_mapping_file('script_levels', mappings) if mappings.any?
    end

    def self.process_levels_script_levels
      mappings = {}
      
      LevelsScriptLevel.includes(:level, :script_level, script_level: [:script, :lesson]).each do |lsl|
        if lsl.guid.blank?
          lsl.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{lsl.level.key}:#{lsl.script_level.script.name}:#{lsl.script_level.lesson.key}:#{lsl.script_level.position}"
        mappings[composite_key] = lsl.guid
      end
      
      write_mapping_file('levels_script_levels', mappings) if mappings.any?
    end

    def self.process_course_scripts
      mappings = {}
      
      CourseScript.includes(:course, :script).each do |cs|
        if cs.guid.blank?
          cs.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{cs.course.key}:#{cs.script.name}"
        mappings[composite_key] = cs.guid
      end
      
      write_mapping_file('course_scripts', mappings) if mappings.any?
    end

    def self.process_unit_group_resources
      mappings = {}
      
      UnitGroupsResource.includes(:unit_group, :resource).each do |ugr|
        if ugr.guid.blank?
          ugr.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{ugr.unit_group.key}:#{ugr.resource.key}"
        mappings[composite_key] = ugr.guid
      end
      
      write_mapping_file('unit_group_resources', mappings) if mappings.any?
    end

    def self.process_unit_group_student_resources
      mappings = {}
      
      UnitGroupsStudentResource.includes(:unit_group, :resource).each do |ugsr|
        if ugsr.guid.blank?
          ugsr.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{ugsr.unit_group.key}:#{ugsr.resource.key}"
        mappings[composite_key] = ugsr.guid
      end
      
      write_mapping_file('unit_group_student_resources', mappings) if mappings.any?
    end

    def self.process_script_resources
      mappings = {}
      
      ScriptsResource.includes(:script, :resource).each do |sr|
        if sr.guid.blank?
          sr.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{sr.script.name}:#{sr.resource.key}"
        mappings[composite_key] = sr.guid
      end
      
      write_mapping_file('script_resources', mappings) if mappings.any?
    end

    def self.process_script_student_resources
      mappings = {}
      
      ScriptsStudentResource.includes(:script, :resource).each do |ssr|
        if ssr.guid.blank?
          ssr.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{ssr.script.name}:#{ssr.resource.key}"
        mappings[composite_key] = ssr.guid
      end
      
      write_mapping_file('script_student_resources', mappings) if mappings.any?
    end

    def self.process_lesson_resources
      mappings = {}
      
      LessonsResource.includes(:lesson, :resource).each do |lr|
        if lr.guid.blank?
          lr.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{lr.lesson.key}:#{lr.resource.key}"
        mappings[composite_key] = lr.guid
      end
      
      write_mapping_file('lesson_resources', mappings) if mappings.any?
    end

    def self.process_lesson_standards
      mappings = {}
      
      LessonsStandard.includes(:lesson, :standard).each do |ls|
        if ls.guid.blank?
          ls.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{ls.lesson.key}:#{ls.standard.shortcode}"
        mappings[composite_key] = ls.guid
      end
      
      write_mapping_file('lesson_standards', mappings) if mappings.any?
    end

    def self.process_lesson_vocabularies
      mappings = {}
      
      LessonsVocabulary.includes(:lesson, :vocabulary).each do |lv|
        if lv.guid.blank?
          lv.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{lv.lesson.key}:#{lv.vocabulary.key}"
        mappings[composite_key] = lv.guid
      end
      
      write_mapping_file('lesson_vocabularies', mappings) if mappings.any?
    end

    def self.process_lesson_programming_expressions
      mappings = {}
      
      LessonsProgrammingExpression.includes(:lesson, :programming_expression).each do |lpe|
        if lpe.guid.blank?
          lpe.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{lpe.lesson.key}:#{lpe.programming_expression.key}"
        mappings[composite_key] = lpe.guid
      end
      
      write_mapping_file('lesson_programming_expressions', mappings) if mappings.any?
    end

    def self.process_learning_goal_evidence_levels
      mappings = {}
      
      LearningGoalEvidenceLevel.includes(:learning_goal).each do |lgel|
        if lgel.guid.blank?
          lgel.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{lgel.learning_goal.key}:#{lgel.evidence_level}"
        mappings[composite_key] = lgel.guid
      end
      
      write_mapping_file('learning_goal_evidence_levels', mappings) if mappings.any?
    end

    def self.process_lesson_opportunity_standards
      mappings = {}
      
      LessonsOpportunityStandard.includes(:lesson, :standard).each do |los|
        if los.guid.blank?
          los.update_column(:guid, SecureRandom.uuid)
        end
        
        composite_key = "#{los.lesson.key}:#{los.standard.shortcode}"
        mappings[composite_key] = los.guid
      end
      
      write_mapping_file('lesson_opportunity_standards', mappings) if mappings.any?
    end

    def self.write_mapping_file(table_name, mappings)
      mappings_dir = Rails.root.join('config', 'curriculum_guid_mappings')
      FileUtils.mkdir_p(mappings_dir)
      
      mapping_file = mappings_dir.join("#{table_name}.json")
      File.write(mapping_file, JSON.pretty_generate(mappings))
      
      puts "  ✅ Created #{table_name}.json with #{mappings.length} mappings"
    end
  end
end