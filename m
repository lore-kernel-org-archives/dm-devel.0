From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH 8/8] libmultipath: remove FREE_CONST() again
Date: Thu,  8 Mar 2018 00:15:51 +0100
Message-ID: <20180307231551.15162-9-mwilck@suse.com>
References: <20180307231551.15162-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180307231551.15162-1-mwilck@suse.com>
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
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Chongyun Wu <wu.chongyun@h3c.com>
List-Id: dm-devel.ids

The FREE_CONST macro is of questionable value, as reviewers have pointed
out. The users of this macro were mostly functions that called
uevent_get_dm_xyz(). But these functions don't need to return const char*,
as they allocate the strings they return. So my change of the prototype
was wrong. This patch reverts it. The few other users of FREE_CONST can
also be reverted to use char* instead of const char* with negligible risk.

Fixes: "libmultipath: fix compiler warnings for -Wcast-qual"
Fixes: "libmultipath: const qualifier for wwid and alias"

(Note: this reverts changes not committed upstream. But as these changes are
deeply in the middle of my large-ish series of patches, it's probably easier
to simply add this patch on top than to rebase the whole series).

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/devmapper.c |  7 +++----
 libmultipath/memory.h    |  6 ------
 libmultipath/uevent.c    | 12 ++++++------
 libmultipath/uevent.h    |  6 +++---
 multipathd/main.c        | 16 ++++++++--------
 tests/uevent.c           | 16 ++++++++--------
 6 files changed, 28 insertions(+), 35 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 607aea8dc1fc..767d87c8399f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -27,7 +27,6 @@
 #include <sys/types.h>
 #include <time.h>
 
-#define FREE_CONST(p) do { free((void*)(unsigned long)p); p = NULL; } while(0)
 #define MAX_WAIT 5
 #define LOOPS_PER_SEC 5
 
@@ -1415,8 +1414,8 @@ out:
 
 void dm_reassign_deps(char *table, const char *dep, const char *newdep)
 {
-	char *n;
-	const char *p, *newtable;
+	char *n, *newtable;
+	const char *p;
 
 	newtable = strdup(table);
 	if (!newtable)
@@ -1427,7 +1426,7 @@ void dm_reassign_deps(char *table, const char *dep, const char *newdep)
 	n += strlen(newdep);
 	p += strlen(dep);
 	strcat(n, p);
-	FREE_CONST(newtable);
+	FREE(newtable);
 }
 
 int dm_reassign_table(const char *name, char *old, char *new)
diff --git a/libmultipath/memory.h b/libmultipath/memory.h
index 63f59d80584c..a3c478e24bd1 100644
--- a/libmultipath/memory.h
+++ b/libmultipath/memory.h
@@ -43,7 +43,6 @@ int debug;
 		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
 #define STRDUP(n)    ( dbg_strdup((n), \
 		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
-#define FREE_CONST(p) do { FREE((void*)(unsigned long)p); } while(0)
 
 /* Memory debug prototypes defs */
 extern void *dbg_malloc(unsigned long, char *, char *, int);
@@ -56,11 +55,6 @@ extern void dbg_free_final(char *);
 
 #define MALLOC(n)    (calloc(1,(n)))
 #define FREE(p)      do { free(p); p = NULL; } while(0)
-/*
- * Double cast to avoid warnings with -Wcast-qual
- * use this for valid free() operations on const pointers
- */
-#define FREE_CONST(p) do { free((void*)(unsigned long)p); p = NULL; } while(0)
 #define REALLOC(p,n) (realloc((p),(n)))
 #define STRDUP(n)    (strdup(n))
 
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 685ef3362c6d..59d4cad88ca3 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -157,7 +157,7 @@ static int uevent_get_env_positive_int(const struct uevent *uev,
 void
 uevent_get_wwid(struct uevent *uev)
 {
-	const char *uid_attribute;
+	char *uid_attribute;
 	const char *val;
 	struct config * conf;
 
@@ -168,7 +168,7 @@ uevent_get_wwid(struct uevent *uev)
 	val = uevent_get_env_var(uev, uid_attribute);
 	if (val)
 		uev->wwid = val;
-	FREE_CONST(uid_attribute);
+	FREE(uid_attribute);
 }
 
 bool
@@ -907,7 +907,7 @@ int uevent_get_disk_ro(const struct uevent *uev)
 	return uevent_get_env_positive_int(uev, "DISK_RO");
 }
 
-static const char *uevent_get_dm_str(const struct uevent *uev, char *attr)
+static char *uevent_get_dm_str(const struct uevent *uev, char *attr)
 {
 	const char *tmp = uevent_get_env_var(uev, attr);
 
@@ -916,17 +916,17 @@ static const char *uevent_get_dm_str(const struct uevent *uev, char *attr)
 	return strdup(tmp);
 }
 
