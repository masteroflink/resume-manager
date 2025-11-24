# Resume Management System

A simple system for managing multiple resume versions with PDF/HTML generation, powered by Claude Code.

## How It Works

1. Download your resume from Google Docs as plain text
2. Ask Claude to convert it to JSON Resume format
3. Generate PDF/HTML using resume-cli

No scripts, no complex commands - just conversation with Claude.

## Quickstart

```bash
# 1. Install dependencies
npm install

# 2. (Optional) Install pandoc for DOCX and TXT output
brew install pandoc

# 3. Download your resume from Google Docs as plain text
#    File → Download → Plain text (.txt)
#    Save to source/text/resume_backend_developer.txt

# 4. Open Claude Code and convert to JSON Resume format
claude
# Then ask: "Convert source/text/resume_backend_developer.txt to JSON Resume format"

# 5. Build all formats (PDF, HTML, DOCX, TXT)
./scripts/build.sh resume_backend_developer paper

# 6. Find your files in output/backend_developer/paper/
ls output/backend_developer/paper/
# resume.pdf  resume.html  resume.docx  resume.txt
```

## Directory Structure

```
├── source/
│   ├── text/         # Downloaded .txt files from Google Docs
│   └── json/         # JSON Resume files (source of truth)
├── output/           # Generated PDFs and HTMLs
└── package.json      # resume-cli dependency
```

## Setup

```bash
npm install
```

## Workflow

### Adding a New Resume

1. In Google Docs: **File → Download → Plain text (.txt)**
2. Save the file to `source/text/`
3. Ask Claude: "Convert `source/text/myresume.txt` to JSON Resume format"

### Editing Resumes

Ask Claude directly:
- "Update my work experience at Green Key Resources"
- "Add a new skill category for cloud technologies"
- "Change my summary to focus more on backend development"

Or edit JSON files directly in `source/json/`.

### Generating Output

```bash
./scripts/build.sh resume_full_stack_developer paper
```

This generates all formats in `output/full_stack_developer/paper/`:
- `resume.pdf`
- `resume.html`
- `resume.docx` (requires pandoc)
- `resume.txt` (requires pandoc)

### Available Themes

elegant, paper, onepage, short, kendall

### Validating JSON

```bash
npx resume validate source/json/resume_backend.json
```

## Requirements

- Node.js and npm
- Claude Code

## License

MIT
