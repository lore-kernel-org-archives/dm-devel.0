From: Konrad Rzeszutek <konrad@virtualiron.com>
Subject: Re: Device Mapper MultiPath
Date: Wed, 1 Apr 2009 16:31:08 -0400
Message-ID: <20090401203108.GA17991@mars.virtualiron.com>
References: <af7b4eb20903311707o925902dn14a6dc8030498001@mail.gmail.com>
	<20090401002559.GA3213@mars.virtualiron.com>
	<20090401200841.GA9078@thumper2>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090401200841.GA9078@thumper2>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 01, 2009 at 03:08:41PM -0500, Andy wrote:
> On Tue, Mar 31, 2009 at 08:25:59PM -0400, Konrad Rzeszutek wrote:
> > On Tue, Mar 31, 2009 at 09:07:08PM -0300, Rodrigo Nascimento wrote:
> > > Hi All,
> > > 
> > > I'm a student of computer sciences and I'd like to collaborate with the
> > > development of the DM-MP.
> > > I know that maybe you received this kind of message during all time, but I
> > 
> > I think you are the first :-)
> > 
> > > really want to help, with anything.
> > 
> > Shakedown help would be nice. As in, trying to yank stuff underneath it, 
> > add new block disks, remove them, add them, remove them, edit the
> > multipath.conf file and issue 'reconfigure', resize the maps, 
> > then add 1000+LUNs, and while they are being added, start removing the
> > LUNs, then for extra fun call 'dmsetup remove_all' while in another
> > thread you run 'multipath'. Ooh, and see if there are any memory leaks
> > while this all is being done.
> > 
> 
> What I would really like to see is online resizing of non-partitioned dm
> block devices.  I would love to be able to resize an underlying dm-mp block
> device, and the just grow the filesystem without using a extra, un-needed,

Benjamin posted a CVS patch of this, that I've forward-ported to work with
the latest git. It is attached.


> volume manager layer.  I remember some of this being talk about a while ago,
> but I don't think anything ever happened.
> 
> Andy
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="Support-resizing-of-multipath-maps.patch"

From 478bf8cc2c741f860d4a0a6d0cc22d5304e7f45c Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek <konrad@virtualiron.com>
Date: Mon, 23 Mar 2009 15:35:59 -0400
Subject: [PATCH] Support resizing of multipath maps.

This is patch that initially showed up on dm-devel mailing list:

http://www.linux-archive.org/device-mapper-development/162594-multipath-tools-libmultipath-configure-c-libmu.html
which was posted on dm-devel mailing list, but never ported
over to work with the git version. This forward-port by me
works.
---
 libmultipath/configure.c  |   10 +++-
 libmultipath/configure.h  |    4 +-
 libmultipath/devmapper.c  |   12 ++-
 libmultipath/devmapper.h  |    2 +-
 libmultipath/sysfs.h      |    1 +
 multipathd/cli.c          |    2 +
 multipathd/cli.h          |    2 +
 multipathd/cli_handlers.c |  166 +++++++++++++++++++++++++++++++-------------
 multipathd/cli_handlers.h |    1 +
 multipathd/main.c         |    3 +-
 multipathd/main.h         |    1 +
 11 files changed, 147 insertions(+), 57 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index e00582f..ed20f37 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -353,7 +353,15 @@ domap (struct multipath * mpp)
 
 	case ACT_RELOAD:
 		r = (dm_addmap_reload(mpp->alias, mpp->params, mpp->size, NULL)
-		     && dm_simplecmd(DM_DEVICE_RESUME, mpp->alias));
+		     && dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, 1));
+		break;
+
+ 	case ACT_RESIZE:
+  		r = dm_addmap_reload_ro(mpp->alias, mpp->params, mpp->size, NULL);
+  		if (!r)
+  			r = dm_addmap_reload(mpp->alias, mpp->params, mpp->size, NULL);
+  		if (r)
+  			r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, 0);
 		break;
 
 	case ACT_RENAME:
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index 75d5057..25891ba 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -7,6 +7,7 @@
 #define ACT_SWITCHPG_STR        "switchpg"
 #define ACT_RENAME_STR          "rename"
 #define ACT_CREATE_STR          "create"
+#define ACT_RESIZE_STR          "resize"
 
 enum actions {
 	ACT_UNDEF,
@@ -15,7 +16,8 @@ enum actions {
 	ACT_RELOAD,
 	ACT_SWITCHPG,
 	ACT_RENAME,
-	ACT_CREATE
+	ACT_CREATE,
+	ACT_RESIZE,
 };
 
 #define FLUSH_ONE 1
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 78204ff..125d394 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -150,7 +150,7 @@ dm_prereq (void)
 }
 
 extern int
