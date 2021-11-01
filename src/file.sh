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

