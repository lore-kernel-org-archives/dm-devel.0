From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 1/4] multipath-tools: add rbd discovery detection
Date: Tue,  5 Jul 2016 03:12:30 -0500
Message-ID: <1467706353-16878-2-git-send-email-mchristi@redhat.com>
References: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1467706353-16878-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, christophe.varoqui@opensvc.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: dm-devel.ids

rbd is a block device interface for Ceph. It does not support
any SCSI commands, so this patch adds bus detection and virtual
vendor/product pathinfo.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 libmultipath/checkers.h  |  1 +
 libmultipath/discovery.c | 22 ++++++++++++++++++++++
 libmultipath/structs.h   |  1 +
 3 files changed, 24 insertions(+)

diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index a935b3f..ea59c94 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -84,6 +84,7 @@ enum path_check_state {
 #define EMC_CLARIION "emc_clariion"
 #define READSECTOR0  "readsector0"
 #define CCISS_TUR    "cciss_tur"
+#define RBD          "rbd"
 
 #define DEFAULT_CHECKER DIRECTIO
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 126a54f..31bb02d 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1136,6 +1136,23 @@ scsi_sysfs_pathinfo (struct path * pp)
 }
 
 static int
+rbd_sysfs_pathinfo (struct path * pp)
+{
+	sprintf(pp->vendor_id, "Ceph");
+	sprintf(pp->product_id, "RBD");
+
+	condlog(3, "%s: vendor = %s product = %s", pp->dev, pp->vendor_id,
+		pp->product_id);
+	/*
+	 * set the hwe configlet pointer
+	 */
+	pp->hwe = find_hwe(conf->hwtable, pp->vendor_id, pp->product_id, NULL);
+
+	/* should we fake host / bus / target / lun so print looks nice */
+	return 0;
+}
+
+static int
 ccw_sysfs_pathinfo (struct path * pp)
 {
 	struct udev_device *parent;
@@ -1337,6 +1354,8 @@ sysfs_pathinfo(struct path * pp)
 		pp->bus = SYSFS_BUS_CCW;
 	if (!strncmp(pp->dev,"sd", 2))
 		pp->bus = SYSFS_BUS_SCSI;
+	if (!strncmp(pp->dev,"rbd", 3))
+		pp->bus = SYSFS_BUS_RBD;
 
 	if (pp->bus == SYSFS_BUS_UNDEF)
 		return 0;
@@ -1349,6 +1368,9 @@ sysfs_pathinfo(struct path * pp)
 	} else if (pp->bus == SYSFS_BUS_CCISS) {
 		if (cciss_sysfs_pathinfo(pp))
 			return 1;
+	} else if (pp->bus == SYSFS_BUS_RBD) {
+		if (rbd_sysfs_pathinfo(pp))
+			return 1;
 	}
 	return 0;
 }
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index ab7dc25..84e56dc 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -52,6 +52,7 @@ enum sysfs_buses {
 	SYSFS_BUS_IDE,
 	SYSFS_BUS_CCW,
 	SYSFS_BUS_CCISS,
+	SYSFS_BUS_RBD,
 };
 
 enum pathstates {
-- 
2.5.5
