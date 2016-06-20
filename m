From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/26] libmultipath: use 'struct config' as
	argument for pathinfo()
Date: Mon, 20 Jun 2016 10:09:04 +0200
Message-ID: <1466410153-23896-18-git-send-email-hare@suse.de>
References: <1466410153-23896-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1466410153-23896-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

pathinfo() requires access to the entire configuration, not just
hwtable. So don't pretend this is the case.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 libmpathpersist/mpath_persist.c |  6 +++---
 libmultipath/configure.c        |  8 ++++----
 libmultipath/discovery.c        | 37 ++++++++++++++++++-------------------
 libmultipath/discovery.h        |  8 ++++----
 libmultipath/structs_vec.c      |  2 +-
 multipath/main.c                |  6 +++---
 multipathd/cli_handlers.c       |  2 +-
 multipathd/main.c               | 16 ++++++++--------
 8 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index dc11d4f..d557da3 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -94,16 +94,16 @@ updatepaths (struct multipath * mpp)
 					continue;
 				}
 				pp->mpp = mpp;
-				pathinfo(pp, conf->hwtable, DI_ALL);
+				pathinfo(pp, conf, DI_ALL);
 				continue;
 			}
 			pp->mpp = mpp;
 			if (pp->state == PATH_UNCHECKED ||
 					pp->state == PATH_WILD)
-				pathinfo(pp, conf->hwtable, DI_CHECKER);
+				pathinfo(pp, conf, DI_CHECKER);
 
 			if (pp->priority == PRIO_UNDEF)
-				pathinfo(pp, conf->hwtable, DI_PRIO);
+				pathinfo(pp, conf, DI_PRIO);
 		}
 	}
 	return 0;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index a0ea2fe..3e143dd 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -959,7 +959,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 				condlog(2, "%s: can't get udev device", buff);
 				return 1;
 			}
