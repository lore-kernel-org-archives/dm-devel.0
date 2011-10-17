From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm-bufio
Date: Mon, 17 Oct 2011 11:08:10 +0100
Message-ID: <20111017100808.GA4635@ubuntu>
References: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1110141500160.29246@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 14, 2011 at 03:14:34PM -0400, Mikulas Patocka wrote:
> Hi
> 
> This is a patch for dm-bufio.
> 
> Changes:
> * fixed a bug in i/o submission, introduced by someone who changed the 
> code

Could you point me at the specific part of this patch that does this
please?

> * simplified some constructs
> * more likely/unlikely hints

They clutter the code, and have been used without discrimination.  What
is the point of using it on a slow path?

> * dm-bufio.h moved from drivers/md to include/linux

Who outside dm do you expect to use this?

> * put cond_resched() to loops (it was there originally and then someone 
> deleted it)

If you're going to use cond_resched() at least do so a little more
intelligently than putting it in _every_ loop.  For instance you call it on
every iteration of a sweep through the hash table.  The call to
cond_resched will take more time than the loop body.  At least make a
change so it's only done every n'th iteration.


Can I also point out that I asked you to make a lot of these changes
over a year ago.  You've only got yourself to blame if 'someone' does
it for you.

- Someone




> 
> Mikulas
> 
> ---
>  drivers/md/Kconfig       |    2 
>  drivers/md/dm-bufio.c    |   95 ++++++++++++++++++++++++----------------
>  drivers/md/dm-bufio.h    |  110 -----------------------------------------------
>  include/linux/dm-bufio.h |  110 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 169 insertions(+), 148 deletions(-)
> 
> Index: linux-3.1-rc3-fast/drivers/md/Kconfig
> ===================================================================
> --- linux-3.1-rc3-fast.orig/drivers/md/Kconfig	2011-10-14 20:56:45.000000000 +0200
> +++ linux-3.1-rc3-fast/drivers/md/Kconfig	2011-10-14 20:56:46.000000000 +0200
> @@ -209,7 +209,7 @@ config DM_DEBUG
>  	  If unsure, say N.
>  
>  config DM_BUFIO
> -       tristate
> +       tristate "Buffered IO"
>         depends on BLK_DEV_DM && EXPERIMENTAL
>         ---help---
>  	 This interface allows you to do buffered I/O on a device and acts
> Index: linux-3.1-rc3-fast/drivers/md/dm-bufio.c
> ===================================================================
> --- linux-3.1-rc3-fast.orig/drivers/md/dm-bufio.c	2011-10-14 20:56:45.000000000 +0200
> +++ linux-3.1-rc3-fast/drivers/md/dm-bufio.c	2011-10-14 20:57:10.000000000 +0200
> @@ -167,6 +167,12 @@ static void dm_bufio_unlock(struct dm_bu
>  	mutex_unlock(&c->lock);
>  }
>  
> +#ifdef CONFIG_PREEMPT
> +#define dm_bufio_cond_resched()		do { } while (0)
> +#else
> +#define dm_bufio_cond_resched()		cond_resched()
> +#endif
> +
>  /*----------------------------------------------------------------*/
>  
>  /* Default cache size --- available memory divided by the ratio */
> @@ -470,17 +476,18 @@ static void use_inline_bio(struct dm_buf
>  	ptr = b->data;
>  	len = b->c->block_size;
>  
> -	if (len >= PAGE_SIZE)
> +	if (likely(len >= PAGE_SIZE))
>  		BUG_ON((unsigned long)ptr & (PAGE_SIZE - 1));
>  	else
>  		BUG_ON((unsigned long)ptr & (len - 1));
>  
>  	do {
> -		if (!bio_add_page(&b->bio, virt_to_page(ptr),
> -				  len < PAGE_SIZE ? len : PAGE_SIZE,
> -				  virt_to_phys(ptr) & (PAGE_SIZE - 1))) {
> +		if (unlikely(!bio_add_page(&b->bio, virt_to_page(ptr),
> +					len < PAGE_SIZE ? len : PAGE_SIZE,
> +					virt_to_phys(ptr) & (PAGE_SIZE - 1)))) {
>  			BUG_ON(b->c->block_size <= PAGE_SIZE);
>  			use_dmio(b, rw, block, end_io);
> +			return;
>  		}
>  
>  		len -= PAGE_SIZE;
> @@ -493,8 +500,10 @@ static void use_inline_bio(struct dm_buf
>  static void submit_io(struct dm_buffer *b, int rw, sector_t block,
>  		      bio_end_io_t *end_io)
>  {
> -	if (b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE &&
> -	    b->data_mode != DATA_MODE_VMALLOC)
> +	if (rw == WRITE && b->c->write_callback)
> +		b->c->write_callback(b);
> +	if (likely(b->c->block_size <= DM_BUFIO_INLINE_VECS * PAGE_SIZE) &&
> +	    likely(b->data_mode != DATA_MODE_VMALLOC))
>  		use_inline_bio(b, rw, block, end_io);
>  	else
>  		use_dmio(b, rw, block, end_io);
> @@ -514,7 +523,7 @@ static void write_endio(struct bio *bio,
>  {
>  	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
>  	b->write_error = error;
> -	if (error) {
> +	if (unlikely(error)) {
>  		struct dm_bufio_client *c = b->c;
>  		(void)cmpxchg(&c->async_write_error, 0, error);
>  	}
> @@ -550,8 +559,6 @@ static void __write_dirty_buffer(struct 
>  	clear_bit(B_DIRTY, &b->state);
>  	wait_on_bit_lock(&b->state, B_WRITING,
>  			 do_io_schedule, TASK_UNINTERRUPTIBLE);
> -	if (b->c->write_callback)
> -		b->c->write_callback(b);
>  	submit_io(b, WRITE, b->block, write_endio);
>  }
>  
> @@ -572,7 +579,7 @@ static void __make_buffer_clean(struct d
>  
>  /*
>   * Find some buffer that is not held by anybody, clean it, unlink it and
> - * return it.  If "wait" is zero, try less hard and don't block.
> + * return it.
>   */
>  static struct dm_buffer *__get_unclaimed_buffer(struct dm_bufio_client *c)
>  {
> @@ -585,6 +592,7 @@ static struct dm_buffer *__get_unclaimed
>  			__unlink_buffer(b);
>  			return b;
>  		}
> +		dm_bufio_cond_resched();
>  	}
>  
>  	list_for_each_entry_reverse(b, &c->lru[LIST_DIRTY], lru_list) {
> @@ -594,6 +602,7 @@ static struct dm_buffer *__get_unclaimed
>  			__unlink_buffer(b);
>  			return b;
>  		}
> +		dm_bufio_cond_resched();
>  	}
>  	return NULL;
>  }
> @@ -636,18 +645,21 @@ static struct dm_buffer *__alloc_buffer_
>  		 * This is useful for debugging. When we set cache size to 1,
>  		 * no new buffers are allocated at all.
>  		 */
> -		if (dm_bufio_cache_size_latch != 1) {
> +		if (likely(dm_bufio_cache_size_latch != 1)) {
>  			/*
> -			 * dm-bufio is resistant to allocation failures (it just keeps
> -			 * one buffer reserved in cases all the allocations fail).
> +			 * dm-bufio is resistant to allocation failures (it
> +			 * just keeps one buffer reserved in cases all the
> +			 * allocations fail).
>  			 * So set flags to not try too hard:
>  			 *	GFP_NOIO: don't recurse into the I/O layer
> -			 *	__GFP_NORETRY: don't retry and rather return failure
> +			 *	__GFP_NORETRY: don't retry and rather return
> +			 *			failure
>  			 *	__GFP_NOMEMALLOC: don't use emergency reserves
> -			 *	__GFP_NOWARN: don't print a warning in case of failure
> +			 *	__GFP_NOWARN: don't print a warning in case of
> +			 *			failure
>  			 */
>  			b = alloc_buffer(c, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
> -			if (b)
> +			if (likely(b != NULL))
>  				return b;
>  		}
>  
> @@ -670,7 +682,7 @@ static struct dm_buffer *__alloc_buffer_
>  static struct dm_buffer *__alloc_buffer_wait(struct dm_bufio_client *c)
>  {
>  	struct dm_buffer *b = __alloc_buffer_wait_no_callback(c);
> -	if (b && c->alloc_callback)
> +	if (c->alloc_callback)
>  		c->alloc_callback(b);
>  	return b;
>  }
> @@ -682,7 +694,7 @@ static void __free_buffer_wake(struct dm
>  {
>  	struct dm_bufio_client *c = b->c;
>  
> -	if (c->need_reserved_buffers) {
> +	if (unlikely(c->need_reserved_buffers != 0)) {
>  		list_add(&b->lru_list, &c->reserved_buffers);
>  		c->need_reserved_buffers--;
>  	} else
> @@ -704,6 +716,7 @@ static void __write_dirty_buffers_async(
>  		if (no_wait && test_bit(B_WRITING, &b->state))
>  			return;
>  		__write_dirty_buffer(b);
> +		dm_bufio_cond_resched();
>  	}
>  }
>  
> @@ -716,7 +729,7 @@ static void __get_memory_limit(struct dm
>  {
>  	unsigned long buffers;
>  
> -	if (dm_bufio_cache_size != dm_bufio_cache_size_latch) {
> +	if (unlikely(dm_bufio_cache_size != dm_bufio_cache_size_latch)) {
>  		mutex_lock(&dm_bufio_clients_lock);
>  		__cache_size_refresh();
>  		mutex_unlock(&dm_bufio_clients_lock);
> @@ -724,7 +737,7 @@ static void __get_memory_limit(struct dm
>  
>  	buffers = dm_bufio_cache_size_per_client >>
>  		  (c->sectors_per_block_bits + SECTOR_SHIFT);
> -	if (buffers < DM_BUFIO_MIN_BUFFERS)
> +	if (unlikely(buffers < DM_BUFIO_MIN_BUFFERS))
>  		buffers = DM_BUFIO_MIN_BUFFERS;
>  	*limit_buffers = buffers;
>  	*threshold_buffers = buffers * DM_BUFIO_WRITEBACK_PERCENT / 100;
> @@ -747,6 +760,7 @@ static void __check_watermark(struct dm_
>  		if (!b)
>  			return;
>  		__free_buffer_wake(b);
> +		dm_bufio_cond_resched();
>  	}
>  	if (c->n_buffers[LIST_DIRTY] > threshold_buffers)
>  		__write_dirty_buffers_async(c, 1);
> @@ -758,8 +772,9 @@ static struct dm_buffer *__find(struct d
>  	struct dm_buffer *b;
>  	struct hlist_node *hn;
>  	hlist_for_each_entry(b, hn, &c->cache_hash[DM_BUFIO_HASH(block)], hash_list) {
> -		if (b->block == block)
> +		if (likely(b->block == block))
>  			return b;
> +		dm_bufio_cond_resched();
>  	}
>  
>  	return NULL;
> @@ -775,12 +790,13 @@ enum new_flag {
>  	NF_GET = 2
>  };
>  
> -static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block, enum new_flag nf,
> -				     struct dm_buffer **bp, int *need_submit)
> +static void read_endio(struct bio *bio, int error);
> +
> +static struct dm_buffer *__bufio_new(struct dm_bufio_client *c, sector_t block,
> +				     enum new_flag nf, struct dm_buffer **bp)
>  {
>  	struct dm_buffer *b, *new_b = NULL;
>  
> -	*need_submit = 0;
>  	b = __find(c, block);
>  	if (b) {
>  		b->hold_count++;
> @@ -821,7 +837,9 @@ static struct dm_buffer *__bufio_new(str
>  	}
>  
>  	b->state = 1 << B_READING;
> -	*need_submit = 1;
> +
> +	submit_io(b, READ, b->block, read_endio);
> +
>  	return b;
>  }
>  
> @@ -849,22 +867,18 @@ static void read_endio(struct bio *bio, 
>  static void *new_read(struct dm_bufio_client *c, sector_t block, enum new_flag nf,
>  		      struct dm_buffer **bp)
>  {
> -	int need_submit;
>  	struct dm_buffer *b;
>  
>  	dm_bufio_lock(c);
> -	b = __bufio_new(c, block, nf, bp, &need_submit);
> +	b = __bufio_new(c, block, nf, bp);
>  	dm_bufio_unlock(c);
>  
> -	if (!b || IS_ERR(b))
> +	if (unlikely(!b) || unlikely(IS_ERR(b)))
>  		return b;
>  	else {
> -		if (need_submit)
> -			submit_io(b, READ, b->block, read_endio);
> -
>  		wait_on_bit(&b->state, B_READING,
>  			    do_io_schedule, TASK_UNINTERRUPTIBLE);
> -		if (b->read_error != 0) {
> +		if (unlikely(b->read_error != 0)) {
>  			int error = b->read_error;
>  			dm_bufio_release(b);
>  			return ERR_PTR(error);
> @@ -904,7 +918,7 @@ void dm_bufio_release(struct dm_buffer *
>  	BUG_ON(test_bit(B_READING, &b->state));
>  	BUG_ON(!b->hold_count);
>  	b->hold_count--;
> -	if (!b->hold_count) {
> +	if (likely(!b->hold_count)) {
>  		wake_up(&c->free_buffer_wait);
>  
>  		/*
> @@ -912,7 +926,7 @@ void dm_bufio_release(struct dm_buffer *
>  		 * to be written, free the buffer. There is no point in caching
>  		 * invalid buffer.
>  		 */
> -		if ((b->read_error || b->write_error) &&
> +		if (unlikely((b->read_error | b->write_error) != 0) &&
>  		    !test_bit(B_WRITING, &b->state) &&
>  		    !test_bit(B_DIRTY, &b->state)) {
>  			__unlink_buffer(b);
> @@ -999,15 +1013,19 @@ again:
>  		 * someone is doing some writes simultaneously with us --- in
>  		 * this case, stop dropping the lock.
>  		 */
> +		dm_bufio_cond_resched();
>  		if (dropped_lock)
>  			goto again;
>  	}
>  	wake_up(&c->free_buffer_wait);
>  	dm_bufio_unlock(c);
>  
> -	a = xchg(&c->async_write_error, 0);
> +	if (likely(!c->async_write_error))
> +		a = 0;
> +	else
> +		a = xchg(&c->async_write_error, 0);
>  	f = dm_bufio_issue_flush(c);
> -	if (a)
> +	if (unlikely(a != 0))
>  		return a;
>  	return f;
>  }
> @@ -1071,7 +1089,7 @@ retry:
>  	BUG_ON(!b->hold_count);
>  	BUG_ON(test_bit(B_READING, &b->state));
>  	__write_dirty_buffer(b);
> -	if (b->hold_count == 1) {
> +	if (likely(b->hold_count == 1)) {
>  		wait_on_bit(&b->state, B_WRITING,
>  			    do_io_schedule, TASK_UNINTERRUPTIBLE);
>  		set_bit(B_DIRTY, &b->state);
> @@ -1193,6 +1211,7 @@ static void __scan(struct dm_bufio_clien
>  				if (!--nr_to_scan)
>  					return;
>  			}
> +			dm_bufio_cond_resched();
>  		}
>  	}
>  }
> @@ -1406,9 +1425,11 @@ static void cleanup_old_buffers(void)
>  				       struct dm_buffer, lru_list);
>  			if (__cleanup_old_buffer(b, 0, max_age))
>  				break;
> +			dm_bufio_cond_resched();
>  		}
>  
>  		dm_bufio_unlock(c);
> +		dm_bufio_cond_resched();
>  	}
>  	mutex_unlock(&dm_bufio_clients_lock);
>  }
> Index: linux-3.1-rc3-fast/drivers/md/dm-bufio.h
> ===================================================================
> --- linux-3.1-rc3-fast.orig/drivers/md/dm-bufio.h	2011-10-14 20:56:45.000000000 +0200
> +++ /dev/null	1970-01-01 00:00:00.000000000 +0000
> @@ -1,110 +0,0 @@
> -/*
> - * Copyright (C) 2009-2011 2011 Red Hat, Inc.
> - *
> - * This file is released under the GPL.
> - */
> -
> -#ifndef DM_BUFIO_H
> -#define DM_BUFIO_H
> -
> -#include <linux/blkdev.h>
> -#include <linux/types.h>
> -
> -/*----------------------------------------------------------------*/
> -
> -struct dm_bufio_client;
> -struct dm_buffer;
> -
> -/*
> - * Create a buffered IO cache on a given device
> - */
> -struct dm_bufio_client *
> -dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
> -		       unsigned reserved_buffers, unsigned aux_size,
> -		       void (*alloc_callback)(struct dm_buffer *),
> -		       void (*write_callback)(struct dm_buffer *));
> -
> -/*
> - * Release a buffered IO cache.
> - */
> -void dm_bufio_client_destroy(struct dm_bufio_client *c);
> -
> -/*
> - * WARNING: to avoid deadlocks, these conditions are observed:
> - *
> - * - At most one thread can hold at most "reserved_buffers" simultaneously.
> - * - Each other threads can hold at most one buffer.
> - * - Threads which call only dm_bufio_get can hold unlimited number of
> - *   buffers.
> - */
> -
> -/*
> - * Read a given block from disk. Returns pointer to data.  Returns a
> - * pointer to dm_buffer that can be used to release the buffer or to make
> - * it dirty.
> - */
> -void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
> -		    struct dm_buffer **bp);
> -
> -/*
> - * Like dm_bufio_read, but return buffer from cache, don't read
> - * it. If the buffer is not in the cache, return NULL.
> - */
> -void *dm_bufio_get(struct dm_bufio_client *c, sector_t block,
> -		   struct dm_buffer **bp);
> -
> -/*
> - * Like dm_bufio_read, but don't read anything from the disk.  It is
> - * expected that the caller initializes the buffer and marks it dirty.
> - */
> -void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
> -		   struct dm_buffer **bp);
> -
> -/*
> - * Release a reference obtained with dm_bufio_{read,get,new}. The data
> - * pointer and dm_buffer pointer is no longer valid after this call.
> - */
> -void dm_bufio_release(struct dm_buffer *b);
> -
> -/*
> - * Mark a buffer dirty. It should be called after the buffer is modified.
> - *
> - * In case of memory pressure, the buffer may be written after
> - * dm_bufio_mark_buffer_dirty, but before dm_bufio_write_dirty_buffers.  So
> - * dm_bufio_write_dirty_buffers guarantees that the buffer is on-disk but
> - * the actual writing may occur earlier.
> - */
> -void dm_bufio_mark_buffer_dirty(struct dm_buffer *b);
> -
> -/*
> - * Initiate writing of dirty buffers, without waiting for completion.
> - */
> -void dm_bufio_write_dirty_buffers_async(struct dm_bufio_client *c);
> -
> -/*
> - * Write all dirty buffers. Guarantees that all dirty buffers created prior
> - * to this call are on disk when this call exits.
> - */
> -int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c);
> -
> -/*
> - * Send an empty write barrier to the device to flush hardware disk cache.
> - */
> -int dm_bufio_issue_flush(struct dm_bufio_client *c);
> -
> -/*
> - * Like dm_bufio_release but also move the buffer to the new
> - * block. dm_bufio_write_dirty_buffers is needed to commit the new block.
> - */
> -void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block);
> -
> -unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
> -sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
> -sector_t dm_bufio_get_block_number(struct dm_buffer *b);
> -void *dm_bufio_get_block_data(struct dm_buffer *b);
> -void *dm_bufio_get_aux_data(struct dm_buffer *b);
> -struct dm_bufio_client *dm_bufio_get_client(struct dm_buffer *b);
> -
> -/*----------------------------------------------------------------*/
> -
> -#endif
> Index: linux-3.1-rc3-fast/include/linux/dm-bufio.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-3.1-rc3-fast/include/linux/dm-bufio.h	2011-10-14 20:56:46.000000000 +0200
> @@ -0,0 +1,110 @@
> +/*
> + * Copyright (C) 2009-2011 2011 Red Hat, Inc.
> + *
> + * This file is released under the GPL.
> + */
> +
> +#ifndef DM_BUFIO_H
> +#define DM_BUFIO_H
> +
> +#include <linux/blkdev.h>
> +#include <linux/types.h>
> +
> +/*----------------------------------------------------------------*/
> +
> +struct dm_bufio_client;
> +struct dm_buffer;
> +
> +/*
> + * Create a buffered IO cache on a given device
> + */
> +struct dm_bufio_client *
> +dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
> +		       unsigned reserved_buffers, unsigned aux_size,
> +		       void (*alloc_callback)(struct dm_buffer *),
> +		       void (*write_callback)(struct dm_buffer *));
> +
> +/*
> + * Release a buffered IO cache.
> + */
> +void dm_bufio_client_destroy(struct dm_bufio_client *c);
> +
> +/*
> + * WARNING: to avoid deadlocks, these conditions are observed:
> + *
> + * - At most one thread can hold at most "reserved_buffers" simultaneously.
> + * - Each other threads can hold at most one buffer.
> + * - Threads which call only dm_bufio_get can hold unlimited number of
> + *   buffers.
> + */
> +
> +/*
> + * Read a given block from disk. Returns pointer to data.  Returns a
> + * pointer to dm_buffer that can be used to release the buffer or to make
> + * it dirty.
> + */
> +void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
> +		    struct dm_buffer **bp);
> +
> +/*
> + * Like dm_bufio_read, but return buffer from cache, don't read
> + * it. If the buffer is not in the cache, return NULL.
> + */
> +void *dm_bufio_get(struct dm_bufio_client *c, sector_t block,
> +		   struct dm_buffer **bp);
> +
> +/*
> + * Like dm_bufio_read, but don't read anything from the disk.  It is
> + * expected that the caller initializes the buffer and marks it dirty.
> + */
> +void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
> +		   struct dm_buffer **bp);
> +
> +/*
> + * Release a reference obtained with dm_bufio_{read,get,new}. The data
> + * pointer and dm_buffer pointer is no longer valid after this call.
> + */
> +void dm_bufio_release(struct dm_buffer *b);
> +
> +/*
> + * Mark a buffer dirty. It should be called after the buffer is modified.
> + *
> + * In case of memory pressure, the buffer may be written after
> + * dm_bufio_mark_buffer_dirty, but before dm_bufio_write_dirty_buffers.  So
> + * dm_bufio_write_dirty_buffers guarantees that the buffer is on-disk but
> + * the actual writing may occur earlier.
> + */
> +void dm_bufio_mark_buffer_dirty(struct dm_buffer *b);
> +
> +/*
> + * Initiate writing of dirty buffers, without waiting for completion.
> + */
> +void dm_bufio_write_dirty_buffers_async(struct dm_bufio_client *c);
> +
> +/*
> + * Write all dirty buffers. Guarantees that all dirty buffers created prior
> + * to this call are on disk when this call exits.
> + */
> +int dm_bufio_write_dirty_buffers(struct dm_bufio_client *c);
> +
> +/*
> + * Send an empty write barrier to the device to flush hardware disk cache.
> + */
> +int dm_bufio_issue_flush(struct dm_bufio_client *c);
> +
> +/*
> + * Like dm_bufio_release but also move the buffer to the new
> + * block. dm_bufio_write_dirty_buffers is needed to commit the new block.
> + */
> +void dm_bufio_release_move(struct dm_buffer *b, sector_t new_block);
> +
> +unsigned dm_bufio_get_block_size(struct dm_bufio_client *c);
> +sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
> +sector_t dm_bufio_get_block_number(struct dm_buffer *b);
> +void *dm_bufio_get_block_data(struct dm_buffer *b);
> +void *dm_bufio_get_aux_data(struct dm_buffer *b);
> +struct dm_bufio_client *dm_bufio_get_client(struct dm_buffer *b);
> +
> +/*----------------------------------------------------------------*/
> +
> +#endif
