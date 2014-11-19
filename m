From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [PATCH 4/6] add find_multipaths option
Date: Wed, 19 Nov 2014 00:17:37 -0600
Message-ID: <1416377859-15073-5-git-send-email-bmarzins@redhat.com>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
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

This patch adds a new option (find_multipaths) to the defaults section
of multipath.conf.  This is used to keep multipath from simply creating
multipath devices on top of any non-blacklisted device.  When this is
set to "yes", multipath will only create multipath devices when there
are actually multiple paths to the storage.  This means that in most
setups where find_multipaths is set, users don't need to bother with the
editting the blacklist, because multipath will do the work for them.
The only case where blacklisting is still necessary is if user want to
disable multipathing on LUNs that actually have multiple paths.

One of the issues with only grabbing devices with multiple paths is that
multipath can't know when it first sees a path device whether a second
path device will appear. This could be a problem, because if multipath
doesn't claim the device, something else might. For instance, a
filesystem could be automounted on a path device before the second path
device appeared.

Multipath deals with this by using the /etc/multipaths/wwids file.  If
the device wwid is listed in this file, multipath knows that it is a
path device, and can create a multipath device on it as soon as it
appears.  This means that after multipath has created a multipath device
once, it will automatically create it in the future as soon as the first
path is discovered.

In general, there are three conditions for find_multipaths to allow the
creation of a device. After passing all the checks that multipath
currently does to allow device creation, one of these three conditions
must also be true for device creation, if find_multipaths is enabled.

1. There are at least two non-blacklisted paths with the same wwid
2. The creation was manually forced, by specifying the device with the
   multipath command
3. The path's wwid is in the wwids file, which means that multipath has
   previously created a multipath device with that wwid.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c    |  1 +
 libmultipath/config.h    |  1 +
 libmultipath/configure.c | 11 +++++++++++
 libmultipath/defaults.h  |  1 +
 libmultipath/dict.c      |  4 ++++
 libmultipath/wwids.c     | 26 ++++++++++++++++++++++++++
 libmultipath/wwids.h     |  1 +
 multipath/main.c         | 27 +++++++++++++++++++++++++--
 multipathd/main.c        |  6 ++++++
 9 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 7f7bd5a..3c72b59 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -563,6 +563,7 @@ load_config (char * file, struct udev *udev)
 	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
 	conf->detect_prio = DEFAULT_DETECT_PRIO;
 	conf->force_sync = 0;
