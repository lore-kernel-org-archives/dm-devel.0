From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 3/9] block: Add bio_reset()
Date: Tue, 28 Aug 2012 15:53:38 -0700
Message-ID: <20120828225337.GH1048@moria.home.lan>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-4-git-send-email-koverstreet@google.com>
 <20120828203148.GB24608@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120828221715.GD1048@moria.home.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120828221715.GD1048-jC9Py7bek1znysI04z7BkA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: dm-devel.ids

On Tue, Aug 28, 2012 at 03:17:15PM -0700, Kent Overstreet wrote:
> On Tue, Aug 28, 2012 at 01:31:48PM -0700, Tejun Heo wrote:
> > > +	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
> > > +
> > > +	if (bio_integrity(bio))
> > > +		bio_integrity_free(bio, bio->bi_pool);
> > > +
> > > +	bio_disassociate_task(bio);
> > 
> > Is this desirable?  Why?
> 
> *twitch* I should've thought more when I made that change.
> 
> It occurs to me now that we specifically talked about that and decided
> to do it the other way - when I changed that I was just looking at
> bio_free() and decided they needed to be symmetrical.
> 
> I still think they should be symmetrical, but if that's true bi_ioc and
> bi_css need to be moved, and also bio_disassociate_task() should be
> getting called from bio_free(), not bio_put().

Though - looking at it again I didn't actually screw anything up when I
made that change, it's just bad style.

Just screwing around a bit with the patch below, but - couple thoughts:

1) I hate duplicated code, and for the stuff in
bio_init()/bio_free()/bio_reset() it's perhaps not worth it, it is the
kind of stuff that gets out of sync.

2) It'd be better to have bio_reset() reset as much as possible, i.e. be
as close to bio_init() as posible. Fewer differences to confuse people.


diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 7c8fe1d..a38bc7d 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -148,6 +148,9 @@ void bio_integrity_free(struct bio *bio, struct bio_set *bs)
 
 	BUG_ON(bip == NULL);
 
+	if (!bs)
+		bs = fs_bio_set;
+
 	/* A cloned bio doesn't own the integrity metadata */
 	if (!bio_flagged(bio, BIO_CLONED) && !bio_flagged(bio, BIO_FS_INTEGRITY)
 	    && bip->bip_buf != NULL)
diff --git a/fs/bio.c b/fs/bio.c
index c938f42..56d8fa2 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -234,39 +234,47 @@ fallback:
 	return bvl;
 }
 
+static void bio_free_stuff(struct bio *bio)
+{
+	bio_disassociate_task(bio);
+
+	if (bio_integrity(bio))
+		bio_integrity_free(bio, bio->bi_pool);
+}
+
 void bio_free(struct bio *bio)
 {
 	struct bio_set *bs = bio->bi_pool;
 	void *p;
 
+	bio_free_stuff(bio);
+
 	if (!bs) {
-		/* Bio was allocated by bio_kmalloc() */
-		if (bio_integrity(bio))
-			bio_integrity_free(bio, fs_bio_set);
 		kfree(bio);
-		return;
-	}
-
-	if (bio_has_allocated_vec(bio))
-		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
+	} else {
+		if (bio_has_allocated_vec(bio))
+			bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
-	if (bio_integrity(bio))
-		bio_integrity_free(bio, bs);
+		/*
+		 * If we have front padding, adjust the bio pointer before freeing
+		 */
+		p = bio;
+		if (bs->front_pad)
+			p -= bs->front_pad;
 
-	/*
-	 * If we have front padding, adjust the bio pointer before freeing
-	 */
-	p = bio;
-	if (bs->front_pad)
-		p -= bs->front_pad;
+		mempool_free(p, bs->bio_pool);
+	}
+}
 
-	mempool_free(p, bs->bio_pool);
+static void __bio_init(struct bio *bio)
+{
+	memset(bio, 0, BIO_RESET_BYTES);
+	bio->bi_flags = 1 << BIO_UPTODATE;
 }
 
 void bio_init(struct bio *bio)
 {
-	memset(bio, 0, sizeof(*bio));
-	bio->bi_flags = 1 << BIO_UPTODATE;
+	__bio_init(bio);
 	atomic_set(&bio->bi_cnt, 1);
 }
 EXPORT_SYMBOL(bio_init);
@@ -275,13 +283,10 @@ void bio_reset(struct bio *bio)
 {
 	unsigned long flags = bio->bi_flags & (~0UL << BIO_RESET_BITS);
 
-	if (bio_integrity(bio))
-		bio_integrity_free(bio, bio->bi_pool);
+	bio_free_stuff(bio);
+	__bio_init(bio);
 
-	bio_disassociate_task(bio);
-
-	memset(bio, 0, BIO_RESET_BYTES);
-	bio->bi_flags = flags|(1 << BIO_UPTODATE);
+	bio->bi_flags |= flags;
 }
 EXPORT_SYMBOL(bio_reset);
 
@@ -440,10 +445,8 @@ void bio_put(struct bio *bio)
 	/*
 	 * last put frees it
 	 */
-	if (atomic_dec_and_test(&bio->bi_cnt)) {
-		bio_disassociate_task(bio);
+	if (atomic_dec_and_test(&bio->bi_cnt))
 		bio_free(bio);
-	}
 }
 EXPORT_SYMBOL(bio_put);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index ca63847..28bddc0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -68,15 +68,6 @@ struct bio {
 
 	struct bvec_iter	bi_iter;
 
-	/*
-	 * Everything starting with bi_max_vecs will be preserved by bio_reset()
-	 */
-
-	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
-
-	atomic_t		bi_cnt;		/* pin count */
-
-	struct bio_vec		*bi_io_vec;	/* the actual vec list */
 #ifdef CONFIG_BLK_CGROUP
 	/*
 	 * Optional ioc and css associated with this bio.  Put on bio
@@ -89,6 +80,16 @@ struct bio {
 	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
 
+	/*
+	 * Everything starting with bi_max_vecs will be preserved by bio_reset()
+	 */
+
+	unsigned int		bi_max_vecs;	/* max bvl_vecs we can hold */
+
+	atomic_t		bi_cnt;		/* pin count */
+
+	struct bio_vec		*bi_io_vec;	/* the actual vec list */
+
 	struct bio_set		*bi_pool;
 
 	/*
