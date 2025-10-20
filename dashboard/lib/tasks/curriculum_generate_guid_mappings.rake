# frozen_string_literal: true

# Curriculum GUID Mapping Generation Task
# This task generates JSON mapping files that link existing unique identifiers to GUIDs
# Run with: bundle exec rake curriculum:generate_guid_mappings

namespace :curriculum do
  desc "Generate GUID mapping files for curriculum entities"
  task generate_guid_mappings: :environment do
    puts "🗺️  Generating Curriculum GUID Mappings"
    puts "=" * 60
    puts ""
    
    generator = CurriculumGuidMappingGenerator.new
    generator.generate_all_mappings
    
    puts ""
    puts "✅ GUID mapping files generated successfully!"
    puts "📁 Mapping files location: #{generator.mappings_dir}"
    puts ""
    puts "📋 Next steps:"
    puts "  1. Review the generated mapping files"
    puts "  2. Commit the mapping files to the codebase"
    puts "  3. Update seeding process to use GUID mappings"
  end
end

class CurriculumGuidMappingGenerator
  def initialize
    @mappings_dir = Rails.root.join('config', 'curriculum_guid_mappings')
    @stats = {
      total_mappings: 0,
      files_generated: 0,
      errors: 0
    }
    
    # Create mappings directory
    FileUtils.mkdir_p(@mappings_dir)
  end
  
  attr_reader :mappings_dir, :stats
  
  def generate_all_mappings
    puts "📊 Generating mappings for all curriculum entities..."
    puts ""
    
    # Generate mappings for each curriculum table type
    generate_script_mappings
    generate_lesson_mappings
    generate_level_mappings
    generate_lesson_group_mappings
    generate_lesson_activity_mappings
    generate_activity_section_mappings
    generate_course_mappings
    generate_course_offering_mappings
    generate_course_version_mappings
    generate_objective_mappings
    generate_programming_expression_mappings
    generate_rubric_mappings
    generate_learning_goal_mappings
    generate_unit_group_mappings
    generate_script_level_mappings
    generate_levels_script_level_mappings
    generate_course_script_mappings
    generate_unit_group_resource_mappings
    generate_unit_group_student_resource_mappings
    generate_script_resource_mappings
    generate_script_student_resource_mappings
    generate_lesson_resource_mappings
    generate_lesson_standard_mappings
    generate_lesson_vocabulary_mappings
    generate_lesson_programming_expression_mappings
    generate_learning_goal_evidence_level_mappings
    generate_lesson_opportunity_standard_mappings
    
    # Create summary
    create_mapping_summary
    
    # Print final statistics
    print_final_stats
  end
  
  private
  
  def generate_script_mappings
    puts "📝 Generating script mappings..."
    
    # Scripts use 'name' as unique identifier
    scripts = Unit.all
    mappings = {}
    
    scripts.each do |script|
      next if script.guid.blank?
      mappings[script.name] = script.guid
    end
    
    write_mapping_file('scripts.json', mappings)
    puts "  ✅ Generated #{mappings.length} script mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_lesson_mappings
    puts "📝 Generating lesson mappings..."
    
    # Lessons (stages) use 'key' as unique identifier
    lessons = Lesson.all
    mappings = {}
    
    lessons.each do |lesson|
      next if lesson.guid.blank? || lesson.key.blank?
      mappings[lesson.key] = lesson.guid
    end
    
    write_mapping_file('lessons.json', mappings)
    puts "  ✅ Generated #{mappings.length} lesson mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_level_mappings
    puts "📝 Generating level mappings..."
    
    # Levels use 'key' as unique identifier
    levels = Level.all
    mappings = {}
    
    levels.each do |level|
      next if level.guid.blank? || level.key.blank?
      mappings[level.key] = level.guid
    end
    
    write_mapping_file('levels.json', mappings)
    puts "  ✅ Generated #{mappings.length} level mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_lesson_group_mappings
    puts "📝 Generating lesson group mappings..."
    
    # Lesson groups use 'key' as unique identifier
    lesson_groups = LessonGroup.all
    mappings = {}
    
    lesson_groups.each do |lg|
      next if lg.guid.blank? || lg.key.blank?
      mappings[lg.key] = lg.guid
    end
    
    write_mapping_file('lesson_groups.json', mappings)
    puts "  ✅ Generated #{mappings.length} lesson group mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_lesson_activity_mappings
    puts "📝 Generating lesson activity mappings..."
    
    # Lesson activities use 'key' as unique identifier
    activities = LessonActivity.all
    mappings = {}
    
    activities.each do |activity|
      next if activity.guid.blank? || activity.key.blank?
      mappings[activity.key] = activity.guid
    end
    
    write_mapping_file('lesson_activities.json', mappings)
    puts "  ✅ Generated #{mappings.length} lesson activity mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_activity_section_mappings
    puts "📝 Generating activity section mappings..."
    
    # Activity sections use 'key' as unique identifier
    sections = ActivitySection.all
    mappings = {}
    
    sections.each do |section|
      next if section.guid.blank? || section.key.blank?
      mappings[section.key] = section.guid
    end
    
    write_mapping_file('activity_sections.json', mappings)
    puts "  ✅ Generated #{mappings.length} activity section mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_course_mappings
    puts "📝 Generating course mappings..."
    
    # Courses use 'key' as unique identifier
    courses = Course.all
    mappings = {}
    
    courses.each do |course|
      next if course.guid.blank? || course.key.blank?
      mappings[course.key] = course.guid
    end
    
    write_mapping_file('courses.json', mappings)
    puts "  ✅ Generated #{mappings.length} course mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_course_offering_mappings
    puts "📝 Generating course offering mappings..."
    
    # Course offerings use 'key' as unique identifier
    offerings = CourseOffering.all
    mappings = {}
    
    offerings.each do |offering|
      next if offering.guid.blank? || offering.key.blank?
      mappings[offering.key] = offering.guid
    end
    
    write_mapping_file('course_offerings.json', mappings)
    puts "  ✅ Generated #{mappings.length} course offering mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_course_version_mappings
    puts "📝 Generating course version mappings..."
    
    # Course versions use 'key' as unique identifier
    versions = CourseVersion.all
    mappings = {}
    
    versions.each do |version|
      next if version.guid.blank? || version.key.blank?
      mappings[version.key] = version.guid
    end
    
    write_mapping_file('course_versions.json', mappings)
    puts "  ✅ Generated #{mappings.length} course version mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_objective_mappings
    puts "📝 Generating objective mappings..."
    
    # Objectives use 'key' as unique identifier
    objectives = Objective.all
    mappings = {}
    
    objectives.each do |objective|
      next if objective.guid.blank? || objective.key.blank?
      mappings[objective.key] = objective.guid
    end
    
    write_mapping_file('objectives.json', mappings)
    puts "  ✅ Generated #{mappings.length} objective mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_programming_expression_mappings
    puts "📝 Generating programming expression mappings..."
    
    # Programming expressions use 'key' as unique identifier
    expressions = ProgrammingExpression.all
    mappings = {}
    
    expressions.each do |expr|
      next if expr.guid.blank? || expr.key.blank?
      mappings[expr.key] = expr.guid
    end
    
    write_mapping_file('programming_expressions.json', mappings)
    puts "  ✅ Generated #{mappings.length} programming expression mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_rubric_mappings
    puts "📝 Generating rubric mappings..."
    
    # Rubrics use 'key' as unique identifier
    rubrics = Rubric.all
    mappings = {}
    
    rubrics.each do |rubric|
      next if rubric.guid.blank? || rubric.key.blank?
      mappings[rubric.key] = rubric.guid
    end
    
    write_mapping_file('rubrics.json', mappings)
    puts "  ✅ Generated #{mappings.length} rubric mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_learning_goal_mappings
    puts "📝 Generating learning goal mappings..."
    
    # Learning goals use 'key' as unique identifier
    goals = LearningGoal.all
    mappings = {}
    
    goals.each do |goal|
      next if goal.guid.blank? || goal.key.blank?
      mappings[goal.key] = goal.guid
    end
    
    write_mapping_file('learning_goals.json', mappings)
    puts "  ✅ Generated #{mappings.length} learning goal mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_unit_group_mappings
    puts "📝 Generating unit group mappings..."
    
    # Unit groups use 'key' as unique identifier
    unit_groups = UnitGroup.all
    mappings = {}
    
    unit_groups.each do |ug|
      next if ug.guid.blank? || ug.key.blank?
      mappings[ug.key] = ug.guid
    end
    
    write_mapping_file('unit_groups.json', mappings)
    puts "  ✅ Generated #{mappings.length} unit group mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_script_level_mappings
    puts "📝 Generating script level mappings..."
    
    # Script levels use composite key: script_name + lesson_key + position
    script_levels = ScriptLevel.all.includes(:script, :lesson)
    mappings = {}
    
    script_levels.each do |sl|
      next if sl.guid.blank?
      key = "#{sl.script.name}:#{sl.lesson.key}:#{sl.position}"
      mappings[key] = sl.guid
    end
    
    write_mapping_file('script_levels.json', mappings)
    puts "  ✅ Generated #{mappings.length} script level mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_levels_script_level_mappings
    puts "📝 Generating levels script level mappings..."
    
    # Levels script levels use composite key: level_key + script_name + lesson_key + position
    lsls = LevelsScriptLevel.all.includes(:level, :script_level, script_level: [:script, :lesson])
    mappings = {}
    
    lsls.each do |lsl|
      next if lsl.guid.blank?
      key = "#{lsl.level.key}:#{lsl.script_level.script.name}:#{lsl.script_level.lesson.key}:#{lsl.script_level.position}"
      mappings[key] = lsl.guid
    end
    
    write_mapping_file('levels_script_levels.json', mappings)
    puts "  ✅ Generated #{mappings.length} levels script level mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_course_script_mappings
    puts "📝 Generating course script mappings..."
    
    # Course scripts use composite key: course_key + script_name
    course_scripts = CourseScript.all.includes(:course, :script)
    mappings = {}
    
    course_scripts.each do |cs|
      next if cs.guid.blank?
      key = "#{cs.course.key}:#{cs.script.name}"
      mappings[key] = cs.guid
    end
    
    write_mapping_file('course_scripts.json', mappings)
    puts "  ✅ Generated #{mappings.length} course script mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_unit_group_resource_mappings
    puts "📝 Generating unit group resource mappings..."
    
    # Unit group resources use composite key: unit_group_key + resource_key
    resources = UnitGroupsResource.all.includes(:unit_group, :resource)
    mappings = {}
    
    resources.each do |resource|
      next if resource.guid.blank?
      key = "#{resource.unit_group.key}:#{resource.resource.key}"
      mappings[key] = resource.guid
    end
    
    write_mapping_file('unit_group_resources.json', mappings)
    puts "  ✅ Generated #{mappings.length} unit group resource mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_unit_group_student_resource_mappings
    puts "📝 Generating unit group student resource mappings..."
    
    # Unit group student resources use composite key: unit_group_key + resource_key
    resources = UnitGroupsStudentResource.all.includes(:unit_group, :resource)
    mappings = {}
    
    resources.each do |resource|
      next if resource.guid.blank?
      key = "#{resource.unit_group.key}:#{resource.resource.key}"
      mappings[key] = resource.guid
    end
    
    write_mapping_file('unit_group_student_resources.json', mappings)
    puts "  ✅ Generated #{mappings.length} unit group student resource mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_script_resource_mappings
    puts "📝 Generating script resource mappings..."
    
    # Script resources use composite key: script_name + resource_key
    resources = ScriptsResource.all.includes(:script, :resource)
    mappings = {}
    
    resources.each do |resource|
      next if resource.guid.blank?
      key = "#{resource.script.name}:#{resource.resource.key}"
      mappings[key] = resource.guid
    end
    
    write_mapping_file('script_resources.json', mappings)
    puts "  ✅ Generated #{mappings.length} script resource mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_script_student_resource_mappings
    puts "📝 Generating script student resource mappings..."
    
    # Script student resources use composite key: script_name + resource_key
    resources = ScriptsStudentResource.all.includes(:script, :resource)
    mappings = {}
    
    resources.each do |resource|
      next if resource.guid.blank?
      key = "#{resource.script.name}:#{resource.resource.key}"
      mappings[key] = resource.guid
    end
    
    write_mapping_file('script_student_resources.json', mappings)
    puts "  ✅ Generated #{mappings.length} script student resource mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_lesson_resource_mappings
    puts "📝 Generating lesson resource mappings..."
    
    # Lesson resources use composite key: lesson_key + resource_key
    resources = LessonsResource.all.includes(:lesson, :resource)
    mappings = {}
    
    resources.each do |resource|
      next if resource.guid.blank?
      key = "#{resource.lesson.key}:#{resource.resource.key}"
      mappings[key] = resource.guid
    end
    
    write_mapping_file('lesson_resources.json', mappings)
    puts "  ✅ Generated #{mappings.length} lesson resource mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_lesson_standard_mappings
    puts "📝 Generating lesson standard mappings..."
    
    # Lesson standards use composite key: lesson_key + standard_key
    standards = LessonsStandard.all.includes(:lesson, :standard)
    mappings = {}
    
    standards.each do |standard|
      next if standard.guid.blank?
      key = "#{standard.lesson.key}:#{standard.standard.key}"
      mappings[key] = standard.guid
    end
    
    write_mapping_file('lesson_standards.json', mappings)
    puts "  ✅ Generated #{mappings.length} lesson standard mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_lesson_vocabulary_mappings
    puts "📝 Generating lesson vocabulary mappings..."
    
    # Lesson vocabularies use composite key: lesson_key + vocabulary_key
    vocabularies = LessonsVocabulary.all.includes(:lesson, :vocabulary)
    mappings = {}
    
    vocabularies.each do |vocab|
      next if vocab.guid.blank?
      key = "#{vocab.lesson.key}:#{vocab.vocabulary.key}"
      mappings[key] = vocab.guid
    end
    
    write_mapping_file('lesson_vocabularies.json', mappings)
    puts "  ✅ Generated #{mappings.length} lesson vocabulary mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_lesson_programming_expression_mappings
    puts "📝 Generating lesson programming expression mappings..."
    
    # Lesson programming expressions use composite key: lesson_key + programming_expression_key
    expressions = LessonsProgrammingExpression.all.includes(:lesson, :programming_expression)
    mappings = {}
    
    expressions.each do |expr|
      next if expr.guid.blank?
      key = "#{expr.lesson.key}:#{expr.programming_expression.key}"
      mappings[key] = expr.guid
    end
    
    write_mapping_file('lesson_programming_expressions.json', mappings)
    puts "  ✅ Generated #{mappings.length} lesson programming expression mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_learning_goal_evidence_level_mappings
    puts "📝 Generating learning goal evidence level mappings..."
    
    # Learning goal evidence levels use composite key: learning_goal_key + evidence_level
    levels = LearningGoalEvidenceLevel.all.includes(:learning_goal)
    mappings = {}
    
    levels.each do |level|
      next if level.guid.blank?
      key = "#{level.learning_goal.key}:#{level.evidence_level}"
      mappings[key] = level.guid
    end
    
    write_mapping_file('learning_goal_evidence_levels.json', mappings)
    puts "  ✅ Generated #{mappings.length} learning goal evidence level mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def generate_lesson_opportunity_standard_mappings
    puts "📝 Generating lesson opportunity standard mappings..."
    
    # Lesson opportunity standards use composite key: lesson_key + standard_key
    standards = LessonsOpportunityStandard.all.includes(:lesson, :standard)
    mappings = {}
    
    standards.each do |standard|
      next if standard.guid.blank?
      key = "#{standard.lesson.key}:#{standard.standard.key}"
      mappings[key] = standard.guid
    end
    
    write_mapping_file('lesson_opportunity_standards.json', mappings)
    puts "  ✅ Generated #{mappings.length} lesson opportunity standard mappings"
    @stats[:total_mappings] += mappings.length
    @stats[:files_generated] += 1
  end
  
  def create_mapping_summary
    puts "📝 Creating mapping summary..."
    
    summary = {
      generated_at: Time.current.iso8601,
      mapping_files: Dir.glob(File.join(@mappings_dir, '*.json')).map { |f| File.basename(f) },
      total_files: @stats[:files_generated],
      total_mappings: @stats[:total_mappings],
      usage: {
        description: "These mapping files link existing unique identifiers to GUIDs",
        purpose: "Enable consistent GUID assignment across environments during seeding",
        integration: "Used by seeding process to assign same GUIDs to same content"
      },
      file_locations: {
        mappings_dir: @mappings_dir.to_s,
        committed_to_codebase: true
      }
    }
    
    # Write summary file
    File.write(File.join(@mappings_dir, 'mapping_summary.json'), JSON.pretty_generate(summary))
    puts "  ✅ Mapping summary created"
  end
  
  def print_final_stats
    puts ""
    puts "📊 GENERATION STATISTICS"
    puts "=" * 60
    puts "Total mapping files generated: #{@stats[:files_generated]}"
    puts "Total mappings created: #{@stats[:total_mappings]}"
    puts "Errors encountered: #{@stats[:errors]}"
    puts ""
  end
  
  def write_mapping_file(filename, mappings)
    file_path = File.join(@mappings_dir, filename)
    File.write(file_path, JSON.pretty_generate(mappings))
  end
end