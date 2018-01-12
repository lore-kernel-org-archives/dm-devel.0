From: Julian Andres Klode <julian.klode@canonical.com>
Subject: multipath-tools 0.7.4 failure to remove device
Date: Fri, 12 Jan 2018 09:38:33 +0100
Message-ID: <20180112083833.apsybil4ux4d2y32@jak-x230>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ozuh6bihxa5nsjii"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Device-mapper development mailing list <dm-devel@redhat.com>
List-Id: dm-devel.ids


--ozuh6bihxa5nsjii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I am working on updating Ubuntu's multipath-tools from 0.6.4 to 0.7.4, and
our tests report a weird failure. We first build a multipath device from 4
nodes, and then start removing nodes while performing I/O to the multipath
device. This works fine for one or two removals, but eventually we end up
with:

+ multipath -ll
Jan 12 08:23:50 | 8:16: cannot find block device
Jan 12 08:23:50 | 8:16: Empty device name
Jan 12 08:23:50 | 8:16: Empty device name
360000000000000000e00000000010001 dm-0 IET,VIRTUAL-DISK
size=100M features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=0 status=enabled
| `- #:#:#:# -   #:#  failed undef unknown
|-+- policy='service-time 0' prio=1 status=active
| `- 4:0:0:1 sdc 8:32 active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 5:0:0:1 sdd 8:48 active ready running

and then we get I/O error on the device and it's rendered unusable. It's
also crashing in uev_pathfail_check() occassionally because find_path_by_devt()
returns NULL, so I applied the following patch to at least continue, but that's
obviously wrong - We get an udev event for a device which does not exist in /dev
(but it should)?

