From: mwilck@suse.com
Subject: [PATCH 10/19] libmultipath: devmapper: refactor libdm
	version determination
Date: Wed, 16 Sep 2020 17:37:09 +0200
Message-ID: <20200916153718.582-11-mwilck@suse.com>
References: <20200916153718.582-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200916153718.582-1-mwilck@suse.com>
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
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

As one step towards bundling all possibly racy libdm init calls into a single
function, split the code for determining and checking versions of
libdm and kernel components. Provide a generic helper
libmp_get_version() that makes sure the versions are "lazily" initialized.
Note that retrieving the versions requires libdm calls, thus the
version initialization calls libdm initialization, which might call
version initialization recursively. But that's not an issue, as
the initialization is protected by pthread_once().

External callers may use dm_prereq(), like before.
Minor API change: dm_prereq() does not nullify the argument any more
if an error is encountered.

Remove the conf->version field, which isn't needed any more after this
change.

Cc: lixiaokeng@huawei.com
Cc: Zdenek Kabelac <zkabelac@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.h    |   1 -
 libmultipath/devmapper.c | 155 ++++++++++++++++++++++++++-------------
 libmultipath/devmapper.h |  11 ++-
 libmultipath/propsel.c   |  10 ++-
 multipathd/dmevents.c    |   2 +-
 multipathd/main.c        |   1 -
 6 files changed, 120 insertions(+), 60 deletions(-)

diff --git a/libmultipath/config.h b/libmultipath/config.h
index 2bb7153..8e13ae9 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -191,7 +191,6 @@ struct config {
 	int find_multipaths_timeout;
 	int marginal_pathgroups;
 	int skip_delegate;
-	unsigned int version[3];
 	unsigned int sequence_nr;
 
 	char * multipath_dir;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index cc2de1d..3694cc8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -26,6 +26,7 @@
 #include "sysfs.h"
 #include "config.h"
 #include "wwids.h"
+#include "version.h"
 
 #include "log_pthread.h"
 #include <sys/types.h>
@@ -34,7 +35,13 @@
 #define MAX_WAIT 5
 #define LOOPS_PER_SEC 5
 
+#define INVALID_VERSION ~0U
+static unsigned int dm_library_version[3] = { INVALID_VERSION, };
+static unsigned int dm_kernel_version[3] = { INVALID_VERSION, };
+static unsigned int dm_mpath_target_version[3] = { INVALID_VERSION, };
+
 static pthread_once_t dm_initialized = PTHREAD_ONCE_INIT;
+static pthread_once_t versions_initialized = PTHREAD_ONCE_INIT;
 
 static int dm_conf_verbosity;
 
@@ -102,7 +109,7 @@ dm_write_log (int level, const char *file, int line, const char *f, ...)
 	return;
 }
 
