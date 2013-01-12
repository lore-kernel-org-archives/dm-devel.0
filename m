From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 16/18] multipath: Check blacklists as soon as
	possible
Date: Sat, 12 Jan 2013 00:04:53 -0600
Message-ID: <1357970695-3396-16-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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

Multipath does a lot of unnecessary work on devices blacklisted by device
type or wwid before ignoring them.  When dealing with a large number of
devices blacklisted this way, multipath can take long time to complete.
The patch makes sure that multipath is checking the blacklists as soon
as it has the necessary information to do so. To do this, pathinfo() now
takes another flag DI_BLACKLIST, which is only used by store_pathinfo(),
that tells it to check if the device should be blacklisted. Doing this
cleanly also required changing how store_pathinfo() and rlookup_binding()
are called.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/alias.c      | 47 +++++++++++++++++--------------
 libmultipath/alias.h      |  2 +-
 libmultipath/configure.c  | 70 +++++++++++++++++++++++++++++++----------------
 libmultipath/configure.h  |  2 +-
 libmultipath/discovery.c  | 47 +++++++++++++++++++++++--------
 libmultipath/discovery.h  | 11 +++++---
 libmultipath/util.c       |  2 +-
 multipath/main.c          | 14 +++++-----
 multipathd/cli_handlers.c | 11 ++++----
 multipathd/main.c         | 22 +++++++--------
 10 files changed, 140 insertions(+), 88 deletions(-)

diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index 2b42606..d913294 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -13,6 +13,9 @@
 #include "uxsock.h"
 #include "alias.h"
 #include "file.h"
+#include "vector.h"
+#include "checkers.h"
+#include "structs.h"
 
 
 /*
@@ -121,23 +124,23 @@ lookup_binding(FILE *f, char *map_wwid, char **map_alias, char *prefix)
 }
 
 static int
-rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
+rlookup_binding(FILE *f, char *buff, char *map_alias)
 {
-	char buf[LINE_MAX];
+	char line[LINE_MAX];
 	unsigned int line_nr = 0;
 	int id = 0;
 
-	*map_wwid = NULL;
+	buff[0] = '\0';
 
-	while (fgets(buf, LINE_MAX, f)) {
+	while (fgets(line, LINE_MAX, f)) {
 		char *c, *alias, *wwid;
 		int curr_id;
 
 		line_nr++;
-		c = strpbrk(buf, "#\n\r");
+		c = strpbrk(line, "#\n\r");
 		if (c)
 			*c = '\0';
-		alias = strtok(buf, " \t");
+		alias = strtok(line, " \t");
 		if (!alias) /* blank line */
 			continue;
 		curr_id = scan_devname(alias, NULL); /* TBD: Why this call? */
@@ -150,13 +153,16 @@ rlookup_binding(FILE *f, char **map_wwid, char *map_alias)
 				line_nr);
 			continue;
 		}
+		if (strlen(wwid) > WWID_SIZE - 1) {
+			condlog(3,
+				"Ignoring too large wwid at %u in bindings file", line_nr);
+			continue;
+		}
 		if (strcmp(alias, map_alias) == 0){
 			condlog(3, "Found matching alias [%s] in bindings file."
 				"\nSetting wwid to %s", alias, wwid);
-			*map_wwid = strdup(wwid);
-			if (*map_wwid == NULL)
-				condlog(0, "Cannot copy alias from bindings "
-					"file : %s", strerror(errno));
+			strncpy(buff, wwid, WWID_SIZE);
+			buff[WWID_SIZE - 1] = '\0';
 			return id;
 		}
 	}
@@ -255,36 +261,35 @@ get_user_friendly_alias(char *wwid, char *file, char *prefix,
 	return alias;
 }
 
