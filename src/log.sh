
##
# cfg_log_emerg(): displays an emergency message
# $1: message to display
##
cfg_log_emerg()
{
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [EMERG] %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_log_alert(): displays an alert message
# $1: message to display
##
cfg_log_alert() 
{
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [ALERT] %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_log_crit(): displays a emergency meesage
# $1: message to display
##
cfg_log_crit() 
{
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [CRIT]  %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_log_err(): displays an error message
# $1: message to display
##
cfg_log_err() 
{
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [ERR]   %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_log_warning(): displays a warning message
# $1: message to display
##
cfg_log_warning() 
{
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [WARN]  %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_log_notice(): displays a notice message
# $1: message to display
##
cfg_log_notice() 
{
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [NOTE]  %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_log_info(): displays an informational message
# $1: message to display
##
cfg_log_info()
{
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [INFO]  %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


##
# cfg_log_debug(): displays a debug message
# $1: message to display
##
cfg_log_debug()
{
	if [ -n "$CFG_LOG" ] ; then
		printf "%s [DEBUG] %s...\n" "$(date)" "$1" >> "$CFG_LOG"
	fi
}


__cfg_log_input()
{
	printf "%s [INPUT] %s" "$(date)" "$1" >> "$CFG_LOG"
}


cfg_log_yn()
{
	if [ -n "$CFG_LOG" ] ; then
		__cfg_log_input "$1 (y/N): "
		printf "%s" "$2" >> "$CFG_LOG"
	fi
}


cfg_log_pwd()
{
	if [ -n "$CFG_LOG" ] ; then
		__cfg_log_input "$1: ********"
	fi
}


cfg_log_set()
{
	CFG_LOG="$1"
}


cfg_log_unset()
{
	unset CFG_LOG
}

