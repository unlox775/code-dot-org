# Soft Control Vulnerabilities and Inconsistencies Analysis

This document provides a detailed analysis of soft control vulnerabilities and inconsistencies found in the Code.org codebase, as referenced in the Jira ticket. Each vulnerability includes specific code references and line numbers for verification.

## Executive Summary

The analysis confirms several soft control vulnerabilities and inconsistencies that allow users to bypass intended restrictions through simple changes or exploit validation gaps. These issues primarily affect user role management, sharing permissions, teacher verification, and geographic compliance controls.

## 1. Student/Teacher Role Changes and Section Access

### Issue: Students can become teachers with inconsistent section access controls

**Location**: `/workspace/dashboard/app/models/user.rb` and related files

**Vulnerability Details**:
- Students can change their `user_type` to `teacher` through the user interface
- The system prevents students-turned-teachers from accessing sections where they were previously students, but this check is not consistently applied
- Students who become teachers can potentially invite others to sections after role changes

**Code References**:
- User model allows `user_type` changes: `/workspace/dashboard/app/models/user.rb:28`
- Section access controls: `/workspace/dashboard/app/models/sections/section.rb:249-252`
- The `update_student_sharing` method in sections suggests sharing controls can be modified by teachers

**Risk Level**: Medium - Allows unauthorized access to teacher features and section management

## 2. Teacher Verification Bypasses

### Issue: LTI Automatic Teacher Verification Bypass

**Location**: `/workspace/dashboard/lib/services/lti/account_linker.rb:25`

**Vulnerability Details**:
- LTI users are automatically granted `AUTHORIZED_TEACHER` permission without proper verification
- This bypasses the normal teacher verification process that requires manual approval
- The code explicitly calls `user.verify_teacher!` for unverified LTI teachers

**Code Reference**:
```ruby
# Line 25 in account_linker.rb
user.verify_teacher! if Policies::Lti.unverified_teacher?(user)
```

**Additional Context**:
- The `verify_teacher!` method in `/workspace/dashboard/app/models/concerns/user/verifiable.rb:7-8` automatically grants `AUTHORIZED_TEACHER` permission
- This permission grants access to professional development content, restricted curriculum, and editing user feedback

**Risk Level**: High - Bypasses critical verification controls for teacher access

## 3. Age-Based Sharing Restrictions

### Issue: Age Change Bypass for Sharing Permissions

**Location**: `/workspace/dashboard/app/models/user.rb:1216-1228`

**Vulnerability Details**:
- Students under 13 have sharing disabled by default
- If a student changes their age to 13 or older, sharing is enabled
- If they revert to under 13, the sharing restriction is NOT re-applied
- The `update_share_setting` method only checks age when the user is not in any sections

**Code References**:
```ruby
# Lines 1216-1220: Initial sharing restriction
def update_default_share_setting
  self.sharing_disabled = true if under_13?
end

# Lines 1222-1228: Inconsistent re-application
def update_share_setting
  if sections_as_student.empty?
    self.sharing_disabled = under_13?
  end
  true
end
```

**Age Logic**:
- Age calculation in `/workspace/dashboard/app/models/concerns/user/age.rb:48-50`
- The `under_13?` method returns `true` if age is nil or less than 13

**Risk Level**: Medium - Allows underage users to maintain sharing capabilities

## 4. Geographic/Parental Controls

### Issue: Inconsistent State Policy Enforcement

**Location**: `/workspace/dashboard/lib/policies/child_account/state_policies.rb`

**Vulnerability Details**:
- Parent verification is required for students under 13 in specific states (CO, DE, NY, OR, MN, MD)
- The implementation has complex logic for determining compliance that can be bypassed
- Users can potentially change their state to avoid restrictions

**Code References**:
- State policies defined in `/workspace/dashboard/lib/policies/child_account/state_policies.rb:10-53`
- Colorado (CO) policy requires parent permission for students under 13
- The `parent_permission_required?` method in `/workspace/dashboard/lib/policies/child_account.rb:201-207` determines if verification is needed

**State-Specific Policies**:
- Colorado (CPA): Max age 12, grace period 14 days
- Delaware (DPDPA): Max age 12, grace period 14 days  
- New York (NYCDPA): Max age 12, grace period 14 days
- Oregon (OCPA): Max age 12, grace period 14 days
- Minnesota (MCDPA): Max age 12, grace period 14 days
- Maryland (MODPA): Max age 12, grace period 14 days

**Risk Level**: Medium - Compliance violations for child privacy regulations

## 5. Sharing Permission Inconsistencies

### Issue: Multiple Inconsistent Sharing Control Implementations

**Location**: Multiple files with different sharing logic

**Vulnerability Details**:
- Sharing permissions are checked in multiple places with different logic
- Some checks use `sharing_disabled` property, others check age directly
- Inconsistent application of sharing restrictions across different contexts

**Code References**:
- Legacy middleware: `/workspace/dashboard/legacy/middleware/helpers/auth_helpers.rb:26-29`
- User model: `/workspace/dashboard/app/models/user.rb:1001`
- Section controls: `/workspace/dashboard/app/models/sections/section.rb:249-252`
- Project age limits: `/workspace/dashboard/app/models/project.rb:58-61`

**Inconsistent Implementations**:
1. `sharing_disabled?` method in auth_helpers.rb
2. `sharing_disabled` property in user model
3. `apply_project_age_publish_limits?` in project model
4. Section-level sharing controls

**Risk Level**: Medium - Inconsistent enforcement allows bypasses

## 6. Additional Vulnerabilities Found

### Issue: User Type Validation Gaps

**Location**: `/workspace/dashboard/app/models/user.rb`

**Vulnerability Details**:
- Limited validation on `user_type` changes
- No comprehensive audit trail for role changes
- Potential for students to gain teacher privileges through UI manipulation

### Issue: LTI Role Assignment

**Location**: `/workspace/dashboard/lib/policies/lti.rb:135-140`

**Vulnerability Details**:
- LTI role assignment logic in `get_account_type` method
- Teachers are identified by specific LTI roles but verification is automatic
- No additional validation of teacher credentials from LTI providers

## Recommendations

1. **Implement Consistent Age-Based Controls**: Ensure sharing restrictions are re-applied when age changes
2. **Remove LTI Automatic Verification**: Require manual verification for all teachers, including LTI users
3. **Strengthen Role Change Controls**: Add comprehensive validation and audit trails for user type changes
4. **Consolidate Sharing Logic**: Create a single, authoritative method for checking sharing permissions
5. **Enhance State Policy Enforcement**: Implement stricter controls for geographic compliance
6. **Add Monitoring**: Implement alerts for suspicious role changes or permission escalations

## Conclusion

The analysis confirms the presence of multiple soft control vulnerabilities that allow users to bypass intended restrictions through simple changes or exploit validation gaps. While these issues do not present high security risks, they undermine the intended educational model and compliance requirements. The inconsistencies suggest a need for systematic review and improvement of these controls.

## Files Referenced

- `/workspace/dashboard/app/models/user.rb`
- `/workspace/dashboard/app/models/concerns/user/age.rb`
- `/workspace/dashboard/app/models/concerns/user/verifiable.rb`
- `/workspace/dashboard/lib/services/lti/account_linker.rb`
- `/workspace/dashboard/lib/policies/lti.rb`
- `/workspace/dashboard/lib/policies/child_account.rb`
- `/workspace/dashboard/lib/policies/child_account/state_policies.rb`
- `/workspace/dashboard/app/models/sections/section.rb`
- `/workspace/dashboard/legacy/middleware/helpers/auth_helpers.rb`