#!/usr/bin/env python3
"""
Interactive tool to cherry-pick private production changes back to public repo.

This script helps sync security fixes from the private production repository
back to the public repository by allowing you to select which commits to
cherry-pick and creating pull requests for them.

Usage:
    # Interactive mode - select commits with arrow keys
    ./private_production_sync.py
    
    # Specify specific commit hashes
    ./private_production_sync.py --commits abc123,def456,ghi789
    
    # Sync to production branch only
    ./private_production_sync.py --production
    
    # Sync to staging branch only  
    ./private_production_sync.py --staging
    
    # Test mode - check for conflicts without creating PRs
    ./private_production_sync.py --dry-run
"""

import argparse
import subprocess
import sys
import os
from pathlib import Path
import json
from typing import List, Dict, Optional

class PrivateProductionSyncer:
    def __init__(self, public_repo_path: str, private_repo_path: str):
        self.public_repo_path = Path(public_repo_path)
        self.private_repo_path = Path(private_repo_path)
        self.gh_available = self._check_gh_cli()
        
    def _check_gh_cli(self) -> bool:
        """Check if GitHub CLI is available."""
        try:
            subprocess.run(['gh', '--version'], capture_output=True, check=True)
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False
    
    def _run_git(self, args: List[str], cwd: Path) -> subprocess.CompletedProcess:
        """Run git command in specified directory."""
        return subprocess.run(['git'] + args, cwd=cwd, capture_output=True, text=True)
    
    def _ensure_clean_working_directory(self) -> None:
        """Ensure public repo has clean working directory."""
        result = self._run_git(['status', '--porcelain'], self.public_repo_path)
        if result.stdout.strip():
            print("ERROR: Public repository has uncommitted changes")
            print("Please commit or stash your changes before running back-sync")
            sys.exit(1)
    
    def _update_public_repo(self) -> None:
        """Update public repo to latest."""
        print("Updating public repository...")
        self._run_git(['fetch', 'origin'], self.public_repo_path)
        self._run_git(['checkout', 'production'], self.public_repo_path)
        self._run_git(['pull', 'origin', 'production'], self.public_repo_path)
        self._run_git(['checkout', 'staging'], self.public_repo_path)
        self._run_git(['pull', 'origin', 'staging'], self.public_repo_path)
    
    def _get_private_commits(self) -> List[Dict]:
        """Get commits from private repo that aren't in public repo."""
        # Get commits from private production that aren't in public production
        result = self._run_git([
            'log', '--oneline', '--pretty=format:%H|%s|%an|%ad',
            '--date=short',
            'origin/production..origin/production'
        ], self.private_repo_path)
        
        commits = []
        for line in result.stdout.strip().split('\n'):
            if not line:
                continue
            parts = line.split('|', 3)
            if len(parts) >= 4:
                commits.append({
                    'hash': parts[0],
                    'message': parts[1],
                    'author': parts[2],
                    'date': parts[3]
                })
        
        return commits
    
    def _display_commits(self, commits: List[Dict]) -> None:
        """Display available commits for selection."""
        if not commits:
            print("No new commits found in private repository")
            return
        
        print(f"\nFound {len(commits)} new commits in private repository:")
        print("-" * 80)
        for i, commit in enumerate(commits, 1):
            print(f"{i:2d}. {commit['hash'][:8]} | {commit['date']} | {commit['author']}")
            print(f"    {commit['message']}")
            print()
    
    def _get_user_selection(self, commits: List[Dict]) -> List[int]:
        """Get user selection of commits to sync."""
        if not commits:
            return []
        
        while True:
            try:
                selection = input("Enter commit numbers to sync (e.g., 1,3,5 or 1 3 5): ").strip()
                if not selection:
                    return []
                
                # Parse both comma-separated and space-separated formats
                if ',' in selection:
                    indices = [int(x.strip()) for x in selection.split(',')]
                else:
                    indices = [int(x.strip()) for x in selection.split()]
                
                # Validate indices
                valid_indices = [i for i in indices if 1 <= i <= len(commits)]
                if len(valid_indices) != len(indices):
                    print("ERROR: Some commit numbers are invalid")
                    continue
                
                return valid_indices
                
            except ValueError:
                print("ERROR: Please enter valid numbers")
                continue
    
    def _test_cherry_pick(self, commit_hash: str, target_branch: str) -> bool:
        """Test cherry-pick on target branch without applying."""
        print(f"Testing cherry-pick of {commit_hash[:8]} on {target_branch}...")
        
        # Switch to target branch
        self._run_git(['checkout', target_branch], self.public_repo_path)
        
        # Try cherry-pick in dry-run mode
        result = self._run_git(['cherry-pick', '--no-commit', commit_hash], self.public_repo_path)
        
        if result.returncode == 0:
            # Cherry-pick succeeded, reset it
            self._run_git(['reset', '--hard', 'HEAD'], self.public_repo_path)
            print(f"✓ Cherry-pick test passed for {target_branch}")
            return True
        else:
            print(f"✗ Cherry-pick test failed for {target_branch}")
            print(f"Error: {result.stderr}")
            return False
    
    def _create_pull_request(self, commit_hash: str, target_branch: str, commit_message: str) -> Optional[str]:
        """Create pull request for cherry-picked commit."""
        if not self.gh_available:
            print("GitHub CLI not available, skipping PR creation")
            return None
        
        # Create branch for this commit
        branch_name = f"back-sync-{commit_hash[:8]}"
        self._run_git(['checkout', '-b', branch_name], self.public_repo_path)
        
        # Cherry-pick the commit
        result = self._run_git(['cherry-pick', commit_hash], self.public_repo_path)
        if result.returncode != 0:
            print(f"ERROR: Cherry-pick failed: {result.stderr}")
            return None
        
        # Push branch
        self._run_git(['push', 'origin', branch_name], self.public_repo_path)
        
        # Create PR
        pr_title = f"Back-sync: {commit_message}"
        pr_body = f"Cherry-picked from private production repository\n\nCommit: {commit_hash}"
        
        try:
            result = subprocess.run([
                'gh', 'pr', 'create',
                '--title', pr_title,
                '--body', pr_body,
                '--base', target_branch,
                '--head', branch_name
            ], capture_output=True, text=True, check=True)
            
            pr_url = result.stdout.strip()
            print(f"✓ Created PR: {pr_url}")
            return pr_url
            
        except subprocess.CalledProcessError as e:
            print(f"ERROR: Failed to create PR: {e.stderr}")
            return None
    
    def sync_commits(self, target_branches: List[str], commit_hashes: Optional[List[str]] = None, dry_run: bool = False) -> None:
        """Main sync function."""
        print(f"Starting back-sync to {', '.join(target_branches)} branch(es)...")
        
        # Safety checks
        self._ensure_clean_working_directory()
        self._update_public_repo()
        
        # Get available commits
        commits = self._get_private_commits()
        if not commits:
            print("No new commits to sync")
            return
        
        # If specific commit hashes provided, filter commits
        if commit_hashes:
            selected_commits = [c for c in commits if c['hash'] in commit_hashes]
            if not selected_commits:
                print("ERROR: None of the specified commit hashes found in private repo")
                return
        else:
            # Interactive selection
            self._display_commits(commits)
            commit_indices = self._get_user_selection(commits)
            if not commit_indices:
                print("No commits selected")
                return
            selected_commits = [commits[i-1] for i in commit_indices]
        
        # Confirm selection
        print(f"\nSelected {len(selected_commits)} commits:")
        for commit in selected_commits:
            print(f"  - {commit['hash'][:8]}: {commit['message']}")
        
        confirm = input("\nProceed with sync? (y/N): ").strip().lower()
        if confirm != 'y':
            print("Sync cancelled")
            return
        
        # Test cherry-picks on all target branches
        print("\nTesting cherry-picks...")
        all_tests_passed = True
        
        for commit in selected_commits:
            for target in target_branches:
                if not self._test_cherry_pick(commit['hash'], target):
                    all_tests_passed = False
        
        if not all_tests_passed:
            print("\nERROR: Some cherry-pick tests failed")
            print("Please resolve conflicts manually or run commits one at a time")
            sys.exit(1)
        
        if dry_run:
            print("\nDry run completed - all tests passed")
            return
        
        # Create pull requests for each target branch
        for target in target_branches:
            print(f"\nCreating pull requests for {target} branch...")
            for commit in selected_commits:
                self._create_pull_request(commit['hash'], target, commit['message'])
        
        print("\nBack-sync completed successfully!")

