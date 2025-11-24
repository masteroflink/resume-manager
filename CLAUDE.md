# CLAUDE.md

## Project Purpose
Resume management system for maintaining multiple resume versions with PDF, HTML, DOCX, and TXT generation.

## Directory Structure
```
├── source/
│   ├── text/         # Downloaded resumes from Google Docs (.txt)
│   └── json/         # JSON Resume format files (source of truth)
├── output/           # Generated files organized by specialty and theme (git-ignored)
│   └── {specialty}/
│       └── {theme}/
│           ├── resume.pdf
│           ├── resume.html
│           ├── resume.docx
│           └── resume.txt
├── scripts/
│   └── build.sh      # Build script for generating all formats
└── package.json      # resume-cli dependency
```

## File Naming Convention
All JSON resume files must follow the format: `resume_{specialty}.json`
- `resume_full_stack_developer.json`
- `resume_backend_developer.json`
- `resume_data_engineer.json`

## Workflow

### 1. Adding a New Resume
1. Download from Google Docs as Plain Text (.txt)
2. Save to `source/text/`
3. Ask Claude: "Read `source/text/filename.txt` and convert to JSON Resume format"
4. Claude saves JSON to `source/json/resume_{specialty}.json`

### 2. Editing Resumes
- Edit JSON files directly in `source/json/`
- Or ask Claude: "Update my work experience at [Company] with [changes]"

### 3. Building All Formats
```bash
./scripts/build.sh resume_full_stack_developer elegant
```

This generates PDF, HTML, DOCX, and TXT in `output/full_stack_developer/elegant/`

Available themes: elegant, paper, kendall, flat, modern, classy, class, short, slick, kwan, onepage

### 4. Validating JSON
```bash
npx resume validate source/json/resume_full_stack_developer.json
```

## Dependencies
- Node.js and npm (for resume-cli)
- Pandoc (for DOCX and TXT generation): `brew install pandoc`

## JSON Resume Schema
Reference: https://jsonresume.org/schema/

Key sections:
- `basics` - name, email, phone, summary, location, profiles
- `work` - array of work experiences
- `education` - array of education entries
- `skills` - array of skill categories with keywords
- `projects` - array of projects

## Tips for Claude
- When converting text to JSON, extract all relevant information into proper JSON Resume schema
- Preserve exact dates, company names, and achievements
- Group related skills into categories
- Always validate JSON after creation
- JSON filenames must follow `resume_{specialty}.json` format

## Theme Compatibility Notes
For maximum theme compatibility, include these fields:

### Work entries
Include both `name` and `company` fields (some themes use one or the other):
```json
{
  "name": "Company Name",
  "company": "Company Name",
  "position": "Job Title",
  "startDate": "2020-01",
  "endDate": "2023-12"
}
```

### Education entries
Always include `startDate` (some themes require it):
```json
{
  "institution": "University Name",
  "studyType": "Bachelor of Science",
  "area": "Computer Science",
  "startDate": "2015",
  "endDate": "2019"
}
```

### Profile entries
Always include `username` for all profiles (some themes like "short" only display profiles with usernames). For LinkedIn, use just the name portion without trailing numbers:
```json
{
  "network": "LinkedIn",
  "username": "john-doe",
  "url": "https://www.linkedin.com/in/john-doe-123456"
}
```

### Project entries
Include both `description` and `summary` fields (some themes use one or the other):
```json
{
  "name": "Project Name",
  "url": "https://github.com/user/project",
  "description": "Project description text",
  "summary": "Project description text"
}
```
