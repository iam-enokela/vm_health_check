# VM Health Check

## Overview
This repository contains a script designed to monitor the health of virtual machines (VMs). The script checks various metrics and provides outputs that can alert users to potential issues with their VMs.

## Features
- **CPU Monitoring**: Checks CPU usage and alerts if it exceeds a specified threshold.
- **Memory Usage**: Monitors memory consumption and provides reports.
- **Disk Space**: Alerts users when disk space is low.
- **Network Status**: Checks network connectivity and reports any issues.
- **Custom Configurations**: Users can configure the thresholds for alerts and customize the checks performed.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/iam-enokela/vm_health_check.git
   cd vm_health_check
   ```
2. Install the required dependencies (if any):
   ```bash
   pip install -r requirements.txt
   ```

## Usage
To run the VM health check script, execute the following command:
```bash
python health_check.py
```

### Command-line options:
- `--cpu-threshold`: Set a custom CPU usage threshold (default is 80%).
- `--memory-threshold`: Set a custom memory usage threshold (default is 80%).
- `--disk-threshold`: Set a custom disk space threshold (default is 10%).

#### Example:
```bash
python health_check.py --cpu-threshold 90 --memory-threshold 70
```

## Troubleshooting
- **Script Fails to Execute**: Ensure that Python is installed and the required dependencies are present.
- **Alerts Not Triggering**: Check the configuration values for thresholds; ensure they are set correctly.
- **Performance Issues**: If the script is slow, check VM performance and system resource usage.

## Contributing
We welcome contributions! Please fork the project and submit a pull request for any enhancements or bug fixes.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
