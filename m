From: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 01/08] idr: add idr_replace method for replacing
	pointers
Date: Mon, 17 Apr 2006 11:16:02 -0400
Message-ID: <20060417151602.GA18916@locomotive.unixthugs.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Device Mapper Development List <dm-devel@redhat.com>
List-Id: dm-devel.ids


 This patch adds an idr_replace() method to the IDR library for replacing
 a pointer already present in the IDR. Rather than do a remove/add pair, this
 function simply updates the pointer for an ID.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>

--
 include/linux/idr.h |    1 +
 lib/idr.c           |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/include/linux/idr.h 2.6.17-rc1-staging2/include/linux/idr.h
--- 2.6.17-rc1-staging1/include/linux/idr.h	2006-01-02 22:21:10.000000000 -0500
+++ 2.6.17-rc1-staging2/include/linux/idr.h	2006-04-17 10:51:41.000000000 -0400
@@ -78,6 +78,7 @@ void *idr_find(struct idr *idp, int id);
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask);
 int idr_get_new(struct idr *idp, void *ptr, int *id);
 int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
+void *idr_replace(struct idr *idp, void *ptr, int id);
 void idr_remove(struct idr *idp, int id);
 void idr_destroy(struct idr *idp);
 void idr_init(struct idr *idp);
diff -ruNpX ../dontdiff 2.6.17-rc1-staging1/lib/idr.c 2.6.17-rc1-staging2/lib/idr.c
--- 2.6.17-rc1-staging1/lib/idr.c	2006-01-02 22:21:10.000000000 -0500
+++ 2.6.17-rc1-staging2/lib/idr.c	2006-04-17 10:51:41.000000000 -0400
@@ -390,6 +390,49 @@ void *idr_find(struct idr *idp, int id)
 }
 EXPORT_SYMBOL(idr_find);
 
+/**
+ * idr_replace - replace pointer for given id
+ * @idp: idr handle
+ * @ptr: pointer you want associated with the ide
+ * @id: lookup key
+ *
+ * Replace the pointer registered with an id and return the old value.
+ * A -ENOENT return indicates that @id was not found.
+ * A -EINVAL return indicates that @id was not within valid constraints.
+ *
+ * The caller must serialize vs idr_find(), idr_get_new(), and idr_remove().
+ */
+void *idr_replace(struct idr *idp, void *ptr, int id)
+{
+	int n;
+	struct idr_layer *p;
+	int shift = (idp->layers - 1) * IDR_BITS;
+	void *old;
+
+	n = idp->layers * IDR_BITS;
+	p = idp->top;
+
+	id &= MAX_ID_MASK;
+
+	if (id >= (1 << n))
+		return ERR_PTR(-EINVAL);
+
+	while ((shift > 0) && p) {
+		n = (id >> shift) & IDR_MASK;
+		p = p->ary[n];
+		shift -= IDR_BITS;
+	}
+
+	n = id & IDR_MASK;
+	if (unlikely(p == NULL || !test_bit(n, &p->bitmap)))
+		return ERR_PTR(-ENOENT);
+
+	old = p->ary[n];
+	p->ary[n] = ptr;
+	return old;
+}
+EXPORT_SYMBOL(idr_replace);
+
 static void idr_cache_ctor(void * idr_layer, kmem_cache_t *idr_layer_cache,
 		unsigned long flags)
 {
