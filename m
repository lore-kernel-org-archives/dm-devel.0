From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 01/57] kpartx: Fixup persistent name generation
Date: Wed, 27 Apr 2016 13:10:02 +0200
Message-ID: <1461755458-29225-2-git-send-email-hare@suse.de>
References: <1461755458-29225-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1461755458-29225-1-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

kpartx_id would overwrite the 'DM_NAME' variable, which were
causing things to break later on. Seeing that kpartx_id is
only ever used to generate persistent device names I've updated
kpartx_id and kpartx.rules to rely on existing variables where
possible, avoiding any accidental overwrite of existing variables.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.rules | 11 +++--------
 kpartx/kpartx_id    | 11 +----------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 022361f..f6a3706 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -14,19 +14,14 @@ ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
 OPTIONS="link_priority=50"
 
-# Create persistent links for multipath tables
-ENV{DM_UUID}=="mpath-*", \
+ENV{DM_UUID}=="?*", ENV{DM_TYPE}=="?*" \
 	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
-ENV{DM_MPATH}=="?*", ENV{DM_PART}!="?*", \
-	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_MPATH}"
+
+# Create persistent links for multipath tables
 ENV{DM_WWN}=="?*", ENV{DM_PART}!="?*", \
 	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}"
 
 # Create persistent links for partitions
-ENV{DM_PART}=="?*", \
-        SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}-part$env{DM_PART}"
-ENV{DM_MPATH}=="?*", ENV{DM_PART}=="?*", \
-	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_MPATH}-part$env{DM_PART}"
 ENV{DM_WWN}=="?*", ENV{DM_PART}=="?*", \
 	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}-part$env{DM_PART}"
 
diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index 517b856..df0e6b9 100644
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -52,12 +52,8 @@ fi
 # Set the name of the table. We're only interested in dmraid,
 # multipath, and kpartx tables; everything else is ignored.
 if [ "$dmtbl" = "part" ] ; then
-    # The name of the kpartx table is the name of the parent table
     dmname=$($DMSETUP info  -c --noheadings -o name -u $dmuuid)
-    echo "DM_NAME=$dmname"
-    if [ "$dmname" != ${dmuuid#mpath-} ] ; then
-	echo "DM_MPATH=${dmuuid#mpath-}"
-    fi
+    echo "DM_MPATH=$dmname"
     # We need the dependencies of the parent table to figure out
     # the type if the parent is a multipath table
     case "$dmuuid" in
@@ -66,14 +62,9 @@ if [ "$dmtbl" = "part" ] ; then
 	    ;;
     esac
 elif [ "$dmtbl" = "mpath" ] ; then
-    if [ -n "$DM_NAME" -a "$DM_NAME" != "$dmuuid" ] ; then
-	echo "DM_MPATH=$dmuuid"
-    fi
     dmname="$dmuuid"
     # We need the dependencies of the table to figure out the type
     dmdeps=$($DMSETUP deps -u $UUID)
-elif [ "$dmtbl" = "dmraid" ] ; then
-    dmname=$tblname
 fi
 
 [ -n "$dmpart" ] && echo "DM_PART=$dmpart"
-- 
2.6.6
