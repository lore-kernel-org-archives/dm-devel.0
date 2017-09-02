From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 26/31] kpartx.rules: create by-partuuid and
	by-partlabel symlinks
Date: Sun,  3 Sep 2017 00:38:55 +0200
Message-ID: <20170902223900.7339-27-mwilck@suse.com>
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

The LVM rules do this since 2.02.173 (c48149cf80 "udev: also
create /dev/disk/by-part{label,uuid} and gpt-auto-root symlinks").
We have to do it here for partitions on unaccessible mpath maps.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.rules | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kpartx/kpartx.rules b/kpartx/kpartx.rules
index 4e5a6d07..b05181a8 100644
--- a/kpartx/kpartx.rules
+++ b/kpartx/kpartx.rules
@@ -38,12 +38,18 @@ ENV{DM_UUID}!="part*-*-*", GOTO="import_end"
 ENV{ID_FS_USAGE}!="?*", IMPORT{db}="ID_FS_USAGE"
 ENV{ID_FS_UUID_ENC}!="?*", IMPORT{db}="ID_FS_UUID_ENC"
 ENV{ID_FS_LABEL_ENC}!="?*", IMPORT{db}="ID_FS_LABEL_ENC"
+ENV{ID_PART_ENTRY_NAME}!="?*", IMPORT{db}="ID_PART_ENTRY_NAME"
+ENV{ID_PART_ENTRY_UUID}!="?*", IMPORT{db}="ID_PART_ENTRY_UUID"
+ENV{ID_PART_ENTRY_SCHEME}!="?*", IMPORT{db}="ID_PART_ENTRY_SCHEME"
 LABEL="import_end"
 
 ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", \
        SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
 ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
        SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
+ENV{ID_PART_ENTRY_UUID}=="?*", SYMLINK+="disk/by-partuuid/$env{ID_PART_ENTRY_UUID}"
+ENV{ID_PART_ENTRY_SCHEME}=="gpt", ENV{ID_PART_ENTRY_NAME}=="?*", \
+       SYMLINK+="disk/by-partlabel/$env{ID_PART_ENTRY_NAME}"
 LABEL="symlink_end"
 
 # Create dm tables for partitions
-- 
2.14.0
