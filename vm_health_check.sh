#!/bin/bash

#################################################################
# VM Health Check Script for Ubuntu
# 
# This script analyzes the health of a virtual machine based on:
# - CPU utilization
# - Memory utilization
# - Disk space utilization
#
# Thresholds:
# - If ANY metric is > 60%: VM is NOT HEALTHY
# - If ALL metrics are < 60%: VM is HEALTHY
#
# Usage:
#   ./vm_health_check.sh              # Show health status
#   ./vm_health_check.sh explain      # Show health status with detailed explanation
#################################################################

set -o pipefail

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Thresholds
THRESHOLD=60

# Check if explain flag is passed
EXPLAIN_MODE=false
if [ "$1" == "explain" ]; then
    EXPLAIN_MODE=true
fi

# Initialize status variables
cpu_status="HEALTHY"
memory_status="HEALTHY"
disk_status="HEALTHY"
overall_status="HEALTHY"

echo "=========================================="
echo "    VM HEALTH CHECK REPORT"
echo "=========================================="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo "Hostname: $(hostname)"
echo ""

# ==========================================
# 1. CPU Utilization Check
# ==========================================
echo "1. CPU UTILIZATION:"
echo "-------------------"

# Calculate CPU utilization (percentage of CPU not idle)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print int(100 - $1)}')

echo "   Current Usage: ${cpu_usage}%"
echo "   Threshold: ${THRESHOLD}%"

if [ $cpu_usage -lt $THRESHOLD ]; then
    echo -e "   Status: ${GREEN}HEALTHY${NC}"
    cpu_status="HEALTHY"
    
    if [ "$EXPLAIN_MODE" = true ]; then
        echo -e "   ${BLUE}Explanation:${NC} CPU usage is at ${cpu_usage}%, which is below"
        echo "   the 60% threshold. The system has sufficient CPU capacity"
        echo "   and is not experiencing high computational load."
    fi
else
    echo -e "   Status: ${RED}NOT HEALTHY${NC}"
    cpu_status="NOT HEALTHY"
    overall_status="NOT HEALTHY"
    
    if [ "$EXPLAIN_MODE" = true ]; then
        echo -e "   ${BLUE}Explanation:${NC} CPU usage is at ${cpu_usage}%, which exceeds"
        echo "   the 60% threshold. The system is experiencing high"
        echo "   computational load and may face performance issues."
        echo "   Consider investigating running processes using 'top' or 'ps'."
    fi
fi
echo ""

# ==========================================
# 2. Memory Utilization Check
# ==========================================
echo "2. MEMORY UTILIZATION:"
echo "----------------------"

# Get memory utilization percentage
memory_info=$(free | grep Mem)
memory_total=$(echo "$memory_info" | awk '{print $2}')
memory_used=$(echo "$memory_info" | awk '{print $3}')
memory_usage=$(echo "$memory_info" | awk '{printf("%d", ($3 / $2) * 100)}')

echo "   Current Usage: ${memory_usage}%"
echo "   Memory Used: ${memory_used} KB / ${memory_total} KB"
echo "   Threshold: ${THRESHOLD}%"

if [ $memory_usage -lt $THRESHOLD ]; then
    echo -e "   Status: ${GREEN}HEALTHY${NC}"
    memory_status="HEALTHY"
    
    if [ "$EXPLAIN_MODE" = true ]; then
        echo -e "   ${BLUE}Explanation:${NC} Memory usage is at ${memory_usage}%, which is below"
        echo "   the 60% threshold. The system has plenty of available memory"
        echo "   and should handle most workloads without swapping."
    fi
else
    echo -e "   Status: ${RED}NOT HEALTHY${NC}"
    memory_status="NOT HEALTHY"
    overall_status="NOT HEALTHY"
    
    if [ "$EXPLAIN_MODE" = true ]; then
        echo -e "   ${BLUE}Explanation:${NC} Memory usage is at ${memory_usage}%, which exceeds"
        echo "   the 60% threshold. The system is running low on available memory"
        echo "   and may be experiencing slowdowns due to excessive swapping."
        echo "   Check memory usage with 'free -h' or 'top' to identify"
        echo "   memory-intensive processes."
    fi
