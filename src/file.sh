export rv

cfg_file_mkdir()
{
	if [ -d "$1" ] ; then
		cfg_tty_notice "Directory $1 already exists"
	else
		mkdir -p "$1" >/dev/null 2>&1
		rv=$?

		if [ "$rv" -eq 0 ] ; then
			cfg_tty_info "Directory $1 created"
		else
			cfg_tty_alert "Failed to create directory $1"
			exit
		fi
	fi
}


cfg_file_rm()
{
	if [ -f "$1" ] || [ -d "$1" ] ; then
		rm -rf "$1" >/dev/null 2>&1
		rv=$?

		if [ "$rv" -eq 0 ] ; then
			cfg_tty_info "$1 removed"
		else
			cfg_tty_warning "Failed to remove $1"
		fi
	else
		cfg_tty_notice "$1 not found, skipping removal"
	fi
}


cfg_file_put() 
{
	printf "%b" "$2" >> "$1"
	rv=$?

	if [ "$rv" -ne 0 ] ; then
		cfg_tty_alert "Failed to write to $1"
		return 1
	fi

	return 0
}


cfg_file_putn() 
{
	printf "%b\n" "$2" >> "$1"
	rv=$?

	if [ "$rv" -ne 0 ] ; then
		cfg_tty_alert "Failed to write to $1"
		return 1
	fi

	return 0
}


cfg_file_sym() 
{
	if [ -L "$2" ] ; then
		if [ -e "$2" ] ; then
			cfg_tty_notice "Symlink $2 exists, skipping"
			return 0
		else
			cfg_tty_warning "Broken symlink $2 found, removing"
			cfg_file_rm "$2"
		fi
	fi

	if [ ! -f "$1" ] ; then
		cfg_tty_crit "Target $1 not found, symlink not created"
		return 1
	fi
	
	ln -sf "$1" "$2" >/dev/null 2>&1
	rv=$?

	if [ "$rv" -eq 0 ] ; then
		cfg_tty_info "Symlink $2 --> $1 created"
	else
		cfg_tty_alert "Failed to create symlink $2 --> $1"
	fi
}

