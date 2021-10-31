
##
# cfg_tty_emerg(): displays an emergency message
# $1: message to display
##
cfg_tty_emerg()
{
	printf "[\033[0;31mEMERG\033[0m] %s...\n" "$1"
	cfg_log_emerg "$1"

	exit
}


##
# cfg_tty_alert(): displays an alert message
# $1: message to display
##
cfg_tty_alert() 
{
	printf "[\033[0;31mALERT\033[0m] %s...\n" "$1"
	cfg_log_alert "$1"

	exit
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
	printf "[\033[0;32mINFO\033[0m]  %s.\n" "$1"
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


cfg_tty_yn() {
	printf "[\033[0;34m INPUT\033[0m] %s (y/N): " "$1"
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

