From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/16] Simplify uevent processing
Date: Mon, 30 Apr 2012 12:26:06 +0200
Message-ID: <1335781568-13299-16-git-send-email-hare@suse.de>
References: <1335781568-13299-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1335781568-13299-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: dm-devel@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

We can get all sort of information from the udev device, so we
don't need to add our own fields here.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 libmultipath/blacklist.c |   28 +++++----
 libmultipath/blacklist.h |    8 +-
 libmultipath/discovery.c |   14 ++++-
 libmultipath/structs.c   |    2 +-
 libmultipath/structs.h   |    2 +-
 libmultipath/uevent.c    |  139 ++++++++++++++-------------------------------
 libmultipath/uevent.h    |    5 --
 multipathd/main.c        |   97 +++++++++++++-------------------
 multipathd/main.h        |    4 +-
 9 files changed, 117 insertions(+), 182 deletions(-)

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index f369517..7807482 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -140,7 +140,7 @@ setup_default_blist (struct config * conf)
 }
 
 int
-_blacklist_exceptions (vector elist, char * str)
+_blacklist_exceptions (vector elist, const char * str)
 {
 	int i;
 	struct blentry * ele;
@@ -153,7 +153,7 @@ _blacklist_exceptions (vector elist, char * str)
 }
 
 int
-_blacklist (vector blist, char * str)
+_blacklist (vector blist, const char * str)
 {
 	int i;
 	struct blentry * ble;
@@ -166,7 +166,8 @@ _blacklist (vector blist, char * str)
 }
 
 int
-_blacklist_exceptions_device(vector elist, char * vendor, char * product)
+_blacklist_exceptions_device(vector elist, const char * vendor,
+			     const char * product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -180,7 +181,7 @@ _blacklist_exceptions_device(vector elist, char * vendor, char * product)
 }
 
 int
