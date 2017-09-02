From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 29/31] multipath/kpartx rules: avoid superfluous
	scanning
Date: Sun,  3 Sep 2017 00:38:58 +0200
Message-ID: <20170902223900.7339-30-mwilck@suse.com>
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

Multipath maps receive certain udev events that only indicate
changes in the path list. Use MPATH_UNCHANGED to tell this to
upper layers, so that they can ignore the event.

multipathd-generated events with DM_SUBSYSTEM_UDEV_FLAG0 are one
case, and kernel-generated PATH_FAILED and PATH_REINSTATED events
are another.

The LVM rules rely on DM_ACTIVATION, but other rules such as
kpartx can't do that, because they'd miss e.g. partition table
changes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules         | 3 +++
 multipath/11-dm-mpath.rules | 8 +++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index b8141141..1cbe9429 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -60,6 +60,9 @@ ENV{DM_UUID}!="mpath-?*", GOTO="mpath_kpartx_end"
 ENV{DM_UDEV_PRIMARY_SOURCE_FLAG}!="1", IMPORT{db}="DM_SUBSYSTEM_UDEV_FLAG1"
 ENV{DM_SUBSYSTEM_UDEV_FLAG1}=="1", GOTO="mpath_kpartx_end"
 
+# 11-dm-mpath.rules sets MPATH_UNCHANGED for events that can be ignored.
+ENV{MPATH_UNCHANGED}=="1", GOTO="mpath_kpartx_end"
+
 # Don't run kpartx now if we know it will fail or hang.
 ENV{DM_SUSPENDED}=="1", GOTO="mpath_kpartx_end"
 ENV{DM_NOSCAN}=="1", GOTO="mpath_kpartx_end"
diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 9bfd75f8..4a3f646d 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -49,7 +49,13 @@ LABEL="mpath_action"
 # something that should be reacted upon since it would be useless extra work.
 # It's exactly mpath's job to provide *seamless* device access to any of the
 # paths that are available underneath.
-ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", ENV{DM_ACTIVATION}="0"
+ENV{DM_SUBSYSTEM_UDEV_FLAG0}=="1", \
+	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
+
+# For path failed or reinstated events, unset DM_ACTIVATION.
+# This is similar to the DM_SUBSYSTEM_UDEV_FLAG0 case above.
+ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", \
+	ENV{DM_ACTIVATION}="0", ENV{MPATH_UNCHANGED}="1"
 
 # Do not initiate scanning if no path is available,
 # otherwise there would be a hang or IO error on access.
-- 
2.14.0
