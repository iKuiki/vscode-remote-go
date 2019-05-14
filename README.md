# vscode-remote-go

针对国内网络预先完成apt下载、go工具安装的vscode go开发用容器

本项目中的[Dockerfile](https://github.com/microsoft/vscode-remote-try-go/blob/master/.devcontainer/Dockerfile)由[微软范例go开发容器](https://github.com/Microsoft/vscode-remote-try-go)中提取后修改

相较于原本的Dockerfile，做了如下修改

- 通过apt多安装了zsh less locales这三个组件
- 安装了oh-my-zsh
- 将所有涉及apt的操作合为一句RUN以避免缓存文件出现在docker的层叠卷中
- 生成了中文locale支持，在终端中中文的输入与输出都不会乱码了