--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1090,6 +1090,11 @@ uev_pathfail_check(struct uevent *uev, s
 	lock(&vecs->lock);
 	pthread_testcancel();
 	pp = find_path_by_devt(vecs->pathvec, devt);
+	if (!pp) {
+		condlog(3, "%s: Cannot find path by dm path %s", uev->kernel, devt);
+		FREE(devt);
+		goto out;
+	}
 	r = io_err_stat_handle_pathfail(pp);
 	lock_cleanup_pop(vecs->lock);
 

The journal mentions something useful I guess. Let's start at the mount:

Jan 12 09:17:30 autopkgtest kernel: EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
Jan 12 09:17:42 autopkgtest kernel: device-mapper: multipath: Failing path 8:0.
Jan 12 09:17:42 autopkgtest multipathd[1980]: sda: mark as failed
Jan 12 09:17:42 autopkgtest multipathd[1980]: 360000000000000000e00000000010001: remaining active paths: 3
Jan 12 09:17:42 autopkgtest kernel: sd 2:0:0:1: [sda] Synchronizing SCSI cache
Jan 12 09:17:42 autopkgtest multipathd[1980]: sda: remove path (uevent)
Jan 12 09:17:42 autopkgtest multipathd[1980]: 360000000000000000e00000000010001: load table [0 204800 multipath 0 0 3 1 service-time 0 1 1 8:16 1 service-time 0 1 1 8:32 1 service-time 0 1 1 8:48 1
Jan 12 09:17:42 autopkgtest multipathd[1980]: ]
Jan 12 09:17:42 autopkgtest multipathd[1980]: sda [8:0]: path removed from map 360000000000000000e00000000010001
Jan 12 09:17:42 autopkgtest multipath[6877]: dm-0: usable paths found
Jan 12 09:17:42 autopkgtest multipath[6887]: dm-0: usable paths found
Jan 12 09:17:43 autopkgtest iscsid[649]: Connection1:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is shutdown.
Jan 12 09:17:43 autopkgtest multipathd[1980]: dm-0: Cannot find path by dm path 8:0

			   ^^^^^^^^^^^^^^^^^^^ would have crashed here

Jan 12 09:17:52 autopkgtest kernel: device-mapper: multipath: Failing path 8:16.
Jan 12 09:17:52 autopkgtest kernel: sd 3:0:0:1: [sdb] Synchronizing SCSI cache
Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: cannot find block device
Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: Empty device name
Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: Empty device name
Jan 12 09:17:52 autopkgtest multipath[6909]: get_udev_device: failed to look up 8:16 with type 1
Jan 12 09:17:52 autopkgtest multipath[6909]: dm-0: usable paths found
Jan 12 09:17:53 autopkgtest iscsid[649]: Connection2:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is shutdown.

We can see that it correctly removed the first device (sda) - except well, it seems to try
again and fail with the part where it would have crashed. But when it tries to lookup the
second one it fails.

Given that this works in 0.6.4, I think it's a bug that appeared later on,
but I can't really pin point the source of it.


I attached:

* the test script (might need some changes to run outside Ubuntu,
  it uses service tgt restart and writes output to $AUTOPKGTEST_ARTIFACTS)
* a udevadm monitor log when removing devices
* test-background.log which logs the path removals
* journal.log which contains the systemd journal, starting when multipathd started
* autopkgtest.log containing the output (from the run before, I accidentally deleted
  the current run, but output is the same)

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en

--ozuh6bihxa5nsjii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="test-background.log"

+ iscsiadm --mode session
tcp: [1] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [2] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [3] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [4] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
+ sleep 10s
+ date +MP report (expect 4) %H:%M:%S.%N
MP report (expect 4) 09:17:41.865602408
+ multipath -ll
360000000000000000e00000000010001 dm-0 IET,VIRTUAL-DISK
size=100M features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=1 status=active
| `- 2:0:0:1 sda 8:0  active ready running
|-+- policy='service-time 0' prio=1 status=enabled
| `- 3:0:0:1 sdb 8:16 active ready running
|-+- policy='service-time 0' prio=1 status=enabled
| `- 4:0:0:1 sdc 8:32 active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 5:0:0:1 sdd 8:48 active ready running
+ date +UN-plug path 1 %H:%M:%S.%N
UN-plug path 1 09:17:42.061970430
+ iscsiadm --mode session -r 1 -u
Logging out of session [sid: 1, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260]
Logout of [sid: 1, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session
tcp: [2] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [3] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [4] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
+ sleep 10s
+ date +MP report (expect 3) %H:%M:%S.%N
MP report (expect 3) 09:17:52.120551204
+ multipath -ll
360000000000000000e00000000010001 dm-0 IET,VIRTUAL-DISK
size=100M features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=1 status=active
| `- 3:0:0:1 sdb 8:16 active ready running
|-+- policy='service-time 0' prio=1 status=enabled
| `- 4:0:0:1 sdc 8:32 active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 5:0:0:1 sdd 8:48 active ready running
+ date +UN-plug path 2 %H:%M:%S.%N
UN-plug path 2 09:17:52.140778540
+ iscsiadm --mode session -r 2 -u
Logging out of session [sid: 2, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260]
Logout of [sid: 2, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session
tcp: [3] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [4] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
+ sleep 10s
+ date +MP report (expect 2) %H:%M:%S.%N
MP report (expect 2) 09:18:02.174689219
+ multipath -ll
Jan 12 09:18:02 | 8:16: cannot find block device
Jan 12 09:18:02 | 8:16: Empty device name
Jan 12 09:18:02 | 8:16: Empty device name
360000000000000000e00000000010001 dm-0 IET,VIRTUAL-DISK
size=100M features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=0 status=enabled
| `- #:#:#:# -   #:#  failed undef unknown
|-+- policy='service-time 0' prio=1 status=active
| `- 4:0:0:1 sdc 8:32 active ready running
`-+- policy='service-time 0' prio=1 status=enabled
  `- 5:0:0:1 sdd 8:48 active ready running
+ date +UN-plug path 3 %H:%M:%S.%N
UN-plug path 3 09:18:02.211466936
+ iscsiadm --mode session -r 3 -u
Logging out of session [sid: 3, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260]
Logout of [sid: 3, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session
tcp: [4] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
+ sleep 10s
+ date +MP report (expect 1) %H:%M:%S.%N
MP report (expect 1) 09:18:12.259643693
+ multipath -ll
Jan 12 09:18:12 | 8:16: cannot find block device
Jan 12 09:18:12 | 8:16: Empty device name
Jan 12 09:18:12 | 8:16: Empty device name
Jan 12 09:18:12 | 8:32: cannot find block device
Jan 12 09:18:12 | 8:32: Empty device name
Jan 12 09:18:12 | 8:32: Empty device name
360000000000000000e00000000010001 dm-0 IET,VIRTUAL-DISK
size=100M features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=0 status=enabled
| `- #:#:#:# -   #:#  failed undef unknown
|-+- policy='service-time 0' prio=0 status=enabled
| `- #:#:#:# -   #:#  failed undef unknown
`-+- policy='service-time 0' prio=1 status=active
  `- 5:0:0:1 sdd 8:48 active ready running
+ date +Add paths 5/6/7/8 %H:%M:%S.%N
Add paths 5/6/7/8 09:18:12.271680780
+ iscsiadm --mode session -r 4 --op new
Logging in to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] (multiple)
Login to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session -r 4 --op new
Logging in to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] (multiple)
Login to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session -r 4 --op new
Logging in to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] (multiple)
Login to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session -r 4 --op new
Logging in to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] (multiple)
Login to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session
tcp: [4] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [5] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [6] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [7] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [8] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
+ sleep 10s
+ date +MP report (expect 5) %H:%M:%S.%N
MP report (expect 5) 09:18:22.361908579
+ multipath -ll
Jan 12 09:18:22 | 8:16: cannot find block device
Jan 12 09:18:22 | 8:16: Empty device name
Jan 12 09:18:22 | 8:16: Empty device name
Jan 12 09:18:22 | 8:32: cannot find block device
Jan 12 09:18:22 | 8:32: Empty device name
Jan 12 09:18:22 | 8:32: Empty device name
360000000000000000e00000000010001 dm-0 IET,VIRTUAL-DISK
size=100M features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=0 status=enabled
| `- #:#:#:# -   #:#  failed undef unknown
|-+- policy='service-time 0' prio=0 status=enabled
| `- #:#:#:# -   #:#  failed undef unknown
`-+- policy='service-time 0' prio=1 status=active
  `- 5:0:0:1 sdd 8:48 active ready running
+ date +UN-plug multiple paths 4/7/8 %H:%M:%S.%N
UN-plug multiple paths 4/7/8 09:18:22.391372112
+ iscsiadm --mode session -r 4 -u
Logging out of session [sid: 4, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260]
Logout of [sid: 4, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session -r 7 -u
Logging out of session [sid: 7, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260]
Logout of [sid: 7, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session -r 8 -u
Logging out of session [sid: 8, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260]
Logout of [sid: 8, target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] successful.
+ iscsiadm --mode session
tcp: [5] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
tcp: [6] 127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi (non-flash)
+ sleep 10s
+ date +Restart multipath daemon %H:%M:%S.%N
Restart multipath daemon 09:18:32.503401265
+ systemctl restart multipathd

--ozuh6bihxa5nsjii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=tgtbasedmpaths

#!/bin/sh
# autopkgtest check: tgt and open-iscsi based mpath operations
# The test is intentionally extra verbose to have rich log and to stress
# some of the code paths in and around multipath on top of the actual IO test.
# (C) 2016 Canonical Ltd.
# Author: Christian Ehrhardt <christian.ehrhardt@canonical.com>

# Tests the creation and usage of a tgt target and lun on localhost
set -uxe

targetname="iqn.2016-11.foo.com:target.iscsi"
cwd=$(pwd)
testdir="/mnt/tgtmpathtest"
localhost="127.0.0.1"
portal="${localhost}:3260"
maxpaths=4
backfn="backingfile"
expectwwid="360000000000000000e00000000010001"
testdisk="/dev/disk/by-id/scsi-${expectwwid}"
bglog="$AUTOPKGTEST_ARTIFACTS/test-background.log"
udevlog="$AUTOPKGTEST_ARTIFACTS/udev-path-changes.log"
fioprep="$AUTOPKGTEST_ARTIFACTS/path-change-prep.fio"
fiovrfy="$AUTOPKGTEST_ARTIFACTS/path-change-check.fio"

# Restart tgtd to make sure modules are all loaded
service tgt restart || echo "Failed to restart tgt" >&2

# prep SINGLE test file
truncate --size 100M ${backfn}

# create target
tgtadm --lld iscsi --op new --mode target --tid 1 -T "${targetname}"
# allow all to bind the target
tgtadm --lld iscsi --op bind --mode target --tid 1 -I ALL
# set backing file
tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b "${cwd}/${backfn}"

# scan for targets (locally)
iscsiadm --mode discovery --type sendtargets --portal ${localhost}

# login
echo "login #1"
iscsiadm --mode node --targetname "${targetname}" --portal ${portal} --login
# duplicate this session (always 1)
for i in $(seq 2 ${maxpaths})
do
    echo "extra login #${i}"
    iscsiadm --mode session -r 1 --op new
done

udevadm settle

# status summary
echo "Status after initial setup"
tgtadm --lld iscsi --mode target --op show
tgtadm --lld iscsi --op show --mode conn --tid 1
iscsiadm --mode session -P 1
lsscsi -liv
multipath -v3 -ll
dmsetup table

echo "Test WWN should now point to DM"
readlink "${testdisk}" | grep dm

# create FS on the mpathed device
mkfs.ext4 -F "${testdisk}"
udevadm settle
sleep 3s
mkdir -p ${testdir}
mount "${testdisk}" ${testdir}

# based on /usr/share/doc/fio/examples/surface-scan.fio
cat << EOF > ${fioprep}
; writes 512 byte verification blocks until the disk is full,
; then verifies written data
[global]
directory=${testdir}
thread=1
bs=64k
direct=1
ioengine=sync
verify=meta
verify_pattern=0xaa555aa5
verify_interval=512

[write-phase]
filename=datafile.tmp   ; or use a full disk, for example /dev/sda
rw=write
fill_device=1
do_verify=0
EOF

cat << EOF > ${fiovrfy}
; verifies written data
[global]
directory=${testdir}
thread=1
bs=64k
direct=1
ioengine=sync
verify=meta
verify_pattern=0xaa555aa5
verify_interval=512

[verify-phase]
stonewall
create_serialize=0
filename=datafile.tmp
rw=read
do_verify=1
runtime=180
time_based
EOF

# IO Bench with verify
# prep files
fio "${fioprep}"

udevadm monitor > $udevlog		&

# while verify is running unplud/plug paths as well as restart the daemon
# Note - we run in a clean env, so we just assume each new session is an increment
# Even with other multipath/scsi devices on the system this is true, jutst no
# other iscsi logins are allowed - since the test runs under isolation-machine
# that should be safe.
# That way we can directly call IDs without huge logic on the session IDs
echo "Starting the path changes in background"
(
    iscsiadm --mode session
    sleep 10s
    date +'MP report (expect 4) %H:%M:%S.%N'
    multipath -ll
    date +'UN-plug path 1 %H:%M:%S.%N'
    iscsiadm --mode session -r 1 -u
    iscsiadm --mode session
    sleep 10s
    date +'MP report (expect 3) %H:%M:%S.%N'
    multipath -ll
    date +'UN-plug path 2 %H:%M:%S.%N'
    iscsiadm --mode session -r 2 -u
    iscsiadm --mode session
    sleep 10s
    date +'MP report (expect 2) %H:%M:%S.%N'
    multipath -ll
    date +'UN-plug path 3 %H:%M:%S.%N'
    iscsiadm --mode session -r 3 -u
    iscsiadm --mode session
    sleep 10s
    date +'MP report (expect 1) %H:%M:%S.%N'
    multipath -ll
    date +'Add paths 5/6/7/8 %H:%M:%S.%N'
    iscsiadm --mode session -r 4 --op new
    iscsiadm --mode session -r 4 --op new
    iscsiadm --mode session -r 4 --op new
    iscsiadm --mode session -r 4 --op new
    iscsiadm --mode session
    sleep 10s
    date +'MP report (expect 5) %H:%M:%S.%N'
    multipath -ll
    date +'UN-plug multiple paths 4/7/8 %H:%M:%S.%N'
    iscsiadm --mode session -r 4 -u
    iscsiadm --mode session -r 7 -u
    iscsiadm --mode session -r 8 -u
    iscsiadm --mode session
    sleep 10s
    date +'Restart multipath daemon %H:%M:%S.%N'
    systemctl restart multipathd
    sleep 10s
    date +'Final background report (expect 2) %H:%M:%S.%N'
    multipath -ll
) > "${bglog}" 2>&1 &

# test I/O with verification of actual content
# on any I/O error or verification of read data it would fail
date +'Pre FIO %H:%M:%S.%N'
fio "${fiovrfy}"
date +'Post FIO %H:%M:%S.%N'

echo "FIO verify test with changing paths - OK"

echo "Report log of background activity"
cat "${bglog}"

sync
umount "${testdisk}"

# report stats - might be useful if checked across various tests that misbehave
echo "Final stats"
iscsiadm --mode session --stats
journalctl --no-pager -u multipathd

echo "Check final path status"
multipath -ll
# ensure we have one active and one running path
diskc=$(multipath -ll | grep --count 'status=')
diska=$(multipath -ll | grep --count 'status=active')
diske=$(multipath -ll | grep --count 'status=enabled')
if [ "${diskc}" -ne "2" -o "${diska}" -ne "1" -o "${diske}" -ne "1" ]; then
    echo "Error: Not the expected count of active/enabled disks"
    exit 1
else
    echo "OK"
fi

# logout and target delete should work even after all of this
iscsiadm --mode node --targetname "${targetname}" --portal "${portal}" --logout
tgtadm --lld iscsi --op delete --mode logicalunit --tid 1 --lun 1

--ozuh6bihxa5nsjii
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="autopkgtest.log"
Content-Transfer-Encoding: quoted-printable

autopkgtest [08:49:10]: version 5.1
autopkgtest [08:49:10]: host jak-x230; command line: /usr/bin/autopkgtest -=
l autopkgtest.log '--setup-commands=3Dapt install -y systemd-coredump gdb' =
--shell-fail ../multipath-tools_0.7.4-2ubuntu1_amd64.changes -- qemu /home/=
jak/autopkgtest-bionic-amd64.img
autopkgtest [08:49:31]: @@@@@@@@@@@@@@@@@@@@ test bed setup

WARNING: apt does not have a stable CLI interface. Use with caution in scri=
pts.

Reading package lists...
Building dependency tree...
Reading state information...
The following package was automatically installed and is no longer required:
  grub-pc-bin
Use 'apt autoremove' to remove it.
The following additional packages will be installed:
  gdbserver libbabeltrace1 libc6-dbg libcc1-0 libdw1 libelf1 libnss-systemd
  libpam-systemd libsystemd0 python3-apport systemd
Suggested packages:
  gdb-doc python3-launchpadlib systemd-container
Recommended packages:
  apport
The following packages will be REMOVED:
  apport ubuntu-server
The following NEW packages will be installed:
  gdb gdbserver libbabeltrace1 libc6-dbg libcc1-0 libdw1 systemd-coredump
The following packages will be upgraded:
  libelf1 libnss-systemd libpam-systemd libsystemd0 python3-apport systemd
6 upgraded, 7 newly installed, 2 to remove and 16 not upgraded.
Need to get 11.7 MB of archives.
After this operation, 48.5 MB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnss-systemd amd=
64 235-3ubuntu3 [97.2 kB]
Get:2 http://archive.ubuntu.com/ubuntu bionic/main amd64 libpam-systemd amd=
64 235-3ubuntu3 [100 kB]
Get:3 http://archive.ubuntu.com/ubuntu bionic/main amd64 systemd amd64 235-=
3ubuntu3 [2,834 kB]
Get:4 http://archive.ubuntu.com/ubuntu bionic/main amd64 libsystemd0 amd64 =
235-3ubuntu3 [197 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic/main amd64 libelf1 amd64 0.17=
0-0.2 [44.4 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic/main amd64 libdw1 amd64 0.170=
-0.2 [203 kB]
Get:7 http://archive.ubuntu.com/ubuntu bionic/main amd64 libbabeltrace1 amd=
64 1.5.3-4 [152 kB]
Get:8 http://archive.ubuntu.com/ubuntu bionic/main amd64 gdb amd64 8.0.1-0u=
buntu3 [2,735 kB]
Get:9 http://archive.ubuntu.com/ubuntu bionic/main amd64 gdbserver amd64 8.=
0.1-0ubuntu3 [185 kB]
Get:10 http://archive.ubuntu.com/ubuntu bionic/main amd64 libcc1-0 amd64 7.=
2.0-18ubuntu2 [38.7 kB]
Get:11 http://archive.ubuntu.com/ubuntu bionic/main amd64 python3-apport al=
l 2.20.8-0ubuntu6 [80.6 kB]
Get:12 http://archive.ubuntu.com/ubuntu bionic/universe amd64 systemd-cored=
ump amd64 235-3ubuntu3 [41.6 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic/main amd64 libc6-dbg amd64 2=
=2E26-0ubuntu2 [4,996 kB]
Fetched 11.7 MB in 0s (50.7 MB/s)
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 57061 files and directories currently installed.)
Removing ubuntu-server (1.407) ...
Removing apport (2.20.8-0ubuntu5) ...
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 56982 files and directories currently installed.)
Preparing to unpack .../libnss-systemd_235-3ubuntu3_amd64.deb ...
Unpacking libnss-systemd:amd64 (235-3ubuntu3) over (235-3ubuntu2) ...
Preparing to unpack .../libpam-systemd_235-3ubuntu3_amd64.deb ...
Unpacking libpam-systemd:amd64 (235-3ubuntu3) over (235-3ubuntu2) ...
Preparing to unpack .../systemd_235-3ubuntu3_amd64.deb ...
Unpacking systemd (235-3ubuntu3) over (235-3ubuntu2) ...
Preparing to unpack .../libsystemd0_235-3ubuntu3_amd64.deb ...
Unpacking libsystemd0:amd64 (235-3ubuntu3) over (235-3ubuntu2) ...
Setting up libsystemd0:amd64 (235-3ubuntu3) ...
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 56982 files and directories currently installed.)
Preparing to unpack .../0-libelf1_0.170-0.2_amd64.deb ...
Unpacking libelf1:amd64 (0.170-0.2) over (0.170-0.1) ...
Selecting previously unselected package libdw1:amd64.
Preparing to unpack .../1-libdw1_0.170-0.2_amd64.deb ...
Unpacking libdw1:amd64 (0.170-0.2) ...
Selecting previously unselected package libbabeltrace1:amd64.
Preparing to unpack .../2-libbabeltrace1_1.5.3-4_amd64.deb ...
Unpacking libbabeltrace1:amd64 (1.5.3-4) ...
Selecting previously unselected package gdb.
Preparing to unpack .../3-gdb_8.0.1-0ubuntu3_amd64.deb ...
Unpacking gdb (8.0.1-0ubuntu3) ...
Selecting previously unselected package gdbserver.
Preparing to unpack .../4-gdbserver_8.0.1-0ubuntu3_amd64.deb ...
Unpacking gdbserver (8.0.1-0ubuntu3) ...
Selecting previously unselected package libcc1-0:amd64.
Preparing to unpack .../5-libcc1-0_7.2.0-18ubuntu2_amd64.deb ...
Unpacking libcc1-0:amd64 (7.2.0-18ubuntu2) ...
Preparing to unpack .../6-python3-apport_2.20.8-0ubuntu6_all.deb ...
Unpacking python3-apport (2.20.8-0ubuntu6) over (2.20.8-0ubuntu5) ...
Selecting previously unselected package systemd-coredump.
Preparing to unpack .../7-systemd-coredump_235-3ubuntu3_amd64.deb ...
Unpacking systemd-coredump (235-3ubuntu3) ...
Selecting previously unselected package libc6-dbg:amd64.
Preparing to unpack .../8-libc6-dbg_2.26-0ubuntu2_amd64.deb ...
Unpacking libc6-dbg:amd64 (2.26-0ubuntu2) ...
Setting up libcc1-0:amd64 (7.2.0-18ubuntu2) ...
Setting up libc6-dbg:amd64 (2.26-0ubuntu2) ...
Processing triggers for ureadahead (0.100.0-20) ...
Setting up libelf1:amd64 (0.170-0.2) ...
Setting up python3-apport (2.20.8-0ubuntu6) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
Setting up systemd (235-3ubuntu3) ...
Created symlink /etc/systemd/system/dbus-org.freedesktop.network1.service =
=E2=86=92 /lib/systemd/system/systemd-networkd.service.
Processing triggers for man-db (2.7.6.1-4) ...
Setting up gdbserver (8.0.1-0ubuntu3) ...
Processing triggers for dbus (1.12.2-1ubuntu1) ...
Setting up libnss-systemd:amd64 (235-3ubuntu3) ...
Setting up libpam-systemd:amd64 (235-3ubuntu3) ...
Setting up libdw1:amd64 (0.170-0.2) ...
Setting up libbabeltrace1:amd64 (1.5.3-4) ...
Setting up systemd-coredump (235-3ubuntu3) ...
Setting up gdb (8.0.1-0ubuntu3) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
autopkgtest [08:49:44]: rebooting testbed after setup commands that affecte=
d boot
autopkgtest [08:50:05]: testbed running kernel: Linux 4.13.0-17-generic #20=
-Ubuntu SMP Mon Nov 6 10:04:08 UTC 2017
autopkgtest [08:50:05]: testbed dpkg architecture: amd64
autopkgtest [08:50:08]: @@@@@@@@@@@@@@@@@@@@ source ../multipath-tools_0.7.=
4-2ubuntu1.dsc
Reading package lists...
Building dependency tree...
Reading state information...
Correcting dependencies...Starting pkgProblemResolver with broken count: 0
Starting 2 pkgProblemResolver with broken count: 0
Done
 Done
Starting pkgProblemResolver with broken count: 0
Starting 2 pkgProblemResolver with broken count: 0
Done
The following package was automatically installed and is no longer required:
  grub-pc-bin
Use 'apt autoremove' to remove it.
The following additional packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu dpkg-dev libbinutils
  libdpkg-perl make
Suggested packages:
  binutils-doc debian-keyring gcc | c-compiler bzr make-doc
Recommended packages:
  build-essential gcc | c-compiler fakeroot libalgorithm-merge-perl
  libfile-fcntllock-perl
The following NEW packages will be installed:
  binutils binutils-common binutils-x86-64-linux-gnu dpkg-dev libbinutils
  libdpkg-perl make
0 upgraded, 7 newly installed, 0 to remove and 21 not upgraded.
1 not fully installed or removed.
Need to get 3,492 kB of archives.
After this operation, 18.9 MB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu bionic/main amd64 libdpkg-perl all 1=
=2E19.0.4ubuntu1 [211 kB]
Get:2 http://archive.ubuntu.com/ubuntu bionic/main amd64 make amd64 4.1-9.1=
 [154 kB]
Get:3 http://archive.ubuntu.com/ubuntu bionic/main amd64 binutils-common am=
d64 2.29.1-12ubuntu1 [190 kB]
Get:4 http://archive.ubuntu.com/ubuntu bionic/main amd64 libbinutils amd64 =
2.29.1-12ubuntu1 [503 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic/main amd64 binutils-x86-64-li=
nux-gnu amd64 2.29.1-12ubuntu1 [1,825 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic/main amd64 binutils amd64 2.2=
9.1-12ubuntu1 [3,408 B]
Get:7 http://archive.ubuntu.com/ubuntu bionic/main amd64 dpkg-dev all 1.19.=
0.4ubuntu1 [607 kB]
Fetched 3,492 kB in 0s (30.2 MB/s)
Selecting previously unselected package libdpkg-perl.
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 57437 files and directories currently installed.)
Preparing to unpack .../0-libdpkg-perl_1.19.0.4ubuntu1_all.deb ...
Unpacking libdpkg-perl (1.19.0.4ubuntu1) ...
Selecting previously unselected package make.
Preparing to unpack .../1-make_4.1-9.1_amd64.deb ...
Unpacking make (4.1-9.1) ...
Selecting previously unselected package binutils-common:amd64.
Preparing to unpack .../2-binutils-common_2.29.1-12ubuntu1_amd64.deb ...
Unpacking binutils-common:amd64 (2.29.1-12ubuntu1) ...
Selecting previously unselected package libbinutils:amd64.
Preparing to unpack .../3-libbinutils_2.29.1-12ubuntu1_amd64.deb ...
Unpacking libbinutils:amd64 (2.29.1-12ubuntu1) ...
Selecting previously unselected package binutils-x86-64-linux-gnu.
Preparing to unpack .../4-binutils-x86-64-linux-gnu_2.29.1-12ubuntu1_amd64.=
deb ...
Unpacking binutils-x86-64-linux-gnu (2.29.1-12ubuntu1) ...
Selecting previously unselected package binutils.
Preparing to unpack .../5-binutils_2.29.1-12ubuntu1_amd64.deb ...
Unpacking binutils (2.29.1-12ubuntu1) ...
Selecting previously unselected package dpkg-dev.
Preparing to unpack .../6-dpkg-dev_1.19.0.4ubuntu1_all.deb ...
Unpacking dpkg-dev (1.19.0.4ubuntu1) ...
Setting up make (4.1-9.1) ...
Setting up libdpkg-perl (1.19.0.4ubuntu1) ...
Setting up binutils-common:amd64 (2.29.1-12ubuntu1) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
Processing triggers for man-db (2.7.6.1-4) ...
Setting up libbinutils:amd64 (2.29.1-12ubuntu1) ...
Setting up binutils-x86-64-linux-gnu (2.29.1-12ubuntu1) ...
Setting up binutils (2.29.1-12ubuntu1) ...
Setting up dpkg-dev (1.19.0.4ubuntu1) ...
Setting up autopkgtest-satdep (0) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
(Reading database ... 58021 files and directories currently installed.)
Removing autopkgtest-satdep (0) ...
dpkg-source: warning: extracting unsigned source package (/tmp/autopkgtest.=
ei92jh/multipath-tools_0.7.4-2ubuntu1.dsc)
dpkg-source: info: extracting multipath-tools in src
dpkg-source: info: unpacking multipath-tools_0.7.4.orig.tar.gz
dpkg-source: info: unpacking multipath-tools_0.7.4-2ubuntu1.debian.tar.xz
dpkg-source: info: applying 0004-Fix-lintian-complaint-about-bad-whatis-ent=
ry.patch
dpkg-source: info: applying 0001-blacklist-cciss-devices.patch
dpkg-source: info: applying 0009-hardened-build-flags.patch
dpkg-source: info: applying 0011-patch-udev-rule.patch
dpkg-source: info: applying 0014-libmultipath-discovery-blank-rev-attr.patch
dpkg-source: info: applying systemd-alias.patch
dpkg-source: info: applying disable-systemd-for-udeb.patch
dpkg-source: info: applying disable-rados-link-for-udeb-new.patch
dpkg-source: info: applying 1000--set-umask-in-multipathd.patch
dpkg-source: info: applying disable-fexceptions-udeb.patch
dpkg-source: info: applying kpartx_more_loopback_fixes.patch
dpkg-source: info: applying multipathd-crash-fix.patch
dpkg-source: info: applying fix-usrmerge-paths.patch
dpkg-source: info: applying 11-dm-mpath-fix-DM_UDEV_RULES_VSN-check.patch
autopkgtest [08:50:21]: testing package multipath-tools version 0.7.4-2ubun=
tu1
autopkgtest [08:50:21]: build not needed
autopkgtest [08:50:22]: test kpartx-file-loopback: preparing testbed
Get:1 file:/tmp/autopkgtest.ei92jh/binaries  InRelease
Ign:1 file:/tmp/autopkgtest.ei92jh/binaries  InRelease
Get:2 file:/tmp/autopkgtest.ei92jh/binaries  Release [816 B]
Get:2 file:/tmp/autopkgtest.ei92jh/binaries  Release [816 B]
Get:3 file:/tmp/autopkgtest.ei92jh/binaries  Release.gpg
Ign:3 file:/tmp/autopkgtest.ei92jh/binaries  Release.gpg
Get:4 file:/tmp/autopkgtest.ei92jh/binaries  Packages [4,627 B]
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
Correcting dependencies...Starting pkgProblemResolver with broken count: 0
Starting 2 pkgProblemResolver with broken count: 0
Done
 Done
Starting pkgProblemResolver with broken count: 0
Starting 2 pkgProblemResolver with broken count: 0
Done
The following additional packages will be installed:
  kpartx libaio1 libboost-iostreams1.65.1 libboost-random1.65.1
  libboost-regex1.65.1 libboost-system1.65.1 libboost-thread1.65.1 libibver=
bs1
  libiscsi7 libnl-3-200 libnl-route-3-200 libnspr4 libnss3 librados2 librbd1
  qemu-block-extra qemu-utils
Suggested packages:
  debootstrap
Recommended packages:
  sharutils
The following NEW packages will be installed:
  kpartx libaio1 libboost-iostreams1.65.1 libboost-random1.65.1
  libboost-regex1.65.1 libboost-system1.65.1 libboost-thread1.65.1 libibver=
bs1
  libiscsi7 libnl-3-200 libnl-route-3-200 libnspr4 libnss3 librados2 librbd1
  qemu-block-extra qemu-utils
0 upgraded, 17 newly installed, 0 to remove and 21 not upgraded.
1 not fully installed or removed.
Need to get 6,242 kB/6,289 kB of archives.
After this operation, 27.3 MB of additional disk space will be used.
Get:1 file:/tmp/autopkgtest.ei92jh/binaries  kpartx 0.7.4-2ubuntu1 [46.7 kB]
Get:2 http://archive.ubuntu.com/ubuntu bionic/main amd64 libaio1 amd64 0.3.=
110-5 [6,448 B]
Get:3 http://archive.ubuntu.com/ubuntu bionic/main amd64 libiscsi7 amd64 1.=
17.0-1.1 [55.4 kB]
Get:4 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-iostreams=
1.65.1 amd64 1.65.1+dfsg-0ubuntu4 [29.1 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-system1.6=
5.1 amd64 1.65.1+dfsg-0ubuntu4 [10.5 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-random1.6=
5.1 amd64 1.65.1+dfsg-0ubuntu4 [12.8 kB]
Get:7 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-regex1.65=
=2E1 amd64 1.65.1+dfsg-0ubuntu4 [255 kB]
Get:8 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-thread1.6=
5.1 amd64 1.65.1+dfsg-0ubuntu4 [43.2 kB]
Get:9 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnl-3-200 amd64 =
3.2.29-0ubuntu3 [52.8 kB]
Get:10 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnl-route-3-200=
 amd64 3.2.29-0ubuntu3 [146 kB]
Get:11 http://archive.ubuntu.com/ubuntu bionic/main amd64 libibverbs1 amd64=
 1.2.1-2ubuntu1 [30.8 kB]
Get:12 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnspr4 amd64 2:=
4.16-1ubuntu2 [112 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnss3 amd64 2:3=
=2E32-1ubuntu3 [1,141 kB]
Get:14 http://archive.ubuntu.com/ubuntu bionic/main amd64 librados2 amd64 1=
2.2.2-0ubuntu1 [2,550 kB]
Get:15 http://archive.ubuntu.com/ubuntu bionic/main amd64 librbd1 amd64 12.=
2.2-0ubuntu1 [917 kB]
Get:16 http://archive.ubuntu.com/ubuntu bionic/main amd64 qemu-block-extra =
amd64 1:2.10+dfsg-0ubuntu5 [40.1 kB]
Get:17 http://archive.ubuntu.com/ubuntu bionic/main amd64 qemu-utils amd64 =
1:2.10+dfsg-0ubuntu5 [841 kB]
Fetched 6,242 kB in 0s (48.6 MB/s)
Selecting previously unselected package kpartx.
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 58021 files and directories currently installed.)
Preparing to unpack .../00-kpartx.deb ...
Unpacking kpartx (0.7.4-2ubuntu1) ...
Selecting previously unselected package libaio1:amd64.
Preparing to unpack .../01-libaio1_0.3.110-5_amd64.deb ...
Unpacking libaio1:amd64 (0.3.110-5) ...
Selecting previously unselected package libiscsi7:amd64.
Preparing to unpack .../02-libiscsi7_1.17.0-1.1_amd64.deb ...
Unpacking libiscsi7:amd64 (1.17.0-1.1) ...
Selecting previously unselected package libboost-iostreams1.65.1:amd64.
Preparing to unpack .../03-libboost-iostreams1.65.1_1.65.1+dfsg-0ubuntu4_am=
d64.deb ...
Unpacking libboost-iostreams1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libboost-system1.65.1:amd64.
Preparing to unpack .../04-libboost-system1.65.1_1.65.1+dfsg-0ubuntu4_amd64=
=2Edeb ...
Unpacking libboost-system1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libboost-random1.65.1:amd64.
Preparing to unpack .../05-libboost-random1.65.1_1.65.1+dfsg-0ubuntu4_amd64=
=2Edeb ...
Unpacking libboost-random1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libboost-regex1.65.1:amd64.
Preparing to unpack .../06-libboost-regex1.65.1_1.65.1+dfsg-0ubuntu4_amd64.=
deb ...
Unpacking libboost-regex1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libboost-thread1.65.1:amd64.
Preparing to unpack .../07-libboost-thread1.65.1_1.65.1+dfsg-0ubuntu4_amd64=
=2Edeb ...
Unpacking libboost-thread1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libnl-3-200:amd64.
Preparing to unpack .../08-libnl-3-200_3.2.29-0ubuntu3_amd64.deb ...
Unpacking libnl-3-200:amd64 (3.2.29-0ubuntu3) ...
Selecting previously unselected package libnl-route-3-200:amd64.
Preparing to unpack .../09-libnl-route-3-200_3.2.29-0ubuntu3_amd64.deb ...
Unpacking libnl-route-3-200:amd64 (3.2.29-0ubuntu3) ...
Selecting previously unselected package libibverbs1.
Preparing to unpack .../10-libibverbs1_1.2.1-2ubuntu1_amd64.deb ...
Unpacking libibverbs1 (1.2.1-2ubuntu1) ...
Selecting previously unselected package libnspr4:amd64.
Preparing to unpack .../11-libnspr4_2%3a4.16-1ubuntu2_amd64.deb ...
Unpacking libnspr4:amd64 (2:4.16-1ubuntu2) ...
Selecting previously unselected package libnss3:amd64.
Preparing to unpack .../12-libnss3_2%3a3.32-1ubuntu3_amd64.deb ...
Unpacking libnss3:amd64 (2:3.32-1ubuntu3) ...
Selecting previously unselected package librados2.
Preparing to unpack .../13-librados2_12.2.2-0ubuntu1_amd64.deb ...
Unpacking librados2 (12.2.2-0ubuntu1) ...
Selecting previously unselected package librbd1.
Preparing to unpack .../14-librbd1_12.2.2-0ubuntu1_amd64.deb ...
Unpacking librbd1 (12.2.2-0ubuntu1) ...
Selecting previously unselected package qemu-block-extra:amd64.
Preparing to unpack .../15-qemu-block-extra_1%3a2.10+dfsg-0ubuntu5_amd64.de=
b ...
Unpacking qemu-block-extra:amd64 (1:2.10+dfsg-0ubuntu5) ...
Selecting previously unselected package qemu-utils.
Preparing to unpack .../16-qemu-utils_1%3a2.10+dfsg-0ubuntu5_amd64.deb ...
Unpacking qemu-utils (1:2.10+dfsg-0ubuntu5) ...
Setting up libboost-iostreams1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Setting up libiscsi7:amd64 (1.17.0-1.1) ...
Setting up libnspr4:amd64 (2:4.16-1ubuntu2) ...
Setting up libboost-system1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
Setting up libaio1:amd64 (0.3.110-5) ...
Setting up kpartx (0.7.4-2ubuntu1) ...
Setting up libboost-thread1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Processing triggers for man-db (2.7.6.1-4) ...
Setting up libnl-3-200:amd64 (3.2.29-0ubuntu3) ...
Setting up libboost-random1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Setting up libboost-regex1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Setting up libnss3:amd64 (2:3.32-1ubuntu3) ...
Setting up libnl-route-3-200:amd64 (3.2.29-0ubuntu3) ...
Setting up libibverbs1 (1.2.1-2ubuntu1) ...
Setting up librados2 (12.2.2-0ubuntu1) ...
Setting up librbd1 (12.2.2-0ubuntu1) ...
Setting up qemu-block-extra:amd64 (1:2.10+dfsg-0ubuntu5) ...
Setting up qemu-utils (1:2.10+dfsg-0ubuntu5) ...
Setting up autopkgtest-satdep (0) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
(Reading database ... 58148 files and directories currently installed.)
Removing autopkgtest-satdep (0) ...
autopkgtest [08:50:37]: test kpartx-file-loopback: [-----------------------
Formatting 'foo.img', fmt=3Draw size=3D20971520
Creating new GPT entries.
Warning: The kernel is still using the old partition table.
The new table will be used at the next reboot or after you
run partprobe(8) or kpartx(8)
The operation has completed successfully.
add map loop0p1 (253:0): 0 38879 linear 7:0 2048
standard_filename: FAIL
standard_filename_cleanup: ERROR
autopkgtest [08:50:39]: test kpartx-file-loopback: -----------------------]
autopkgtest [08:50:40]: test kpartx-file-loopback:  - - - - - - - - - - res=
ults - - - - - - - - - -
kpartx-file-loopback FAIL non-zero exit status 6
autopkgtest [08:50:40]:  - - - - - - - - - - running shell - - - - - - - - =
- -
autopkgtest [08:51:36]: test tgtbasedmpaths: preparing testbed
qemu-system-x86_64: terminating on signal 15 from pid 25453 (/usr/bin/pytho=
n3)
autopkgtest [08:51:57]: @@@@@@@@@@@@@@@@@@@@ test bed setup

WARNING: apt does not have a stable CLI interface. Use with caution in scri=
pts.

Reading package lists...
Building dependency tree...
Reading state information...
The following package was automatically installed and is no longer required:
  grub-pc-bin
Use 'apt autoremove' to remove it.
The following additional packages will be installed:
  gdbserver libbabeltrace1 libc6-dbg libcc1-0 libdw1 libelf1 libnss-systemd
  libpam-systemd libsystemd0 python3-apport systemd
Suggested packages:
  gdb-doc python3-launchpadlib systemd-container
Recommended packages:
  apport
The following packages will be REMOVED:
  apport ubuntu-server
The following NEW packages will be installed:
  gdb gdbserver libbabeltrace1 libc6-dbg libcc1-0 libdw1 systemd-coredump
The following packages will be upgraded:
  libelf1 libnss-systemd libpam-systemd libsystemd0 python3-apport systemd
6 upgraded, 7 newly installed, 2 to remove and 21 not upgraded.
Need to get 11.7 MB of archives.
After this operation, 48.5 MB of additional disk space will be used.
Get:1 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnss-systemd amd=
64 235-3ubuntu3 [97.2 kB]
Get:2 http://archive.ubuntu.com/ubuntu bionic/main amd64 libpam-systemd amd=
64 235-3ubuntu3 [100 kB]
Get:3 http://archive.ubuntu.com/ubuntu bionic/main amd64 systemd amd64 235-=
3ubuntu3 [2,834 kB]
Get:4 http://archive.ubuntu.com/ubuntu bionic/main amd64 libsystemd0 amd64 =
235-3ubuntu3 [197 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic/main amd64 libelf1 amd64 0.17=
0-0.2 [44.4 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic/main amd64 libdw1 amd64 0.170=
-0.2 [203 kB]
Get:7 http://archive.ubuntu.com/ubuntu bionic/main amd64 libbabeltrace1 amd=
64 1.5.3-4 [152 kB]
Get:8 http://archive.ubuntu.com/ubuntu bionic/main amd64 gdb amd64 8.0.1-0u=
buntu3 [2,735 kB]
Get:9 http://archive.ubuntu.com/ubuntu bionic/main amd64 gdbserver amd64 8.=
0.1-0ubuntu3 [185 kB]
Get:10 http://archive.ubuntu.com/ubuntu bionic/main amd64 libcc1-0 amd64 7.=
2.0-18ubuntu2 [38.7 kB]
Get:11 http://archive.ubuntu.com/ubuntu bionic/main amd64 python3-apport al=
l 2.20.8-0ubuntu6 [80.6 kB]
Get:12 http://archive.ubuntu.com/ubuntu bionic/universe amd64 systemd-cored=
ump amd64 235-3ubuntu3 [41.6 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic/main amd64 libc6-dbg amd64 2=
=2E26-0ubuntu2 [4,996 kB]
Fetched 11.7 MB in 0s (57.4 MB/s)
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 57061 files and directories currently installed.)
Removing ubuntu-server (1.407) ...
Removing apport (2.20.8-0ubuntu5) ...
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 56982 files and directories currently installed.)
Preparing to unpack .../libnss-systemd_235-3ubuntu3_amd64.deb ...
Unpacking libnss-systemd:amd64 (235-3ubuntu3) over (235-3ubuntu2) ...
Preparing to unpack .../libpam-systemd_235-3ubuntu3_amd64.deb ...
Unpacking libpam-systemd:amd64 (235-3ubuntu3) over (235-3ubuntu2) ...
Preparing to unpack .../systemd_235-3ubuntu3_amd64.deb ...
Unpacking systemd (235-3ubuntu3) over (235-3ubuntu2) ...
Preparing to unpack .../libsystemd0_235-3ubuntu3_amd64.deb ...
Unpacking libsystemd0:amd64 (235-3ubuntu3) over (235-3ubuntu2) ...
Setting up libsystemd0:amd64 (235-3ubuntu3) ...
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 56982 files and directories currently installed.)
Preparing to unpack .../0-libelf1_0.170-0.2_amd64.deb ...
Unpacking libelf1:amd64 (0.170-0.2) over (0.170-0.1) ...
Selecting previously unselected package libdw1:amd64.
Preparing to unpack .../1-libdw1_0.170-0.2_amd64.deb ...
Unpacking libdw1:amd64 (0.170-0.2) ...
Selecting previously unselected package libbabeltrace1:amd64.
Preparing to unpack .../2-libbabeltrace1_1.5.3-4_amd64.deb ...
Unpacking libbabeltrace1:amd64 (1.5.3-4) ...
Selecting previously unselected package gdb.
Preparing to unpack .../3-gdb_8.0.1-0ubuntu3_amd64.deb ...
Unpacking gdb (8.0.1-0ubuntu3) ...
Selecting previously unselected package gdbserver.
Preparing to unpack .../4-gdbserver_8.0.1-0ubuntu3_amd64.deb ...
Unpacking gdbserver (8.0.1-0ubuntu3) ...
Selecting previously unselected package libcc1-0:amd64.
Preparing to unpack .../5-libcc1-0_7.2.0-18ubuntu2_amd64.deb ...
Unpacking libcc1-0:amd64 (7.2.0-18ubuntu2) ...
Preparing to unpack .../6-python3-apport_2.20.8-0ubuntu6_all.deb ...
Unpacking python3-apport (2.20.8-0ubuntu6) over (2.20.8-0ubuntu5) ...
Selecting previously unselected package systemd-coredump.
Preparing to unpack .../7-systemd-coredump_235-3ubuntu3_amd64.deb ...
Unpacking systemd-coredump (235-3ubuntu3) ...
Selecting previously unselected package libc6-dbg:amd64.
Preparing to unpack .../8-libc6-dbg_2.26-0ubuntu2_amd64.deb ...
Unpacking libc6-dbg:amd64 (2.26-0ubuntu2) ...
Setting up libcc1-0:amd64 (7.2.0-18ubuntu2) ...
Setting up libc6-dbg:amd64 (2.26-0ubuntu2) ...
Processing triggers for ureadahead (0.100.0-20) ...
Setting up libelf1:amd64 (0.170-0.2) ...
Setting up python3-apport (2.20.8-0ubuntu6) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
Setting up systemd (235-3ubuntu3) ...
Created symlink /etc/systemd/system/dbus-org.freedesktop.network1.service =
=E2=86=92 /lib/systemd/system/systemd-networkd.service.
Processing triggers for man-db (2.7.6.1-4) ...
Setting up gdbserver (8.0.1-0ubuntu3) ...
Processing triggers for dbus (1.12.2-1ubuntu1) ...
Setting up libnss-systemd:amd64 (235-3ubuntu3) ...
Setting up libpam-systemd:amd64 (235-3ubuntu3) ...
Setting up libdw1:amd64 (0.170-0.2) ...
Setting up libbabeltrace1:amd64 (1.5.3-4) ...
Setting up systemd-coredump (235-3ubuntu3) ...
Setting up gdb (8.0.1-0ubuntu3) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
autopkgtest [08:52:06]: rebooting testbed after setup commands that affecte=
d boot
autopkgtest [08:52:26]: testbed dpkg architecture: amd64
Get:1 file:/tmp/autopkgtest.ei92jh/binaries  InRelease
Ign:1 file:/tmp/autopkgtest.ei92jh/binaries  InRelease
Get:2 file:/tmp/autopkgtest.ei92jh/binaries  Release [816 B]
Get:2 file:/tmp/autopkgtest.ei92jh/binaries  Release [816 B]
Get:3 file:/tmp/autopkgtest.ei92jh/binaries  Release.gpg
Ign:3 file:/tmp/autopkgtest.ei92jh/binaries  Release.gpg
Get:4 file:/tmp/autopkgtest.ei92jh/binaries  Packages [4,627 B]
Reading package lists...
Reading package lists...
Building dependency tree...
Reading state information...
Correcting dependencies...Starting pkgProblemResolver with broken count: 0
Starting 2 pkgProblemResolver with broken count: 0
Done
 Done
Starting pkgProblemResolver with broken count: 0
Starting 2 pkgProblemResolver with broken count: 0
Done
The following package was automatically installed and is no longer required:
  grub-pc-bin
Use 'apt autoremove' to remove it.
The following additional packages will be installed:
  fio kpartx libaio1 libboost-iostreams1.65.1 libboost-random1.65.1
  libboost-regex1.65.1 libboost-system1.65.1 libboost-thread1.65.1
  libconfig-general-perl libibverbs1 libnl-3-200 libnl-route-3-200 libnspr4
  libnss3 libpython-stdlib libpython2.7-minimal libpython2.7-stdlib librado=
s2
  librbd1 librdmacm1 libsgutils2-2 liburcu6 lsscsi multipath-tools python
  python-minimal python2.7 python2.7-minimal sg3-utils sg3-utils-udev tgt
Suggested packages:
  gnuplot gfio python-scipy multipath-tools-boot python-doc python-tk
  python2.7-doc binutils binfmt-support tgt-rbd
The following NEW packages will be installed:
  fio kpartx libaio1 libboost-iostreams1.65.1 libboost-random1.65.1
  libboost-regex1.65.1 libboost-system1.65.1 libboost-thread1.65.1
  libconfig-general-perl libibverbs1 libnl-3-200 libnl-route-3-200 libnspr4
  libnss3 libpython-stdlib libpython2.7-minimal libpython2.7-stdlib librado=
s2
  librbd1 librdmacm1 libsgutils2-2 liburcu6 lsscsi multipath-tools python
  python-minimal python2.7 python2.7-minimal sg3-utils sg3-utils-udev tgt
0 upgraded, 31 newly installed, 0 to remove and 21 not upgraded.
1 not fully installed or removed.
Need to get 10.9 MB/11.3 MB of archives.
After this operation, 44.8 MB of additional disk space will be used.
Get:1 file:/tmp/autopkgtest.ei92jh/binaries  kpartx 0.7.4-2ubuntu1 [46.7 kB]
Get:2 http://archive.ubuntu.com/ubuntu bionic/main amd64 libaio1 amd64 0.3.=
110-5 [6,448 B]
Get:3 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-iostreams=
1.65.1 amd64 1.65.1+dfsg-0ubuntu4 [29.1 kB]
Get:4 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-system1.6=
5.1 amd64 1.65.1+dfsg-0ubuntu4 [10.5 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-random1.6=
5.1 amd64 1.65.1+dfsg-0ubuntu4 [12.8 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-regex1.65=
=2E1 amd64 1.65.1+dfsg-0ubuntu4 [255 kB]
Get:7 file:/tmp/autopkgtest.ei92jh/binaries  multipath-tools 0.7.4-2ubuntu1=
 [275 kB]
Get:8 http://archive.ubuntu.com/ubuntu bionic/main amd64 libboost-thread1.6=
5.1 amd64 1.65.1+dfsg-0ubuntu4 [43.2 kB]
Get:9 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnl-3-200 amd64 =
3.2.29-0ubuntu3 [52.8 kB]
Get:10 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnl-route-3-200=
 amd64 3.2.29-0ubuntu3 [146 kB]
Get:11 http://archive.ubuntu.com/ubuntu bionic/main amd64 libibverbs1 amd64=
 1.2.1-2ubuntu1 [30.8 kB]
Get:12 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnspr4 amd64 2:=
4.16-1ubuntu2 [112 kB]
Get:13 http://archive.ubuntu.com/ubuntu bionic/main amd64 libnss3 amd64 2:3=
=2E32-1ubuntu3 [1,141 kB]
Get:14 http://archive.ubuntu.com/ubuntu bionic/main amd64 librados2 amd64 1=
2.2.2-0ubuntu1 [2,550 kB]
Get:15 http://archive.ubuntu.com/ubuntu bionic/main amd64 liburcu6 amd64 0.=
10.0-2 [51.7 kB]
Get:16 http://archive.ubuntu.com/ubuntu bionic/main amd64 libsgutils2-2 amd=
64 1.42-2ubuntu1 [59.3 kB]
Get:17 http://archive.ubuntu.com/ubuntu bionic/main amd64 sg3-utils amd64 1=
=2E42-2ubuntu1 [743 kB]
Get:18 http://archive.ubuntu.com/ubuntu bionic/main amd64 sg3-utils-udev al=
l 1.42-2ubuntu1 [4,864 B]
Get:19 http://archive.ubuntu.com/ubuntu bionic/main amd64 librdmacm1 amd64 =
1.1.0-2 [48.9 kB]
Get:20 http://archive.ubuntu.com/ubuntu bionic/main amd64 libconfig-general=
-perl all 2.63-1 [53.9 kB]
Get:21 http://archive.ubuntu.com/ubuntu bionic/main amd64 tgt amd64 1:1.0.7=
2-1ubuntu1 [214 kB]
Get:22 http://archive.ubuntu.com/ubuntu bionic/main amd64 librbd1 amd64 12.=
2.2-0ubuntu1 [917 kB]
Get:23 http://archive.ubuntu.com/ubuntu bionic/main amd64 libpython2.7-mini=
mal amd64 2.7.14-4 [337 kB]
Get:24 http://archive.ubuntu.com/ubuntu bionic/main amd64 python2.7-minimal=
 amd64 2.7.14-4 [1,293 kB]
Get:25 http://archive.ubuntu.com/ubuntu bionic/main amd64 python-minimal am=
d64 2.7.14-2ubuntu1 [28.1 kB]
Get:26 http://archive.ubuntu.com/ubuntu bionic/main amd64 libpython2.7-stdl=
ib amd64 2.7.14-4 [1,910 kB]
Get:27 http://archive.ubuntu.com/ubuntu bionic/main amd64 python2.7 amd64 2=
=2E7.14-4 [233 kB]
Get:28 http://archive.ubuntu.com/ubuntu bionic/main amd64 libpython-stdlib =
amd64 2.7.14-2ubuntu1 [7,576 B]
Get:29 http://archive.ubuntu.com/ubuntu bionic/main amd64 python amd64 2.7.=
14-2ubuntu1 [140 kB]
Get:30 http://archive.ubuntu.com/ubuntu bionic/universe amd64 fio amd64 3.1=
-1 [467 kB]
Get:31 http://archive.ubuntu.com/ubuntu bionic/main amd64 lsscsi amd64 0.28=
-0.1 [35.5 kB]
Fetched 10.9 MB in 0s (50.4 MB/s)
Selecting previously unselected package libaio1:amd64.
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 57437 files and directories currently installed.)
Preparing to unpack .../00-libaio1_0.3.110-5_amd64.deb ...
Unpacking libaio1:amd64 (0.3.110-5) ...
Selecting previously unselected package libboost-iostreams1.65.1:amd64.
Preparing to unpack .../01-libboost-iostreams1.65.1_1.65.1+dfsg-0ubuntu4_am=
d64.deb ...
Unpacking libboost-iostreams1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libboost-system1.65.1:amd64.
Preparing to unpack .../02-libboost-system1.65.1_1.65.1+dfsg-0ubuntu4_amd64=
=2Edeb ...
Unpacking libboost-system1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libboost-random1.65.1:amd64.
Preparing to unpack .../03-libboost-random1.65.1_1.65.1+dfsg-0ubuntu4_amd64=
=2Edeb ...
Unpacking libboost-random1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libboost-regex1.65.1:amd64.
Preparing to unpack .../04-libboost-regex1.65.1_1.65.1+dfsg-0ubuntu4_amd64.=
deb ...
Unpacking libboost-regex1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libboost-thread1.65.1:amd64.
Preparing to unpack .../05-libboost-thread1.65.1_1.65.1+dfsg-0ubuntu4_amd64=
=2Edeb ...
Unpacking libboost-thread1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Selecting previously unselected package libnl-3-200:amd64.
Preparing to unpack .../06-libnl-3-200_3.2.29-0ubuntu3_amd64.deb ...
Unpacking libnl-3-200:amd64 (3.2.29-0ubuntu3) ...
Selecting previously unselected package libnl-route-3-200:amd64.
Preparing to unpack .../07-libnl-route-3-200_3.2.29-0ubuntu3_amd64.deb ...
Unpacking libnl-route-3-200:amd64 (3.2.29-0ubuntu3) ...
Selecting previously unselected package libibverbs1.
Preparing to unpack .../08-libibverbs1_1.2.1-2ubuntu1_amd64.deb ...
Unpacking libibverbs1 (1.2.1-2ubuntu1) ...
Selecting previously unselected package libnspr4:amd64.
Preparing to unpack .../09-libnspr4_2%3a4.16-1ubuntu2_amd64.deb ...
Unpacking libnspr4:amd64 (2:4.16-1ubuntu2) ...
Selecting previously unselected package libnss3:amd64.
Preparing to unpack .../10-libnss3_2%3a3.32-1ubuntu3_amd64.deb ...
Unpacking libnss3:amd64 (2:3.32-1ubuntu3) ...
Selecting previously unselected package librados2.
Preparing to unpack .../11-librados2_12.2.2-0ubuntu1_amd64.deb ...
Unpacking librados2 (12.2.2-0ubuntu1) ...
Selecting previously unselected package liburcu6:amd64.
Preparing to unpack .../12-liburcu6_0.10.0-2_amd64.deb ...
Unpacking liburcu6:amd64 (0.10.0-2) ...
Selecting previously unselected package kpartx.
Preparing to unpack .../13-kpartx.deb ...
Unpacking kpartx (0.7.4-2ubuntu1) ...
Selecting previously unselected package libsgutils2-2.
Preparing to unpack .../14-libsgutils2-2_1.42-2ubuntu1_amd64.deb ...
Unpacking libsgutils2-2 (1.42-2ubuntu1) ...
Selecting previously unselected package sg3-utils.
Preparing to unpack .../15-sg3-utils_1.42-2ubuntu1_amd64.deb ...
Unpacking sg3-utils (1.42-2ubuntu1) ...
Selecting previously unselected package sg3-utils-udev.
Preparing to unpack .../16-sg3-utils-udev_1.42-2ubuntu1_all.deb ...
Unpacking sg3-utils-udev (1.42-2ubuntu1) ...
Selecting previously unselected package multipath-tools.
Preparing to unpack .../17-multipath-tools.deb ...
insmod /lib/modules/4.13.0-17-generic/kernel/drivers/md/dm-multipath.ko=20
Unpacking multipath-tools (0.7.4-2ubuntu1) ...
Selecting previously unselected package librdmacm1.
Preparing to unpack .../18-librdmacm1_1.1.0-2_amd64.deb ...
Unpacking librdmacm1 (1.1.0-2) ...
Selecting previously unselected package libconfig-general-perl.
Preparing to unpack .../19-libconfig-general-perl_2.63-1_all.deb ...
Unpacking libconfig-general-perl (2.63-1) ...
Selecting previously unselected package tgt.
Preparing to unpack .../20-tgt_1%3a1.0.72-1ubuntu1_amd64.deb ...
Unpacking tgt (1:1.0.72-1ubuntu1) ...
Selecting previously unselected package librbd1.
Preparing to unpack .../21-librbd1_12.2.2-0ubuntu1_amd64.deb ...
Unpacking librbd1 (12.2.2-0ubuntu1) ...
Selecting previously unselected package libpython2.7-minimal:amd64.
Preparing to unpack .../22-libpython2.7-minimal_2.7.14-4_amd64.deb ...
Unpacking libpython2.7-minimal:amd64 (2.7.14-4) ...
Selecting previously unselected package python2.7-minimal.
Preparing to unpack .../23-python2.7-minimal_2.7.14-4_amd64.deb ...
Unpacking python2.7-minimal (2.7.14-4) ...
Selecting previously unselected package python-minimal.
Preparing to unpack .../24-python-minimal_2.7.14-2ubuntu1_amd64.deb ...
Unpacking python-minimal (2.7.14-2ubuntu1) ...
Selecting previously unselected package libpython2.7-stdlib:amd64.
Preparing to unpack .../25-libpython2.7-stdlib_2.7.14-4_amd64.deb ...
Unpacking libpython2.7-stdlib:amd64 (2.7.14-4) ...
Selecting previously unselected package python2.7.
Preparing to unpack .../26-python2.7_2.7.14-4_amd64.deb ...
Unpacking python2.7 (2.7.14-4) ...
Selecting previously unselected package libpython-stdlib:amd64.
Preparing to unpack .../27-libpython-stdlib_2.7.14-2ubuntu1_amd64.deb ...
Unpacking libpython-stdlib:amd64 (2.7.14-2ubuntu1) ...
Setting up libpython2.7-minimal:amd64 (2.7.14-4) ...
Setting up python2.7-minimal (2.7.14-4) ...
Setting up python-minimal (2.7.14-2ubuntu1) ...
Selecting previously unselected package python.
(Reading database ... =0D(Reading database ... 5%=0D(Reading database ... 1=
0%=0D(Reading database ... 15%=0D(Reading database ... 20%=0D(Reading datab=
ase ... 25%=0D(Reading database ... 30%=0D(Reading database ... 35%=0D(Read=
ing database ... 40%=0D(Reading database ... 45%=0D(Reading database ... 50=
%=0D(Reading database ... 55%=0D(Reading database ... 60%=0D(Reading databa=
se ... 65%=0D(Reading database ... 70%=0D(Reading database ... 75%=0D(Readi=
ng database ... 80%=0D(Reading database ... 85%=0D(Reading database ... 90%=
=0D(Reading database ... 95%=0D(Reading database ... 100%=0D(Reading databa=
se ... 58668 files and directories currently installed.)
Preparing to unpack .../python_2.7.14-2ubuntu1_amd64.deb ...
Unpacking python (2.7.14-2ubuntu1) ...
Selecting previously unselected package fio.
Preparing to unpack .../archives/fio_3.1-1_amd64.deb ...
Unpacking fio (3.1-1) ...
Selecting previously unselected package lsscsi.
Preparing to unpack .../lsscsi_0.28-0.1_amd64.deb ...
Unpacking lsscsi (0.28-0.1) ...
Setting up libboost-iostreams1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Processing triggers for mime-support (3.60ubuntu1) ...
Processing triggers for ureadahead (0.100.0-20) ...
Setting up lsscsi (0.28-0.1) ...
Setting up liburcu6:amd64 (0.10.0-2) ...
Setting up libnspr4:amd64 (2:4.16-1ubuntu2) ...
Setting up libboost-system1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Setting up libsgutils2-2 (1.42-2ubuntu1) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
Setting up libaio1:amd64 (0.3.110-5) ...
Setting up kpartx (0.7.4-2ubuntu1) ...
Setting up libboost-thread1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Processing triggers for systemd (235-3ubuntu3) ...
Processing triggers for man-db (2.7.6.1-4) ...
Setting up sg3-utils (1.42-2ubuntu1) ...
Setting up libnl-3-200:amd64 (3.2.29-0ubuntu3) ...
Setting up sg3-utils-udev (1.42-2ubuntu1) ...
update-initramfs: deferring update (trigger activated)
Setting up libboost-random1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Setting up libpython2.7-stdlib:amd64 (2.7.14-4) ...
Setting up libconfig-general-perl (2.63-1) ...
Setting up libboost-regex1.65.1:amd64 (1.65.1+dfsg-0ubuntu4) ...
Setting up python2.7 (2.7.14-4) ...
Setting up libnss3:amd64 (2:3.32-1ubuntu3) ...
Setting up libnl-route-3-200:amd64 (3.2.29-0ubuntu3) ...
Setting up libpython-stdlib:amd64 (2.7.14-2ubuntu1) ...
Setting up python (2.7.14-2ubuntu1) ...
Setting up libibverbs1 (1.2.1-2ubuntu1) ...
Setting up librdmacm1 (1.1.0-2) ...
Setting up librados2 (12.2.2-0ubuntu1) ...
Setting up multipath-tools (0.7.4-2ubuntu1) ...
Created symlink /etc/systemd/system/multipath-tools.service =E2=86=92 /lib/=
systemd/system/multipathd.service.
Created symlink /etc/systemd/system/sysinit.target.wants/multipathd.service=
 =E2=86=92 /lib/systemd/system/multipathd.service.
multipathd.socket is a disabled or a static unit, not starting it.
Setting up tgt (1:1.0.72-1ubuntu1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/tgt.service =E2=
=86=92 /lib/systemd/system/tgt.service.
Setting up librbd1 (12.2.2-0ubuntu1) ...
Setting up fio (3.1-1) ...
Setting up autopkgtest-satdep (0) ...
Processing triggers for libc-bin (2.26-0ubuntu2) ...
Processing triggers for initramfs-tools (0.125ubuntu13) ...
update-initramfs: Generating /boot/initrd.img-4.13.0-17-generic
WARNING: Setting CRYPTSETUP in /etc/initramfs-tools/initramfs.conf is depre=
cated and will stop working in the future. Use /etc/cryptsetup-initramfs/co=
nf-hook instead.
Processing triggers for systemd (235-3ubuntu3) ...
Processing triggers for ureadahead (0.100.0-20) ...
(Reading database ... 58802 files and directories currently installed.)
Removing autopkgtest-satdep (0) ...
autopkgtest [08:52:56]: test tgtbasedmpaths: [-----------------------
+ targetname=3Diqn.2016-11.foo.com:target.iscsi
+ pwd
+ cwd=3D/tmp/autopkgtest.ei92jh/build.HoZ/src
+ testdir=3D/mnt/tgtmpathtest
+ localhost=3D127.0.0.1
+ portal=3D127.0.0.1:3260
+ maxpaths=3D4
+ backfn=3Dbackingfile
+ expectwwid=3D360000000000000000e00000000010001
+ testdisk=3D/dev/disk/by-id/scsi-360000000000000000e00000000010001
+ bglog=3D/tmp/autopkgtest.ei92jh/tgtbasedmpaths-artifacts/test-background.=
log
+ fioprep=3D/tmp/autopkgtest.ei92jh/tgtbasedmpaths-artifacts/path-change-pr=
ep.fio
+ fiovrfy=3D/tmp/autopkgtest.ei92jh/tgtbasedmpaths-artifacts/path-change-ch=
eck.fio
+ service tgt restart
+ truncate --size 100M backingfile
+ tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2016-11.foo.com:=
target.iscsi
+ tgtadm --lld iscsi --op bind --mode target --tid 1 -I ALL
+ tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b /tmp/au=
topkgtest.ei92jh/build.HoZ/src/backingfile
+ iscsiadm --mode discovery --type sendtargets --portal 127.0.0.1
127.0.0.1:3260,1 iqn.2016-11.foo.com:target.iscsi
login #1
+ echo login #1
+ iscsiadm --mode node --targetname iqn.2016-11.foo.com:target.iscsi --port=
al 127.0.0.1:3260 --login
+ seq 2 4
+ echo extra login #2
+ iscsiadm --mode session -r 1 --op new
Logging in to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, po=
rtal: 127.0.0.1,3260] (multiple)
Login to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal:=
 127.0.0.1,3260] successful.
extra login #2
+ echo extra login #3
+ iscsiadm --mode session -r 1 --op new
Logging in to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, po=
rtal: 127.0.0.1,3260] (multiple)
Login to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal:=
 127.0.0.1,3260] successful.
extra login #3
Logging in to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, po=
rtal: 127.0.0.1,3260] (multiple)
Login to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal:=
 127.0.0.1,3260] successful.
extra login #4
+ echo extra login #4
+ iscsiadm --mode session -r 1 --op new
Logging in to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, po=
rtal: 127.0.0.1,3260] (multiple)
Login to [iface: default, target: iqn.2016-11.foo.com:target.iscsi, portal:=
 127.0.0.1,3260] successful.
+ udevadm settle
Status after initial setup
Target 1: iqn.2016-11.foo.com:target.iscsi
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
        I_T nexus: 1
            Initiator: iqn.1993-08.org.debian:01:54a3714cca34 alias: autopk=
gtest
            Connection: 0
                IP Address: 127.0.0.1
        I_T nexus: 2
            Initiator: iqn.1993-08.org.debian:01:54a3714cca34 alias: autopk=
gtest
            Connection: 0
                IP Address: 127.0.0.1
        I_T nexus: 3
            Initiator: iqn.1993-08.org.debian:01:54a3714cca34 alias: autopk=
gtest
            Connection: 0
                IP Address: 127.0.0.1
        I_T nexus: 4
            Initiator: iqn.1993-08.org.debian:01:54a3714cca34 alias: autopk=
gtest
            Connection: 0
                IP Address: 127.0.0.1
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB, Block size: 1
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: null
            Backing store path: None
            Backing store flags:=20
        LUN: 1
            Type: disk
            SCSI ID: IET     00010001
            SCSI SN: beaf11
            Size: 105 MB, Block size: 512
            Online: Yes
            Removable media: No
            Prevent removal: No
            Readonly: No
            SWP: No
            Thin-provisioning: No
            Backing store type: rdwr
            Backing store path: /tmp/autopkgtest.ei92jh/build.HoZ/src/backi=
ngfile
            Backing store flags:=20
    Account information:
    ACL information:
        ALL
Session: 4
    Connection: 0
        Initiator: iqn.1993-08.org.debian:01:54a3714cca34
        IP Address: 127.0.0.1
Session: 3
    Connection: 0
        Initiator: iqn.1993-08.org.debian:01:54a3714cca34
        IP Address: 127.0.0.1
Session: 2
    Connection: 0
        Initiator: iqn.1993-08.org.debian:01:54a3714cca34
        IP Address: 127.0.0.1
Session: 1
    Connection: 0
        Initiator: iqn.1993-08.org.debian:01:54a3714cca34
        IP Address: 127.0.0.1
Target: iqn.2016-11.foo.com:target.iscsi (non-flash)
	Current Portal: 127.0.0.1:3260,1
	Persistent Portal: 127.0.0.1:3260,1
		**********
		Interface:
		**********
		Iface Name: default
		Iface Transport: tcp
		Iface Initiatorname: iqn.1993-08.org.debian:01:54a3714cca34
		Iface IPaddress: 127.0.0.1
		Iface HWaddress: <empty>
		Iface Netdev: <empty>
		SID: 1
		iSCSI Connection State: LOGGED IN
		iSCSI Session State: LOGGED_IN
		Internal iscsid Session State: NO CHANGE

		**********
		Interface:
		**********
		Iface Name: default
		Iface Transport: tcp
		Iface Initiatorname: iqn.1993-08.org.debian:01:54a3714cca34
		Iface IPaddress: 127.0.0.1
		Iface HWaddress: <empty>
		Iface Netdev: <empty>
		SID: 4
		iSCSI Connection State: LOGGED IN
		iSCSI Session State: LOGGED_IN
		Internal iscsid Session State: NO CHANGE

		**********
		Interface:
		**********
		Iface Name: default
		Iface Transport: tcp
		Iface Initiatorname: iqn.1993-08.org.debian:01:54a3714cca34
		Iface IPaddress: 127.0.0.1
		Iface HWaddress: <empty>
		Iface Netdev: <empty>
		SID: 3
		iSCSI Connection State: LOGGED IN
		iSCSI Session State: LOGGED_IN
		Internal iscsid Session State: NO CHANGE

		**********
		Interface:
		**********
		Iface Name: default
		Iface Transport: tcp
		Iface Initiatorname: iqn.1993-08.org.debian:01:54a3714cca34
		Iface IPaddress: 127.0.0.1
		Iface HWaddress: <empty>
		Iface Netdev: <empty>
		SID: 2
		iSCSI Connection State: LOGGED IN
		iSCSI Session State: LOGGED_IN
		Internal iscsid Session State: NO CHANGE
[1:0:0:0]    cd/dvd  QEMU     QEMU DVD-ROM     2.5+  /dev/sr0   -
  state=3Drunning queue_depth=3D1 scsi_level=3D6 type=3D5 device_blocked=3D=
0 timeout=3D30
  dir: /sys/bus/scsi/devices/1:0:0:0  [/sys/devices/pci0000:00/0000:00:01.1=
/ata2/host1/target1:0:0/1:0:0:0]
[2:0:0:0]    storage IET      Controller       0001  -          -
  state=3Drunning queue_depth=3D32 scsi_level=3D6 type=3D12 device_blocked=
=3D0 timeout=3D0
  dir: /sys/bus/scsi/devices/2:0:0:0  [/sys/devices/platform/host2/session1=
/target2:0:0/2:0:0:0]
[2:0:0:1]    disk    IET      VIRTUAL-DISK     0001  /dev/sda   36000000000=
0000000e00000000010001
  state=3Drunning queue_depth=3D32 scsi_level=3D6 type=3D0 device_blocked=
=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/2:0:0:1  [/sys/devices/platform/host2/session1=
/target2:0:0/2:0:0:1]
[3:0:0:0]    storage IET      Controller       0001  -          -
  state=3Drunning queue_depth=3D32 scsi_level=3D6 type=3D12 device_blocked=
=3D0 timeout=3D0
  dir: /sys/bus/scsi/devices/3:0:0:0  [/sys/devices/platform/host3/session2=
/target3:0:0/3:0:0:0]
[3:0:0:1]    disk    IET      VIRTUAL-DISK     0001  /dev/sdb   -
  state=3Drunning queue_depth=3D32 scsi_level=3D6 type=3D0 device_blocked=
=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/3:0:0:1  [/sys/devices/platform/host3/session2=
/target3:0:0/3:0:0:1]
[4:0:0:0]    storage IET      Controller       0001  -          -
  state=3Drunning queue_depth=3D32 scsi_level=3D6 type=3D12 device_blocked=
=3D0 timeout=3D0
  dir: /sys/bus/scsi/devices/4:0:0:0  [/sys/devices/platform/host4/session3=
/target4:0:0/4:0:0:0]
[4:0:0:1]    disk    IET      VIRTUAL-DISK     0001  /dev/sdc   -
  state=3Drunning queue_depth=3D32 scsi_level=3D6 type=3D0 device_blocked=
=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/4:0:0:1  [/sys/devices/platform/host4/session3=
/target4:0:0/4:0:0:1]
[5:0:0:0]    storage IET      Controller       0001  -          -
  state=3Drunning queue_depth=3D32 scsi_level=3D6 type=3D12 device_blocked=
=3D0 timeout=3D0
  dir: /sys/bus/scsi/devices/5:0:0:0  [/sys/devices/platform/host5/session4=
/target5:0:0/5:0:0:0]
[5:0:0:1]    disk    IET      VIRTUAL-DISK     0001  /dev/sdd   SIET_VIRTUA=
L-DISK_beaf11
  state=3Drunning queue_depth=3D32 scsi_level=3D6 type=3D0 device_blocked=
=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/5:0:0:1  [/sys/devices/platform/host5/session4=
/target5:0:0/5:0:0:1]
+ echo Status after initial setup
+ tgtadm --lld iscsi --mode target --op show
+ tgtadm --lld iscsi --op show --mode conn --tid 1
+ iscsiadm --mode session -P 1
+ lsscsi -liv
+ multipath -v3 -ll
Jan 12 08:52:57 | loading //lib/multipath/libchecktur.so checker
Jan 12 08:52:57 | loading //lib/multipath/libprioconst.so prioritizer
Jan 12 08:52:57 | sr0: blacklisted, udev property missing
Jan 12 08:52:57 | vda: blacklisted, udev property missing
Jan 12 08:52:57 | vdb: blacklisted, udev property missing
Jan 12 08:52:57 | fd0: blacklisted, udev property missing
Jan 12 08:52:57 | sda: udev property ID_WWN whitelisted
Jan 12 08:52:57 | sda: mask =3D 0x7
Jan 12 08:52:57 | sda: dev_t =3D 8:0
Jan 12 08:52:57 | sda: size =3D 204800
Jan 12 08:52:57 | sda: vendor =3D IET
Jan 12 08:52:57 | sda: product =3D VIRTUAL-DISK
Jan 12 08:52:57 | sda: rev =3D 0001
Jan 12 08:52:57 | sda: h:b:t:l =3D 2:0:0:1
Jan 12 08:52:57 | sda: tgt_node_name =3D iqn.2016-11.foo.com:target.iscsi
Jan 12 08:52:57 | sda: path state =3D running
Jan 12 08:52:57 | sda: 1024 cyl, 4 heads, 50 sectors/track, start at 0
Jan 12 08:52:57 | sda: serial =3D                               beaf11
Jan 12 08:52:57 | sda: get_state
Jan 12 08:52:57 | sda: detect_checker =3D yes (setting: multipath internal)
Jan 12 08:52:57 | failed to issue vpd inquiry for pgc9
Jan 12 08:52:57 | sda: path_checker =3D tur (setting: multipath internal)
Jan 12 08:52:57 | sda: checker timeout =3D 30 s (setting: multipath interna=
l)
Jan 12 08:52:57 | sda: tur state =3D up
Jan 12 08:52:57 | sdb: udev property ID_WWN whitelisted
Jan 12 08:52:57 | sdb: mask =3D 0x7
Jan 12 08:52:57 | sdb: dev_t =3D 8:16
Jan 12 08:52:57 | sdb: size =3D 204800
Jan 12 08:52:57 | sdb: vendor =3D IET
Jan 12 08:52:57 | sdb: product =3D VIRTUAL-DISK
Jan 12 08:52:57 | sdb: rev =3D 0001
Jan 12 08:52:57 | sdb: h:b:t:l =3D 3:0:0:1
Jan 12 08:52:57 | sdb: tgt_node_name =3D iqn.2016-11.foo.com:target.iscsi
Jan 12 08:52:57 | sdb: path state =3D running
Jan 12 08:52:57 | sdb: 1024 cyl, 4 heads, 50 sectors/track, start at 0
Jan 12 08:52:57 | sdb: serial =3D                               beaf11
Jan 12 08:52:57 | sdb: get_state
Jan 12 08:52:57 | sdb: detect_checker =3D yes (setting: multipath internal)
Jan 12 08:52:57 | failed to issue vpd inquiry for pgc9
Jan 12 08:52:57 | sdb: path_checker =3D tur (setting: multipath internal)
Jan 12 08:52:57 | sdb: checker timeout =3D 30 s (setting: multipath interna=
l)
Jan 12 08:52:57 | sdb: tur state =3D up
Jan 12 08:52:57 | sdc: udev property ID_WWN whitelisted
Jan 12 08:52:57 | sdc: mask =3D 0x7
Jan 12 08:52:57 | sdc: dev_t =3D 8:32
Jan 12 08:52:57 | sdc: size =3D 204800
Jan 12 08:52:57 | sdc: vendor =3D IET
Jan 12 08:52:57 | sdc: product =3D VIRTUAL-DISK
Jan 12 08:52:57 | sdc: rev =3D 0001
Jan 12 08:52:57 | sdc: h:b:t:l =3D 4:0:0:1
Jan 12 08:52:57 | sdc: tgt_node_name =3D iqn.2016-11.foo.com:target.iscsi
Jan 12 08:52:57 | sdc: path state =3D running
Jan 12 08:52:57 | sdc: 1024 cyl, 4 heads, 50 sectors/track, start at 0
Jan 12 08:52:57 | sdc: serial =3D                               beaf11
Jan 12 08:52:57 | sdc: get_state
Jan 12 08:52:57 | sdc: detect_checker =3D yes (setting: multipath internal)
Jan 12 08:52:57 | failed to issue vpd inquiry for pgc9
Jan 12 08:52:57 | sdc: path_checker =3D tur (setting: multipath internal)
Jan 12 08:52:57 | sdc: checker timeout =3D 30 s (setting: multipath interna=
l)
Jan 12 08:52:57 | sdc: tur state =3D up
Jan 12 08:52:57 | sdd: udev property ID_WWN whitelisted
Jan 12 08:52:57 | sdd: mask =3D 0x7
Jan 12 08:52:57 | sdd: dev_t =3D 8:48
Jan 12 08:52:57 | sdd: size =3D 204800
Jan 12 08:52:57 | sdd: vendor =3D IET
Jan 12 08:52:57 | sdd: product =3D VIRTUAL-DISK
Jan 12 08:52:57 | sdd: rev =3D 0001
Jan 12 08:52:57 | sdd: h:b:t:l =3D 5:0:0:1
Jan 12 08:52:57 | sdd: tgt_node_name =3D iqn.2016-11.foo.com:target.iscsi
Jan 12 08:52:57 | sdd: path state =3D running
Jan 12 08:52:57 | sdd: 1024 cyl, 4 heads, 50 sectors/track, start at 0
Jan 12 08:52:57 | sdd: serial =3D                               beaf11
Jan 12 08:52:57 | sdd: get_state
Jan 12 08:52:57 | sdd: detect_checker =3D yes (setting: multipath internal)
Jan 12 08:52:57 | failed to issue vpd inquiry for pgc9
Jan 12 08:52:57 | sdd: path_checker =3D tur (setting: multipath internal)
Jan 12 08:52:57 | sdd: checker timeout =3D 30 s (setting: multipath interna=
l)
Jan 12 08:52:57 | sdd: tur state =3D up
Jan 12 08:52:57 | loop0: blacklisted, udev property missing
Jan 12 08:52:57 | loop1: blacklisted, udev property missing
Jan 12 08:52:57 | loop2: blacklisted, udev property missing
Jan 12 08:52:57 | loop3: blacklisted, udev property missing
Jan 12 08:52:57 | loop4: blacklisted, udev property missing
Jan 12 08:52:57 | loop5: blacklisted, udev property missing
Jan 12 08:52:57 | loop6: blacklisted, udev property missing
Jan 12 08:52:57 | loop7: blacklisted, udev property missing
Jan 12 08:52:57 | dm-0: blacklisted, udev property missing
=3D=3D=3D=3D=3D paths list =3D=3D=3D=3D=3D
uuid hcil    dev dev_t pri dm_st chk_st vend/prod/rev    dev_st=20
     2:0:0:1 sda 8:0   -1  undef undef  IET,VIRTUAL-DISK unknown
     3:0:0:1 sdb 8:16  -1  undef undef  IET,VIRTUAL-DISK unknown
     4:0:0:1 sdc 8:32  -1  undef undef  IET,VIRTUAL-DISK unknown
     5:0:0:1 sdd 8:48  -1  undef undef  IET,VIRTUAL-DISK unknown
Jan 12 08:52:57 | libdevmapper version 1.02.137 (2016-11-30)
Jan 12 08:52:57 | DM multipath kernel driver v1.12.0
Jan 12 08:52:57 | params =3D 0 0 1 1 service-time 0 1 2 8:0 1 1=20
Jan 12 08:52:57 | status =3D 2 0 0 0 1 1 A 0 1 2 8:0 A 0 0 1=20
Jan 12 08:52:57 | 360000000000000000e00000000010001: disassemble map [0 0 1=
 1 service-time 0 1 2 8:0 1 1 ]
Jan 12 08:52:57 | sda: udev property ID_WWN whitelisted
Jan 12 08:52:57 | sda: mask =3D 0x8
Jan 12 08:52:57 | sda: path state =3D running
Jan 12 08:52:57 | sda: detect_prio =3D yes (setting: multipath internal)
Jan 12 08:52:57 | sda: prio =3D const (setting: multipath internal)
Jan 12 08:52:57 | sda: prio args =3D "" (setting: multipath internal)
Jan 12 08:52:57 | sda: const prio =3D 1
Jan 12 08:52:57 | 360000000000000000e00000000010001: disassemble status [2 =
0 0 0 1 1 A 0 1 2 8:0 A 0 0 1 ]
360000000000000000e00000000010001 dm-0 IET,VIRTUAL-DISK
size=3D100M features=3D'0' hwhandler=3D'0' wp=3Drw
`-+- policy=3D'service-time 0' prio=3D1 status=3Dactive
  `- 2:0:0:1 sda 8:0  active ready running
Jan 12 08:52:57 | tur checker refcount 4
Jan 12 08:52:57 | const prioritizer refcount 1
Jan 12 08:52:57 | tur checker refcount 3
Jan 12 08:52:57 | tur checker refcount 2
Jan 12 08:52:57 | tur checker refcount 1
Jan 12 08:52:57 | unloading const prioritizer
Jan 12 08:52:57 | unloading tur checker
360000000000000000e00000000010001: 0 204800 multipath 0 0 1 1 service-time =
0 1 2 8:0 1 1=20
Test WWN should now point to DM
=2E./../dm-0
Creating filesystem with 102400 1k blocks and 25688 inodes
Filesystem UUID: fde6596d-e098-4bae-8dae-d7fb3094ea05
Superblock backups stored on blocks:=20
	8193, 24577, 40961, 57345, 73729

Allocating group tables:  0/13=08=08=08=08=08     =08=08=08=08=08done      =
                     =20
Writing inode tables:  0/13=08=08=08=08=08     =08=08=08=08=08done         =
                  =20
+ dmsetup table
+ echo Test WWN should now point to DM
+ grep dm
+ readlink /dev/disk/by-id/scsi-360000000000000000e00000000010001
+ mkfs.ext4 -F /dev/disk/by-id/scsi-360000000000000000e00000000010001
mke2fs 1.43.7 (16-Oct-2017)
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information:  0/13=08=08=08=
=08=08     =08=08=08=08=08done

+ udevadm settle
+ sleep 3s
+ mkdir -p /mnt/tgtmpathtest
+ mount /dev/disk/by-id/scsi-360000000000000000e00000000010001 /mnt/tgtmpat=
htest
+ cat
+ cat
+ fio /tmp/autopkgtest.ei92jh/tgtbasedmpaths-artifacts/path-change-prep.fio
write-phase: (g=3D0): rw=3Dwrite, bs=3D(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.=
0KiB, (T) 64.0KiB-64.0KiB, ioengine=3Dsync, iodepth=3D1
fio-3.1
Starting 1 thread
write-phase: Laying out IO file (1 file / 17592186044415MiB)
fio: io_u error on file /mnt/tgtmpathtest/datafile.tmp: No space left on de=
vice: write offset=3D93585408, buflen=3D65536

write-phase: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6780: Fri Jan 12 08:5=
3:01 2018
  write: IOPS=3D5049, BW=3D315MiB/s (331MB/s)(89.2MiB/283msec)
    clat (usec): min=3D143, max=3D4878, avg=3D194.58, stdev=3D232.11
     lat (usec): min=3D143, max=3D4878, avg=3D194.92, stdev=3D232.14
    clat percentiles (usec):
     |  1.00th=3D[  149],  5.00th=3D[  149], 10.00th=3D[  149], 20.00th=3D[=
  151],
     | 30.00th=3D[  151], 40.00th=3D[  153], 50.00th=3D[  153], 60.00th=3D[=
  159],
     | 70.00th=3D[  165], 80.00th=3D[  180], 90.00th=3D[  221], 95.00th=3D[=
  310],
     | 99.00th=3D[  799], 99.50th=3D[ 1045], 99.90th=3D[ 4047], 99.95th=3D[=
 4883],
     | 99.99th=3D[ 4883]
  lat (usec)   : 250=3D91.46%, 500=3D6.23%, 750=3D1.12%, 1000=3D0.49%
  lat (msec)   : 2=3D0.28%, 4=3D0.21%, 10=3D0.14%
  cpu          : usr=3D3.90%, sys=3D9.22%, ctx=3D1436, majf=3D0, minf=3D1
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwt: total=3D0,1429,0, short=3D0,0,0, dropped=3D0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
  WRITE: bw=3D315MiB/s (331MB/s), 315MiB/s-315MiB/s (331MB/s-331MB/s), io=
=3D89.2MiB (93.6MB), run=3D283-283msec

Disk stats (read/write):
    dm-0: ios=3D2/688, merge=3D0/0, ticks=3D0/136, in_queue=3D136, util=3D5=
5.97%, aggrios=3D0/358, aggrmerge=3D0/0, aggrticks=3D0/59, aggrin_queue=3D5=
9, aggrutil=3D58.85%
  sdd: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00%
  sdb: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00%
  sdc: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00%
  sda: ios=3D3/1432, merge=3D0/0, ticks=3D0/236, in_queue=3D236, util=3D58.=
85%
+ echo Starting the path changes in background
+ date +Pre FIO %H:%M:%S.%N
+ fio /tmp/autopkgtest.ei92jh/tgtbasedmpaths-artifacts/path-change-check.fio
Starting the path changes in background
Pre FIO 08:53:01.239699087
verify-phase: (g=3D0): rw=3Dread, bs=3D(R) 64.0KiB-64.0KiB, (W) 64.0KiB-64.=
0KiB, (T) 64.0KiB-64.0KiB, ioengine=3Dsync, iodepth=3D1
fio-3.1
Starting 1 thread
fio: pid=3D6787, err=3D5/file:io_u.c:1756, func=3Dio_u error, error=3DInput=
/output error
fio: io_u error on file /mnt/tgtmpathtest/datafile.tmp: Input/output error:=
 read offset=3D36438016, buflen=3D65536

verify-phase: (groupid=3D0, jobs=3D1): err=3D 5 (file:io_u.c:1756, func=3Di=
o_u error, error=3DInput/output error): pid=3D6787: Fri Jan 12 08:53:51 2018
   read: IOPS=3D10.9k, BW=3D681MiB/s (714MB/s)(33.3GiB/50095msec)
    clat (usec): min=3D71, max=3D22932, avg=3D84.76, stdev=3D83.84
     lat (usec): min=3D71, max=3D22932, avg=3D85.09, stdev=3D83.86
    clat percentiles (usec):
     |  1.00th=3D[   75],  5.00th=3D[   75], 10.00th=3D[   75], 20.00th=3D[=
   76],
     | 30.00th=3D[   76], 40.00th=3D[   76], 50.00th=3D[   76], 60.00th=3D[=
   77],
     | 70.00th=3D[   81], 80.00th=3D[   88], 90.00th=3D[  109], 95.00th=3D[=
  123],
     | 99.00th=3D[  157], 99.50th=3D[  182], 99.90th=3D[  297], 99.95th=3D[=
  570],
     | 99.99th=3D[ 2180]
   bw (  KiB/s): min=3D407936, max=3D762368, per=3D100.00%, avg=3D698791.41=
, stdev=3D63680.08, samples=3D100
   iops        : min=3D 6374, max=3D11912, avg=3D10918.44, stdev=3D994.96, =
samples=3D100
  lat (usec)   : 100=3D86.92%, 250=3D12.94%, 500=3D0.09%, 750=3D0.01%, 1000=
=3D0.01%
  lat (msec)   : 2=3D0.02%, 4=3D0.01%, 10=3D0.01%, 20=3D0.01%, 50=3D0.01%
  cpu          : usr=3D9.85%, sys=3D12.32%, ctx=3D546977, majf=3D0, minf=3D=
17
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwt: total=3D546053,0,0, short=3D0,0,0, dropped=3D0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D681MiB/s (714MB/s), 681MiB/s-681MiB/s (714MB/s-714MB/s), io=
=3D33.3GiB (35.8GB), run=3D50095-50095msec

Disk stats (read/write):
    dm-0: ios=3D547162/24, merge=3D0/36, ticks=3D53376/964, in_queue=3D5414=
4, util=3D100.00%, aggrios=3D135945/5, aggrmerge=3D0/0, aggrticks=3D8914/2,=
 aggrin_queue=3D8870, aggrutil=3D70.87%
  sdd: ios=3D207988/0, merge=3D0/0, ticks=3D14492/0, in_queue=3D14424, util=
=3D28.71%
  sdb: ios=3D112840/3, merge=3D0/0, ticks=3D7108/4, in_queue=3D7076, util=
=3D35.93%
  sdc: ios=3D114524/5, merge=3D0/0, ticks=3D7140/0, in_queue=3D7096, util=
=3D23.72%
  sda: ios=3D108429/14, merge=3D0/0, ticks=3D6916/4, in_queue=3D6884, util=
=3D70.87%
autopkgtest [08:53:52]: test tgtbasedmpaths: -----------------------]
autopkgtest [08:53:53]: test tgtbasedmpaths:  - - - - - - - - - - results -=
 - - - - - - - - -
tgtbasedmpaths       FAIL non-zero exit status 1
autopkgtest [08:53:53]:  - - - - - - - - - - running shell - - - - - - - - =
- -
autopkgtest [09:11:38]: @@@@@@@@@@@@@@@@@@@@ summary
kpartx-file-loopback FAIL non-zero exit status 6
tgtbasedmpaths       FAIL non-zero exit status 1
qemu-system-x86_64: terminating on signal 15 from pid 25453 (/usr/bin/pytho=
n3)

--ozuh6bihxa5nsjii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="journal.log"

Jan 12 09:17:08 autopkgtest multipathd[1980]: --------start up--------
Jan 12 09:17:08 autopkgtest multipathd[1980]: read /etc/multipath.conf
Jan 12 09:17:08 autopkgtest multipathd[1980]: path checkers start up
Jan 12 09:17:08 autopkgtest systemd[1]: Started Device-Mapper Multipath Device Controller.
Jan 12 09:17:08 autopkgtest systemd[1]: Reloading.
Jan 12 09:17:08 autopkgtest systemd[1]: Reloading.
Jan 12 09:17:09 autopkgtest systemd[1]: Reloading.
Jan 12 09:17:09 autopkgtest systemd[1]: Reloading.
Jan 12 09:17:09 autopkgtest systemd[1]: Starting (i)SCSI target daemon...
Jan 12 09:17:09 autopkgtest tgtd[2069]: tgtd: iser_ib_init(3431) Failed to initialize RDMA; load kernel modules?
Jan 12 09:17:09 autopkgtest tgtd[2069]: tgtd: work_timer_start(146) use timer_fd based scheduler
Jan 12 09:17:09 autopkgtest tgtd[2069]: tgtd: bs_init(387) use signalfd notification
Jan 12 09:17:09 autopkgtest systemd[1]: Started (i)SCSI target daemon.
Jan 12 09:17:12 autopkgtest kernel: print_req_error: I/O error, dev fd0, sector 0
Jan 12 09:17:12 autopkgtest kernel: floppy: error 10 while reading block 0
Jan 12 09:17:15 autopkgtest systemd[1]: Reloading.
Jan 12 09:17:17 autopkgtest systemd-timesyncd[476]: Synchronized to time server 91.189.89.198:123 (ntp.ubuntu.com).
Jan 12 09:17:26 autopkgtest su[6567]: Successful su for root by root
Jan 12 09:17:26 autopkgtest su[6567]: + ??? root:root
Jan 12 09:17:26 autopkgtest su[6567]: pam_unix(su:session): session opened for user root by (uid=0)
Jan 12 09:17:26 autopkgtest systemd[1]: Created slice User Slice of root.
Jan 12 09:17:26 autopkgtest systemd[1]: Starting User Manager for UID 0...
Jan 12 09:17:26 autopkgtest systemd[6568]: pam_unix(systemd-user:session): session opened for user root by (uid=0)
Jan 12 09:17:26 autopkgtest systemd[1]: Started Session c1 of user root.
Jan 12 09:17:26 autopkgtest systemd-logind[592]: New session c1 of user root.
Jan 12 09:17:26 autopkgtest systemd[6568]: Reached target Timers.
Jan 12 09:17:26 autopkgtest systemd[6568]: Reached target Sockets.
Jan 12 09:17:26 autopkgtest systemd[6568]: Reached target Paths.
Jan 12 09:17:26 autopkgtest systemd[6568]: Reached target Basic System.
Jan 12 09:17:26 autopkgtest systemd[6568]: Reached target Default.
Jan 12 09:17:26 autopkgtest systemd[6568]: Startup finished in 24ms.
Jan 12 09:17:26 autopkgtest systemd[1]: Started User Manager for UID 0.
Jan 12 09:17:26 autopkgtest systemd[1]: Stopping (i)SCSI target daemon...
Jan 12 09:17:26 autopkgtest systemd[1]: Stopped (i)SCSI target daemon.
Jan 12 09:17:26 autopkgtest systemd[1]: Starting (i)SCSI target daemon...
Jan 12 09:17:26 autopkgtest tgtd[6609]: tgtd: iser_ib_init(3431) Failed to initialize RDMA; load kernel modules?
Jan 12 09:17:26 autopkgtest tgtd[6609]: tgtd: work_timer_start(146) use timer_fd based scheduler
Jan 12 09:17:26 autopkgtest tgtd[6609]: tgtd: bs_init(387) use signalfd notification
Jan 12 09:17:27 autopkgtest systemd[1]: Started (i)SCSI target daemon.
Jan 12 09:17:27 autopkgtest tgtd[6609]: tgtd: device_mgmt(246) sz:46 params:path=/tmp/autopkgtest.zdJK5Z/tree/backingfile
Jan 12 09:17:27 autopkgtest tgtd[6609]: tgtd: bs_thread_open(409) 16
Jan 12 09:17:27 autopkgtest kernel: scsi host2: iSCSI Initiator over TCP/IP
Jan 12 09:17:27 autopkgtest kernel: scsi 2:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
Jan 12 09:17:27 autopkgtest kernel: scsi 2:0:0:0: Attached scsi generic sg1 type 12
Jan 12 09:17:27 autopkgtest kernel: scsi 2:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Jan 12 09:17:27 autopkgtest kernel: sd 2:0:0:1: [sda] 204800 512-byte logical blocks: (105 MB/100 MiB)
Jan 12 09:17:27 autopkgtest kernel: sd 2:0:0:1: [sda] 4096-byte physical blocks
Jan 12 09:17:27 autopkgtest kernel: sd 2:0:0:1: [sda] Write Protect is off
Jan 12 09:17:27 autopkgtest kernel: sd 2:0:0:1: [sda] Mode Sense: 69 00 10 08
Jan 12 09:17:27 autopkgtest kernel: sd 2:0:0:1: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jan 12 09:17:27 autopkgtest kernel: sd 2:0:0:1: [sda] Attached SCSI disk
Jan 12 09:17:27 autopkgtest kernel: sd 2:0:0:1: Attached scsi generic sg2 type 0
Jan 12 09:17:27 autopkgtest kernel: scsi host3: iSCSI Initiator over TCP/IP
Jan 12 09:17:27 autopkgtest kernel: scsi 3:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
Jan 12 09:17:27 autopkgtest kernel: scsi 3:0:0:0: Attached scsi generic sg3 type 12
Jan 12 09:17:27 autopkgtest kernel: scsi 3:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Jan 12 09:17:27 autopkgtest kernel: sd 3:0:0:1: [sdb] 204800 512-byte logical blocks: (105 MB/100 MiB)
Jan 12 09:17:27 autopkgtest kernel: sd 3:0:0:1: [sdb] 4096-byte physical blocks
Jan 12 09:17:27 autopkgtest kernel: sd 3:0:0:1: [sdb] Write Protect is off
Jan 12 09:17:27 autopkgtest kernel: sd 3:0:0:1: [sdb] Mode Sense: 69 00 10 08
Jan 12 09:17:27 autopkgtest kernel: sd 3:0:0:1: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jan 12 09:17:27 autopkgtest kernel: sd 3:0:0:1: [sdb] Attached SCSI disk
Jan 12 09:17:27 autopkgtest kernel: sd 3:0:0:1: Attached scsi generic sg4 type 0
Jan 12 09:17:27 autopkgtest kernel: scsi host4: iSCSI Initiator over TCP/IP
Jan 12 09:17:27 autopkgtest kernel: scsi 4:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
Jan 12 09:17:27 autopkgtest kernel: scsi 4:0:0:0: Attached scsi generic sg5 type 12
Jan 12 09:17:27 autopkgtest kernel: scsi 4:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Jan 12 09:17:27 autopkgtest kernel: sd 4:0:0:1: [sdc] 204800 512-byte logical blocks: (105 MB/100 MiB)
Jan 12 09:17:27 autopkgtest kernel: sd 4:0:0:1: [sdc] 4096-byte physical blocks
Jan 12 09:17:27 autopkgtest kernel: sd 4:0:0:1: [sdc] Write Protect is off
Jan 12 09:17:27 autopkgtest kernel: sd 4:0:0:1: [sdc] Mode Sense: 69 00 10 08
Jan 12 09:17:27 autopkgtest kernel: sd 4:0:0:1: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jan 12 09:17:27 autopkgtest kernel: sd 4:0:0:1: [sdc] Attached SCSI disk
Jan 12 09:17:27 autopkgtest kernel: sd 4:0:0:1: Attached scsi generic sg6 type 0
Jan 12 09:17:27 autopkgtest kernel: scsi host5: iSCSI Initiator over TCP/IP
Jan 12 09:17:27 autopkgtest kernel: scsi 5:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
Jan 12 09:17:27 autopkgtest kernel: scsi 5:0:0:0: Attached scsi generic sg7 type 12
Jan 12 09:17:27 autopkgtest kernel: scsi 5:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Jan 12 09:17:27 autopkgtest kernel: sd 5:0:0:1: [sdd] 204800 512-byte logical blocks: (105 MB/100 MiB)
Jan 12 09:17:27 autopkgtest kernel: sd 5:0:0:1: [sdd] 4096-byte physical blocks
Jan 12 09:17:27 autopkgtest kernel: sd 5:0:0:1: [sdd] Write Protect is off
Jan 12 09:17:27 autopkgtest kernel: sd 5:0:0:1: [sdd] Mode Sense: 69 00 10 08
Jan 12 09:17:27 autopkgtest kernel: sd 5:0:0:1: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jan 12 09:17:27 autopkgtest kernel: sd 5:0:0:1: [sdd] Attached SCSI disk
Jan 12 09:17:27 autopkgtest kernel: sd 5:0:0:1: Attached scsi generic sg8 type 0
Jan 12 09:17:27 autopkgtest multipathd[1980]: sda: add path (uevent)
Jan 12 09:17:27 autopkgtest multipathd[1980]: sda: duration = 0 (ms)
Jan 12 09:17:27 autopkgtest multipathd[1980]: sda: persistent reservation in: requested 8200 bytes but got 8 bytes)
Jan 12 09:17:27 autopkgtest multipathd[1980]: sda: No key found. Device may not be registered.
Jan 12 09:17:27 autopkgtest kernel: device-mapper: multipath service-time: version 0.3.0 loaded
Jan 12 09:17:27 autopkgtest multipathd[1980]: 360000000000000000e00000000010001: load table [0 204800 multipath 0 0 1 1 service-time 0 1 1 8:0 1
Jan 12 09:17:27 autopkgtest multipathd[1980]: ]
Jan 12 09:17:27 autopkgtest multipathd[1980]: 360000000000000000e00000000010001: event checker started
Jan 12 09:17:27 autopkgtest multipathd[1980]: sda [8:0]: path added to devmap 360000000000000000e00000000010001
Jan 12 09:17:27 autopkgtest systemd-udevd[6687]: Process '/usr/bin/partx -d --nr 1-1024 /dev/sda' failed with exit code 1.
Jan 12 09:17:27 autopkgtest multipath[6787]: dm-0: usable paths found
Jan 12 09:17:27 autopkgtest multipath[6810]: dm-0: usable paths found
Jan 12 09:17:28 autopkgtest iscsid[649]: Connection1:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is operational now
Jan 12 09:17:28 autopkgtest iscsid[649]: Connection2:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is operational now
Jan 12 09:17:28 autopkgtest iscsid[649]: Connection3:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is operational now
Jan 12 09:17:28 autopkgtest iscsid[649]: Connection4:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is operational now
Jan 12 09:17:28 autopkgtest multipathd[1980]: sdb: add path (uevent)
Jan 12 09:17:28 autopkgtest multipathd[1980]: sdb: delaying path addition until 360000000000000000e00000000010001 is fully initialized
Jan 12 09:17:28 autopkgtest multipathd[1980]: sdc: add path (uevent)
Jan 12 09:17:28 autopkgtest multipathd[1980]: sdc: delaying path addition until 360000000000000000e00000000010001 is fully initialized
Jan 12 09:17:28 autopkgtest multipathd[1980]: sdd: add path (uevent)
Jan 12 09:17:28 autopkgtest multipathd[1980]: sdd: delaying path addition until 360000000000000000e00000000010001 is fully initialized
Jan 12 09:17:28 autopkgtest multipathd[1980]: 360000000000000000e00000000010001: performing delayed actions
Jan 12 09:17:28 autopkgtest multipathd[1980]: 360000000000000000e00000000010001: load table [0 204800 multipath 0 0 4 1 service-time 0 1 1 8:0 1 service-time 0 1 1 8:16 1 service-time 0 1 1 8:32 1 service-time 0 1 1 8:48 1
Jan 12 09:17:28 autopkgtest multipathd[1980]: ]
Jan 12 09:17:28 autopkgtest multipath[6825]: dm-0: usable paths found
Jan 12 09:17:30 autopkgtest kernel: EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
Jan 12 09:17:42 autopkgtest kernel: device-mapper: multipath: Failing path 8:0.
Jan 12 09:17:42 autopkgtest multipathd[1980]: sda: mark as failed
Jan 12 09:17:42 autopkgtest multipathd[1980]: 360000000000000000e00000000010001: remaining active paths: 3
Jan 12 09:17:42 autopkgtest kernel: sd 2:0:0:1: [sda] Synchronizing SCSI cache
Jan 12 09:17:42 autopkgtest multipathd[1980]: sda: remove path (uevent)
Jan 12 09:17:42 autopkgtest multipathd[1980]: 360000000000000000e00000000010001: load table [0 204800 multipath 0 0 3 1 service-time 0 1 1 8:16 1 service-time 0 1 1 8:32 1 service-time 0 1 1 8:48 1
Jan 12 09:17:42 autopkgtest multipathd[1980]: ]
Jan 12 09:17:42 autopkgtest multipathd[1980]: sda [8:0]: path removed from map 360000000000000000e00000000010001
Jan 12 09:17:42 autopkgtest multipath[6877]: dm-0: usable paths found
Jan 12 09:17:42 autopkgtest multipath[6887]: dm-0: usable paths found
Jan 12 09:17:43 autopkgtest iscsid[649]: Connection1:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is shutdown.
Jan 12 09:17:43 autopkgtest multipathd[1980]: dm-0: Cannot find path by dm path 8:0
Jan 12 09:17:52 autopkgtest kernel: device-mapper: multipath: Failing path 8:16.
Jan 12 09:17:52 autopkgtest kernel: sd 3:0:0:1: [sdb] Synchronizing SCSI cache
Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: cannot find block device
Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: Empty device name
Jan 12 09:17:52 autopkgtest multipath[6909]: 8:16: Empty device name
Jan 12 09:17:52 autopkgtest multipath[6909]: get_udev_device: failed to look up 8:16 with type 1
Jan 12 09:17:52 autopkgtest multipath[6909]: dm-0: usable paths found
Jan 12 09:17:53 autopkgtest iscsid[649]: Connection2:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is shutdown.
Jan 12 09:18:02 autopkgtest kernel: device-mapper: multipath: Failing path 8:32.
Jan 12 09:18:02 autopkgtest kernel: sd 4:0:0:1: [sdc] Synchronizing SCSI cache
Jan 12 09:18:02 autopkgtest multipath[6933]: 8:16: cannot find block device
Jan 12 09:18:02 autopkgtest multipath[6933]: 8:16: Empty device name
Jan 12 09:18:02 autopkgtest multipath[6933]: 8:16: Empty device name
Jan 12 09:18:02 autopkgtest multipath[6933]: 8:32: cannot find block device
Jan 12 09:18:02 autopkgtest multipath[6933]: 8:32: Empty device name
Jan 12 09:18:02 autopkgtest multipath[6933]: 8:32: Empty device name
Jan 12 09:18:02 autopkgtest multipath[6933]: get_udev_device: failed to look up 8:16 with type 1
Jan 12 09:18:02 autopkgtest multipath[6933]: get_udev_device: failed to look up 8:32 with type 1
Jan 12 09:18:02 autopkgtest multipath[6933]: dm-0: usable paths found
Jan 12 09:18:03 autopkgtest iscsid[649]: Connection3:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is shutdown.
Jan 12 09:18:12 autopkgtest kernel: scsi host2: iSCSI Initiator over TCP/IP
Jan 12 09:18:12 autopkgtest kernel: scsi 2:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
Jan 12 09:18:12 autopkgtest kernel: scsi 2:0:0:0: Attached scsi generic sg1 type 12
Jan 12 09:18:12 autopkgtest kernel: scsi 2:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Jan 12 09:18:12 autopkgtest kernel: sd 2:0:0:1: Attached scsi generic sg2 type 0
Jan 12 09:18:12 autopkgtest kernel: sd 2:0:0:1: [sda] 204800 512-byte logical blocks: (105 MB/100 MiB)
Jan 12 09:18:12 autopkgtest kernel: sd 2:0:0:1: [sda] 4096-byte physical blocks
Jan 12 09:18:12 autopkgtest kernel: sd 2:0:0:1: [sda] Write Protect is off
Jan 12 09:18:12 autopkgtest kernel: sd 2:0:0:1: [sda] Mode Sense: 69 00 10 08
Jan 12 09:18:12 autopkgtest kernel: sd 2:0:0:1: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jan 12 09:18:12 autopkgtest kernel: sd 2:0:0:1: [sda] Attached SCSI disk
Jan 12 09:18:12 autopkgtest kernel: scsi host6: iSCSI Initiator over TCP/IP
Jan 12 09:18:12 autopkgtest kernel: scsi 6:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
Jan 12 09:18:12 autopkgtest kernel: scsi 6:0:0:0: Attached scsi generic sg3 type 12
Jan 12 09:18:12 autopkgtest kernel: scsi 6:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Jan 12 09:18:12 autopkgtest kernel: sd 6:0:0:1: Attached scsi generic sg4 type 0
Jan 12 09:18:12 autopkgtest kernel: sd 6:0:0:1: [sde] 204800 512-byte logical blocks: (105 MB/100 MiB)
Jan 12 09:18:12 autopkgtest kernel: sd 6:0:0:1: [sde] 4096-byte physical blocks
Jan 12 09:18:12 autopkgtest kernel: sd 6:0:0:1: [sde] Write Protect is off
Jan 12 09:18:12 autopkgtest kernel: sd 6:0:0:1: [sde] Mode Sense: 69 00 10 08
Jan 12 09:18:12 autopkgtest kernel: sd 6:0:0:1: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jan 12 09:18:12 autopkgtest kernel: sd 6:0:0:1: [sde] Attached SCSI disk
Jan 12 09:18:12 autopkgtest kernel: scsi host7: iSCSI Initiator over TCP/IP
Jan 12 09:18:12 autopkgtest kernel: scsi 7:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
Jan 12 09:18:12 autopkgtest kernel: scsi 7:0:0:0: Attached scsi generic sg5 type 12
Jan 12 09:18:12 autopkgtest kernel: scsi 7:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Jan 12 09:18:12 autopkgtest kernel: sd 7:0:0:1: Attached scsi generic sg6 type 0
Jan 12 09:18:12 autopkgtest kernel: sd 7:0:0:1: [sdf] 204800 512-byte logical blocks: (105 MB/100 MiB)
Jan 12 09:18:12 autopkgtest kernel: sd 7:0:0:1: [sdf] 4096-byte physical blocks
Jan 12 09:18:12 autopkgtest kernel: sd 7:0:0:1: [sdf] Write Protect is off
Jan 12 09:18:12 autopkgtest kernel: sd 7:0:0:1: [sdf] Mode Sense: 69 00 10 08
Jan 12 09:18:12 autopkgtest kernel: sd 7:0:0:1: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jan 12 09:18:12 autopkgtest kernel: sd 7:0:0:1: [sdf] Attached SCSI disk
Jan 12 09:18:12 autopkgtest kernel: scsi host8: iSCSI Initiator over TCP/IP
Jan 12 09:18:12 autopkgtest kernel: scsi 8:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
Jan 12 09:18:12 autopkgtest kernel: scsi 8:0:0:0: Attached scsi generic sg9 type 12
Jan 12 09:18:12 autopkgtest kernel: scsi 8:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Jan 12 09:18:12 autopkgtest kernel: sd 8:0:0:1: Attached scsi generic sg10 type 0
Jan 12 09:18:12 autopkgtest kernel: sd 8:0:0:1: [sdg] 204800 512-byte logical blocks: (105 MB/100 MiB)
Jan 12 09:18:12 autopkgtest kernel: sd 8:0:0:1: [sdg] 4096-byte physical blocks
Jan 12 09:18:12 autopkgtest kernel: sd 8:0:0:1: [sdg] Write Protect is off
Jan 12 09:18:12 autopkgtest kernel: sd 8:0:0:1: [sdg] Mode Sense: 69 00 10 08
Jan 12 09:18:12 autopkgtest kernel: sd 8:0:0:1: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
Jan 12 09:18:12 autopkgtest kernel: sd 8:0:0:1: [sdg] Attached SCSI disk
Jan 12 09:18:12 autopkgtest systemd-udevd[6963]: Process '/usr/bin/partx -d --nr 1-1024 /dev/sda' failed with exit code 1.
Jan 12 09:18:12 autopkgtest systemd-udevd[6958]: Process '/usr/bin/partx -d --nr 1-1024 /dev/sde' failed with exit code 1.
Jan 12 09:18:12 autopkgtest systemd-udevd[6949]: Process '/usr/bin/partx -d --nr 1-1024 /dev/sdf' failed with exit code 1.
Jan 12 09:18:12 autopkgtest systemd-udevd[6961]: Process '/usr/bin/partx -d --nr 1-1024 /dev/sdg' failed with exit code 1.
Jan 12 09:18:13 autopkgtest iscsid[649]: Connection5:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is operational now
Jan 12 09:18:13 autopkgtest iscsid[649]: Connection6:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is operational now
Jan 12 09:18:13 autopkgtest iscsid[649]: Connection7:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is operational now
Jan 12 09:18:13 autopkgtest iscsid[649]: Connection8:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is operational now
Jan 12 09:18:22 autopkgtest kernel: device-mapper: multipath: Failing path 8:48.
Jan 12 09:18:22 autopkgtest kernel: print_req_error: I/O error, dev dm-0, sector 136066
Jan 12 09:18:22 autopkgtest kernel: sd 5:0:0:1: [sdd] Synchronizing SCSI cache
Jan 12 09:18:22 autopkgtest kernel: sd 7:0:0:1: [sdf] Synchronizing SCSI cache
Jan 12 09:18:22 autopkgtest su[6567]: pam_unix(su:session): session closed for user root
Jan 12 09:18:22 autopkgtest systemd-logind[592]: Removed session c1.
Jan 12 09:18:22 autopkgtest systemd[1]: Stopping User Manager for UID 0...
Jan 12 09:18:22 autopkgtest systemd[6568]: Stopped target Default.
Jan 12 09:18:22 autopkgtest systemd[6568]: Stopped target Basic System.
Jan 12 09:18:22 autopkgtest systemd[6568]: Stopped target Paths.
Jan 12 09:18:22 autopkgtest systemd[6568]: Stopped target Timers.
Jan 12 09:18:22 autopkgtest systemd[6568]: Stopped target Sockets.
Jan 12 09:18:22 autopkgtest systemd[6568]: Reached target Shutdown.
Jan 12 09:18:22 autopkgtest systemd[6568]: Starting Exit the Session...
Jan 12 09:18:22 autopkgtest kernel: sd 8:0:0:1: [sdg] Synchronizing SCSI cache
Jan 12 09:18:22 autopkgtest systemd[6568]: Received SIGRTMIN+24 from PID 7084 (kill).
Jan 12 09:18:22 autopkgtest systemd[1]: Stopped User Manager for UID 0.
Jan 12 09:18:22 autopkgtest systemd[1]: Removed slice User Slice of root.
Jan 12 09:18:23 autopkgtest iscsid[649]: Connection4:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is shutdown.
Jan 12 09:18:23 autopkgtest iscsid[649]: Connection7:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is shutdown.
Jan 12 09:18:23 autopkgtest iscsid[649]: Connection8:0 to [target: iqn.2016-11.foo.com:target.iscsi, portal: 127.0.0.1,3260] through [iface: default] is shutdown.
Jan 12 09:18:32 autopkgtest systemd[1]: Stopping Device-Mapper Multipath Device Controller...
Jan 12 09:18:37 autopkgtest multipathd[1980]: exit (signal)
Jan 12 09:18:38 autopkgtest sshd[7124]: Accepted password for ubuntu from 10.0.2.2 port 55444 ssh2
Jan 12 09:18:38 autopkgtest sshd[7124]: pam_unix(sshd:session): session opened for user ubuntu by (uid=0)
Jan 12 09:18:38 autopkgtest systemd[1]: Created slice User Slice of ubuntu.
Jan 12 09:18:38 autopkgtest systemd[1]: Starting User Manager for UID 1000...
Jan 12 09:18:38 autopkgtest systemd[7137]: pam_unix(systemd-user:session): session opened for user ubuntu by (uid=0)
Jan 12 09:18:38 autopkgtest systemd[1]: Started Session 3 of user ubuntu.
Jan 12 09:18:38 autopkgtest systemd-logind[592]: New session 3 of user ubuntu.
Jan 12 09:18:38 autopkgtest systemd[7137]: Reached target Timers.
Jan 12 09:18:38 autopkgtest systemd[7137]: Reached target Sockets.
Jan 12 09:18:38 autopkgtest systemd[7137]: Reached target Paths.
Jan 12 09:18:38 autopkgtest systemd[7137]: Reached target Basic System.
Jan 12 09:18:38 autopkgtest systemd[7137]: Reached target Default.
Jan 12 09:18:38 autopkgtest systemd[7137]: Startup finished in 26ms.
Jan 12 09:18:38 autopkgtest systemd[1]: Started User Manager for UID 1000.
Jan 12 09:18:38 autopkgtest kernel: print_req_error: I/O error, dev dm-0, sector 98304
Jan 12 09:18:38 autopkgtest kernel: Buffer I/O error on dev dm-0, logical block 49152, async page read
Jan 12 09:18:38 autopkgtest kernel: print_req_error: I/O error, dev dm-0, sector 98310
Jan 12 09:18:38 autopkgtest kernel: Buffer I/O error on dev dm-0, logical block 49155, async page read
Jan 12 09:18:38 autopkgtest kernel: print_req_error: I/O error, dev dm-0, sector 98304
Jan 12 09:18:38 autopkgtest kernel: Buffer I/O error on dev dm-0, logical block 49152, async page read
Jan 12 09:18:38 autopkgtest kernel: print_req_error: I/O error, dev dm-0, sector 98310
Jan 12 09:18:38 autopkgtest kernel: Buffer I/O error on dev dm-0, logical block 49155, async page read

--ozuh6bihxa5nsjii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=udevlog

KERNEL[64.000145] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:0/bsg/2:0:0:0 (bsg)
KERNEL[64.000192] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:0/scsi_generic/sg1 (scsi_generic)
KERNEL[64.000215] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:0/scsi_device/2:0:0:0 (scsi_device)
KERNEL[64.000242] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:0 (scsi)
KERNEL[64.000267] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/bsg/2:0:0:1 (bsg)
KERNEL[64.000288] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/scsi_generic/sg2 (scsi_generic)
KERNEL[64.000304] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/scsi_device/2:0:0:1 (scsi_device)
KERNEL[64.000347] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/scsi_disk/2:0:0:1 (scsi_disk)    
UDEV  [64.002088] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/scsi_disk/2:0:0:1 (scsi_disk)    
KERNEL[64.004135] change   /devices/virtual/block/dm-0 (block)                        
KERNEL[64.012462] remove   /devices/virtual/bdi/8:0 (bdi)                                        
KERNEL[64.012896] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/block/sda (block)              
KERNEL[64.016890] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1 (scsi)                           
UDEV  [64.018408] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/scsi_generic/sg2 (scsi_generic)
UDEV  [64.021040] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/scsi_device/2:0:0:1 (scsi_device)
UDEV  [64.022886] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:0/scsi_generic/sg1 (scsi_generic)
UDEV  [64.024884] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/bsg/2:0:0:1 (bsg)
KERNEL[64.028232] remove   /devices/platform/host2/session1/target2:0:0 (scsi)                                 
KERNEL[64.028722] remove   /devices/platform/host2/session1/connection1:0/iscsi_connection/connection1:0 (iscsi_connection)
KERNEL[64.028958] remove   /devices/platform/host2/session1/iscsi_session/session1 (iscsi_session)
KERNEL[64.029059] remove   /devices/platform/host2/iscsi_host/host2 (iscsi_host)      
KERNEL[64.029171] remove   /devices/platform/host2/scsi_host/host2 (scsi_host)
KERNEL[64.029296] remove   /devices/platform/host2 (scsi)                                        
UDEV  [64.036503] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:0/bsg/2:0:0:0 (bsg)
UDEV  [64.036542] remove   /devices/virtual/bdi/8:0 (bdi) 
UDEV  [64.045615] remove   /devices/platform/host2/session1/iscsi_session/session1 (iscsi_session)
UDEV  [64.047954] remove   /devices/platform/host2/session1/connection1:0/iscsi_connection/connection1:0 (iscsi_connection)
UDEV  [64.057855] remove   /devices/platform/host2/scsi_host/host2 (scsi_host)                                             
UDEV  [64.059690] remove   /devices/platform/host2/iscsi_host/host2 (iscsi_host)                  
UDEV  [64.063312] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:0/scsi_device/2:0:0:0 (scsi_device)
UDEV  [64.067748] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1/block/sda (block)
UDEV  [64.073994] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:0 (scsi)
UDEV  [64.081780] remove   /devices/platform/host2/session1/target2:0:0/2:0:0:1 (scsi)            
UDEV  [64.082874] remove   /devices/platform/host2/session1/target2:0:0 (scsi)                                             
KERNEL[64.084673] change   /devices/virtual/block/dm-0 (block)                                                              
UDEV  [64.086194] remove   /devices/platform/host2 (scsi)                                                                  
UDEV  [64.144668] change   /devices/virtual/block/dm-0 (block)                                                              
UDEV  [64.230774] change   /devices/virtual/block/dm-0 (block)                                                             
KERNEL[74.069607] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:0/bsg/3:0:0:0 (bsg)                                          
UDEV  [74.069628] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/scsi_disk/3:0:0:1 (scsi_disk)   
KERNEL[74.069641] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:0/scsi_generic/sg3 (scsi_generic)            
UDEV  [74.069650] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/scsi_device/3:0:0:1 (scsi_device)          
KERNEL[74.069657] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:0/scsi_device/3:0:0:0 (scsi_device)
KERNEL[74.069667] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:0 (scsi)                                      
KERNEL[74.069678] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/bsg/3:0:0:1 (bsg)                           
KERNEL[74.069688] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/scsi_generic/sg4 (scsi_generic)
KERNEL[74.069695] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/scsi_device/3:0:0:1 (scsi_device)
KERNEL[74.069701] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/scsi_disk/3:0:0:1 (scsi_disk)              
UDEV  [74.070450] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:0/scsi_device/3:0:0:0 (scsi_device) 
UDEV  [74.071029] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/bsg/3:0:0:1 (bsg)                 
KERNEL[74.071416] change   /devices/virtual/block/dm-0 (block)                                                   
UDEV  [74.073108] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/scsi_generic/sg4 (scsi_generic)            
UDEV  [74.074455] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:0/scsi_generic/sg3 (scsi_generic)            
UDEV  [74.075626] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:0/bsg/3:0:0:0 (bsg)                          
UDEV  [74.077001] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:0 (scsi)                           
KERNEL[74.080125] remove   /devices/virtual/bdi/8:16 (bdi)                                                        
KERNEL[74.080270] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/block/sdb (block)                
KERNEL[74.080759] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1 (scsi)                           
UDEV  [74.083661] remove   /devices/virtual/bdi/8:16 (bdi)                                                       
UDEV  [74.086799] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1/block/sdb (block)                           
KERNEL[74.088142] remove   /devices/platform/host3/session2/target3:0:0 (scsi)                                             
KERNEL[74.088422] remove   /devices/platform/host3/session2/connection2:0/iscsi_connection/connection2:0 (iscsi_connection)
KERNEL[74.088584] remove   /devices/platform/host3/session2/iscsi_session/session2 (iscsi_session)                         
KERNEL[74.088657] remove   /devices/platform/host3/iscsi_host/host3 (iscsi_host)                                                                                         
KERNEL[74.088740] remove   /devices/platform/host3/scsi_host/host3 (scsi_host)                                   
KERNEL[74.088785] remove   /devices/platform/host3 (scsi)                                                        
UDEV  [74.093773] remove   /devices/platform/host3/session2/iscsi_session/session2 (iscsi_session)                
UDEV  [74.094775] remove   /devices/platform/host3/iscsi_host/host3 (iscsi_host)                                                                                                                                                                                                 [304/11793]
UDEV  [74.095345] remove   /devices/platform/host3/scsi_host/host3 (scsi_host)
UDEV  [74.095910] remove   /devices/platform/host3/session2/connection2:0/iscsi_connection/connection2:0 (iscsi_connection)
UDEV  [74.098530] remove   /devices/platform/host3/session2/target3:0:0/3:0:0:1 (scsi)
UDEV  [74.099420] remove   /devices/platform/host3/session2/target3:0:0 (scsi)
UDEV  [74.100500] remove   /devices/platform/host3 (scsi)
UDEV  [74.134076] change   /devices/virtual/block/dm-0 (block)
KERNEL[84.143452] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:0/bsg/4:0:0:0 (bsg)
KERNEL[84.143493] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:0/scsi_generic/sg5 (scsi_generic)
KERNEL[84.143509] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:0/scsi_device/4:0:0:0 (scsi_device)
KERNEL[84.143527] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:0 (scsi)
KERNEL[84.143548] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/bsg/4:0:0:1 (bsg)
KERNEL[84.143568] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/scsi_generic/sg6 (scsi_generic)
KERNEL[84.143582] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/scsi_device/4:0:0:1 (scsi_device)
KERNEL[84.143594] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/scsi_disk/4:0:0:1 (scsi_disk)
UDEV  [84.144843] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/scsi_device/4:0:0:1 (scsi_device)
UDEV  [84.145769] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/scsi_generic/sg6 (scsi_generic)
KERNEL[84.146120] change   /devices/virtual/block/dm-0 (block)
UDEV  [84.150544] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/scsi_disk/4:0:0:1 (scsi_disk)
UDEV  [84.153129] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:0/scsi_generic/sg5 (scsi_generic)
UDEV  [84.155032] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:0/scsi_device/4:0:0:0 (scsi_device)
KERNEL[84.156175] remove   /devices/virtual/bdi/8:32 (bdi)
KERNEL[84.156327] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/block/sdc (block)
UDEV  [84.158249] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:0/bsg/4:0:0:0 (bsg)
UDEV  [84.163414] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/bsg/4:0:0:1 (bsg)
KERNEL[84.163959] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1 (scsi)
UDEV  [84.165762] remove   /devices/virtual/bdi/8:32 (bdi)
KERNEL[84.172202] remove   /devices/platform/host4/session3/target4:0:0 (scsi)
KERNEL[84.172627] remove   /devices/platform/host4/session3/connection3:0/iscsi_connection/connection3:0 (iscsi_connection)
KERNEL[84.172853] remove   /devices/platform/host4/session3/iscsi_session/session3 (iscsi_session)
KERNEL[84.172954] remove   /devices/platform/host4/iscsi_host/host4 (iscsi_host)
KERNEL[84.173016] remove   /devices/platform/host4/scsi_host/host4 (scsi_host)
KERNEL[84.173069] remove   /devices/platform/host4 (scsi)
UDEV  [84.178398] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:0 (scsi)
UDEV  [84.178433] remove   /devices/platform/host4/session3/iscsi_session/session3 (iscsi_session)
UDEV  [84.178452] remove   /devices/platform/host4/iscsi_host/host4 (iscsi_host)                                                                                                                                                                                                 [268/11793]
UDEV  [84.181797] remove   /devices/platform/host4/scsi_host/host4 (scsi_host)
UDEV  [84.186165] remove   /devices/platform/host4/session3/connection3:0/iscsi_connection/connection3:0 (iscsi_connection)
UDEV  [84.191566] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1/block/sdc (block)
UDEV  [84.200973] remove   /devices/platform/host4/session3/target4:0:0/4:0:0:1 (scsi)
UDEV  [84.202042] remove   /devices/platform/host4/session3/target4:0:0 (scsi)
UDEV  [84.203355] remove   /devices/platform/host4 (scsi)
UDEV  [84.250480] change   /devices/virtual/block/dm-0 (block)

--ozuh6bihxa5nsjii
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--ozuh6bihxa5nsjii--