fi
echo ""

# ==========================================
# 3. Disk Space Utilization Check
# ==========================================
echo "3. DISK SPACE UTILIZATION:"
echo "---------------------------"

# Get disk utilization percentage for root partition
disk_output=$(df -h /)
disk_usage=$(echo "$disk_output" | awk 'NR==2 {print $5}' | sed 's/%//')
disk_used=$(echo "$disk_output" | awk 'NR==2 {print $3}')
disk_total=$(echo "$disk_output" | awk 'NR==2 {print $2}')

echo "   Current Usage: ${disk_usage}%"
echo "   Disk Used: ${disk_used} / ${disk_total}"
echo "   Threshold: ${THRESHOLD}%"

if [ $disk_usage -lt $THRESHOLD ]; then
    echo -e "   Status: ${GREEN}HEALTHY${NC}"
    disk_status="HEALTHY"
    
    if [ "$EXPLAIN_MODE" = true ]; then
        echo -e "   ${BLUE}Explanation:${NC} Disk usage is at ${disk_usage}%, which is below"
        echo "   the 60% threshold. The system has sufficient disk space"
        echo "   and should not face any space-related issues soon."
    fi
else
    echo -e "   Status: ${RED}NOT HEALTHY${NC}"
    disk_status="NOT HEALTHY"
    overall_status="NOT HEALTHY"
    
    if [ "$EXPLAIN_MODE" = true ]; then
        echo -e "   ${BLUE}Explanation:${NC} Disk usage is at ${disk_usage}%, which exceeds"
        echo "   the 60% threshold. The system is running low on disk space."
        echo "   Applications may fail if disk space runs out completely."
        echo "   Consider cleaning up unnecessary files or expanding the partition."
        echo "   Use 'du -sh /*' to identify large directories."
    fi
fi
echo ""

# ==========================================
# Overall Health Status
# ==========================================
echo "=========================================="
echo "    OVERALL VM HEALTH STATUS"
echo "=========================================="

if [ "$overall_status" = "HEALTHY" ]; then
    echo -e "Status: ${GREEN}HEALTHY${NC}"
    
    if [ "$EXPLAIN_MODE" = true ]; then
        echo ""
        echo -e "${BLUE}Summary:${NC}"
        echo "All system resources (CPU, Memory, and Disk) are operating"
        echo "below the 60% utilization threshold. The virtual machine is"
        echo "performing optimally with no immediate resource constraints."
    fi
else
    echo -e "Status: ${RED}NOT HEALTHY${NC}"
    
    if [ "$EXPLAIN_MODE" = true ]; then
        echo ""
        echo -e "${BLUE}Summary:${NC}"
        echo "One or more system resources are exceeding the 60% utilization"
        echo "threshold. The virtual machine is under resource stress."
        echo ""
        echo "Issues detected:"
        [ "$cpu_status" = "NOT HEALTHY" ] && echo "  • CPU utilization is high (${cpu_usage}%)"
        [ "$memory_status" = "NOT HEALTHY" ] && echo "  • Memory utilization is high (${memory_usage}%)"
        [ "$disk_status" = "NOT HEALTHY" ] && echo "  • Disk utilization is high (${disk_usage}%)"
        echo ""
        echo "Recommended Actions:"
        echo "  • Monitor resource usage with 'htop' or 'top'"
        echo "  • Review running processes for resource-intensive applications"
        echo "  • Consider scaling resources or optimizing workloads"
        echo "  • Check application logs for errors or issues"
    fi
fi

echo ""
echo "=========================================="
echo ""

# Exit code: 0 if healthy, 1 if not healthy
if [ "$overall_status" = "HEALTHY" ]; then
    exit 0
else
    exit 1
fi