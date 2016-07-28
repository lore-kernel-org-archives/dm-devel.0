From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: bcache super block corruption with non 4k pages
Date: Wed, 27 Jul 2016 21:55:03 -0800
Message-ID: <20160728055503.GA3009@kmo-pixel>
References: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
 <fce2a0a9-47d1-a052-997c-b14cd62dcf46@canonical.com>
 <20160726102148.GA20130@kmo-pixel>
 <e09788a2-71f4-96ff-cca4-943c1bc1d9bb@canonical.com>
 <20160726124918.GA15102@kmo-pixel>
 <6a0f7c6d-ac26-22cb-9cc7-aeceb34ac2ba@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6a0f7c6d-ac26-22cb-9cc7-aeceb34ac2ba@canonical.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, liuzhengyuang521@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com
List-Id: dm-devel.ids

On Wed, Jul 27, 2016 at 05:16:36PM +0200, Stefan Bader wrote:
> So here is another attempt which does half the proposed changes. And before you
> point out that it looks still ugly, let me explain some reasons. The goal for me
> would be to have something as small as possible to be acceptable as stable change.
> And the part about putting a bio on the stack and using submit_bio_wait: I
> believe you meant in read_super to replace the __bread. I was thinking about
> that but in the end it seemed to make the change unnecessary big. Whether using
> __bread or submit_bio_wait, in both cases and without needing to make more
> changes on the write side, read_super has to return the in-memory and on-disk
> variant of the superblock. So as long as nothing that is related to __bread is
> leaked out of read_super, it is much better than what is there now. And I remain
> as small as possible for the delta.

I like that approach much better. I suppose it's not _strictly_ necessary to rip
out the __bread()...

Only other comment is that you shouldn't have to pass the buffer to
__write_super() - I'd just move the bch_bio_map() call to when the struct
cache/cached_dev is being initialized (or rip it out and initialize the bvec by
hand) and never touch it after that.

> So there is one part of the patch which I find hard to do in a better manner but
> is a bit ugly: and that is to sanely free the sb_disk_data blob on all error
> paths but not on success when it is assigned to either cache or cached_dev.
> Could possibly pass the address of the pointer and then clear it inside the
> called functions. Not sure that would be much less strange...

Yeah that is a hassle - that's why in the 4k superblocks patch in bcache-dev I
added that "disk_sb" struct - it owns the buffer and random other crap. You
could read that patch for ideas if you want, look at how it transfers ownership
of the disk_sb. 

