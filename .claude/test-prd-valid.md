# Test Feature for File-Mode Validation

## Problem Statement

Users currently have no way to validate PRD files before filing them as issues. This can lead to incomplete or malformed PRDs being filed.

## Solution

Provide a file-mode option for the `/new-prd` command that reads a PRD from disk, validates its structure, and files it directly without requiring interaction.

## User Stories

1. As a developer, I want to write a PRD in my editor and validate it locally before filing, so that I catch structural issues early.
2. As a developer, I want to file a pre-written PRD with a single command, so that I don't need to go through the synthesis process.
3. As a developer, I want clear error messages if my PRD is invalid, so that I know exactly what needs to be fixed.

## Implementation Decisions

- Add file-mode detection: if the argument is a file path with `.md` extension, enter file-mode
- Validate all seven required sections are present in the file
- Extract the issue title from the first H1 heading
- File the issue with title "PRD: <extracted-title>" using the file directly as body
- Do not invoke prd-researcher in file-mode

## Testing Decisions

- File-mode should be tested with valid PRD files
- File-mode should be tested with missing sections to verify error reporting
- File-mode should be tested with missing H1 heading to verify error reporting
- Synthesis-mode should be tested to ensure no regression

## Out of Scope

- Support for other file formats (only Markdown)
- Automatic formatting or correction of PRD files
- Interactive section editing

## Further Notes

This feature makes it easier for users to prepare PRDs offline and batch-file them through the skill.
