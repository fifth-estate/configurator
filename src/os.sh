export rv


cfg_os_kernel() 
{
	_kern=$(uname -s)

	if [ "$_kern" = "FreeBSD" ] ; then
		rv=$_kern

	elif [ "$_kern" = "Linux" ] ; then
		if [ -f /etc/os-release ] ; then
			rv=$_kern
		else
			cfg_tty_emerg "Outdated Linux kernel: $_kern"
			exit 1
		fi

	else
		cfg_tty_emerg "Unsupported kernel: $_kern"
	fi
}


cfg_os_distro() 
{
	cfg_os_kernel

	if [ "$rv" = "Linux" ] ; then
		rv=$(grep 'NAME' /etc/os-release				\
	            | head -n1 							\
		    | cut -d '=' -f 2 						\
	            | tr -d '"' 						\
		    | cut -d ' ' -f 1)
	fi

	if [ "$rv" != "FreeBSD" ]						\
	    && [ "$rv" != "Arch" ]						\
	    && [ "$rv" != "Debian" ] 						\
	    && [ "$rv" != "Ubuntu" ] ; then	
		cfg_tty_emerg "Unsupported distribution: $rv"
		exit 1
	fi
}


cfg_os_version() 
{
	cfg_os_distro
	_distro=$rv

	if [ "$_distro" = "Arch" ] ; then
		rv="rolling"

	elif [ "$_distro" = "FreeBSD" ] ; then
		rv=$(uname -r)
		
		_ver=$(echo "$rv"						\
		    | cut -d '-' -f 1						\
		    | tr -d '.')

		if [ "$_ver" -lt 122 ] ; then
			cfg_tty_notice "FreeBSD version $rv detected"
			cfg_tty_alert "FreeBSD version >= 12.2 required"
			exit 1
		fi

	elif [ "$_distro" = "Debian" ] ; then
		rv=$(grep 'VERSION=' /etc/os-release				\
		    | tr -d '"' 						\
		    | cut -d '=' -f 2)
		
		_ver=$(echo "$rv" | tr -d 'A-Z a-z ( ) .')

		if [ "$_ver" -lt 10 ] ; then
			cfg_tty_notice "Debian version $rv detected"
			cfg_tty_alert "Debian version >= 10 required"
			exit 1
		fi

	else
		rv=$(grep "VERSION_ID" /etc/os-release				\
		    | tr -d '"'							\
		    | cut -d '=' -f 2)
		
		_ver=$(echo "$rv" | tr -d 'A-Z a-z ( ) .')

		if [ "$_ver" -lt 2004 ] ; then
			cfg_tty_notice "Ubuntu version $rv detected"
			cfg_tty_alert "Ubuntu version >= 20.04 required"
			exit 1
		fi
	fi
}


cfg_os_notify()
{
	cfg_os_distro
	
	if [ "$rv" = "Arch" ] ; then
		cfg_tty_info "Arch Linux detected"
	else
		_distro="$rv"
		cfg_os_version
		core_tty_info "$_distro ($rv) detected"
	fi
}


cfg_os_update()
{
	if [ "$(id -u)" -ne 0 ] ; then
		_su="sudo"
		sudo ls >/dev/null
	fi
	
	cfg_os_distro
	
	_log=".pkg.cfg.log"
	cfg_tty_notice "Updating packages, this may take a while"
	cfg_tty_progress_start "Updating" "$_log"
	cfg_tty_progress_update  25

	if [ "$rv" = "Arch" ] ; then
		"$_su" pacman -Syy >"$_log" 2>&1
	elif [ "$rv" = "FreeBSD" ] ; then
		"$_su" pkg update >"$_log" 2>&1
	else
		"$_su" apt-get update >"$_log" 2>&1
	fi
	
	rv=$?
	cfg_tty_progress_stop

	if [ -n "$CFG_LOG" ] ; then
		echo "$_log" >> "$CFG_LOG"
	fi

	if [ ! $rv -eq 0 ] ; then
		cfg_tty_crit "Package lists failed to update"
	fi

	rm -f "$_log" >/dev/null 2>&1
}


cfg_os_upgrade()
{
	if [ "$(id -u)" -ne 0 ] ; then
		_su="sudo"
		sudo ls >/dev/null
	fi
	
	cfg_os_distro
	
	_log=".pkg.cfg.log"
	cfg_tty_notice "Updating packages, this may take a while"
	cfg_tty_progress_start "Upgrading" "$_log"
	cfg_tty_progress_update  25

	if [ "$rv" = "Arch" ] ; then
		"$_su" pacman -Su --noconfirm >"$_log" 2>&1
	elif [ "$rv" = "FreeBSD" ] ; then
		"$_su" pkg upgrade -y >"$_log" 2>&1
	else
		"$_su" apt-get upgrade -y >"$_log" 2>&1
	fi
	
	rv=$?
	cfg_tty_progress_stop

	if [ -n "$CFG_LOG" ] ; then
		echo "$_log" >> "$CFG_LOG"
	fi

	if [ ! $rv -eq 0 ] ; then
		cfg_tty_crit "Failed to upgrade system"
	fi

	rm -f "$_log" >/dev/null 2>&1
}


cfg_os_install() {
	if [ "$(id -u)" -ne 0 ] ; then
		_su="sudo"
		sudo ls >/dev/null
	fi

	cfg_os_distro

	_log=".pkg.cfg.log"
	cfg_tty_notice "Installing packages, this may take a while"
	cfg_tty_progress_start "Installing $1" "$_log"
	cfg_tty_progress_update  25

	if [ "$rv" == "Arch" ] ; then
		"$_su" pacman -S --noconfirm --needed "$1" >"$_log" 2>&1
	elif [ "$rv" == "FreeBSD" ] ; then
		"$_su" pkg install -y --no-repo-update "$1" >"$_log" 2>&1
	else
		"$_su" apt install -y --no-upgrade "$1" >"$_log" 2>&1
	fi

	rv=$?
	cfg_tty_progress_stop

	if [ -n "$CFG_LOG" ] ; then
		echo "$_log" >> "$CFG_LOG"
	fi

	if [ ! $rv -eq 0 ] ; then
		cfg_tty_crit "Failed to install $1"
	fi

	rm -f "$_log" >/dev/null 2>&1
}

