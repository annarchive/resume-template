# Resume templates

**此项目停止维护，请使用[PanBook](https://github.com/annProg/PanBook)替代**


不需要掌握LaTeX，编辑yaml文件即可生成简历
## 软件需求
1. LaTeX(texlive) with moderncv and limecv
2. pandoc
3. python3(pyyaml)
4. docker(可选)

Windows上可以使用`msys2`搭建环境

## 用法
通过yaml文件编辑简历，参考`sample.yml`

```
# 生成所有示例简历
make
```

### 一般使用流程
```
# 新建工作目录
mkdir work

# 简历yaml及照片放在工作目录下
cp sample.yml work/xxx.yml
cp /somepath/photo.png work/photo.png

# 修改yaml文件，指定个人信息，生成所有样式的简历
PHONE=111 GITHUB=xxx HOMEPAGE=xxx EMAIL=xxx YAML=work/xxx.yml PHOTO=work/photo.png make
```

### 高级用法
make 命令
```
make pdf           # 默认情况下等同于make moderncv
make moderncv      # 仅生成classic风格的moderncv简历
make all-moderncv  # 生成所有风格的moderncv简历
make limecv        # 生成limecv简历
make clean         # 清除所有编译生成的无用文件
make docker        # 构建docker镜像
make enter-docker  # 进入docker容器，容器中程序位于/home/resume
make run-docker-limecv    # 使用容器生成limecv模板简历
make run-docker-moderncv  # 使用容器生成moderncv模板简历
make run-docker    # 使用容器生成所有简历
```

可以指定以下make变量
```
PHONE        # 手机号
EMAIL        # 邮箱地址
HOMEPAGE     # 个人主页
TYPE         # 模板类型，默认为moderncv
GITHUB       # github名
PHOTO        # 照片路径
YAML         # 简历yaml文件路径
REPO         # docker镜像打包名称
TAG          # docker镜像tag
QUOTE        # 个人简介，可以覆盖yaml文件中的quote内容（某个模板不适合加入个人简介时，可以在编译时将该变量设置为空来覆盖个人简介）
TPL          # 模板文件，可以将自定义模板文件放在work目录下，通过命令指定模板
STYLE        # 指定moderncv的风格(casual classic oldstyle banking fancy)
COLOR        # 指定moderncv的颜色(blue orange green red purple grey black)
```

## 使用容器
### 构建镜像
```
make docker
```

### 生成示例简历
```
make run-docker
```

### 进入容器使用
```
make enter-docker
cd /home/resume
```

容器会挂载 `build/`, `work/` 目录，请将yaml文件及照片文件存放在`work/`目录下，然后通过变量指定：
```
PHOTO=work/photo.png YAML=work/ann.yml make run-docker
```

### 字体
容器会安装文泉驿字体并默认使用文泉驿微米黑作为默认CJK字体，`make enter-docker`和`make run-docker`命令会挂载 `/usr/share/fonts`目录到容器中，因此容器中可以使用宿主机上的字体

## 预览
请进入preview目录：[preview/](https://github.com/annProg/resume-template/tree/master/preview)
