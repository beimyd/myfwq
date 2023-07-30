FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# 安装所需软件
RUN Invoke-WebRequest -Uri 'https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz' -OutFile 'v1.2.0.tar.gz' -UseBasicParsing
RUN Invoke-WebRequest -Uri 'https://proot.gitlab.io/proot/bin/proot' -OutFile 'proot.exe' -UseBasicParsing

# 安装其他软件，例如：qemu-kvm、curl、firefox、git、等等

# 设置环境变量
ENV HOME='C:\Users\ContainerAdministrator'

# 创建.vnc目录并设置VNC密码
RUN mkdir $env:HOME\.vnc
RUN echo 'luo' | vncpasswd -f > $env:HOME\.vnc\passwd
RUN icacls $env:HOME\.vnc\passwd /inheritance:r

# 创建启动脚本
RUN echo 'cd C:\noVNC-1.2.0' >> C:\luo.bat
RUN echo 'vncserver :2000 -geometry 1280x800' >> C:\luo.bat
RUN echo '.\utils\launch.bat --vnc localhost:7900 --listen 8900' >> C:\luo.bat

EXPOSE 8900
CMD ["cmd", "/k", "C:\\luo.bat"]
