______________________________________________________________________________________________________________________________________________________________
## FIRST PUT UP THE ROUTER
https://docs.google.com/document/d/1QIyOL9Kg1znrP3vxEkuLKU6vcpnhlAII9l6PQdQ3UoI/edit

https://i.gyazo.com/ef056017d48d1a71e775465bc0f3688a.png

https://i.gyazo.com/f716221280179e0874ce3dde0fb7a3f1.png
___________________________________________________________________________________________________________________________________________________________________
## SET UP THE FIREWALL

```
# stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Flush exisitng iptables rules
sudo iptables -F
sudo iptables -F -t nat

# our port forwards
# sudo iptables -t nat -A PREROUTING -d <router external ip> -p tcp --dport <port> -j DNAT --to-destination <box ip>:<port>
sudo iptables -t nat -A PREROUTING -d 172.18.13.12 -p tcp --dport 80 -j DNAT --to-destination 192.168.12.5:80
sudo iptables -t nat -A PREROUTING -d 172.20.13.12 -p tcp --dport 443 -j DNAT --to-destination 192.168.12.5:443
sudo iptables -t nat -A PREROUTING -d 172.20.13.12 -p udp --dport 53 -j DNAT --to-destination 192.168.12.66:53
sudo iptables -t nat -A PREROUTING -d 172.20.13.12 -p tcp --dport 53 -j DNAT --to-destination 192.168.12.66:53
sudo iptables -t nat -A PREROUTING -d 172.20.13.12 -p tcp --dport 5432 -j DNAT --to-destination 192.168.12.7:5432
#mystery service
sudo iptables -t nat -A PREROUTING -d 172.20.13.12 -p tcp --dport <port> -j DNAT --to-destination 192.168.12.14:<port>



sudo iptables -t nat -A POSTROUTING -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1


# Accept ICMP requests
iptables -A INPUT -p icmp -j ACCEPT

# Drop anything with source ip of our router (rev shells)
# https://serverfault.com/questions/479618/how-can-i-block-all-traffic-that-is-coming-to-and-from-an-ip-address-using-iptab
# iptables -A INPUT -d <whatever im tryna drop> -j DROP
iptables -A OUTPUT -s <router-ip> -j DROP

# Drop all else
iptables -P INPUT DROP

# save the rules
sudo iptables-save > /etc/iptables/rules.v4
# restore that jawn
sudo iptables-restore < /etc/sysconfig/.centos7b/rules.v4

# put a rule at the top, istead of -A do -I
sudo iptables -t nat -I PREROUTING -d <router external ip> -p tcp --dport <port> -j DNAT --to-destination <box ip>:<port>
```
_______________________________________________________________________________________________________________________________________________________________
## CHECK TO SEE IF ICMP IS WORKING
``` cat /proc/sys/net/ipv4/icmp_echo_ignore_all ```
### making it work
``` echo "0" > /proc/sys/net/ipv4/icmp_echo_ignore_all ```
_______________________________________________________________________________________________________________________________________________________________
## PASSWORD CHANGE SCRIPT
``` read -p "Pw: "; for u in $(cat /etc/passwd | grep -E "/bin/.*sh" | cut -d":" -f1); do echo "$u:$REPLY" | chpasswd; echo "$u,$REPLY"; done ```
_______________________________________________________________________________________________________________________________________________________________
## BACKUPS
```
# Make the directory
mkdir /etc/sysconfig/.centos7b

# Copy important files aswell as the whole directory
cp -rp ifcfg-eth0 /etc/sysconfig/.centos7b/ifcfg-eth0.backup
cp -rp ifcfg-eth1 /etc/sysconfig/.centos7b/ifcfg-eth1.backup
cp -rp /etc/sysconfig/network-scripts /etc/sysconfig/.centos7b/network-scripts

# To move them back
cp -rp /etc/sysconfig/.centos7b/ifcfg-eth0.backup /etc/sysconfig/network-scripts/ifcfg-eth0
cp -rp /etc/sysconfig/.centos7b/ifcfg-eth1.backup /etc/sysconfig/network-scripts/ifcfg-eth1
cp -rp /etc/sysconfig/.centos7b/network-scripts /etc/sysconfig/network-scripts

cd /etc/sysconfig/.centos7b
```
_______________________________________________________________________________________________________________________________________________________________
## Checking port forwarding 
```
# check to see if port forward
sysctl net.ipv4.ip_forward

# actually portforward
sysctl -w net.ipv4.ip_forward=1

```
_______________________________________________________________________________________________________________________________________________________________
## Checking for connections, IR stuff basically
```
# checks or ssh connections
w
kill -9 -t tty<whatever>

# checks for running services
systemctl | grep running
systemctl stop <service>

# established sessions
ss -peunt
kill -9 <pid>
```
_______________________________________________________________________________________________________________________________________________________________
## Use this for iptables and make a script
```
touch iptables.sh
# this is going to put it on a new line
# to run this put a #!/bin/bash in the file
echo "your_content" >> filename
```
______________________________________________________________________________________________________________________________________________________________
