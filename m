From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 10/11] libmultipath: don't try to set
	hwhandler if it is retained
Date: Wed, 21 Jun 2017 17:06:29 +0200
Message-ID: <20170621150630.25773-11-mwilck@suse.com>
References: <20170621150630.25773-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170621150630.25773-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Setting a device handler only works if retain_attached_hw_handler
is 'no', or if the kernel didn't auto-assign a handler. If this
is not the case, don't even attempt to set a different handler.

This requires reading the sysfs "dh_state" path attribute.
For internal consistency, this attribute must be updated after domap().

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-
 libmultipath/discovery.c |  4 ++++
 libmultipath/propsel.c   | 15 ++++++++++++++
 libmultipath/structs.h   |  2 ++
 4 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 74b6f52a..55dbb261 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -275,15 +275,21 @@ int setup_map(struct multipath *mpp, char *params, int params_size)
 
 	/*
 	 * properties selectors
+	 *
+	 * Ordering matters for some properties:
+	 * - features after no_path_retry and retain_hwhandler
+	 * - hwhandler after retain_hwhandler
+	 * No guarantee that this list is complete, check code in
+	 * propsel.c if in doubt.
 	 */
 	conf = get_multipath_config();
 	select_pgfailback(conf, mpp);
 	select_pgpolicy(conf, mpp);
 	select_selector(conf, mpp);
-	select_hwhandler(conf, mpp);
 	select_no_path_retry(conf, mpp);
 	select_retain_hwhandler(conf, mpp);
 	select_features(conf, mpp);
+	select_hwhandler(conf, mpp);
 	select_rr_weight(conf, mpp);
 	select_minio(conf, mpp);
 	select_mode(conf, mpp);
@@ -706,6 +712,48 @@ fail:
 	return 1;
 }
 
+static void
+check_dh_state_changed(struct multipath *mp)
+{
+	struct config *conf;
+	struct path newp, *pp;
+	struct pathgroup *pg;
+	int i, j;
+
+	conf = get_multipath_config();
+
+	vector_foreach_slot (mp->pg, pg, j) {
+		vector_foreach_slot (pg->paths, pp, i) {
+			if (!pp->udev || !strlen(pp->dh_state) ||
+			    (conf->retain_hwhandler == RETAIN_HWHANDLER_ON &&
+			     strcmp(pp->dh_state, "detached")))
+				continue;
+
+			memset(&newp, 0, sizeof(newp));
+			memcpy(newp.dev, pp->dev, sizeof(newp.dev));
+			newp.udev = udev_device_ref(pp->udev);
+
+			if (pathinfo(&newp, conf, DI_SYSFS) == PATHINFO_OK) {
+				if (strncmp(newp.dh_state, pp->dh_state,
+					    SCSI_DH_SIZE)) {
+					condlog(3, "%s: dh_state changed from %s to %s",
+						pp->dev,
+						pp->dh_state,
+						newp.dh_state);
+					memcpy(pp->dh_state, newp.dh_state,
+					       SCSI_DH_SIZE);
+				}
+			} else
+				condlog(1, "%s: failed to update dh_state",
+					pp->dev);
+
+			udev_device_unref(newp.udev);
+		}
+	}
+
+	put_multipath_config(conf);
+}
+
 /*
  * Return value:
  */
@@ -828,6 +876,8 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 			}
 		}
 		dm_setgeometry(mpp);
+
+		check_dh_state_changed(mpp);
 		return DOMAP_OK;
 	}
 	return DOMAP_FAIL;
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 663c8eaa..8c0c6a9f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1188,6 +1188,10 @@ scsi_sysfs_pathinfo (struct path * pp, vector hwtable)
 	condlog(3, "%s: tgt_node_name = %s",
 		pp->dev, pp->tgt_node_name);
 
+	if (sysfs_attr_get_value(parent, "dh_state",
+				 pp->dh_state, sizeof(pp->dh_state)) >= 0)
+		condlog(3, "%s: dh_state = %s", pp->dev, pp->dh_state);
+
 	return 0;
 }
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d609394e..d1b3d416 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -345,7 +345,22 @@ out:
 int select_hwhandler(struct config *conf, struct multipath *mp)
 {
 	char *origin;
+	struct path *pp;
+	char handler[SCSI_DH_SIZE+2];
+	int i;
 
+	if (mp->retain_hwhandler != RETAIN_HWHANDLER_OFF) {
+		vector_foreach_slot(mp->paths, pp, i) {
+			if (strlen(pp->dh_state) &&
+			    strcmp(pp->dh_state, "detached")) {
+				snprintf(handler, sizeof(handler),
+					 "1 %s", pp->dh_state);
+				mp->hwhandler = handler;
+				origin = "(setting: retained by kernel driver)";
+				goto out;
+			}
+		}
+	}
 	mp_set_hwe(hwhandler);
 	mp_set_conf(hwhandler);
 	mp_set_default(hwhandler, DEFAULT_HWHANDLER);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 8ea984d9..4203e2b0 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -22,6 +22,7 @@
 #define SCSI_PRODUCT_SIZE	17
 #define SCSI_REV_SIZE		5
 #define SCSI_STATE_SIZE		19
+#define SCSI_DH_SIZE		9 /* must hold "detached" */
 
 #define NO_PATH_RETRY_UNDEF	0
 #define NO_PATH_RETRY_FAIL	-1
@@ -205,6 +206,7 @@ struct path {
 	char rev[SCSI_REV_SIZE];
 	char serial[SERIAL_SIZE];
 	char tgt_node_name[NODE_NAME_SIZE];
+	char dh_state[SCSI_DH_SIZE];
 	unsigned long long size;
 	unsigned int checkint;
 	unsigned int tick;
-- 
2.13.1
