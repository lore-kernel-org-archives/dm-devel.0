From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 4/9] blkio-cgroup-v12: Refactoring io-context
	initialization
Date: Mon, 14 Sep 2009 21:29:46 +0900 (JST)
Message-ID: <20090914.212946.104038099.ryov@valinux.co.jp>
References: <20090914.212805.193688121.ryov@valinux.co.jp>
	<20090914.212839.226798134.ryov@valinux.co.jp>
	<20090914.212909.71094050.ryov@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090914.212909.71094050.ryov@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com, agk@redhat.com
List-Id: dm-devel.ids

This patch refactors io_context initialization.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>

---
 block/blk-ioc.c           |   30 +++++++++++++++++-------------
 include/linux/iocontext.h |    1 +
 2 files changed, 18 insertions(+), 13 deletions(-)

Index: linux-2.6.31/block/blk-ioc.c
===================================================================
--- linux-2.6.31.orig/block/blk-ioc.c
+++ linux-2.6.31/block/blk-ioc.c
@@ -84,24 +84,28 @@ void exit_io_context(void)
 	}
 }
 
+void init_io_context(struct io_context *ioc)
+{
+	atomic_long_set(&ioc->refcount, 1);
+	atomic_set(&ioc->nr_tasks, 1);
+	spin_lock_init(&ioc->lock);
+	ioc->ioprio_changed = 0;
+	ioc->ioprio = 0;
+	ioc->last_waited = jiffies; /* doesn't matter... */
+	ioc->nr_batch_requests = 0; /* because this is 0 */
+	ioc->aic = NULL;
+	INIT_RADIX_TREE(&ioc->radix_root, GFP_ATOMIC | __GFP_HIGH);
+	INIT_HLIST_HEAD(&ioc->cic_list);
+	ioc->ioc_data = NULL;
+}
+
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node)
 {
 	struct io_context *ret;
 
 	ret = kmem_cache_alloc_node(iocontext_cachep, gfp_flags, node);
-	if (ret) {
-		atomic_long_set(&ret->refcount, 1);
-		atomic_set(&ret->nr_tasks, 1);
-		spin_lock_init(&ret->lock);
-		ret->ioprio_changed = 0;
-		ret->ioprio = 0;
-		ret->last_waited = jiffies; /* doesn't matter... */
-		ret->nr_batch_requests = 0; /* because this is 0 */
-		ret->aic = NULL;
-		INIT_RADIX_TREE(&ret->radix_root, GFP_ATOMIC | __GFP_HIGH);
-		INIT_HLIST_HEAD(&ret->cic_list);
-		ret->ioc_data = NULL;
-	}
+	if (ret)
+		init_io_context(ret);
 
 	return ret;
 }
Index: linux-2.6.31/include/linux/iocontext.h
===================================================================
--- linux-2.6.31.orig/include/linux/iocontext.h
+++ linux-2.6.31/include/linux/iocontext.h
@@ -104,6 +104,7 @@ int put_io_context(struct io_context *io
 void exit_io_context(void);
 struct io_context *get_io_context(gfp_t gfp_flags, int node);
 struct io_context *alloc_io_context(gfp_t gfp_flags, int node);
+void init_io_context(struct io_context *ioc);
 void copy_io_context(struct io_context **pdst, struct io_context **psrc);
 #else
 static inline void exit_io_context(void)
