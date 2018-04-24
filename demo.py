import paramiko

host = '60.24.65.157'
username = 'ltts'
password = 'sunline'

def create_ssh(host=host, username=username, password=password):
	client = paramiko.SSHClient()
	client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	client.connect(host, username=username, password=password)
	stdin, stdout, stderr = client.exec_command('sh bsb_update.sh')
	for line in stdout:
		print('>>>',line.strip('\n'))
	client.close()

if __name__ == '__main__':
	create_ssh()