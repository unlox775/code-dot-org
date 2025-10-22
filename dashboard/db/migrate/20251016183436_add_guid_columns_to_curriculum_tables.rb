# Migration: Add GUID columns to curriculum tables
# This migration adds GUID columns to CURRICULUM CONTENT tables only
# EXCLUDES user progress tables (user_levels, user_scripts, activities)
# User progress tables should remain ID-based for performance

class AddGuidColumnsToCurriculumTables < ActiveRecord::Migration[7.0]
  def up
    # Add GUID columns to all 27 curriculum content tables
    
    # Core curriculum content tables (13)
    add_guid_column :scripts, 'scripts'
    add_guid_column :stages, 'lessons'  # stages table represents lessons
    add_guid_column :levels, 'levels'
    add_guid_column :lesson_groups, 'lesson_groups'
    add_guid_column :lesson_activities, 'lesson_activities'
    add_guid_column :activity_sections, 'activity_sections'
    add_guid_column :courses, 'courses'
    add_guid_column :course_offerings, 'course_offerings'
    add_guid_column :course_versions, 'course_versions'
    add_guid_column :objectives, 'objectives'
    add_guid_column :programming_expressions, 'programming_expressions'
    add_guid_column :rubrics, 'rubrics'
    add_guid_column :learning_goals, 'learning_goals'
    
    # Curriculum organization tables (3)
    add_guid_column :unit_groups, 'unit_groups'
    add_guid_column :script_levels, 'script_levels'
    add_guid_column :levels_script_levels, 'levels_script_levels'
    
    # Curriculum resource tables (8)
    add_guid_column :course_scripts, 'course_scripts'
    add_guid_column :unit_groups_resources, 'unit_groups_resources'
    add_guid_column :unit_groups_student_resources, 'unit_groups_student_resources'
    add_guid_column :scripts_resources, 'scripts_resources'
    add_guid_column :scripts_student_resources, 'scripts_student_resources'
    add_guid_column :lessons_resources, 'lessons_resources'
    add_guid_column :stages_standards, 'stages_standards'
    add_guid_column :lessons_vocabularies, 'lessons_vocabularies'
    
    # Curriculum join tables (3)
    add_guid_column :lessons_programming_expressions, 'lessons_programming_expressions'
    add_guid_column :learning_goal_evidence_levels, 'learning_goal_evidence_levels'
    add_guid_column :lessons_opportunity_standards, 'lessons_opportunity_standards'
    
    # Generate GUIDs for existing data
    generate_guids_for_existing_data
    
    # Add unique indexes on GUID columns
    add_guid_indexes
  end
  
  def down
    # Remove GUID indexes
    remove_guid_indexes
    
    # Remove GUID columns
    remove_guid_columns
  end
  
  private
  
  def add_guid_column(table_name, description)
    puts "Adding GUID column to #{table_name} (#{description})"
    add_column table_name, :guid, :string, limit: 36, null: false, default: ''
  end
  
  def generate_guids_for_existing_data
    puts "Generating GUIDs for existing data..."
    
    # Core curriculum content tables (13)
    generate_guids_for_table(:scripts, 'Script')
    generate_guids_for_table(:stages, 'Lesson')  # stages table represents lessons
    generate_guids_for_table(:levels, 'Level')
    generate_guids_for_table(:lesson_groups, 'LessonGroup')
    generate_guids_for_table(:lesson_activities, 'LessonActivity')
    generate_guids_for_table(:activity_sections, 'ActivitySection')
    generate_guids_for_table(:courses, 'Course')
    generate_guids_for_table(:course_offerings, 'CourseOffering')
    generate_guids_for_table(:course_versions, 'CourseVersion')
    generate_guids_for_table(:objectives, 'Objective')
    generate_guids_for_table(:programming_expressions, 'ProgrammingExpression')
    generate_guids_for_table(:rubrics, 'Rubric')
    generate_guids_for_table(:learning_goals, 'LearningGoal')
    
    # Curriculum organization tables (3)
    generate_guids_for_table(:unit_groups, 'UnitGroup')
    generate_guids_for_table(:script_levels, 'ScriptLevel')
    generate_guids_for_table(:levels_script_levels, 'LevelsScriptLevel')
    
    # Curriculum resource tables (8)
    generate_guids_for_table(:course_scripts, 'CourseScript')
    generate_guids_for_table(:unit_groups_resources, 'UnitGroupResource')
    generate_guids_for_table(:unit_groups_student_resources, 'UnitGroupStudentResource')
    generate_guids_for_table(:scripts_resources, 'ScriptResource')
    generate_guids_for_table(:scripts_student_resources, 'ScriptStudentResource')
    generate_guids_for_table(:lessons_resources, 'LessonResource')
    generate_guids_for_table(:stages_standards, 'StageStandard')
    generate_guids_for_table(:lessons_vocabularies, 'LessonVocabulary')
    
    # Curriculum join tables (3)
    generate_guids_for_table(:lessons_programming_expressions, 'LessonsProgrammingExpression')
    generate_guids_for_table(:learning_goal_evidence_levels, 'LearningGoalEvidenceLevel')
    generate_guids_for_table(:lessons_opportunity_standards, 'LessonsOpportunityStandard')
  end
  
  def generate_guids_for_table(table_name, model_name)
    puts "  Generating GUIDs for #{table_name}..."
    
    # Use raw SQL for better performance with large datasets
    connection.execute("
      UPDATE #{table_name} 
      SET guid = UUID() 
      WHERE guid = '' OR guid IS NULL
    ")
    
    # Verify all records have GUIDs
    count = connection.select_value("SELECT COUNT(*) FROM #{table_name} WHERE guid = '' OR guid IS NULL")
    if count > 0
      raise "Failed to generate GUIDs for #{count} records in #{table_name}"
    end
    
    puts "  Generated GUIDs for #{table_name} (#{connection.select_value("SELECT COUNT(*) FROM #{table_name}")} records)"
  end
  
  def add_guid_indexes
    puts "Adding GUID indexes..."
    
    # Core curriculum content tables (13)
    add_index :scripts, :guid, unique: true, name: 'idx_scripts_guid'
    add_index :stages, :guid, unique: true, name: 'idx_lessons_guid'
    add_index :levels, :guid, unique: true, name: 'idx_levels_guid'
    add_index :lesson_groups, :guid, unique: true, name: 'idx_lesson_groups_guid'
    add_index :lesson_activities, :guid, unique: true, name: 'idx_lesson_activities_guid'
    add_index :activity_sections, :guid, unique: true, name: 'idx_activity_sections_guid'
    add_index :courses, :guid, unique: true, name: 'idx_courses_guid'
    add_index :course_offerings, :guid, unique: true, name: 'idx_course_offerings_guid'
    add_index :course_versions, :guid, unique: true, name: 'idx_course_versions_guid'
    add_index :objectives, :guid, unique: true, name: 'idx_objectives_guid'
    add_index :programming_expressions, :guid, unique: true, name: 'idx_programming_expressions_guid'
    add_index :rubrics, :guid, unique: true, name: 'idx_rubrics_guid'
    add_index :learning_goals, :guid, unique: true, name: 'idx_learning_goals_guid'
    
    # Curriculum organization tables (3)
    add_index :unit_groups, :guid, unique: true, name: 'idx_unit_groups_guid'
    add_index :script_levels, :guid, unique: true, name: 'idx_script_levels_guid'
    add_index :levels_script_levels, :guid, unique: true, name: 'idx_levels_script_levels_guid'
    
    # Curriculum resource tables (8)
    add_index :course_scripts, :guid, unique: true, name: 'idx_course_scripts_guid'
    add_index :unit_groups_resources, :guid, unique: true, name: 'idx_unit_groups_resources_guid'
    add_index :unit_groups_student_resources, :guid, unique: true, name: 'idx_unit_groups_student_resources_guid'
    add_index :scripts_resources, :guid, unique: true, name: 'idx_scripts_resources_guid'
    add_index :scripts_student_resources, :guid, unique: true, name: 'idx_scripts_student_resources_guid'
    add_index :lessons_resources, :guid, unique: true, name: 'idx_lessons_resources_guid'
    add_index :stages_standards, :guid, unique: true, name: 'idx_stages_standards_guid'
    add_index :lessons_vocabularies, :guid, unique: true, name: 'idx_lessons_vocabularies_guid'
    
    # Curriculum join tables (3)
    add_index :lessons_programming_expressions, :guid, unique: true, name: 'idx_lessons_programming_expressions_guid'
    add_index :learning_goal_evidence_levels, :guid, unique: true, name: 'idx_learning_goal_evidence_levels_guid'
    add_index :lessons_opportunity_standards, :guid, unique: true, name: 'idx_lessons_opportunity_standards_guid'
  end
  
  def remove_guid_indexes
    puts "Removing GUID indexes..."
    
    # Core curriculum content tables (13)
    remove_index :scripts, name: 'idx_scripts_guid'
    remove_index :stages, name: 'idx_lessons_guid'
    remove_index :levels, name: 'idx_levels_guid'
    remove_index :lesson_groups, name: 'idx_lesson_groups_guid'
    remove_index :lesson_activities, name: 'idx_lesson_activities_guid'
    remove_index :activity_sections, name: 'idx_activity_sections_guid'
    remove_index :courses, name: 'idx_courses_guid'
    remove_index :course_offerings, name: 'idx_course_offerings_guid'
    remove_index :course_versions, name: 'idx_course_versions_guid'
    remove_index :objectives, name: 'idx_objectives_guid'
    remove_index :programming_expressions, name: 'idx_programming_expressions_guid'
    remove_index :rubrics, name: 'idx_rubrics_guid'
    remove_index :learning_goals, name: 'idx_learning_goals_guid'
    
    # Curriculum organization tables (3)
    remove_index :unit_groups, name: 'idx_unit_groups_guid'
    remove_index :script_levels, name: 'idx_script_levels_guid'
    remove_index :levels_script_levels, name: 'idx_levels_script_levels_guid'
    
    # Curriculum resource tables (8)
    remove_index :course_scripts, name: 'idx_course_scripts_guid'
    remove_index :unit_groups_resources, name: 'idx_unit_groups_resources_guid'
    remove_index :unit_groups_student_resources, name: 'idx_unit_groups_student_resources_guid'
    remove_index :scripts_resources, name: 'idx_scripts_resources_guid'
    remove_index :scripts_student_resources, name: 'idx_scripts_student_resources_guid'
    remove_index :lessons_resources, name: 'idx_lessons_resources_guid'
    remove_index :stages_standards, name: 'idx_stages_standards_guid'
    remove_index :lessons_vocabularies, name: 'idx_lessons_vocabularies_guid'
    
    # Curriculum join tables (3)
    remove_index :lessons_programming_expressions, name: 'idx_lessons_programming_expressions_guid'
    remove_index :learning_goal_evidence_levels, name: 'idx_learning_goal_evidence_levels_guid'
    remove_index :lessons_opportunity_standards, name: 'idx_lessons_opportunity_standards_guid'
  end
  
  def remove_guid_columns
    puts "Removing GUID columns..."
    
    # Core curriculum content tables (13)
    remove_column :scripts, :guid
    remove_column :stages, :guid
    remove_column :levels, :guid
    remove_column :lesson_groups, :guid
    remove_column :lesson_activities, :guid
    remove_column :activity_sections, :guid
    remove_column :courses, :guid
    remove_column :course_offerings, :guid
    remove_column :course_versions, :guid
    remove_column :objectives, :guid
    remove_column :programming_expressions, :guid
    remove_column :rubrics, :guid
    remove_column :learning_goals, :guid
    
    # Curriculum organization tables (3)
    remove_column :unit_groups, :guid
    remove_column :script_levels, :guid
    remove_column :levels_script_levels, :guid
    
    # Curriculum resource tables (8)
    remove_column :course_scripts, :guid
    remove_column :unit_groups_resources, :guid
    remove_column :unit_groups_student_resources, :guid
    remove_column :scripts_resources, :guid
    remove_column :scripts_student_resources, :guid
    remove_column :lessons_resources, :guid
    remove_column :stages_standards, :guid
    remove_column :lessons_vocabularies, :guid
    
    # Curriculum join tables (3)
    remove_column :lessons_programming_expressions, :guid
    remove_column :learning_goal_evidence_levels, :guid
    remove_column :lessons_opportunity_standards, :guid
  end
end