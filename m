From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 01/10] libmultipath: remove last of rbd code
Date: Fri, 13 Jul 2018 14:39:06 -0500
Message-ID: <1531510755-16046-2-git-send-email-bmarzins@redhat.com>
References: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1531510755-16046-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

My previous patch to remove the rbd code missed a little bit.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/del-part-nodes.rules | 2 +-
 libmultipath/structs.h      | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/kpartx/del-part-nodes.rules b/kpartx/del-part-nodes.rules
index 17bc505..0ceecf5 100644
--- a/kpartx/del-part-nodes.rules
+++ b/kpartx/del-part-nodes.rules
@@ -10,7 +10,7 @@
 # or create an udev rule file that sets ENV{DONT_DEL_PART_NODES}="1".
 
 SUBSYSTEM!="block", GOTO="end_del_part_nodes"
-KERNEL!="sd*|dasd*|rbd*", GOTO="end_del_part_nodes"
+KERNEL!="sd*|dasd*", GOTO="end_del_part_nodes"
 ACTION!="add|change", GOTO="end_del_part_nodes"
 ENV{DEVTYPE}=="partition", GOTO="end_del_part_nodes"
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index e5b698b..ca14315 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -61,7 +61,6 @@ enum sysfs_buses {
 	SYSFS_BUS_IDE,
 	SYSFS_BUS_CCW,
 	SYSFS_BUS_CCISS,
-	SYSFS_BUS_RBD,
 	SYSFS_BUS_NVME,
 };
 
-- 
2.7.4
