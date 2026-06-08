# Creating ec2 instance for self hosted runner and attached to EKS cluster and used it as self hosted runner. in GitHub Actions.

* default runner: ubuntu-latest
* self hosted runner: 34.53.232.353 (our runner ec2 instance ip)

Here runner.sh contains all softwares needs to eks cluters like helm, eksctl, kubectl... etc.

We will use runner.server later in our runner configuration.

We can replace ./run.sh with below service.
configuring runner manually using service.
```
sudo vim /etc/systemd/system/runner.service
```

```
[Unit]
Description=GitHub Actions Runner
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/actions-runner
ExecStart=/home/ec2-user/actions-runner/run.sh
Restart=always

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl enable runner
sudo systemctl start runner
sudo systemctl status runner
```

