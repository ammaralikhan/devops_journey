#!/bin/bash
echo "=== My DevOps Environment Status === "
echo "Date: $(date)"
echo ""
echo "1. Docker Version"
docker --version
echo "2. AWS CLI Status"
if command -v aws &> /dev/null; then
	aws --version
else
	echo "AWS CLI not Installed"
fi
echo ""
echo "3. Current directory"
pwd
echo "=== Setup Check Complete ==="

