FINEGRAINED_SUPPORTED=yes
NAMEEXTRA=

run_bench() {
	$SCRIPTDIR/shellpacks/shellpack-bench-fio \
		${FIO_CMD_OPTIONS:+--cmdline "$FIO_CMD_OPTIONS"}
	return $?
}
