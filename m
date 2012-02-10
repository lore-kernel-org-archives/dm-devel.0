From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: cleanup dev_loss_tmo issues
Date: Fri, 10 Feb 2012 12:11:37 -0600
Message-ID: <20120210181137.GN1241@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

There are a couple of issues with the dev_loss_tmo code.  First, the
comparison between fast_io_fail and dev_loss was failing for
fast_io_fail = -1. Second, if fast_io_fail_tmo was set to off, and
dev_loss was greater than 600, dev_loss_tmo would not be set. Finally,
verify_paths was calling sysfs_set_scsi_tmo without ever calling
select_fast_io_fail.  However, this hasn't be causing problems since
setup_map is always called immediately after verify_paths, and it calls
all the select_ functions correctly.  This patch fixes all these.  Now,
if setting dev_loss_tmo fails, and fast_io_fail is set to off, it will
retry will dev_loss_tmo set to 600. Also, the calls that are duplicated
between verify_paths and setup_map have been removed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c   |   22 +++++++++++++++-------
 libmultipath/structs_vec.c |    5 -----
 2 files changed, 15 insertions(+), 12 deletions(-)

Index: multipath-tools-120123/libmultipath/discovery.c
===================================================================
--- multipath-tools-120123.orig/libmultipath/discovery.c
+++ multipath-tools-120123/libmultipath/discovery.c
@@ -299,17 +299,17 @@ sysfs_set_scsi_tmo (struct multipath *mp
 			no_path_retry_tmo = MAX_DEV_LOSS_TMO;
 		if (no_path_retry_tmo > dev_loss_tmo)
 			dev_loss_tmo = no_path_retry_tmo;
-		condlog(3, "%s: update dev_loss_tmo to %d\n",
+		condlog(3, "%s: update dev_loss_tmo to %d",
 			mpp->alias, dev_loss_tmo);
 	} else if (mpp->no_path_retry == NO_PATH_RETRY_QUEUE) {
 		dev_loss_tmo = MAX_DEV_LOSS_TMO;
-		condlog(4, "%s: update dev_loss_tmo to %d\n",
+		condlog(3, "%s: update dev_loss_tmo to %d",
 			mpp->alias, dev_loss_tmo);
 	}
 	mpp->dev_loss = dev_loss_tmo;
-	if (mpp->fast_io_fail > mpp->dev_loss) {
+	if (mpp->fast_io_fail > (int)mpp->dev_loss) {
 		mpp->fast_io_fail = mpp->dev_loss;
-		condlog(3, "%s: update fast_io_fail to %d\n",
+		condlog(3, "%s: update fast_io_fail to %d",
 			mpp->alias, mpp->fast_io_fail);
 	}
 	if (!mpp->dev_loss && !mpp->fast_io_fail)
@@ -333,9 +333,17 @@ sysfs_set_scsi_tmo (struct multipath *mp
 			snprintf(value, 11, "%u", mpp->dev_loss);
 			if (sysfs_attr_set_value(attr_path, "dev_loss_tmo",
 						 value, 11) < 0) {
-				condlog(0, "%s failed to set %s/dev_loss_tmo",
-					mpp->alias, attr_path);
-				return 1;
+				int err = 1;
+				if (mpp->fast_io_fail <= 0 && mpp->dev_loss > 600) {
+					strncpy(value, "600", 4);
+					condlog(3, "%s: limiting dev_loss_tmo to 600, since fast_io_fail is not set", mpp->alias);
+					if (sysfs_attr_set_value(attr_path, "dev_loss_tmo", value, 11) >= 0)
+						err = 0;
+				}
+				if (err) {
+					condlog(0, "%s failed to set %s/dev_loss_tmo", mpp->alias, attr_path);
+					return 1;
+				}
 			}
 		}
 		if (mpp->fast_io_fail){
Index: multipath-tools-120123/libmultipath/structs_vec.c
===================================================================
--- multipath-tools-120123.orig/libmultipath/structs_vec.c
+++ multipath-tools-120123/libmultipath/structs_vec.c
@@ -441,11 +441,6 @@ verify_paths(struct multipath * mpp, str
 	if (!mpp)
 		return 0;
 
-	select_features(mpp);
-	select_no_path_retry(mpp);
-	select_dev_loss(mpp);
-	sysfs_set_scsi_tmo(mpp);
-
 	vector_foreach_slot (mpp->paths, pp, i) {
 		/*
 		 * see if path is in sysfs