-char *
-get_user_friendly_wwid(char *alias, char *file)
+int
+get_user_friendly_wwid(char *alias, char *buff, char *file)
 {
-	char *wwid;
-	int fd, id, unused;
+	int fd, unused;
 	FILE *f;
 
 	if (!alias || *alias == '\0') {
 		condlog(3, "Cannot find binding for empty alias");
-		return NULL;
+		return -1;
 	}
 
 	fd = open_file(file, &unused, BINDINGS_FILE_HEADER);
 	if (fd < 0)
-		return NULL;
+		return -1;
 
 	f = fdopen(fd, "r");
 	if (!f) {
 		condlog(0, "cannot fdopen on bindings file descriptor : %s",
 			strerror(errno));
 		close(fd);
-		return NULL;
+		return -1;
 	}
 
-	id = rlookup_binding(f, &wwid, alias);
-	if (id < 0) {
+	rlookup_binding(f, buff, alias);
+	if (!strlen(buff)) {
 		fclose(f);
-		return NULL;
+		return -1;
 	}
 
 	fclose(f);
-	return wwid;
+	return 0;
 }
diff --git a/libmultipath/alias.h b/libmultipath/alias.h
index c625090..8ddd0b5 100644
--- a/libmultipath/alias.h
+++ b/libmultipath/alias.h
@@ -9,4 +9,4 @@
 
 char *get_user_friendly_alias(char *wwid, char *file, char *prefix,
 			      int bindings_readonly);
-char *get_user_friendly_wwid(char *alias, char *file);
+int get_user_friendly_wwid(char *alias, char *buff, char *file);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 131b5ad..e5048eb 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -676,21 +676,32 @@ coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid, int force_r
 	return 0;
 }
 
-extern char *
-get_refwwid (char * dev, enum devtypes dev_type, vector pathvec)
+/*
+ * returns:
+ * 0 - success
+ * 1 - failure
+ * 2 - blacklist
+ */
+extern int
+get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid)
 {
+	int ret = 1;
 	struct path * pp;
 	char buff[FILE_NAME_SIZE];
 	char * refwwid = NULL, tmpwwid[WWID_SIZE];
 
+	if (!wwid)
+		return 1;
+	*wwid = NULL;
+
 	if (dev_type == DEV_NONE)
-		return NULL;
+		return 1;
 
 	if (dev_type == DEV_DEVNODE) {
 		if (basenamecpy(dev, buff, FILE_NAME_SIZE) == 0) {
 			condlog(1, "basename failed for '%s' (%s)",
 				dev, buff);
-			return NULL;
+			return 1;
 		}
 
 		pp = find_path_by_dev(pathvec, buff);
@@ -699,14 +710,16 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec)
 
 			if (!udevice) {
 				condlog(2, "%s: can't get udev device", buff);
-				return NULL;
+				return 1;
 			}
-			pp = store_pathinfo(pathvec, conf->hwtable, udevice,
-					    DI_SYSFS | DI_WWID);
+			ret = store_pathinfo(pathvec, conf->hwtable, udevice,
+					     DI_SYSFS | DI_WWID, &pp);
 			udev_device_unref(udevice);
 			if (!pp) {
-				condlog(0, "%s can't store path info", buff);
-				return NULL;
+				if (ret == 1)
+					condlog(0, "%s can't store path info",
+						buff);
+				return ret;
 			}
 		}
 		refwwid = pp->wwid;
@@ -721,14 +734,16 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec)
 
 			if (!udevice) {
 				condlog(2, "%s: can't get udev device", dev);
-				return NULL;
+				return 1;
 			}
-			pp = store_pathinfo(pathvec, conf->hwtable, udevice,
-					    DI_SYSFS | DI_WWID);
+			ret = store_pathinfo(pathvec, conf->hwtable, udevice,
+					     DI_SYSFS | DI_WWID, &pp);
 			udev_device_unref(udevice);
 			if (!pp) {
-				condlog(0, "%s can't store path info", buff);
-				return NULL;
+				if (ret == 1)
+					condlog(0, "%s can't store path info",
+						buff);
+				return ret;
 			}
 		}
 		refwwid = pp->wwid;
