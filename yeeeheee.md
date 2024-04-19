___________________________________________________________________________________________________________________________________________________________________
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
sudo iptables -t nat -A PREROUTING -d 172.18.13.<team_num> -p tcp --dport 80 -j DNAT --to-destination 192.168.<team_num>.5:80
sudo iptables -t nat -A PREROUTING -d 172.20.13.<team_num> -p tcp --dport 443 -j DNAT --to-destination 192.168.<team_num>.5:443
sudo iptables -t nat -A PREROUTING -d 172.20.13.<team_num> -p udp --dport 53 -j DNAT --to-destination 192.168.<team_num>.12:53
sudo iptables -t nat -A POSTROUTING -j MASQUERADE

# Accept ICMP requests
iptables -A INPUT -p icmp -j ACCEPT

# Drop anything with source ip of our router (rev shells)
# https://serverfault.com/questions/479618/how-can-i-block-all-traffic-that-is-coming-to-and-from-an-ip-address-using-iptab
# iptables -A INPUT -d <router-ip> -j DROP
iptables -A OUTPUT -s <router-ip> -j DROP

# Drop all else
iptables -P INPUT DROP  
```
_________________________________________________________________________________________________________________________________________________________________