-void dm_init(int v)
+static void dm_init(int v)
 {
 	/*
 	 * This maps libdm's standard loglevel _LOG_WARN (= 4), which is rather
@@ -112,59 +119,66 @@ void dm_init(int v)
 	dm_log_init(&dm_write_log);
 }
 
+static void init_dm_library_version(void)
+{
+	char version[64];
+	unsigned int v[3];
+
+	dm_get_library_version(version, sizeof(version));
+	if (sscanf(version, "%u.%u.%u ", &v[0], &v[1], &v[2]) != 3) {
+		condlog(0, "invalid libdevmapper version %s", version);
+		return;
+	}
+	memcpy(dm_library_version, v, sizeof(dm_library_version));
+	condlog(3, "libdevmapper version %u.%.2u.%.2u",
+		dm_library_version[0], dm_library_version[1],
+		dm_library_version[2]);
+}
+
 static int
 dm_lib_prereq (void)
 {
-	char version[64];
-	int v[3];
+
 #if defined(LIBDM_API_HOLD_CONTROL)
-	int minv[3] = {1, 2, 111};
+	unsigned int minv[3] = {1, 2, 111};
 #elif defined(LIBDM_API_DEFERRED)
-	int minv[3] = {1, 2, 89};
+	unsigned int minv[3] = {1, 2, 89};
 #elif defined(DM_SUBSYSTEM_UDEV_FLAG0)
-	int minv[3] = {1, 2, 82};
+	unsigned int minv[3] = {1, 2, 82};
 #elif defined(LIBDM_API_COOKIE)
-	int minv[3] = {1, 2, 38};
+	unsigned int minv[3] = {1, 2, 38};
 #else
-	int minv[3] = {1, 2, 8};
+	unsigned int minv[3] = {1, 2, 8};
 #endif
 
-	dm_get_library_version(version, sizeof(version));
-	condlog(3, "libdevmapper version %s", version);
-	if (sscanf(version, "%d.%d.%d ", &v[0], &v[1], &v[2]) != 3) {
-		condlog(0, "invalid libdevmapper version %s", version);
-		return 1;
-	}
-
-	if VERSION_GE(v, minv)
+	if (VERSION_GE(dm_library_version, minv))
 		return 0;
-	condlog(0, "libdevmapper version must be >= %d.%.2d.%.2d",
+	condlog(0, "libdevmapper version must be >= %u.%.2u.%.2u",
 		minv[0], minv[1], minv[2]);
 	return 1;
 }
 
-int
-dm_drv_version(unsigned int *v)
+static void init_dm_drv_version(void)
 {
 	char buff[64];
-
-	v[0] = 0;
-	v[1] = 0;
-	v[2] = 0;
+	unsigned int v[3];
 
 	if (!dm_driver_version(buff, sizeof(buff))) {
 		condlog(0, "cannot get kernel dm version");
-		return 1;
+		return;
 	}
 	if (sscanf(buff, "%u.%u.%u ", &v[0], &v[1], &v[2]) != 3) {
 		condlog(0, "invalid kernel dm version '%s'", buff);
-		return 1;
+		return;
 	}
-	return 0;
+	memcpy(dm_kernel_version, v, sizeof(dm_library_version));
+	condlog(3, "kernel device mapper v%u.%u.%u",
+		dm_kernel_version[0],
+		dm_kernel_version[1],
+		dm_kernel_version[2]);
 }
 
-int
-dm_tgt_version (unsigned int * version, char * str)
+static int dm_tgt_version (unsigned int *version, char *str)
 {
 	int r = 2;
 	struct dm_task *dmt;
@@ -172,10 +186,6 @@ dm_tgt_version (unsigned int * version, char * str)
 	struct dm_versions *last_target;
 	unsigned int *v;
 
-	version[0] = 0;
-	version[1] = 0;
-	version[2] = 0;
-
 	if (!(dmt = dm_task_create(DM_DEVICE_LIST_VERSIONS)))
 		return 1;
 
@@ -211,26 +221,25 @@ out:
 	return r;
 }
 
-static int
-dm_tgt_prereq (unsigned int *ver)
+static void init_dm_mpath_version(void)
 {
-	unsigned int minv[3] = {1, 0, 3};
-	unsigned int version[3] = {0, 0, 0};
-	unsigned int * v = version;
-
-	if (dm_tgt_version(v, TGT_MPATH)) {
-		/* in doubt return not capable */
-		return 1;
-	}
-
-	/* test request based multipath capability */
+	dm_tgt_version(dm_mpath_target_version, TGT_MPATH);
 	condlog(3, "DM multipath kernel driver v%u.%u.%u",
-		v[0], v[1], v[2]);
+		dm_mpath_target_version[0],
+		dm_mpath_target_version[1],
+		dm_mpath_target_version[2]);
+}
+
+static int dm_tgt_prereq (unsigned int *ver)
+{
+	unsigned int minv[3] = {1, 0, 3};
 
-	if (VERSION_GE(v, minv)) {
-		ver[0] = v[0];
-		ver[1] = v[1];
-		ver[2] = v[2];
+	if (VERSION_GE(dm_mpath_target_version, minv)) {
+		if (ver) {
+			ver[0] = dm_mpath_target_version[0];
+			ver[1] = dm_mpath_target_version[1];
+			ver[2] = dm_mpath_target_version[2];
+		}
 		return 0;
 	}
 
@@ -239,13 +248,60 @@ dm_tgt_prereq (unsigned int *ver)
 	return 1;
 }
 
+static void _init_versions(void)
+{
+	dlog(logsink, 3, VERSION_STRING);
+	init_dm_library_version();
+	init_dm_drv_version();
+	init_dm_mpath_version();
+}
+
+static int init_versions(void) {
+	pthread_once(&versions_initialized, _init_versions);
+	return (dm_library_version[0] == INVALID_VERSION ||
+		dm_kernel_version[0] == INVALID_VERSION ||
+		dm_mpath_target_version[0] == INVALID_VERSION);
+}
+
 int dm_prereq(unsigned int *v)
 {
+	if (init_versions())
+		return 1;
 	if (dm_lib_prereq())
 		return 1;
 	return dm_tgt_prereq(v);
 }
 
+int libmp_get_version(int which, unsigned int version[3])
+{
+	unsigned int *src_version;
+
+	init_versions();
+	switch (which) {
+	case DM_LIBRARY_VERSION:
+		src_version = dm_library_version;
+		break;
+	case DM_KERNEL_VERSION:
+		src_version = dm_kernel_version;
+		break;
+	case DM_MPATH_TARGET_VERSION:
+		src_version = dm_mpath_target_version;
+		break;
+	case MULTIPATH_VERSION:
+		version[0] = (VERSION_CODE >> 16) & 0xff;
+		version[1] = (VERSION_CODE >> 8) & 0xff;
+		version[2] = VERSION_CODE & 0xff;
+		return 0;
+	default:
+		condlog(0, "%s: invalid value for 'which'", __func__);
+		return 1;
+	}
+	if (src_version[0] == INVALID_VERSION)
+		return 1;
+	memcpy(version, src_version, 3 * sizeof(*version));
+	return 0;
+}
+
 static int libmp_dm_udev_sync = 0;
 
 void libmp_udev_set_sync_support(int on)
@@ -263,7 +319,6 @@ static void libmp_dm_init(void)
 		exit(1);
 	conf = get_multipath_config();
 	verbosity = conf->verbosity;
-	memcpy(conf->version, version, sizeof(version));
 	put_multipath_config(conf);
 	dm_init(verbosity);
 #ifdef LIBDM_API_HOLD_CONTROL
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index f568ab5..c8b37e1 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -33,13 +33,10 @@ enum {
 	DMP_NOT_FOUND,
 };
 
-void dm_init(int verbosity);
 int dm_prereq(unsigned int *v);
 void skip_libmp_dm_init(void);
 void libmp_udev_set_sync_support(int on);
 struct dm_task *libmp_dm_task_create(int task);
-int dm_drv_version (unsigned int * version);
-int dm_tgt_version (unsigned int * version, char * str);
 int dm_simplecmd_flush (int, const char *, uint16_t);
 int dm_simplecmd_noflush (int, const char *, uint16_t);
 int dm_addmap_create (struct multipath *mpp, char *params);
@@ -85,6 +82,14 @@ struct multipath *dm_get_multipath(const char *name);
 	((v[0] == minv[0]) && (v[1] == minv[1]) && (v[2] >= minv[2])) \
 )
 
