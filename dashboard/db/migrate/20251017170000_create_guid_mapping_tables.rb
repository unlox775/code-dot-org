# Migration: Create GUID mapping tables
# This migration creates mapping tables that link existing unique identifiers (keys) to GUIDs
# This allows us to maintain existing file structure while enabling GUID-based synchronization

class CreateGuidMappingTables < ActiveRecord::Migration[7.0]
  def up
    create_guid_mapping_tables
    create_mapping_indexes
    populate_initial_mappings
  end
  
  def down
    drop_guid_mapping_tables
  end
  
  private
  
  def create_guid_mapping_tables
    puts "Creating GUID mapping tables..."
    
    # Core curriculum content mappings (13 tables)
    create_table :script_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :lesson_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :level_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :lesson_group_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :lesson_activity_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :activity_section_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :course_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :course_offering_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :course_version_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :objective_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :programming_expression_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :rubric_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :learning_goal_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    # Curriculum organization mappings (3 tables)
    create_table :unit_group_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :script_level_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :levels_script_level_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    # Curriculum resource mappings (8 tables)
    create_table :course_script_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :unit_group_resource_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :unit_group_student_resource_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :script_resource_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :script_student_resource_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :lesson_resource_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :lesson_standard_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :lesson_vocabulary_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    # Curriculum join table mappings (3 tables)
    create_table :lesson_programming_expression_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :learning_goal_evidence_level_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
    
    create_table :lesson_opportunity_standard_guid_mappings do |t|
      t.string :key, null: false, limit: 255
      t.string :guid, null: false, limit: 36
      t.timestamps
    end
  end
  
  def create_mapping_indexes
    puts "Creating mapping table indexes..."
    
    # Create unique indexes on key columns
    mapping_tables = [
      'script_guid_mappings', 'lesson_guid_mappings', 'level_guid_mappings',
      'lesson_group_guid_mappings', 'lesson_activity_guid_mappings', 'activity_section_guid_mappings',
      'course_guid_mappings', 'course_offering_guid_mappings', 'course_version_guid_mappings',
      'objective_guid_mappings', 'programming_expression_guid_mappings', 'rubric_guid_mappings',
      'learning_goal_guid_mappings', 'unit_group_guid_mappings', 'script_level_guid_mappings',
      'levels_script_level_guid_mappings', 'course_script_guid_mappings', 'unit_group_resource_guid_mappings',
      'unit_group_student_resource_guid_mappings', 'script_resource_guid_mappings',
      'script_student_resource_guid_mappings', 'lesson_resource_guid_mappings',
      'lesson_standard_guid_mappings', 'lesson_vocabulary_guid_mappings',
      'lesson_programming_expression_guid_mappings', 'learning_goal_evidence_level_guid_mappings',
      'lesson_opportunity_standard_guid_mappings'
    ]
    
    mapping_tables.each do |table|
      add_index table, :key, unique: true, name: "idx_#{table}_key"
      add_index table, :guid, unique: true, name: "idx_#{table}_guid"
    end
  end
  
  def populate_initial_mappings
    puts "Populating initial GUID mappings from existing data..."
    
    # Populate mappings for all existing curriculum data
    populate_script_mappings
    populate_lesson_mappings
    populate_level_mappings
    populate_lesson_group_mappings
    populate_lesson_activity_mappings
    populate_activity_section_mappings
    populate_course_mappings
    populate_course_offering_mappings
    populate_course_version_mappings
    populate_objective_mappings
    populate_programming_expression_mappings
    populate_rubric_mappings
    populate_learning_goal_mappings
    populate_unit_group_mappings
    populate_script_level_mappings
    populate_levels_script_level_mappings
    populate_course_script_mappings
    populate_unit_group_resource_mappings
    populate_unit_group_student_resource_mappings
    populate_script_resource_mappings
    populate_script_student_resource_mappings
    populate_lesson_resource_mappings
    populate_lesson_standard_mappings
    populate_lesson_vocabulary_mappings
    populate_lesson_programming_expression_mappings
    populate_learning_goal_evidence_level_mappings
    populate_lesson_opportunity_standard_mappings
  end
  
  def populate_script_mappings
    puts "  Populating script GUID mappings..."
    connection.execute("
      INSERT INTO script_guid_mappings (key, guid, created_at, updated_at)
      SELECT name, guid, NOW(), NOW()
      FROM scripts
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_lesson_mappings
    puts "  Populating lesson GUID mappings..."
    connection.execute("
      INSERT INTO lesson_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM stages
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_level_mappings
    puts "  Populating level GUID mappings..."
    connection.execute("
      INSERT INTO level_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM levels
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_lesson_group_mappings
    puts "  Populating lesson group GUID mappings..."
    connection.execute("
      INSERT INTO lesson_group_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM lesson_groups
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_lesson_activity_mappings
    puts "  Populating lesson activity GUID mappings..."
    connection.execute("
      INSERT INTO lesson_activity_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM lesson_activities
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_activity_section_mappings
    puts "  Populating activity section GUID mappings..."
    connection.execute("
      INSERT INTO activity_section_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM activity_sections
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_course_mappings
    puts "  Populating course GUID mappings..."
    connection.execute("
      INSERT INTO course_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM courses
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_course_offering_mappings
    puts "  Populating course offering GUID mappings..."
    connection.execute("
      INSERT INTO course_offering_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM course_offerings
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_course_version_mappings
    puts "  Populating course version GUID mappings..."
    connection.execute("
      INSERT INTO course_version_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM course_versions
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_objective_mappings
    puts "  Populating objective GUID mappings..."
    connection.execute("
      INSERT INTO objective_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM objectives
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_programming_expression_mappings
    puts "  Populating programming expression GUID mappings..."
    connection.execute("
      INSERT INTO programming_expression_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM programming_expressions
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_rubric_mappings
    puts "  Populating rubric GUID mappings..."
    connection.execute("
      INSERT INTO rubric_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM rubrics
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_learning_goal_mappings
    puts "  Populating learning goal GUID mappings..."
    connection.execute("
      INSERT INTO learning_goal_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM learning_goals
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_unit_group_mappings
    puts "  Populating unit group GUID mappings..."
    connection.execute("
      INSERT INTO unit_group_guid_mappings (key, guid, created_at, updated_at)
      SELECT key, guid, NOW(), NOW()
      FROM unit_groups
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_script_level_mappings
    puts "  Populating script level GUID mappings..."
    # ScriptLevels don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO script_level_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(script_id, '-', stage_id, '-', position), guid, NOW(), NOW()
      FROM script_levels
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_levels_script_level_mappings
    puts "  Populating levels script level GUID mappings..."
    # LevelsScriptLevels don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO levels_script_level_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(level_id, '-', script_level_id), guid, NOW(), NOW()
      FROM levels_script_levels
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_course_script_mappings
    puts "  Populating course script GUID mappings..."
    # CourseScripts don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO course_script_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(course_id, '-', script_id), guid, NOW(), NOW()
      FROM course_scripts
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_unit_group_resource_mappings
    puts "  Populating unit group resource GUID mappings..."
    # UnitGroupResources don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO unit_group_resource_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(unit_group_id, '-', resource_id), guid, NOW(), NOW()
      FROM unit_groups_resources
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_unit_group_student_resource_mappings
    puts "  Populating unit group student resource GUID mappings..."
    # UnitGroupStudentResources don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO unit_group_student_resource_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(unit_group_id, '-', resource_id), guid, NOW(), NOW()
      FROM unit_groups_student_resources
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_script_resource_mappings
    puts "  Populating script resource GUID mappings..."
    # ScriptResources don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO script_resource_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(script_id, '-', resource_id), guid, NOW(), NOW()
      FROM scripts_resources
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_script_student_resource_mappings
    puts "  Populating script student resource GUID mappings..."
    # ScriptStudentResources don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO script_student_resource_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(script_id, '-', resource_id), guid, NOW(), NOW()
      FROM scripts_student_resources
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_lesson_resource_mappings
    puts "  Populating lesson resource GUID mappings..."
    # LessonsResources don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO lesson_resource_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(lesson_id, '-', resource_id), guid, NOW(), NOW()
      FROM lessons_resources
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_lesson_standard_mappings
    puts "  Populating lesson standard GUID mappings..."
    # LessonsStandards don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO lesson_standard_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(lesson_id, '-', standard_id), guid, NOW(), NOW()
      FROM stages_standards
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_lesson_vocabulary_mappings
    puts "  Populating lesson vocabulary GUID mappings..."
    # LessonsVocabularies don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO lesson_vocabulary_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(lesson_id, '-', vocabulary_id), guid, NOW(), NOW()
      FROM lessons_vocabularies
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_lesson_programming_expression_mappings
    puts "  Populating lesson programming expression GUID mappings..."
    # LessonsProgrammingExpressions don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO lesson_programming_expression_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(lesson_id, '-', programming_expression_id), guid, NOW(), NOW()
      FROM lessons_programming_expressions
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_learning_goal_evidence_level_mappings
    puts "  Populating learning goal evidence level GUID mappings..."
    # LearningGoalEvidenceLevels don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO learning_goal_evidence_level_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(learning_goal_id, '-', evidence_level), guid, NOW(), NOW()
      FROM learning_goal_evidence_levels
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def populate_lesson_opportunity_standard_mappings
    puts "  Populating lesson opportunity standard GUID mappings..."
    # LessonsOpportunityStandards don't have keys, so we'll use a composite key
    connection.execute("
      INSERT INTO lesson_opportunity_standard_guid_mappings (key, guid, created_at, updated_at)
      SELECT CONCAT(lesson_id, '-', standard_id), guid, NOW(), NOW()
      FROM lessons_opportunity_standards
      WHERE guid IS NOT NULL AND guid != ''
    ")
  end
  
  def drop_guid_mapping_tables
    puts "Dropping GUID mapping tables..."
    
    mapping_tables = [
      'script_guid_mappings', 'lesson_guid_mappings', 'level_guid_mappings',
      'lesson_group_guid_mappings', 'lesson_activity_guid_mappings', 'activity_section_guid_mappings',
      'course_guid_mappings', 'course_offering_guid_mappings', 'course_version_guid_mappings',
      'objective_guid_mappings', 'programming_expression_guid_mappings', 'rubric_guid_mappings',
      'learning_goal_guid_mappings', 'unit_group_guid_mappings', 'script_level_guid_mappings',
      'levels_script_level_guid_mappings', 'course_script_guid_mappings', 'unit_group_resource_guid_mappings',
      'unit_group_student_resource_guid_mappings', 'script_resource_guid_mappings',
      'script_student_resource_guid_mappings', 'lesson_resource_guid_mappings',
      'lesson_standard_guid_mappings', 'lesson_vocabulary_guid_mappings',
      'lesson_programming_expression_guid_mappings', 'learning_goal_evidence_level_guid_mappings',
      'lesson_opportunity_standard_guid_mappings'
    ]
    
    mapping_tables.each do |table|
      drop_table table if table_exists?(table)
    end
  end
end