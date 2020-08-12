From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH V3] vector: return false if realloc fails in
 vector_alloc_slot func
Date: Wed, 12 Aug 2020 16:29:41 +0800
Message-ID: <c53517b7-903e-9484-f0a2-b4eac38dd9ed@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>, liuzhiqiang26@huawei.com
List-Id: dm-devel.ids


In vector_alloc_slot func, if REALLOC fails, it means new slot
allocation fails. However, it just update v->allocated and then
return the old v->slot without new slot. So, the caller will take
the last old slot as the new allocated slot, and use it by calling
vector_set_slot func. Finally, the data of last slot is lost.

Here, we rewrite vector_alloc_slot as suggested by Martin Wilck:
 - increment v->allocated only after successful allocation,
 - avoid the "if (v->slot)" conditional by just calling realloc(),
 - make sure all newly allocated vector elements are set to NULL,
 - change return value to bool.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/config.c       |  2 +-
 libmultipath/foreign.c      |  2 +-
 libmultipath/foreign/nvme.c |  6 +++---
 libmultipath/vector.c       | 27 ++++++++++++++-------------
 libmultipath/vector.h       |  6 ++++--
 5 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index 49723add..4f5cefda 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -131,7 +131,7 @@ find_hwe (const struct _vector *hwtable,
 	vector_foreach_slot_backwards (hwtable, tmp, i) {
 		if (hwe_regmatch(tmp, vendor, product, revision))
 			continue;
-		if (vector_alloc_slot(result) != NULL) {
+		if (vector_alloc_slot(result)) {
 			vector_set_slot(result, tmp);
 			n++;
 		}
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 26f92672..c2335ed5 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -236,7 +236,7 @@ static int _init_foreign(const char *multipath_dir, const char *const enable)
 			goto dl_err;
 		}

-		if (vector_alloc_slot(foreigns) == NULL) {
+		if (!vector_alloc_slot(foreigns)) {
 			goto dl_err;
 		}

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index da85e515..88b6aee2 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -731,12 +731,12 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 		test_ana_support(map, path->ctl);

 		path->pg.gen.ops = &nvme_pg_ops;
-		if (vector_alloc_slot(&path->pg.pathvec) == NULL) {
+		if (!vector_alloc_slot(&path->pg.pathvec)) {
 			cleanup_nvme_path(path);
 			continue;
 		}
 		vector_set_slot(&path->pg.pathvec, path);
-		if (vector_alloc_slot(&map->pgvec) == NULL) {
+		if (!vector_alloc_slot(&map->pgvec)) {
 			cleanup_nvme_path(path);
 			continue;
 		}
@@ -792,7 +792,7 @@ static int _add_map(struct context *ctx, struct udev_device *ud,
 	map->subsys = subsys;
 	map->gen.ops = &nvme_map_ops;

-	if (vector_alloc_slot(ctx->mpvec) == NULL) {
+	if (!vector_alloc_slot(ctx->mpvec)) {
 		cleanup_nvme_map(map);
 		return FOREIGN_ERR;
 	}
diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index 501cf4c5..edd58a89 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -35,26 +35,27 @@ vector_alloc(void)
 }

 /* allocated one slot */
-void *
+bool
 vector_alloc_slot(vector v)
 {
 	void *new_slot = NULL;
+	int new_allocated;
+	int i;

 	if (!v)
-		return NULL;
-
-	v->allocated += VECTOR_DEFAULT_SIZE;
-	if (v->slot)
-		new_slot = REALLOC(v->slot, sizeof (void *) * v->allocated);
-	else
-		new_slot = (void *) MALLOC(sizeof (void *) * v->allocated);
+		return false;

+	new_allocated = v->allocated + VECTOR_DEFAULT_SIZE;
+	new_slot = REALLOC(v->slot, sizeof (void *) * new_allocated);
 	if (!new_slot)
-		v->allocated -= VECTOR_DEFAULT_SIZE;
-	else
-		v->slot = new_slot;
+		return false;

-	return v->slot;
+	v->slot = new_slot;
+	for (i = v->allocated; i < new_allocated; i++)
+		v->slot[i] = NULL;
+
+	v->allocated = new_allocated;
+	return true;
 }

 int
@@ -203,7 +204,7 @@ int vector_find_or_add_slot(vector v, void *value)

 	if (n >= 0)
 		return n;
-	if (vector_alloc_slot(v) == NULL)
+	if (!vector_alloc_slot(v))
 		return -1;
 	vector_set_slot(v, value);
 	return VECTOR_SIZE(v) - 1;
diff --git a/libmultipath/vector.h b/libmultipath/vector.h
index e16ec461..cb64b7d6 100644
--- a/libmultipath/vector.h
+++ b/libmultipath/vector.h
@@ -23,6 +23,8 @@
 #ifndef _VECTOR_H
 #define _VECTOR_H

+#include <stdbool.h>
+
 /* vector definition */
 struct _vector {
 	int allocated;
@@ -60,7 +62,7 @@ typedef struct _vector *vector;
 			__t = vector_alloc();				\
 		if (__t != NULL) {					\
 			vector_foreach_slot(__v, __j, __i) {		\
-				if (vector_alloc_slot(__t) == NULL) {	\
+				if (!vector_alloc_slot(__t)) {	\
 					vector_free(__t);		\
 					__t = NULL;			\
 					break;				\
@@ -73,7 +75,7 @@ typedef struct _vector *vector;

 /* Prototypes */
 extern vector vector_alloc(void);
-extern void *vector_alloc_slot(vector v);
+extern bool vector_alloc_slot(vector v);
 vector vector_reset(vector v);
 extern void vector_free(vector v);
 #define vector_free_const(x) vector_free((vector)(long)(x))
-- 
2.24.0.windows.2
