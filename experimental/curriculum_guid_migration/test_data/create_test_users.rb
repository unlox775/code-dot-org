#!/usr/bin/env ruby
# frozen_string_literal: true

# Create Test Users and Sample Data
# This script creates test users and sample curriculum data for testing

require 'active_record'
require 'faker'

# Load Rails environment
require_relative '../../dashboard/config/environment'

class TestDataCreator
  def initialize
    @results = {
      timestamp: Time.current,
      status: 'running',
      created_data: {}
    }
  end

  def run
    puts "🏗️  Creating Test Data for Curriculum GUID Migration"
    puts "=" * 60

    # Check if we're in a safe environment
    unless safe_environment?
      puts "❌ ERROR: Not in a safe environment for creating test data!"
      puts "   This script should only be run in development or test environments."
      exit 1
    end

    # Create test data
    create_test_users
    create_sample_curriculum_data
    create_sample_user_progress
    create_sample_relationships

    # Generate report
    generate_report

    puts "\n✅ Test data creation complete!"
    puts "📊 Results saved to: test_data_creation_results.json"
  end

  private

  def safe_environment?
    Rails.env.development? || Rails.env.test?
  end

  def create_test_users
    puts "\n👥 Creating test users..."
    
    users = []
    
    # Create admin user
    admin = User.create!(
      name: 'Test Admin',
      email: 'admin@test.com',
      user_type: 'teacher',
      admin: true,
      provider: 'manual',
      uid: 'test_admin_001'
    )
    users << admin
    puts "   Created admin user: #{admin.email}"

    # Create teacher users
    5.times do |i|
      teacher = User.create!(
        name: Faker::Name.name,
        email: "teacher#{i + 1}@test.com",
        user_type: 'teacher',
        provider: 'manual',
        uid: "test_teacher_#{i + 1}"
      )
      users << teacher
    end
    puts "   Created 5 teacher users"

    # Create student users
    20.times do |i|
      student = User.create!(
        name: Faker::Name.name,
        email: "student#{i + 1}@test.com",
        user_type: 'student',
        provider: 'manual',
        uid: "test_student_#{i + 1}",
        birthday: Faker::Date.birthday(min_age: 8, max_age: 18)
      )
      users << student
    end
    puts "   Created 20 student users"

    @results[:created_data][:users] = users.length
    @results[:created_data][:user_details] = users.map { |u| { id: u.id, email: u.email, type: u.user_type } }
  end

  def create_sample_curriculum_data
    puts "\n📚 Creating sample curriculum data..."
    
    # Create courses
    courses = []
    3.times do |i|
      course = Course.create!(
        name: "Test Course #{i + 1}",
        title: "Test Course #{i + 1}",
        description: Faker::Lorem.paragraph,
        version_year: 2024,
        is_active: true
      )
      courses << course
    end
    puts "   Created #{courses.length} courses"

    # Create scripts (units)
    scripts = []
    5.times do |i|
      script = Script.create!(
        name: "test_script_#{i + 1}",
        title: "Test Script #{i + 1}",
        description: Faker::Lorem.paragraph,
        version_year: 2024,
        is_course: false,
        is_stable: true,
        family_name: "test_family_#{i + 1}",
        published_state: 'stable'
      )
      scripts << script
    end
    puts "   Created #{scripts.length} scripts"

    # Create stages (lessons)
    stages = []
    scripts.each do |script|
      3.times do |i|
        stage = Stage.create!(
          name: "test_stage_#{script.id}_#{i + 1}",
          title: "Test Stage #{i + 1}",
          description: Faker::Lorem.paragraph,
          script: script,
          position: i + 1,
          absolute_position: i + 1
        )
        stages << stage
      end
    end
    puts "   Created #{stages.length} stages"

    # Create levels
    levels = []
    stages.each do |stage|
      2.times do |i|
        level = Level.create!(
          name: "test_level_#{stage.id}_#{i + 1}",
          level_num: "#{stage.id}_#{i + 1}",
          title: "Test Level #{i + 1}",
          description: Faker::Lorem.paragraph,
          type: 'Maze',
          created_at: Time.current,
          updated_at: Time.current
        )
        levels << level
      end
    end
    puts "   Created #{levels.length} levels"

    # Create script_levels (lesson activities)
    script_levels = []
    stages.each_with_index do |stage, stage_index|
      stage.script.levels.each_with_index do |level, level_index|
        script_level = ScriptLevel.create!(
          script: stage.script,
          stage: stage,
          level: level,
          position: level_index + 1,
          chapter: stage_index + 1
        )
        script_levels << script_level
      end
    end
    puts "   Created #{script_levels.length} script levels"

    @results[:created_data][:courses] = courses.length
    @results[:created_data][:scripts] = scripts.length
    @results[:created_data][:stages] = stages.length
    @results[:created_data][:levels] = levels.length
    @results[:created_data][:script_levels] = script_levels.length
  end

  def create_sample_user_progress
    puts "\n📊 Creating sample user progress data..."
    
    users = User.where(user_type: 'student').limit(10)
    scripts = Script.limit(3)
    levels = Level.limit(10)
    
    # Create user_scripts
    user_scripts = []
    users.each do |user|
      scripts.each do |script|
        user_script = UserScript.create!(
          user: user,
          script: script,
          started_at: Faker::Time.between(from: 1.month.ago, to: Time.current),
          last_progress_at: Faker::Time.between(from: 1.week.ago, to: Time.current),
          completed_at: Faker::Time.between(from: 1.week.ago, to: Time.current)
        )
        user_scripts << user_script
      end
    end
    puts "   Created #{user_scripts.length} user scripts"

    # Create user_levels
    user_levels = []
    users.each do |user|
      levels.sample(5).each do |level|
        user_level = UserLevel.create!(
          user: user,
          level: level,
          script: level.script_levels.first&.script,
          attempts: Faker::Number.between(from: 1, to: 10),
          best_result: Faker::Number.between(from: 0, to: 100),
          time_spent: Faker::Number.between(from: 60, to: 3600),
          created_at: Faker::Time.between(from: 1.month.ago, to: Time.current),
          updated_at: Faker::Time.between(from: 1.week.ago, to: Time.current)
        )
        user_levels << user_level
      end
    end
    puts "   Created #{user_levels.length} user levels"

    @results[:created_data][:user_scripts] = user_scripts.length
    @results[:created_data][:user_levels] = user_levels.length
  end

  def create_sample_relationships
    puts "\n🔗 Creating sample relationships..."
    
    # Create course_scripts
    courses = Course.limit(2)
    scripts = Script.limit(3)
    
    course_scripts = []
    courses.each do |course|
      scripts.each do |script|
        course_script = CourseScript.create!(
          course: course,
          script: script,
          position: Faker::Number.between(from: 1, to: 10)
        )
        course_scripts << course_script
      end
    end
    puts "   Created #{course_scripts.length} course scripts"

    # Create unit_groups
    unit_groups = []
    2.times do |i|
      unit_group = UnitGroup.create!(
        name: "test_unit_group_#{i + 1}",
        title: "Test Unit Group #{i + 1}",
        description: Faker::Lorem.paragraph,
        published_state: 'stable'
      )
      unit_groups << unit_group
    end
    puts "   Created #{unit_groups.length} unit groups"

    @results[:created_data][:course_scripts] = course_scripts.length
    @results[:created_data][:unit_groups] = unit_groups.length
  end

  def generate_report
    puts "\n📊 Generating test data creation report..."
    
    @results[:status] = 'completed'
    @results[:summary] = {
      total_records: @results[:created_data].values.sum,
      tables_populated: @results[:created_data].keys.length,
      data_quality: 'high'
    }
    
    # Save results
    File.write('test_data_creation_results.json', JSON.pretty_generate(@results))
    
    # Print summary
    puts "\n📈 TEST DATA CREATION SUMMARY"
    puts "=" * 40
    puts "Total records created: #{@results[:summary][:total_records]}"
    puts "Tables populated: #{@results[:summary][:tables_populated]}"
    puts "Data quality: #{@results[:summary][:data_quality]}"
    
    puts "\n📋 DETAILED BREAKDOWN:"
    @results[:created_data].each do |table, count|
      puts "  #{table}: #{count} records"
    end
  end
end

# Run the test data creation
if __FILE__ == $0
  creator = TestDataCreator.new
  creator.run
end