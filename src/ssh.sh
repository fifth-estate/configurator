export rv

cfg_ssh_copy()
{
	if [ -z "$CFG_LOG" ] ; then
		ssh copy-id -i "$1" "$2" >/dev/null 2>&1
	else
		ssh copy-id -i "$1" "$2" >"$CFG_LOG" 2>&1
	fi

	rv=$?
	if [ $rv -eq 0 ] ; then
		cfg_tty_info "Copied SSH key $1 --> $2"
	else
		cfg_tty_alert "Failed to copy SSH key $1 --> $2"
		exit 1
	fi
}


##!
# @func cfg_ssh_add(): adds an SSH key
# @param $1: path to SSH key
#
# The {{cfg_ssh_add()}} function adds a given SSH key to the running SSH
# instance. The SSH key to add is passed through the first parameter, and must
# physically exist. This function ensures that the SSH agent is running before
# adding the key. 
#
# If the log file is set (through the {{CFG_LOG}} environment variable), then
# the operation output is logged there; otherwise, the details are thrown to the
# {{/dev/null}} bit bucket.
#
# If all goes well, then the user is notified with a success message. In case an
# error is encountered, then an alert is raised before exiting with the error
# code 1.
##
cfg_ssh_add()
{
	if [ -z "$CFG_LOG" ] ; then
		eval "$(ssh-agent -s)" >/dev/null 2>&1
	else
		eval "$(ssh-agent -s)" >"$CFG_LOG" 2>&1
	fi
	
	rv=$?
	if [ $rv -ne 0 ] ; then
		cfg_tty_alert "Failed to enable SSH agent"
		exit 1
	fi
	
	if [ -z "$CFG_LOG" ] ; then
		ssh-add "$1" >/dev/null 2>&1
	else
		ssh-add "$1" >"$CFG_LOG" 2>&1
	fi
	
	rv=$?
	if [ $rv -eq 0 ] ; then
		cfg_tty_info "Added SSH key $1"
	else
		cfg_tty_alert "Failed to add SSH key $1"
		exit 1
	fi
}

