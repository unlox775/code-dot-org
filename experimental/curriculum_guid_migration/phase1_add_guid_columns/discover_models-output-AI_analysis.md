# AI Analysis: discover_models-output.json

**Date**: 2025-10-17  
**Script**: `discover_models.rb`  
**Output**: `discover_models-output.json`  
**Status**: ✅ SUCCESS

## 🎯 **Analysis Summary**

### **Key Findings**
- **Models found in ScriptSeed service**: 28
- **Confirmed curriculum models**: 4
- **Missing from analysis**: 27
- **Extra models found**: 24
- **Confidence level**: 12.9% (Low but useful)

## 🔍 **Detailed Findings**

### **✅ Confirmed Models (4)**
- **Level** - Coding challenges
- **LessonGroup** - Chapters that organize lessons
- **ScriptLevel** - Roadmap of levels in scripts
- **LessonActivity** - Hands-on exercises

### **❌ Missing Models (27)**
- **Script, Stage, Course** - These are actually `Unit`, `Lesson`, `Course` in the code
- **UserLevel, UserScript** - Correctly excluded (user progress data)
- **Various other models** - May not actually be curriculum models

### **⚠️ Extra Models (24)**
- **Unit** - This is the actual model for scripts
- **Lesson** - This is the actual model for stages
- **Resource, Vocabulary** - Curriculum content models
- **Various other models** - Additional curriculum-related models

## 💡 **Key Insights**

### **Naming Mismatch**
- **Our assumptions used**: Script, Stage, Course
- **Actual code uses**: Unit, Lesson, Course
- **This explains** the low confidence - we were looking for wrong names

### **Model Discovery Value**
- **Found actual models** used in seeding code
- **Identified additional models** not in our assumptions
- **Revealed naming conventions** used in the codebase

## 🎯 **Validation Against Other Analysis**

### **Consistency Check**
- **Level, LessonGroup, ScriptLevel, LessonActivity** - Confirmed in both analyses
- **Unit, Lesson** - Found here, matches `scripts`, `stages` in other analysis
- **Resource models** - Found here, matches resource tables in other analysis

### **Complementary Value**
- **This analysis** - Discovers what models actually exist in code
- **Other analysis** - Identifies what tables need GUID migration
- **Together** - Provide complete picture of curriculum system

## 🚀 **Recommendation**

**USE AS DISCOVERY TOOL** - This analysis is valuable for discovering actual model names and additional curriculum models, but should be combined with the table analysis for a complete picture. The low confidence is expected given the naming mismatches, but the discovery value is high.

**Key Takeaway**: The codebase uses `Unit` for scripts, `Lesson` for stages, and includes many resource-related models that should be considered for GUID migration.