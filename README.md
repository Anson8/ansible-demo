# ops-deploy
---

ops-deploy 用于支持icarbonx k8s平台的一键式部署、系统宕机恢复

## 准备工作
1. 在wdoggy机器上创建安装账号(比如:icadmin),然后修改/etc/suduers，给该账号添加sudo权限，修改内容如下：
```
icadmin ALL=(ALL) NOPASSWD: ALL
```
2. 检查wdoggy是否能通外网
3. 手动安装git客户端
```
    sudo apt-get update
    sudo apt-get install git
```
4. 下载该部署脚本到安全账户所在的home目录，需要注意权限问题，否则脚本会无法执行

## 一键式部署
使用start_deploy.sh 进行一键式部署，该脚本会进行每一步的安装确认，根据需求进行一步步的安装。
运行该脚本前，操作者必须进行 config/clusterConfig的文件配置



* Ansible安装

* git安装