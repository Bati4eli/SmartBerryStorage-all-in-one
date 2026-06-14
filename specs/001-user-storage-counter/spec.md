# Feature Specification: User Storage Counter

**Feature Branch**: `[001-user-storage-counter]`

**Created**: 2026-06-08

**Status**: Draft

**Input**: User description: "android & backend: нужно добавить кэшируемый и обновляемый счетчик свободного места у пользователя"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See cloud storage usage in the app (Priority: P1)

As a signed-in user, I want the app to show my cloud storage usage and remaining free space so
that I understand how much room is left before uploading more files.

**Why this priority**: This is the direct user-facing value of the task and the reason the
counter exists at all.

**Independent Test**: Can be fully tested by opening the screen that displays cloud storage and
verifying that the user sees used and remaining space for the current account.

**Acceptance Scenarios**:

1. **Given** the user is signed in and storage data is available, **When** the user opens the
   settings area with cloud storage information, **Then** the app shows both used space and
   remaining free space for that account.
2. **Given** the user has not uploaded any files yet, **When** the user opens the storage
   display, **Then** the app shows zero used space and the full remaining space.

---

### User Story 2 - Reuse cached storage data and refresh it (Priority: P2)

As a signed-in user, I want the app to reuse the last known storage summary and refresh it when
needed so that the display is fast but still updates after my actions.

**Why this priority**: The task explicitly calls for a cached and refreshable counter, and users
need both responsiveness and accuracy.

**Independent Test**: Can be tested by viewing storage data, leaving and reopening the surface,
and then performing a storage-changing action to verify that the displayed value later updates.

**Acceptance Scenarios**:

1. **Given** the app already has a previously loaded storage summary, **When** the user returns
   to the storage display, **Then** the app can show the last known value without waiting for a
   full reload.
2. **Given** the user completes an upload or deletion that changes occupied space, **When** the
   app next refreshes storage information, **Then** the displayed used and remaining space match
   the updated account state.

---

### User Story 3 - Behave clearly when fresh data is unavailable (Priority: P3)

As a signed-in user, I want the app to behave predictably if fresh storage data cannot be loaded
so that I am not misled by a broken or empty widget.

**Why this priority**: Storage information is supportive UI, so failures should not degrade the
main app experience or create confusing empty states.

**Independent Test**: Can be tested by simulating an unavailable refresh and verifying that the
app still presents a stable storage section instead of crashing or showing contradictory data.

**Acceptance Scenarios**:

1. **Given** the app has cached storage data but cannot refresh it right now, **When** the user
   opens the storage display, **Then** the app shows the last known summary instead of an empty
   broken block.
2. **Given** the app has never loaded storage data for this session and the refresh fails,
   **When** the user opens the storage display, **Then** the app shows a clear unavailable state
   without crashing.

### Edge Cases

- What happens when the app has cached data for the user but the account state changed on another
  device before the next refresh?
- How does the app behave when the user opens the storage section during a long-running upload?
- What happens if the backend summary is temporarily unavailable on first load?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: App MUST display the current user's cloud storage summary with at least used space
  and remaining space.
- **FR-002**: App MUST cache the last successfully loaded storage summary for the current signed-in
  user.
- **FR-003**: App MUST refresh the storage summary after user actions that can change occupied
  cloud space, or when the user reopens the relevant storage surface.
- **FR-004**: App MUST distinguish between last known storage data and unavailable fresh data in
  a way that avoids showing an empty broken widget.
- **FR-005**: App MUST keep the storage display scoped to the currently signed-in user and must
  not show another account's cached summary.
- **FR-006**: App MUST present storage values consistently so users can compare used space and
  remaining space without ambiguity.
- **FR-007**: App MUST continue functioning if storage refresh fails; the failure must not crash
  the application or block unrelated user actions.

### Key Entities *(include if feature involves data)*

- **Displayed Storage Summary**: The user-visible storage information shown in the app, including
  used space, remaining space, and availability state.
- **Cached Storage Summary**: The last successfully loaded storage summary stored locally for fast
  reuse by the app.
- **Storage Refresh Trigger**: A user action or screen lifecycle event that causes the app to
  request a newer storage summary.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can open the storage display and see used and remaining space without waiting
  for a full app restart or relogin.
- **SC-002**: After a completed upload or deletion, a later refresh updates the displayed storage
  summary to the new account state.
- **SC-003**: In acceptance testing, the storage display never crashes the app when fresh data is
  unavailable.
- **SC-004**: The app never displays another user's cached storage summary after account changes
  in covered test scenarios.

## Assumptions

- The existing settings screen is the first place where the storage counter will be shown.
- Changing storage plan or purchasing more space is out of scope for this first feature slice.
- The backend will provide one coherent storage summary for the current account rather than
  requiring the app to calculate usage from file lists.
- The app may temporarily show the last known summary while waiting for a newer refresh result.
