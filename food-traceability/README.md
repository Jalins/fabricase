### fabric案例实战教程
#### 搭建网络
* 下载源码`git clone https://github.com/Jalins/fabricase.git`

* cd 进入`fabric_raft`目录

* 编写configtx.yaml，cryptogen.yaml，base目录下的docker-compose-base.yaml以及peer-base.yaml 文件，还有docker-compose-cli.yaml文件

* 生产启动网络所需的证书及创始区块以及通道配置文件。

  ```shell
  bash ./updown.sh up
  ```

* 创建channel以及安装实例化链码

  ```shell
  bash ./cc.sh
  ```

* 完成网络

博客教程地址：

#### 编写chaincode
* 创建 chaincode
* 在 src 下编写chaincode源代码，每个目录一个chaincode
* 相应目录下编写测试用例
* 相应目录下测试： go test -v ..._test.go ...go
* 测试成功，完成chaincode

博客教程地址：

#### SDK开发

##### 1.node-sdk-api

博客教程地址：

##### 2.go-sdk-api

博客教程地址：