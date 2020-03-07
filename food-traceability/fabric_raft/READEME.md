#### 说明

基础系统版本为fabric 1.4.5，单机raft机制
3个orderer节点，两个组织，每个组织两个节点

#### 启动

生产启动网络所需的证书及创始区块以及通道配置文件。

```shell
bash ./updown.sh up
```

创建channel以及安装实例化链码

```shell
bash ./cc.sh
```

