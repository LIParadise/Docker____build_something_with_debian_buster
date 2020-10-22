FROM debian:buster
LABEL maintainer="a58524andy@gmail.com"

RUN echo 'deb http://debian.cs.nctu.edu.tw/debian/ buster main contrib non-free' > /etc/apt/sources.list &&\
echo 'deb-src http://debian.cs.nctu.edu.tw/debian/ buster main contrib non-free' >> /etc/apt/sources.list &&\
echo '' >> /etc/apt/sources.list &&\
echo 'deb http://security.debian.org/debian-security buster/updates main contrib non-free' >> /etc/apt/sources.list &&\
echo 'deb-src http://security.debian.org/debian-security buster/updates main contrib non-free' >> /etc/apt/sources.list &&\
echo '' >> /etc/apt/sources.list &&\
echo 'deb http://debian.cs.nctu.edu.tw/debian/ buster-updates main contrib non-free' >> /etc/apt/sources.list &&\
echo 'deb-src http://debian.cs.nctu.edu.tw/debian/ buster-updates main contrib non-free' >> /etc/apt/sources.list &&\
echo '' >> /etc/apt/sources.list &&\
echo 'deb http://debian.cs.nctu.edu.tw/debian buster-backports main contrib non-free' >> /etc/apt/sources.list &&\
echo 'deb-src http://debian.cs.nctu.edu.tw/debian buster-backports main contrib non-free' >> /etc/apt/sources.list

RUN apt update
RUN apt -y upgrade
RUN apt -y install dialog apt-utils aptitude
RUN aptitude update
RUN aptitude -y safe-upgrade
RUN aptitude -y install gcc g++ gdb clang valgrind vim tmux zsh htop pigz make cmake openssh-client openssh-server openssh-sftp-server git wget curl ctags awk autoconf automake autotools-dev gawk build-essential bison flex bc zlib1g-dev sudo libreadline-dev cvc4 libcvc4-dev nodejs npm
RUN mkdir /var/run/sshd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN sed -i -r 's/\#*(PermitRootLogin.*prohibit-password)/\1/' /etc/ssh/sshd_config
RUN sed -i -r 's/\#*(PasswordAuthentication).*yes/\1\ no/' /etc/ssh/sshd_config

RUN useradd --create-home --shell `which zsh` liparadise
RUN usermod -a -G sudo liparadise
RUN chsh -s /usr/bin/zsh liparadise
USER liparadise
WORKDIR /home/liparadise
RUN \
git config --global user.email a58524andy@gmail.com &&\
git config --global user.name LIParadise &&\
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh .oh-my-zsh &&\
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-autosuggestions &&\
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git .oh-my-zsh/custom/plugins/zsh-syntax-highlighting &&\
git clone --depth=1 https://github.com/LIParadise/home_dir.git .home &&\
mkdir -p .vim/.swp .vim/.undo .vim/.backup .ssh .zsh &&\
cp .home/COC.vimrc .vimrc &&\
cp .home/.zshrc .zsh &&\
cp .home/.tmux.conf . &&\
ln -s ~/.zsh/.zshrc ~/.zshrc &&\
cp -r .home/.vim . &&\
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&\
sed -i -r 's/(.*)virtualenvwrapper.*/\#\ \1virtualenvwrapper\.sh/' .zsh/.zshrc &&\
sed -i -r 's/^export\ ZSH=.*/export\ ZSH="\$HOME\/\.oh-my-zsh"/' .zsh/.zshrc &&\
sed -i -r 's/^export\ ZDOTDIR=.*/export\ ZDOTDIR="\$HOME\/\.zsh"/' .zsh/.zshrc &&\
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOZDEuqbM4C/mmWII4k+6Bz09duZ6RyeggV0zxouQUE liparadise@T480-arch" > .ssh/authorized_keys &&\
chmod 644 .ssh/authorized_keys &&\
vim +PlugInstall +qa

# RUN wget http://apache.stu.edu.tw/tomcat/tomcat-7/v7.0.82/bin/apache-tomcat-7.0.82.tar.gz
# RUN tar zxvf apache-tomcat-7.0.82.tar.gz

# ENV JAVA_HOME=/jdk1.8.0_152
# ENV PATH=$PATH:/jdk1.8.0_152/bin

USER root
WORKDIR /root

EXPOSE 2224
CMD ["/usr/sbin/sshd", "-D"]
