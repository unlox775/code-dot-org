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
    
    def scan_markdown_files(self) -> Tuple[Set[str], Set[str]]:
        """Scan all markdown files for documented dependencies and check completeness"""
        documented_deps = set()
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
                documented_deps.add(dep_name)
                
                # Check if this dependency has a necessity line
                if not self._has_necessity_line(content, dep_name):
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
        self.results['missing_docs'] = all_source_deps - self.results['documented_deps']
        
        return self.results
    
    def print_report(self):
        """Print a comprehensive report"""
        print("\n" + "="*80)
        print("📊 DEPENDENCY DOCUMENTATION REPORT")
        print("="*80)
        
        # Ruby/Gemfile dependencies
        print(f"\n🔴 RUBY DEPENDENCIES (Gemfile): {len(self.results['gemfile_deps'])} total")
        print("-" * 50)
        for dep in sorted(self.results['gemfile_deps']):
            status = "✅" if dep in self.results['documented_deps'] else "❌"
            print(f"  {status} {dep}")
        
        # JavaScript/Node.js dependencies
        print(f"\n🟡 JAVASCRIPT DEPENDENCIES (package.json): {len(self.results['package_json_deps'])} total")
        print("-" * 50)
        for dep in sorted(self.results['package_json_deps']):
            status = "✅" if dep in self.results['documented_deps'] else "❌"
            print(f"  {status} {dep}")
        
        # Python dependencies
        print(f"\n🐍 PYTHON DEPENDENCIES (pyproject.toml): {len(self.results['python_deps'])} total")
        print("-" * 50)
        for dep in sorted(self.results['python_deps']):
            status = "✅" if dep in self.results['documented_deps'] else "❌"
            print(f"  {status} {dep}")
        
        # Missing documentation
        if self.results['missing_docs']:
            print(f"\n❌ MISSING DEPENDENCIES NOT DOCUMENTED: {len(self.results['missing_docs'])}")
            print("-" * 50)
            for dep in sorted(self.results['missing_docs']):
                print(f"  ❌ {dep}")
        else:
            print(f"\n✅ ALL DEPENDENCIES ARE DOCUMENTED!")
        
        # Incomplete documentation
        if self.results['incomplete_docs']:
            print(f"\n⚠️  DEPENDENCIES WITHOUT FULL DETAIL: {len(self.results['incomplete_docs'])}")
            print("-" * 50)
            for dep in sorted(self.results['incomplete_docs']):
                print(f"  ⚠️  {dep} (missing necessity line)")
        else:
            print(f"\n✅ ALL DOCUMENTED DEPENDENCIES HAVE FULL DETAIL!")
        
        # Summary
        total_deps = len(self.results['gemfile_deps']) + len(self.results['package_json_deps']) + len(self.results['python_deps'])
        documented_count = len(self.results['documented_deps'])
        complete_count = documented_count - len(self.results['incomplete_docs'])
        
        print(f"\n📈 SUMMARY:")
        print(f"  Total dependencies: {total_deps}")
        print(f"  Documented: {documented_count} ({documented_count/total_deps*100:.1f}%)")
        print(f"  Complete: {complete_count} ({complete_count/total_deps*100:.1f}%)")
        print(f"  Missing: {len(self.results['missing_docs'])}")
        print(f"  Incomplete: {len(self.results['incomplete_docs'])}")
        
        return len(self.results['missing_docs']) == 0 and len(self.results['incomplete_docs']) == 0

def main():
    """Main entry point"""
    checker = DependencyChecker()
    checker.run_check()
    success = checker.print_report()
    
    if success:
        print("\n🎉 All dependencies are properly documented!")
        sys.exit(0)
    else:
        print("\n⚠️  Some dependencies need attention!")
        sys.exit(1)

if __name__ == "__main__":
    main()