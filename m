From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Date: Wed, 30 May 2012 18:09:41 -0700
Message-ID: <20120531010940.GB5645@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
 <20120530074708.GA32121@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120530074708.GA32121-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

On Wed, May 30, 2012 at 04:47:08PM +0900, Tejun Heo wrote:
> A couple more comments from this round of reading.
> 
> On Wed, May 09, 2012 at 11:10:48PM -0400, Kent Overstreet wrote:
> > +#define btree_prio		USHRT_MAX
> > +#define initial_prio		32768
> 
> Why are these in lower case?

No good reason. I'll change it.

> 
> > +#define PTR_BUCKET(c, k, n)						\
> > +	(PTR_CACHE(c, k, n)->buckets + PTR_BUCKET_NR(c, k, n))
> 
> PTR_BUCKET(c, k, n)
> 
> Awesome.  I don't know what type it takes or what each single
> character argument stands for.

Yeah, that should be an inline function, along with some others. Fixed -
well, have to convert the rest of the code to the lowercase names:

Maybe ptr_bucket_idx() instead of ptr_bucket_nr()?

diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
index 1011a73..0617885 100644
--- a/drivers/md/bcache/bcache.h
+++ b/drivers/md/bcache/bcache.h
@@ -717,15 +717,41 @@ PTR_FIELD(PTR_GEN,		0,  8)
 #define PTR(gen, offset, dev)						\
 	((((uint64_t) dev) << 51) | ((uint64_t) offset) << 8 | gen)
 
-#define sector_to_bucket(c, s)	((long) ((s) >> (c)->bucket_bits))
-#define bucket_to_sector(c, b)	(((sector_t) (b)) << (c)->bucket_bits)
-#define bucket_remainder(c, b)	((b) & ((c)->sb.bucket_size - 1))
+static inline size_t sector_to_bucket(struct cache_set *c, sector_t s)
+{
+	return s >> c->bucket_bits;
+}
+
+static inline sector_t bucket_to_sector(struct cache_set *c, size_t b)
+{
+	return ((sector_t) b) << c->bucket_bits;
+}
 
-#define PTR_CACHE(c, k, n)	((c)->cache[PTR_DEV(k, n)])
-#define PTR_BUCKET_NR(c, k, n)	sector_to_bucket(c, PTR_OFFSET(k, n))
+static inline sector_t bucket_remainder(struct cache_set *c, sector_t s)
+{
+	return s & (c->sb.bucket_size - 1);
+}
 
-#define PTR_BUCKET(c, k, n)						\
-	(PTR_CACHE(c, k, n)->buckets + PTR_BUCKET_NR(c, k, n))
+static inline struct cache *ptr_cache(struct cache_set *c,
+				      struct bkey *k,
+				      unsigned ptr)
+{
+	return c->cache[PTR_DEV(k, ptr)];
+}
+
+static inline size_t ptr_bucket_nr(struct cache_set *c,
+				   struct bkey *k,
+				   unsigned ptr)
+{
+	return sector_to_bucket(c, PTR_OFFSET(k, ptr));
+}
+
+static inline struct bucket *ptr_bucket(struct cache_set *c,
+					struct bkey *k,
+					unsigned ptr)
+{
+	return ptr_cache(c, k, ptr)->buckets + ptr_bucket_nr(c, k, ptr);
+}
 
 /* Btree key macros */
 
> 
> > +static inline bool cached_dev_get(struct cached_dev *d)
> > +{
> > +	if (!atomic_inc_not_zero(&d->count))
> > +		return false;
> > +
> > +	smp_mb__after_atomic_inc();
> 
> What is this mb() paired with?  Whenever using a mb, please specify
> what the mb is paired with.

super.c, cached_dev_attach():

	smp_wmb();
	/* d->c must be set before d->count != 0 */
	atomic_set(&d->count, 1);

I'm improving the comments.

> 
> > +	return true;
> > +}
> 
> Thanks.
> 
> -- 
> tejun
