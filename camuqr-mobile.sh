echo ${1:-$(termux-clipboard-get)} | nc -l -q 0 -p 56789  
