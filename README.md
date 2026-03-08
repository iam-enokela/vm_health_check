# VM Health Check Script

A comprehensive shell script to monitor the health of Ubuntu virtual machines by analyzing CPU, Memory, and Disk space utilization.

## Overview

The `vm_health_check.sh` script analyzes three key system metrics on Ubuntu VMs:
- **CPU Utilization**
- **Memory Utilization**
- **Disk Space Utilization**

### Health Status Determination

- **HEALTHY**: All metrics are below 60% utilization
- **NOT HEALTHY**: Any metric exceeds 60% utilization

## Features

✅ **Real-time Resource Monitoring**
- CPU usage calculation using `top` command
- Memory usage from `free` command
- Disk space from `df` command

✅ **Color-Coded Output**
- Green for HEALTHY status
- Red for NOT HEALTHY status
- Blue for explanations and details

✅ **Detailed Explanation Mode**
- Run with `explain` argument for detailed insights
- Provides troubleshooting recommendations
- Shows what to do if resources are constrained

✅ **Exit Codes**
- Returns `0` if VM is HEALTHY
- Returns `1` if VM is NOT HEALTHY
- Suitable for monitoring systems and cron jobs

✅ **Ubuntu Compatible**
- Works on all Ubuntu versions
- Uses standard Ubuntu commands
- No external dependencies required

## Requirements

- Ubuntu/Debian-based Linux distribution
- Standard utilities: `bash`, `top`, `free`, `df`
- These are pre-installed on most Ubuntu systems

## Installation

1. Clone the repository:
```bash
git clone https://github.com/iam-enokela/vm_health_check.git
cd vm_health_check
```

2. Make the script executable:
```bash
chmod +x vm_health_check.sh
```

## Usage

### Basic Health Check
Run the script without arguments to get a quick health status:
```bash
./vm_health_check.sh
```

### Detailed Health Check with Explanation
Run with the `explain` argument for detailed explanations:
```bash
./vm_health_check.sh explain
```

## Exit Codes

The script returns different exit codes for integration with monitoring systems:
- `0`: VM is HEALTHY
- `1`: VM is NOT HEALTHY

## Use Cases

### Manual Monitoring
```bash
# Quick health check
./vm_health_check.sh

# Detailed check
./vm_health_check.sh explain
```

### Cron Job Integration
Add to your crontab for periodic checks:
```bash
# Check every 5 minutes
*/5 * * * * /path/to/vm_health_check.sh >> /var/log/vm_health.log

# Check daily with detailed report
0 9 * * * /path/to/vm_health_check.sh explain >> /var/log/vm_health_daily.log
```

## Troubleshooting

### High CPU Usage
If CPU exceeds 60%, the script will report NOT HEALTHY. To investigate:
```bash
top -b -n 1 | head -20  # See top processes
ps aux --sort=-%cpu | head -10  # Show CPU-intensive processes
```

### High Memory Usage
If memory exceeds 60%, check what's consuming memory:
```bash
free -h  # Detailed memory info
top -b -n 1 -o %MEM | head -20  # Top memory-consuming processes
```

### High Disk Usage
If disk exceeds 60%, find large files and directories:
```bash
du -sh /*  # Show size of each directory in root
du -sh ./* | sort -rh | head -20  # Top 20 largest items in current dir
df -h  # Detailed disk info
```

## Customization

You can modify the `THRESHOLD` variable in the script to change the alert percentage.

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest improvements
- Submit pull requests

## License

This project is open source and available under the MIT License.

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Run the script with `explain` argument for more details
3. Open an issue on GitHub

---

**Author**: iam-enokela  
**Created**: March 2026  
**Last Updated**: March 8, 2026