-const char *uevent_get_dm_name(const struct uevent *uev)
+char *uevent_get_dm_name(const struct uevent *uev)
 {
 	return uevent_get_dm_str(uev, "DM_NAME");
 }
 
-const char *uevent_get_dm_path(const struct uevent *uev)
+char *uevent_get_dm_path(const struct uevent *uev)
 {
 	return uevent_get_dm_str(uev, "DM_PATH");
 }
 
-const char *uevent_get_dm_action(const struct uevent *uev)
+char *uevent_get_dm_action(const struct uevent *uev)
 {
 	return uevent_get_dm_str(uev, "DM_ACTION");
 }
diff --git a/libmultipath/uevent.h b/libmultipath/uevent.h
index cb5347e45c2b..0aa867510f28 100644
--- a/libmultipath/uevent.h
+++ b/libmultipath/uevent.h
@@ -36,9 +36,9 @@ int uevent_dispatch(int (*store_uev)(struct uevent *, void * trigger_data),
 int uevent_get_major(const struct uevent *uev);
 int uevent_get_minor(const struct uevent *uev);
 int uevent_get_disk_ro(const struct uevent *uev);
-const char *uevent_get_dm_name(const struct uevent *uev);
-const char *uevent_get_dm_path(const struct uevent *uev);
-const char *uevent_get_dm_action(const struct uevent *uev);
+char *uevent_get_dm_name(const struct uevent *uev);
+char *uevent_get_dm_path(const struct uevent *uev);
+char *uevent_get_dm_action(const struct uevent *uev);
 bool uevent_is_mpath(const struct uevent *uev);
 
 #endif /* _UEVENT_H */
diff --git a/multipathd/main.c b/multipathd/main.c
index 6d502aceb252..f85995810950 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -392,7 +392,7 @@ flush_map(struct multipath * mpp, struct vectors * vecs, int nopaths)
 static int
 uev_add_map (struct uevent * uev, struct vectors * vecs)
 {
-	const char *alias;
+	char *alias;
 	int major = -1, minor = -1, rc;
 
 	condlog(3, "%s: add map (uevent)", uev->kernel);
@@ -413,7 +413,7 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
 	pthread_testcancel();
 	rc = ev_add_map(uev->kernel, alias, vecs);
 	lock_cleanup_pop(vecs->lock);
-	FREE_CONST(alias);
+	FREE(alias);
 	return rc;
 }
 
@@ -487,7 +487,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
 static int
 uev_remove_map (struct uevent * uev, struct vectors * vecs)
 {
-	const char *alias;
+	char *alias;
 	int minor;
 	struct multipath *mpp;
 
@@ -519,7 +519,7 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 	remove_map_and_stop_waiter(mpp, vecs, 1);
 out:
 	lock_cleanup_pop(vecs->lock);
-	FREE_CONST(alias);
+	FREE(alias);
 	return 0;
 }
 
@@ -1005,7 +1005,7 @@ out:
 static int
 uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
 {
-	const char *action = NULL, *devt = NULL;
+	char *action = NULL, *devt = NULL;
 	struct path *pp;
 	int r = 1;
 
@@ -1032,11 +1032,11 @@ uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
 				pp->dev);
 out_lock:
 	lock_cleanup_pop(vecs->lock);
-	FREE_CONST(devt);
-	FREE_CONST(action);
+	FREE(devt);
+	FREE(action);
 	return r;
 out:
-	FREE_CONST(action);
+	FREE(action);
 	return 1;
 }
 
diff --git a/tests/uevent.c b/tests/uevent.c
index b7d6458710f4..acfcb14a5def 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -169,44 +169,44 @@ static void test_major_bad_8(void **state)
 static void test_dm_name_good(void **state)
 {
 	struct uevent *uev = *state;
-	const char *name = uevent_get_dm_name(uev);
+	char *name = uevent_get_dm_name(uev);
 
 	assert_string_equal(name, DM_NAME);
-	free((void*)name);
+	FREE(name);
 }
 
 static void test_dm_name_bad_0(void **state)
 {
 	struct uevent *uev = *state;
-	const char *name;
+	char *name;
 
 	uev->envp[3] = "DM_NAME" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_ptr_equal(name, NULL);
-	free((void*)name);
+	FREE(name);
 }
 
 static void test_dm_name_bad_1(void **state)
 {
 	struct uevent *uev = *state;
-	const char *name;
+	char *name;
 
 	uev->envp[3] = "DM_NAMES=" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_ptr_equal(name, NULL);
-	free((void*)name);
+	FREE(name);
 }
 
 static void test_dm_name_good_1(void **state)
 {
 	struct uevent *uev = *state;
-	const char *name;
+	char *name;
 
 	/* Note we change index 2 here */
 	uev->envp[2] = "DM_NAME=" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_string_equal(name, DM_NAME);
-	free((void*)name);
+	FREE(name);
 }
 
 static void test_dm_uuid_false_0(void **state)
-- 
2.16.1
