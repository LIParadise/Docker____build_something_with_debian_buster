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
RUN \
aptitude -y install gcc g++ gdb clang valgrind vim tmux zsh htop pigz make cmake git wget curl ctags awk autoconf automake autotools-dev gawk build-essential bison flex bc zlib1g-dev sudo libreadline-dev cvc4 libcvc4-dev nodejs npm nftables neofetch &&\
echo "flush ruleset" > /etc/nftables.conf                                               &&\
echo "table inet filter {" >> /etc/nftables.conf                                        &&\
echo "    chain input {" >> /etc/nftables.conf                                          &&\
echo "        type filter hook input priority 0; policy drop;" >> /etc/nftables.conf    &&\
echo "        ct state invalid drop" >> /etc/nftables.conf                              &&\
echo "        ct state {established, related} accept" >> /etc/nftables.conf             &&\
echo "        iif lo accept" >> /etc/nftables.conf                                      &&\
echo "        iif != lo ip daddr 127.0.0.1/8 counter drop" >> /etc/nftables.conf        &&\
echo "        iif != lo ip6 daddr ::1/128 counter drop" >> /etc/nftables.conf           &&\
echo "        ip protocol icmp accept" >> /etc/nftables.conf                            &&\
echo "        ip6 nexthdr icmpv6 accept" >> /etc/nftables.conf                          &&\
echo "        meta l4proto ipv6-icmp accept" >> /etc/nftables.conf                      &&\
echo "        tcp dport ssh drop" >> /etc/nftables.conf                                 &&\
echo "    }" >> /etc/nftables.conf                                                      &&\
echo "    chain forward {" >> /etc/nftables.conf                                        &&\
echo "        type filter hook forward priority 0; policy drop;" >> /etc/nftables.conf  &&\
echo "    }" >> /etc/nftables.conf                                                      &&\
echo "    chain output {" >> /etc/nftables.conf                                         &&\
echo "        type filter hook output priority 0;" >> /etc/nftables.conf                &&\
echo "    }" >> /etc/nftables.conf                                                      &&\
echo "}" >> /etc/nftables.conf                                                          &&\
aptitude -y purge iptables

RUN \
useradd --create-home --shell `which zsh` liparadise &&\
usermod -a -G sudo liparadise &&\
chsh -s /usr/bin/zsh liparadise
USER liparadise
WORKDIR /home/liparadise
RUN \
git config --global user.email a58524andy@gmail.com &&\
git config --global user.name LIParadise &&\
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh .oh-my-zsh &&\
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions .oh-my-zsh/custom/plugins/zsh-autosuggestions &&\
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git .oh-my-zsh/custom/plugins/zsh-syntax-highlighting &&\
git clone --depth=1 https://github.com/LIParadise/home_dir.git .home &&\
mkdir -p .vim/.swp .vim/.undo .vim/.backup .zsh &&\
cp .home/.config/nvim/init.vim .vimrc &&\
cp .home/.zshrc .zsh &&\
cp .home/.tmux.conf . &&\
ln -s ~/.zsh/.zshrc ~/.zshrc &&\
echo "alias nv=\"vim\"" >> ~/.zsh/.zshrc &&\
ln -s /mnt/user_data/Chun_Hong/ABC_async_DAC17 DAC17 &&\
cp -r .home/.vim . &&\
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &&\
sed -i -r 's/(.*)virtualenvwrapper.*/\#\ \1virtualenvwrapper\.sh/' .zsh/.zshrc &&\
sed -i -r 's/^export\ ZSH=.*/export\ ZSH="\$HOME\/\.oh-my-zsh"/' .zsh/.zshrc &&\
sed -i -r 's/^export\ ZDOTDIR=.*/export\ ZDOTDIR="\$HOME\/\.zsh"/' .zsh/.zshrc &&\
sed -i -r 's/liparadise_color.vim/liparadise_color_X200.vim/' .vimrc &&\
sed -i -r '1i let g:coc_disable_startup_warning = 1' .vimrc &&\
vim +PlugInstall +qa

ENTRYPOINT ["/usr/bin/zsh"]