-_blacklist_device (vector blist, char * vendor, char * product)
+_blacklist_device (vector blist, const char * vendor, const char * product)
 {
 	int i;
 	struct blentry_device * ble;
@@ -202,7 +203,8 @@ _blacklist_device (vector blist, char * vendor, char * product)
 		condlog(3, "%s: %s", dev, (M))
 
 void
-log_filter (char *dev, char *vendor, char *product, char *wwid, int r)
+log_filter (const char *dev, const char *vendor, const char *product,
+	    const char *wwid, int r)
 {
 	/*
 	 * Try to sort from most likely to least.
@@ -232,7 +234,8 @@ log_filter (char *dev, char *vendor, char *product, char *wwid, int r)
 }
 
 int
-_filter_device (vector blist, vector elist, char * vendor, char * product)
+_filter_device (vector blist, vector elist,
+		const char * vendor, const char * product)
 {
 	if (!vendor || !product)
 		return 0;
@@ -244,7 +247,8 @@ _filter_device (vector blist, vector elist, char * vendor, char * product)
 }
 
 int
-filter_device (vector blist, vector elist, char * vendor, char * product)
+filter_device (vector blist, vector elist,
+	       const char * vendor, const char * product)
 {
 	int r = _filter_device(blist, elist, vendor, product);
 	log_filter(NULL, vendor, product, NULL, r);
@@ -252,7 +256,7 @@ filter_device (vector blist, vector elist, char * vendor, char * product)
 }
 
 int
-_filter_devnode (vector blist, vector elist, char * dev)
+_filter_devnode (vector blist, vector elist, const char * dev)
 {
 	if (!dev)
 		return 0;
@@ -264,7 +268,7 @@ _filter_devnode (vector blist, vector elist, char * dev)
 }
 
 int
-filter_devnode (vector blist, vector elist, char * dev)
+filter_devnode (vector blist, vector elist, const char * dev)
 {
 	int r = _filter_devnode(blist, elist, dev);
 	log_filter(dev, NULL, NULL, NULL, r);
@@ -272,7 +276,7 @@ filter_devnode (vector blist, vector elist, char * dev)
 }
 
 int
-_filter_wwid (vector blist, vector elist, char * wwid)
+_filter_wwid (vector blist, vector elist, const char * wwid)
 {
 	if (!wwid)
 		return 0;
@@ -284,7 +288,7 @@ _filter_wwid (vector blist, vector elist, char * wwid)
 }
 
 int
-filter_wwid (vector blist, vector elist, char * wwid)
+filter_wwid (vector blist, vector elist, const char * wwid)
 {
 	int r = _filter_wwid(blist, elist, wwid);
 	log_filter(NULL, NULL, NULL, wwid, r);
@@ -327,7 +331,7 @@ free_blacklist (vector blist)
 	vector_foreach_slot (blist, ble, i) {
 		if (ble) {
 			regfree(&ble->regex);
-			FREE(ble->str);
+			FREE((char *)ble->str);
 			FREE(ble);
 		}
 	}
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index cdbebef..937c98d 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -12,7 +12,7 @@
 #define MATCH_DEVNODE_BLIST_EXCEPT -MATCH_DEVNODE_BLIST
 
 struct blentry {
-	char * str;
+	const char * str;
 	regex_t regex;
 	int origin;
 };
@@ -27,9 +27,9 @@ struct blentry_device {
 
 int setup_default_blist (struct config *);
 int alloc_ble_device (vector);
-int filter_devnode (vector, vector, char *);
-int filter_wwid (vector, vector, char *);
-int filter_device (vector, vector, char *, char *);
+int filter_devnode (vector, vector, const char *);
+int filter_wwid (vector, vector, const char *);
+int filter_device (vector, vector, const char *, const char *);
 int filter_path (struct config *, struct path *);
 int store_ble (vector, char *, int);
 int set_ble_device (vector, char *, char *, int);
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 7adda2a..d666bfe 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -104,6 +104,8 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 
 	udev_list_entry_foreach(entry,
 				udev_enumerate_get_list_entry(udev_iter)) {
+		const char *sysname;
+
 		devpath = udev_list_entry_get_name(entry);
 		condlog(4, "Discover device %s", devpath);
 		udevice = udev_device_new_from_syspath(conf->udev, devpath);
@@ -112,8 +114,16 @@ path_discovery (vector pathvec, struct config * conf, int flag)
 			r++;
 			continue;
 		}
-		if(!strncmp(udev_device_get_devtype(udevice), "disk", 4))
-			r += path_discover(pathvec, conf, udevice, flag);
+		sysname = udev_device_get_sysname(udevice);
+		if (strncmp(udev_device_get_devtype(udevice), "disk", 4)) {
+			condlog(4, "%s: Ignore non-disk device", sysname);
+			continue;
+		}
+		if (udev_device_get_sysattr_value(udevice, "partition")) {
+			condlog(4, "%s: Ignore partition", sysname);
+			continue;
+		}
+		r += path_discover(pathvec, conf, udevice, flag);
 		udev_device_unref(udevice);
 	}
 	udev_enumerate_unref(udev_iter);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 3c0fe90..f0f1b60 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -308,7 +308,7 @@ find_mp_by_str (vector mpvec, char * str)
 }
 
 struct path *
-find_path_by_dev (vector pathvec, char * dev)
+find_path_by_dev (vector pathvec, const char * dev)
 {
 	int i;
 	struct path * pp;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 4f643ef..a497896 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -246,7 +246,7 @@ struct multipath * find_mp_by_str (vector mp, char * wwid);
 struct multipath * find_mp_by_minor (vector mp, int minor);
 	
 struct path * find_path_by_devt (vector pathvec, char * devt);
-struct path * find_path_by_dev (vector pathvec, char * dev);
+struct path * find_path_by_dev (vector pathvec, const char * dev);
 struct path * first_path (struct multipath * mpp);
 
 int pathcountgr (struct pathgroup *, int);
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 5450dd7..c1d45b0 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -34,7 +34,7 @@
 #include <sys/socket.h>
 #include <sys/user.h>
 #include <sys/un.h>
-#include <linux/types.h>
+#include <sys/types.h>
 #include <linux/netlink.h>
 #include <pthread.h>
 #include <limits.h>
@@ -217,65 +217,28 @@ int uevent_listen(void)
 		goto out;
 	}
 	while (1) {
-		int i = 0;
-		char *pos, *end;
 		struct uevent *uev;
 		struct udev_device *dev;
-		struct udev_list_entry *list_entry;
 
 		dev = udev_monitor_receive_device(monitor);
 		if (!dev) {
 			condlog(0, "failed getting udev device");
 			continue;
 		}
-
+		if (udev_device_get_sysattr_value(dev, "partition")) {
+			condlog(3, "Ignoring partition uevent");
+			continue;
+		}
 		uev = alloc_uevent();
 		if (!uev) {
 			condlog(1, "lost uevent, oom");
 			continue;
 		}
-		pos = uev->buffer;
-		end = pos + HOTPLUG_BUFFER_SIZE + OBJECT_SIZE - 1;
-		udev_list_entry_foreach(list_entry,
-					udev_device_get_properties_list_entry(dev)) {
-			const char *name, *value;
-			int bytes;
-
-			name = udev_list_entry_get_name(list_entry);
-			if (!name)
-				name = "(null)";
-			value = udev_list_entry_get_value(list_entry);
-			if (!value)
-				value = "(null)";
-			bytes = snprintf(pos, end - pos, "%s=%s", name,
-					value);
-			if (pos + bytes >= end) {
-				condlog(2, "buffer overflow for uevent");
-				break;
-			}
-			uev->envp[i] = pos;
-			pos += bytes;
-			*pos = '\0';
-			pos++;
-			if (strcmp(name, "DEVPATH") == 0)
-				uev->devpath = uev->envp[i] + 8;
-			if (strcmp(name, "ACTION") == 0)
-				uev->action = uev->envp[i] + 7;
-			i++;
-			if (i == HOTPLUG_NUM_ENVP - 1)
-				break;
-		}
 		uev->udev = dev;
-		uev->envp[i] = NULL;
 
-		condlog(3, "uevent '%s' from '%s'", uev->action, uev->devpath);
-		uev->kernel = strrchr(uev->devpath, '/');
-		if (uev->kernel)
-			uev->kernel++;
-
-		/* print payload environment */
-		for (i = 0; uev->envp[i] != NULL; i++)
-			condlog(5, "%s", uev->envp[i]);
+		condlog(3, "uevent '%s' from '%s'",
+			udev_device_get_action(dev),
+			udev_device_get_devpath(dev));
 
 		/*
 		 * Queue uevent and poke service pthread.
@@ -297,58 +260,43 @@ out:
 extern int
 uevent_get_major(struct uevent *uev)
 {
-	char *p, *q;
-	int i, major = -1;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "MAJOR", 5) && strlen(uev->envp[i]) > 6) {
-			p = uev->envp[i] + 6;
-			major = strtoul(p, &q, 10);
-			if (p == q) {
-				condlog(2, "invalid major '%s'", p);
-				major = -1;
-			}
-			break;
-		}
+	dev_t dev_devt;
+	int m = 0;
+
+	if (uev->udev) {
+		dev_devt = udev_device_get_devnum(uev->udev);
+		m = major(dev_devt);
 	}
-	return major;
+	return m;
 }
 
 extern int
 uevent_get_minor(struct uevent *uev)
 {
-	char *p, *q;
-	int i, minor = -1;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "MINOR", 5) && strlen(uev->envp[i]) > 6) {
-			p = uev->envp[i] + 6;
-			minor = strtoul(p, &q, 10);
-			if (p == q) {
-				condlog(2, "invalid minor '%s'", p);
-				minor = -1;
-			}
-			break;
-		}
+	dev_t dev_devt;
+	int m = 0;
+
+	if (uev->udev) {
+		dev_devt = udev_device_get_devnum(uev->udev);
+		m = minor(dev_devt);
 	}
-	return minor;
+	return m;
 }
 
 extern int
 uevent_get_disk_ro(struct uevent *uev)
 {
-	char *p, *q;
-	int i, ro = -1;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DISK_RO", 6) && strlen(uev->envp[i]) > 7) {
-			p = uev->envp[i] + 8;
-			ro = strtoul(p, &q, 10);
-			if (p == q) {
-				condlog(2, "invalid read_only setting '%s'", p);
-				ro = -1;
-			}
-			break;
+	const char *p = NULL;
+	char *q;
+	int ro = -1;
+
+	if (uev->udev)
+		p = udev_device_get_property_value(uev->udev, "DISK_RO");
+	if (p) {
+		ro = strtoul(p, &q, 10);
+		if (p == q) {
+			condlog(2, "invalid read_only setting '%s'", p);
+			ro = -1;
 		}
 	}
 	return ro;
@@ -357,16 +305,15 @@ uevent_get_disk_ro(struct uevent *uev)
 extern char *
 uevent_get_dm_name(struct uevent *uev)
 {
-	char *p = NULL;
-	int i;
-
-	for (i = 0; uev->envp[i] != NULL; i++) {
-		if (!strncmp(uev->envp[i], "DM_NAME", 6) &&
-		    strlen(uev->envp[i]) > 7) {
-			p = MALLOC(strlen(uev->envp[i] + 8) + 1);
-			strcpy(p, uev->envp[i] + 8);
-			break;
-		}
+	const char *p = NULL;
+	char *name = NULL;
+
+	if (uev->udev)
+		p = udev_device_get_property_value(uev->udev, "DM_NAME");
+	if (p) {
+		name = MALLOC(strlen(p) + 1);
+		if (name)
+			strcpy(name, p);
 	}
-	return p;
+	return name;
 }
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 64f00b7..542ec0b 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -16,11 +16,6 @@
 struct uevent {
 	struct list_head node;
 	struct udev_device *udev;
-	char buffer[HOTPLUG_BUFFER_SIZE + OBJECT_SIZE];
-	char *devpath;
-	char *action;
-	char *kernel;
-	char *envp[HOTPLUG_NUM_ENVP];
 };
 
 int is_uevent_busy(void);
diff --git a/multipathd/main.c b/multipathd/main.c
index f7625ca..3845880 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -242,26 +242,28 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
 	char *alias;
 	int major = -1, minor = -1, rc;
 
-	condlog(3, "%s: add map (uevent)", uev->kernel);
+	condlog(3, "%s: add map (uevent)", udev_device_get_sysname(uev->udev));
 	alias = uevent_get_dm_name(uev);
 	if (!alias) {
-		condlog(3, "%s: No DM_NAME in uevent", uev->kernel);
+		condlog(3, "%s: No DM_NAME in uevent",
+			udev_device_get_sysname(uev->udev));
 		major = uevent_get_major(uev);
 		minor = uevent_get_minor(uev);
 		alias = dm_mapname(major, minor);
 		if (!alias) {
 			condlog(2, "%s: mapname not found for %d:%d",
-				uev->kernel, major, minor);
+				udev_device_get_sysname(uev->udev),
+				major, minor);
 			return 1;
 		}
 	}
-	rc = ev_add_map(uev->kernel, alias, vecs);
+	rc = ev_add_map(udev_device_get_sysname(uev->udev), alias, vecs);
 	FREE(alias);
 	return rc;
 }
 
 int
-ev_add_map (char * dev, char * alias, struct vectors * vecs)
+ev_add_map (const char * dev, char * alias, struct vectors * vecs)
 {
 	char * refwwid;
 	struct multipath * mpp;
@@ -300,7 +302,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 		condlog(2, "%s: devmap %s registered", alias, dev);
 		return 0;
 	}
-	refwwid = get_refwwid(dev, DEV_DEVMAP, vecs->pathvec);
+	refwwid = get_refwwid((char *)dev, DEV_DEVMAP, vecs->pathvec);
 
 	if (refwwid) {
 		r = coalesce_paths(vecs, NULL, refwwid, 0);
@@ -323,10 +325,12 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 	int minor;
 	struct multipath *mpp;
 
-	condlog(2, "%s: remove map (uevent)", uev->kernel);
+	condlog(2, "%s: remove map (uevent)",
+		udev_device_get_sysname(uev->udev));
 	alias = uevent_get_dm_name(uev);
 	if (!alias) {
-		condlog(3, "%s: No DM_NAME in uevent, ignoring", uev->kernel);
+		condlog(3, "%s: No DM_NAME in uevent, ignoring",
+			udev_device_get_sysname(uev->udev));
 		return 0;
 	}
 	minor = uevent_get_minor(uev);
@@ -334,7 +338,7 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 
 	if (!mpp) {
 		condlog(2, "%s: devmap not registered, can't remove",
-			uev->kernel);
+			udev_device_get_sysname(uev->udev));
 		goto out;
 	}
 	if (strcmp(mpp->alias, alias)) {
@@ -351,7 +355,7 @@ out:
 }
 
 int
-ev_remove_map (char * devname, char * alias, int minor, struct vectors * vecs)
+ev_remove_map (const char * devname, char * alias, int minor, struct vectors * vecs)
 {
 	struct multipath * mpp;
 
@@ -374,20 +378,14 @@ static int
 uev_add_path (struct uevent *uev, struct vectors * vecs)
 {
 	struct path *pp;
+	const char *sysname = udev_device_get_sysname(uev->udev);
 
-	condlog(2, "%s: add path (uevent)", uev->kernel);
-	if (strstr(uev->kernel, "..") != NULL) {
-		/*
-		 * Don't allow relative device names in the pathvec
-		 */
-		condlog(0, "%s: path name is invalid", uev->kernel);
-		return 1;
-	}
+	condlog(2, "%s: add path (uevent)", sysname);
 
-	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+	pp = find_path_by_dev(vecs->pathvec, sysname);
 	if (pp) {
 		condlog(0, "%s: spurious uevent, path already in pathvec",
-			uev->kernel);
+			sysname);
 		if (pp->mpp)
 			return 0;
 	} else {
@@ -400,7 +398,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs)
 		if (!(pp = store_pathinfo(vecs->pathvec, conf->hwtable,
 					  udevice, DI_ALL))) {
 			condlog(0, "%s: failed to store path info",
-				uev->kernel);
+				sysname);
 			udev_device_unref(udevice);
 			return 1;
 		}
