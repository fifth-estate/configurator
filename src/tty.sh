export rv

##
# cfg_tty_emerg(): displays an emergency message
# $1: message to display
##
cfg_tty_emerg()
{
	printf "[\033[0;31mEMERG\033[0m] %s...\n" "$1"
	cfg_log_emerg "$1"
}


##
# cfg_tty_alert(): displays an alert message
# $1: message to display
##
cfg_tty_alert() 
{
	printf "[\033[0;31mALERT\033[0m] %s...\n" "$1"
	cfg_log_alert "$1"
}


##
# cfg_tty_crit(): displays a emergency meesage
# $1: message to display
##
cfg_tty_crit() 
{
	printf "[\033[0;31mCRIT\033[0m]  %s...\n" "$1"
	cfg_log_crit "$1"
	
}


##
# cfg_tty_err(): displays an error message
# $1: message to display
##
cfg_tty_err() 
{
	printf "[\033[0;31mERR\033[0m]   %s...\n" "$1"
	cfg_log_err "$1"	
}


##
# cfg_tty_warning(): displays a warning message
# $1: message to display
##
cfg_tty_warning() 
{
	printf "[\033[0;33mWARN\033[0m]  %s...\n" "$1"
	cfg_log_warning "$1"	
}


##
# cfg_tty_notice(): displays a notice message
# $1: message to display
##
cfg_tty_notice() 
{
	printf "[\033[0;33mNOTE\033[0m]  %s...\n" "$1"
	cfg_log_notice "$1"	
}


##
# cfg_tty_info(): displays an informational message
# $1: message to display
##
cfg_tty_info()
{
	printf "[\033[0;32mINFO\033[0m]  %s...\n" "$1"
	cfg_log_info "$1"	
}


##
# cfg_tty_debug(): displays a debug message
# $1: message to display
##
cfg_tty_debug()
{
	printf "[\033[0;32mDEBUG\033[0m] %s.\n" "$1"
	cfg_log_debug "$1"	
}


__cfg_tty_input()
{
	printf "[\033[0;34m INPUT\033[0m] %s: " "$1"
}


cfg_tty_yn() {
	__cfg_tty_input "$1 (y/N)"
	read -r _inp
	cfg_log_yn "$1" "$_inp"

	if [ -z "$_inp" ] ; then
		cfg_tty_info "Operation skipped"
		cfg_log_info "Operation skipped"

		return 1
	fi 

	if [ "$_inp" != "y" ] && [ "$_inp" != "Y" ] ; then
		cfg_tty_info "Operation skipped"
		cfg_log_info "Operation skipped"

		return 1
	fi
	
	return 0
}


cfg_tty_pwd() 
{
	__cfg_tty_input "$1"
	stty -echo ; read -r rv ; printf "\n" ; stty echo
	cfg_log_pwd "$1"
	
	__cfg_tty_input "Repeat password to confirm"
	stty -echo ; read -r _chk ; printf "\n" ; stty echo
	cfg_log_pwd "Repeat password to confirm"

	if [ "$rv" != "$_chk" ] ; then
		cfg_tty_error "Passwords don't match! Please try again"
		cfg_tty_pwd "$1"
	fi
}


cfg_tty_splash()
{
	_license=$(cat "$1")

	if [ -n "$2" ] ; then
		_logo=$(cat "$2")
		printf "%s\n\n" "$_logo"
	fi

	printf "%s\n\n" "$_license"
}


cfg_tty_cr()
{
	_cols=$(tput cols)
	printf "\r%${_cols}s" ""
}


# https://bash.cyberciti.biz/guide/Putting_functions_in_background

__cfg_tty_progress_run()
{
	while true ; do
		_len=$(tput cols)
		_len=$((_len / 4))
		_log=$(tail -n 1 "$1" | tr -d '\n')
		_curr=$(tail -n 1 "$CFG_PROGRESS_GRAPH")
		_done=$(((_curr * _len) / 100))
		_left=$((_len - _done - 1 ))

		cfg_tty_cr
		printf "\r %s%%\t[" "$_curr"
		__cfg_tty_progress_bar $_done "."
		__cfg_tty_progress_bar $_left "."
		printf "] %s: %s" "$CFG_PROGRESS_MSG" "$_log"
		
		sleep 1
	done
}

__cfg_tty_progress_bar()
{
	_i=0
	while [ $_i -le "$1" ] ; do
		printf "%s" "$2"
		_i=$((_i + 1))
	done
}


cfg_tty_progress_start()
{
	CFG_PROGRESS_MSG="$1"
	CFG_PROGRESS_GRAPH=".graph.cfg.log"

	echo 0 > "$CFG_PROGRESS_GRAPH"
	__cfg_tty_progress_run "$2" &
	CFG_PROGRESS_PID=$!
}


cfg_tty_progress_update()
{
	echo "$1" >> "$CFG_PROGRESS_GRAPH"
}


cfg_tty_progress_stop()
{
	kill $CFG_PROGRESS_PID >/dev/null 2>&1

	cfg_tty_cr
	cfg_tty_info "$CFG_PROGRESS_MSG: done"

	rm -f "$CFG_PROGRESS_GRAPH" >/dev/null 2>&1
}

