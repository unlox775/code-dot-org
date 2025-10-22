#!/usr/bin/env python3
"""
Dependency Checker Tool

This script validates that all dependencies from Gemfile, package.json, and pyproject.toml
are properly documented in the markdown files.

Usage:
    python dependency_checker.py
    make check-dependencies
"""

import os
import re
import json
import yaml
import sys
from pathlib import Path
from typing import Dict, List, Set, Tuple, Optional
from datetime import datetime

class DependencyChecker:
    def __init__(self, base_dir: str = None):
        self.base_dir = Path(base_dir) if base_dir else Path(__file__).parent.parent.parent
        self.docs_dir = Path(__file__).parent
        self.results = {
            'gemfile_deps': set(),
            'package_json_deps': set(),
            'python_deps': set(),
            'documented_deps': set(),
            'missing_docs': set(),
            'incomplete_docs': set()
        }
    
    def extract_gemfile_dependencies(self) -> Set[str]:
        """Extract dependencies from Gemfile"""
        gemfile_path = self.base_dir / 'Gemfile'
        if not gemfile_path.exists():
            print(f"Warning: Gemfile not found at {gemfile_path}")
            return set()
        
        deps = set()
        with open(gemfile_path, 'r') as f:
            content = f.read()
            
        # Match gem declarations
        gem_pattern = r"gem\s+['\"]([^'\"]+)['\"]"
        matches = re.findall(gem_pattern, content)
        
        for match in matches:
            # Skip version constraints and options
            dep_name = match.split(',')[0].strip()
            deps.add(dep_name)
        
        return deps
    
    def extract_package_json_dependencies(self) -> Set[str]:
        """Extract dependencies from apps/package.json"""
        package_json_path = self.base_dir / 'apps' / 'package.json'
        if not package_json_path.exists():
            print(f"Warning: package.json not found at {package_json_path}")
            return set()
        
        deps = set()
        with open(package_json_path, 'r') as f:
            data = json.load(f)
        
        # Extract from dependencies and devDependencies
        for section in ['dependencies', 'devDependencies']:
            if section in data:
                deps.update(data[section].keys())
        
        return deps
    
    def extract_python_dependencies(self) -> Set[str]:
        """Extract dependencies from pyproject.toml"""
        pyproject_path = self.base_dir / 'pyproject.toml'
        if not pyproject_path.exists():
            print(f"Warning: pyproject.toml not found at {pyproject_path}")
            return set()
        
        deps = set()
        with open(pyproject_path, 'r') as f:
            content = f.read()
        
        # Simple TOML parsing for dependencies
        in_deps_section = False
        for line in content.split('\n'):
            line = line.strip()
            if line.startswith('[dependencies]') or line.startswith('[project.dependencies]'):
                in_deps_section = True
                continue
            elif line.startswith('[') and not line.startswith('[dependencies]'):
                in_deps_section = False
                continue
            
            if in_deps_section and '=' in line and not line.startswith('#'):
                dep_name = line.split('=')[0].strip().strip('"\'')
                if dep_name and not dep_name.startswith('['):
                    deps.add(dep_name)
        
        return deps
    
    def scan_markdown_files(self) -> Tuple[Dict[str, Dict], Set[str]]:
        """Scan all markdown files for documented dependencies and check completeness"""
        documented_deps = {}  # dep_name -> {file: str, severity: str, has_necessity: bool}
        incomplete_deps = set()
        
        # Scan all markdown files in the docs directory
        for md_file in self.docs_dir.rglob('*.md'):
            if md_file.name == 'README.md' or md_file.name == 'agent-prompts.md':
                continue
                
            with open(md_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find all dependency entries (lines starting with - [x] or - [ ])
            dep_pattern = r'^- \[[x ]\] \*\*([^*]+)\*\*'
            matches = re.findall(dep_pattern, content, re.MULTILINE)
            
            for dep_name in matches:
                # Clean up the dependency name
                dep_name = dep_name.strip()
                file_name = md_file.stem  # Get filename without extension
                
                # Check if this dependency has a necessity line
                has_necessity = self._has_necessity_line(content, dep_name)
                
                # Extract severity if present
                severity = "UNKNOWN"
                if has_necessity:
                    # Look for necessity line after the dependency name
                    dep_section = re.search(rf'\*\*{re.escape(dep_name)}\*\*.*?(?=\n- \[|$)', content, re.DOTALL)
                    if dep_section:
                        section_content = dep_section.group(0)
                        severity_match = re.search(r'- \*\*Necessity\*\*:\s*\*\*(LOW|MEDIUM|HIGH|CRITICAL)\*\*', section_content)
                        if severity_match:
                            severity = severity_match.group(1)
                
                documented_deps[dep_name] = {
                    'file': file_name,
                    'severity': severity,
                    'has_necessity': has_necessity
                }
                
                if not has_necessity:
                    incomplete_deps.add(dep_name)
        
        return documented_deps, incomplete_deps
    
    def _has_necessity_line(self, content: str, dep_name: str) -> bool:
        """Check if a dependency has a necessity line in the content"""
        # Look for the dependency name followed by necessity information
        pattern = rf'\*\*{re.escape(dep_name)}\*\*.*?\n.*?Necessity.*?:\s*\*\*(LOW|MEDIUM|HIGH|CRITICAL)\*\*'
        return bool(re.search(pattern, content, re.DOTALL | re.IGNORECASE))
    
    def run_check(self) -> Dict:
        """Run the complete dependency check"""
        print("🔍 Extracting dependencies from source files...")
        
        # Extract dependencies from source files
        self.results['gemfile_deps'] = self.extract_gemfile_dependencies()
        self.results['package_json_deps'] = self.extract_package_json_dependencies()
        self.results['python_deps'] = self.extract_python_dependencies()
        
        print("📚 Scanning documentation files...")
        
        # Scan documentation
        self.results['documented_deps'], self.results['incomplete_docs'] = self.scan_markdown_files()
        
        # Find missing dependencies
        all_source_deps = self.results['gemfile_deps'] | self.results['package_json_deps'] | self.results['python_deps']
        self.results['missing_docs'] = all_source_deps - set(self.results['documented_deps'].keys())
        
        return self.results
    
    def save_report(self, output_dir: Path = None):
        """Save the report to a timestamped file"""
        if output_dir is None:
            output_dir = Path(__file__).parent
        
        timestamp = datetime.now().strftime("%Y-%m-%d")
        report_file = output_dir / f"dependency-checker-last-run-{timestamp}.txt"
        
        with open(report_file, 'w') as f:
            f.write("="*80 + "\n")
            f.write("📊 DEPENDENCY DOCUMENTATION REPORT\n")
            f.write(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write("="*80 + "\n")
            
            # Ruby dependencies
            f.write(f"\n🔴 RUBY DEPENDENCIES (Gemfile): {len(self.results['gemfile_deps'])} total\n")
            f.write("-" * 50 + "\n")
            for dep in sorted(self.results['gemfile_deps']):
                status = "✅" if dep in self.results['documented_deps'] else "❌"
                f.write(f"  {status} {dep}\n")
            
            # JavaScript dependencies
            f.write(f"\n🟡 JAVASCRIPT DEPENDENCIES (package.json): {len(self.results['package_json_deps'])} total\n")
            f.write("-" * 50 + "\n")
            for dep in sorted(self.results['package_json_deps']):
                status = "✅" if dep in self.results['documented_deps'] else "❌"
                f.write(f"  {status} {dep}\n")
            
            # Python dependencies
            f.write(f"\n🐍 PYTHON DEPENDENCIES (pyproject.toml): {len(self.results['python_deps'])} total\n")
            f.write("-" * 50 + "\n")
            for dep in sorted(self.results['python_deps']):
                status = "✅" if dep in self.results['documented_deps'] else "❌"
                f.write(f"  {status} {dep}\n")
            
            # Missing documentation
            if self.results['missing_docs']:
                f.write(f"\n❌ MISSING DEPENDENCIES NOT DOCUMENTED: {len(self.results['missing_docs'])}\n")
                f.write("-" * 50 + "\n")
                for dep in sorted(self.results['missing_docs']):
                    f.write(f"  ❌ {dep}\n")
            else:
                f.write(f"\n✅ ALL DEPENDENCIES ARE DOCUMENTED!\n")
            
            # Incomplete documentation
            if self.results['incomplete_docs']:
                f.write(f"\n⚠️  DEPENDENCIES WITHOUT FULL DETAIL: {len(self.results['incomplete_docs'])}\n")
                f.write("-" * 50 + "\n")
                for dep in sorted(self.results['incomplete_docs']):
                    f.write(f"  ⚠️  {dep} (missing necessity line)\n")
            else:
                f.write(f"\n✅ ALL DOCUMENTED DEPENDENCIES HAVE FULL DETAIL!\n")
            
            # Summary
            total_deps = len(self.results['gemfile_deps']) + len(self.results['package_json_deps']) + len(self.results['python_deps'])
            documented_count = len(self.results['documented_deps'])
            complete_count = sum(1 for info in self.results['documented_deps'].values() 
                               if info['has_necessity'] and info['severity'] != "UNKNOWN")
            
            f.write(f"\n📈 SUMMARY:\n")
            f.write(f"  Total dependencies: {total_deps}\n")
            f.write(f"  Documented: {documented_count} ({documented_count/total_deps*100:.1f}%)\n")
            f.write(f"  Complete: {complete_count} ({complete_count/total_deps*100:.1f}%)\n")
            f.write(f"  Missing: {len(self.results['missing_docs'])}\n")
            f.write(f"  Incomplete: {len(self.results['incomplete_docs'])}\n")
        
        print(f"📄 Report saved to: {report_file}")
        return report_file

    def print_report(self):
        """Print a comprehensive report with enhanced details"""
        print("\n" + "="*80)
        print("📊 DEPENDENCY DOCUMENTATION REPORT")
        print("="*80)
        
        # Combine all dependencies and sort by file
        all_deps = {}
        
        # Add Ruby dependencies
        for dep in self.results['gemfile_deps']:
            all_deps[dep] = {'type': 'Ruby', 'source': 'Gemfile'}
        
        # Add JavaScript dependencies  
        for dep in self.results['package_json_deps']:
            all_deps[dep] = {'type': 'JavaScript', 'source': 'package.json'}
        
        # Add Python dependencies
        for dep in self.results['python_deps']:
            all_deps[dep] = {'type': 'Python', 'source': 'pyproject.toml'}
        
        # Sort dependencies by file name (if documented) or by type
        def sort_key(dep_info):
            dep_name, info = dep_info
            if dep_name in self.results['documented_deps']:
                doc_info = self.results['documented_deps'][dep_name]
                return (0, doc_info['file'], dep_name)  # Documented first, sorted by file
            else:
                return (1, info['type'], dep_name)  # Undocumented last, sorted by type
        
        sorted_deps = sorted(all_deps.items(), key=sort_key)
        
        print(f"\n📋 ALL DEPENDENCIES: {len(all_deps)} total")
        print("-" * 80)
        
        current_file = None
        for dep_name, info in sorted_deps:
            # Get documentation info if available
            if dep_name in self.results['documented_deps']:
                doc_info = self.results['documented_deps'][dep_name]
                file_name = doc_info['file']
                severity = doc_info['severity']
                has_necessity = doc_info['has_necessity']
                
                # Determine status emoji
                if has_necessity and severity != "UNKNOWN":
                    status = "✅"  # Complete
                elif has_necessity:
                    status = "🔨"  # Has necessity but unknown severity
                else:
                    status = "⚠️"   # Missing necessity
                
                # Print file header if changed
                if current_file != file_name:
                    current_file = file_name
                    print(f"\n📁 {file_name.upper()}:")
                
                # Format severity display
                severity_display = f"({severity})" if severity != "UNKNOWN" else ""
                print(f"  {status} {dep_name} {severity_display}")
                
            else:
                # Not documented
                if current_file != "UNDOCUMENTED":
                    current_file = "UNDOCUMENTED"
                    print(f"\n❌ NOT DOCUMENTED:")
                
                print(f"  ❌ {dep_name} ({info['type']} - {info['source']})")
        
        # Summary
        total_deps = len(all_deps)
        documented_count = len(self.results['documented_deps'])
        complete_count = sum(1 for info in self.results['documented_deps'].values() 
                           if info['has_necessity'] and info['severity'] != "UNKNOWN")
        missing_count = len(self.results['missing_docs'])
        incomplete_count = len(self.results['incomplete_docs'])
        
        print(f"\n📈 SUMMARY:")
        print(f"  Total dependencies: {total_deps}")
        print(f"  Documented: {documented_count} ({documented_count/total_deps*100:.1f}%)")
        print(f"  Complete: {complete_count} ({complete_count/total_deps*100:.1f}%)")
        print(f"  Missing: {missing_count}")
        print(f"  Incomplete: {incomplete_count}")
        
        return missing_count == 0 and incomplete_count == 0

def main():
    """Main entry point"""
    checker = DependencyChecker()
    checker.run_check()
    
    # Save timestamped report
    report_file = checker.save_report()
    
    # Print report to console
    success = checker.print_report()
    
    if success:
        print("\n🎉 All dependencies are properly documented!")
        sys.exit(0)
    else:
        print("\n⚠️  Some dependencies need attention!")
        sys.exit(1)

if __name__ == "__main__":
    main()