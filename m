From: Martin Wilck <mwilck@suse.com>
Subject: [RFC PATCH 15/16] libmultipath: trigger change uevent on
	new device creation
Date: Fri, 19 Jan 2018 01:29:15 +0100
Message-ID: <20180119002916.10323-16-mwilck@suse.com>
References: <20180119002916.10323-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180119002916.10323-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com, Benjamin Marzinski <bmarzins@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

From: Benjamin Marzinski <bmarzins@redhat.com>

When multipath first sees a path device with find_multipaths
enabled, it can't know if the device should be multipathed. This means
that it will not claim the device in udev.  If the device is eventually
multipathed, multipath should trigger a change uevent to update the udev
database to claim the device.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 26 ++++++++++++++++++++++++--
 libmultipath/configure.h |  1 +
 libmultipath/wwids.c     |  2 +-
 multipath/main.c         |  2 +-
 multipathd/main.c        |  3 ++-
 5 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 325018a78b95..c08ea5b8decc 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -433,6 +433,28 @@ trigger_udev_change(const struct multipath *mpp)
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
@@ -827,8 +849,8 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
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
index 0ffc28efdaf7..09603ba81733 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -37,3 +37,4 @@ int get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh, int is_daemon);
 int sysfs_get_host_adapter_name(struct path *pp, char *adapter_name);
 struct udev_device *get_udev_device(const char *dev, enum devtypes dev_type);
+void trigger_paths_udev_change(const struct multipath *mpp);
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index 655ccbe2c94a..098aa6f67b77 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -326,5 +326,5 @@ remember_wwid(char *wwid)
 		condlog(3, "wrote wwid %s to wwids file", wwid);
 	else
 		condlog(4, "wwid %s already in wwids file", wwid);
-	return 0;
+	return ret;
 }
diff --git a/multipath/main.c b/multipath/main.c
index c65793d5a9e9..528c3fe1f50f 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -419,7 +419,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
 		}
 		if (cmd == CMD_ADD_WWID) {
 			r = remember_wwid(refwwid);
-			if (r == 0)
+			if (r >= 0)
 				printf("wwid '%s' added\n", refwwid);
 			else
 				printf("failed adding '%s' to wwids file\n",
diff --git a/multipathd/main.c b/multipathd/main.c
index 6f612f6d3d2f..5807b42c2b2c 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2048,7 +2048,8 @@ configure (struct vectors * vecs, int start_waiters)
 
 	sync_maps_state(mpvec);
 	vector_foreach_slot(mpvec, mpp, i){
-		remember_wwid(mpp->wwid);
+		if (remember_wwid(mpp->wwid) == 1)
+			trigger_paths_udev_change(mpp);
 		update_map_pr(mpp);
 	}
 
-- 
2.15.1
