# frozen_string_literal: true

# Curriculum GUID Import Task
# This task imports curriculum data with GUIDs using mapping files for consistency
# Run with: bundle exec rake curriculum:import_guids[path_to_export_directory]

namespace :curriculum do
  desc "Import curriculum data with GUIDs from export directory"
  task :import_guids, [:export_path] => :environment do |t, args|
    export_path = args[:export_path] || find_latest_export
    
    if export_path.nil?
      puts "❌ No export directory specified and no recent export found"
      puts "Usage: bundle exec rake curriculum:import_guids[path_to_export_directory]"
      exit 1
    end
    
    puts "🚀 Starting Curriculum GUID Import"
    puts "=" * 60
    puts "📁 Import directory: #{export_path}"
    puts ""
    
    importer = CurriculumGuidImporter.new(export_path)
    importer.import_all
    
    puts ""
    puts "✅ Curriculum GUID import complete!"
  end
  
  private
  
  def find_latest_export
    export_dir = Rails.root.join('tmp', 'curriculum_guid_export')
    return nil unless Dir.exist?(export_dir)
    
    latest = Dir.glob(File.join(export_dir, '*')).max_by { |f| File.mtime(f) }
    latest
  end
end

class CurriculumGuidImporter
  def initialize(export_path)
    @export_path = Pathname.new(export_path)
    @mapping_cache = {}
    @import_stats = {
      created: 0,
      updated: 0,
      errors: 0,
      skipped: 0
    }
  end
  
  def import_all
    puts "📊 Importing curriculum data with GUIDs..."
    puts ""
    
    # Load mapping files first
    load_mapping_files
    
    # Import all curriculum tables
    import_scripts
    import_lessons
    import_levels
    import_lesson_groups
    import_lesson_activities
    import_activity_sections
    import_courses
    import_course_offerings
    import_course_versions
    import_objectives
    import_programming_expressions
    import_rubrics
    import_learning_goals
    import_unit_groups
    import_script_levels
    import_levels_script_levels
    import_course_scripts
    import_unit_group_resources
    import_unit_group_student_resources
    import_script_resources
    import_script_student_resources
    import_lesson_resources
    import_lesson_standards
    import_lesson_vocabularies
    import_lesson_programming_expressions
    import_learning_goal_evidence_levels
    import_lesson_opportunity_standards
    
    # Print import statistics
    print_import_stats
  end
  
  private
  
  def load_mapping_files
    puts "📋 Loading GUID mapping files..."
    
    mapping_files = [
      'scripts.json', 'lessons.json', 'levels.json', 'lesson_groups.json',
      'lesson_activities.json', 'activity_sections.json', 'courses.json',
      'course_offerings.json', 'course_versions.json', 'objectives.json',
      'programming_expressions.json', 'rubrics.json', 'learning_goals.json',
      'unit_groups.json', 'script_levels.json', 'levels_script_levels.json',
      'course_scripts.json', 'unit_group_resources.json', 'unit_group_student_resources.json',
      'script_resources.json', 'script_student_resources.json', 'lesson_resources.json',
      'lesson_standards.json', 'lesson_vocabularies.json', 'lesson_programming_expressions.json',
      'learning_goal_evidence_levels.json', 'lesson_opportunity_standards.json'
    ]
    
    mapping_files.each do |filename|
      table_name = filename.gsub('.json', '')
      file_path = @export_path.join(filename)
      
      if File.exist?(file_path)
        data = JSON.parse(File.read(file_path))
        @mapping_cache[table_name] = data.index_by { |item| item['key'] }
        puts "  ✅ Loaded #{data.length} #{table_name} mappings"
      else
        puts "  ⚠️  #{filename} not found, skipping"
      end
    end
    
    puts ""
  end
  
  def import_scripts
    puts "📝 Importing scripts..."
    scripts_data = load_json_file('scripts.json')
    return unless scripts_data
    
    scripts_data.each do |script_data|
      begin
        existing_script = Unit.find_by(guid: script_data['guid'])
        
        if existing_script
          # Update existing script
          existing_script.update!(
            name: script_data['name'],
            properties: script_data['properties'],
            published_state: script_data['published_state'],
            instruction_type: script_data['instruction_type'],
            instructor_audience: script_data['instructor_audience'],
            participant_audience: script_data['participant_audience'],
            hide_within_course: script_data['hide_within_course']
          )
          @import_stats[:updated] += 1
        else
          # Create new script
          Unit.create!(
            guid: script_data['guid'],
            name: script_data['name'],
            properties: script_data['properties'],
            published_state: script_data['published_state'],
            instruction_type: script_data['instruction_type'],
            instructor_audience: script_data['instructor_audience'],
            participant_audience: script_data['participant_audience'],
            hide_within_course: script_data['hide_within_course']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing script #{script_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{scripts_data.length} scripts"
  end
  
  def import_lessons
    puts "📝 Importing lessons..."
    lessons_data = load_json_file('lessons.json')
    return unless lessons_data
    
    lessons_data.each do |lesson_data|
      begin
        existing_lesson = Lesson.find_by(guid: lesson_data['guid'])
        
        # Find script by GUID
        script = Unit.find_by(guid: lesson_data['script_guid'])
        next unless script
        
        # Find lesson group by GUID
        lesson_group = script.lesson_groups.find_by(guid: lesson_data['lesson_group_guid']) if lesson_data['lesson_group_guid']
        
        if existing_lesson
          # Update existing lesson
          existing_lesson.update!(
            key: lesson_data['key'],
            name: lesson_data['name'],
            script_id: script.id,
            lesson_group_id: lesson_group&.id,
            absolute_position: lesson_data['absolute_position'],
            relative_position: lesson_data['relative_position'],
            properties: lesson_data['properties'],
            lockable: lesson_data['lockable'],
            has_lesson_plan: lesson_data['has_lesson_plan']
          )
          @import_stats[:updated] += 1
        else
          # Create new lesson
          Lesson.create!(
            guid: lesson_data['guid'],
            key: lesson_data['key'],
            name: lesson_data['name'],
            script_id: script.id,
            lesson_group_id: lesson_group&.id,
            absolute_position: lesson_data['absolute_position'],
            relative_position: lesson_data['relative_position'],
            properties: lesson_data['properties'],
            lockable: lesson_data['lockable'],
            has_lesson_plan: lesson_data['has_lesson_plan']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing lesson #{lesson_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{lessons_data.length} lessons"
  end
  
  def import_levels
    puts "📝 Importing levels..."
    levels_data = load_json_file('levels.json')
    return unless levels_data
    
    levels_data.each do |level_data|
      begin
        existing_level = Level.find_by(guid: level_data['guid'])
        
        if existing_level
          # Update existing level
          existing_level.update!(
            key: level_data['key'],
            name: level_data['name'],
            properties: level_data['properties'],
            type: level_data['type'],
            level_num: level_data['level_num'],
            user_id: level_data['user_id'],
            game_id: level_data['game_id'],
            ideal_level_source_id: level_data['ideal_level_source_id'],
            solution_level_source_id: level_data['solution_level_source_id']
          )
          @import_stats[:updated] += 1
        else
          # Create new level
          Level.create!(
            guid: level_data['guid'],
            key: level_data['key'],
            name: level_data['name'],
            properties: level_data['properties'],
            type: level_data['type'],
            level_num: level_data['level_num'],
            user_id: level_data['user_id'],
            game_id: level_data['game_id'],
            ideal_level_source_id: level_data['ideal_level_source_id'],
            solution_level_source_id: level_data['solution_level_source_id']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing level #{level_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{levels_data.length} levels"
  end
  
  def import_lesson_groups
    puts "📝 Importing lesson groups..."
    lesson_groups_data = load_json_file('lesson_groups.json')
    return unless lesson_groups_data
    
    lesson_groups_data.each do |lg_data|
      begin
        existing_lg = LessonGroup.find_by(guid: lg_data['guid'])
        
        # Find script by GUID
        script = Unit.find_by(guid: lg_data['script_guid'])
        next unless script
        
        if existing_lg
          # Update existing lesson group
          existing_lg.update!(
            key: lg_data['key'],
            script_id: script.id,
            user_facing: lg_data['user_facing'],
            position: lg_data['position'],
            properties: lg_data['properties']
          )
          @import_stats[:updated] += 1
        else
          # Create new lesson group
          LessonGroup.create!(
            guid: lg_data['guid'],
            key: lg_data['key'],
            script_id: script.id,
            user_facing: lg_data['user_facing'],
            position: lg_data['position'],
            properties: lg_data['properties']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing lesson group #{lg_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{lesson_groups_data.length} lesson groups"
  end
  
  def import_lesson_activities
    puts "📝 Importing lesson activities..."
    activities_data = load_json_file('lesson_activities.json')
    return unless activities_data
    
    activities_data.each do |activity_data|
      begin
        existing_activity = LessonActivity.find_by(guid: activity_data['guid'])
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: activity_data['lesson_guid'])
        next unless lesson
        
        if existing_activity
          # Update existing activity
          existing_activity.update!(
            key: activity_data['key'],
            lesson_id: lesson.id,
            position: activity_data['position'],
            properties: activity_data['properties']
          )
          @import_stats[:updated] += 1
        else
          # Create new activity
          LessonActivity.create!(
            guid: activity_data['guid'],
            key: activity_data['key'],
            lesson_id: lesson.id,
            position: activity_data['position'],
            properties: activity_data['properties']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing lesson activity #{activity_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{activities_data.length} lesson activities"
  end
  
  def import_activity_sections
    puts "📝 Importing activity sections..."
    sections_data = load_json_file('activity_sections.json')
    return unless sections_data
    
    sections_data.each do |section_data|
      begin
        existing_section = ActivitySection.find_by(guid: section_data['guid'])
        
        # Find lesson activity by GUID
        lesson_activity = LessonActivity.find_by(guid: section_data['lesson_activity_guid'])
        next unless lesson_activity
        
        if existing_section
          # Update existing section
          existing_section.update!(
            key: section_data['key'],
            lesson_activity_id: lesson_activity.id,
            position: section_data['position'],
            properties: section_data['properties']
          )
          @import_stats[:updated] += 1
        else
          # Create new section
          ActivitySection.create!(
            guid: section_data['guid'],
            key: section_data['key'],
            lesson_activity_id: lesson_activity.id,
            position: section_data['position'],
            properties: section_data['properties']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing activity section #{section_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{sections_data.length} activity sections"
  end
  
  def import_courses
    puts "📝 Importing courses..."
    courses_data = load_json_file('courses.json')
    return unless courses_data
    
    courses_data.each do |course_data|
      begin
        existing_course = Course.find_by(guid: course_data['guid'])
        
        if existing_course
          # Update existing course
          existing_course.update!(
            key: course_data['key'],
            name: course_data['name'],
            properties: course_data['properties']
          )
          @import_stats[:updated] += 1
        else
          # Create new course
          Course.create!(
            guid: course_data['guid'],
            key: course_data['key'],
            name: course_data['name'],
            properties: course_data['properties']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing course #{course_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{courses_data.length} courses"
  end
  
  def import_course_offerings
    puts "📝 Importing course offerings..."
    offerings_data = load_json_file('course_offerings.json')
    return unless offerings_data
    
    offerings_data.each do |offering_data|
      begin
        existing_offering = CourseOffering.find_by(guid: offering_data['guid'])
        
        if existing_offering
          # Update existing offering
          existing_offering.update!(
            key: offering_data['key'],
            display_name: offering_data['display_name'],
            is_featured: offering_data['is_featured'],
            assignable: offering_data['assignable'],
            curriculum_type: offering_data['curriculum_type'],
            marketing_initiative: offering_data['marketing_initiative'],
            grade_levels: offering_data['grade_levels'],
            header: offering_data['header'],
            image: offering_data['image'],
            cs_topic: offering_data['cs_topic'],
            school_subject: offering_data['school_subject'],
            device_compatibility: offering_data['device_compatibility'],
            description: offering_data['description'],
            professional_learning_program: offering_data['professional_learning_program'],
            video: offering_data['video'],
            published_date: offering_data['published_date'],
            ai_teaching_assistant_available: offering_data['ai_teaching_assistant_available'],
            facilitator_course_permissions: offering_data['facilitator_course_permissions']
          )
          @import_stats[:updated] += 1
        else
          # Create new offering
          CourseOffering.create!(
            guid: offering_data['guid'],
            key: offering_data['key'],
            display_name: offering_data['display_name'],
            is_featured: offering_data['is_featured'],
            assignable: offering_data['assignable'],
            curriculum_type: offering_data['curriculum_type'],
            marketing_initiative: offering_data['marketing_initiative'],
            grade_levels: offering_data['grade_levels'],
            header: offering_data['header'],
            image: offering_data['image'],
            cs_topic: offering_data['cs_topic'],
            school_subject: offering_data['school_subject'],
            device_compatibility: offering_data['device_compatibility'],
            description: offering_data['description'],
            professional_learning_program: offering_data['professional_learning_program'],
            video: offering_data['video'],
            published_date: offering_data['published_date'],
            ai_teaching_assistant_available: offering_data['ai_teaching_assistant_available'],
            facilitator_course_permissions: offering_data['facilitator_course_permissions']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing course offering #{offering_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{offerings_data.length} course offerings"
  end
  
  def import_course_versions
    puts "📝 Importing course versions..."
    versions_data = load_json_file('course_versions.json')
    return unless versions_data
    
    versions_data.each do |version_data|
      begin
        existing_version = CourseVersion.find_by(guid: version_data['guid'])
        
        # Find course offering by GUID
        course_offering = CourseOffering.find_by(guid: version_data['course_offering_guid'])
        next unless course_offering
        
        if existing_version
          # Update existing version
          existing_version.update!(
            key: version_data['key'],
            display_name: version_data['display_name'],
            content_root_id: version_data['content_root_id'],
            course_offering_id: course_offering.id,
            properties: version_data['properties'],
            published_state: version_data['published_state']
          )
          @import_stats[:updated] += 1
        else
          # Create new version
          CourseVersion.create!(
            guid: version_data['guid'],
            key: version_data['key'],
            display_name: version_data['display_name'],
            content_root_id: version_data['content_root_id'],
            course_offering_id: course_offering.id,
            properties: version_data['properties'],
            published_state: version_data['published_state']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing course version #{version_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{versions_data.length} course versions"
  end
  
  def import_objectives
    puts "📝 Importing objectives..."
    objectives_data = load_json_file('objectives.json')
    return unless objectives_data
    
    objectives_data.each do |objective_data|
      begin
        existing_objective = Objective.find_by(guid: objective_data['guid'])
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: objective_data['lesson_guid'])
        next unless lesson
        
        if existing_objective
          # Update existing objective
          existing_objective.update!(
            key: objective_data['key'],
            lesson_id: lesson.id,
            description: objective_data['description']
          )
          @import_stats[:updated] += 1
        else
          # Create new objective
          Objective.create!(
            guid: objective_data['guid'],
            key: objective_data['key'],
            lesson_id: lesson.id,
            description: objective_data['description']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing objective #{objective_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{objectives_data.length} objectives"
  end
  
  def import_programming_expressions
    puts "📝 Importing programming expressions..."
    expressions_data = load_json_file('programming_expressions.json')
    return unless expressions_data
    
    expressions_data.each do |expr_data|
      begin
        existing_expr = ProgrammingExpression.find_by(guid: expr_data['guid'])
        
        # Find programming environment by name
        programming_environment = ProgrammingEnvironment.find_by(name: expr_data['programming_environment_name'])
        next unless programming_environment
        
        if existing_expr
          # Update existing expression
          existing_expr.update!(
            key: expr_data['key'],
            programming_environment_id: programming_environment.id,
            name: expr_data['name'],
            category: expr_data['category'],
            color: expr_data['color'],
            properties: expr_data['properties']
          )
          @import_stats[:updated] += 1
        else
          # Create new expression
          ProgrammingExpression.create!(
            guid: expr_data['guid'],
            key: expr_data['key'],
            programming_environment_id: programming_environment.id,
            name: expr_data['name'],
            category: expr_data['category'],
            color: expr_data['color'],
            properties: expr_data['properties']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing programming expression #{expr_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{expressions_data.length} programming expressions"
  end
  
  def import_rubrics
    puts "📝 Importing rubrics..."
    rubrics_data = load_json_file('rubrics.json')
    return unless rubrics_data
    
    rubrics_data.each do |rubric_data|
      begin
        existing_rubric = Rubric.find_by(guid: rubric_data['guid'])
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: rubric_data['lesson_guid'])
        next unless lesson
        
        # Find level by GUID if provided
        level = Level.find_by(guid: rubric_data['level_guid']) if rubric_data['level_guid']
        
        if existing_rubric
          # Update existing rubric
          existing_rubric.update!(
            key: rubric_data['key'],
            lesson_id: lesson.id,
            level_id: level&.id,
            properties: rubric_data['properties']
          )
          @import_stats[:updated] += 1
        else
          # Create new rubric
          Rubric.create!(
            guid: rubric_data['guid'],
            key: rubric_data['key'],
            lesson_id: lesson.id,
            level_id: level&.id,
            properties: rubric_data['properties']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing rubric #{rubric_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{rubrics_data.length} rubrics"
  end
  
  def import_learning_goals
    puts "📝 Importing learning goals..."
    goals_data = load_json_file('learning_goals.json')
    return unless goals_data
    
    goals_data.each do |goal_data|
      begin
        existing_goal = LearningGoal.find_by(guid: goal_data['guid'])
        
        # Find rubric by GUID
        rubric = Rubric.find_by(guid: goal_data['rubric_guid'])
        next unless rubric
        
        if existing_goal
          # Update existing goal
          existing_goal.update!(
            key: goal_data['key'],
            rubric_id: rubric.id,
            name: goal_data['name'],
            description: goal_data['description'],
            properties: goal_data['properties']
          )
          @import_stats[:updated] += 1
        else
          # Create new goal
          LearningGoal.create!(
            guid: goal_data['guid'],
            key: goal_data['key'],
            rubric_id: rubric.id,
            name: goal_data['name'],
            description: goal_data['description'],
            properties: goal_data['properties']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing learning goal #{goal_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{goals_data.length} learning goals"
  end
  
  def import_unit_groups
    puts "📝 Importing unit groups..."
    unit_groups_data = load_json_file('unit_groups.json')
    return unless unit_groups_data
    
    unit_groups_data.each do |ug_data|
      begin
        existing_ug = UnitGroup.find_by(guid: ug_data['guid'])
        
        if existing_ug
          # Update existing unit group
          existing_ug.update!(
            key: ug_data['key'],
            name: ug_data['name'],
            properties: ug_data['properties']
          )
          @import_stats[:updated] += 1
        else
          # Create new unit group
          UnitGroup.create!(
            guid: ug_data['guid'],
            key: ug_data['key'],
            name: ug_data['name'],
            properties: ug_data['properties']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing unit group #{ug_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{unit_groups_data.length} unit groups"
  end
  
  def import_script_levels
    puts "📝 Importing script levels..."
    script_levels_data = load_json_file('script_levels.json')
    return unless script_levels_data
    
    script_levels_data.each do |sl_data|
      begin
        existing_sl = ScriptLevel.find_by(guid: sl_data['guid'])
        
        # Find script by GUID
        script = Unit.find_by(guid: sl_data['script_guid'])
        next unless script
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: sl_data['lesson_guid'])
        next unless lesson
        
        if existing_sl
          # Update existing script level
          existing_sl.update!(
            script_id: script.id,
            stage_id: lesson.id,
            position: sl_data['position'],
            properties: sl_data['properties'],
            level_keys: sl_data['level_keys']
          )
          @import_stats[:updated] += 1
        else
          # Create new script level
          ScriptLevel.create!(
            guid: sl_data['guid'],
            script_id: script.id,
            stage_id: lesson.id,
            position: sl_data['position'],
            properties: sl_data['properties'],
            level_keys: sl_data['level_keys']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing script level #{sl_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{script_levels_data.length} script levels"
  end
  
  def import_levels_script_levels
    puts "📝 Importing levels script levels..."
    lsls_data = load_json_file('levels_script_levels.json')
    return unless lsls_data
    
    lsls_data.each do |lsl_data|
      begin
        existing_lsl = LevelsScriptLevel.find_by(guid: lsl_data['guid'])
        
        # Find level by GUID
        level = Level.find_by(guid: lsl_data['level_guid'])
        next unless level
        
        # Find script level by GUID
        script_level = ScriptLevel.find_by(guid: lsl_data['script_level_guid'])
        next unless script_level
        
        if existing_lsl
          # Update existing levels script level
          existing_lsl.update!(
            level_id: level.id,
            script_level_id: script_level.id
          )
          @import_stats[:updated] += 1
        else
          # Create new levels script level
          LevelsScriptLevel.create!(
            guid: lsl_data['guid'],
            level_id: level.id,
            script_level_id: script_level.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing levels script level #{lsl_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{lsls_data.length} levels script levels"
  end
  
  def import_course_scripts
    puts "📝 Importing course scripts..."
    course_scripts_data = load_json_file('course_scripts.json')
    return unless course_scripts_data
    
    course_scripts_data.each do |cs_data|
      begin
        existing_cs = CourseScript.find_by(guid: cs_data['guid'])
        
        # Find course by GUID
        course = Course.find_by(guid: cs_data['course_guid'])
        next unless course
        
        # Find script by GUID
        script = Unit.find_by(guid: cs_data['script_guid'])
        next unless script
        
        if existing_cs
          # Update existing course script
          existing_cs.update!(
            course_id: course.id,
            script_id: script.id,
            position: cs_data['position']
          )
          @import_stats[:updated] += 1
        else
          # Create new course script
          CourseScript.create!(
            guid: cs_data['guid'],
            course_id: course.id,
            script_id: script.id,
            position: cs_data['position']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing course script #{cs_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{course_scripts_data.length} course scripts"
  end
  
  def import_unit_group_resources
    puts "📝 Importing unit group resources..."
    resources_data = load_json_file('unit_group_resources.json')
    return unless resources_data
    
    resources_data.each do |resource_data|
      begin
        existing_resource = UnitGroupsResource.find_by(guid: resource_data['guid'])
        
        # Find unit group by GUID
        unit_group = UnitGroup.find_by(guid: resource_data['unit_group_guid'])
        next unless unit_group
        
        # Find resource by GUID
        resource = Resource.find_by(guid: resource_data['resource_guid'])
        next unless resource
        
        if existing_resource
          # Update existing resource
          existing_resource.update!(
            unit_group_id: unit_group.id,
            resource_id: resource.id
          )
          @import_stats[:updated] += 1
        else
          # Create new resource
          UnitGroupsResource.create!(
            guid: resource_data['guid'],
            unit_group_id: unit_group.id,
            resource_id: resource.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing unit group resource #{resource_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{resources_data.length} unit group resources"
  end
  
  def import_unit_group_student_resources
    puts "📝 Importing unit group student resources..."
    resources_data = load_json_file('unit_group_student_resources.json')
    return unless resources_data
    
    resources_data.each do |resource_data|
      begin
        existing_resource = UnitGroupsStudentResource.find_by(guid: resource_data['guid'])
        
        # Find unit group by GUID
        unit_group = UnitGroup.find_by(guid: resource_data['unit_group_guid'])
        next unless unit_group
        
        # Find resource by GUID
        resource = Resource.find_by(guid: resource_data['resource_guid'])
        next unless resource
        
        if existing_resource
          # Update existing resource
          existing_resource.update!(
            unit_group_id: unit_group.id,
            resource_id: resource.id
          )
          @import_stats[:updated] += 1
        else
          # Create new resource
          UnitGroupsStudentResource.create!(
            guid: resource_data['guid'],
            unit_group_id: unit_group.id,
            resource_id: resource.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing unit group student resource #{resource_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{resources_data.length} unit group student resources"
  end
  
  def import_script_resources
    puts "📝 Importing script resources..."
    resources_data = load_json_file('script_resources.json')
    return unless resources_data
    
    resources_data.each do |resource_data|
      begin
        existing_resource = ScriptsResource.find_by(guid: resource_data['guid'])
        
        # Find script by GUID
        script = Unit.find_by(guid: resource_data['script_guid'])
        next unless script
        
        # Find resource by GUID
        resource = Resource.find_by(guid: resource_data['resource_guid'])
        next unless resource
        
        if existing_resource
          # Update existing resource
          existing_resource.update!(
            script_id: script.id,
            resource_id: resource.id
          )
          @import_stats[:updated] += 1
        else
          # Create new resource
          ScriptsResource.create!(
            guid: resource_data['guid'],
            script_id: script.id,
            resource_id: resource.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing script resource #{resource_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{resources_data.length} script resources"
  end
  
  def import_script_student_resources
    puts "📝 Importing script student resources..."
    resources_data = load_json_file('script_student_resources.json')
    return unless resources_data
    
    resources_data.each do |resource_data|
      begin
        existing_resource = ScriptsStudentResource.find_by(guid: resource_data['guid'])
        
        # Find script by GUID
        script = Unit.find_by(guid: resource_data['script_guid'])
        next unless script
        
        # Find resource by GUID
        resource = Resource.find_by(guid: resource_data['resource_guid'])
        next unless resource
        
        if existing_resource
          # Update existing resource
          existing_resource.update!(
            script_id: script.id,
            resource_id: resource.id
          )
          @import_stats[:updated] += 1
        else
          # Create new resource
          ScriptsStudentResource.create!(
            guid: resource_data['guid'],
            script_id: script.id,
            resource_id: resource.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing script student resource #{resource_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{resources_data.length} script student resources"
  end
  
  def import_lesson_resources
    puts "📝 Importing lesson resources..."
    resources_data = load_json_file('lesson_resources.json')
    return unless resources_data
    
    resources_data.each do |resource_data|
      begin
        existing_resource = LessonsResource.find_by(guid: resource_data['guid'])
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: resource_data['lesson_guid'])
        next unless lesson
        
        # Find resource by GUID
        resource = Resource.find_by(guid: resource_data['resource_guid'])
        next unless resource
        
        if existing_resource
          # Update existing resource
          existing_resource.update!(
            lesson_id: lesson.id,
            resource_id: resource.id
          )
          @import_stats[:updated] += 1
        else
          # Create new resource
          LessonsResource.create!(
            guid: resource_data['guid'],
            lesson_id: lesson.id,
            resource_id: resource.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing lesson resource #{resource_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{resources_data.length} lesson resources"
  end
  
  def import_lesson_standards
    puts "📝 Importing lesson standards..."
    standards_data = load_json_file('lesson_standards.json')
    return unless standards_data
    
    standards_data.each do |standard_data|
      begin
        existing_standard = LessonsStandard.find_by(guid: standard_data['guid'])
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: standard_data['lesson_guid'])
        next unless lesson
        
        # Find standard by GUID
        standard = Standard.find_by(guid: standard_data['standard_guid'])
        next unless standard
        
        if existing_standard
          # Update existing standard
          existing_standard.update!(
            lesson_id: lesson.id,
            standard_id: standard.id
          )
          @import_stats[:updated] += 1
        else
          # Create new standard
          LessonsStandard.create!(
            guid: standard_data['guid'],
            lesson_id: lesson.id,
            standard_id: standard.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing lesson standard #{standard_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{standards_data.length} lesson standards"
  end
  
  def import_lesson_vocabularies
    puts "📝 Importing lesson vocabularies..."
    vocabularies_data = load_json_file('lesson_vocabularies.json')
    return unless vocabularies_data
    
    vocabularies_data.each do |vocab_data|
      begin
        existing_vocab = LessonsVocabulary.find_by(guid: vocab_data['guid'])
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: vocab_data['lesson_guid'])
        next unless lesson
        
        # Find vocabulary by GUID
        vocabulary = Vocabulary.find_by(guid: vocab_data['vocabulary_guid'])
        next unless vocabulary
        
        if existing_vocab
          # Update existing vocabulary
          existing_vocab.update!(
            lesson_id: lesson.id,
            vocabulary_id: vocabulary.id
          )
          @import_stats[:updated] += 1
        else
          # Create new vocabulary
          LessonsVocabulary.create!(
            guid: vocab_data['guid'],
            lesson_id: lesson.id,
            vocabulary_id: vocabulary.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing lesson vocabulary #{vocab_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{vocabularies_data.length} lesson vocabularies"
  end
  
  def import_lesson_programming_expressions
    puts "📝 Importing lesson programming expressions..."
    expressions_data = load_json_file('lesson_programming_expressions.json')
    return unless expressions_data
    
    expressions_data.each do |expr_data|
      begin
        existing_expr = LessonsProgrammingExpression.find_by(guid: expr_data['guid'])
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: expr_data['lesson_guid'])
        next unless lesson
        
        # Find programming expression by GUID
        programming_expression = ProgrammingExpression.find_by(guid: expr_data['programming_expression_guid'])
        next unless programming_expression
        
        if existing_expr
          # Update existing expression
          existing_expr.update!(
            lesson_id: lesson.id,
            programming_expression_id: programming_expression.id
          )
          @import_stats[:updated] += 1
        else
          # Create new expression
          LessonsProgrammingExpression.create!(
            guid: expr_data['guid'],
            lesson_id: lesson.id,
            programming_expression_id: programming_expression.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing lesson programming expression #{expr_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{expressions_data.length} lesson programming expressions"
  end
  
  def import_learning_goal_evidence_levels
    puts "📝 Importing learning goal evidence levels..."
    levels_data = load_json_file('learning_goal_evidence_levels.json')
    return unless levels_data
    
    levels_data.each do |level_data|
      begin
        existing_level = LearningGoalEvidenceLevel.find_by(guid: level_data['guid'])
        
        # Find learning goal by GUID
        learning_goal = LearningGoal.find_by(guid: level_data['learning_goal_guid'])
        next unless learning_goal
        
        if existing_level
          # Update existing level
          existing_level.update!(
            learning_goal_id: learning_goal.id,
            evidence_level: level_data['evidence_level'],
            description: level_data['description']
          )
          @import_stats[:updated] += 1
        else
          # Create new level
          LearningGoalEvidenceLevel.create!(
            guid: level_data['guid'],
            learning_goal_id: learning_goal.id,
            evidence_level: level_data['evidence_level'],
            description: level_data['description']
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing learning goal evidence level #{level_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{levels_data.length} learning goal evidence levels"
  end
  
  def import_lesson_opportunity_standards
    puts "📝 Importing lesson opportunity standards..."
    standards_data = load_json_file('lesson_opportunity_standards.json')
    return unless standards_data
    
    standards_data.each do |standard_data|
      begin
        existing_standard = LessonsOpportunityStandard.find_by(guid: standard_data['guid'])
        
        # Find lesson by GUID
        lesson = Lesson.find_by(guid: standard_data['lesson_guid'])
        next unless lesson
        
        # Find standard by GUID
        standard = Standard.find_by(guid: standard_data['standard_guid'])
        next unless standard
        
        if existing_standard
          # Update existing standard
          existing_standard.update!(
            lesson_id: lesson.id,
            standard_id: standard.id
          )
          @import_stats[:updated] += 1
        else
          # Create new standard
          LessonsOpportunityStandard.create!(
            guid: standard_data['guid'],
            lesson_id: lesson.id,
            standard_id: standard.id
          )
          @import_stats[:created] += 1
        end
      rescue => e
        puts "    ❌ Error importing lesson opportunity standard #{standard_data['key']}: #{e.message}"
        @import_stats[:errors] += 1
      end
    end
    
    puts "    ✅ Imported #{standards_data.length} lesson opportunity standards"
  end
  
  def load_json_file(filename)
    file_path = @export_path.join(filename)
    return nil unless File.exist?(file_path)
    
    JSON.parse(File.read(file_path))
  end
  
  def print_import_stats
    puts ""
    puts "📈 IMPORT STATISTICS"
    puts "=" * 60
    puts "Records created: #{@import_stats[:created]}"
    puts "Records updated: #{@import_stats[:updated]}"
    puts "Records skipped: #{@import_stats[:skipped]}"
    puts "Errors: #{@import_stats[:errors]}"
    puts ""
    
    if @import_stats[:errors] > 0
      puts "❌ Import completed with errors - check logs above"
    else
      puts "✅ Import completed successfully!"
    end
  end
end