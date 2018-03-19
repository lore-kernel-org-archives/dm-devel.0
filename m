From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 17/20] multipath.rules: find_multipaths
	"smart" logic
Date: Mon, 19 Mar 2018 16:01:52 +0100
Message-ID: <20180319150155.5363-18-mwilck@suse.com>
References: <20180319150155.5363-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180319150155.5363-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

When the first path to a device appears, we don't know if more paths are going
to follow. find_multipath "smart" logic attempts to solve this dilemma by
waiting for additional paths for a configurable time before giving up
and releasing single paths to upper layers.

These rules apply only if both find_multipaths is set to "smart" in
multipath.conf. In this mode, multipath -u sets DM_MULTIPATH_DEVICE_PATH=2 if
there's no clear evidence wheteher a given device should be a multipath member
(not blacklisted, not listed as "failed", not in WWIDs file, not member of an
exisiting map, only one path seen yet).

In this case, pretend that the path is multipath member, disallow further
processing by systemd (allowing multipathd some time to grab the path),
and check again after some time. If the path is still not multipathed by then,
pass it on to systemd for further processing.

The timeout is controlled by the "find_multipaths_timeout" config option.
Note that delays caused by waiting don't "add up" during boot, because the
timers run concurrently.

Implementation note: This logic requires obtaining the current time. It's not
trivial to do this in udev rules in a portable way, because "/bin/date" is
often not available in restricted environments such as the initrd. I chose
the sysfs method, because /sys/class/rtc/rtc0 seems to be quite universally
available. I'm open for better suggestions if there are any.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.rules | 80 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index aab64dc7182c..32d33991db3d 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -21,7 +21,83 @@ TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
 
 # multipath -u sets DM_MULTIPATH_DEVICE_PATH
 ENV{DM_MULTIPATH_DEVICE_PATH}!="1", IMPORT{program}="$env{MPATH_SBIN_PATH}/multipath -u %k"
-ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
-	ENV{SYSTEMD_READY}="0"
+
+# case 1: this is definitely multipath
+ENV{DM_MULTIPATH_DEVICE_PATH}=="1", \
+	ENV{ID_FS_TYPE}="mpath_member", ENV{SYSTEMD_READY}="0", \
+	ENV{FIND_MULTIPATHS_WAIT_UNTIL}="finished", \
+	GOTO="end_mpath"
+
+# case 2: this is definitely not multipath
+ENV{DM_MULTIPATH_DEVICE_PATH}!="2", \
+	ENV{FIND_MULTIPATHS_WAIT_UNTIL}="finished", \
+	GOTO="end_mpath"
+
+# All code below here is only run in "smart" mode.
+
+# FIND_MULTIPATHS_WAIT_UNTIL is the timeout (in seconds after the
+# epoch). If waiting ends for any reason, it is set to "finished".
+IMPORT{db}="FIND_MULTIPATHS_WAIT_UNTIL"
+
+# At this point we know DM_MULTIPATH_DEVICE_PATH==2.
+# (multipath -u indicates this is "maybe" multipath)
+
+# case 3: waiting has already finished. Treat as non-multipath.
+ENV{FIND_MULTIPATHS_WAIT_UNTIL}=="finished", \
+	ENV{DM_MULTIPATH_DEVICE_PATH}="", GOTO="end_mpath"
+
+# The timeout should have been set by the multipath -u call above, set a default
+# value it that didn't happen for whatever reason
+ENV{FIND_MULTIPATHS_PATH_TMO}!="?*", ENV{FIND_MULTIPATHS_PATH_TMO}="5"
+
+PROGRAM="/bin/cat $sys/class/rtc/rtc0/since_epoch", \
+	ENV{.TIME_NOW}="$result"
+ENV{.TIME_NOW}!="?*", ENV{DM_MULTIPATH_DEVICE_PATH}="", \
+	ENV{FIND_MULTIPATHS_WAIT_UNTIL}="error", GOTO="end_mpath"
+
+ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="?*", GOTO="start_wait"
+
+# At this point, we know that FIND_MULTIPATHS_WAIT_UNTIL is a timeout value.
+# If it's expired, give up waiting and assume this is non-multipath.
+PROGRAM="/bin/sh -c '[ $env{.TIME_NOW} -ge $env{FIND_MULTIPATHS_WAIT_UNTIL} ]'", \
+	ENV{DM_MULTIPATH_DEVICE_PATH}="", \
+	ENV{FIND_MULTIPATHS_WAIT_UNTIL}="finished", \
+	GOTO="end_mpath"
+
+# Timer not expired yet. The current uevent has not been triggered by the
+# systemd timer but something else, e.g. 60-block.rules. Continue pretending.
+ACTION!="add", GOTO="pretend_mpath"
+
+# Special case: Another "add" event happened before the timeout expired.
+# This can happen during "coldplug" after switching root FS, if a
+# systemd timer started during initramfs processing had been cancelled.
+# We need to start the timer again.
+
+LABEL="start_wait"
+
+# We are seeing this path for the first time, and it's "maybe" multipath.
+# Pretend that it is actually multipath, and set a timer to create another
+# uevent at FIND_MULTIPATHS_WAIT_UNTIL seconds after the epoch.
+ENV{FIND_MULTIPATHS_WAIT_UNTIL}!="?*", \
+	PROGRAM="/bin/sh -c 'echo $(( $env{.TIME_NOW} + $env{FIND_MULTIPATHS_PATH_TMO} ))'", \
+	ENV{FIND_MULTIPATHS_WAIT_UNTIL}="$result"
+
+# The actual start command for the timer.
+#
+# The purpose of this command is only to make sure we will receive another
+# uevent eventually. *Any* uevent may cause waiting to finish if it either ends
+# in case 1-3 above, or if it arrives after FIND_MULTIPATHS_WAIT_UNTIL.
+#
+# Note that this will try to activate multipathd if it isn't running yet.
+# If that fails, the unit starts and expires nonetheless. If multipathd
+# startup needs to wait for other services, this wait time will add up with
+# the --on-active timeout.
+#
+# We must trigger an "add" event because LVM2 will only act on those.
+RUN+="/usr/bin/systemd-run --unit=cancel-multipath-wait-$kernel --description 'cancel waiting for multipath siblings of $kernel' --no-block --timer-property DefaultDependencies=no --timer-property Conflicts=shutdown.target --timer-property Before=shutdown.target --timer-property AccuracySec=500ms --property DefaultDependencies=no --property Conflicts=shutdown.target --property Before=shutdown.target --property Wants=multipathd.service --property After=multipathd.service --on-active=$env{FIND_MULTIPATHS_PATH_TMO} /usr/bin/udevadm trigger --action=add $sys$devpath"
+
+LABEL="pretend_mpath"
+ENV{DM_MULTIPATH_DEVICE_PATH}="1"
+ENV{SYSTEMD_READY}="0"
 
 LABEL="end_mpath"
-- 
2.16.1