+	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ef1d7c3..801387c 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -116,6 +116,7 @@ struct config {
 	unsigned int dev_loss;
 	int log_checker_err;
 	int allow_queueing;
+	int find_multipaths;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 1068a0a..2a7ef55 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -740,6 +740,10 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 
 	memset(empty_buff, 0, WWID_SIZE);
 
+	/* ignore refwwid if it's empty */
+	if (refwwid && !strlen(refwwid))
+		refwwid = NULL;
+
 	if (force_reload) {
 		vector_foreach_slot (pathvec, pp1, k) {
 			pp1->mpp = NULL;
@@ -769,6 +773,13 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 		if (refwwid && strncmp(pp1->wwid, refwwid, WWID_SIZE))
 			continue;
 
+		/* If find_multipaths was selected check if the path is valid */
+		if (conf->find_multipaths && !refwwid &&
+		    !should_multipath(pp1, pathvec)) {
+			orphan_path(pp1, "only one path");
+			continue;
+		}
+
 		/*
 		 * at this point, we know we really got a new mp
 		 */
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index 99cf4b1..de6cec6 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -13,6 +13,7 @@
 #define DEFAULT_NO_PATH_RETRY  NO_PATH_RETRY_UNDEF
 #define DEFAULT_VERBOSITY	2
 #define DEFAULT_REASSIGN_MAPS	1
+#define DEFAULT_FIND_MULTIPATHS	0
 #define DEFAULT_FAST_IO_FAIL	5
 #define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_OFF
 #define DEFAULT_DETECT_PRIO DETECT_PRIO_OFF
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 737c9b0..d1e2e96 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -230,6 +230,9 @@ declare_def_snprint(reassign_maps, print_yes_no)
 declare_def_handler(multipath_dir, set_str)
 declare_def_snprint(multipath_dir, print_str)
 
+declare_def_handler(find_multipaths, set_yes_no)
+declare_def_snprint(find_multipaths, print_yes_no)
+
 declare_def_handler(selector, set_str)
 declare_def_snprint_defstr(selector, print_str, DEFAULT_SELECTOR)
 declare_hw_handler(selector, set_str)
@@ -1242,6 +1245,7 @@ init_keywords(void)
 	install_keyword("retain_attached_hw_handler", &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
 	install_keyword("detect_prio", &def_detect_prio_handler, &snprint_def_detect_prio);
 	install_keyword("force_sync", &def_force_sync_handler, &snprint_def_force_sync);
+	install_keyword("find_multipaths", &def_find_multipaths_handler, &snprint_def_find_multipaths);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_uid_attribute", &def_uid_attribute_handler, NULL);
diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
index eca1799..f6f8ea8 100644
--- a/libmultipath/wwids.c
+++ b/libmultipath/wwids.c
@@ -261,6 +261,32 @@ out:
 }
 
 int
+should_multipath(struct path *pp1, vector pathvec)
+{
+	int i;
+	struct path *pp2;
+
+	condlog(4, "checking if %s should be multipathed", pp1->dev);
+	vector_foreach_slot(pathvec, pp2, i) {
+		if (pp1->dev == pp2->dev)
+			continue;
+		if (strncmp(pp1->wwid, pp2->wwid, WWID_SIZE) == 0) {
+			condlog(3, "found multiple paths with wwid %s, "
+				"multipathing %s", pp1->wwid, pp1->dev);
+			return 1;
+		}
+	}
+	if (check_wwids_file(pp1->wwid, 0) < 0) {
+		condlog(3, "wwid %s not in wwids file, skipping %s",
+			pp1->wwid, pp1->dev);
+		return 0;
+	}
+	condlog(3, "found wwid %s in wwids file, multipathing %s", pp1->wwid,
+		pp1->dev);
+	return 1;
+}
+
+int
 remember_wwid(char *wwid)
 {
 	int ret = check_wwids_file(wwid, 1);
diff --git a/libmultipath/wwids.h b/libmultipath/wwids.h
index f3b21fa..9527012 100644
--- a/libmultipath/wwids.h
+++ b/libmultipath/wwids.h
@@ -12,6 +12,7 @@
 "#\n" \
 "# Valid WWIDs:\n"
 
+int should_multipath(struct path *pp, vector pathvec);
 int remember_wwid(char *wwid);
 int check_wwids_file(char *wwid, int write_wwid);
 int remove_wwid(char *wwid);
diff --git a/multipath/main.c b/multipath/main.c
index ea453b4..d085f64 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -197,6 +197,9 @@ get_dm_mpvec (vector curmp, vector pathvec, char * refwwid)
 			continue;
 		}
 
+		if (conf->cmd == CMD_VALID_PATH)
+			continue;
+
 		dm_get_map(mpp->alias, &mpp->size, params);
 		condlog(3, "params = %s", params);
 		dm_get_status(mpp->alias, status);
@@ -307,7 +310,13 @@ configure (void)
 			goto out;
 		}
 		condlog(3, "scope limited to %s", refwwid);
-		if (conf->cmd == CMD_VALID_PATH) {
+		/* If you are ignoring the wwids file and find_multipaths is
+		 * set, you need to actually check if there are two available
+		 * paths to determine if this path should be multipathed. To
+		 * do this, we put off the check until after discovering all
+		 * the paths */
+		if (conf->cmd == CMD_VALID_PATH &&
+		    (!conf->find_multipaths || !conf->ignore_wwids)) {
 			if (conf->ignore_wwids ||
 			    check_wwids_file(refwwid, 0) == 0)
 				r = 0;
@@ -347,6 +356,20 @@ configure (void)
 
 	filter_pathvec(pathvec, refwwid);
 
+
+	if (conf->cmd == CMD_VALID_PATH) {
+		/* This only happens if find_multipaths is and
+		 * ignore_wwids is set.
+		 * If there is currently a multipath device matching
+		 * the refwwid, or there is more than one path matching
+		 * the refwwid, then the path is valid */
+		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
+			r = 0;
+		printf("%s %s a valid multipath device path\n",
+		       conf->dev, r == 0 ? "is" : "is not");
+		goto out;
+	}
+
 	if (conf->cmd != CMD_CREATE && conf->cmd != CMD_DRY_RUN) {
 		r = 0;
 		goto out;
@@ -355,7 +378,7 @@ configure (void)
 	/*
 	 * core logic entry point
 	 */
-	r = coalesce_paths(&vecs, NULL, NULL, conf->force_reload);
+	r = coalesce_paths(&vecs, NULL, refwwid, conf->force_reload);
 
 out:
 	if (refwwid)
diff --git a/multipathd/main.c b/multipathd/main.c
index 3afed62..e697897 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -54,6 +54,7 @@
 #include <print.h>
 #include <configure.h>
 #include <prio.h>
+#include <wwids.h>
 #include <pgpolicies.h>
 #include <uevent.h>
 #include <log.h>
@@ -496,6 +497,11 @@ rescan:
 			return 1;
 		}
 
+		if (conf->find_multipaths &&
+		    !should_multipath(pp, vecs->pathvec)) {
+			orphan_path(pp, "only one path");
+			return 0;
+		}
 		condlog(4,"%s: creating new map", pp->dev);
 		if ((mpp = add_map_with_path(vecs, pp, 1))) {
 			mpp->action = ACT_CREATE;
-- 
1.8.3.1
