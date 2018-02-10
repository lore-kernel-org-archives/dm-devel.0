From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: [RFC PATCH 4/5] libmultipath: add helper functions
Date: Fri,  9 Feb 2018 23:07:30 -0600
Message-ID: <1518239251-29392-5-git-send-email-bmarzins@redhat.com>
References: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1518239251-29392-1-git-send-email-bmarzins@redhat.com>
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
Cc: Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

Add the ability to reset a vector without completely freeing it, and to
check the version of the device-mapper module.  The existing version
checking code checks the version of a specific device mapper target, and
has been renamed for clarity's sake. These functions will be used in a
later patch.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 28 ++++++++++++++++++++++++----
 libmultipath/devmapper.h |  3 ++-
 libmultipath/vector.c    | 16 ++++++++++++----
 libmultipath/vector.h    |  1 +
 multipathd/main.c        |  2 +-
 5 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 573fc75..2960bf5 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -132,7 +132,27 @@ dm_lib_prereq (void)
 }
 
 int
-dm_drv_version (unsigned int * version, char * str)
+dm_drv_version(unsigned int *v)
+{
+	char buff[64];
+
+	v[0] = 0;
+	v[1] = 0;
+	v[2] = 0;
+
+	if (!dm_driver_version(buff, sizeof(buff))) {
+		condlog(0, "cannot get kernel dm version");
+		return 1;
+	}
+	if (sscanf(buff, "%u.%u.%u ", &v[0], &v[1], &v[2]) != 3) {
+		condlog(0, "invalid kernel dm version '%s'", buff);
+		return 1;
+	}
+	return 0;
+}
+
+int
+dm_tgt_version (unsigned int * version, char * str)
 {
 	int r = 2;
 	struct dm_task *dmt;
@@ -179,13 +199,13 @@ out:
 }
 
 static int
-dm_drv_prereq (unsigned int *ver)
+dm_tgt_prereq (unsigned int *ver)
 {
 	unsigned int minv[3] = {1, 0, 3};
 	unsigned int version[3] = {0, 0, 0};
 	unsigned int * v = version;
 
-	if (dm_drv_version(v, TGT_MPATH)) {
+	if (dm_tgt_version(v, TGT_MPATH)) {
 		/* in doubt return not capable */
 		return 1;
 	}
@@ -210,7 +230,7 @@ static int dm_prereq(unsigned int *v)
 {
 	if (dm_lib_prereq())
 		return 1;
-	return dm_drv_prereq(v);
+	return dm_tgt_prereq(v);
 }
 
 static int libmp_dm_udev_sync = 0;
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 62e14d1..52d4af8 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -28,7 +28,8 @@ void dm_init(int verbosity);
 void libmp_dm_init(void);
 void libmp_udev_set_sync_support(int on);
 struct dm_task *libmp_dm_task_create(int task);
-int dm_drv_version (unsigned int * version, char * str);
+int dm_drv_version (unsigned int * version);
+int dm_tgt_version (unsigned int * version, char * str);
 int dm_simplecmd_flush (int, const char *, uint16_t);
 int dm_simplecmd_noflush (int, const char *, uint16_t);
 int dm_addmap_create (struct multipath *mpp, char *params);
diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index 6266e0a..f741ae0 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -145,18 +145,26 @@ vector_repack(vector v)
 			vector_del_slot(v, i--);
 }
 
-/* Free memory vector allocation */
-void
-vector_free(vector v)
+vector
+vector_reset(vector v)
 {
 	if (!v)
-		return;
+		return NULL;
 
 	if (v->slot)
 		FREE(v->slot);
 
 	v->allocated = 0;
 	v->slot = NULL;
+	return v;
+}
+
+/* Free memory vector allocation */
+void
+vector_free(vector v)
+{
+	if (!vector_reset(v))
+		return;
 	FREE(v);
 }
 
diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index 5cfd4d0..d69cd0b 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -45,6 +45,7 @@ typedef struct _vector *vector;
 /* Prototypes */
 extern vector vector_alloc(void);
 extern void *vector_alloc_slot(vector v);
+vector vector_reset(vector v);
 extern void vector_free(vector v);
 extern void free_strvec(vector strvec);
 extern void vector_set_slot(vector v, void *value);
diff --git a/multipathd/main.c b/multipathd/main.c
index efc39d7..2963bde 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2228,7 +2228,7 @@ reconfigure (struct vectors * vecs)
 	/* Re-read any timezone changes */
 	tzset();
 
-	dm_drv_version(conf->version, TGT_MPATH);
+	dm_tgt_version(conf->version, TGT_MPATH);
 	if (verbosity)
 		conf->verbosity = verbosity;
 	if (bindings_read_only)
-- 
2.7.4
