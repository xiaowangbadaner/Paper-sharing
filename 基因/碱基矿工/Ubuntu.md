# Ubuntu

## 环境变量配置

* 临时设置

  ```
  export PATH=/XXX/XXX/XXX:$PATH
  ```

* 当前用户的全局设置

  * 打开~/.bashrc,添加

    ```
    export PATH=/XXX/XXX/XXX:$PATH
    ```

  * 使生效

    ```
    source ~/.bashrc
    ```

* 所有用户的全局设置

  * 打开

    ```
    $ vim /etc/profile
    ```

  * 在里面加入：

    ```
    export PATH=/home/yan/share/usr/local/arm/3.4.1/bin:$PATH
    ```

  * 使生效

    ```
    source profile
    ```
