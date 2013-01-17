From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/11] kpartx_id: Generate persistent symlinks
	for 'wwn'
Date: Thu, 17 Jan 2013 15:59:25 +0100
Message-ID: <1358434773-2002-4-git-send-email-hare@suse.de>
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

Newer udev versions generate /dev/disk/by-id/wwn-* symlinks.
We should be adjusting those for multipathing, too.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.rules |    4 ++++
 kpartx/kpartx_id    |    2 ++
 2 files changed, 6 insertions(+)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 8640094..b96ec89 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -20,12 +20,16 @@ ENV{DM_UUID}=="mpath-*", \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
 ENV{DM_MPATH}=="?*", ENV{DM_PART}!="?*", \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_MPATH}"
+ENV{DM_WWN}=="?*", ENV{DM_PART}!="?*", \
+	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}"
 
 # Create persistent links for partitions
 ENV{DM_PART}=="?*", \
         SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}-part$env{DM_PART}"
 ENV{DM_MPATH}=="?*", ENV{DM_PART}=="?*", \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_MPATH}-part$env{DM_PART}"
+ENV{DM_WWN}=="?*", ENV{DM_PART}=="?*", \
+	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}-part$env{DM_PART}"
 
 # Create dm tables for partitions
 ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index afb589c..47fab1a 100644
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -69,6 +69,7 @@ elif [ "$dmtbl" = "mpath" ] ; then
     if [ -n "$DM_NAME" -a "$DM_NAME" != "$dmuuid" ] ; then
 	echo "DM_MPATH=$dmuuid"
     fi
+    dmname="$dmuuid"
     # We need the dependencies of the table to figure out the type
     dmdeps=$($DMSETUP deps -u $UUID)
 elif [ "$dmtbl" = "dmraid" ] ; then
@@ -92,6 +93,7 @@ if [ -n "$dmdeps" ] ; then
 	    ;;
 	*)
             echo "DM_TYPE=scsi"
+	    echo "DM_WWN=0x${dmname#?}"
 	    ;;
     esac
 else
-- 
1.7.10.4
