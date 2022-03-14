install_python () {

    new_version="$1"
    py_main_version=${new_version::-2}
    file="Python-${new_version}.tar.xz"
    url="https://www.python.org/ftp/python/${new_version}/${file}"

    old_version=$(python -c 'import platform; print("3.10.0")')

    if [ "$(printf '%s\n' "$new_version" "$old_version" | sort -V | head -n1)" = "$new_version" ]; then
        echo "You are trying to install an older version than your current version!"
        echo  "Exiting this script!"
        exit 0
    fi

    echo "Your current Python version is: ${old_version}"

    echo "Updating system"
    apt -qq update < /dev/null

    echo "Installing system essentials"
    apt -qq install wget build-essential checkinstall < /dev/null

    echo "Installing Python essentials"
    apt -qq install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev < /dev/null

    echo "Downloading Python ${new_version}"
    wget ${url}
    echo "Decompressing file"
    tar -Jxf ${file} < /dev/null

    cd Python-${new_version}

    echo "Prepare the source for the installation"
    ./configure --enable-optimizations --prefix=/usr < /dev/null
    make < /dev/null
    echo $("Install the new Python version " $new_version)
    make altinstall < /dev/null

    echo "Let's cleanup!"
    cd ..
    rm -r ${Python-$new_version}
    rm -rf ${file}

    new_python_version=$(python -c 'import platform; print(platform.python_version())')
    if [ $old_python_version = $new_version ]; then
        echo "Version okay!"
    else
        echo "Okay, let's try to get your new installed to be the default!"
        update-alternatives --install /usr/bin/python python /usr/bin/python${py_main_version} 1
    fi

    echo "Let's install PIP"
    apt -qq install python3-pip < /dev/null

    clear
    echo "All Done!"
    echo "Your new Python version should be ${new_version}"
    echo "You can check this yourself by 'python --version'"
    echo "It might be a good idea to update pip with : 'python pip install --upgrade pip'"
    echo ""
    echo "Do not forget to give me a tip/donation for my hard :-) work!"
    echo "https://itheo.tech/donate"
    echo ""
    echo "Any questions?"
    echo "Visit my site and contact me on my contact page https://itheo.tech/contact"
    echo ""
    echo "Have Fun!"
}

if [ -z "$1" ]; then
    echo "Sorry you did not provide a version number. (eg. 3.10.0)"
    echo "bash python.sh 3.10.0"
else
    install_python "$1"
fi