@@ -738,17 +753,17 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec)
 
 		if (((dm_get_uuid(dev, tmpwwid)) == 0) && (strlen(tmpwwid))) {
 			refwwid = tmpwwid;
-			goto out;
+			goto check;
 		}
 
 		/*
 		 * may be a binding
 		 */
-		refwwid = get_user_friendly_wwid(dev,
-						 conf->bindings_file);
-
-		if (refwwid)
-			return refwwid;
+		if (get_user_friendly_wwid(dev, tmpwwid,
+					   conf->bindings_file) == 0) {
+			refwwid = tmpwwid;
+			goto check;
+		}
 
 		/*
 		 * or may be an alias
@@ -760,12 +775,21 @@ get_refwwid (char * dev, enum devtypes dev_type, vector pathvec)
 		 */
 		if (!refwwid)
 			refwwid = dev;
+
+check:
+		if (refwwid && strlen(refwwid)) {
+			if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
+					refwwid) > 0)
+			return 2;
+		}
 	}
 out:
-	if (refwwid && strlen(refwwid))
-		return STRDUP(refwwid);
+	if (refwwid && strlen(refwwid)) {
+		*wwid = STRDUP(refwwid);
+		return 0;
+	}
 
-	return NULL;
+	return 1;
 }
 
 extern int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh)
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index d13c0ac..650f080 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -27,6 +27,6 @@ int setup_map (struct multipath * mpp, char * params, int params_size );
 int domap (struct multipath * mpp, char * params);
 int reinstate_paths (struct multipath *mpp);
 int coalesce_paths (struct vectors *vecs, vector curmp, char * refwwid, int force_reload);
-char * get_refwwid (char * dev, enum devtypes dev_type, vector pathvec);
+int get_refwwid (char * dev, enum devtypes dev_type, vector pathvec, char **wwid);
 int reload_map(struct vectors *vecs, struct multipath *mpp, int refresh);
 
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 45570dc..b8a5cd1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -28,37 +28,45 @@
 #include "prio.h"
 #include "defaults.h"
 
-struct path *
+int
 store_pathinfo (vector pathvec, vector hwtable, struct udev_device *udevice,
-		int flag)
+		int flag, struct path **pp_ptr)
 {
+	int err = 1;
 	struct path * pp;
 	const char * devname;
 
+	if (pp_ptr)
+		*pp_ptr = NULL;
+
 	devname = udev_device_get_sysname(udevice);
 	if (!devname)
-		return NULL;
+		return 1;
 
 	pp = alloc_path();
 
 	if (!pp)
-		return NULL;
+		return 1;
 
 	if(safe_sprintf(pp->dev, "%s", devname)) {
 		condlog(0, "pp->dev too small");
 		goto out;
 	}
 	pp->udev = udev_device_ref(udevice);
-	if (pathinfo(pp, hwtable, flag))
+	err = pathinfo(pp, hwtable, flag | DI_BLACKLIST);
+	if (err)
 		goto out;
 
-	if (store_path(pathvec, pp))
+	err = store_path(pathvec, pp);
+	if (err)
 		goto out;
 
-	return pp;
 out:
-	free_path(pp);
-	return NULL;
+	if (err)
+		free_path(pp);
+	else if (pp_ptr)
+		*pp_ptr = pp;
+	return err;
 }
 
 static int
@@ -78,9 +86,11 @@ path_discover (vector pathvec, struct config * conf,
 
 	pp = find_path_by_dev(pathvec, (char *)devname);
 	if (!pp) {
-		pp = store_pathinfo(pathvec, conf->hwtable,
-				    udevice, flag);
-		return (pp ? 0 : 1);
+		if (store_pathinfo(pathvec, conf->hwtable,
+				   udevice, flag, NULL) != 1)
+			return 0;
+		else
+			return 1;
 	}
 	return pathinfo(pp, conf->hwtable, flag);
 }