@@ -555,13 +553,14 @@ static int
 uev_remove_path (struct uevent *uev, struct vectors * vecs)
 {
 	struct path *pp;
+	const char *sysname = udev_device_get_sysname(uev->udev);
 
-	condlog(2, "%s: remove path (uevent)", uev->kernel);
-	pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+	condlog(2, "%s: remove path (uevent)", sysname);
+	pp = find_path_by_dev(vecs->pathvec, sysname);
 
 	if (!pp) {
 		/* Not an error; path might have been purged earlier */
-		condlog(0, "%s: path already removed", uev->kernel);
+		condlog(0, "%s: path already removed", sysname);
 		return 0;
 	}
 
@@ -665,6 +664,7 @@ static int
 uev_update_path (struct uevent *uev, struct vectors * vecs)
 {
 	int retval, ro;
+	const char *sysname = udev_device_get_sysname(uev->udev);
 
 	ro = uevent_get_disk_ro(uev);
 
@@ -672,18 +672,18 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 		struct path * pp;
 
 		condlog(2, "%s: update path write_protect to '%d' (uevent)",
-			uev->kernel, ro);
-		pp = find_path_by_dev(vecs->pathvec, uev->kernel);
+			sysname, ro);
+		pp = find_path_by_dev(vecs->pathvec, sysname);
 		if (!pp) {
 			condlog(0, "%s: spurious uevent, path not found",
-				uev->kernel);
+				sysname);
 			return 1;
 		}
 		if (pp->mpp)
 			retval = reload_map(vecs, pp->mpp);
 
 		condlog(2, "%s: map %s reloaded (retval %d)",
-			uev->kernel, pp->mpp->alias, retval);
+			pp->dev, pp->mpp->alias, retval);
 
 	}
 
