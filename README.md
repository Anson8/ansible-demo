# ops-deploy
---

ops-deploy 用于支持icarbonx k8s平台的一键式部署、系统宕机恢复

## 准备工作
1. 检查kerberos是否能通外网
2. 手动安装git客户端
```
    sudo apt-get update
    sudo apt-get install git
```
3. 下载该部署脚本到安全账户（ubuntu）所在的home目录，需要注意权限问题，否则脚本会无法执行

## 配置文件
    config：
        存放通用配置文件
    depend：
        存放依赖项
    deploy：
        发布k8s脚本
    install:
        系统预安装等脚本
    recover:
        k8s系统恢复脚本

## 启动文件
    start_deploy.sh
        k8s服务部署启动
    start_install.sh
        系统预安装等启动
    start_recover.sh
        k8s机器恢复启动
        
        
## kerberos 登录预安装
    1、检查kerberos是否与sshd服务器互通
    2、在sshd服务器创建用户名(ops-admin),密码（admin123）,然后修改/etc/sudoers，给该账号添加sudo权限，修改内容如下：
       ops-admin ALL=(ALL) NOPASSWD: ALL
    
    3、打开允许用户名密码登录权限 sudo vi /etc/ssh/sshd_config,然后重启sshd
       asswordAuthentication yes
       sudo service sshd restart
    4、在kerberos服务器上执行kerberos脚本
       ./start-install.sh kerberos

       