# Soft Control Inconsistencies in Code.org

This document discusses some examples of "soft controls" in our system - features and restrictions that are important for user experience and curriculum integrity, but which are inconsistently implemented or easily bypassed. These aren't high-security issues, but they can lead to unintended access or behaviors that undermine our intended educational model.

## Student-Teacher Role Changes

**Issue**: The frontend hides the role change control when students are in sections, but the backend doesn't enforce this restriction.

We allow teachers to switch to student mode to see what their students experience, and students can switch back to teachers. This is totally fine - all our curriculum is public anyway, and students can just create their own teacher accounts if they want. The only thing we try to limit is when students are actively in a section, we don't want them seeing that "become a teacher" option because it's just too common for students to click around and think "oh, I could be my teacher, check this out." 

The problem is this restriction is only implemented on the frontend - the UI hides the control, but the backend API will still let you change your role. It's not a big deal since the access doesn't really matter, but it's inconsistent.

## Verified Teacher Access Is Easy to Overlook

**Issue**: Our access controls for verified teacher status don't have strong tests in place, making it easy to accidentally grant this permission.

Because verified teacher access is a soft control, it's easy to be lax about enforcement. An example of this is the recent vulnerability BC-90, which allowed verified teacher status to be granted automatically as part of the LTI workflow. In [account_linker.rb](https://github.com/code-dot-org/code-dot-org/blob/staging/dashboard/lib/services/lti/account_linker.rb#L25), we automatically grant `AUTHORIZED_TEACHER` permission to LTI users, bypassing our normal verification process.

The thing is, being a verified teacher doesn't actually grant you that much access - it's more of a soft control that we use to limit certain features. So this isn't really a security issue, it's just an example of how we sometimes get lax about enforcement when it's "just" authorized teacher access. Our engineers probably aren't being super careful about it because it's not a hard control.

## Age-Based Restrictions Are Implemented Ad Hoc

**Issue**: Age 13 checks are scattered throughout the codebase with different logic and conditions.

We have age-based restrictions in multiple places, but they're implemented inconsistently. For example, in [user.rb](https://github.com/code-dot-org/code-dot-org/blob/staging/dashboard/app/models/user.rb#L1216-1228), sharing is disabled for students under 13, but only when they're not in sections. In [levels_helper.rb](https://github.com/code-dot-org/code-dot-org/blob/staging/dashboard/app/helpers/levels_helper.rb#L965-980), we check if students are under 13 AND don't have terms of service accepted for certain programming tools.

The problem is these checks are implemented wherever they're needed in the code, with different conditions and logic. Some check just age, others check age plus state, others check age plus terms acceptance. It's all ad hoc - there's no central place that defines what "under 13" means or what restrictions should apply.

This leads to situations where depending on how you navigate through the system, you might end up with different restrictions applied even though you're the same age. For example, a student under 13 might have sharing disabled in one context but enabled in another, just because the code paths are different.

## Geographic/Parental Controls

**Issue**: Parent verification requirements vary by state but the enforcement logic is complex and can be inconsistent.

We have different state policies for Colorado, Delaware, New York, Oregon, Minnesota, and Maryland that require parent verification for students under 13. The logic for determining when these apply is pretty complex - it depends on when the account was created, what state they're in, whether they have a personal email, etc.

The implementation in [state_policies.rb](https://github.com/code-dot-org/code-dot-org/blob/staging/dashboard/lib/policies/child_account/state_policies.rb) has a lot of edge cases and special handling, which means there are probably scenarios where the restrictions don't apply when they should, or vice versa.

## Why These Matter

These aren't security vulnerabilities in the traditional sense - they're more like inconsistencies in how we implement our "soft controls." The problem is that when controls are inconsistently enforced, it can lead to:

- Users accessing features in ways we didn't intend
- Confusion about what restrictions actually apply
- Engineers being less careful about enforcement because "it's just a soft control"

The goal isn't to eliminate all these inconsistencies (some of them are probably fine), but to be more systematic about where and how we apply these controls so they work as intended.