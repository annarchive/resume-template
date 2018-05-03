# Resume templates
不需要掌握LaTeX，编辑yaml文件即可生成简历
## Requires
1. LaTeX(texlive) with moderncv
2. pandoc
3. python3

Windows上可以使用`msys2`搭建环境

## Usage
通过yaml文件编辑简历，参考`sample.yml`

生成所有简历
```
make
```

指定yaml文件生成简历
```
YAML=work/ann.yml make
```

按需生成简历
```
PHONE=111 GITHUB=xxx HOMEPAGE=xxx EMAIL=xxx TPL=moderncv.tpl COLOR=blue YAML=xxx.yml make
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

容器会挂载 `build/`, `work/` 目录，建议将个人简历的yaml文件及照片文件存放在`work/`目录下，然后通过变量指定：
```
PHOTO=work/photo.png YAML=work/ann.yml make run-docker
```

## 预览

### moderncv
#### classic
![](preview/moderncv-classic.jpg)

#### banking
![](preview/moderncv-banking.jpg)

#### fancy
![](preview/moderncv-fancy.jpg)

#### oldstyle
![](preview/moderncv-oldstyle.jpg)