> From 391682e2329a6f8608bfc7628b6c8a0afa9a5d98 Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Tue, 26 Jul 2016 18:47:21 +0200
> Subject: [PATCH] bcache: read_super: handle architectures with more than 4k
>  page size
> 
> There is no guarantee that the superblock which __bread returns in
> a buffer_head starts at offset 0 when an architecture has bigger
> pages than 4k (the used sector size).
> 
> This is the attempt to fix this with the minimum amount of change
> by having a buffer allocated with kmalloc that holds the superblock
> data as it is on disk.
> This buffer can then be passed to bch_map_bio which will set up the
> bio_vec correctly.
> 
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  drivers/md/bcache/bcache.h |  2 ++
>  drivers/md/bcache/super.c  | 61 ++++++++++++++++++++++++++--------------------
>  2 files changed, 36 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/md/bcache/bcache.h b/drivers/md/bcache/bcache.h
> index 6b420a5..3c48927 100644
> --- a/drivers/md/bcache/bcache.h
> +++ b/drivers/md/bcache/bcache.h
> @@ -295,6 +295,7 @@ struct cached_dev {
>  	struct cache_sb		sb;
>  	struct bio		sb_bio;
>  	struct bio_vec		sb_bv[1];
> +	void			*sb_disk_data;
>  	struct closure		sb_write;
>  	struct semaphore	sb_write_mutex;
>  
> @@ -382,6 +383,7 @@ struct cache {
>  	struct cache_sb		sb;
>  	struct bio		sb_bio;
>  	struct bio_vec		sb_bv[1];
> +	void			*sb_disk_data;
>  
>  	struct kobject		kobj;
>  	struct block_device	*bdev;
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index e169739..f017f69 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -62,7 +62,7 @@ struct workqueue_struct *bcache_wq;
>  /* Superblock */
>  
>  static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
> -			      struct page **res)
> +			      void *sb_data)
>  {
>  	const char *err;
>  	struct cache_sb *s;
> @@ -191,8 +191,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
>  	sb->last_mount = get_seconds();
>  	err = NULL;
>  
> -	get_page(bh->b_page);
> -	*res = bh->b_page;
> +	memcpy(sb_data, bh->b_data, SB_SIZE);
>  err:
>  	put_bh(bh);
>  	return err;
> @@ -206,15 +205,15 @@ static void write_bdev_super_endio(struct bio *bio)
>  	closure_put(&dc->sb_write);
>  }
>  
> -static void __write_super(struct cache_sb *sb, struct bio *bio)
> +static void __write_super(struct cache_sb *sb, struct bio *bio, void *sb_data)
>  {
> -	struct cache_sb *out = page_address(bio->bi_io_vec[0].bv_page);
> +	struct cache_sb *out = sb_data;
>  	unsigned i;
>  
>  	bio->bi_iter.bi_sector	= SB_SECTOR;
>  	bio->bi_rw		= REQ_SYNC|REQ_META;
>  	bio->bi_iter.bi_size	= SB_SIZE;
> -	bch_bio_map(bio, NULL);
> +	bch_bio_map(bio, sb_data);
>  
>  	out->offset		= cpu_to_le64(sb->offset);
>  	out->version		= cpu_to_le64(sb->version);
> @@ -262,7 +261,7 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
>  	bio->bi_private = dc;
>  
>  	closure_get(cl);
> -	__write_super(&dc->sb, bio);
> +	__write_super(&dc->sb, bio, dc->sb_disk_data);
>  
>  	closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
>  }
> @@ -308,7 +307,7 @@ void bcache_write_super(struct cache_set *c)
>  		bio->bi_private = ca;
>  
>  		closure_get(cl);
> -		__write_super(&ca->sb, bio);
> +		__write_super(&ca->sb, bio, ca->sb_disk_data);
>  	}
>  
>  	closure_return_with_destructor(cl, bcache_write_super_unlock);
> @@ -1045,6 +1044,8 @@ void bch_cached_dev_release(struct kobject *kobj)
>  {
>  	struct cached_dev *dc = container_of(kobj, struct cached_dev,
>  					     disk.kobj);
> +
> +	kfree(dc->sb_disk_data);
>  	kfree(dc);
>  	module_put(THIS_MODULE);
>  }
> @@ -1138,7 +1139,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
>  
>  /* Cached device - bcache superblock */
>  
> -static void register_bdev(struct cache_sb *sb, struct page *sb_page,
> +static void register_bdev(struct cache_sb *sb, void *sb_disk_data,
>  				 struct block_device *bdev,
>  				 struct cached_dev *dc)
>  {
> @@ -1152,9 +1153,8 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
>  
>  	bio_init(&dc->sb_bio);
>  	dc->sb_bio.bi_max_vecs	= 1;
> -	dc->sb_bio.bi_io_vec	= dc->sb_bio.bi_inline_vecs;
> -	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
> -	get_page(sb_page);
> +	dc->sb_bio.bi_io_vec	= &dc->sb_bv[0];
> +	dc->sb_disk_data	= sb_disk_data;
>  
>  	if (cached_dev_init(dc, sb->block_size << 9))
>  		goto err;
> @@ -1179,6 +1179,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
>  	return;
>  err:
>  	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
> +	kfree(sb_disk_data);
>  	bcache_device_stop(&dc->disk);
>  }
>  
> @@ -1793,8 +1794,7 @@ void bch_cache_release(struct kobject *kobj)
>  	for (i = 0; i < RESERVE_NR; i++)
>  		free_fifo(&ca->free[i]);
>  
> -	if (ca->sb_bio.bi_inline_vecs[0].bv_page)
> -		put_page(ca->sb_bio.bi_io_vec[0].bv_page);
> +	kfree(ca->sb_disk_data);
>  
>  	if (!IS_ERR_OR_NULL(ca->bdev))
>  		blkdev_put(ca->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
> @@ -1838,7 +1838,7 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
>  	return 0;
>  }
>  
> -static int register_cache(struct cache_sb *sb, struct page *sb_page,
> +static int register_cache(struct cache_sb *sb, void *sb_disk_data,
>  				struct block_device *bdev, struct cache *ca)
>  {
>  	char name[BDEVNAME_SIZE];
> @@ -1851,16 +1851,17 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
>  
>  	bio_init(&ca->sb_bio);
>  	ca->sb_bio.bi_max_vecs	= 1;
> -	ca->sb_bio.bi_io_vec	= ca->sb_bio.bi_inline_vecs;
> -	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
> -	get_page(sb_page);
> +	ca->sb_bio.bi_io_vec	= &ca->sb_bv[0];
> +	ca->sb_disk_data	= sb_disk_data;
>  
>  	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
>  		ca->discard = CACHE_DISCARD(&ca->sb);
>  
>  	ret = cache_alloc(sb, ca);
> -	if (ret != 0)
> +	if (ret != 0) {
> +		err = "error calling cache_alloc";
>  		goto err;
> +	}
>  
>  	if (kobject_add(&ca->kobj, &part_to_dev(bdev->bd_part)->kobj, "bcache")) {
>  		err = "error calling kobject_add";
> @@ -1883,8 +1884,10 @@ out:
>  	kobject_put(&ca->kobj);
>  
>  err:
> -	if (err)
> +	if (err) {
>  		pr_notice("error opening %s: %s", bdevname(bdev, name), err);
> +		kfree(sb_disk_data);
> +	}
>  
>  	return ret;
>  }
> @@ -1935,13 +1938,14 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	char *path = NULL;
>  	struct cache_sb *sb = NULL;
>  	struct block_device *bdev = NULL;
> -	struct page *sb_page = NULL;
> +	void *sb_disk_data = NULL;
>  
>  	if (!try_module_get(THIS_MODULE))
>  		return -EBUSY;
>  
>  	if (!(path = kstrndup(buffer, size, GFP_KERNEL)) ||
> -	    !(sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL)))
> +	    !(sb = kmalloc(sizeof(struct cache_sb), GFP_KERNEL)) ||
> +	    !(sb_disk_data = kmalloc(SB_SIZE, GFP_KERNEL)))
>  		goto err;
>  
>  	err = "failed to open device";
> @@ -1967,7 +1971,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  	if (set_blocksize(bdev, 4096))
>  		goto err_close;
>  
> -	err = read_super(sb, bdev, &sb_page);
> +	err = read_super(sb, bdev, sb_disk_data);
>  	if (err)
>  		goto err_close;
>  
> @@ -1977,20 +1981,23 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
>  			goto err_close;
>  
>  		mutex_lock(&bch_register_lock);
> -		register_bdev(sb, sb_page, bdev, dc);
> +		register_bdev(sb, sb_disk_data, bdev, dc);
> +		sb_disk_data = NULL; /* Consumed or freed in register call */
>  		mutex_unlock(&bch_register_lock);
>  	} else {
>  		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
>  		if (!ca)
>  			goto err_close;
>  
> -		if (register_cache(sb, sb_page, bdev, ca) != 0)
> +		if (register_cache(sb, sb_disk_data, bdev, ca) != 0) {
> +			sb_disk_data = NULL;
>  			goto err_close;
> +		}
> +		sb_disk_data = NULL;
>  	}
>  out:
> -	if (sb_page)
> -		put_page(sb_page);
>  	kfree(sb);
> +	kfree(sb_disk_data);
>  	kfree(path);
>  	module_put(THIS_MODULE);
>  	return ret;
> -- 
> 1.9.1
> 
