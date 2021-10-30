
##
# cfg_tty_emerg(): displays an emergency message
# $1: message to display
##
cfg_tty_emerg()
{
	printf "[\033[0;31mEMERG\033[0m] %s...\n" "$1"

	if [ -n "$CFG_LOG" ] ; then
		printf "%s [EMERG] %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi

	exit
}


##
# cfg_tty_alert(): displays an alert message
# $1: message to display
##
cfg_tty_alert() 
{
	printf "[\033[0;31mALERT\033[0m] %s...\n" "$1"
	
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [ALERT] %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi

	exit
}


##
# cfg_tty_crit(): displays a emergency meesage
# $1: message to display
##
cfg_tty_crit() 
{
	printf "[\033[0;31mCRIT\033[0m]  %s.\n" "$1"
	
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [CRIT]  %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_tty_err(): displays an error message
# $1: message to display
##
cfg_tty_err() 
{
	printf "[\033[0;31mERR\033[0m]   %s.\n" "$1"
	
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [ERR]   %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_tty_warning(): displays a warning message
# $1: message to display
##
cfg_tty_warning() 
{
	printf "[\033[0;33mWARN\033[0m]  %s.\n" "$1"
	
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [WARN]  %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_tty_notice(): displays a notice message
# $1: message to display
##
cfg_tty_notice() 
{
	printf "[\033[0;33mNOTE\033[0m]  %s.\n" "$1"
	
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [NOTE]  %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_tty_info(): displays an informational message
# $1: message to display
##
cfg_tty_info()
{
	printf "[\033[0;32mINFO\033[0m]  %s.\n" "$1"
	
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [INFO]  %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_tty_debug(): displays a debug message
# $1: message to display
##
cfg_tty_debug()
{
	printf "[\033[0;32mDEBUG\033[0m] %s.\n" "$1"
	
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [DEBUG] %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}

