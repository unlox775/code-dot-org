# Migration: Validate GUID migration
# This migration validates that the GUID migration was successful
# and all data integrity is maintained

class ValidateGuidMigration < ActiveRecord::Migration[7.0]
  def up
    puts "Validating GUID migration..."
    
    # Validate GUID generation
    validate_guid_generation
    
    # Validate foreign key relationships
    validate_foreign_key_relationships
    
    # Validate data consistency
    validate_data_consistency
    
    puts "GUID migration validation completed successfully!"
  end
  
  def down
    # This migration is read-only, no rollback needed
    puts "Validation migration has no rollback - it only validates data"
  end
  
  private
  
  def validate_guid_generation
    puts "  Validating GUID generation..."
    
    # Check that all curriculum tables have GUIDs
    curriculum_tables = [
      :scripts, :script_levels, :levels, :lesson_groups, :stages,
      :lesson_activities, :activity_sections, :unit_groups,
      :course_versions, :course_offerings, :courses
    ]
    
    curriculum_tables.each do |table|
      count = connection.select_value("SELECT COUNT(*) FROM #{table} WHERE guid = '' OR guid IS NULL")
      if count > 0
        raise "Validation failed: #{count} records in #{table} are missing GUIDs"
      end
      
      # Check for duplicate GUIDs
      duplicate_count = connection.select_value("
        SELECT COUNT(*) - COUNT(DISTINCT guid) 
        FROM #{table}
      ")
      if duplicate_count > 0
        raise "Validation failed: #{duplicate_count} duplicate GUIDs found in #{table}"
      end
      
      puts "    ✓ #{table}: All records have unique GUIDs"
    end
  end
  
  def validate_foreign_key_relationships
    puts "  Validating foreign key relationships..."
    
    # Validate user_levels relationships
    validate_user_levels_relationships
    
    # Validate user_scripts relationships
    validate_user_scripts_relationships
    
    # Validate script_levels relationships
    validate_script_levels_relationships
    
    # Validate levels_script_levels relationships
    validate_levels_script_levels_relationships
    
    # Validate lesson relationships
    validate_lesson_relationships
    
    # Validate course relationships
    validate_course_relationships
    
    # Validate resource relationships
    validate_resource_relationships
    
    # Validate other relationships
    validate_other_relationships
  end
  
  def validate_user_levels_relationships
    puts "    Validating user_levels relationships..."
    
    # Check level_guid relationships
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM user_levels ul 
      LEFT JOIN levels l ON ul.level_guid = l.guid 
      WHERE ul.level_guid IS NOT NULL AND l.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} user_levels have invalid level_guid references"
    end
    
    # Check script_guid relationships
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM user_levels ul 
      LEFT JOIN scripts s ON ul.script_guid = s.guid 
      WHERE ul.script_guid IS NOT NULL AND s.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} user_levels have invalid script_guid references"
    end
    
    puts "      ✓ user_levels relationships valid"
  end
  
  def validate_user_scripts_relationships
    puts "    Validating user_scripts relationships..."
    
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM user_scripts us 
      LEFT JOIN scripts s ON us.script_guid = s.guid 
      WHERE us.script_guid IS NOT NULL AND s.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} user_scripts have invalid script_guid references"
    end
    
    puts "      ✓ user_scripts relationships valid"
  end
  
  def validate_script_levels_relationships
    puts "    Validating script_levels relationships..."
    
    # Check script_guid relationships
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM script_levels sl 
      LEFT JOIN scripts s ON sl.script_guid = s.guid 
      WHERE sl.script_guid IS NOT NULL AND s.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} script_levels have invalid script_guid references"
    end
    
    # Check lesson_guid relationships
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM script_levels sl 
      LEFT JOIN stages st ON sl.lesson_guid = st.guid 
      WHERE sl.lesson_guid IS NOT NULL AND st.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} script_levels have invalid lesson_guid references"
    end
    
    puts "      ✓ script_levels relationships valid"
  end
  
  def validate_levels_script_levels_relationships
    puts "    Validating levels_script_levels relationships..."
    
    # Check level_guid relationships
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM levels_script_levels lsl 
      LEFT JOIN levels l ON lsl.level_guid = l.guid 
      WHERE lsl.level_guid IS NOT NULL AND l.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} levels_script_levels have invalid level_guid references"
    end
    
    # Check script_level_guid relationships
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM levels_script_levels lsl 
      LEFT JOIN script_levels sl ON lsl.script_level_guid = sl.guid 
      WHERE lsl.script_level_guid IS NOT NULL AND sl.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} levels_script_levels have invalid script_level_guid references"
    end
    
    puts "      ✓ levels_script_levels relationships valid"
  end
  
  def validate_lesson_relationships
    puts "    Validating lesson relationships..."
    
    # Check lesson_groups script_guid
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM lesson_groups lg 
      LEFT JOIN scripts s ON lg.script_guid = s.guid 
      WHERE lg.script_guid IS NOT NULL AND s.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} lesson_groups have invalid script_guid references"
    end
    
    # Check lesson_activities lesson_guid
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM lesson_activities la 
      LEFT JOIN stages st ON la.lesson_guid = st.guid 
      WHERE la.lesson_guid IS NOT NULL AND st.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} lesson_activities have invalid lesson_guid references"
    end
    
    # Check activity_sections lesson_activity_guid
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM activity_sections asec 
      LEFT JOIN lesson_activities la ON asec.lesson_activity_guid = la.guid 
      WHERE asec.lesson_activity_guid IS NOT NULL AND la.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} activity_sections have invalid lesson_activity_guid references"
    end
    
    puts "      ✓ lesson relationships valid"
  end
  
  def validate_course_relationships
    puts "    Validating course relationships..."
    
    # Check course_versions content_root_guid
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM course_versions cv 
      LEFT JOIN unit_groups ug ON cv.content_root_guid = ug.guid 
      WHERE cv.content_root_guid IS NOT NULL AND ug.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} course_versions have invalid content_root_guid references"
    end
    
    # Check course_versions course_offering_guid
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM course_versions cv 
      LEFT JOIN course_offerings co ON cv.course_offering_guid = co.guid 
      WHERE cv.course_offering_guid IS NOT NULL AND co.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} course_versions have invalid course_offering_guid references"
    end
    
    # Check course_scripts relationships
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM course_scripts cs 
      LEFT JOIN courses c ON cs.course_guid = c.guid 
      WHERE cs.course_guid IS NOT NULL AND c.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} course_scripts have invalid course_guid references"
    end
    
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM course_scripts cs 
      LEFT JOIN scripts s ON cs.script_guid = s.guid 
      WHERE cs.script_guid IS NOT NULL AND s.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} course_scripts have invalid script_guid references"
    end
    
    puts "      ✓ course relationships valid"
  end
  
  def validate_resource_relationships
    puts "    Validating resource relationships..."
    
    # Check scripts_resources
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM scripts_resources sr 
      LEFT JOIN scripts s ON sr.script_guid = s.guid 
      WHERE sr.script_guid IS NOT NULL AND s.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} scripts_resources have invalid script_guid references"
    end
    
    # Check scripts_student_resources
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM scripts_student_resources ssr 
      LEFT JOIN scripts s ON ssr.script_guid = s.guid 
      WHERE ssr.script_guid IS NOT NULL AND s.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} scripts_student_resources have invalid script_guid references"
    end
    
    # Check lessons_resources
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM lessons_resources lr 
      LEFT JOIN stages st ON lr.lesson_guid = st.guid 
      WHERE lr.lesson_guid IS NOT NULL AND st.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} lessons_resources have invalid lesson_guid references"
    end
    
    # Check unit_groups_resources
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM unit_groups_resources ugr 
      LEFT JOIN unit_groups ug ON ugr.unit_group_guid = ug.guid 
      WHERE ugr.unit_group_guid IS NOT NULL AND ug.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} unit_groups_resources have invalid unit_group_guid references"
    end
    
    puts "      ✓ resource relationships valid"
  end
  
  def validate_other_relationships
    puts "    Validating other relationships..."
    
    # Check concepts_levels
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM concepts_levels cl 
      LEFT JOIN levels l ON cl.level_guid = l.guid 
      WHERE cl.level_guid IS NOT NULL AND l.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} concepts_levels have invalid level_guid references"
    end
    
    # Check parent_levels_child_levels
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM parent_levels_child_levels plcl 
      LEFT JOIN levels l ON plcl.parent_level_guid = l.guid 
      WHERE plcl.parent_level_guid IS NOT NULL AND l.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} parent_levels_child_levels have invalid parent_level_guid references"
    end
    
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM parent_levels_child_levels plcl 
      LEFT JOIN levels l ON plcl.child_level_guid = l.guid 
      WHERE plcl.child_level_guid IS NOT NULL AND l.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} parent_levels_child_levels have invalid child_level_guid references"
    end
    
    # Check section relationships
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM section_hidden_scripts shs 
      LEFT JOIN scripts s ON shs.script_guid = s.guid 
      WHERE shs.script_guid IS NOT NULL AND s.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} section_hidden_scripts have invalid script_guid references"
    end
    
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM section_hidden_stages shs 
      LEFT JOIN stages st ON shs.lesson_guid = st.guid 
      WHERE shs.lesson_guid IS NOT NULL AND st.guid IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} section_hidden_stages have invalid lesson_guid references"
    end
    
    puts "      ✓ other relationships valid"
  end
  
  def validate_data_consistency
    puts "  Validating data consistency..."
    
    # Validate that GUID foreign keys match ID foreign keys where both exist
    validate_guid_id_consistency
    
    # Validate that all required relationships are maintained
    validate_required_relationships
    
    puts "    ✓ data consistency valid"
  end
  
  def validate_guid_id_consistency
    puts "    Validating GUID-ID consistency..."
    
    # Check user_levels consistency
    inconsistent_count = connection.select_value("
      SELECT COUNT(*) 
      FROM user_levels ul 
      JOIN levels l ON ul.level_id = l.id 
      WHERE ul.level_guid != l.guid
    ")
    if inconsistent_count > 0
      raise "Validation failed: #{inconsistent_count} user_levels have inconsistent level_guid vs level_id"
    end
    
    inconsistent_count = connection.select_value("
      SELECT COUNT(*) 
      FROM user_levels ul 
      JOIN scripts s ON ul.script_id = s.id 
      WHERE ul.script_guid != s.guid
    ")
    if inconsistent_count > 0
      raise "Validation failed: #{inconsistent_count} user_levels have inconsistent script_guid vs script_id"
    end
    
    # Check user_scripts consistency
    inconsistent_count = connection.select_value("
      SELECT COUNT(*) 
      FROM user_scripts us 
      JOIN scripts s ON us.script_id = s.id 
      WHERE us.script_guid != s.guid
    ")
    if inconsistent_count > 0
      raise "Validation failed: #{inconsistent_count} user_scripts have inconsistent script_guid vs script_id"
    end
    
    # Check script_levels consistency
    inconsistent_count = connection.select_value("
      SELECT COUNT(*) 
      FROM script_levels sl 
      JOIN scripts s ON sl.script_id = s.id 
      WHERE sl.script_guid != s.guid
    ")
    if inconsistent_count > 0
      raise "Validation failed: #{inconsistent_count} script_levels have inconsistent script_guid vs script_id"
    end
    
    inconsistent_count = connection.select_value("
      SELECT COUNT(*) 
      FROM script_levels sl 
      JOIN stages st ON sl.stage_id = st.id 
      WHERE sl.lesson_guid != st.guid
    ")
    if inconsistent_count > 0
      raise "Validation failed: #{inconsistent_count} script_levels have inconsistent lesson_guid vs stage_id"
    end
    
    puts "      ✓ GUID-ID consistency valid"
  end
  
  def validate_required_relationships
    puts "    Validating required relationships..."
    
    # Check that all script_levels have valid script and lesson references
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM script_levels sl 
      LEFT JOIN scripts s ON sl.script_id = s.id 
      LEFT JOIN stages st ON sl.stage_id = st.id 
      WHERE s.id IS NULL OR st.id IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} script_levels have missing script or lesson references"
    end
    
    # Check that all user_levels have valid level references
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM user_levels ul 
      LEFT JOIN levels l ON ul.level_id = l.id 
      WHERE l.id IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} user_levels have missing level references"
    end
    
    # Check that all user_scripts have valid script references
    invalid_count = connection.select_value("
      SELECT COUNT(*) 
      FROM user_scripts us 
      LEFT JOIN scripts s ON us.script_id = s.id 
      WHERE s.id IS NULL
    ")
    if invalid_count > 0
      raise "Validation failed: #{invalid_count} user_scripts have missing script references"
    end
    
    puts "      ✓ required relationships valid"
  end
end