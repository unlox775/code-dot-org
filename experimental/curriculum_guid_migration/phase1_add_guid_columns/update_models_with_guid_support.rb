#!/usr/bin/env ruby
# frozen_string_literal: true

# Script to add GuidSupport to all curriculum models
# This script updates all 27 curriculum model files to include GuidSupport

require 'fileutils'

class ModelGuidSupportUpdater
  def initialize
    @models_to_update = {
      # Core curriculum content models (13)
      'unit.rb' => 'Unit (scripts table)',
      'lesson.rb' => 'Lesson (stages table)', 
      'levels/level.rb' => 'Level (levels table)',
      'lesson_group.rb' => 'LessonGroup (lesson_groups table)',
      'lesson_activity.rb' => 'LessonActivity (lesson_activities table)',
      'activity_section.rb' => 'ActivitySection (activity_sections table)',
      'course_version.rb' => 'CourseVersion (course_versions table)',
      'course_offering.rb' => 'CourseOffering (course_offerings table)',
      'objective.rb' => 'Objective (objectives table)',
      'programming_expression.rb' => 'ProgrammingExpression (programming_expressions table)',
      'rubric.rb' => 'Rubric (rubrics table)',
      'learning_goal.rb' => 'LearningGoal (learning_goals table)',
      
      # Curriculum organization models (3)
      'unit_group.rb' => 'UnitGroup (unit_groups table)',
      'script_level.rb' => 'ScriptLevel (script_levels table)',
      'levels_script_level.rb' => 'LevelsScriptLevel (levels_script_levels table)',
      
      # Curriculum resource models (8)
      'unit_group_unit.rb' => 'UnitGroupUnit (course_scripts table)',
      'unit_groups_resource.rb' => 'UnitGroupsResource (unit_groups_resources table)',
      'unit_groups_student_resource.rb' => 'UnitGroupsStudentResource (unit_groups_student_resources table)',
      'scripts_resource.rb' => 'ScriptsResource (scripts_resources table)',
      'scripts_student_resource.rb' => 'ScriptsStudentResource (scripts_student_resources table)',
      'lessons_resource.rb' => 'LessonsResource (lessons_resources table)',
      'lessons_standard.rb' => 'LessonsStandard (stages_standards table)',
      'lessons_vocabulary.rb' => 'LessonsVocabulary (lessons_vocabularies table)',
      
      # Curriculum join models (3)
      'lessons_programming_expression.rb' => 'LessonsProgrammingExpression (lessons_programming_expressions table)',
      'learning_goal_evidence_level.rb' => 'LearningGoalEvidenceLevel (learning_goal_evidence_levels table)',
      'lessons_opportunity_standard.rb' => 'LessonsOpportunityStandard (lessons_opportunity_standards table)'
    }
    
    @models_already_updated = [
      'unit.rb', 'lesson.rb', 'lesson_group.rb', 'course_version.rb', 'course_offering.rb'
    ]
    
    @models_with_guid_support = [
      'levels/level.rb', 'script_level.rb', 'unit.rb'
    ]
  end
  
  def run
    puts "🔧 Adding GuidSupport to Curriculum Models"
    puts "=" * 60
    puts ""
    
    @models_to_update.each do |model_file, description|
      if @models_already_updated.include?(model_file)
        puts "✅ #{model_file} - Already updated"
        next
      end
      
      if @models_with_guid_support.include?(model_file)
        puts "✅ #{model_file} - Already has GuidSupport"
        next
      end
      
      update_model_file(model_file, description)
    end
    
    puts ""
    puts "🎉 Model updates complete!"
    puts "📊 Updated #{@models_to_update.length - @models_already_updated.length - @models_with_guid_support.length} models"
  end
  
  private
  
  def update_model_file(model_file, description)
    model_path = "/workspace/dashboard/app/models/#{model_file}"
    
    unless File.exist?(model_path)
      puts "❌ #{model_file} - File not found"
      return
    end
    
    content = File.read(model_path)
    
    # Check if already has GuidSupport
    if content.include?('include GuidSupport')
      puts "✅ #{model_file} - Already has GuidSupport"
      return
    end
    
    # Find the class definition and add GuidSupport
    if content.match(/class\s+(\w+)\s*<\s*ApplicationRecord/)
      class_name = $1
      
      # Find where to insert GuidSupport (after other includes)
      if content.match(/class\s+#{class_name}\s*<\s*ApplicationRecord\s*\n(.*?)(?=\n\s*(?:def|private|protected|end|\z))/m)
        class_content = $1
        
        # Find the last include statement
        includes = class_content.scan(/^\s*include\s+\w+/)
        
        if includes.any?
          # Insert after the last include
          last_include = includes.last
          replacement = "#{last_include}\n  include GuidSupport"
          new_content = content.gsub(last_include, replacement)
        else
          # Insert after the class definition
          replacement = "class #{class_name} < ApplicationRecord\n  include GuidSupport"
          new_content = content.gsub(/class\s+#{class_name}\s*<\s*ApplicationRecord/, replacement)
        end
        
        # Write the updated content
        File.write(model_path, new_content)
        puts "✅ #{model_file} - Added GuidSupport"
      else
        puts "❌ #{model_file} - Could not find class definition"
      end
    else
      puts "❌ #{model_file} - Could not find ApplicationRecord class"
    end
  end
end

# Run the updater
if __FILE__ == $0
  updater = ModelGuidSupportUpdater.new
  updater.run
end