-			ret = store_pathinfo(pathvec, conf->hwtable, udevice,
+			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
 			udev_device_unref(udevice);
 			if (!pp) {
@@ -991,7 +991,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 				condlog(2, "%s: can't get udev device", dev);
 				return 1;
 			}
-			ret = store_pathinfo(pathvec, conf->hwtable, udevice,
+			ret = store_pathinfo(pathvec, conf, udevice,
 					     flags, &pp);
 			udev_device_unref(udevice);
 			if (!pp) {
@@ -1016,7 +1016,7 @@ get_refwwid (enum mpath_cmds cmd, char * dev, enum devtypes dev_type,
 			condlog(2, "%s: can't get udev device", dev);
 			return 1;
 		}
-		ret = store_pathinfo(pathvec, conf->hwtable, udevice,
+		ret = store_pathinfo(pathvec, conf, udevice,
 				     flags, &pp);
 		udev_device_unref(udevice);
 		if (!pp) {
@@ -1085,7 +1085,7 @@ extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh,
 	update_mpp_paths(mpp, vecs->pathvec);
 	if (refresh) {
 		vector_foreach_slot (mpp->paths, pp, i) {
-			r = pathinfo(pp, conf->hwtable, DI_PRIO);
+			r = pathinfo(pp, conf, DI_PRIO);
 			if (r) {
 				condlog(2, "%s: failed to refresh pathinfo",
 					mpp->alias);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index e598337..b32c57e 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -32,7 +32,7 @@
 #include "defaults.h"
 
 int
-alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
+alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 			  int flag, struct path **pp_ptr)
 {
 	int err = PATHINFO_FAILED;
@@ -55,7 +55,7 @@ alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
 		condlog(0, "pp->dev too small");
 	} else {
 		pp->udev = udev_device_ref(udevice);
-		err = pathinfo(pp, hwtable, flag | DI_BLACKLIST);
+		err = pathinfo(pp, conf, flag | DI_BLACKLIST);
 	}
 
 	if (err)
@@ -66,8 +66,8 @@ alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
 }
 
 int
-store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
-		int flag, struct path **pp_ptr)
+store_pathinfo (vector pathvec, struct config *conf,
+		struct udev_device *udevice, int flag, struct path **pp_ptr)
 {
 	int err = PATHINFO_FAILED;
 	struct path * pp;
@@ -90,7 +90,7 @@ store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
 		goto out;
 	}
 	pp->udev = udev_device_ref(udevice);
-	err = pathinfo(pp, hwtable, flag);
+	err = pathinfo(pp, conf, flag);
 	if (err)
 		goto out;
 
@@ -126,10 +126,10 @@ path_discover (vector pathvec, struct config * conf,
 
 	pp = find_path_by_dev(pathvec, (char *)devname);
 	if (!pp) {
-		return store_pathinfo(pathvec, conf->hwtable,
+		return store_pathinfo(pathvec, conf,
 				      udevice, flag, NULL);
 	}
-	return pathinfo(pp, conf->hwtable, flag);
+	return pathinfo(pp, conf, flag);
 }
 
 int
@@ -1397,7 +1397,7 @@ cciss_ioctl_pathinfo (struct path * pp, int mask)
 }
 
 int
-get_state (struct path * pp, vector hwtable, int daemon)
+get_state (struct path * pp, struct config *conf)
 {
 	struct checker * c = &pp->checker;
 	int state;
@@ -1405,8 +1405,8 @@ get_state (struct path * pp, vector hwtable, int daemon)
 	condlog(3, "%s: get_state", pp->dev);
 
 	if (!checker_selected(c)) {
-		if (daemon) {
-			if (pathinfo(pp, hwtable, DI_SYSFS) != PATHINFO_OK) {
+		if (!pp->hwe) {
+			if (pathinfo(pp, conf, DI_SYSFS) != PATHINFO_OK) {
 				condlog(3, "%s: couldn't get sysfs pathinfo",
 					pp->dev);
 				return PATH_UNCHECKED;
@@ -1425,12 +1425,11 @@ get_state (struct path * pp, vector hwtable, int daemon)
 		}
 	}
 	checker_clear_message(c);
-	if (daemon) {
-		if (conf->force_sync == 0)
-			checker_set_async(c);
-		else
-			checker_set_sync(c);
-	}
+	if (conf->force_sync == 0)
+		checker_set_async(c);
+	else
+		checker_set_sync(c);
+
 	if (!conf->checker_timeout &&
 	    sysfs_get_timeout(pp, &(c->timeout)) <= 0)
 		c->timeout = DEF_TIMEOUT;
@@ -1588,7 +1587,7 @@ get_uid (struct path * pp, int path_state)
 }
 
 extern int
-pathinfo (struct path *pp, vector hwtable, int mask)
+pathinfo (struct path *pp, struct config *conf, int mask)
 {
 	int path_state;
 
@@ -1610,7 +1609,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	/*
 	 * fetch info available in sysfs
 	 */
-	if (mask & DI_SYSFS && sysfs_pathinfo(pp, hwtable))
+	if (mask & DI_SYSFS && sysfs_pathinfo(pp, conf->hwtable))
 		return PATHINFO_FAILED;
 
 	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
@@ -1649,7 +1648,7 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 
 	if (mask & DI_CHECKER) {
 		if (path_state == PATH_UP) {
-			pp->chkrstate = pp->state = get_state(pp, hwtable, 0);
+			pp->chkrstate = pp->state = get_state(pp, conf);
 			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD)
 				goto blank;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 2619015..cfbc46c 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -34,11 +34,11 @@ int path_discovery (vector pathvec, struct config * conf, int flag);
 
 int do_tur (char *);
 int path_offline (struct path *);
-int get_state (struct path * pp, vector hwtable, int daemon);
-int pathinfo (struct path *, vector hwtable, int mask);
-int alloc_path_with_pathinfo (vector hwtable, struct udev_device *udevice,
+int get_state (struct path * pp, struct config * conf);
+int pathinfo (struct path * pp, struct config * conf, int mask);
+int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
 			      int flag, struct path **pp_ptr);
-int store_pathinfo (vector pathvec, vector hwtable,
+int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
 int sysfs_set_scsi_tmo (struct multipath *mpp, int checkint);
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 8e75504..1207a59 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -69,7 +69,7 @@ adopt_paths (vector pathvec, struct multipath * mpp)
 			if (!find_path_by_dev(mpp->paths, pp->dev) &&
 			    store_path(mpp->paths, pp))
 					return 1;
-			if (pathinfo(pp, conf->hwtable,
+			if (pathinfo(pp, conf,
 				     DI_PRIO | DI_CHECKER))
 				return 1;
 		}
diff --git a/multipath/main.c b/multipath/main.c
index df6a7ca..ca4c1f5 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -156,19 +156,19 @@ update_paths (struct multipath * mpp)
 					continue;
 				}
 				pp->mpp = mpp;
-				if (pathinfo(pp, conf->hwtable, DI_ALL))
+				if (pathinfo(pp, conf, DI_ALL))
 					pp->state = PATH_UNCHECKED;
 				continue;
 			}
 			pp->mpp = mpp;
 			if (pp->state == PATH_UNCHECKED ||
 			    pp->state == PATH_WILD) {
-				if (pathinfo(pp, conf->hwtable, DI_CHECKER))
+				if (pathinfo(pp, conf, DI_CHECKER))
 					pp->state = PATH_UNCHECKED;
 			}
 
 			if (pp->priority == PRIO_UNDEF) {
-				if (pathinfo(pp, conf->hwtable, DI_PRIO))
+				if (pathinfo(pp, conf, DI_PRIO))
 					pp->priority = PRIO_UNDEF;
 			}
 		}
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index c8c712a..90259ae 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -640,7 +640,7 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		udevice = udev_device_new_from_subsystem_sysname(udev,
 								 "block",
 								 param);
-		r = store_pathinfo(vecs->pathvec, conf->hwtable,
+		r = store_pathinfo(vecs->pathvec, conf,
 				   udevice, DI_ALL, &pp);
 		udev_device_unref(udevice);
 		if (!pp) {
diff --git a/multipathd/main.c b/multipathd/main.c
index fe80d1a..6c3efb2 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -213,7 +213,7 @@ need_switch_pathgroup (struct multipath * mpp, int refresh)
 	if (refresh)
 		vector_foreach_slot (mpp->pg, pgp, i)
 			vector_foreach_slot (pgp->paths, pp, j)
-				pathinfo(pp, conf->hwtable, DI_PRIO);
+				pathinfo(pp, conf, DI_PRIO);
 
 	if (!mpp->pg || VECTOR_SIZE(mpp->paths) == 0)
 		return 0;
@@ -590,7 +590,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 			condlog(3, "%s: reinitialize path", uev->kernel);
 			udev_device_unref(pp->udev);
 			pp->udev = udev_device_ref(uev->udev);
-			r = pathinfo(pp, conf->hwtable,
+			r = pathinfo(pp, conf,
 				     DI_ALL | DI_BLACKLIST);
 			if (r == PATHINFO_OK)
 				ret = ev_add_path(pp, vecs);
@@ -615,7 +615,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 	/*
 	 * get path vital state
 	 */
-	ret = alloc_path_with_pathinfo(conf->hwtable, uev->udev,
+	ret = alloc_path_with_pathinfo(conf, uev->udev,
 				       DI_ALL, &pp);
 	if (!pp) {
 		if (ret == PATHINFO_SKIPPED)
@@ -1344,7 +1344,7 @@ int update_prio(struct path *pp, int refresh_all)
 		vector_foreach_slot (pp->mpp->pg, pgp, i) {
 			vector_foreach_slot (pgp->paths, pp1, j) {
 				oldpriority = pp1->priority;
-				pathinfo(pp1, conf->hwtable, DI_PRIO);
+				pathinfo(pp1, conf, DI_PRIO);
 				if (pp1->priority != oldpriority)
 					changed = 1;
 			}
@@ -1352,7 +1352,7 @@ int update_prio(struct path *pp, int refresh_all)
 		return changed;
 	}
 	oldpriority = pp->priority;
-	pathinfo(pp, conf->hwtable, DI_PRIO);
+	pathinfo(pp, conf, DI_PRIO);
 
 	if (pp->priority == oldpriority)
 		return 0;
@@ -1421,20 +1421,20 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
 		newstate = PATH_DOWN;
 
 	if (newstate == PATH_UP)
-		newstate = get_state(pp, conf->hwtable, 1);
+		newstate = get_state(pp, conf);
 	else
 		checker_clear_message(&pp->checker);
 
 	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
 		condlog(2, "%s: unusable path", pp->dev);
-		pathinfo(pp, conf->hwtable, 0);
+		pathinfo(pp, conf, 0);
 		return 1;
 	}
 	if (!pp->mpp) {
 		if (!strlen(pp->wwid) && pp->initialized != INIT_MISSING_UDEV &&
 		    (newstate == PATH_UP || newstate == PATH_GHOST)) {
 			condlog(2, "%s: add missing path", pp->dev);
-			if (pathinfo(pp, conf->hwtable, DI_ALL) == 0) {
+			if (pathinfo(pp, conf, DI_ALL) == 0) {
 				ev_add_path(pp, vecs);
 				pp->tick = 1;
 			}
-- 
2.6.6
