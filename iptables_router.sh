#!/bin/bash

# Prompt the user for the team number
read -p "Enter team number: " team_num

# Check if team_num is provided
if [ -z "$team_num" ]; then
    echo "Team number cannot be empty."
    exit 1
fi

# port forwarding with team num
iptables_cmd1="sudo iptables -t nat -A PREROUTING -d 172.18.13.${team_num} -p tcp --dport 80 -j DNAT --to-destination 192.168.${team_num}.5:80"
iptables_cmd2="sudo iptables -t nat -A PREROUTING -d 172.18.13.${team_num} -p tcp --dport 443 -j DNAT --to-destination 192.168.${team_num}.5:443"
iptables_cmd3="sudo iptables -t nat -A PREROUTING -d 172.18.13.${team_num} -p udp --dport 53 -j DNAT --to-destination 192.168.${team_num}.12:53"
iptables_cmd4="sudo iptables -t nat -A PREROUTING -d 172.18.13.${team_num} -p tcp --dport 5432 -j DNAT --to-destination 192.168.${team_num}.7:5432"
iptables_cmd5="sudo iptables -t nat -A POSTROUTING -j MASQUERADE"

# Execute the iptables commands
echo "Executing iptables command 1:"
echo "$iptables_cmd1"
eval "$iptables_cmd1"

echo "Executing iptables command 2:"
echo "$iptables_cmd2"
eval "$iptables_cmd2"

echo "Executing iptables command 3:"
echo "$iptables_cmd3"
eval "$iptables_cmd3"

echo "Executing iptables command 4:"
echo "$iptables_cmd4"
eval "$iptables_cmd4"

echo "Executing iptables command 5:"
echo "$iptables_cmd5"
eval "$iptables_cmd5"

# Egress Rules
iptables_cmd6="sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT"
iptables_cmd7="sudo iptables -A OUTPUT -d 192.168.${team_num}.1/24 -j ACCEPT"
iptables_cmd8="sudo iptables -P OUTPUT DROP"

# Execute the additional iptables commands
echo "Executing additional iptables command 6:"
echo "$iptables_cmd6"
eval "$iptables_cmd6"

echo "Executing additional iptables command 7:"
echo "$iptables_cmd7"
eval "$iptables_cmd7"

echo "Executing additional iptables command 8:"
echo "$iptables_cmd8"
eval "$iptables_cmd8"