def main():
    parser = argparse.ArgumentParser(description='Sync private production changes to public repo')
    parser.add_argument('--commits', type=str,
                       help='Specific commit hashes to sync (comma-separated)')
    parser.add_argument('--production', action='store_true',
                       help='Sync to production branch only')
    parser.add_argument('--staging', action='store_true',
                       help='Sync to staging branch only')
    parser.add_argument('--dry-run', action='store_true',
                       help='Test cherry-picks without creating PRs')
    parser.add_argument('--public-repo', default='.',
                       help='Path to public repository checkout')
    parser.add_argument('--private-repo', 
                       help='Path to private repository checkout')
    
    args = parser.parse_args()
    
    # Determine private repo path
    if args.private_repo:
        private_repo_path = args.private_repo
    else:
        # Assume private repo is in ../code-dot-org-production
        private_repo_path = Path(args.public_repo).parent / 'code-dot-org-production'
        if not private_repo_path.exists():
            print(f"ERROR: Private repository not found at {private_repo_path}")
            print("Please specify --private-repo path")
            sys.exit(1)
    
    # Determine target branches
    if args.production and args.staging:
        print("ERROR: Cannot specify both --production and --staging")
        sys.exit(1)
    elif args.production:
        target_branches = ['production']
    elif args.staging:
        target_branches = ['staging']
    else:
        target_branches = ['production', 'staging']
    
    # Parse commit hashes if provided
    commit_hashes = None
    if args.commits:
        commit_hashes = [x.strip() for x in args.commits.split(',')]
    
    # Run sync
    syncer = PrivateProductionSyncer(args.public_repo, str(private_repo_path))
    syncer.sync_commits(target_branches, commit_hashes, args.dry_run)

if __name__ == '__main__':
    main()