@@ -857,6 +867,13 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 	if (mask & DI_SYSFS && sysfs_pathinfo(pp))
 		return 1;
 
+	if (mask & DI_BLACKLIST && mask & DI_SYSFS) {
+		if (filter_device(conf->blist_device, conf->elist_device,
+				  pp->vendor_id, pp->product_id) > 0) {
+			return 2;
+		}
+	}
+
 	path_state = path_offline(pp);
 
 	/*
@@ -896,6 +913,12 @@ pathinfo (struct path *pp, vector hwtable, int mask)
 
 	if (path_state == PATH_UP && (mask & DI_WWID) && !strlen(pp->wwid))
 		get_uid(pp);
+	if (mask & DI_BLACKLIST && mask & DI_WWID) {
+		if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
+				pp->wwid) > 0) {
+			return 2;
+		}
+	}
 
 	 /*
 	  * Retrieve path priority, even for PATH_DOWN paths if it has never
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index 17108c7..1a614ee 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -33,8 +33,9 @@ int do_tur (char *);
 int path_offline (struct path *);
 int get_state (struct path * pp, int daemon);
 int pathinfo (struct path *, vector hwtable, int mask);
-struct path * store_pathinfo (vector pathvec, vector hwtable,
-			      struct udev_device *udevice, int flag);
+int store_pathinfo (vector pathvec, vector hwtable,
+		    struct udev_device *udevice, int flag,
+		    struct path **pp_ptr);
 int sysfs_set_scsi_tmo (struct multipath *mpp);
 int sysfs_get_timeout(struct path *pp, unsigned int *timeout);
 
@@ -46,14 +47,16 @@ enum discovery_mode {
 	__DI_SERIAL,
 	__DI_CHECKER,
 	__DI_PRIO,
-	__DI_WWID
+	__DI_WWID,
+	__DI_BLACKLIST,
 };
 
 #define DI_SYSFS	(1 << __DI_SYSFS)
 #define DI_SERIAL	(1 << __DI_SERIAL)
 #define DI_CHECKER	(1 << __DI_CHECKER)
 #define DI_PRIO		(1 << __DI_PRIO)
-#define DI_WWID 	(1 << __DI_WWID)
+#define DI_WWID		(1 << __DI_WWID)
+#define DI_BLACKLIST	(1 << __DI_BLACKLIST)
 
 #define DI_ALL		(DI_SYSFS  | DI_SERIAL | DI_CHECKER | DI_PRIO | \
 			 DI_WWID)
diff --git a/libmultipath/util.c b/libmultipath/util.c
index 3ac018c..41ac21b 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -27,7 +27,7 @@ basenamecpy (const char * str1, char * str2, int str2len)
 	if (!str1 || !strlen(str1))
 		return 0;
 
-	if (strlen(str1) > str2len)
+	if (strlen(str1) >= str2len)
 		return 0;
 
 	if (!str2)
diff --git a/multipath/main.c b/multipath/main.c
index e526f7c..5d5a6f8 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -262,7 +262,7 @@ configure (void)
 	/*
 	 * if we have a blacklisted device parameter, exit early
 	 */
