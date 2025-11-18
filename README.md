# GitStream Read Markdown Plugin

A GitStream plugin for reading markdown files with automatic internal link following. This plugin extends the basic `readFile` functionality by recursively following internal markdown links and providing a comprehensive view of interconnected documentation.

## Features

- **Internal Link Following**: Automatically follows `[text](./file.md)` style links
- **Circular Reference Detection**: Prevents infinite loops when files reference each other
- **Depth Control**: Configurable maximum depth to control how deep to follow links
- **Path Resolution**: Handles relative paths correctly (`./ ../` patterns)
- **Comprehensive Output**: Provides both structured data and combined content views

## Installation

### 🚀 Automatic Installation

```bash
curl -fsSL https://raw.githubusercontent.com/linearb-customer-solutions/gitstream-read-markdown-plugin/main/install.sh | bash
```

**Smart Detection:**
- **Repository-level**: `.cm/plugins/filters/readMarkdownWithLinks/` (any repo)
- **Organization-level**: `plugins/filters/readMarkdownWithLinks/` (when in `cm` folder)

Uses git submodules for proper version control and easy updates.

### 🔗 Manual Installation

#### Individual Repository
```bash
git submodule add https://github.com/linearb-customer-solutions/gitstream-read-markdown-plugin.git .cm/plugins/filters/readMarkdownWithLinks
```

#### GitStream Organization Config  
```bash
git submodule add https://github.com/linearb-customer-solutions/gitstream-read-markdown-plugin.git plugins/filters/readMarkdownWithLinks
```

### 🔄 Updates

Update to the latest version:
```bash
git submodule update --remote .cm/plugins/filters/readMarkdownWithLinks
# or for org config:
git submodule update --remote plugins/filters/readMarkdownWithLinks
```

## Usage in GitStream

### 🔍 Primary Use Case: LinearB AI Code Review Integration

The main use case for this plugin is enhancing LinearB AI code reviews with comprehensive documentation context.

#### Basic Usage

```yaml
guidelines: |
  {{ "REVIEW_RULES.md" | readMarkdownWithLinks }}
  
  Additional Context:
  {{ "README.md" | readMarkdownWithLinks(maxDepth=2) }}
```

### 📚 Complete Examples

See the included example files for comprehensive configurations:
- `read_markdown_with_links.cm` - Full automation examples
- After installation, check your generated example config file

**Key Benefits:**
- 🧠 **Rich Context**: AI gets comprehensive documentation for better reviews
- 📚 **Linked Knowledge**: Follows internal documentation links automatically  
- 🎯 **Dynamic Guidelines**: Different rules based on changed file areas
- 👥 **Onboarding**: Enhanced guidance for new contributors

## Configuration Options

- `followLinks` (boolean, default: `true`): Whether to follow internal markdown links
- `maxDepth` (number, default: `3`): Maximum depth to follow links to prevent excessive recursion

## API

### `readMarkdownWithLinks(filePath, options)`

Returns the combined content of the main file and all linked files as a formatted string.

### `readMarkdown(filePath, options)`

Returns a structured object containing:
- `path`: Absolute path to the file
- `content`: File content
- `error`: Any error encountered
- `linkedFiles`: Array of linked file objects with the same structure

## Integration with GitStream

In a GitStream environment, replace the mock `readFile` function with the actual GitStream `readFile` function:

```javascript
// Replace this line in index.js:
// function readFile(filePath) { ... }

// With:
const readFile = gitstream.readFile; // or however GitStream exposes readFile
```

## Example Output

```
=== main.md ===
# Main Document
Content of main document...

  === related.md ===
# Related Document
Content of related document...

    === subdoc.md ===
# Sub Document
Content of sub document...
```

## Testing

Run the included test:

```bash
node test.js
```

This creates sample markdown files and demonstrates the plugin functionality.