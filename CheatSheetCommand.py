1. # Find size file larger than specific value (100MB)
	find / -type f -size +100000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }' 

2. # Improved version of top
	htop 

3. # List all current process tree  	
	ps auxf 
   	ps auxf | grep <specific service> 

4. # List the last 10 lines of that file
	cat "file" | tail 

6. 	nmap -sV <IP>	#scan all port
	nmap -p "specific port" <IP>	#scan specific port

7. # List all TCP/UDP process and listening port 
	netstat -tulpn 

8. # Extract file
	unzip file.zip
	tar -zxvf file.tar.gz

9. # Compress file
	zip newfile.zip <file1> <file2> <file-n>
	zip -r newfile.zip <direcotory>
	tar -zcvf newfile.tar.gz <file/directory>

10.# Kill a process
	kill -9 <PID>

11.# Manual for any service/command
	man <service/command>

12.# View files in directory 
	ls -lah
	ll
13.# Record all packets send to/from host 
	tcpdump -w <file>.pcap -i <network-interface> 
   # View packets route
	tcpdump -r <file>.pcap