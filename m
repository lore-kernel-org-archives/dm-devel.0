From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Consolidate bio_clone_bioset(), bio_kmalloc()
Date: Wed, 8 Aug 2012 19:38:11 -0700
Message-ID: <20120809023811.GJ7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-11-git-send-email-koverstreet@google.com>
 <20120808231552.GJ6983@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120808231552.GJ6983-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 04:15:52PM -0700, Tejun Heo wrote:
> > +struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
> > +{
> > +	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
> 
> Can't we use %NULL bioset as an indication to allocate from kmalloc
> instead of duping interfaces like this?

So, if bio_clone_bioset(gfp, nr_iovecs, BIO_KMALLOC_POOL) just does
bio_kmalloc(), the rest just falls out naturally.

We could do this by either just having bio_clone_bioset() call
bio_kmalloc(), or consolidate them both into a single function.

I'm leaning towards the latter, because while looking at it I noticed a
couple subtle behavioural differences.

 * bio_kmalloc(GFP_KERNEL, 0) sets bi_io_vec = bi_inline_vecs,
bio_alloc_bioset sets it to NULL. This is a bug waiting to happen, if it
isn't one already - bi_io_vec != NULL is exactly what bio_has_data()
checks.

 * bio_alloc_bioset() could return a bio with bi_max_vecs greater than
requested if you asked for a bio with fewer than BIO_INLINE_VECS.
Unlikely to ever be a real problem, but subtle enough that I wouldn't
bet too much against it.

 * bio_kmalloc() fails if asked for more than UIO_MAXIOV bvecs (wtf!?),
which is 1024; bio_alloc_bioset fails if asked for more than
BIO_MAX_PAGES (which is 256, and it'd probably take you a bit to see
where/why it fails).

So here's my initial stab at it. Tell me if you think this is too
contorted:


diff --git a/fs/bio.c b/fs/bio.c
index 22596af..c852665 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -295,34 +295,45 @@ EXPORT_SYMBOL(bio_reset);
  **/
 struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 {
+	unsigned front_pad;
+	unsigned inline_vecs;
 	unsigned long idx = BIO_POOL_NONE;
 	struct bio_vec *bvl = NULL;
 	struct bio *bio;
 	void *p;
 
-	p = mempool_alloc(bs->bio_pool, gfp_mask);
+	if (nr_iovecs > UIO_MAXIOV)
+		return NULL;
+
+	if (bs == BIO_KMALLOC_POOL) {
+		p = kmalloc(sizeof(struct bio) +
+			    nr_iovecs * sizeof(struct bio_vec),
+			    gfp_mask);
+		front_pad = 0;
+		inline_vecs = nr_iovecs;
+	} else {
+		p = mempool_alloc(bs->bio_pool, gfp_mask);
+		front_pad = bs->front_pad;
+		inline_vecs = BIO_INLINE_VECS;
+	}
+
 	if (unlikely(!p))
 		return NULL;
-	bio = p + bs->front_pad;
 
+	bio = p + front_pad;
 	bio_init(bio);
-	bio->bi_pool = bs;
-
-	if (unlikely(!nr_iovecs))
-		goto out_set;
 
-	if (nr_iovecs <= BIO_INLINE_VECS) {
-		bvl = bio->bi_inline_vecs;
-		nr_iovecs = BIO_INLINE_VECS;
-	} else {
+	if (nr_iovecs > inline_vecs) {
 		bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
 		if (unlikely(!bvl))
 			goto err_free;
 
-		nr_iovecs = bvec_nr_vecs(idx);
 		bio->bi_flags |= 1 << BIO_OWNS_VEC;
+	} else if (nr_iovecs) {
+		bvl = bio->bi_inline_vecs;
 	}
-out_set:
+
+	bio->bi_pool = bs;
 	bio->bi_flags |= idx << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bvl;
