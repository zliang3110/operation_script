import paramiko


host = '60.24.65.157'
username = 'ltts'
password = 'sunline'
Port = 22

t = paramiko.Transport((host, Port))
t.connect(username = username, password = password)
sftp = paramiko.SFTPClient.from_transport(t)

# dirlist on remote host
dirlist = sftp.get('bsb_update.sh', 'bsb_update.sh')
print("Dirlist: %s" % dirlist)