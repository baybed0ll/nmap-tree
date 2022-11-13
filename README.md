# nmap-tree

Parse greppable Nmap output (nmap -oG) as a tree

Usage:
```
./nmap-tree.pl <gnmap file>
```

Example:
```
$ sudo nmap -sV -oG scanme.gnmap scanme.nmap.org
Starting Nmap 7.93 ( https://nmap.org ) at 2022-11-12 18:50 CST
Nmap scan report for scanme.nmap.org (45.33.32.156)
[...]
Nmap done: 1 IP address (1 host up) scanned in 4.47 seconds

$ ./nmap-tree.pl scanme.gnmap
45.33.32.156──┐
              ├── 22/tcp
              │   ├── service : ssh
              │   └── banner  : OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0)
              ├── 80/tcp
              │   ├── service : http
              │   └── banner  : Apache httpd 2.4.7 ((Ubuntu))
              ├── 9929/tcp
              │   ├── service : nping-echo
              │   └── banner  : Nping echo
              ├── 31337/tcp
              │   ├── service : tcpwrapped
              │   └── banner  : 
```
