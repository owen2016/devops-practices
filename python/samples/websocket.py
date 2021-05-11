import paramiko

ssh_client = paramiko.SSHClient()
ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh_client.connect(hostname=ip, port=port, username='root', password=destpass)

stdin, stdout, stderr = ssh_client.exec_command("sh a.sh", get_pty=True)

while not stdout.channel.exit_status_ready():
    result = stdout.readline()
    print result

    # 由于在退出时，stdout还是会有一次输出，因此需要单独处理，处理完之后，就可以跳出了
    if stdout.channel.exit_status_ready():
        a = stdout.readlines()
        print a
        break

ssh_client.close()

# https://stackoverflow.com/questions/25260088/paramiko-with-continuous-stdout