+enum {
+	DM_LIBRARY_VERSION,
+	DM_KERNEL_VERSION,
+	DM_MPATH_TARGET_VERSION,
+	MULTIPATH_VERSION
+};
+int libmp_get_version(int which, unsigned int version[3]);
+
 #define dm_log_error(lvl, cmd, dmt)			      \
 	condlog(lvl, "%s: libdm task=%d error: %s", __func__, \
 		cmd, strerror(dm_task_get_errno(dmt)))	      \
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 7e6e0d6..781515e 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -737,9 +737,10 @@ out:
 
 int select_minio(struct config *conf, struct multipath *mp)
 {
-	unsigned int minv_dmrq[3] = {1, 1, 0};
+	unsigned int minv_dmrq[3] = {1, 1, 0}, version[3];
 
-	if (VERSION_GE(conf->version, minv_dmrq))
+	if (!libmp_get_version(DM_MPATH_TARGET_VERSION, version)
+	    && VERSION_GE(version, minv_dmrq))
 		return select_minio_rq(conf, mp);
 	else
 		return select_minio_bio(conf, mp);
@@ -822,9 +823,10 @@ out:
 int select_retain_hwhandler(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
-	unsigned int minv_dm_retain[3] = {1, 5, 0};
+	unsigned int minv_dm_retain[3] = {1, 5, 0}, version[3];
 
-	if (!VERSION_GE(conf->version, minv_dm_retain)) {
+	if (!libmp_get_version(DM_MPATH_TARGET_VERSION, version) &&
+	    !VERSION_GE(version, minv_dm_retain)) {
 		mp->retain_hwhandler = RETAIN_HWHANDLER_OFF;
 		origin = "(setting: WARNING, requires kernel dm-mpath version >= 1.5.0)";
 		goto out;
diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
index 5f2d210..fc97c8a 100644
--- a/multipathd/dmevents.c
+++ b/multipathd/dmevents.c
@@ -60,7 +60,7 @@ int dmevent_poll_supported(void)
 {
 	unsigned int v[3];
 
-	if (dm_drv_version(v))
+	if (libmp_get_version(DM_KERNEL_VERSION, v))
 		return 0;
 
 	if (VERSION_GE(v, DM_VERSION_FOR_ARM_POLL))
diff --git a/multipathd/main.c b/multipathd/main.c
index affe706..53bacac 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2719,7 +2719,6 @@ reconfigure (struct vectors * vecs)
 	/* Re-read any timezone changes */
 	tzset();
 
-	dm_tgt_version(conf->version, TGT_MPATH);
 	if (verbosity)
 		conf->verbosity = verbosity;
 	if (bindings_read_only)
-- 
2.28.0
