#!/bin/bash

# Pi-hole Google Ads Allowlist Toggle Script
# This script allows you to easily enable or disable the Google ads allowlist

ALLOWLIST_FILE="google-ads-allowlist.txt"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALLOWLIST_PATH="$SCRIPT_DIR/$ALLOWLIST_FILE"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to display usage
show_usage() {
    echo "Usage: $0 [enable|disable|status]"
    echo ""
    echo "Commands:"
    echo "  enable   - Add Google ads domains to Pi-hole allowlist"
    echo "  disable  - Remove Google ads domains from Pi-hole allowlist"
    echo "  status   - Check which domains are currently allowed"
    echo ""
}

# Function to check if running as root or with sudo
check_permissions() {
    if [[ $EUID -ne 0 ]]; then
        echo -e "${RED}Error: This script must be run as root or with sudo${NC}"
        echo "Try: sudo $0 $1"
        exit 1
    fi
}

# Function to check if Pi-hole is installed
check_pihole() {
    if ! command -v pihole &> /dev/null; then
        echo -e "${RED}Error: Pi-hole is not installed or not in PATH${NC}"
        exit 1
    fi
}

# Function to enable allowlist
enable_allowlist() {
    echo -e "${YELLOW}Enabling Google ads allowlist...${NC}"
    
    if [[ ! -f "$ALLOWLIST_PATH" ]]; then
        echo -e "${RED}Error: Allowlist file not found at $ALLOWLIST_PATH${NC}"
        exit 1
    fi
    
    # Read domains from file and add to Pi-hole allowlist
    while IFS= read -r domain || [[ -n "$domain" ]]; do
        # Skip empty lines and comments
        if [[ -n "$domain" && ! "$domain" =~ ^[[:space:]]*# ]]; then
            domain=$(echo "$domain" | tr -d '\r' | xargs) # Remove whitespace and carriage returns
            if [[ -n "$domain" ]]; then
                echo "Adding $domain to allowlist..."
                pihole -w "$domain" > /dev/null 2>&1
            fi
        fi
    done < "$ALLOWLIST_PATH"
    
    echo -e "${GREEN}Google ads allowlist enabled successfully!${NC}"
    echo "Run 'pihole restartdns' to apply changes immediately."
}

# Function to disable allowlist
disable_allowlist() {
    echo -e "${YELLOW}Disabling Google ads allowlist...${NC}"
    
    if [[ ! -f "$ALLOWLIST_PATH" ]]; then
        echo -e "${RED}Error: Allowlist file not found at $ALLOWLIST_PATH${NC}"
        exit 1
    fi
    
    # Read domains from file and remove from Pi-hole allowlist
    while IFS= read -r domain || [[ -n "$domain" ]]; do
        # Skip empty lines and comments
        if [[ -n "$domain" && ! "$domain" =~ ^[[:space:]]*# ]]; then
            domain=$(echo "$domain" | tr -d '\r' | xargs) # Remove whitespace and carriage returns
            if [[ -n "$domain" ]]; then
                echo "Removing $domain from allowlist..."
                pihole -w -d "$domain" > /dev/null 2>&1
            fi
        fi
    done < "$ALLOWLIST_PATH"
    
    echo -e "${GREEN}Google ads allowlist disabled successfully!${NC}"
    echo "Run 'pihole restartdns' to apply changes immediately."
}

# Function to show status
show_status() {
    echo -e "${YELLOW}Checking Google ads allowlist status...${NC}"
    
    if [[ ! -f "$ALLOWLIST_PATH" ]]; then
        echo -e "${RED}Error: Allowlist file not found at $ALLOWLIST_PATH${NC}"
        exit 1
    fi
    
    echo ""
    echo "Domain Status in Pi-hole Allowlist:"
    echo "=================================="
    
    while IFS= read -r domain || [[ -n "$domain" ]]; do
        # Skip empty lines and comments
        if [[ -n "$domain" && ! "$domain" =~ ^[[:space:]]*# ]]; then
            domain=$(echo "$domain" | tr -d '\r' | xargs) # Remove whitespace and carriage returns
            if [[ -n "$domain" ]]; then
                if pihole -w -l | grep -q "^$domain$"; then
                    echo -e "${GREEN}✓${NC} $domain (allowed)"
                else
                    echo -e "${RED}✗${NC} $domain (not allowed)"
                fi
            fi
        fi
    done < "$ALLOWLIST_PATH"
}

# Main script logic
case "$1" in
    enable)
        check_permissions "$1"
        check_pihole
        enable_allowlist
        ;;
    disable)
        check_permissions "$1"
        check_pihole
        disable_allowlist
        ;;
    status)
        check_pihole
        show_status
        ;;
    *)
        show_usage
        exit 1
        ;;
esac