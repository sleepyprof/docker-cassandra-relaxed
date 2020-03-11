#!/bin/bash
set -e

# first arg is `-f` or `--some-option`
# or there are no args
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
	set -- cassandra -f "$@"
fi

# "sed -i", but without "mv" (which doesn't work on a bind-mounted file, for example)
_sed-in-place() {
	local filename="$1"; shift
	local tempFile
	tempFile="$(mktemp)"
	sed "$@" "$filename" > "$tempFile"
	cat "$tempFile" > "$filename"
	rm "$tempFile"
}

# perform even more settings as in the default cassandra image
if [ "$1" = 'cassandra' ]; then
	for yaml in \
		read_request_timeout_in_ms \
		range_request_timeout_in_ms \
		write_request_timeout_in_ms \
		counter_write_request_timeout_in_ms \
		request_timeout_in_ms \
		native_transport_max_frame_size_in_mb \
		max_value_size_in_mb \
	; do
		var="CASSANDRA_${yaml^^}"
		val="${!var}"
		if [ "$val" ]; then
			_sed-in-place "$CASSANDRA_CONF/cassandra.yaml" \
				-r 's/^(# )?('"$yaml"':).*/\2 '"$val"'/'
		fi
	done
fi

docker-entrypoint.sh $@
