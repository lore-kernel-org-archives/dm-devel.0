From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 4/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:54:33 +0900 (JST)
Message-ID: <20080422.225433.113622843.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


Make the aio kernel thread work on the iocontext of the process
which request an I/O.


Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/include/linux/aio.h	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/include/linux/aio.h	2008-04-22 15:52:07.000000000 +0900
@@ -181,6 +181,7 @@ struct kioctx {
 	atomic_t		users;
 	int			dead;
 	struct mm_struct	*mm;
+	struct io_context	*io_context;
 
 	/* This needs improving */
 	unsigned long		user_id;
--- linux-2.6.25.bio0/fs/aio.c	2008-04-22 15:48:31.000000000 +0900
+++ linux-2.6.25/fs/aio.c	2008-04-22 15:52:07.000000000 +0900
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/security.h>
 #include <linux/eventfd.h>
+#include <linux/blkdev.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -217,6 +218,10 @@ static struct kioctx *ioctx_alloc(unsign
 	mm = ctx->mm = current->mm;
 	atomic_inc(&mm->mm_count);
 
+	ctx->io_context = get_io_context(GFP_KERNEL, -1);
+	if (!ctx->io_context)
+		goto out_freectx2;
+
 	atomic_set(&ctx->users, 1);
 	spin_lock_init(&ctx->ctx_lock);
 	spin_lock_init(&ctx->ring_info.ring_lock);
@@ -255,6 +260,8 @@ out_cleanup:
 	return ERR_PTR(-EAGAIN);
 
 out_freectx:
+	put_io_context(ctx->io_context);
+out_freectx2:
 	mmdrop(mm);
 	kmem_cache_free(kioctx_cachep, ctx);
 	ctx = ERR_PTR(-ENOMEM);
@@ -376,6 +383,7 @@ void __put_ioctx(struct kioctx *ctx)
 	aio_free_ring(ctx);
 	mmdrop(ctx->mm);
 	ctx->mm = NULL;
+	put_io_context(ctx->io_context);
 	pr_debug("__put_ioctx: freeing %p\n", ctx);
 	kmem_cache_free(kioctx_cachep, ctx);
 
@@ -841,6 +849,7 @@ static void aio_kick_handler(struct work
 	struct mm_struct *mm;
 	int requeue;
 
+	current->io_context = ctx->io_context;
 	set_fs(USER_DS);
 	use_mm(ctx->mm);
 	spin_lock_irq(&ctx->ctx_lock);
@@ -849,6 +858,7 @@ static void aio_kick_handler(struct work
 	spin_unlock_irq(&ctx->ctx_lock);
  	unuse_mm(mm);
 	set_fs(oldfs);
+	current->io_context = NULL;
 	/*
 	 * we're in a worker thread already, don't use queue_delayed_work,
 	 */
