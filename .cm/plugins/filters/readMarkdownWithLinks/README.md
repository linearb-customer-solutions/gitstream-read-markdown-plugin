# readMarkdownWithLinks GitStream Plugin

This plugin reads markdown files and follows internal links to create comprehensive documentation views.

## Installation

This plugin is installed at the repository level. The files should be placed in:
```
.cm/plugins/filters/readMarkdownWithLinks/
├── index.js
├── README.md
└── read_markdown_with_links.cm (example config)
```

## Usage

```yaml
# Basic usage
{{ "README.md" | readMarkdownWithLinks }}

# With options
{{ "docs/api.md" | readMarkdownWithLinks(maxDepth=2, followLinks=true) }}
```

## Options

- `followLinks` (boolean, default: true): Follow internal markdown links
- `maxDepth` (number, default: 3): Maximum depth to follow links
- `structured` (boolean, default: false): Return structured data instead of text

## Example Output

```
=== README.md ===
# Main Documentation
Content here...

  === getting-started.md ===
# Getting Started
Content here...

    === installation.md ===
# Installation
Content here...
```