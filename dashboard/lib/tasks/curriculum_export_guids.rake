# frozen_string_literal: true

# Curriculum GUID Export Task
# This task exports curriculum data with GUIDs and creates mapping files
# Run with: bundle exec rake curriculum:export_guids

namespace :curriculum do
  desc "Export curriculum data with GUIDs and create mapping files"
  task export_guids: :environment do
    puts "🚀 Starting Curriculum GUID Export"
    puts "=" * 60
    
    exporter = CurriculumGuidExporter.new
    exporter.export_all
    
    puts ""
    puts "✅ Curriculum GUID export complete!"
    puts "📁 Mapping files created in: #{exporter.export_directory}"
  end
end

class CurriculumGuidExporter
  def initialize
    @export_directory = Rails.root.join('tmp', 'curriculum_guid_export')
    @timestamp = Time.current.strftime('%Y%m%d_%H%M%S')
    @export_path = @export_directory.join(@timestamp)
    
    # Create export directory
    FileUtils.mkdir_p(@export_path)
  end
  
  attr_reader :export_directory, :export_path, :timestamp
  
  def export_all
    puts "📊 Exporting curriculum data with GUIDs..."
    puts "📁 Export directory: #{@export_path}"
    puts ""
    
    # Export all curriculum tables with GUIDs
    export_scripts
    export_lessons
    export_levels
    export_lesson_groups
    export_lesson_activities
    export_activity_sections
    export_courses
    export_course_offerings
    export_course_versions
    export_objectives
    export_programming_expressions
    export_rubrics
    export_learning_goals
    export_unit_groups
    export_script_levels
    export_levels_script_levels
    export_course_scripts
    export_unit_group_resources
    export_unit_group_student_resources
    export_script_resources
    export_script_student_resources
    export_lesson_resources
    export_lesson_standards
    export_lesson_vocabularies
    export_lesson_programming_expressions
    export_learning_goal_evidence_levels
    export_lesson_opportunity_standards
    
    # Create summary file
    create_export_summary
  end
  
  private
  
  def export_scripts
    puts "  📝 Exporting scripts..."
    scripts = Unit.all.includes(:lesson_groups, :lessons, :script_levels)
    
    scripts_data = scripts.map do |script|
      {
        id: script.id,
        guid: script.guid,
        key: script.name,
        name: script.name,
        created_at: script.created_at,
        updated_at: script.updated_at,
        properties: script.properties,
        published_state: script.published_state,
        instruction_type: script.instruction_type,
        instructor_audience: script.instructor_audience,
        participant_audience: script.participant_audience,
        hide_within_course: script.hide_within_course
      }
    end
    
    write_json_file('scripts.json', scripts_data)
    puts "    ✅ Exported #{scripts_data.length} scripts"
  end
  
  def export_lessons
    puts "  📝 Exporting lessons (stages)..."
    lessons = Lesson.all.includes(:script, :lesson_group, :lesson_activities)
    
    lessons_data = lessons.map do |lesson|
      {
        id: lesson.id,
        guid: lesson.guid,
        key: lesson.key,
        name: lesson.name,
        script_id: lesson.script_id,
        script_guid: lesson.script&.guid,
        lesson_group_id: lesson.lesson_group_id,
        lesson_group_guid: lesson.lesson_group&.guid,
        absolute_position: lesson.absolute_position,
        relative_position: lesson.relative_position,
        created_at: lesson.created_at,
        updated_at: lesson.updated_at,
        properties: lesson.properties,
        lockable: lesson.lockable,
        has_lesson_plan: lesson.has_lesson_plan
      }
    end
    
    write_json_file('lessons.json', lessons_data)
    puts "    ✅ Exported #{lessons_data.length} lessons"
  end
  
  def export_levels
    puts "  📝 Exporting levels..."
    levels = Level.all
    
    levels_data = levels.map do |level|
      {
        id: level.id,
        guid: level.guid,
        key: level.key,
        name: level.name,
        created_at: level.created_at,
        updated_at: level.updated_at,
        properties: level.properties,
        type: level.type,
        level_num: level.level_num,
        user_id: level.user_id,
        game_id: level.game_id,
        ideal_level_source_id: level.ideal_level_source_id,
        solution_level_source_id: level.solution_level_source_id,
        created_at: level.created_at,
        updated_at: level.updated_at
      }
    end
    
    write_json_file('levels.json', levels_data)
    puts "    ✅ Exported #{levels_data.length} levels"
  end
  
  def export_lesson_groups
    puts "  📝 Exporting lesson groups..."
    lesson_groups = LessonGroup.all.includes(:script)
    
    lesson_groups_data = lesson_groups.map do |lg|
      {
        id: lg.id,
        guid: lg.guid,
        key: lg.key,
        script_id: lg.script_id,
        script_guid: lg.script&.guid,
        user_facing: lg.user_facing,
        position: lg.position,
        created_at: lg.created_at,
        updated_at: lg.updated_at,
        properties: lg.properties
      }
    end
    
    write_json_file('lesson_groups.json', lesson_groups_data)
    puts "    ✅ Exported #{lesson_groups_data.length} lesson groups"
  end
  
  def export_lesson_activities
    puts "  📝 Exporting lesson activities..."
    activities = LessonActivity.all.includes(:lesson)
    
    activities_data = activities.map do |activity|
      {
        id: activity.id,
        guid: activity.guid,
        key: activity.key,
        lesson_id: activity.lesson_id,
        lesson_guid: activity.lesson&.guid,
        position: activity.position,
        created_at: activity.created_at,
        updated_at: activity.updated_at,
        properties: activity.properties
      }
    end
    
    write_json_file('lesson_activities.json', activities_data)
    puts "    ✅ Exported #{activities_data.length} lesson activities"
  end
  
  def export_activity_sections
    puts "  📝 Exporting activity sections..."
    sections = ActivitySection.all.includes(:lesson_activity)
    
    sections_data = sections.map do |section|
      {
        id: section.id,
        guid: section.guid,
        key: section.key,
        lesson_activity_id: section.lesson_activity_id,
        lesson_activity_guid: section.lesson_activity&.guid,
        position: section.position,
        created_at: section.created_at,
        updated_at: section.updated_at,
        properties: section.properties
      }
    end
    
    write_json_file('activity_sections.json', sections_data)
    puts "    ✅ Exported #{sections_data.length} activity sections"
  end
  
  def export_courses
    puts "  📝 Exporting courses..."
    courses = Course.all
    
    courses_data = courses.map do |course|
      {
        id: course.id,
        guid: course.guid,
        key: course.key,
        name: course.name,
        created_at: course.created_at,
        updated_at: course.updated_at,
        properties: course.properties
      }
    end
    
    write_json_file('courses.json', courses_data)
    puts "    ✅ Exported #{courses_data.length} courses"
  end
  
  def export_course_offerings
    puts "  📝 Exporting course offerings..."
    offerings = CourseOffering.all
    
    offerings_data = offerings.map do |offering|
      {
        id: offering.id,
        guid: offering.guid,
        key: offering.key,
        display_name: offering.display_name,
        created_at: offering.created_at,
        updated_at: offering.updated_at,
        is_featured: offering.is_featured,
        assignable: offering.assignable,
        curriculum_type: offering.curriculum_type,
        marketing_initiative: offering.marketing_initiative,
        grade_levels: offering.grade_levels,
        header: offering.header,
        image: offering.image,
        cs_topic: offering.cs_topic,
        school_subject: offering.school_subject,
        device_compatibility: offering.device_compatibility,
        description: offering.description,
        professional_learning_program: offering.professional_learning_program,
        video: offering.video,
        published_date: offering.published_date,
        ai_teaching_assistant_available: offering.ai_teaching_assistant_available,
        facilitator_course_permissions: offering.facilitator_course_permissions
      }
    end
    
    write_json_file('course_offerings.json', offerings_data)
    puts "    ✅ Exported #{offerings_data.length} course offerings"
  end
  
  def export_course_versions
    puts "  📝 Exporting course versions..."
    versions = CourseVersion.all.includes(:course_offering)
    
    versions_data = versions.map do |version|
      {
        id: version.id,
        guid: version.guid,
        key: version.key,
        display_name: version.display_name,
        content_root_id: version.content_root_id,
        course_offering_id: version.course_offering_id,
        course_offering_guid: version.course_offering&.guid,
        created_at: version.created_at,
        updated_at: version.updated_at,
        properties: version.properties,
        published_state: version.published_state
      }
    end
    
    write_json_file('course_versions.json', versions_data)
    puts "    ✅ Exported #{versions_data.length} course versions"
  end
  
  def export_objectives
    puts "  📝 Exporting objectives..."
    objectives = Objective.all.includes(:lesson)
    
    objectives_data = objectives.map do |objective|
      {
        id: objective.id,
        guid: objective.guid,
        key: objective.key,
        lesson_id: objective.lesson_id,
        lesson_guid: objective.lesson&.guid,
        description: objective.description,
        created_at: objective.created_at,
        updated_at: objective.updated_at
      }
    end
    
    write_json_file('objectives.json', objectives_data)
    puts "    ✅ Exported #{objectives_data.length} objectives"
  end
  
  def export_programming_expressions
    puts "  📝 Exporting programming expressions..."
    expressions = ProgrammingExpression.all.includes(:programming_environment)
    
    expressions_data = expressions.map do |expression|
      {
        id: expression.id,
        guid: expression.guid,
        key: expression.key,
        programming_environment_id: expression.programming_environment_id,
        programming_environment_name: expression.programming_environment&.name,
        name: expression.name,
        category: expression.category,
        color: expression.color,
        created_at: expression.created_at,
        updated_at: expression.updated_at,
        properties: expression.properties
      }
    end
    
    write_json_file('programming_expressions.json', expressions_data)
    puts "    ✅ Exported #{expressions_data.length} programming expressions"
  end
  
  def export_rubrics
    puts "  📝 Exporting rubrics..."
    rubrics = Rubric.all.includes(:lesson)
    
    rubrics_data = rubrics.map do |rubric|
      {
        id: rubric.id,
        guid: rubric.guid,
        key: rubric.key,
        lesson_id: rubric.lesson_id,
        lesson_guid: rubric.lesson&.guid,
        level_id: rubric.level_id,
        level_guid: rubric.level&.guid,
        created_at: rubric.created_at,
        updated_at: rubric.updated_at,
        properties: rubric.properties
      }
    end
    
    write_json_file('rubrics.json', rubrics_data)
    puts "    ✅ Exported #{rubrics_data.length} rubrics"
  end
  
  def export_learning_goals
    puts "  📝 Exporting learning goals..."
    goals = LearningGoal.all.includes(:rubric)
    
    goals_data = goals.map do |goal|
      {
        id: goal.id,
        guid: goal.guid,
        key: goal.key,
        rubric_id: goal.rubric_id,
        rubric_guid: goal.rubric&.guid,
        name: goal.name,
        description: goal.description,
        created_at: goal.created_at,
        updated_at: goal.updated_at,
        properties: goal.properties
      }
    end
    
    write_json_file('learning_goals.json', goals_data)
    puts "    ✅ Exported #{goals_data.length} learning goals"
  end
  
  def export_unit_groups
    puts "  📝 Exporting unit groups..."
    unit_groups = UnitGroup.all
    
    unit_groups_data = unit_groups.map do |ug|
      {
        id: ug.id,
        guid: ug.guid,
        key: ug.key,
        name: ug.name,
        created_at: ug.created_at,
        updated_at: ug.updated_at,
        properties: ug.properties
      }
    end
    
    write_json_file('unit_groups.json', unit_groups_data)
    puts "    ✅ Exported #{unit_groups_data.length} unit groups"
  end
  
  def export_script_levels
    puts "  📝 Exporting script levels..."
    script_levels = ScriptLevel.all.includes(:script, :lesson, :levels)
    
    script_levels_data = script_levels.map do |sl|
      {
        id: sl.id,
        guid: sl.guid,
        key: "#{sl.script_id}-#{sl.stage_id}-#{sl.position}",
        script_id: sl.script_id,
        script_guid: sl.script&.guid,
        stage_id: sl.stage_id,
        lesson_guid: sl.lesson&.guid,
        position: sl.position,
        created_at: sl.created_at,
        updated_at: sl.updated_at,
        properties: sl.properties,
        level_keys: sl.level_keys
      }
    end
    
    write_json_file('script_levels.json', script_levels_data)
    puts "    ✅ Exported #{script_levels_data.length} script levels"
  end
  
  def export_levels_script_levels
    puts "  📝 Exporting levels script levels..."
    lsls = LevelsScriptLevel.all.includes(:level, :script_level)
    
    lsls_data = lsls.map do |lsl|
      {
        id: lsl.id,
        guid: lsl.guid,
        key: "#{lsl.level_id}-#{lsl.script_level_id}",
        level_id: lsl.level_id,
        level_guid: lsl.level&.guid,
        script_level_id: lsl.script_level_id,
        script_level_guid: lsl.script_level&.guid,
        created_at: lsl.created_at,
        updated_at: lsl.updated_at
      }
    end
    
    write_json_file('levels_script_levels.json', lsls_data)
    puts "    ✅ Exported #{lsls_data.length} levels script levels"
  end
  
  def export_course_scripts
    puts "  📝 Exporting course scripts..."
    course_scripts = CourseScript.all.includes(:course, :script)
    
    course_scripts_data = course_scripts.map do |cs|
      {
        id: cs.id,
        guid: cs.guid,
        key: "#{cs.course_id}-#{cs.script_id}",
        course_id: cs.course_id,
        course_guid: cs.course&.guid,
        script_id: cs.script_id,
        script_guid: cs.script&.guid,
        position: cs.position,
        created_at: cs.created_at,
        updated_at: cs.updated_at
      }
    end
    
    write_json_file('course_scripts.json', course_scripts_data)
    puts "    ✅ Exported #{course_scripts_data.length} course scripts"
  end
  
  def export_unit_group_resources
    puts "  📝 Exporting unit group resources..."
    resources = UnitGroupsResource.all.includes(:unit_group, :resource)
    
    resources_data = resources.map do |resource|
      {
        id: resource.id,
        guid: resource.guid,
        key: "#{resource.unit_group_id}-#{resource.resource_id}",
        unit_group_id: resource.unit_group_id,
        unit_group_guid: resource.unit_group&.guid,
        resource_id: resource.resource_id,
        resource_guid: resource.resource&.guid,
        created_at: resource.created_at,
        updated_at: resource.updated_at
      }
    end
    
    write_json_file('unit_group_resources.json', resources_data)
    puts "    ✅ Exported #{resources_data.length} unit group resources"
  end
  
  def export_unit_group_student_resources
    puts "  📝 Exporting unit group student resources..."
    resources = UnitGroupsStudentResource.all.includes(:unit_group, :resource)
    
    resources_data = resources.map do |resource|
      {
        id: resource.id,
        guid: resource.guid,
        key: "#{resource.unit_group_id}-#{resource.resource_id}",
        unit_group_id: resource.unit_group_id,
        unit_group_guid: resource.unit_group&.guid,
        resource_id: resource.resource_id,
        resource_guid: resource.resource&.guid,
        created_at: resource.created_at,
        updated_at: resource.updated_at
      }
    end
    
    write_json_file('unit_group_student_resources.json', resources_data)
    puts "    ✅ Exported #{resources_data.length} unit group student resources"
  end
  
  def export_script_resources
    puts "  📝 Exporting script resources..."
    resources = ScriptsResource.all.includes(:script, :resource)
    
    resources_data = resources.map do |resource|
      {
        id: resource.id,
        guid: resource.guid,
        key: "#{resource.script_id}-#{resource.resource_id}",
        script_id: resource.script_id,
        script_guid: resource.script&.guid,
        resource_id: resource.resource_id,
        resource_guid: resource.resource&.guid,
        created_at: resource.created_at,
        updated_at: resource.updated_at
      }
    end
    
    write_json_file('script_resources.json', resources_data)
    puts "    ✅ Exported #{resources_data.length} script resources"
  end
  
  def export_script_student_resources
    puts "  📝 Exporting script student resources..."
    resources = ScriptsStudentResource.all.includes(:script, :resource)
    
    resources_data = resources.map do |resource|
      {
        id: resource.id,
        guid: resource.guid,
        key: "#{resource.script_id}-#{resource.resource_id}",
        script_id: resource.script_id,
        script_guid: resource.script&.guid,
        resource_id: resource.resource_id,
        resource_guid: resource.resource&.guid,
        created_at: resource.created_at,
        updated_at: resource.updated_at
      }
    end
    
    write_json_file('script_student_resources.json', resources_data)
    puts "    ✅ Exported #{resources_data.length} script student resources"
  end
  
  def export_lesson_resources
    puts "  📝 Exporting lesson resources..."
    resources = LessonsResource.all.includes(:lesson, :resource)
    
    resources_data = resources.map do |resource|
      {
        id: resource.id,
        guid: resource.guid,
        key: "#{resource.lesson_id}-#{resource.resource_id}",
        lesson_id: resource.lesson_id,
        lesson_guid: resource.lesson&.guid,
        resource_id: resource.resource_id,
        resource_guid: resource.resource&.guid,
        created_at: resource.created_at,
        updated_at: resource.updated_at
      }
    end
    
    write_json_file('lesson_resources.json', resources_data)
    puts "    ✅ Exported #{resources_data.length} lesson resources"
  end
  
  def export_lesson_standards
    puts "  📝 Exporting lesson standards..."
    standards = LessonsStandard.all.includes(:lesson, :standard)
    
    standards_data = standards.map do |standard|
      {
        id: standard.id,
        guid: standard.guid,
        key: "#{standard.lesson_id}-#{standard.standard_id}",
        lesson_id: standard.lesson_id,
        lesson_guid: standard.lesson&.guid,
        standard_id: standard.standard_id,
        standard_guid: standard.standard&.guid,
        created_at: standard.created_at,
        updated_at: standard.updated_at
      }
    end
    
    write_json_file('lesson_standards.json', standards_data)
    puts "    ✅ Exported #{standards_data.length} lesson standards"
  end
  
  def export_lesson_vocabularies
    puts "  📝 Exporting lesson vocabularies..."
    vocabularies = LessonsVocabulary.all.includes(:lesson, :vocabulary)
    
    vocabularies_data = vocabularies.map do |vocab|
      {
        id: vocab.id,
        guid: vocab.guid,
        key: "#{vocab.lesson_id}-#{vocab.vocabulary_id}",
        lesson_id: vocab.lesson_id,
        lesson_guid: vocab.lesson&.guid,
        vocabulary_id: vocab.vocabulary_id,
        vocabulary_guid: vocab.vocabulary&.guid,
        created_at: vocab.created_at,
        updated_at: vocab.updated_at
      }
    end
    
    write_json_file('lesson_vocabularies.json', vocabularies_data)
    puts "    ✅ Exported #{vocabularies_data.length} lesson vocabularies"
  end
  
  def export_lesson_programming_expressions
    puts "  📝 Exporting lesson programming expressions..."
    expressions = LessonsProgrammingExpression.all.includes(:lesson, :programming_expression)
    
    expressions_data = expressions.map do |expr|
      {
        id: expr.id,
        guid: expr.guid,
        key: "#{expr.lesson_id}-#{expr.programming_expression_id}",
        lesson_id: expr.lesson_id,
        lesson_guid: expr.lesson&.guid,
        programming_expression_id: expr.programming_expression_id,
        programming_expression_guid: expr.programming_expression&.guid,
        created_at: expr.created_at,
        updated_at: expr.updated_at
      }
    end
    
    write_json_file('lesson_programming_expressions.json', expressions_data)
    puts "    ✅ Exported #{expressions_data.length} lesson programming expressions"
  end
  
  def export_learning_goal_evidence_levels
    puts "  📝 Exporting learning goal evidence levels..."
    levels = LearningGoalEvidenceLevel.all.includes(:learning_goal)
    
    levels_data = levels.map do |level|
      {
        id: level.id,
        guid: level.guid,
        key: "#{level.learning_goal_id}-#{level.evidence_level}",
        learning_goal_id: level.learning_goal_id,
        learning_goal_guid: level.learning_goal&.guid,
        evidence_level: level.evidence_level,
        description: level.description,
        created_at: level.created_at,
        updated_at: level.updated_at
      }
    end
    
    write_json_file('learning_goal_evidence_levels.json', levels_data)
    puts "    ✅ Exported #{levels_data.length} learning goal evidence levels"
  end
  
  def export_lesson_opportunity_standards
    puts "  📝 Exporting lesson opportunity standards..."
    standards = LessonsOpportunityStandard.all.includes(:lesson, :standard)
    
    standards_data = standards.map do |standard|
      {
        id: standard.id,
        guid: standard.guid,
        key: "#{standard.lesson_id}-#{standard.standard_id}",
        lesson_id: standard.lesson_id,
        lesson_guid: standard.lesson&.guid,
        standard_id: standard.standard_id,
        standard_guid: standard.standard&.guid,
        created_at: standard.created_at,
        updated_at: standard.updated_at
      }
    end
    
    write_json_file('lesson_opportunity_standards.json', standards_data)
    puts "    ✅ Exported #{standards_data.length} lesson opportunity standards"
  end
  
  def create_export_summary
    puts "  📝 Creating export summary..."
    
    summary = {
      export_timestamp: @timestamp,
      export_directory: @export_path.to_s,
      tables_exported: [
        'scripts', 'lessons', 'levels', 'lesson_groups', 'lesson_activities', 'activity_sections',
        'courses', 'course_offerings', 'course_versions', 'objectives', 'programming_expressions',
        'rubrics', 'learning_goals', 'unit_groups', 'script_levels', 'levels_script_levels',
        'course_scripts', 'unit_group_resources', 'unit_group_student_resources',
        'script_resources', 'script_student_resources', 'lesson_resources',
        'lesson_standards', 'lesson_vocabularies', 'lesson_programming_expressions',
        'learning_goal_evidence_levels', 'lesson_opportunity_standards'
      ],
      total_tables: 27,
      export_format: 'JSON with GUIDs and mapping keys',
      usage: 'Import these files to seed curriculum data with consistent GUIDs'
    }
    
    write_json_file('export_summary.json', summary)
    puts "    ✅ Export summary created"
  end
  
  def write_json_file(filename, data)
    file_path = @export_path.join(filename)
    File.write(file_path, JSON.pretty_generate(data))
  end
end