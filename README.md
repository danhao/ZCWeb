# 91 Debt #

## Installing ##
1. 先安装:
- git
- node.js
- grunt

2. 全局安装, grunt-cli 和 karma
````bash
$ npm install -g grunt-cli
````

3. 安装工程依赖包
````bash
$ npm install
$ bower install
````

# 编译 #
1. `grunt build` : 单纯的编译
2. `grunt` 或 `grunt dev` : 编译并启动本地server. 并监听本地文件变化. 自动reload
* `grunt prod` - 编译并压缩
* `grunt test` - unit testing

# 运行 #
`grunt serve`: 运行web server,并打开页面

# 测试 #
1. `grunt test`: unit testing

