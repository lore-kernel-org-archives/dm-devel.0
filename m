From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 4/7] libmultipath: const qualifier for wwid and
	alias
Date: Wed, 17 Jan 2018 08:49:36 +0100
Message-ID: <20180117074939.7795-5-mwilck@suse.com>
References: <20180117074939.7795-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180117074939.7795-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel@redhat.com
Cc: Ritika Srivastava <ritika.srivastava@oracle.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Add "const" qualifiers to some function arguments and fields,
in order to tidy up const handling of libmultipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c   |  2 +-
 libmultipath/discovery.h   |  2 +-
 libmultipath/memory.h      |  2 +-
 libmultipath/structs.c     |  4 ++--
 libmultipath/structs.h     |  4 ++--
 libmultipath/structs_vec.c |  2 +-
 libmultipath/structs_vec.h |  2 +-
 libmultipath/uevent.c      | 16 ++++++++--------
 libmultipath/uevent.h      | 14 +++++++-------
 multipathd/main.c          |  8 ++++----
 multipathd/main.h          |  2 +-
 11 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 8ae170ee3a27..9b22bd94e491 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -34,7 +34,7 @@
 
 int
 alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
-			  char *wwid, int flag, struct path **pp_ptr)
+			  const char *wwid, int flag, struct path **pp_ptr)
 {
 	int err = PATHINFO_FAILED;
 	struct path * pp;
diff --git a/libmultipath/discovery.h b/libmultipath/discovery.h
index b151cc7a39a8..bd5e6678a26d 100644
--- a/libmultipath/discovery.h
+++ b/libmultipath/discovery.h
@@ -38,7 +38,7 @@ int get_state (struct path * pp, struct config * conf, int daemon, int state);
 int get_vpd_sgio (int fd, int pg, char * str, int maxlen);
 int pathinfo (struct path * pp, struct config * conf, int mask);
 int alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
-			      char *wwid, int flag, struct path **pp_ptr);
+			      const char *wwid, int flag, struct path **pp_ptr);
 int store_pathinfo (vector pathvec, struct config *conf,
 		    struct udev_device *udevice, int flag,
 		    struct path **pp_ptr);
diff --git a/libmultipath/memory.h b/libmultipath/memory.h
index a3c478e24bd1..927619b58a62 100644
--- a/libmultipath/memory.h
+++ b/libmultipath/memory.h
@@ -54,7 +54,7 @@ extern void dbg_free_final(char *);
 #else
 
 #define MALLOC(n)    (calloc(1,(n)))
-#define FREE(p)      do { free(p); p = NULL; } while(0)
+#define FREE(p)      do { free((void*)p); p = NULL; } while(0)
 #define REALLOC(p,n) (realloc((p),(n)))
 #define STRDUP(n)    (strdup(n))
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index c42d765409f9..4caad2a40302 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -374,7 +374,7 @@ find_mp_by_wwid (vector mpvec, char * wwid)
 }
 
 struct multipath *
-find_mp_by_alias (vector mpvec, char * alias)
+find_mp_by_alias (vector mpvec, const char * alias)
 {
 	int i;
 	int len;
@@ -425,7 +425,7 @@ find_path_by_dev (vector pathvec, char * dev)
 }
 
 struct path *
-find_path_by_devt (vector pathvec, char * dev_t)
+find_path_by_devt (vector pathvec, const char * dev_t)
 {
 	int i;
 	struct path * pp;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index bfa660a16715..d132dfcebce4 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -374,12 +374,12 @@ int store_hostgroup(vector hostgroupvec, struct host_group *hgp);
 int store_path (vector pathvec, struct path * pp);
 int store_pathgroup (vector pgvec, struct pathgroup * pgp);
 
-struct multipath * find_mp_by_alias (vector mp, char * alias);
+struct multipath * find_mp_by_alias (vector mp, const char * alias);
 struct multipath * find_mp_by_wwid (vector mp, char * wwid);
 struct multipath * find_mp_by_str (vector mp, char * wwid);
 struct multipath * find_mp_by_minor (vector mp, int minor);
 
-struct path * find_path_by_devt (vector pathvec, char * devt);
+struct path * find_path_by_devt (vector pathvec, const char * devt);
 struct path * find_path_by_dev (vector pathvec, char * dev);
 struct path * first_path (struct multipath * mpp);
 
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index fbab61f1dcec..3aafee7b217b 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -449,7 +449,7 @@ fail:
 	return 0;
 }
 
-struct multipath *add_map_without_path (struct vectors *vecs, char *alias)
+struct multipath *add_map_without_path (struct vectors *vecs, const char *alias)
 {
 	struct multipath * mpp = alloc_multipath();
 	struct config *conf;
diff --git a/libmultipath/structs_vec.h b/libmultipath/structs_vec.h
index b81413b0d177..3749eb64a0f6 100644
--- a/libmultipath/structs_vec.h
+++ b/libmultipath/structs_vec.h
@@ -33,7 +33,7 @@ void remove_maps_and_stop_waiters (struct vectors * vecs);
 
 void sync_map_state (struct multipath *);
 int update_map (struct multipath *mpp, struct vectors *vecs);
-struct multipath * add_map_without_path (struct vectors * vecs, char * alias);
+struct multipath * add_map_without_path (struct vectors * vecs, const char * alias);
 struct multipath * add_map_with_path (struct vectors * vecs,
 				struct path * pp, int add_vec);
 int update_multipath (struct vectors *vecs, char *mapname, int reset);
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 13d468f7fce0..3d32e31c5c49 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -891,41 +891,41 @@ out:
 	return err;
 }
 
