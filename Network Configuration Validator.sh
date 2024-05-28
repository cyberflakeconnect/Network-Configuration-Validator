#!/bin/bash

# Output file for the network configuration review
OUTPUT_FILE="network_config_review.txt"

# Print header for the output file
echo "Network Configuration Review Report" > $OUTPUT_FILE
echo "Generated on: $(date)" >> $OUTPUT_FILE
echo "-------------------------------------" >> $OUTPUT_FILE

# Function to check network interfaces
check_interfaces() {
    echo "Checking network interfaces..." >> $OUTPUT_FILE
    ip link show >> $OUTPUT_FILE
    echo "-------------------------------------" >> $OUTPUT_FILE
}

# Function to check IP addresses and subnet masks
check_ip_addresses() {
    echo "Checking IP addresses and subnet masks..." >> $OUTPUT_FILE
    ip -4 addr show >> $OUTPUT_FILE
    echo "-------------------------------------" >> $OUTPUT_FILE
}

# Function to check default gateway
check_gateway() {
    echo "Checking default gateway..." >> $OUTPUT_FILE
    ip route | grep default >> $OUTPUT_FILE
    echo "-------------------------------------" >> $OUTPUT_FILE
}

# Function to check DNS configuration
check_dns() {
    echo "Checking DNS configuration..." >> $OUTPUT_FILE
    cat /etc/resolv.conf >> $OUTPUT_FILE
    echo "-------------------------------------" >> $OUTPUT_FILE
}

# Function to check for compliance with basic standards and best practices
check_compliance() {
    echo "Checking compliance with standards and best practices..." >> $OUTPUT_FILE

    # Example check: Ensure all interfaces have an IP address
    for iface in $(ip -o link show | awk -F': ' '{print $2}'); do
        ip addr show "$iface" | grep "inet " &> /dev/null
        if [ $? -ne 0 ]; then
            echo "Warning: Interface $iface does not have an IP address." >> $OUTPUT_FILE
        fi
    done

    # Example check: Ensure DNS is configured
    if [ ! -s /etc/resolv.conf ]; then
        echo "Warning: DNS is not configured." >> $OUTPUT_FILE
    fi

    # Add more compliance checks as needed
    echo "-------------------------------------" >> $OUTPUT_FILE
}

# Run all checks
check_interfaces
check_ip_addresses
check_gateway
check_dns
check_compliance

# Print completion message
echo "Network configuration review completed. Report saved to $OUTPUT_FILE"