-dm_simplecmd (int task, const char *name) {
+dm_simplecmd (int task, const char *name, int no_flush) {
 	int r = 0;
 	struct dm_task *dmt;
 
@@ -163,7 +163,8 @@ dm_simplecmd (int task, const char *name) {
 	dm_task_no_open_count(dmt);
 	dm_task_skip_lockfs(dmt);	/* for DM_DEVICE_RESUME */
 #ifdef LIBDM_API_FLUSH
-	dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
+	if (no_flush)
+		dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 #endif
 
 	r = dm_task_run (dmt);
@@ -193,6 +194,9 @@ dm_addmap (int task, const char *name, const char *target,
 	if (ro)
 		dm_task_set_ro(dmt);
 
+	if (ro)
+		dm_task_set_ro(dmt);
+
 	if (uuid){
 		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
 		if (!prefixed_uuid) {
@@ -536,7 +540,7 @@ dm_flush_map (const char * mapname)
 		return 1;
 	}
 
-	r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
+	r = dm_simplecmd(DM_DEVICE_REMOVE, mapname, 0);
 
 	if (r) {
 		condlog(4, "multipath map %s removed", mapname);
@@ -935,7 +939,7 @@ dm_remove_partmaps (const char * mapname)
 				 */
 				condlog(4, "partition map %s removed",
 					names->name);
-				dm_simplecmd(DM_DEVICE_REMOVE, names->name);
+				dm_simplecmd(DM_DEVICE_REMOVE, names->name, 0);
 		   }
 
 		next = names->next;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index a340c00..b262efa 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -3,7 +3,7 @@
 
 void dm_init(void);
 int dm_prereq (void);
-int dm_simplecmd (int, const char *);
+int dm_simplecmd (int, const char *, int);
 int dm_addmap_create (const char *, const char *,
                       unsigned long long size, const char *uuid);
 int dm_addmap_create_ro (const char *, const char *,
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index e7fa3e7..2cd762f 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -21,5 +21,6 @@ struct sysfs_device *sysfs_device_get_parent_with_subsystem(struct sysfs_device
 void sysfs_device_put(struct sysfs_device *dev);
 char *sysfs_attr_get_value(const char *devpath, const char *attr_name);
 int sysfs_resolve_link(char *path, size_t size);
+int sysfs_get_size (struct sysfs_device * dev, unsigned long long * size);
 
 #endif
diff --git a/multipathd/cli.c b/multipathd/cli.c
index c93aa83..f6f4297 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -155,6 +155,7 @@ load_keys (void)
 	r += add_key(keys, "resume", RESUME, 0);
 	r += add_key(keys, "reinstate", REINSTATE, 0);
 	r += add_key(keys, "fail", FAIL, 0);
+	r += add_key(keys, "resize", RESIZE, 0);
 	r += add_key(keys, "paths", PATHS, 0);
 	r += add_key(keys, "maps", MAPS, 0);
 	r += add_key(keys, "multipaths", MAPS, 0);
@@ -429,6 +430,7 @@ cli_init (void) {
 	add_handler(RECONFIGURE, NULL);
 	add_handler(SUSPEND+MAP, NULL);
 	add_handler(RESUME+MAP, NULL);
+	add_handler(RESIZE+MAP, NULL);
 	add_handler(REINSTATE+PATH, NULL);
 	add_handler(FAIL+PATH, NULL);
 	add_handler(QUIT, NULL);
diff --git a/multipathd/cli.h b/multipathd/cli.h
index d58a200..13d8289 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -7,6 +7,7 @@ enum {
 	__RESUME,
 	__REINSTATE,
 	__FAIL,
+	__RESIZE,
 	__PATHS,
 	__MAPS,
 	__PATH,
@@ -32,6 +33,7 @@ enum {
 #define RESUME		(1 << __RESUME)
 #define REINSTATE	(1 << __REINSTATE)
 #define FAIL		(1 << __FAIL)
+#define RESIZE		(1 << __RESIZE)
 #define PATHS		(1 << __PATHS)
 #define MAPS		(1 << __MAPS)
 #define PATH		(1 << __PATH)
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 6cf232a..b352c62 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -14,6 +14,7 @@
 #include <debug.h>
 #include <print.h>
 #include <sysfs.h>
+#include <errno.h>
 
 #include "main.h"
 #include "cli.h"
@@ -419,12 +420,79 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 	return ev_remove_map(param, vecs);
 }
 
+int resize_map(struct multipath *mpp, unsigned long long size,
+	       struct vectors * vecs)
+{
+	mpp->size = size;
+	update_mpp_paths(mpp, vecs->pathvec);
+	setup_map(mpp);
+	mpp->action = ACT_RESIZE;
+	if (domap(mpp) <= 0) {
+		condlog(0, "%s: failed to resize map : %s", mpp->alias,
+			strerror(errno));
+		return 1;
+	}
+	return 0;
+}
+
+int
+cli_resize(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * mapname = get_keyparam(v, MAP);
+	struct multipath *mpp;
+	int minor;
+	unsigned long long size;
+	struct pathgroup *pgp;
+	struct path *pp;
+
+	condlog(2, "%s: resize map (operator)", mapname);
+	if (sscanf(mapname, "dm-%d", &minor) == 1)
+		mpp = find_mp_by_minor(vecs->mpvec, minor);
+	else
+		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+
+	if (!mpp) {
+		condlog(0, "%s: invalid map name. cannot resize", mapname);
+		return 1;
+	}
+
+	pgp = VECTOR_SLOT(mpp->pg, 0);
+	pp = VECTOR_SLOT(pgp->paths, 0);
+	condlog(0,"%s: reading sysfs.", mapname);
+	if (sysfs_get_size(pp->sysdev, &size)) {
+		condlog(0, "%s: couldn't get size for sysfs. cannot resize",
+			mapname);
+		return 1;
+	}
+	if (size == mpp->size) {
+		condlog(0, "%s: map is still the same size (%llu)", mapname,
+			mpp->size);
+		return 0;
+	}
+	condlog(3, "%s old size is %llu, new size is %llu", mapname, mpp->size,
+		size);
+
+	condlog(0,"%s: resize_map.");
+	if (resize_map(mpp, size, vecs) != 0)
+		return 1;
+
+	condlog(0,"%s: dm_lib_release.", mapname);
+	dm_lib_release();
+	condlog(0,"%s: setup multipath.", mapname);
+	setup_multipath(vecs, mpp);
+	condlog(0,"%s: sync map state.", mapname);
+	sync_map_state(mpp);
+
+	return 0;
+}
+
 int
 cli_switch_group(void * v, char ** reply, int * len, void * data)
 {
 	char * mapname = get_keyparam(v, MAP);
 	int groupnum = atoi(get_keyparam(v, GROUP));
-	
+
 	condlog(2, "%s: switch to path group #%i (operator)", mapname, groupnum);
 
 	return dm_switchgroup(mapname, groupnum);
@@ -434,7 +502,7 @@ int
 cli_reconfigure(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
-			
+
 	condlog(2, "reconfigure (operator)");
 
 	return reconfigure(vecs);
@@ -445,18 +513,18 @@ cli_suspend(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd(DM_DEVICE_SUSPEND, param);
+	int r = dm_simplecmd(DM_DEVICE_SUSPEND, param, 1);
 
 	condlog(2, "%s: suspend (operator)", param);
 
 	if (!r) /* error */
 		return 1;
-	
+
 	struct multipath * mpp = find_mp_by_alias(vecs->mpvec, param);
 
 	if (!mpp)
 		return 1;
-	
+
 	dm_get_info(param, &mpp->dmi);
 	return 0;
 }
@@ -466,18 +534,18 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd(DM_DEVICE_RESUME, param);
+	int r = dm_simplecmd(DM_DEVICE_RESUME, param, 1);
 
 	condlog(2, "%s: resume (operator)", param);
 
 	if (!r) /* error */
 		return 1;
-	
+
 	struct multipath * mpp = find_mp_by_alias(vecs->mpvec, param);
 
 	if (!mpp)
 		return 1;
-	
+
 	dm_get_info(param, &mpp->dmi);
 	return 0;
 }
@@ -488,7 +556,7 @@ cli_reinstate(void * v, char ** reply, int * len, void * data)
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, PATH);
 	struct path * pp;
-	
+
 	pp = find_path_by_dev(vecs->pathvec, param);
 
 	if (!pp)
@@ -511,7 +579,7 @@ cli_fail(void * v, char ** reply, int * len, void * data)
 	char * param = get_keyparam(v, PATH);
 	struct path * pp;
 	int r;
-	
+
 	pp = find_path_by_dev(vecs->pathvec, param);
 
 	if (!pp)
@@ -535,67 +603,67 @@ cli_fail(void * v, char ** reply, int * len, void * data)
 int
 show_blacklist (char ** r, int * len)
 {
-        char *c = NULL;
-        char *reply = NULL;
-        unsigned int maxlen = INITIAL_REPLY_LEN;
-        int again = 1;
+	char *c = NULL;
+	char *reply = NULL;
+	unsigned int maxlen = INITIAL_REPLY_LEN;
+	int again = 1;
 
-        while (again) {
+	while (again) {
 		reply = MALLOC(maxlen);
 		if (!reply)
 			return 1;
 
-                c = reply;
-                c += snprint_blacklist_report(c, maxlen);
-                again = ((c - reply) == maxlen);
-                if (again) {
+		c = reply;
+		c += snprint_blacklist_report(c, maxlen);
+		again = ((c - reply) == maxlen);
+		if (again) {
 			maxlen  *= 2;
 			FREE(reply);
-                        continue;
-                }
-        }
+			continue;
+		}
+	}
 
-        *r = reply;
-        *len = (int)(c - reply + 1);
+	*r = reply;
+	*len = (int)(c - reply + 1);
 
-        return 0;
+	return 0;
 }
 
 int
 cli_list_blacklist (void * v, char ** reply, int * len, void * data)
 {
-        condlog(3, "list blacklist (operator)");
+	condlog(3, "list blacklist (operator)");
 
-        return show_blacklist(reply, len);
+	return show_blacklist(reply, len);
 }
 
 int
 show_devices (char ** r, int * len, struct vectors *vecs)
 {
-        char *c = NULL;
-        char *reply = NULL;
-        unsigned int maxlen = INITIAL_REPLY_LEN;
-        int again = 1;
+	char *c = NULL;
+	char *reply = NULL;
+	unsigned int maxlen = INITIAL_REPLY_LEN;
+	int again = 1;
 
-        while (again) {
-                reply = MALLOC(maxlen);
-                if (!reply)
-                        return 1;
+	while (again) {
+		reply = MALLOC(maxlen);
+		if (!reply)
+			return 1;
 
-                c = reply;
-                c += snprint_devices(c, maxlen, vecs);
-                again = ((c - reply) == maxlen);
-                if (again) {
-                        maxlen  *= 2;
-                        FREE(reply);
-                        continue;
-                }
-        }
+		c = reply;
+		c += snprint_devices(c, maxlen, vecs);
+		again = ((c - reply) == maxlen);
+		if (again) {
+			maxlen  *= 2;
+			FREE(reply);
+			continue;
+		}
+	}
 
-        *r = reply;
-        *len = (int)(c - reply + 1);
+	*r = reply;
+	*len = (int)(c - reply + 1);
 
-        return 0;
+	return 0;
 }
 
 int
@@ -603,9 +671,9 @@ cli_list_devices (void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 
-        condlog(3, "list devices (operator)");
+	condlog(3, "list devices (operator)");
 
-        return show_devices(reply, len, vecs);
+	return show_devices(reply, len, vecs);
 }
 
 int
diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
index f57a160..6598b2a 100644
--- a/multipathd/cli_handlers.h
+++ b/multipathd/cli_handlers.h
@@ -17,6 +17,7 @@ int cli_add_map (void * v, char ** reply, int * len, void * data);
 int cli_del_map (void * v, char ** reply, int * len, void * data);
 int cli_switch_group(void * v, char ** reply, int * len, void * data);
 int cli_reconfigure(void * v, char ** reply, int * len, void * data);
+int cli_resize(void * v, char ** reply, int * len, void * data);
 int cli_suspend(void * v, char ** reply, int * len, void * data);
 int cli_resume(void * v, char ** reply, int * len, void * data);
 int cli_reinstate(void * v, char ** reply, int * len, void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index b7532f1..fce6ce9 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -147,7 +147,7 @@ coalesce_maps(struct vectors *vecs, vector nmpv)
 	return 0;
 }
 
-static void
+void
 sync_map_state(struct multipath *mpp)
 {
 	struct pathgroup *pgp;
@@ -722,6 +722,7 @@ uxlsnrloop (void * ap)
 	set_handler_callback(RECONFIGURE, cli_reconfigure);
 	set_handler_callback(SUSPEND+MAP, cli_suspend);
 	set_handler_callback(RESUME+MAP, cli_resume);
+	set_handler_callback(RESIZE+MAP, cli_resize);
 	set_handler_callback(REINSTATE+PATH, cli_reinstate);
 	set_handler_callback(FAIL+PATH, cli_fail);
 	set_handler_callback(QUIT, cli_quit);
diff --git a/multipathd/main.h b/multipathd/main.h
index b3a90f8..136b7e5 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -8,5 +8,6 @@ int ev_add_path (char *, struct vectors *);
 int ev_remove_path (char *, struct vectors *);
 int ev_add_map (struct sysfs_device *, struct vectors *);
 int ev_remove_map (char *, struct vectors *);
+void sync_map_state (struct multipath *);
 
 #endif /* MAIN_H */
-- 
1.5.4.1


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--45Z9DzgjV8m4Oswq--
