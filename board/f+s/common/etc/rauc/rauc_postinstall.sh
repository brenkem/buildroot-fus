#!/bin/sh


printenv > /tmp/log;

for i in $RAUC_TARGET_SLOTS; do
        eval RAUC_SLOT_DEVICE=\$RAUC_SLOT_DEVICE_${i}
        eval RAUC_IMAGE_NAME=\$RAUC_IMAGE_NAME_${i}
        eval RAUC_IMAGE_DIGEST=\$RAUC_IMAGE_DIGEST_${i}

		export SIZE=$(wc -c < $RAUC_IMAGE_NAME)
		sync && echo 3 > /proc/sys/vm/drop_caches
		if [[ "$(dd bs=$SIZE count=1 if=$RAUC_SLOT_DEVICE | sha256sum)" != "$RAUC_IMAGE_DIGEST  -" ]]; then
			exit 5
		fi
done
exit 0
