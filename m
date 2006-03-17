From: "Michael Steinmann" <msl@calivia.com>
Subject: multipath-tools: race-condition with boot.multipath and
	boot.lvm
Date: Fri, 17 Mar 2006 10:56:41 +0100 (CET)
Message-ID: <59460.193.5.216.100.1142589401.squirrel@www2.calivia.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

We're currently experiencing problems at boot and got aware of a
race-condition related to LVM over multipath.

We're on SuSE SLES9 SP3 x86_64, multipath-tools-0.4.5-0.11

The SuSE initscript contains 'sleep 1' after running /sbin/multipath in
/etc/init.d/boot.multipath. Our SAN is currently so slow that we had to
increase the sleep to 15 seconds to boot reliably. If the vgscan in
/etc/init.d/boot.lvm starts too quick it would not see the VGs on the
multipath devices.

Is there a way to wait until all multipath devices are up and ready?


The relevant part of SLES9 SP3 /etc/init.d/boot.multipath:

case "$1" in
    start)
        echo -n "Creating multipath targets"
        # Check whether we should rescan for devices
        if grep -q multipath /proc/cmdline && test -d
/sys/class/scsi_host; then
            pushd /sys/class/scsi_host 2> /dev/null
            for host in *; do
                if [ -d $host ]; then
                    echo "- - -" > $host/scan
                fi
            done
        fi
        # Load prerequisite module
        modprobe dm-multipath

        # Clear /dev/disk/by-name/ prior to start-up; multipath will
        # recreate them.
        rm -f /dev/disk/by-name/* 2>&1 >/dev/null

        # Start the program directly as checkproc doesn't work here
        $PROGRAM -v 0

        # Remember status and be verbose
        rc_status -v
-        sleep 1
+        sleep 15
        ;;

--
mike
