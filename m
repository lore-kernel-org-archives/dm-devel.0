From: Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 33/72] libmultipath: mark missing arguments in
 functions matching prototypes
Date: Sat, 12 Oct 2019 21:28:18 +0000
Message-ID: <20191012212703.12989-34-martin.wilck@suse.com>
References: <20191012212703.12989-1-martin.wilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191012212703.12989-1-martin.wilck@suse.com>
Content-Language: en-US
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dm-generic.c   |  6 ++++--
 libmultipath/foreign/nvme.c | 20 +++++++++++++-------
 libmultipath/generic.c      |  2 +-
 libmultipath/print.c        |  6 ++++--
 4 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/libmultipath/dm-generic.c b/libmultipath/dm-generic.c
index d7529919..1b42fa0b 100644
--- a/libmultipath/dm-generic.c
+++ b/libmultipath/dm-generic.c
@@ -31,7 +31,8 @@ dm_mp_get_pgs(const struct gen_multipath *gmp)
 			      struct pathgroup, dm_pathgroup_to_gen);
 }
 
-static void dm_mp_rel_pgs(const struct gen_multipath *gmp,
+static void dm_mp_rel_pgs(__attribute__((unused))
+			  const struct gen_multipath *gmp,
 			  const struct _vector* v)
 {
 	vector_free_const(v);
@@ -44,7 +45,8 @@ dm_pg_get_paths(const struct gen_pathgroup *gpg)
 			      struct path, dm_path_to_gen);
 }
 
-static void dm_mp_rel_paths(const struct gen_pathgroup *gpg,
+static void dm_mp_rel_paths(__attribute__((unused))
+			    const struct gen_pathgroup *gpg,
 			    const struct _vector* v)
 {
 	vector_free_const(v);
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 7e654ec5..e8ca516c 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -123,7 +123,8 @@ nvme_mp_get_pgs(const struct gen_multipath *gmp) {
 }
 
 static void
-nvme_mp_rel_pgs(const struct gen_multipath *gmp, const struct _vector *v)
+nvme_mp_rel_pgs(__attribute__((unused)) const struct gen_multipath *gmp,
+		__attribute__((unused)) const struct _vector *v)
 {
 	/* empty */
 }
@@ -207,7 +208,8 @@ nvme_pg_get_paths(const struct gen_pathgroup *gpg) {
 }
 
 static void
-nvme_pg_rel_paths(const struct gen_pathgroup *gpg, const struct _vector *v)
+nvme_pg_rel_paths(__attribute__((unused)) const struct gen_pathgroup *gpg,
+		  __attribute__((unused)) const struct _vector *v)
 {
 	/* empty */
 }
@@ -331,8 +333,9 @@ static int snprint_nvme_pg(const struct gen_pathgroup *gmp,
 	}
 }
 
-static int nvme_style(const struct gen_multipath* gm,
-		      char *buf, int len, int verbosity)
+static int nvme_style(__attribute__((unused)) const struct gen_multipath* gm,
+		      char *buf, int len,
+		      __attribute__((unused)) int verbosity)
 {
 	int n = snprintf(buf, len, "%%w [%%G]:%%d %%s");
 
@@ -821,7 +824,8 @@ int add(struct context *ctx, struct udev_device *ud)
 	return rc;
 }
 
-int change(struct context *ctx, struct udev_device *ud)
+int change(__attribute__((unused)) struct context *ctx,
+	   __attribute__((unused)) struct udev_device *ud)
 {
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
 	return FOREIGN_IGNORED;
@@ -903,7 +907,8 @@ const struct _vector *get_multipaths(const struct context *ctx)
 	return ctx->mpvec;
 }
 
-void release_multipaths(const struct context *ctx, const struct _vector *mpvec)
+void release_multipaths(__attribute__((unused)) const struct context *ctx,
+			__attribute__((unused)) const struct _vector *mpvec)
 {
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
 	/* NOP */
@@ -927,7 +932,8 @@ const struct _vector * get_paths(const struct context *ctx)
 	return paths;
 }
 
-void release_paths(const struct context *ctx, const struct _vector *mpvec)
+void release_paths(__attribute__((unused)) const struct context *ctx,
+		   const struct _vector *mpvec)
 {
 	condlog(5, "%s called for \"%s\"", __func__, THIS);
 	vector_free_const(mpvec);
diff --git a/libmultipath/generic.c b/libmultipath/generic.c
index 0d1e632a..5f03b9e0 100644
--- a/libmultipath/generic.c
+++ b/libmultipath/generic.c
@@ -21,7 +21,7 @@
 #include "structs.h"
 
 int generic_style(const struct gen_multipath* gm,
-		  char *buf, int len, int verbosity)
+		  char *buf, int len, __attribute__((unused)) int verbosity)
 {
 	char alias_buf[WWID_SIZE];
 	char wwid_buf[WWID_SIZE];
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 907469ad..74c0d62d 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -334,7 +334,8 @@ snprint_multipath_rev (char * buff, size_t len, const struct multipath * mpp)
 }
 
 static int
-snprint_multipath_foreign (char * buff, size_t len, const struct multipath * pp)
+snprint_multipath_foreign (char * buff, size_t len,
+			   __attribute__((unused)) const struct multipath * pp)
 {
 	return snprintf(buff, len, "%s", "--");
 }
@@ -627,7 +628,8 @@ snprint_path_checker (char * buff, size_t len, const struct path * pp)
 }
 
 static int
-snprint_path_foreign (char * buff, size_t len, const struct path * pp)
+snprint_path_foreign (char * buff, size_t len,
+		      __attribute__((unused)) const struct path * pp)
 {
 	return snprintf(buff, len, "%s", "--");
 }
-- 
2.23.0
