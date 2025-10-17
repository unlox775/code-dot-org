# Migration: Add GUID columns to curriculum tables
# This migration adds GUID columns to CURRICULUM CONTENT tables only
# EXCLUDES user progress tables (user_levels, user_scripts, activities)
# User progress tables should remain ID-based for performance

class AddGuidColumnsToCurriculumTables < ActiveRecord::Migration[7.0]
  def up
    # Add GUID columns to primary curriculum tables
    add_guid_column :scripts, 'scripts'
    add_guid_column :script_levels, 'script_levels'
    add_guid_column :levels, 'levels'
    add_guid_column :lesson_groups, 'lesson_groups'
    add_guid_column :stages, 'lessons'  # stages table represents lessons
    add_guid_column :lesson_activities, 'lesson_activities'
    add_guid_column :activity_sections, 'activity_sections'
    add_guid_column :unit_groups, 'unit_groups'
    add_guid_column :course_versions, 'course_versions'
    add_guid_column :course_offerings, 'course_offerings'
    add_guid_column :courses, 'courses'
    
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
    
    # Generate GUIDs for each table
    generate_guids_for_table(:scripts, 'Script')
    generate_guids_for_table(:script_levels, 'ScriptLevel')
    generate_guids_for_table(:levels, 'Level')
    generate_guids_for_table(:lesson_groups, 'LessonGroup')
    generate_guids_for_table(:stages, 'Lesson')  # stages table represents lessons
    generate_guids_for_table(:lesson_activities, 'LessonActivity')
    generate_guids_for_table(:activity_sections, 'ActivitySection')
    generate_guids_for_table(:unit_groups, 'UnitGroup')
    generate_guids_for_table(:course_versions, 'CourseVersion')
    generate_guids_for_table(:course_offerings, 'CourseOffering')
    generate_guids_for_table(:courses, 'Course')
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
    
    add_index :scripts, :guid, unique: true, name: 'idx_scripts_guid'
    add_index :script_levels, :guid, unique: true, name: 'idx_script_levels_guid'
    add_index :levels, :guid, unique: true, name: 'idx_levels_guid'
    add_index :lesson_groups, :guid, unique: true, name: 'idx_lesson_groups_guid'
    add_index :stages, :guid, unique: true, name: 'idx_lessons_guid'
    add_index :lesson_activities, :guid, unique: true, name: 'idx_lesson_activities_guid'
    add_index :activity_sections, :guid, unique: true, name: 'idx_activity_sections_guid'
    add_index :unit_groups, :guid, unique: true, name: 'idx_unit_groups_guid'
    add_index :course_versions, :guid, unique: true, name: 'idx_course_versions_guid'
    add_index :course_offerings, :guid, unique: true, name: 'idx_course_offerings_guid'
    add_index :courses, :guid, unique: true, name: 'idx_courses_guid'
  end
  
  def remove_guid_indexes
    puts "Removing GUID indexes..."
    
    remove_index :scripts, name: 'idx_scripts_guid'
    remove_index :script_levels, name: 'idx_script_levels_guid'
    remove_index :levels, name: 'idx_levels_guid'
    remove_index :lesson_groups, name: 'idx_lesson_groups_guid'
    remove_index :stages, name: 'idx_lessons_guid'
    remove_index :lesson_activities, name: 'idx_lesson_activities_guid'
    remove_index :activity_sections, name: 'idx_activity_sections_guid'
    remove_index :unit_groups, name: 'idx_unit_groups_guid'
    remove_index :course_versions, name: 'idx_course_versions_guid'
    remove_index :course_offerings, name: 'idx_course_offerings_guid'
    remove_index :courses, name: 'idx_courses_guid'
  end
  
  def remove_guid_columns
    puts "Removing GUID columns..."
    
    remove_column :scripts, :guid
    remove_column :script_levels, :guid
    remove_column :levels, :guid
    remove_column :lesson_groups, :guid
    remove_column :stages, :guid
    remove_column :lesson_activities, :guid
    remove_column :activity_sections, :guid
    remove_column :unit_groups, :guid
    remove_column :course_versions, :guid
    remove_column :course_offerings, :guid
    remove_column :courses, :guid
  end
end