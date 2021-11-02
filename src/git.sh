export rv

__cfg_git_clone_graph()
{
	while true ; do
		_steps=$2
		_steps=$((_steps * 2))

		_total=$(grep -c Total "$1")
		_enum=$(grep -c Enumerating "$1")
		
		_prog=$((((_total + _enum) * 100) / _steps))
		cfg_tty_progress_update $_prog
	done
}


cfg_git_clone()
{
	_log=".git.cfg.log"
	echo "" > "$_log"
	
	cfg_tty_progress_start "Cloning" "$_log"
	__cfg_git_clone_graph "$_log" "$2" &
	_pid=$!

	git clone --progress --recurse-submodules "$1" >"$_log" 2>&1
	rv=$?
	
	cfg_tty_progress_stop
	kill $_pid >/dev/null 2>&1
	
	if [ -n "$CFG_LOG" ] ; then
		echo "$_log" >> "$CFG_LOG"
	fi

	if [ $rv -ne 0 ] ; then
		cfg_tty_alert "Failed to clone repository $1"
		cfg_file_rm "$_log"
		exit
	fi
		
	cfg_file_rm "$_log"
}

