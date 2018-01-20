From: Martin Wilck <mwilck@suse.com>
Subject: [FIX for 14/16] multipath.rules: set job properties for
	systemd-run correctly
Date: Sat, 20 Jan 2018 01:27:23 +0100
Message-ID: <20180120002723.10653-1-mwilck@suse.com>
References: <20180119002916.10323-15-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-15-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

The default dependencies must be turned off for both the timer and
the service unit, otherwise systemd-run will wait for sysinit.target.

Moreover, fix these bugs:
 - never run the logic if DM_MULTIPATH_DEVICE_PATH!=2
 - reset DM_MULTIPATH_DEVICE_PATH to "" on timer expiry

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/multipath.rules | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.rules b/multipath/multipath.rules
index 6b4a418d0009..659aa586d46e 100644
--- a/multipath/multipath.rules
+++ b/multipath/multipath.rules
@@ -62,8 +62,9 @@ ENV{DM_MULTIPATH_DEVICE_PATH}=="1", ENV{ID_FS_TYPE}="mpath_member", \
 # DM_MULTIPATH_WAIT_DONE ensures that this happens only once.
 # (But see "special case" exception above).
 
-ENV{DM_MULTIPATH_WAIT_DONE}=="1", GOTO="end_mpath"
 ENV{DM_MULTIPATH_DEVICE_PATH}!="2", GOTO="end_mpath"
+ENV{DM_MULTIPATH_WAIT_DONE}=="1", ENV{DM_MULTIPATH_DEVICE_PATH}="", \
+	GOTO="end_mpath"
 
 # Default timeout values for the timer. Use early udev rules files to customize.
 # Timeouts are in seconds after system boot, and seconds after first path
@@ -77,6 +78,6 @@ ENV{DM_MULTIPATH_SAVED_FS_TYPE}=="", ENV{DM_MULTIPATH_SAVED_FS_TYPE}="dm_multipa
 ENV{ID_FS_TYPE}="maybe_mpath_member"
 ENV{DM_MULTIPATH_DEVICE_PATH}="1"
 ENV{SYSTEMD_READY}="0"
-RUN+="/usr/bin/systemd-run --action change --on-boot $env{FIND_MULTIPATHS_BOOT_TMO} --on-active $env{FIND_MULTIPATHS_PATH_TMO} /usr/bin/udevadm trigger $sys$devpath"
+RUN+="/usr/bin/systemd-run --no-block --timer-property DefaultDependencies=no --property DefaultDependencies=no --on-boot $env{FIND_MULTIPATHS_BOOT_TMO} --on-active $env{FIND_MULTIPATHS_PATH_TMO} /usr/bin/udevadm --action change trigger $sys$devpath"
 
 LABEL="end_mpath"
-- 
2.15.1
