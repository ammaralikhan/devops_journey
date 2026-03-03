#!/bin/bash
################################################################################
# log-analyzer.sh - Production Log Analyzer
# Industry Practice: Follows Google Shell Style Guide + SRE Error Budgets
################################################################################

# === CONFIGURATION ===
MAX_ERRORS=5
MAX_CRITICALS=1
MAX_WARNINGS=50
LOG_TIME_WINDOW="1h"

# === VARIABLES ===
error_count=0
critical_count=0
warning_count=0

# === FUNCTION: Extract log entries ===
get_logs() {
    log show --last "$LOG_TIME_WINDOW" --style syslog 2>/dev/null | \
    grep -Ei "CRITICAL|ERROR|WARNING" || true
}

# === FUNCTION: Analyze log line ===
analyze_line() {
    local line="$1"
    
    if [[ "$line" == *"CRITICAL"* ]]; then
        ((critical_count++))
    elif [[ "$line" == *"ERROR"* ]]; then
        ((error_count++))
    elif [[ "$line" == *"WARNING"* ]]; then
        ((warning_count++))
    fi
}

# === FUNCTION: Generate report ===
generate_report() {
    echo "=== LOG ANALYSIS REPORT ==="
    echo "Time window: $LOG_TIME_WINDOW"
    echo "Generated: $(date)"
    echo ""
    
    if [ "$critical_count" -gt "$MAX_CRITICALS" ]; then
        echo "❌ CRITICAL: $critical_count/$MAX_CRITICALS"
    else
        echo "✅ CRITICAL: $critical_count/$MAX_CRITICALS"
    fi
    
    if [ "$error_count" -gt "$MAX_ERRORS" ]; then
        echo "❌ ERRORS: $error_count/$MAX_ERRORS"
    else
        echo "✅ ERRORS: $error_count/$MAX_ERRORS"
    fi
    
    if [ "$warning_count" -gt "$MAX_WARNINGS" ]; then
        echo "❌ WARNINGS: $warning_count/$MAX_WARNINGS"
    else
        echo "✅ WARNINGS: $warning_count/$MAX_WARNINGS"
    fi
    
    echo ""
    
    if [ "$critical_count" -gt "$MAX_CRITICALS" ] || [ "$error_count" -gt "$MAX_ERRORS" ]; then
        echo "❌ ERROR BUDGET EXCEEDED - INVESTIGATION REQUIRED"
        return 1
    else
        echo "✅ Within error budget - system healthy"
        return 0
    fi
}

# === MAIN EXECUTION ===
echo "🔍 Analyzing system logs..."

# Process logs line by line
while IFS= read -r line; do
    analyze_line "$line"
done < <(get_logs)

# Show final counts for debugging
echo "DEBUG: Critical=$critical_count, Errors=$error_count, Warnings=$warning_count"

# Generate report
generate_report
exit $?
