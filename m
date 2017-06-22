From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v4 10/11] libmultipath: don't try to set
	hwhandler if it is retained
Date: Thu, 22 Jun 2017 16:59:12 +0200
Message-ID: <20170622145913.23714-11-mwilck@suse.com>
References: <20170622145913.23714-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170622145913.23714-1-mwilck@suse.com>
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

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c |  8 +++++++-
 libmultipath/propsel.c   | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 74b6f52a..03874f47 100644
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
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d609394e..a86207a0 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -19,8 +19,10 @@
 #include "discovery.h"
 #include "dict.h"
 #include "util.h"
+#include "sysfs.h"
 #include "prioritizers/alua_rtpg.h"
 #include <inttypes.h>
+#include <libudev.h>
 
 pgpolicyfn *pgpolicies[] = {
 	NULL,
@@ -342,9 +344,42 @@ out:
 	return 0;
 }
 
+static int get_dh_state(struct path *pp, char *value, size_t value_len)
+{
+	struct udev_device *ud;
+
+	if (pp->udev == NULL)
+		return -1;
+
+	ud = udev_device_get_parent_with_subsystem_devtype(
+		pp->udev, "scsi", "scsi_device");
+	if (ud == NULL)
+		return -1;
+
+	return sysfs_attr_get_value(ud, "dh_state", value, value_len);
+}
+
 int select_hwhandler(struct config *conf, struct multipath *mp)
 {
 	char *origin;
+	struct path *pp;
+	/* dh_state is no longer than "detached" */
+	char handler[12];
+	char *dh_state;
+	int i;
+
+	dh_state = &handler[2];
+	if (mp->retain_hwhandler != RETAIN_HWHANDLER_OFF) {
+		vector_foreach_slot(mp->paths, pp, i) {
+			if (get_dh_state(pp, dh_state, sizeof(handler) - 2) > 0
+			    && strcmp(dh_state, "detached")) {
+				memcpy(handler, "1 ", 2);
+				mp->hwhandler = handler;
+				origin = "(setting: retained by kernel driver)";
+				goto out;
+			}
+		}
+	}
 
 	mp_set_hwe(hwhandler);
 	mp_set_conf(hwhandler);
-- 
2.13.1
