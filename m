From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 12/14] kpartx.rules: fix by-id/scsi-* for
	user_friendly_names
Date: Fri, 12 Jan 2018 23:07:41 +0100
Message-ID: <20180112220743.11513-13-mwilck@suse.com>
References: <20180112220743.11513-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180112220743.11513-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

With user_friendly names (or generally, with aliases), the udev
rules create /dev/disk/by-id/scsi-${ALIAS} rather than
/dev/disk/by-id/scsi-${ID_SERIAL}. Fix that.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/dm-parts.rules       | 4 ++--
 kpartx/kpartx_id            | 8 +++++++-
 multipath/11-dm-mpath.rules | 3 ++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/kpartx/dm-parts.rules b/kpartx/dm-parts.rules
index 235642fd9ae3..b48b67c809d5 100644
--- a/kpartx/dm-parts.rules
+++ b/kpartx/dm-parts.rules
@@ -31,8 +31,8 @@ ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
 # DM_TYPE only has a reasonable value for partitions on multipath.
-ENV{DM_UUID}=="*-mpath-*", ENV{DM_TYPE}=="?*" \
-	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
+ENV{DM_UUID}=="*-mpath-*", ENV{DM_TYPE}=="?*", ENV{DM_SERIAL}=="?*" \
+	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_SERIAL}-part$env{DM_PART}"
 ENV{DM_WWN}=="?*", ENV{DM_PART}=="?*", \
 	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}-part$env{DM_PART}"
 
diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index b7f802d9b455..c45db2f80489 100755
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -42,6 +42,7 @@ fi
 dmuuid=${UUID#*-}
 dmtbl=${UUID%%-*}
 dmpart=${dmtbl#part}
+dmserial=
 # kpartx types are 'part<num>'
 if [ "$dmpart" = "$dmtbl" ] ; then
     dmpart=
@@ -59,10 +60,12 @@ if [ "$dmtbl" = "part" ] ; then
     case "$dmuuid" in
 	mpath-*)
 	    dmdeps=$($DMSETUP deps -u $dmuuid)
+	    dmserial=${dmuuid#mpath-}
 	    ;;
     esac
 elif [ "$dmtbl" = "mpath" ] ; then
     dmname="$dmuuid"
+    dmserial="$dmuuid"
     # We need the dependencies of the table to figure out the type
     dmdeps=$($DMSETUP deps -u $UUID)
 fi
@@ -84,11 +87,14 @@ if [ -n "$dmdeps" ] ; then
 	    ;;
 	*)
 	    echo "DM_TYPE=scsi"
-	    echo "DM_WWN=0x${dmname#?}"
+	    echo "DM_WWN=0x${dmserial#?}"
 	    ;;
     esac
 else
     echo "DM_TYPE=raid"
 fi
+if [[ $dmserial ]]; then
+    echo "DM_SERIAL=$dmserial"
+fi
 
 exit 0
diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 91d805877f0c..03ac5da22957 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -100,7 +100,8 @@ ENV{DM_UDEV_LOW_PRIORITY_FLAG}!="1", OPTIONS+="link_priority=50"
 TEST=="/usr/lib/udev/kpartx_id", \
 	IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
-ENV{DM_TYPE}=="?*", SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_NAME}"
+ENV{DM_TYPE}=="?*", ENV{DM_SERIAL}=="?*", \
+	SYMLINK+="disk/by-id/$env{DM_TYPE}-$env{DM_SERIAL}"
 ENV{DM_WWN}=="?*", SYMLINK+="disk/by-id/wwn-$env{DM_WWN}"
 
 LABEL="mpath_end"
-- 
2.15.1
