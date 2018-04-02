From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v3 05/20] libmultipath: trigger change uevent on
	new device creation
Date: Mon,  2 Apr 2018 21:50:36 +0200
Message-ID: <20180402195051.26854-6-mwilck@suse.com>
References: <20180402195051.26854-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180402195051.26854-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Julian Andres Klode <julian.klode@canonical.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Benjamin Marzinski <bmarzins@redhat.com>

When multipath first sees a path device with find_multipaths
enabled, it can't know if the device should be multipathed. This means
that it will not claim the device in udev.  If the device is eventually
multipathed, multipath should trigger a change uevent to update the udev
database to claim the device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/configure.c | 26 ++++++++++++++++++++++++--
 libmultipath/configure.h |  1 +
 libmultipath/wwids.c     |  2 +-
 multipath/main.c         |  2 +-
 multipathd/main.c        |  3 ++-
 5 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 16ce797..245bd11 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -442,6 +442,28 @@ trigger_udev_change(const struct multipath *mpp)
 	udev_device_unref(udd);
 }
 
+void
+trigger_paths_udev_change(const struct multipath *mpp)
+{
+	struct pathgroup * pgp;
+	struct path * pp;
+	int i, j;
+
+	if (!mpp || !mpp->pg)
+		return;
+
+	vector_foreach_slot (mpp->pg, pgp, i) {
+		if (!pgp->paths)
+			continue;
+		vector_foreach_slot(pgp->paths, pp, j) {
+			if (!pp->udev)
+				continue;
+			sysfs_attr_set_value(pp->udev, "uevent", "change",
+					     strlen("change"));
+		}
+	}
+}
+
 static int
 is_mpp_known_to_udev(const struct multipath *mpp)
 {
@@ -836,8 +858,8 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
 		 * succeeded
 		 */
 		mpp->force_udev_reload = 0;
-		if (mpp->action == ACT_CREATE)
-			remember_wwid(mpp->wwid);
+		if (mpp->action == ACT_CREATE && remember_wwid(mpp->wwid) == 1)
+			trigger_paths_udev_change(mpp);
 		if (!is_daemon) {
 			/* multipath client mode */
 			dm_switchgroup(mpp->alias, mpp->bestpg);
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 27a7e6f..545cbc2 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -37,3 +37,4 @@ int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 		 vector pathvec, char **wwid);
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
 struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
+void trigger_paths_udev_change(const struct multipath *mpp);
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index cb6ab52..ea56911 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -329,5 +329,5 @@ remember_wwid(char *wwid)
 		condlog(3, "wrote wwid %s to wwids file", wwid);
 	else
 		condlog(4, "wwid %s already in wwids file", wwid);
-	return 0;
+	return ret;
 }
diff --git a/multipath/main.c b/multipath/main.c
index 4d45df3..19c729d 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -425,7 +425,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		}
 		if (cmd == CMD_ADD_WWID) {
 			r = remember_wwid(refwwid);
-			if (r == 0)
+			if (r >= 0)
 				printf("wwid '%s' added\n", refwwid);
 			else
 				printf("failed adding '%s' to wwids file\n",
diff --git a/multipathd/main.c b/multipathd/main.c
index 707245c..da40595 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2309,7 +2309,8 @@ configure (struct vectors * vecs)
 
 	sync_maps_state(mpvec);
 	vector_foreach_slot(mpvec, mpp, i){
-		remember_wwid(mpp->wwid);
+		if (remember_wwid(mpp->wwid) == 1)
+			trigger_paths_udev_change(mpp);
 		update_map_pr(mpp);
 	}
 
-- 
2.16.1