@@ -738,38 +738,17 @@ uxsock_trigger (char * str, char ** reply, int * len, void * trigger_data)
 	return r;
 }
 
-static int
-uev_discard(char * devpath)
-{
-	char *tmp;
-	char a[11], b[11];
-
-	/*
-	 * keep only block devices, discard partitions
-	 */
-	tmp = strstr(devpath, "/block/");
-	if (tmp == NULL){
-		condlog(4, "no /block/ in '%s'", devpath);
-		return 1;
-	}
-	if (sscanf(tmp, "/block/%10s", a) != 1 ||
-	    sscanf(tmp, "/block/%10[^/]/%10s", a, b) == 2) {
-		condlog(4, "discard event on %s", devpath);
-		return 1;
-	}
-	return 0;
-}
-
 int
 uev_trigger (struct uevent * uev, void * trigger_data)
 {
 	int r = 0;
 	struct vectors * vecs;
+	const char *action = udev_device_get_action(uev->udev);
+	const char *sysname = udev_device_get_sysname(uev->udev);
 
 	vecs = (struct vectors *)trigger_data;
 
-	if (uev_discard(uev->devpath))
-		return 0;
+	condlog(3, "%s: uevent '%s'", sysname, action);
 
 	pthread_cleanup_push(cleanup_lock, &vecs->lock);
 	lock(vecs->lock);
@@ -780,12 +759,12 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	 * Add events are ignored here as the tables
 	 * are not fully initialised then.
 	 */
-	if (!strncmp(uev->kernel, "dm-", 3)) {
-		if (!strncmp(uev->action, "change", 6)) {
+	if (!strncmp(sysname, "dm-", 3)) {
+		if (!action || !strncmp(action, "change", 6)) {
 			r = uev_add_map(uev, vecs);
 			goto out;
 		}
-		if (!strncmp(uev->action, "remove", 6)) {
+		if (action && !strncmp(action, "remove", 6)) {
 			r = uev_remove_map(uev, vecs);
 			goto out;
 		}
@@ -796,18 +775,18 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 	 * path add/remove event
 	 */
 	if (filter_devnode(conf->blist_devnode, conf->elist_devnode,
-			   uev->kernel) > 0)
+			   udev_device_get_sysname(uev->udev)) > 0)
 		goto out;
 
-	if (!strncmp(uev->action, "add", 3)) {
+	if (!action || !strncmp(action, "add", 3)) {
 		r = uev_add_path(uev, vecs);
 		goto out;
 	}
-	if (!strncmp(uev->action, "remove", 6)) {
+	if (action && !strncmp(action, "remove", 6)) {
 		r = uev_remove_path(uev, vecs);
 		goto out;
 	}
-	if (!strncmp(uev->action, "change", 6)) {
+	if (action && !strncmp(action, "change", 6)) {
 		r = uev_update_path(uev, vecs);
 		goto out;
 	}
diff --git a/multipathd/main.h b/multipathd/main.h
index 242f5e1..af825d5 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -21,8 +21,8 @@ const char * daemon_status(void);
 int reconfigure (struct vectors *);
 int ev_add_path (struct path *, struct vectors *);
 int ev_remove_path (struct path *, struct vectors *);
-int ev_add_map (char *, char *, struct vectors *);
-int ev_remove_map (char *, char *, int, struct vectors *);
+int ev_add_map (const char *, char *, struct vectors *);
+int ev_remove_map (const char *, char *, int, struct vectors *);
 void sync_map_state (struct multipath *);
 void * mpath_alloc_prin_response(int prin_sa);
 int prin_do_scsi_ioctl(char *, int rq_servact, struct prin_resp * resp,
-- 
1.7.3.4
