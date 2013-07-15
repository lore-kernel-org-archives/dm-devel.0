From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/29] kpartx: create correct symlinks for
	PATH_FAILED events
Date: Mon, 15 Jul 2013 15:00:09 +0200
Message-ID: <1373893230-26077-9-git-send-email-hare@suse.de>
References: <1373893230-26077-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1373893230-26077-1-git-send-email-hare@suse.de>
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

The kernel is sending out PATH_FAILED/PATH_REINSTATED events,
upon each of which we need to regenerate the existing symlinks.
However, for an all-paths-down scenario we cannot read from
the disk, so we cannot execute blkid or kpartx.
For these cases we need to import the existing data from the
udev database.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/kpartx.rules |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index b96ec89..5c0d0ff 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -8,11 +8,16 @@ KERNEL!="dm-*", GOTO="kpartx_end"
 ACTION=="remove", GOTO="kpartx_end"
 
 ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
-ENV{DM_ACTION}=="PATH_FAILED|PATH_REINSTATED", GOTO="kpartx_end"
 ENV{DM_DEPS}=="0", GOTO="kpartx_end"
 
 ENV{DM_UUID}=="?*", IMPORT{program}=="kpartx_id %M %m $env{DM_UUID}"
 
+ENV{DM_ACTION}=="PATH_FAILED", ENV{DM_NR_VALID_PATHS}=="0", \
+	GOTO="blkid_end"
+ENV{DM_UUID}=="mpath-*", IMPORT{program}="/sbin/blkid -o udev -p $tempnode"
+ENV{DM_PART}=="?*", IMPORT{program}="/sbin/blkid -o udev -p $tempnode"
+LABEL="blkid_end"
+
 OPTIONS="link_priority=50"
 
 # Create persistent links for multipath tables
@@ -31,7 +36,18 @@ ENV{DM_MPATH}=="?*", ENV{DM_PART}=="?*", \
 ENV{DM_WWN}=="?*", ENV{DM_PART}=="?*", \
 	SYMLINK+="disk/by-id/wwn-$env{DM_WWN}-part$env{DM_PART}"
 
+# Create persistent by-label/by-uuid links
+ENV{ID_FS_USAGE}=="?*", IMPORT{db}="ID_FS_USAGE"
+ENV{ID_FS_UUID_ENC}=="?*", IMPORT{db}="ID_FS_UUID_ENC"
+ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", \
+	SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
+ENV{ID_FS_LABEL_ENC}=="?*", IMPORT{db}="ID_FS_LABEL_ENC"
+ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
+	SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
+
 # Create dm tables for partitions
+ENV{DM_ACTION}=="PATH_FAILED", ENV{DM_NR_VALID_PATHS}=="0", \
+	GOTO="kpartx_end"
 ENV{DM_STATE}!="SUSPENDED", ENV{DM_UUID}=="mpath-*", \
         RUN+="/sbin/kpartx -u -p -part /dev/$name"
 
-- 
1.7.10.4
