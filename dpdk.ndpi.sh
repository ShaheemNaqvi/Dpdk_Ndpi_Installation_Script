#!/bin/bash
DPDK_V="21.11"

print_welcome_message()
{
	echo "======================================================================="
	echo "This script is used to install Dpdk and Ndpi"
	echo "======================================================================="
}

print_options()
{  
	echo "======================================================================="
	echo "	[1] : Check cpu and mem info"
	echo "	[2] : Install Dependancies for DPDK"
	echo "	[3] : Install Dpdk"
	echo "	[4] : Install Ndpi"
	echo "	[q] : quit"
	echo "======================================================================="
}

print_error(){
	echo "WARNING: command return non-zero value. Please check output for errors."
	read -n 1 -s -r -p "Press any key to continue..."
}

cpu_mem_info()
{	
	cat /proc/cpuinfo 
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cat /proc/meminfo 
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	dmesg | grep -i numa
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
}

install_dependancies()
{
	sudo apt-get update -y
    rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi

    echo "===========Next Command-> Install linux headers============"
    sudo apt install linux-headers-$(uname -r) -y
    rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi

    echo "===========Next Command-> Install libnuma-dev============"
    sudo apt install libnuma-dev -y
    rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi

    echo "============Next Command-> Install lib**=============="
    sudo apt install libpcap-dev   liblz4-dev   liblz4-tool -y
    rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi

    echo "============Next Command-> Install python============"
    sudo apt-get install python3 python3-pip -y
    sudo apt-get install python3 python3-pip python3-setuptools -y
    sudo apt-get python3-wheel ninja-build -y

    sudo apt-get install python3-pyelftools -y
    rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi

    #pip3 install --user meson
    echo "===========Next Command-> Install meson==============="
    sudo apt install meson
    rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
    pip3 install meson ninja
    rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi	
    echo "===================complete=========================" 
}

install_dpdk()
{
	#if [ !  -f "$(pwd)/dpdk-${DPDK_V}.tar.xz" ] && [!  -d "$(pwd)/dpdk-${DPDK_V}" ]; then
	wget "https://fast.dpdk.org/rel/dpdk-${DPDK_V}.tar.xz"
	
	tar -xJf "dpdk-${DPDK_V}.tar.xz"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd "dpdk-${DPDK_V}"
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	
    	echo "============Next Command-> meson build=================="
    	sudo meson build
    	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
    	echo "============Next Command-> ninja -C build==============="
    	sudo ninja -C build
    	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
    	echo "============Next Command-> ninja -C build install======="
    	sudo ninja -C build install
    	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	cd build
	sudo ninja install
    	echo "=================sudo ldconfig===================="
    	sudo ldconfig
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "===================complete========================="
}

install_ndpi()
{

	sudo apt-get update -y
 	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	sudo apt-get upgrade -y
  	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================Install linux-source============"
	sudo apt-get install linux-source -y
   	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================Install Libtool============"
	sudo apt-get install libtool -y
   	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================Install autoconf============"
	sudo apt-get install autoconf -y
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================Install pkg-config============"
	sudo apt-get install pkg-config -y
 	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================Install subversion============"
	sudo apt-get install subversion -y
  	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================Install iptables============"
	sudo apt-get install iptables-dev -y
  	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================Install libpcap-dev============"
	sudo apt-get install libpcap-dev -y
   	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================Install git============"
	sudo apt install git
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo"==================Install cjason======="
	sudo apt install libjson-c-dev
	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi

	if [ !  -d "$(pwd)/nDPI" ]; then
		git clone https://github.com/ntop/nDPI.git
        	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
		else
		echo "=========file Already exsists========"
	fi

	cd nDPI

	sudo ./autogen.sh
   	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================./configure============"
	sudo ./configure
   	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================make============"
	sudo make
   	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi
	echo "================make install============"
	sudo make install
    	rc=$?; if [[ $rc != 0 ]]; then echo "return code:  ${rc}"; print_error; fi


}


INPUT_OPTION=0
print_welcome_message
print_options
printf "Please select an option:"
cd ../../
read INPUT_OPTION
while [ "$INPUT_OPTION"!="q" ]
do
	case $INPUT_OPTION in
		1)
			cpu_mem_info
			;;
		2)
			install_dependancies
			;;
		3)
			install_dpdk
			;;
		4)
			install_ndpi
			;;
		q)
			exit 0
	esac
	read -n 1 -s -r -p "Press any key to continue..."
	print_options	
	printf "Please select an option:"
	read INPUT_OPTION
done
