Deployment
-----

## Set up an instance
1. Add the ip to `playbooks/hosts`, make sure you can ssh to it
2. 
```bash
cd playbooks
ansible-playbooks -i hosts ctf.yml
```

3. `cap production deploy:create_database`
4. `cap production deploy`
5. Move `env.yml` to /home/deploy/app/shared/config on the server

hacker school CTF
------

- pcap file with ftp
- pcap file with http cookie
- pcap file with https

- xss exploit
- ruby shell exploit (pull down a cert here)
- php sql injection 
 - (potnetial bonus, SQLI then crack passwords)

- c doorbot overflow - call a function
- c doorbot overflow - write shellcode
- haskell web server / directory traversal

- hide a password with stegonography in a JPG
- crack a XOR cipher
- Stock Trader ECB exploit


