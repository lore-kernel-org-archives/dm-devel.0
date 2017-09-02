From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 16/31] 11-dm-mpath.rules: multipath -U for READY
	check
Date: Sun,  3 Sep 2017 00:38:45 +0200
Message-ID: <20170902223900.7339-17-mwilck@suse.com>
References: <20170902223900.7339-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170902223900.7339-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

For kernel-generated path events, DM_NR_VALID_PATHS indicates
whether usable paths are available. But this information isn't
reliable as events may be received out of order.

Use multipath -U to determine whether a multipath map can
handle I/O.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index b131a103..d1ef85e5 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -18,8 +18,19 @@ ENV{DM_SUBSYSTEM_UDEV_FLAG2}=="1", ENV{MPATH_DEVICE_READY}="0",\
 	GOTO="mpath_action"
 
 # If the last path has failed mark the device not ready
-ENV{DM_ACTION}=="PATH_FAILED", ENV{DM_NR_VALID_PATHS}=="0",\
-	ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
+# Note that DM_NR_VALID_PATHS is only set for PATH_FAILED|PATH_REINSTATED
+# events.
+# This may not be reliable, as events aren't necessarily received in order.
+ENV{DM_NR_VALID_PATHS}=="0", ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
+
+ENV{MPATH_SBIN_PATH}="/sbin"
+TEST!="$env{MPATH_SBIN_PATH}/multipath", ENV{MPATH_SBIN_PATH}="/usr/sbin"
+
+# Check the map state directly with multipath -U.
+# This doesn't attempt I/O on the device.
+PROGRAM=="$env{MPATH_SBIN_PATH}/multipath -U %k", GOTO="paths_ok"
+ENV{MPATH_DEVICE_READY}="0", GOTO="mpath_action"
+LABEL="paths_ok"
 
 # Don't mark a device ready on a PATH_FAILED event. even if
 # DM_NR_VALID_PATHS is greater than 0. Just keep the existing
-- 
2.14.0
