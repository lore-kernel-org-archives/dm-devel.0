From: Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 02/21] libmultipath: fix memory leaks from
	scandir() use
Date: Fri,  2 Nov 2018 13:21:06 +0100
Message-ID: <20181102122125.30906-3-mwilck@suse.com>
References: <20181102122125.30906-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181102122125.30906-1-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

scandir() users must not only free the resulting dirent* array,
but also every member. Add a cleanup function, and fix the
existing users of scandir() in libmultipath.

Add a small helper macro for casting function pointers to the
type pthread_cleanup_push() expects.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/config.c       | 10 ++++------
 libmultipath/foreign.c      |  5 ++++-
 libmultipath/foreign/nvme.c |  6 +++++-
 libmultipath/sysfs.c        |  5 ++++-
 libmultipath/util.c         |  9 +++++++++
 libmultipath/util.h         |  9 +++++++++
 6 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 0aef186a..5af7af58 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -639,17 +639,13 @@ free_config (struct config * conf)
 	FREE(conf);
 }
 
-static void free_namelist(void *nl)
-{
-	free(nl);
-}
-
 /* if multipath fails to process the config directory, it should continue,
  * with just a warning message */
 static void
 process_config_dir(struct config *conf, vector keywords, char *dir)
 {
 	struct dirent **namelist;
+	struct scandir_result sr;
 	int i, n;
 	char path[LINE_MAX];
 	int old_hwtable_size;
@@ -669,7 +665,9 @@ process_config_dir(struct config *conf, vector keywords, char *dir)
 		return;
 	} else if (n == 0)
 		return;
-	pthread_cleanup_push(free_namelist, namelist);
+	sr.di = namelist;
+	sr.n = n;
+	pthread_cleanup_push_cast(free_scandir_result, &sr);
 	for (i = 0; i < n; i++) {
 		if (!strstr(namelist[i]->d_name, ".conf"))
 			continue;
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 80b399ba..48e8d247 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -115,6 +115,7 @@ static int _init_foreign(const char *multipath_dir)
 {
 	char pathbuf[PATH_MAX];
 	struct dirent **di;
+	struct scandir_result sr;
 	int r, i;
 
 	foreigns = vector_alloc();
@@ -135,7 +136,9 @@ static int _init_foreign(const char *multipath_dir)
 		return -r;
 	}
 
-	pthread_cleanup_push(free, di);
+	sr.di = di;
+	sr.n = r;
+	pthread_cleanup_push_cast(free_scandir_result, &sr);
 	for (i = 0; i < r; i++) {
 		const char *msg, *fn, *c;
 		struct foreign *fgn;
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 8887a755..c753a747 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -27,6 +27,7 @@
 #include <dirent.h>
 #include <errno.h>
 #include <ctype.h>
+#include "util.h"
 #include "vector.h"
 #include "generic.h"
 #include "foreign.h"
@@ -534,6 +535,7 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 {
 	char pathbuf[PATH_MAX], realbuf[PATH_MAX];
 	struct dirent **di = NULL;
+	struct scandir_result sr;
 	struct udev_device *subsys;
 	struct nvme_path *path;
 	int r, i, n;
@@ -568,7 +570,9 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 		return;
 	}
 
-	pthread_cleanup_push(free, di);
+	sr.di = di;
+	sr.n = r;
+	pthread_cleanup_push_cast(free_scandir_result, &sr);
 	for (i = 0; i < r; i++) {
 		char *fn = di[i]->d_name;
 		struct udev_device *ctrl, *udev;
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index b7dacaad..558c8d6a 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -303,6 +303,7 @@ static void close_fd(void *arg)
 bool sysfs_is_multipathed(const struct path *pp)
 {
 	char pathbuf[PATH_MAX];
+	struct scandir_result sr;
 	struct dirent **di;
 	int n, r, i;
 	bool found = false;
@@ -323,7 +324,9 @@ bool sysfs_is_multipathed(const struct path *pp)
 		return false;
 	}
 
-	pthread_cleanup_push(free, di);
+	sr.di = di;
+	sr.n = r;
+	pthread_cleanup_push_cast(free_scandir_result, &sr);
 	for (i = 0; i < r && !found; i++) {
 		long fd;
 		int nr;
diff --git a/libmultipath/util.c b/libmultipath/util.c
index d08112db..66c47611 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -496,3 +496,12 @@ void set_max_fds(int max_fds)
 		}
 	}
 }
+
+void free_scandir_result(struct scandir_result *res)
+{
+	int i;
+
+	for (i = 0; i < res->n; i++)
+		FREE(res->di[i]);
+	FREE(res->di);
+}
diff --git a/libmultipath/util.h b/libmultipath/util.h
index c2462950..a818e29a 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -30,4 +30,13 @@ void set_max_fds(int max_fds);
 #define safe_snprintf(var, size, format, args...)      \
 	snprintf(var, size, format, ##args) >= size
 
+#define pthread_cleanup_push_cast(f, arg)		\
+	pthread_cleanup_push(((void (*)(void *))&f), (arg))
+
+struct scandir_result {
+	struct dirent **di;
+	int n;
+};
+void free_scandir_result(struct scandir_result *);
+
 #endif /* _UTIL_H */
-- 
2.19.1
