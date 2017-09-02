From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 25/31] kpartx.rules: improved logic for by-uuid
	and by-label links
Date: Sun,  3 Sep 2017 00:38:54 +0200
Message-ID: <20170902223900.7339-26-mwilck@suse.com>
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

If blkid can be run, these links are already set up by 13-dm-disk.rules.
In the DM_NOSCAN=1 case, they are imported from db in 11-dm-mpath.rules
for multipath maps, but not for partitions (there is currently no flag
for kpartx-generated partitions that indicates whether the device will
be able to do IO).

Moreover, the previous logic for running IMPORT{db} was wrong (condition
used '=="?*"' rather than '!="?*"').

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index efd21a29..4e5a6d07 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -25,14 +25,26 @@ ENV{DM_WWN}=="?*", ENV{DM_PART}!="?*", \
 ENV{DM_WWN}=="?*", ENV{DM_PART}=="?*", \
 	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}-part$env{DM_PART}"
 
-# Create persistent by-label/by-uuid links
-ENV{ID_FS_USAGE}=="?*", IMPORT{db}="ID_FS_USAGE"
-ENV{ID_FS_UUID_ENC}=="?*", IMPORT{db}="ID_FS_UUID_ENC"
+# Create persistent by-label/by-uuid links.
+# multipath maps with DM_NOSCAN!=1 are handled in 13-dm-disk.rules.
+DM_UUID=="mpath-*", ENV{DM_NOSCAN}!="1", GOTO="symlink_end"
+
+# For partitions, we don't have DM_NOSCAN.
+# Simply load variables from db if they aren't set.
+# 11-dm-mpath.rules does this for mpath maps.
+# Fixme: we have currently no way to avoid calling blkid on
+# partitions of broken mpath maps.
+ENV{DM_UUID}!="part*-*-*", GOTO="import_end"
+ENV{ID_FS_USAGE}!="?*", IMPORT{db}="ID_FS_USAGE"
+ENV{ID_FS_UUID_ENC}!="?*", IMPORT{db}="ID_FS_UUID_ENC"
+ENV{ID_FS_LABEL_ENC}!="?*", IMPORT{db}="ID_FS_LABEL_ENC"
+LABEL="import_end"
+
 ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", \
-	SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
-ENV{ID_FS_LABEL_ENC}=="?*", IMPORT{db}="ID_FS_LABEL_ENC"
+       SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
 ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
-	SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
+       SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
+LABEL="symlink_end"
 
 # Create dm tables for partitions
 ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", GOTO="kpartx_end"
-- 
2.14.0
