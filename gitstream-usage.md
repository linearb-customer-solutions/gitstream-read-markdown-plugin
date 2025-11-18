# GitStream Usage Examples

This plugin is now compatible with GitStream custom plugins. Here's how to use it:

## Installation in GitStream

1. Create a plugin directory in your GitStream configuration
2. Place the `index.js` file in the plugin directory
3. Reference it in your GitStream automation rules

## Usage in GitStream Rules

### Basic Usage

```yaml
automations:
  read-docs:
    if:
      - {{ pr.files | match(regex=r"docs/.*\.md") | some }}
    run:
      - action: add-comment@v1
        args:
          comment: |
            Documentation content:
            {{ "docs/README.md" | readMarkdownWithLinks }}
```

### With Options

```yaml
automations:
  read-docs-limited:
    if:
      - {{ pr.files | match(regex=r"docs/.*\.md") | some }}
    run:
      - action: add-comment@v1
        args:
          comment: |
            Documentation (max depth 2):
            {{ "docs/README.md" | readMarkdownWithLinks(maxDepth=2) }}
```

### Get Structured Data

```yaml
automations:
  analyze-docs:
    if:
      - {{ pr.files | match(regex=r"docs/.*\.md") | some }}
    run:
      - action: add-comment@v1
        args:
          comment: |
            {% set docData = "docs/README.md" | readMarkdownWithLinks(structured=true) %}
            Found {{ docData.linkedFiles | length }} linked documents
```

## Plugin Function Signature

The main exported function follows GitStream conventions:

```javascript
function readMarkdownWithLinks(filePath, options = {})
```

**Parameters:**
- `filePath` (string): Path to the markdown file (first argument via pipe operator)
- `options` (object): Configuration options (passed in parentheses)
  - `followLinks` (boolean, default: true): Whether to follow internal links
  - `maxDepth` (number, default: 3): Maximum depth to follow links
  - `structured` (boolean, default: false): Return structured data instead of combined text

**Returns:**
- String: Combined content with file headers (default)
- Object: Structured data with content and linked files (if `structured=true`)

## Integration Notes

- Uses console.log() for error logging (GitStream compatible)
- Follows CommonJS module pattern required by GitStream
- Includes comprehensive JSDoc documentation
- Handles file reading errors gracefully
- Prevents circular reference loops
- Supports configurable depth limits

## Repository

This plugin is maintained by LinearB Customer Solutions:
https://github.com/linearb-customer-solutions/gitstream-read-markdown-plugin