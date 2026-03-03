#!/bin/bash

# === VARIABLES: Monitoring configuration ===
SERVICE_NAME="payment-api"
MAX_RETRIES=10
RETRY_DELAY=5 #seconds
# HEALTH_CHECK_URL="https://google.com/health" TODO: Real endpoint check later

# === FUNCTION: Check service health ===
check_service_health() {
	# In real life: curl -s -o /dev/null -w "%{http_code}" "$HEALTH_CHECK_URL"
	# For demo: randomly return healthy/unhealthy
	if [ $((RANDOM % 10)) -gt 3 ]; then
		return 0 #HEALTHY
	else
		return 1 #UNHEALTHY
	fi
}

# === FUNCTION: Send alert notification ===
send_alert() {
	local message=$1
	echo "ALERT: $message"
	# In real life: send to slack, email, PagerDuty etc.
}

# === MAIN SCRIPT ===
echo "=== SERVICE HEALTH MONITOR ==="
echo "Service: $SERVICE_NAME"
echo "Retry: $MAX_RETRIES"
echo "Retry Delay: ${RETRY_DELAY}s"
echo "================================"
echo ""

RETRY_COUNT=0
SUCCESS=false

# === WHILE LOOP: Keep checking until service is healthy OR max retries reached ===
while [ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]; do
	echo "Check #$((RETRY_COUNT + 1)) at $(date '+%H:%M:%S')..."
	
	if check_service_health; then
		echo "$SERVICE_NAME is HEALTHY"
		SUCCESS=true
		break # Exit the loop right away
	else 
		echo "$SERVICE_NAME is UNHEALTHY"
	
		# Send alert on first failure
		if [ "$RETRY_COUNT" -eq 0 ]; then
			send_alert "$SERVICE_NAME is down - starting recovery attempts"
		fi

		((RETRY_COUNT++))
		
		# Don't sleep after last retry
		if [ "$RETRY_COUNT" -lt "$MAX_RETRIES" ]; then
			echo "Waiting ${RETRY_DELAY} seconds before retry..."
			sleep $RETRY_DELAY
		fi
	fi
done

echo ""
echo "================================"
echo "📊 MONITORING SUMMARY"
echo "================================"
echo "Total checks performed: $RETRY_COUNT"

if [ "$SUCCESS" = true ]; then
	echo "Service recovered after $RETRY_COUNT attempts"
	echo "Monitoring complete - service is operational"
	exit 0
else
	echo "Service still DOWN after $MAX_RETRIES attempts"
	send_alert "$SERVICE_NAME failed to recover after $MAX_RETRIES attempt - MANUAL INTERVENTION REQUIRED"
	exit 1
fi
