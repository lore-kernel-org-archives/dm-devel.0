From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 1/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:51:31 +0900 (JST)
Message-ID: <20080422.225131.66125511.taka@valinux.co.jp>
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


Make every bio points the iocontext of the process which originally
generated an I/O request. 
 - Assign the iocontext of the current process to a bio when it is
   newly allocated.
 - Assign the iocontext which the source bio has to a newly allocated
   bio when it is duplicated.


Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/include/linux/bio.h	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/include/linux/bio.h	2008-04-22 15:49:42.000000000 +0900
@@ -114,6 +114,8 @@ struct bio {
 	void			*bi_private;
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
+
+	struct io_context       *bi_io_context;
 };
 
 /*
--- linux-2.6.25.bio0/include/linux/iocontext.h	2008-04-22 15:48:36.000000000 +0900
+++ linux-2.6.25/include/linux/iocontext.h	2008-04-22 15:49:42.000000000 +0900
@@ -85,7 +85,7 @@ struct io_context {
 	void *ioc_data;
 };
 
-static inline struct io_context *ioc_task_link(struct io_context *ioc)
+static inline struct io_context *ioc_object_link(struct io_context *ioc)
 {
 	/*
 	 * if ref count is zero, don't allow sharing (ioc is going away, it's
@@ -99,4 +99,6 @@ static inline struct io_context *ioc_tas
 	return NULL;
 }
 
+#define ioc_task_link(ioc)	ioc_object_link(ioc)
+
 #endif
--- linux-2.6.25.bio0/fs/bio.c	2008-04-22 15:48:31.000000000 +0900
+++ linux-2.6.25/fs/bio.c	2008-04-22 15:49:42.000000000 +0900
@@ -107,8 +107,16 @@ static inline struct bio_vec *bvec_alloc
 	return bvl;
 }
 
+static inline void put_bio_context(struct bio *bio)
+{
+	if (bio->bi_io_context)
+		put_io_context(bio->bi_io_context);
+}
+
 void bio_free(struct bio *bio, struct bio_set *bio_set)
 {
+	put_bio_context(bio);
+
 	if (bio->bi_io_vec) {
 		const int pool_idx = BIO_POOL_IDX(bio);
 
@@ -177,10 +185,29 @@ out:
 
 struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
 {
-	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
+	struct bio *bio;
+	struct io_context *ioc;
 
-	if (bio)
+	/*
+	 * Set the io_context of the current process here since this newly
+	 * created bio may be passed to a I/O scheduler through another
+	 * kernel thread in half of the process that originate this bio.
+	 * get_io_context function should called here so it can be blocked
+	 * in it.
+	 * Todo: when the current is an aio kernel thread, the io_context
+	 *       of the original process should be set instead of that of
+	 *       the thread.
+	 */
+	ioc = get_io_context(gfp_mask, -1);
+	if (!ioc)
+		return NULL;
+
+	bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
+	if (bio) {
 		bio->bi_destructor = bio_fs_destructor;
+		bio->bi_io_context = ioc;
+	} else
+		put_io_context(ioc);
 
 	return bio;
 }
@@ -262,6 +289,7 @@ void __bio_clone(struct bio *bio, struct
 	bio->bi_vcnt = bio_src->bi_vcnt;
 	bio->bi_size = bio_src->bi_size;
 	bio->bi_idx = bio_src->bi_idx;
+	bio->bi_io_context = ioc_object_link(bio_src->bi_io_context);
 }
 
 /**
