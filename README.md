# Pi-hole Google Ads Allowlist

A comprehensive allowlist for Pi-hole to ensure Google advertising and keyword-related services work properly. This project provides an easy-to-use toggle system for enabling and disabling Google ads domains.

## Overview

When using Pi-hole with aggressive blocking lists, many Google advertising and analytics services can be blocked, which may affect:
- Google Ads campaigns and tracking
- Google Analytics functionality  
- Google Shopping results
- YouTube advertising
- Google Search ads and keyword functionality
- Website monetization through Google AdSense

This allowlist contains carefully curated domains that are essential for Google advertising and keyword-related functionality while maintaining your privacy and ad-blocking preferences.

## Files

- **`google-ads-allowlist.txt`** - The main allowlist file containing Google advertising domains
- **`toggle-allowlist.sh`** - Bash script for easy enable/disable functionality
- **`README.md`** - This documentation

## Quick Start

### Option 1: Using the Toggle Script (Recommended)

1. Clone or download this repository:
   ```bash
   git clone https://github.com/gabrielbacha/pi-hole-google-ads-allowlist.git
   cd pi-hole-google-ads-allowlist
   ```

2. Make the script executable (if not already):
   ```bash
   chmod +x toggle-allowlist.sh
   ```

3. Enable the Google ads allowlist:
   ```bash
   sudo ./toggle-allowlist.sh enable
   ```

4. Restart Pi-hole DNS to apply changes:
   ```bash
   pihole restartdns
   ```

### Option 2: Manual Pi-hole Configuration

1. Download the allowlist file:
   ```bash
   wget https://raw.githubusercontent.com/gabrielbacha/pi-hole-google-ads-allowlist/main/google-ads-allowlist.txt
   ```

2. Add domains to Pi-hole allowlist:
   ```bash
   # Method 1: Add all domains at once
   grep -v '^#' google-ads-allowlist.txt | grep -v '^$' | while read domain; do pihole -w "$domain"; done
   
   # Method 2: Import via Pi-hole web interface
   # Copy the contents of google-ads-allowlist.txt and paste into:
   # Pi-hole Admin → Domains → Allowlist → Bulk import
   ```

## Usage

### Toggle Script Commands

```bash
# Enable Google ads allowlist
sudo ./toggle-allowlist.sh enable

# Disable Google ads allowlist  
sudo ./toggle-allowlist.sh disable

# Check status of domains
./toggle-allowlist.sh status
```

### Manual Pi-hole Commands

```bash
# Add a single domain to allowlist
pihole -w domain.com

# Remove a domain from allowlist
pihole -w -d domain.com

# List all allowed domains
pihole -w -l

# Restart DNS service
pihole restartdns
```

## Included Domains

The allowlist includes domains for:

### Core Google Advertising Services
- `googleadservices.com` - Google Ads conversion tracking
- `googlesyndication.com` - Google AdSense and display ads
- `googletagmanager.com` - Google Tag Manager for tracking

### Analytics and Tracking
- `google-analytics.com` - Google Analytics
- `doubleclick.net` - Google DoubleClick advertising network

### Content Delivery and APIs  
- `gstatic.com` - Google static content delivery
- `googleapis.com` - Google API services

### Shopping and Commerce
- `shopping.google.com` - Google Shopping results
- `merchants.google.com` - Google Merchant Center

### Video and Display Advertising
- `youtube.com` - YouTube advertising
- `googlevideo.com` - Google video content

## Troubleshooting

### Script Issues
- **Permission denied**: Run with `sudo` for enable/disable operations
- **Pi-hole not found**: Ensure Pi-hole is installed and in your PATH
- **File not found**: Make sure you're running the script from the correct directory

### Domain Issues
- **Changes not taking effect**: Run `pihole restartdns` after making changes
- **Still seeing blocked requests**: Some domains may need time to propagate
- **Too permissive**: Use `disable` command and manually add only needed domains

### Checking Status
```bash
# View Pi-hole query log
pihole -t

# Check if specific domain is allowed
pihole -w -l | grep domain.com

# View recent blocked/allowed queries
tail -f /var/log/pihole.log
```

## Customization

You can customize the allowlist by:

1. **Editing the allowlist file**: Add or remove domains from `google-ads-allowlist.txt`
2. **Selective enabling**: Manually add only specific domains you need
3. **Testing**: Use the status command to verify which domains are currently allowed

## Security Considerations

- This allowlist only includes domains necessary for Google advertising functionality
- Regular Google search and core services work without these domains
- You can always disable the entire allowlist if you prefer maximum blocking
- Consider reviewing the domain list periodically for any changes

## Contributing

Feel free to submit issues or pull requests if you:
- Find domains that should be added or removed
- Encounter bugs in the toggle script  
- Have suggestions for improvements

## License

This project is provided as-is for educational and personal use. Please review the domains and ensure they meet your privacy and security requirements before use.