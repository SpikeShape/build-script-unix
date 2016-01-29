weis="0;37m"
blau="1;34m"
rot="1;31m"
orange="0;33m"
gruen="0;32m"

function _setup_bash_path() {
  #get path for this bash-script
  MY_PATH="`dirname \"$0\"`"
  MY_PATH="`( cd \"$MY_PATH\" && pwd )`"
  cd $MY_PATH
  printf "\033[$weis+change working directory to $(pwd) \033[0m \n\n";
}

function _check_ruby() {
  if which ruby
    then
      printf "\033[$blau ruby is already installed \033[0m \n";
    else
      printf "\033[$blau ruby not found; installing latest stable ruby version \033[0m \n";
      while true; do
        read -p "Do you wish to install the latest ruby version? If not the building process will be aborted. [y/n]" yn
        case $yn in
            [Yy]* )
              gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
              \curl -sSL https://get.rvm.io | bash -s stable --ruby
              rvm install ruby --latest
              break;;
            [Nn]* )
              echo "aborting...";
              exit;;
            * ) echo "Please answer [y]es or [n]o.";;
        esac
      done
  fi
}

function _check_node() {
  if which node
    then
      printf "\033[$blau node is already installed \033[0m \n";
    else
      printf "\033[$blau node not found \033[0m \n";
      while true; do
        read -p "Do you wish to install the latest node version? If not the building process will be aborted. [y/n]" yn
        case $yn in
            [Yy]* )
              echo 'export PATH=$HOME/local/bin:$PATH' >> ~/.bashrc
              . ~/.bashrc
              mkdir ~/local
              mkdir ~/node-latest-install
              cd ~/node-latest-install
              curl http://nodejs.org/dist/node-latest.tar.gz | tar xz --strip-components=1
              ./configure --prefix=~/local
              make install
              curl -L https://www.npmjs.org/install.sh | sh;
              cd $MY_PATH
              break;;
            [Nn]* )
              echo "aborting...";
              exit;;
            * ) echo "Please answer [y]es or [n]o.";;
        esac
      done
  fi
}

function _find_outdated_npm_packages() {
  npm_outdated=($(npm outdated --parseable))
  npm_outdated_array_length=${#npm_outdated[@]}
  return_string=""

  for (( i=0; i<${npm_outdated_array_length}; i++ ));
  do
    npm_outdated_name=$( echo ${npm_outdated[$i]} | cut -d "@" -f 2 | cut -d ":" -f 2)
    npm_outdated_current=$( echo ${npm_outdated[$i]} | cut -d "@" -f 2 | cut -d ":" -f 1)
    npm_outdated_wanted=$( echo ${npm_outdated[$i]} | cut -d "@" -f 3 | cut -d ":" -f 1)
    npm_outdated_latest=$( echo ${npm_outdated[$i]} | cut -d "@" -f 4)

    if [ $npm_outdated_current == $npm_outdated_wanted ]; then
      return_string="$return_string $npm_outdated_name"
    fi
  done
  echo "$return_string"
}

function _install_packages() {
  npm install -g grunt
  npm install -g grunt-cli

  if [[ -d 'node_modules' ]]; then
    retval=$( _find_outdated_npm_packages )

    if [[ -z $retval ]]; then
      printf "\033[$blau remove outdated npm packages \033[0m \n";
      npm remove $retval
      printf "\033[$blau install new npm packages \033[0m \n";
      npm install $retval
    else
      printf "\033[$gruen all npm Packages up-to-date \033[0m \n";
    fi
  else
    printf "\033[$blau executing npm install \033[0m \n";
    npm install
  fi
}

function _install_packages_simple() {
  npm install -g grunt
  npm install -g grunt-cli

  if [[ ! -d 'node_modules' ]]; then
    printf "\033[$blau no node_modules folder; executing npm install \033[0m \n";
    npm install
  else
    printf "\033[$blau node_modules folder found; skipping npm install \033[0m \n";
  fi
}

function _check_bundler() {
  if which bundle
    then
      printf "\033[$blau bundler is already installed \033[0m \n";
    else
      printf "\033[$blau bundler not found; installing latest node version \033[0m \n";
      gem install bundler
  fi

  printf "\033[$blau executing bundle install \033[0m \n";
  bundle install
}

function _execute_grunt() {
  if [ -f "Gemfile" ]
    then
      printf "\033[$blau Gemfile found; executing bundle exec grunt -v \033[0m \n";
      bundle exec grunt -v
    else
      printf "\033[$blau Gemfile not found; executing grunt -v \033[0m \n";
      grunt -v
  fi
}

function _purge_dependencies() {
  sudo rm -rf /usr/local/{lib/node{,/.npm,_modules},bin,share/man}/{npm*,node*,man1/node*}
  gem uninstall bundler
}

printf "\033[$weis############################\nInstalling dependcies to build projects...\n############################ \033[0m \n";
_setup_bash_path
# _purge_dependencies
_check_ruby
_check_node
_check_bundler
_install_packages
_execute_grunt
