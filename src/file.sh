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

		if [ "$rv" -eq 0 ] ; then
			cfg_tty_info "$1 removed"
		else
			cfg_tty_warning "Failed to remove $1"
		fi
	else
		cfg_tty_notice "$1 not found, skipping removal"
	fi
}

