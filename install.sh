#!/bin/bash

# GitStream readMarkdownWithLinks Plugin Installer
# Supports both repository-level and organization-level installation

set -e

PLUGIN_NAME="readMarkdownWithLinks"
REPO_URL="https://github.com/linearb-customer-solutions/gitstream-read-markdown-plugin.git"

echo "🔧 GitStream $PLUGIN_NAME Plugin Installer"
echo ""

# Initialize global variables
PLUGIN_DIR=""
INSTALL_TYPE=""

# Function to detect installation type and set paths
detect_installation_type() {
    echo "🔍 Detecting installation type..."
    
    # Get current directory name
    CURRENT_DIR=$(basename "$(pwd)")
    
    # Check if we're in a GitStream organization config repository (parent folder is "cm")
    if [ "$CURRENT_DIR" = "cm" ]; then
        echo "📋 Detected: GitStream organization configuration repository (folder: cm)"
        PLUGIN_DIR="plugins/filters/$PLUGIN_NAME"
        INSTALL_TYPE="organization"
        return 0
    fi
    
    # Check if we're in a regular repository
    if [ -d ".git" ]; then
        echo "📁 Detected: Individual repository (folder: $CURRENT_DIR)"
        PLUGIN_DIR=".cm/plugins/filters/$PLUGIN_NAME"
        INSTALL_TYPE="repository"
        return 0
    fi
    
    # Ask user if detection failed
    echo "❓ Could not auto-detect installation type."
    echo "   Current directory: $CURRENT_DIR"
    echo ""
    echo "Please choose:"
    echo "1) Repository-level installation (.cm/plugins/filters/$PLUGIN_NAME)"
    echo "2) Organization-level installation (plugins/filters/$PLUGIN_NAME)"
    echo ""
    read -p "Enter choice [1-2]: " choice
    
    case $choice in
        1)
            PLUGIN_DIR=".cm/plugins/filters/$PLUGIN_NAME"
            INSTALL_TYPE="repository"
            ;;
        2)
            PLUGIN_DIR="plugins/filters/$PLUGIN_NAME"
            INSTALL_TYPE="organization"
            ;;
        *)
            echo "❌ Invalid choice"
            exit 1
            ;;
    esac
}

# Function to install plugin files
install_plugin_files() {
    echo ""
    echo "📦 Installing plugin files..."
    
    # Create plugin directory
    mkdir -p "$PLUGIN_DIR"
    
    # Download the main plugin file
    echo "⬇️  Downloading index.js..."
    curl -fsSL "https://raw.githubusercontent.com/linearb-customer-solutions/gitstream-read-markdown-plugin/main/index.js" -o "$PLUGIN_DIR/index.js" || {
        echo "❌ Failed to download plugin file"
        echo "   Please check your internet connection and try again"
        exit 1
    }
    
    echo "✅ Successfully installed plugin files"
    echo "   Location: $PLUGIN_DIR/index.js"
    
    return 0
}

# Function to print manual installation instructions
print_manual_instructions() {
    echo ""
    echo "📋 Manual Installation Instructions:"
    echo ""
    if [ "$INSTALL_TYPE" = "organization" ]; then
        echo "For organization-level installation:"
        echo "  mkdir -p plugins/filters/$PLUGIN_NAME"
        echo "  curl -fsSL https://raw.githubusercontent.com/linearb-customer-solutions/gitstream-read-markdown-plugin/main/index.js -o plugins/filters/$PLUGIN_NAME/index.js"
    else
        echo "For repository-level installation:"
        echo "  mkdir -p .cm/plugins/filters/$PLUGIN_NAME"
        echo "  curl -fsSL https://raw.githubusercontent.com/linearb-customer-solutions/gitstream-read-markdown-plugin/main/index.js -o .cm/plugins/filters/$PLUGIN_NAME/index.js"
    fi
}

# Function to create example configuration
create_example_config() {
    local config_file
    if [ "$INSTALL_TYPE" = "organization" ]; then
        config_file="gitstream.readMarkdownWithLinks.example.cm"
    else
        mkdir -p ".cm"
        config_file=".cm/gitstream.readMarkdownWithLinks.example.cm"
    fi
    
    echo ""
    echo "📝 Creating example configuration..."
    cat > "$config_file" << 'EOF'
# Basic example using readMarkdownWithLinks for LinearB AI code reviews
# See read_markdown_with_links.cm for comprehensive examples

manifest:
  version: 1.0

automations:
  ai_review_with_docs:
    if:
      - {{ not pr.draft }}
    run:
      - action: code-review@v1
        args:
          guidelines: |
            {{ "REVIEW_RULES.md" | readMarkdownWithLinks | dump }}
            
            Project Context:
            {{ "README.md" | readMarkdownWithLinks(maxDepth=2) | dump }}
EOF

    echo "✅ Created example config: $config_file"
}

# Main installation flow
main() {
    detect_installation_type
    
    echo ""
    echo "🎯 Installing to: $PLUGIN_DIR"
    echo "📋 Installation type: $INSTALL_TYPE"
    
    # Install plugin files
    install_plugin_files
    
    create_example_config
    
    echo ""
    echo "🎉 Installation complete!"
    echo ""
    echo "📖 Next Steps:"
    if [ "$INSTALL_TYPE" = "organization" ]; then
        echo "1. Review the example configuration: gitstream.readMarkdownWithLinks.example.cm"
        echo "2. Add the plugin usage to your gitstream.cm file"
    else
        echo "1. Review the example configuration: .cm/gitstream.readMarkdownWithLinks.example.cm"
        echo "2. Add the plugin usage to your .cm/gitstream.cm file"
    fi
    echo "3. Test with: {{ \"README.md\" | readMarkdownWithLinks }}"
    echo ""
    echo "🔧 Plugin Location: $PLUGIN_DIR"
    echo "📚 Documentation: https://github.com/linearb-customer-solutions/gitstream-read-markdown-plugin"
    echo ""
    echo "🔄 Update plugin: Re-run this installer to get the latest version"
}

# Run main function
main "$@"