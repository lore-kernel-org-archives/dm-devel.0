From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 18/31] 11-dm-mpath.rules: no need to test before
	IMPORT
Date: Sun,  3 Sep 2017 00:38:47 +0200
Message-ID: <20170902223900.7339-19-mwilck@suse.com>
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

This code is run before 13-dm-disk.rules which calls "blkid",
therefore the code can be simplified because the condition checked
always holds.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipath/11-dm-mpath.rules | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/multipath/11-dm-mpath.rules b/multipath/11-dm-mpath.rules
index 2e42a1bd..abf7987b 100644
--- a/multipath/11-dm-mpath.rules
+++ b/multipath/11-dm-mpath.rules
@@ -69,12 +69,12 @@ ENV{MPATH_DEVICE_READY}!="0", ENV{.MPATH_DEVICE_READY_OLD}=="0",\
 
 LABEL="scan_import"
 ENV{DM_NOSCAN}!="1", GOTO="mpath_end"
-ENV{ID_FS_TYPE}!="?*", IMPORT{db}="ID_FS_TYPE"
-ENV{ID_FS_USAGE}!="?*", IMPORT{db}="ID_FS_USAGE"
-ENV{ID_FS_UUID}!="?*", IMPORT{db}="ID_FS_UUID"
-ENV{ID_FS_UUID_ENC}!="?*", IMPORT{db}="ID_FS_UUID_ENC"
-ENV{ID_FS_LABEL}!="?*", IMPORT{db}="ID_FS_LABEL"
-ENV{ID_FS_LABEL_ENC}!="?*", IMPORT{db}="ID_FS_LABEL_ENC"
-ENV{ID_FS_VERSION}!="?*", IMPORT{db}="ID_FS_VERSION"
+IMPORT{db}="ID_FS_TYPE"
+IMPORT{db}="ID_FS_USAGE"
+IMPORT{db}="ID_FS_UUID"
+IMPORT{db}="ID_FS_UUID_ENC"
+IMPORT{db}="ID_FS_LABEL"
+IMPORT{db}="ID_FS_LABEL_ENC"
+IMPORT{db}="ID_FS_VERSION"
 
 LABEL="mpath_end"
-- 
2.14.0