-	if (dev &&
+	if (dev && conf->dev_type == DEV_DEVNODE &&
 	    (filter_devnode(conf->blist_devnode,
 			    conf->elist_devnode, dev) > 0)) {
 		if (conf->dry_run == 2)
@@ -275,16 +275,16 @@ configure (void)
 	 * failing the translation is fatal (by policy)
 	 */
 	if (conf->dev) {
-		refwwid = get_refwwid(conf->dev, conf->dev_type, pathvec);
-
+		int failed = get_refwwid(conf->dev, conf->dev_type, pathvec,
+					 &refwwid);
 		if (!refwwid) {
-			condlog(3, "scope is nul");
+			if (failed == 2 && conf->dry_run == 2)
+				printf("%s is not a valid multipath device path\n", conf->dev);
+			else
+				condlog(3, "scope is nul");
 			goto out;
 		}
 		condlog(3, "scope limited to %s", refwwid);
-		if (filter_wwid(conf->blist_wwid, conf->elist_wwid,
-				refwwid) > 0)
-			goto out;
 		if (conf->dry_run == 2) {
 			if (check_wwids_file(refwwid, 0) == 0){
 				printf("%s is a valid multipath device path\n", conf->dev);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 4df37fe..a1e4bde 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -433,19 +433,18 @@ cli_add_path (void * v, char ** reply, int * len, void * data)
 		udevice = udev_device_new_from_subsystem_sysname(conf->udev,
 								 "block",
 								 param);
-		pp = store_pathinfo(vecs->pathvec, conf->hwtable,
-				    udevice, DI_ALL);
+		r = store_pathinfo(vecs->pathvec, conf->hwtable,
+				   udevice, DI_ALL, &pp);
 		udev_device_unref(udevice);
 		if (!pp) {
+			if (r == 2)
+				goto blacklisted;
 			condlog(0, "%s: failed to store path info", param);
 			return 1;
 		}
 		pp->checkint = conf->checkint;
 	}
-	r = ev_add_path(pp, vecs);
-	if (r == 2)
-		goto blacklisted;
-	return r;
+	return ev_add_path(pp, vecs);
 blacklisted:
 	*reply = strdup("blacklisted\n");
 	*len = strlen(*reply) + 1;
diff --git a/multipathd/main.c b/multipathd/main.c
index a6afebb..8c0866d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -299,7 +299,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 		condlog(2, "%s: devmap %s registered", alias, dev);
 		return 0;
 	}
-	refwwid = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec);
+	r = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec, &refwwid);
 
 	if (refwwid) {
 		r = coalesce_paths(vecs, NULL, refwwid, 0);
@@ -308,6 +308,8 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 
 	if (!r)
 		condlog(2, "%s: devmap %s added", alias, dev);
+	else if (r == 2)
+		condlog(2, "%s: uev_add_map %s blacklisted", alias, dev);
 	else
 		condlog(0, "%s: uev_add_map %s failed", alias, dev);
 
@@ -373,6 +375,7 @@ static int
 uev_add_path (struct uevent *uev, struct vectors * vecs)
 {
 	struct path *pp;
+	int ret;
 
 	condlog(2, "%s: add path (uevent)", uev->kernel);
 	if (strstr(uev->kernel, "..") != NULL) {
@@ -393,8 +396,11 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		/*
 		 * get path vital state
 		 */
-		if (!(pp = store_pathinfo(vecs->pathvec, conf->hwtable,
-					  uev->udev, DI_ALL))) {
+		ret = store_pathinfo(vecs->pathvec, conf->hwtable,
+				     uev->udev, DI_ALL, &pp);
+		if (!pp) {
+			if (ret == 2)
+				return 0;
 			condlog(0, "%s: failed to store path info",
 				uev->kernel);
 			return 1;
@@ -402,14 +408,13 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		pp->checkint = conf->checkint;
 	}
 
-	return (ev_add_path(pp, vecs) != 1)? 0 : 1;
+	return ev_add_path(pp, vecs);
 }
 
 /*
  * returns:
  * 0: added
  * 1: error
- * 2: blacklisted
  */
 int
 ev_add_path (struct path * pp, struct vectors * vecs)
@@ -427,13 +432,6 @@ ev_add_path (struct path * pp, struct vectors * vecs)
 		condlog(0, "%s: failed to get path uid", pp->dev);
 		goto fail; /* leave path added to pathvec */
 	}
-	if (filter_path(conf, pp) > 0){
-		int i = find_slot(vecs->pathvec, (void *)pp);
-		if (i != -1)
-			vector_del_slot(vecs->pathvec, i);
-		free_path(pp);
-		return 2;
-	}
 	mpp = pp->mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
 rescan:
 	if (mpp) {
-- 
1.8.0
