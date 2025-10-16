# Migration: Add GUID foreign key columns to dependent tables
# This migration adds GUID-based foreign key columns to all tables
# that reference curriculum tables, enabling dual-key support

class AddGuidForeignKeysToDependentTables < ActiveRecord::Migration[7.0]
  def up
    # Add GUID foreign key columns to tables that reference curriculum tables
    add_guid_foreign_keys
    
    # Populate GUID foreign keys based on existing ID relationships
    populate_guid_foreign_keys
    
    # Add indexes on GUID foreign key columns
    add_guid_foreign_key_indexes
  end
  
  def down
    # Remove GUID foreign key indexes
    remove_guid_foreign_key_indexes
    
    # Remove GUID foreign key columns
    remove_guid_foreign_keys
  end
  
  private
  
  def add_guid_foreign_keys
    puts "Adding GUID foreign key columns..."
    
    # User progress tracking tables
    add_column :user_levels, :level_guid, :string, limit: 36
    add_column :user_levels, :script_guid, :string, limit: 36
    add_column :user_scripts, :script_guid, :string, limit: 36
    
    # Script level relationships
    add_column :script_levels, :script_guid, :string, limit: 36
    add_column :script_levels, :lesson_guid, :string, limit: 36
    
    # Level relationships
    add_column :levels_script_levels, :level_guid, :string, limit: 36
    add_column :levels_script_levels, :script_level_guid, :string, limit: 36
    
    # Lesson relationships
    add_column :lesson_groups, :script_guid, :string, limit: 36
    add_column :lesson_activities, :lesson_guid, :string, limit: 36
    add_column :activity_sections, :lesson_activity_guid, :string, limit: 36
    
    # Course relationships
    add_column :course_versions, :content_root_guid, :string, limit: 36
    add_column :course_versions, :course_offering_guid, :string, limit: 36
    add_column :course_scripts, :course_guid, :string, limit: 36
    add_column :course_scripts, :script_guid, :string, limit: 36
    
    # Resource relationships
    add_column :scripts_resources, :script_guid, :string, limit: 36
    add_column :scripts_student_resources, :script_guid, :string, limit: 36
    add_column :lessons_resources, :lesson_guid, :string, limit: 36
    add_column :unit_groups_resources, :unit_group_guid, :string, limit: 36
    add_column :unit_groups_student_resources, :unit_group_guid, :string, limit: 36
    
    # Concept relationships
    add_column :concepts_levels, :level_guid, :string, limit: 36
    add_column :level_concept_difficulties, :level_guid, :string, limit: 36
    
    # Level hierarchy relationships
    add_column :parent_levels_child_levels, :parent_level_guid, :string, limit: 36
    add_column :parent_levels_child_levels, :child_level_guid, :string, limit: 36
    add_column :contained_levels, :level_group_level_guid, :string, limit: 36
    add_column :contained_levels, :contained_level_guid, :string, limit: 36
    
    # Section relationships
    add_column :section_hidden_scripts, :script_guid, :string, limit: 36
    add_column :section_hidden_stages, :lesson_guid, :string, limit: 36
    
    # PLC relationships
    add_column :plc_course_units, :script_guid, :string, limit: 36
    add_column :plc_courses, :course_guid, :string, limit: 36
    
    # Standards relationships
    add_column :lessons_standards, :lesson_guid, :string, limit: 36
    add_column :lessons_opportunity_standards, :lesson_guid, :string, limit: 36
    add_column :stages_standards, :lesson_guid, :string, limit: 36
    
    # Programming expression relationships
    add_column :lessons_programming_expressions, :lesson_guid, :string, limit: 36
    
    # Vocabulary relationships
    add_column :lessons_vocabularies, :lesson_guid, :string, limit: 36
    
    # Skills relationships
    add_column :levels_skills, :level_guid, :string, limit: 36
    
    # AI relationships
    add_column :ai_lesson_summaries, :lesson_guid, :string, limit: 36
    
    # Learning goal relationships
    add_column :learning_goal_evidence_levels, :learning_goal_guid, :string, limit: 36
  end
  
  def populate_guid_foreign_keys
    puts "Populating GUID foreign keys..."
    
    # User progress tracking
    populate_user_levels_guids
    populate_user_scripts_guids
    
    # Script level relationships
    populate_script_levels_guids
    
    # Level relationships
    populate_levels_script_levels_guids
    
    # Lesson relationships
    populate_lesson_relationships_guids
    
    # Course relationships
    populate_course_relationships_guids
    
    # Resource relationships
    populate_resource_relationships_guids
    
    # Other relationships
    populate_other_relationships_guids
  end
  
  def populate_user_levels_guids
    puts "  Populating user_levels GUIDs..."
    
    # Populate level_guid
    connection.execute("
      UPDATE user_levels ul 
      JOIN levels l ON ul.level_id = l.id 
      SET ul.level_guid = l.guid
    ")
    
    # Populate script_guid
    connection.execute("
      UPDATE user_levels ul 
      JOIN scripts s ON ul.script_id = s.id 
      SET ul.script_guid = s.guid
    ")
  end
  
  def populate_user_scripts_guids
    puts "  Populating user_scripts GUIDs..."
    
    connection.execute("
      UPDATE user_scripts us 
      JOIN scripts s ON us.script_id = s.id 
      SET us.script_guid = s.guid
    ")
  end
  
  def populate_script_levels_guids
    puts "  Populating script_levels GUIDs..."
    
    # Populate script_guid
    connection.execute("
      UPDATE script_levels sl 
      JOIN scripts s ON sl.script_id = s.id 
      SET sl.script_guid = s.guid
    ")
    
    # Populate lesson_guid (stages table represents lessons)
    connection.execute("
      UPDATE script_levels sl 
      JOIN stages st ON sl.stage_id = st.id 
      SET sl.lesson_guid = st.guid
    ")
  end
  
  def populate_levels_script_levels_guids
    puts "  Populating levels_script_levels GUIDs..."
    
    # Populate level_guid
    connection.execute("
      UPDATE levels_script_levels lsl 
      JOIN levels l ON lsl.level_id = l.id 
      SET lsl.level_guid = l.guid
    ")
    
    # Populate script_level_guid
    connection.execute("
      UPDATE levels_script_levels lsl 
      JOIN script_levels sl ON lsl.script_level_id = sl.id 
      SET lsl.script_level_guid = sl.guid
    ")
  end
  
  def populate_lesson_relationships_guids
    puts "  Populating lesson relationships GUIDs..."
    
    # Lesson groups
    connection.execute("
      UPDATE lesson_groups lg 
      JOIN scripts s ON lg.script_id = s.id 
      SET lg.script_guid = s.guid
    ")
    
    # Lesson activities
    connection.execute("
      UPDATE lesson_activities la 
      JOIN stages st ON la.lesson_id = st.id 
      SET la.lesson_guid = st.guid
    ")
    
    # Activity sections
    connection.execute("
      UPDATE activity_sections asec 
      JOIN lesson_activities la ON asec.lesson_activity_id = la.id 
      SET asec.lesson_activity_guid = la.guid
    ")
  end
  
  def populate_course_relationships_guids
    puts "  Populating course relationships GUIDs..."
    
    # Course versions
    connection.execute("
      UPDATE course_versions cv 
      JOIN unit_groups ug ON cv.content_root_id = ug.id 
      SET cv.content_root_guid = ug.guid
    ")
    
    connection.execute("
      UPDATE course_versions cv 
      JOIN course_offerings co ON cv.course_offering_id = co.id 
      SET cv.course_offering_guid = co.guid
    ")
    
    # Course scripts
    connection.execute("
      UPDATE course_scripts cs 
      JOIN courses c ON cs.course_id = c.id 
      SET cs.course_guid = c.guid
    ")
    
    connection.execute("
      UPDATE course_scripts cs 
      JOIN scripts s ON cs.script_id = s.id 
      SET cs.script_guid = s.guid
    ")
  end
  
  def populate_resource_relationships_guids
    puts "  Populating resource relationships GUIDs..."
    
    # Script resources
    connection.execute("
      UPDATE scripts_resources sr 
      JOIN scripts s ON sr.script_id = s.id 
      SET sr.script_guid = s.guid
    ")
    
    connection.execute("
      UPDATE scripts_student_resources ssr 
      JOIN scripts s ON ssr.script_id = s.id 
      SET ssr.script_guid = s.guid
    ")
    
    # Lesson resources
    connection.execute("
      UPDATE lessons_resources lr 
      JOIN stages st ON lr.lesson_id = st.id 
      SET lr.lesson_guid = st.guid
    ")
    
    # Unit group resources
    connection.execute("
      UPDATE unit_groups_resources ugr 
      JOIN unit_groups ug ON ugr.unit_group_id = ug.id 
      SET ugr.unit_group_guid = ug.guid
    ")
    
    connection.execute("
      UPDATE unit_groups_student_resources ugsr 
      JOIN unit_groups ug ON ugsr.unit_group_id = ug.id 
      SET ugsr.unit_group_guid = ug.guid
    ")
  end
  
  def populate_other_relationships_guids
    puts "  Populating other relationships GUIDs..."
    
    # Concept relationships
    connection.execute("
      UPDATE concepts_levels cl 
      JOIN levels l ON cl.level_id = l.id 
      SET cl.level_guid = l.guid
    ")
    
    connection.execute("
      UPDATE level_concept_difficulties lcd 
      JOIN levels l ON lcd.level_id = l.id 
      SET lcd.level_guid = l.guid
    ")
    
    # Level hierarchy
    connection.execute("
      UPDATE parent_levels_child_levels plcl 
      JOIN levels l ON plcl.parent_level_id = l.id 
      SET plcl.parent_level_guid = l.guid
    ")
    
    connection.execute("
      UPDATE parent_levels_child_levels plcl 
      JOIN levels l ON plcl.child_level_id = l.id 
      SET plcl.child_level_guid = l.guid
    ")
    
    # Section relationships
    connection.execute("
      UPDATE section_hidden_scripts shs 
      JOIN scripts s ON shs.script_id = s.id 
      SET shs.script_guid = s.guid
    ")
    
    connection.execute("
      UPDATE section_hidden_stages shs 
      JOIN stages st ON shs.stage_id = st.id 
      SET shs.lesson_guid = st.guid
    ")
    
    # PLC relationships
    connection.execute("
      UPDATE plc_course_units pcu 
      JOIN scripts s ON pcu.script_id = s.id 
      SET pcu.script_guid = s.guid
    ")
    
    connection.execute("
      UPDATE plc_courses pc 
      JOIN courses c ON pc.course_id = c.id 
      SET pc.course_guid = c.guid
    ")
    
    # Standards relationships
    connection.execute("
      UPDATE lessons_standards ls 
      JOIN stages st ON ls.lesson_id = st.id 
      SET ls.lesson_guid = st.guid
    ")
    
    connection.execute("
      UPDATE lessons_opportunity_standards los 
      JOIN stages st ON los.lesson_id = st.id 
      SET los.lesson_guid = st.guid
    ")
    
    connection.execute("
      UPDATE stages_standards ss 
      JOIN stages st ON ss.stage_id = st.id 
      SET ss.lesson_guid = st.guid
    ")
    
    # Programming expressions
    connection.execute("
      UPDATE lessons_programming_expressions lpe 
      JOIN stages st ON lpe.lesson_id = st.id 
      SET lpe.lesson_guid = st.guid
    ")
    
    # Vocabularies
    connection.execute("
      UPDATE lessons_vocabularies lv 
      JOIN stages st ON lv.lesson_id = st.id 
      SET lv.lesson_guid = st.guid
    ")
    
    # Skills
    connection.execute("
      UPDATE levels_skills ls 
      JOIN levels l ON ls.level_id = l.id 
      SET ls.level_guid = l.guid
    ")
    
    # AI relationships
    connection.execute("
      UPDATE ai_lesson_summaries als 
      JOIN stages st ON als.lesson_id = st.id 
      SET als.lesson_guid = st.guid
    ")
  end
  
  def add_guid_foreign_key_indexes
    puts "Adding GUID foreign key indexes..."
    
    # User progress tracking indexes
    add_index :user_levels, :level_guid, name: 'idx_user_levels_level_guid'
    add_index :user_levels, :script_guid, name: 'idx_user_levels_script_guid'
    add_index :user_scripts, :script_guid, name: 'idx_user_scripts_script_guid'
    
    # Script level indexes
    add_index :script_levels, :script_guid, name: 'idx_script_levels_script_guid'
    add_index :script_levels, :lesson_guid, name: 'idx_script_levels_lesson_guid'
    
    # Level relationship indexes
    add_index :levels_script_levels, :level_guid, name: 'idx_levels_script_levels_level_guid'
    add_index :levels_script_levels, :script_level_guid, name: 'idx_levels_script_levels_script_level_guid'
    
    # Lesson relationship indexes
    add_index :lesson_groups, :script_guid, name: 'idx_lesson_groups_script_guid'
    add_index :lesson_activities, :lesson_guid, name: 'idx_lesson_activities_lesson_guid'
    add_index :activity_sections, :lesson_activity_guid, name: 'idx_activity_sections_lesson_activity_guid'
    
    # Course relationship indexes
    add_index :course_versions, :content_root_guid, name: 'idx_course_versions_content_root_guid'
    add_index :course_versions, :course_offering_guid, name: 'idx_course_versions_course_offering_guid'
    add_index :course_scripts, :course_guid, name: 'idx_course_scripts_course_guid'
    add_index :course_scripts, :script_guid, name: 'idx_course_scripts_script_guid'
    
    # Resource relationship indexes
    add_index :scripts_resources, :script_guid, name: 'idx_scripts_resources_script_guid'
    add_index :scripts_student_resources, :script_guid, name: 'idx_scripts_student_resources_script_guid'
    add_index :lessons_resources, :lesson_guid, name: 'idx_lessons_resources_lesson_guid'
    add_index :unit_groups_resources, :unit_group_guid, name: 'idx_unit_groups_resources_unit_group_guid'
    add_index :unit_groups_student_resources, :unit_group_guid, name: 'idx_unit_groups_student_resources_unit_group_guid'
    
    # Other relationship indexes
    add_index :concepts_levels, :level_guid, name: 'idx_concepts_levels_level_guid'
    add_index :level_concept_difficulties, :level_guid, name: 'idx_level_concept_difficulties_level_guid'
    add_index :parent_levels_child_levels, :parent_level_guid, name: 'idx_parent_levels_child_levels_parent_level_guid'
    add_index :parent_levels_child_levels, :child_level_guid, name: 'idx_parent_levels_child_levels_child_level_guid'
    add_index :section_hidden_scripts, :script_guid, name: 'idx_section_hidden_scripts_script_guid'
    add_index :section_hidden_stages, :lesson_guid, name: 'idx_section_hidden_stages_lesson_guid'
    add_index :plc_course_units, :script_guid, name: 'idx_plc_course_units_script_guid'
    add_index :plc_courses, :course_guid, name: 'idx_plc_courses_course_guid'
    add_index :lessons_standards, :lesson_guid, name: 'idx_lessons_standards_lesson_guid'
    add_index :lessons_opportunity_standards, :lesson_guid, name: 'idx_lessons_opportunity_standards_lesson_guid'
    add_index :stages_standards, :lesson_guid, name: 'idx_stages_standards_lesson_guid'
    add_index :lessons_programming_expressions, :lesson_guid, name: 'idx_lessons_programming_expressions_lesson_guid'
    add_index :lessons_vocabularies, :lesson_guid, name: 'idx_lessons_vocabularies_lesson_guid'
    add_index :levels_skills, :level_guid, name: 'idx_levels_skills_level_guid'
    add_index :ai_lesson_summaries, :lesson_guid, name: 'idx_ai_lesson_summaries_lesson_guid'
  end
  
  def remove_guid_foreign_key_indexes
    puts "Removing GUID foreign key indexes..."
    
    # Remove all the indexes we added
    remove_index :user_levels, name: 'idx_user_levels_level_guid'
    remove_index :user_levels, name: 'idx_user_levels_script_guid'
    remove_index :user_scripts, name: 'idx_user_scripts_script_guid'
    remove_index :script_levels, name: 'idx_script_levels_script_guid'
    remove_index :script_levels, name: 'idx_script_levels_lesson_guid'
    remove_index :levels_script_levels, name: 'idx_levels_script_levels_level_guid'
    remove_index :levels_script_levels, name: 'idx_levels_script_levels_script_level_guid'
    remove_index :lesson_groups, name: 'idx_lesson_groups_script_guid'
    remove_index :lesson_activities, name: 'idx_lesson_activities_lesson_guid'
    remove_index :activity_sections, name: 'idx_activity_sections_lesson_activity_guid'
    remove_index :course_versions, name: 'idx_course_versions_content_root_guid'
    remove_index :course_versions, name: 'idx_course_versions_course_offering_guid'
    remove_index :course_scripts, name: 'idx_course_scripts_course_guid'
    remove_index :course_scripts, name: 'idx_course_scripts_script_guid'
    remove_index :scripts_resources, name: 'idx_scripts_resources_script_guid'
    remove_index :scripts_student_resources, name: 'idx_scripts_student_resources_script_guid'
    remove_index :lessons_resources, name: 'idx_lessons_resources_lesson_guid'
    remove_index :unit_groups_resources, name: 'idx_unit_groups_resources_unit_group_guid'
    remove_index :unit_groups_student_resources, name: 'idx_unit_groups_student_resources_unit_group_guid'
    remove_index :concepts_levels, name: 'idx_concepts_levels_level_guid'
    remove_index :level_concept_difficulties, name: 'idx_level_concept_difficulties_level_guid'
    remove_index :parent_levels_child_levels, name: 'idx_parent_levels_child_levels_parent_level_guid'
    remove_index :parent_levels_child_levels, name: 'idx_parent_levels_child_levels_child_level_guid'
    remove_index :section_hidden_scripts, name: 'idx_section_hidden_scripts_script_guid'
    remove_index :section_hidden_stages, name: 'idx_section_hidden_stages_lesson_guid'
    remove_index :plc_course_units, name: 'idx_plc_course_units_script_guid'
    remove_index :plc_courses, name: 'idx_plc_courses_course_guid'
    remove_index :lessons_standards, name: 'idx_lessons_standards_lesson_guid'
    remove_index :lessons_opportunity_standards, name: 'idx_lessons_opportunity_standards_lesson_guid'
    remove_index :stages_standards, name: 'idx_stages_standards_lesson_guid'
    remove_index :lessons_programming_expressions, name: 'idx_lessons_programming_expressions_lesson_guid'
    remove_index :lessons_vocabularies, name: 'idx_lessons_vocabularies_lesson_guid'
    remove_index :levels_skills, name: 'idx_levels_skills_level_guid'
    remove_index :ai_lesson_summaries, name: 'idx_ai_lesson_summaries_lesson_guid'
  end
  
  def remove_guid_foreign_keys
    puts "Removing GUID foreign key columns..."
    
    # Remove all the columns we added
    remove_column :user_levels, :level_guid
    remove_column :user_levels, :script_guid
    remove_column :user_scripts, :script_guid
    remove_column :script_levels, :script_guid
    remove_column :script_levels, :lesson_guid
    remove_column :levels_script_levels, :level_guid
    remove_column :levels_script_levels, :script_level_guid
    remove_column :lesson_groups, :script_guid
    remove_column :lesson_activities, :lesson_guid
    remove_column :activity_sections, :lesson_activity_guid
    remove_column :course_versions, :content_root_guid
    remove_column :course_versions, :course_offering_guid
    remove_column :course_scripts, :course_guid
    remove_column :course_scripts, :script_guid
    remove_column :scripts_resources, :script_guid
    remove_column :scripts_student_resources, :script_guid
    remove_column :lessons_resources, :lesson_guid
    remove_column :unit_groups_resources, :unit_group_guid
    remove_column :unit_groups_student_resources, :unit_group_guid
    remove_column :concepts_levels, :level_guid
    remove_column :level_concept_difficulties, :level_guid
    remove_column :parent_levels_child_levels, :parent_level_guid
    remove_column :parent_levels_child_levels, :child_level_guid
    remove_column :contained_levels, :level_group_level_guid
    remove_column :contained_levels, :contained_level_guid
    remove_column :section_hidden_scripts, :script_guid
    remove_column :section_hidden_stages, :lesson_guid
    remove_column :plc_course_units, :script_guid
    remove_column :plc_courses, :course_guid
    remove_column :lessons_standards, :lesson_guid
    remove_column :lessons_opportunity_standards, :lesson_guid
    remove_column :stages_standards, :lesson_guid
    remove_column :lessons_programming_expressions, :lesson_guid
    remove_column :lessons_vocabularies, :lesson_guid
    remove_column :levels_skills, :level_guid
    remove_column :ai_lesson_summaries, :lesson_guid
    remove_column :learning_goal_evidence_levels, :learning_goal_guid
  end
end