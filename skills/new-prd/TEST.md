# New-PRD Skill Tests

This file documents the test cases for the new-prd skill file-mode feature.
To test file-mode, create test `.md` files based on `.claude/prd-template.md`.

## Test Case 1: File-mode with valid PRD file (all sections present)

**Setup:** Create a test PRD that follows `.claude/prd-template.md` with all seven required sections and an H1 heading.

**Invocation:** `/new-prd <path-to-valid-prd>.md`

**Expected behavior:**
- Skill reads the file
- Skill validates all seven sections are present
- Skill extracts the H1 title
- Skill executes `gh issue create --title "PRD: <title>" --body-file <path> --assignee @me`
- Skill prints the returned issue URL
- Does NOT invoke prd-researcher agent

## Test Case 2: File-mode with missing sections

**Setup:** Create a test PRD based on `.claude/prd-template.md` but omit one section (e.g., "## Testing Decisions").

**Invocation:** `/new-prd <path-to-invalid-prd>.md`

**Expected behavior:**
- Skill reads the file
- Skill validates sections and finds at least one missing
- Skill lists the missing sections
- Skill halts without filing an issue
- Does NOT invoke gh issue create
- Does NOT invoke prd-researcher agent

## Test Case 3: File-mode with no H1 heading

**Setup:** Create a test PRD with all required sections from `.claude/prd-template.md` but no H1 heading.

**Invocation:** `/new-prd <path-to-prd-no-h1>.md`

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
