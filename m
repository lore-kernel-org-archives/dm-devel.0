From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/11] Provide correct persistent symlinks for
	user_friendly_names
Date: Thu, 17 Jan 2013 15:59:24 +0100
Message-ID: <1358434773-2002-3-git-send-email-hare@suse.de>
References: <1358434773-2002-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1358434773-2002-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When the option 'user_friendly_names' is set we should provide
both symlinks, the persistent one and that one generated for
user_friendly_names.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.rules |    4 ++++
 kpartx/kpartx_id    |    7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index ba5c6cb..8640094 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -18,10 +18,14 @@ OPTIONS="link_priority=50"
 # Create persistent links for multipath tables
 ENV{DM_UUID}=="mpath-*", \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
+ENV{DM_MPATH}=="?*", ENV{DM_PART}!="?*", \
+	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_MPATH}"
 
 # Create persistent links for partitions
 ENV{DM_PART}=="?*", \
         SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}-part$env{DM_PART}"
+ENV{DM_MPATH}=="?*", ENV{DM_PART}=="?*", \
+	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_MPATH}-part$env{DM_PART}"
 
 # Create dm tables for partitions
 ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index fa21b5b..afb589c 100644
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -55,6 +55,9 @@ if [ "$dmtbl" = "part" ] ; then
     # The name of the kpartx table is the name of the parent table
     dmname=$($DMSETUP info  -c --noheadings -o name -u $dmuuid)
     echo "DM_NAME=$dmname"
+    if [ "$dmname" != ${dmuuid#mpath-} ] ; then
+	echo "DM_MPATH=${dmuuid#mpath-}"
+    fi
     # We need the dependencies of the parent table to figure out
     # the type if the parent is a multipath table
     case "$dmuuid" in
@@ -63,7 +66,9 @@ if [ "$dmtbl" = "part" ] ; then
 	    ;;
     esac
 elif [ "$dmtbl" = "mpath" ] ; then
-    dmname=$tblname
+    if [ -n "$DM_NAME" -a "$DM_NAME" != "$dmuuid" ] ; then
+	echo "DM_MPATH=$dmuuid"
+    fi
     # We need the dependencies of the table to figure out the type
     dmdeps=$($DMSETUP deps -u $UUID)
 elif [ "$dmtbl" = "dmraid" ] ; then
-- 
1.7.10.4
