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
mkdir -p .vim/.swp .vim/.undo .vim/.backup .zsh .config &&\
cp .home/.tmux.conf . &&\
ln -s /mnt/user_data/Chun_Hong/ABC_async_DAC17   DAC17   &&\
ln -s /mnt/user_data/Chun_Hong/ABC_async_ASYNC17 ASYNC17 &&\
cp -r .home/.vim . &&\
cp -r .home/.config/nvim .config &&\
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN \
echo "autoload -U +X bashcompinit && bashcompinit"          >> ~/.zsh/.zshrc        &&\
echo "autoload -U +X compinit && compinit"                  >> ~/.zsh/.zshrc        &&\
echo "export PATH=\$HOME/.cargo/bin:\$HOME/bin:\$PATH"      >> ~/.zsh/.zshrc        &&\
echo "export ZSH=\"/home/liparadise/.oh-my-zsh\""           >> ~/.zsh/.zshrc        &&\
echo "export ZDOTDIR=\"/home/liparadise/.zsh\""             >> ~/.zsh/.zshrc        &&\
echo "DISABLE_AUTO_UPDATE=\"true\""                         >> ~/.zsh/.zshrc        &&\
echo "ZSH_THEME=\"gentoo\""                                 >> ~/.zsh/.zshrc        &&\
echo "plugins=("                                            >> ~/.zsh/.zshrc        &&\
echo "    git"                                              >> ~/.zsh/.zshrc        &&\
echo "    zsh-autosuggestions"                              >> ~/.zsh/.zshrc        &&\
echo "    zsh-syntax-highlighting"                          >> ~/.zsh/.zshrc        &&\
echo ")"                                                    >> ~/.zsh/.zshrc        &&\
echo "source \$ZSH/oh-my-zsh.sh"                            >> ~/.zsh/.zshrc        &&\
echo "export VISUAL=\"vim\""                                >> ~/.zsh/.zshrc        &&\
echo "autoload edit-command-line"                           >> ~/.zsh/.zshrc        &&\
echo "zle -N edit-command-line"                             >> ~/.zsh/.zshrc        &&\
echo "alias cp=\"cp -i\""                                   >> ~/.zsh/.zshrc        &&\
echo "alias mv=\"mv -i\""                                   >> ~/.zsh/.zshrc        &&\
echo "alias rm=\"rm -i\""                                   >> ~/.zsh/.zshrc        &&\
echo "alias lr=\"ls -tr\""                                  >> ~/.zsh/.zshrc        &&\
echo "alias ll=\"ls -alF\""                                 >> ~/.zsh/.zshrc        &&\
echo "alias tmux=\"tmux -u\" # utf-8 support"               >> ~/.zsh/.zshrc        &&\
echo "function CD(){ cd \${1}; cd \$(pwd -P) }"             >> ~/.zsh/.zshrc        &&\
echo "let mapleader=\" \"" > ~/.config/nvim/init.vim &&\
echo "filetype off" >> ~/.config/nvim/init.vim &&\
echo "call plug#begin('~/.vim/plugged')" >> ~/.config/nvim/init.vim &&\
echo "Plug 'neoclide/coc.nvim', {'branch': 'release'}" >> ~/.config/nvim/init.vim &&\
echo "Plug 'Yggdroot/indentLine'" >> ~/.config/nvim/init.vim &&\
echo "Plug 'ayu-theme/ayu-vim'" >> ~/.config/nvim/init.vim &&\
echo "Plug 'webdevel/tabulous'" >> ~/.config/nvim/init.vim &&\
echo "call plug#end()" >> ~/.config/nvim/init.vim &&\
echo "filetype plugin indent on    \" required" >> ~/.config/nvim/init.vim &&\
echo "runtime liparadise_coc.vim" >> ~/.config/nvim/init.vim &&\
echo "set nu ai expandtab tabstop=4 shiftwidth=4 history=3000 cursorline laststatus=2 statusline+=%<%F\ %h%m%r%=%-16.(%l,%c%V%)\ %P ignorecase smartcase showcmd t_Co=256 backspace=indent,eol,start encoding=utf-8 nocompatible ttimeoutlen=5 mouse=a" >> ~/.config/nvim/init.vim &&\
echo "set undodir=~/.vim/.undo//" >> ~/.config/nvim/init.vim &&\
echo "set backupdir=~/.vim/.backup//" >> ~/.config/nvim/init.vim &&\
echo "set directory=~/.vim/.swp//" >> ~/.config/nvim/init.vim &&\
echo "syntax on" >> ~/.config/nvim/init.vim &&\
echo "" >> ~/.config/nvim/init.vim &&\
echo "runtime liparadise_color_X200.vim" >> ~/.config/nvim/init.vim &&\
echo "runtime liparadise_pclose.vim" >> ~/.config/nvim/init.vim &&\
echo "autocmd VimEnter * call My_stop_hide_underscore()" >> ~/.config/nvim/init.vim &&\
echo "if !&diff" >> ~/.config/nvim/init.vim &&\
echo "    autocmd VimEnter * call My_dark_theme()" >> ~/.config/nvim/init.vim &&\
echo "endif" >> ~/.config/nvim/init.vim &&\
echo "autocmd filetype c setlocal cindent cino=j1,(s,ws,Ws,N-s,m1" >> ~/.config/nvim/init.vim &&\
echo "autocmd filetype cpp setlocal cindent cino=j1,(s,ws,Ws,N-s,m1" >> ~/.config/nvim/init.vim &&\
echo "autocmd filetype markdown setlocal ts=2 sw=2" >> ~/.config/nvim/init.vim &&\
echo "vnoremap <Leader>H c__*<C-r>\"*__" >> ~/.config/nvim/init.vim &&\
echo "vnoremap <Leader>h c__<C-r>\"__" >> ~/.config/nvim/init.vim &&\
echo "vnoremap <Leader>a c*<C-r>\"*" >> ~/.config/nvim/init.vim &&\
echo "nnoremap <Leader>n :set nu!" >> ~/.config/nvim/init.vim &&\
echo "nnoremap <Leader>b :windo set scrollbind" >> ~/.config/nvim/init.vim &&\
echo "nnoremap <Leader>B :windo set noscrollbind" >> ~/.config/nvim/init.vim &&\
echo "nnoremap <C-Up> " >> ~/.config/nvim/init.vim &&\
echo "nnoremap <C-Down> " >> ~/.config/nvim/init.vim &&\
echo "cnoremap Q tabc" >> ~/.config/nvim/init.vim &&\
echo "if exists('+termguicolors')" >> ~/.config/nvim/init.vim &&\
echo "    if ((\$TERM !~? '^linux\$') && (\$TERM !~? '^screen\$'))" >> ~/.config/nvim/init.vim &&\
echo "        let &t_8f = \"\<Esc>[38;2;%lu;%lu;%lum\"" >> ~/.config/nvim/init.vim &&\
echo "        let &t_8b = \"\<Esc>[48;2;%lu;%lu;%lum\"" >> ~/.config/nvim/init.vim &&\
echo "        set termguicolors" >> ~/.config/nvim/init.vim &&\
echo "    endif" >> ~/.config/nvim/init.vim &&\
echo "endif" >> ~/.config/nvim/init.vim &&\
echo "function! My_stop_hide_underscore()" >> ~/.config/nvim/init.vim &&\
echo "    set concealcursor=\"nc\"" >> ~/.config/nvim/init.vim &&\
echo "endfunction" >> ~/.config/nvim/init.vim &&\
echo "if has(\"gui_running\")" >> ~/.config/nvim/init.vim &&\
echo "    set encoding=utf-8" >> ~/.config/nvim/init.vim &&\
echo "    set fileencodings=utf-8,chinese,latin-1" >> ~/.config/nvim/init.vim &&\
echo "    if has(\"gui_win32\")" >> ~/.config/nvim/init.vim &&\
echo "        set guifont=Cascadia_Code:h13" >> ~/.config/nvim/init.vim &&\
echo "    endif" >> ~/.config/nvim/init.vim &&\
echo "else" >> ~/.config/nvim/init.vim &&\
echo "    hi linenr       cterm=NONE  ctermfg=244  ctermbg=NONE guibg=NONE guifg=NONE" >> ~/.config/nvim/init.vim &&\
echo "    hi cursorlinenr cterm=NONE  ctermfg=255  ctermbg=NONE guibg=NONE guifg=NONE" >> ~/.config/nvim/init.vim &&\
echo "    hi cursorline   cterm=NONE  ctermfg=NONE ctermbg=NONE guibg=NONE guifg=NONE" >> ~/.config/nvim/init.vim &&\
echo "endif" >> ~/.config/nvim/init.vim &&\
echo "function! Spell_On_Off()" >> ~/.config/nvim/init.vim &&\
echo "    setlocal spell! spelllang=en" >> ~/.config/nvim/init.vim &&\
echo "    echohl None" >> ~/.config/nvim/init.vim &&\
echo "    echo \"Spell Check is now \"" >> ~/.config/nvim/init.vim &&\
echo "    echohl Boolean" >> ~/.config/nvim/init.vim &&\
echo "    if &spell" >> ~/.config/nvim/init.vim &&\
echo "        echo \"ON\"" >> ~/.config/nvim/init.vim &&\
echo "    else" >> ~/.config/nvim/init.vim &&\
echo "        echo \"OFF\"" >> ~/.config/nvim/init.vim &&\
echo "    endif" >> ~/.config/nvim/init.vim &&\
echo "    echohl None" >> ~/.config/nvim/init.vim &&\
echo "endfunction" >> ~/.config/nvim/init.vim &&\
ln -s ~/.zsh/.zshrc ~/.zshrc &&\
ln -s ~/.config/nvim/init.vim .vimrc &&\
vim +PlugInstall +qa

ENTRYPOINT ["/usr/bin/zsh"]
