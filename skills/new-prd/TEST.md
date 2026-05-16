# New-PRD Skill Tests

This file documents the test cases for the new-prd skill file-mode feature.

## Test Case 1: File-mode with valid PRD file (all sections present)

**File:** `.claude/test-prd-valid.md`

**Setup:** Create a test PRD with all seven required sections and an H1 heading.

**Invocation:** `/new-prd .claude/test-prd-valid.md`

**Expected behavior:**
- Skill reads the file
- Skill validates all seven sections are present
- Skill extracts the H1 title
- Skill executes `gh issue create --title "PRD: <title>" --body-file <path> --assignee @me`
- Skill prints the returned issue URL
- Does NOT invoke prd-researcher agent

## Test Case 2: File-mode with missing sections

**File:** `.claude/test-prd-missing-sections.md`

**Setup:** Create a test PRD missing the "## Testing Decisions" section.

**Invocation:** `/new-prd .claude/test-prd-missing-sections.md`

**Expected behavior:**
- Skill reads the file
- Skill validates sections and finds "## Testing Decisions" is missing
- Skill lists the missing sections: "Missing required sections: ## Testing Decisions"
- Skill halts without filing an issue
- Does NOT invoke gh issue create
- Does NOT invoke prd-researcher agent

## Test Case 3: File-mode with no H1 heading

**File:** `.claude/test-prd-no-h1.md`

**Setup:** Create a test PRD with all required sections but no H1 heading.

**Invocation:** `/new-prd .claude/test-prd-no-h1.md`

**Expected behavior:**
- Skill reads the file
- Skill validates all seven sections are present
- Skill searches for H1 heading and finds none
- Skill reports: "Error: no H1 heading found in file"
- Skill halts without filing an issue
- Does NOT invoke gh issue create
- Does NOT invoke prd-researcher agent

## Test Case 4: Synthesis-mode (no argument)

**Invocation:** `/new-prd`

**Expected behavior:**
- Skill does NOT attempt file-mode
- Skill invokes prd-researcher agent (first pass) to get module sketch
- Skill asks the two confirmation questions
- Skill invokes prd-researcher agent (second pass) with sketch and answers
- Skill prints the returned issue URL
- Matches the current (existing) behavior exactly

## Test Case 5: Synthesis-mode with feature title argument

**Invocation:** `/new-prd "New feature title"`

**Expected behavior:**
- Skill recognizes this is NOT a file path (no .md extension, not a file)
- Skill invokes prd-researcher agent (first pass) with the provided title
- Skill proceeds with confirmation questions and second pass
- Matches the current (existing) behavior exactly
