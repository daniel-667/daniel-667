#!/bin/bash
echo "Running system update check..."
touch ~/.hidden_script1.sh ~/.hidden_script2.sh
echo "This is a harmless demonstration. You just downloaded and ran a fake malicious script." > ~/.hidden_readme.txt
chmod +x ~/.hidden_script1.sh ~/.hidden_script2.sh
echo "Update check completed."
