# ops-deploy
---

ops-deploy 用于支持icarbonx k8s平台的一键式部署、系统宕机恢复

## 准备工作
1. 在wdoggy机器上创建安装账号(比如:icx-admin),然后修改/etc/suduers，给该账号添加sudo权限，修改内容如下：
```
icx-admin ALL=(ALL) NOPASSWD: ALL
```
2. 检查wdoggy是否能通外网
3. 手动安装git客户端
```
    sudo apt-get update
    sudo apt-get install git
```
4. 下载该部署脚本到安全账户所在的home目录，需要注意权限问题，否则脚本会无法执行

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
        系统预安装等启动，启动方式如下
        ./
        
    start_recover.sh
        k8s机器恢复启动