-int uevent_get_major(struct uevent *uev)
+int uevent_get_major(const struct uevent *uev)
 {
 	return uevent_get_env_positive_int(uev, "MAJOR");
 }
 
-int uevent_get_minor(struct uevent *uev)
+int uevent_get_minor(const struct uevent *uev)
 {
 	return uevent_get_env_positive_int(uev, "MINOR");
 }
 
-int uevent_get_disk_ro(struct uevent *uev)
+int uevent_get_disk_ro(const struct uevent *uev)
 {
 	return uevent_get_env_positive_int(uev, "DISK_RO");
 }
 
-static char *uevent_get_dm_str(const struct uevent *uev, char *attr)
+static const char *uevent_get_dm_str(const struct uevent *uev, char *attr)
 {
-	char *tmp = uevent_get_env_var(uev, attr);
+	const char *tmp = uevent_get_env_var(uev, attr);
 
 	if (tmp == NULL)
 		return NULL;
 	return strdup(tmp);
 }
 
-char *uevent_get_dm_name(struct uevent *uev)
+const char *uevent_get_dm_name(const struct uevent *uev)
 {
 	return uevent_get_dm_str(uev, "DM_NAME");
 }
 
-char *uevent_get_dm_path(struct uevent *uev)
+const char *uevent_get_dm_path(const struct uevent *uev)
 {
 	return uevent_get_dm_str(uev, "DM_PATH");
 }
 
-char *uevent_get_dm_action(struct uevent *uev)
+const char *uevent_get_dm_action(const struct uevent *uev)
 {
 	return uevent_get_dm_str(uev, "DM_ACTION");
 }
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index 6f5af0af6478..bf7017090b1c 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -23,7 +23,7 @@ struct uevent {
 	char *devpath;
 	char *action;
 	char *kernel;
-	char *wwid;
+	const char *wwid;
 	unsigned long seqnum;
 	char *envp[HOTPLUG_NUM_ENVP];
 };
@@ -33,11 +33,11 @@ int is_uevent_busy(void);
 int uevent_listen(struct udev *udev);
 int uevent_dispatch(int (*store_uev)(struct uevent *, void * trigger_data),
 		    void * trigger_data);
-int uevent_get_major(struct uevent *uev);
-int uevent_get_minor(struct uevent *uev);
-int uevent_get_disk_ro(struct uevent *uev);
-char *uevent_get_dm_name(struct uevent *uev);
-char *uevent_get_dm_path(struct uevent *uev);
-char *uevent_get_dm_action(struct uevent *uev);
+int uevent_get_major(const struct uevent *uev);
+int uevent_get_minor(const struct uevent *uev);
+int uevent_get_disk_ro(const struct uevent *uev);
+const char *uevent_get_dm_name(const struct uevent *uev);
+const char *uevent_get_dm_path(const struct uevent *uev);
+const char *uevent_get_dm_action(const struct uevent *uev);
 
 #endif /* _UEVENT_H */
diff --git a/multipathd/main.c b/multipathd/main.c
index ccbb0ad13d32..ff3ecb640487 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -387,7 +387,7 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 static int
 uev_add_map (struct uevent * uev, struct vectors * vecs)
 {
-	char *alias;
+	const char *alias;
 	int major = -1, minor = -1, rc;
 
 	condlog(3, "%s: add map (uevent)", uev->kernel);
@@ -413,7 +413,7 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
 }
 
 int
-ev_add_map (char * dev, char * alias, struct vectors * vecs)
+ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 {
 	char * refwwid;
 	struct multipath * mpp;
@@ -500,7 +500,7 @@ ev_add_map (char * dev, char * alias, struct vectors * vecs)
 static int
 uev_remove_map (struct uevent * uev, struct vectors * vecs)
 {
-	char *alias;
+	const char *alias;
 	int minor;
 	struct multipath *mpp;
 
@@ -1001,7 +1001,7 @@ out:
 static int
 uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
 {
-	char *action = NULL, *devt = NULL;
+	const char *action = NULL, *devt = NULL;
 	struct path *pp;
 	int r = 1;
 
diff --git a/multipathd/main.h b/multipathd/main.h
index ededdaba32fe..ee44dab36aec 100644
--- a/multipathd/main.h
+++ b/multipathd/main.h
@@ -24,7 +24,7 @@ int need_to_delay_reconfig (struct vectors *);
 int reconfigure (struct vectors *);
 int ev_add_path (struct path *, struct vectors *, int);
 int ev_remove_path (struct path *, struct vectors *, int);
-int ev_add_map (char *, char *, struct vectors *);
+int ev_add_map (char *, const char *, struct vectors *);
 int ev_remove_map (char *, char *, int, struct vectors *);
 int set_config_state(enum daemon_status);
 void * mpath_alloc_prin_response(int prin_sa);
-- 
2.15.1
