Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF3922FF38
	for <dm-devel@lists.linux.dev>; Mon,  3 Mar 2025 16:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741020927; cv=none; b=ObNG4YeF2sfT8kyGKhzmDDOJCcsx/3hKCO6dgIZAen3kNQJd1D6lbqpuMUhFC1+TqcJgs0sUYl5ledL3oYdT/k/VeSvJwIeXFtLRIfnFMavz3Nvp92HzBxbKQ9FenfBEgTm4ql4ReiDhvWcuQUn8anfxHrP74FR2HtQfqOMb6zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741020927; c=relaxed/simple;
	bh=2V4UmDwhVDsUDS8C9tM+3uE/yPoStsh6RXRhhnpM4io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=j7fw2YzWs8krcmnw79v0ZulIIys06GhU9+i0cjJvXHFL7j/1ZGCANN0u2K3AbLB3C/vQDY4hGEMG5hrajerGnW2PoezSnLcb8KOoiCDiv9lkdL4MxOwEEiGcuhxw7OLiRrfayO4PDpVY81yK9/1K8w9e7QmsbY6XLP4jklt08Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DhF9eXMw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DhF9eXMw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741020923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JcVpF0Cq9Z/iurVWjNrhhZmY76kNNpVOluk9hnPRV9Y=;
	b=DhF9eXMwK7Wi2Mns/F34ZQIJtf6xHqWLM4zcHtAB2LnkeRyIDidzP9WVy2L5UeClfvPeGV
	X+7kG90dRTXLFMeSczPEO0vPN0QNM+34zAnKuqpDulyGeelwG0W/R5C1r6P4uRm4o+ghUq
	TNi+oJHSyfllsHOlDbTs8/NWLchZcBU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-Nj_mt7z-NfqU8fP3NQbiFQ-1; Mon, 03 Mar 2025 11:55:22 -0500
X-MC-Unique: Nj_mt7z-NfqU8fP3NQbiFQ-1
X-Mimecast-MFC-AGG-ID: Nj_mt7z-NfqU8fP3NQbiFQ_1741020921
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-390f6aa50c5so1509427f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 03 Mar 2025 08:55:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741020920; x=1741625720;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcVpF0Cq9Z/iurVWjNrhhZmY76kNNpVOluk9hnPRV9Y=;
        b=QD0Fo050JgDQ8HUt95z+x17MRXh81TS34XQK+ZZbUkAL6tLDK41LnhySBHWEP4E7cB
         VB8BZgfp/bJxcNJqVFHQeHcz0jKZJY174rlR0+Ab1MLqT/sqesSPZ4CCTcJFL7w2TsQl
         Bd264LBHP2xn0YgNeojJrVnMYfg0JylF2Qm6+3VXGqv2Eu9i4h6Q2pXQYAJRXU2vsm0r
         HY4Ab7MAWwGEUzJTLqP4teEEnhi7Pe3+nhb1qAoFrs6T8JnFApumQBIspMj59aCWewx2
         T6KxrPE/9qlA9dj+iTB2TbDyIr2BO9oOW+ae7yC+whhmik25m9Cl0hA2KJkP91vvWK9q
         8+oA==
X-Forwarded-Encrypted: i=1; AJvYcCV4OD2utWUfYbM97xkGCT0DdUuH755gfktx9XJ7Dd1QjakKQw0SXVFFNNaLR7iD6m7ZQX/Bex17Ag==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywpt+zxXgl8w66qAhrcko/Ssbi0K0IBKL7nqmLUXqJzjAMm8yig
	Fhk1vUWPhDt/32gYw6GySap/P0hyaF5Ch4iYC69XEo53jZgw3RyVs/bimlKsaApKyXZaz4xvdwY
	lRwsqzou6mxqn8xesLyQOQSTnCGuXVkEhOudUEAkLFGjouO4USPNjwsv7eLck2ATMz14=
X-Gm-Gg: ASbGnct07xpBMLyoAagaRh7uRW+06jnQ92f9sRziOlckSSBRJJLCzGOrb+BKRe/e/kM
	Z6WF89sENqJ5wescXODA/A5F/MciSFRZ5IY+eN3OGuN9aEisXxG0ygAepWYS3FhHwvd+8m8EAvR
	0a0KaSr7dcYkl60w54LS6MnRSMNNnOIkv+wviSes1ploV5tzpmct2P8CLG3zM5B0oGHBHZRrp4u
	63wnSZX2oJRJJfnf1ZAKL8ahxwmL+q+jcWjsoArecUgiGoM+7y6bbVHLMcfkYw/D+2dI0bpeas0
	81DIlAW9Lja3PuayreeOGdwkwd+Jgoue/izIag==
X-Received: by 2002:a05:6000:1faa:b0:38d:e6b6:508b with SMTP id ffacd0b85a97d-390ec7cd37fmr10892782f8f.9.1741020920045;
        Mon, 03 Mar 2025 08:55:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHP1epup18M7CzSGb/oj56r/k7O11fs9JkIwPjXMavtWgIPxK2uBbgdz/oyIlQSgoiF1k40yw==
X-Received: by 2002:a05:6000:1faa:b0:38d:e6b6:508b with SMTP id ffacd0b85a97d-390ec7cd37fmr10892750f8f.9.1741020919406;
        Mon, 03 Mar 2025 08:55:19 -0800 (PST)
Received: from redhat.com (128.19.187.81.in-addr.arpa. [81.187.19.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bc596eb90sm27424035e9.17.2025.03.03.08.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 08:55:19 -0800 (PST)
Date: Mon, 3 Mar 2025 16:55:17 +0000
From: "Bryn M. Reeves" <breeves@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] the dm-loop target
Message-ID: <Z8Xe9bJQYs9TiUrO@redhat.com>
References: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <7d6ae2c9-df8e-50d0-7ad6-b787cb3cfab4@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CbVoVxeyW0kgn0H8R9D7DbBrXSbszU4zr7eB5OFsmZc_1741020921
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 03, 2025 at 11:24:27AM +0100, Mikulas Patocka wrote:
> This is the dm-loop target - a replacement for the regular loop driver 
> with better performance. The dm-loop target builds a map of the file in 
> the constructor and it just remaps bios according to this map.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

This looks like it is based on my dm-loop patch from almost 20 years
ago. Afaik the locking problems that hch pointed out back then are still
valid now - stashing the bmap lookup in memory lead to weird and hard to
debug problems back then and I don't think this has changed.

There are two other approaches that have been proposed in the mean time,
Heinz posted one about 6 years ago that uses the VFS for IO to the
backing file[1], and I posted another version in around 2012, this time
based on splitting drivers/block/loop.c into front/backend interfaces
and consuming the backend interface in dm-loop.

These mechanisms don't have the peformance gain of the in-memory block
mapping but they are safe and simpler (and may allow for more code
sharing with /dev/loop).

Regards,
Bryn.

[1] https://patchwork.kernel.org/project/dm-devel/patch/1b84af841912065fc57cfe395d5214f4eee0f0fc.1516124587.git.heinzm@redhat.com/


This implements a loopback target for device mapper allowing a regular
file to be treated as a block device.

Signed-off-by: Bryn Reeves <breeves@redhat.com>

===================================================================
diff --git a/drivers/md/dm-loop.c b/drivers/md/dm-loop.c
new file mode 100644
index 0000000..71f0287
--- /dev/null
+++ b/drivers/md/dm-loop.c
@@ -0,0 +1,1000 @@
+/*
+ * Copyright (C) 2006 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of device-mapper.
+ *
+ * drivers/md/dm-loop.c
+ *
+ * Extent mapping implementation heavily influenced by mm/swapfile.c
+ * Bryn Reeves <breeves@redhat.com>
+ *
+ * File mapping and block lookup algorithms support by
+ * Heinz Mauelshagen <hjm@redhat.com>.
+ *
+ * This file is released under the GPL.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/syscalls.h>
+#include <linux/workqueue.h>
+#include <linux/file.h>
+#include <linux/bio.h>
+
+#include "dm.h"
+#include "dm-bio-list.h"
+
+static const char *version = "v0.419";
+#define DAEMON "kloopd"
+#define DM_MSG_PREFIX "loop"
+
+enum flags { LOOP_BMAP, LOOP_FSIO };
+
+/*--------------------------------------------------------------------
+ * Loop context
+ *--------------------------------------------------------------------*/
+
+struct loop_c {
+	unsigned long flags;
+
+	/* information describing the backing store */
+	struct file *filp;		/* loop file handle */
+	char *path;			/* path argument */
+	loff_t offset;			/* offset argument */
+	struct block_device *bdev;	/* block device */
+	unsigned blkbits;		/* file system block size shift bits */
+
+	loff_t size;			/* size of entire file in bytes */
+	loff_t blocks;			/* blocks allocated to loop file */
+	sector_t mapped_sectors;	/* size of mapped area in sectors*/
+
+	/* mapping */
+	int (*map_fn)(struct dm_target*, struct bio*);
+	/* mapping function private data */
+	void *map_data;
+};
+
+/*
+ * block map extent
+ */
+struct extent {
+	sector_t start; 		/* start sector in mapped device */
+	sector_t to;			/* start sector on target device */
+	sector_t len;			/* length in sectors */
+};
+
+/*
+ * temporary extent list
+ */
+struct extent_list {
+	struct extent * extent;
+	struct list_head list;
+};
+
+struct kmem_cache *extent_cache;
+
+/*
+ * block map private context
+ */
+struct block_map_c {
+	int nr_extents;			/* number of extents in map */
+	struct extent **map;		/* linear map of extent pointers */
+	struct extent **mru;		/* pointer to mru entry */
+	spinlock_t mru_lock;		/* protects mru */
+};
+
+/*
+ * file map private context
+ */
+struct file_map_c {
+	spinlock_t lock;		/* protects in */
+	struct bio_list in;		/* new bios for processing */
+	struct bio_list work;		/* bios queued for processing */
+	struct workqueue_struct *wq;	/* workqueue */
+	struct work_struct ws;		/* loop work */
+	struct loop_c *loop;		/* for filp & offset */
+};
+
+/*--------------------------------------------------------------------
+ * Generic helpers
+ *--------------------------------------------------------------------*/
+
+static inline sector_t blk2sec(struct loop_c *lc, blkcnt_t block)
+{
+	return block << (lc->blkbits - SECTOR_SHIFT);
+}
+
+static inline blkcnt_t sec2blk(struct loop_c *lc, sector_t sector)
+{
+	return sector >> (lc->blkbits - SECTOR_SHIFT);
+}
+
+/*--------------------------------------------------------------------
+ * File I/O helpers
+ *--------------------------------------------------------------------*/
+
+/*
+ * transfer data to/from file using the read/write file_operations.
+ */
+static int fs_io(int rw, struct file *filp, loff_t *pos,
+		     struct bio_vec *bv)
+{
+	ssize_t r;
+	void *ptr = kmap(bv->bv_page) + bv->bv_offset;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(get_ds());
+	r = (rw == READ) ? filp->f_op->read(filp, ptr, bv->bv_len, pos) :
+			   filp->f_op->write(filp, ptr, bv->bv_len, pos);
+	set_fs(old_fs);
+	kunmap(bv->bv_page);
+	return (r == bv->bv_len) ? 0 : -EIO;
+}
+
+/*
+ * Handle I/O for one bio
+ */
+static void do_one_bio(struct file_map_c *fc, struct bio *bio)
+{
+	int r = 0, rw = bio_data_dir(bio);
+	loff_t start = (bio->bi_sector << 9) + fc->loop->offset,
+		pos = start;
+	struct bio_vec *bv, *bv_end = bio->bi_io_vec + bio->bi_vcnt;
+
+	for (bv = bio->bi_io_vec; bv < bv_end; bv++) {
+		r = fs_io(rw, fc->loop->filp, &pos, bv);
+		if (r) {
+			DMERR("%s error %d", rw ? "write":"read" , r);
+			break;
+		}
+	}
+	bio_endio(bio, pos - start, r);
+}
+
+/*
+ * Worker thread for a 'file' type loop device
+ */
+static void do_loop_work(struct work_struct *ws)
+{
+	struct file_map_c *fc = container_of(ws, struct file_map_c, ws);
+	struct bio *bio;
+
+	/* quickly grab all new bios queued and add them to the work list */
+	spin_lock_irq(&fc->lock);
+	bio_list_merge_init(&fc->work, &fc->in);
+	spin_unlock_irq(&fc->lock); +
+	/* work the list and do file I/O on all bios */
+	while ((bio = bio_list_pop(&fc->work)))
+		do_one_bio(fc, bio);
+}
+
+/*
+ * Create work queue and initialize work
+ */
+static int loop_work_init(struct loop_c *lc)
+{
+	struct file_map_c *fc = lc->map_data;
+	fc->wq = create_singlethread_workqueue(DAEMON);
+	if (!fc->wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * Destroy work queue
+ */
+static void loop_work_exit(struct loop_c *lc)
+{
+	struct file_map_c *fc = lc->map_data;
+	if (fc->wq)
+		destroy_workqueue(fc->wq);
+}
+
+/*
+ * LOOP_FSIO map_fn. Mapping just queues bios to the file map
+ * context and lets the daemon deal with them.
+ */
+static int loop_file_map(struct dm_target *ti, struct bio *bio)
+{
+	int wake;
+	struct loop_c *lc = ti->private;
+	struct file_map_c *fc = lc->map_data;
+
+	spin_lock_irq(&fc->lock);
+	wake = bio_list_empty(&fc->in);
+	bio_list_add(&fc->in, bio);
+	spin_unlock_irq(&fc->lock);
+
+	/*
+	 * only call queue_work() if necessary to avoid
+	 * superfluous preempt_{disable/enable}() overhead.
+	 */
+	if (wake)
+		queue_work(fc->wq, &fc->ws);
+
+	/* handling bio -> will submit later */
+	return 0;
+}
+
+/*
+ * Shutdown the workqueue and free a file mapping
+ */
+static void destroy_file_map(struct loop_c *lc)
+{
+	loop_work_exit(lc);
+	kfree(lc->map_data);
+}
+
+/*
+ * Set up a file map context and workqueue
+ */
+static int setup_file_map(struct loop_c *lc)
+{
+	struct file_map_c *fc = kzalloc(sizeof(*fc), GFP_KERNEL);
+	if (!fc)
+		return -ENOMEM;
+
+	lc->map_data = fc;
+	spin_lock_init(&fc->lock);
+	bio_list_init(&fc->in);
+	bio_list_init(&fc->work);
+	INIT_WORK(&fc->ws, do_loop_work);
+	fc->loop = lc;
+	lc->map_fn = loop_file_map;
+
+	return loop_work_init(lc);
+}
+
+/*--------------------------------------------------------------------
+ * Block I/O helpers
+ *--------------------------------------------------------------------*/
+
+static int contains_sector(struct extent *e, sector_t s)
+{
+	if (likely(e))
+		return s < (e->start + (e->len)) &&
+			s >= e->start;
+	return 0;
+}
+
+/*
+ * Walk over a linked list of extent_list structures, freeing them as
+ * we go. Does not free el->extent.
+ */
+static void destroy_extent_list(struct list_head *head)
+{
+	struct list_head *curr, *n;
+
+	if (list_empty(head))
+		return;
+
+	list_for_each_safe(curr, n, head) {
+		struct extent_list *el;
+		el = list_entry(curr, struct extent_list, list);
+		list_del(curr);
+		kfree(el);
+	}
+}
+
+/*
+ * Add a new extent to the tail of the list at *head with
+ * start/to/len parameters. Allocates from the extent cache.
+ */
+static int list_add_extent(struct list_head *head,
+		sector_t start, sector_t to, sector_t len)
+{
+	struct extent *extent;
+	struct extent_list *list;
+
+	extent = kmem_cache_alloc(extent_cache, GFP_KERNEL);
+	if(!extent)
+		goto out;
+
+	list = kmalloc(sizeof(*list), GFP_KERNEL);
+	if(!list)
+		goto out;
+
+	extent->start = start;
+	extent->to = to;
+	extent->len = len;
+
+	list->extent = extent;
+	list_add_tail(&list->list, head);
+
+	return 0;
+out:
+	if (extent)
+		kmem_cache_free(extent_cache, extent);
+	return -ENOMEM;
+}
+
+/*
+ * Return an extent range (i.e. beginning and ending physical block numbers).
+ */
+static int extent_range(struct inode * inode,
+			blkcnt_t logical_blk, blkcnt_t last_blk,
+			blkcnt_t *begin_blk, blkcnt_t *end_blk)
+{
+	sector_t dist = 0, phys_blk, probe_blk = logical_blk;
+
+	/* Find beginning physical block of extent starting at logical_blk. */
+	*begin_blk = phys_blk = bmap(inode, probe_blk);
+	if (!phys_blk)
+		return -ENXIO;
+
+	for (; phys_blk == *begin_blk + dist; dist++) {
+		*end_blk = phys_blk;
+		if (++probe_blk > last_blk)
+			break;
+
+		phys_blk = bmap(inode, probe_blk);
+		if (unlikely(!phys_blk))
+			return -ENXIO;
+	}
+
+	return 0;
+}
+
+/*
+ * Create a sequential list of extents from an inode and return
+ * it in *head. On success return the number of extents found or
+ * -ERRNO on failure.
+ */
+static int loop_extents(struct loop_c *lc, struct inode *inode,
+			struct list_head *head)
+{
+	sector_t start = 0;
+	int r, nr_extents = 0;
+	blkcnt_t nr_blks = 0, begin_blk = 0, end_blk = 0;
+	blkcnt_t last_blk = sec2blk(lc,
+			(lc->mapped_sectors + (lc->offset >> 9))) - 1;
+	blkcnt_t logical_blk = sec2blk(lc, (lc->offset >> 9));
+
+	/* for each block in the mapped region */
+	while (logical_blk <= last_blk) {
+		r = extent_range(inode, logical_blk, last_blk,
+				&begin_blk, &end_blk);
+
+		/* sparse file fallback */
+		if (unlikely(r)) {
+			DMWARN("%s has a hole; sparse file detected - "
+				"switching to filesystem I/O", lc->path);
+			clear_bit(LOOP_BMAP, &lc->flags);
+			set_bit(LOOP_FSIO, &lc->flags);
+			return r;
+		}
+
+		nr_blks = 1 + end_blk - begin_blk;
+
+		if (likely(nr_blks)) {
+			r = list_add_extent(head, start,
+				blk2sec(lc, begin_blk),
+				blk2sec(lc, nr_blks));
+
+			if (unlikely(r))
+				return r;
+
+			/* advance to next extent */
+			nr_extents++;
+			start += blk2sec(lc, nr_blks);
+			logical_blk += nr_blks;
+		}
+	}
+
+	return nr_extents;
+}
+
+/*
+ * Walk over the extents in a block_map_c, returning them to the cache and
+ * freeing bc->map and bc.
+ */
+static void destroy_block_map(struct block_map_c *bc)
+{
+	unsigned i;
+
+	if (!bc)
+		return;
+
+	for (i = 0; i < bc->nr_extents; i++)
+		kmem_cache_free(extent_cache, bc->map[i]);
+	DMDEBUG("destroying block map of %d entries", i);
+	vfree(bc->map);
+	kfree(bc);
+}
+
+/*
+ * Find an extent in *bc using binary search. Returns a pointer into the
+ * extent map. Calculate index as (extent - bc->map).
+ */
+static struct extent **extent_binary_lookup(struct block_map_c *bc,
+					   struct extent **extent_mru,
+					   sector_t sector)
+{
+	unsigned nr_extents = bc->nr_extents;
+	unsigned delta, dist, prev_dist = 0;
+	struct extent **eptr;
+
+	/* Optimize lookup range based on MRU extent. */
+	dist = extent_mru - bc->map;
+	if ((*extent_mru)->start < sector) {
+		delta = (nr_extents - dist) / 2;
+		dist += delta;
+	} else
+		delta = dist = dist / 2;
+
+	eptr = bc->map + dist;
+	while(*eptr && !contains_sector(*eptr, sector)) {
+		if (sector >= (*eptr)->start + (*eptr)->len) {
+			prev_dist = dist;
+			if (delta > 1)
+				delta /= 2;
+			dist += delta;
+		} else {
+			delta = (dist - prev_dist) / 2;
+			if (!delta)
+				delta = 1;
+			dist -= delta;
+		}
+		eptr = bc->map + dist;
+	}
+
+	return eptr;
+}
+
+/*
+ * Lookup an extent for a sector using the mru cache and binary search.
+ */
+static struct extent *extent_lookup(struct block_map_c *bc, sector_t sector)
+{
+	struct extent **eptr;
+
+	spin_lock_irq(&bc->mru_lock);
+	eptr = bc->mru;
+	spin_unlock_irq(&bc->mru_lock);
+
+	if (contains_sector(*eptr, sector))
+		return *eptr;
+
+	eptr = extent_binary_lookup(bc, eptr, sector);
+	if (!eptr)
+		return NULL;
+
+	spin_lock_irq(&bc->mru_lock);
+	bc->mru = eptr;
+	spin_unlock_irq(&bc->mru_lock);
+
+	return *eptr;
+}
+
+/*
+ * LOOP_BMAP map_fn. Looks up the sector in the extent map and
+ * rewrites the bio device and bi_sector fields.
+ */
+static int loop_block_map(struct dm_target *ti, struct bio *bio)
+{
+	struct loop_c *lc = ti->private;
+	struct extent *extent = extent_lookup(lc->map_data, bio->bi_sector);
+
+	if (likely(extent)) {
+		bio->bi_bdev = lc->bdev;
+		bio->bi_sector = extent->to +
+				 (bio->bi_sector - extent->start);
+		return 1;       /* Done with bio -> submit */
+	}
+
+	DMERR("no matching extent in map for sector %llu",
+	      (unsigned long long) bio->bi_sector + ti->begin);
+	BUG();
+
+	return -EIO;
+}
+
+/*
+ * Turn an extent_list into a linear pointer map of nr_extents + 1 entries
+ * and set the final entry to NULL.
+ */
+static struct extent **build_extent_map(struct list_head *head,
+				int nr_extents, unsigned long *flags)
+{
+	unsigned map_size, cache_size;
+	struct extent **map, **curr;
+	struct list_head *pos;
+
+	map_size = 1 +(sizeof(*map) * nr_extents);
+	cache_size = kmem_cache_size(extent_cache) * nr_extents;
+
+	map = vmalloc(map_size);
+	curr = map;
+
+	DMDEBUG("allocated extent map of %u %s for %d extents (%u %s)",
+		(map_size < 8192 ) ? map_size : map_size >> 10,
+		(map_size < 8192 ) ? "bytes" : "kilobytes", nr_extents,
+		(cache_size < 8192) ? cache_size : cache_size >> 10,
+		(cache_size < 8192) ? "bytes" : "kilobytes");
+
+	list_for_each(pos, head) {
+		struct extent_list *el;
+		el = list_entry(pos, struct extent_list, list);
+		*(curr++) = el->extent;
+	}
+	*curr = NULL;
+
+	return map;
+}
+
+/*
+ * Set up a block map context and extent map
+ */
+static int setup_block_map(struct loop_c *lc, struct inode *inode)
+{
+	int r, nr_extents;
+	struct block_map_c *bc;
+	LIST_HEAD(head);
+
+	if (!inode || !inode->i_sb || !inode->i_sb->s_bdev)
+		return -ENXIO;
+
+	/* build a linked list of extents in linear order */
+	r = nr_extents = loop_extents(lc, inode, &head);
+	if (nr_extents < 1)
+		goto out;
+
+	r = -ENOMEM;
+	bc = kzalloc(sizeof(*bc), GFP_KERNEL);
+	if(!bc)
+		goto out;
+
+	/* create a linear map of pointers into the extent cache */
+	bc->map = build_extent_map(&head, nr_extents, &lc->flags);
+	destroy_extent_list(&head);
+
+	if (IS_ERR(bc->map)) {
+		r = PTR_ERR(bc->map);
+		goto out;
+	}
+
+	spin_lock_init(&bc->mru_lock);
+	bc->mru = bc->map;
+	bc->nr_extents = nr_extents;
+	lc->bdev = inode->i_sb->s_bdev;
+	lc->map_data = bc;
+	lc->map_fn = loop_block_map;
+
+	return 0;
+
+out:
+	return r;
+}
+
+/*--------------------------------------------------------------------
+ * Generic helpers
+ *--------------------------------------------------------------------*/
+
+/*
+ * Invalidate all unlocked loop file pages
+ */
+static int loop_invalidate_file(struct file *filp)
+{
+	return invalidate_inode_pages(filp->f_mapping);
+}
+
+/*
+ * acquire or release a "no-truncate" lock on *filp.
+ * We overload the S_SWAPFILE flag for loop targets because
+ * it provides the same no-truncate semantics we require, and
+ * holding onto i_sem is no longer an option.
+ */
+static void file_truncate_lock(struct file *filp)
+{
+	struct inode *inode = filp->f_mapping->host;
+
+	mutex_lock(&inode->i_mutex);
+	inode->i_flags |= S_SWAPFILE;
+	mutex_unlock(&inode->i_mutex);
+}
+
+static void file_truncate_unlock(struct file *filp)
+{
+	struct inode *inode = filp->f_mapping->host;
+
+	mutex_lock(&inode->i_mutex);
+	inode->i_flags &= ~S_SWAPFILE;
+	mutex_unlock(&inode->i_mutex);
+}
+
+/*
+ * Fill out split_io for taget backing store
+ */
+static void set_split_io(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+
+	if(test_bit(LOOP_BMAP, &lc->flags))
+		/* Split I/O at block boundaries */
+		ti->split_io = 1 << (lc->blkbits - SECTOR_SHIFT);
+	else
+		ti->split_io = 64;
+
+	DMDEBUG("splitting io at %llu sector boundaries",
+			(unsigned long long) ti->split_io);
+}
+
+/*
+ * Check that the loop file is regular and available.
+ */
+static int loop_check_file(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+	struct file *filp = lc->filp;
+	struct inode *inode = filp->f_mapping->host;
+
+	if (!inode)
+		return -ENXIO;
+
+	ti->error = "backing file must be a regular file";
+	if (!S_ISREG(inode->i_mode))
+		return -EINVAL;
+
+	ti->error = "backing file is mapped into userspace for writing";
+	if (mapping_writably_mapped(filp->f_mapping))
+		return -EBUSY;
+
+	if (mapping_mapped(filp->f_mapping))
+		DMWARN("%s is mapped into userspace", lc->path);
+
+	if (!inode->i_sb || !inode->i_sb->s_bdev) {
+		DMWARN("%s has no blockdevice - switching to filesystem I/O", lc->path);
+		clear_bit(LOOP_BMAP, &lc->flags);
+		set_bit(LOOP_FSIO, &lc->flags);
+	}
+
+	ti->error = "backing file already in use";
+	if (IS_SWAPFILE(inode))
+		return -EBUSY;
+
+	return 0;
+}
+
+/*
+ * Check loop file size and store it in the loop context
+ */
+static int loop_setup_size(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+	struct inode *inode = lc->filp->f_mapping->host;
+	int r = -EINVAL;
+
+	lc->size = i_size_read(inode);
+	lc->blkbits = inode->i_blkbits;
+
+	ti->error = "backing file is empty";
+	if (!lc->size)
+		goto out;
+
+	DMDEBUG("set backing file size to %llu",
+		(unsigned long long) lc->size);
+
+	ti->error = "backing file cannot be less than one block in size";
+	if (lc->size < (blk2sec(lc,1) << 9))
+		goto out;
+
+	ti->error = "loop file offset must be a multiple of fs blocksize";
+	if (lc->offset & ((1 << lc->blkbits) - 1))
+		goto out;
+
+	ti->error = "loop file offset too large";
+	if (lc->offset > (lc->size - (1 << 9)))
+		goto out;
+
+	lc->mapped_sectors = (lc->size - lc->offset) >> 9;
+	DMDEBUG("set mapped sectors to %llu (%llu bytes)",
+		(unsigned long long) lc->mapped_sectors,
+		(lc->size - lc->offset));
+
+	if ((lc->offset + (lc->mapped_sectors << 9)) < lc->size)
+		DMWARN("not using %llu bytes in incomplete block at EOF",
+		       lc->size - (lc->offset + (lc->mapped_sectors << 9)));
+
+	ti->error = "mapped region cannot be smaller than target size";
+	if (lc->size - lc->offset < (ti->len << 9))
+		goto out;
+
+	return 0;
+out:
+	return r;
+}
+
+/*
+ * release a loop file
+ */
+static void loop_put_file(struct file *filp)
+{
+	if (!filp)
+		return;
+	file_truncate_unlock(filp);
+	filp_close(filp, NULL);
+}
+
+/*
+ * open loop file and perform type, availability and size checks.
+ */
+static int loop_get_file(struct dm_target *ti)
+{
+	int flags = ((dm_table_get_mode(ti->table) & FMODE_WRITE) ?
+		    O_RDWR : O_RDONLY) | O_LARGEFILE;
+	struct loop_c *lc = ti->private;
+	struct file *filp;
+	int r = 0;
+
+	ti->error = "could not open backing file";
+	filp = filp_open(lc->path, flags, 0);
+	if (IS_ERR(filp))
+		return PTR_ERR(filp);
+	lc->filp = filp;
+	r = loop_check_file(ti);
+	if (r)
+		goto out_put;
+
+	r = loop_setup_size(ti);
+	if (r)
+		goto out_put;
+
+	file_truncate_lock(filp);
+	return 0;
+
+out_put:
+	fput(filp);
+	return r;
+}
+
+/*
+ * invalidate mapped pages belonging to the loop file
+ */
+void loop_flush(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+	loop_invalidate_file(lc->filp);
+}
+
+/*--------------------------------------------------------------------
+ * Device-mapper target methods
+ *--------------------------------------------------------------------*/
+
+/*
+ * Generic loop map function. Re-base I/O to target begin and submit
+ */
+static int loop_map(struct dm_target *ti, struct bio *bio,
+					union map_info *context)
+{
+	struct loop_c *lc = ti->private;
+
+	if (unlikely(bio_barrier(bio)))
+		return -EOPNOTSUPP;
+	bio->bi_sector -= ti->begin;
+	if (lc->map_fn)
+		return lc->map_fn(ti, bio);
+	return -EIO;
+}
+
+/*
+ * Block status helper
+ */
+static ssize_t loop_file_status(struct loop_c *lc, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	struct file_map_c *fc = lc->map_data;
+	int qlen;
+
+	spin_lock_irq(&fc->lock);
+	qlen = bio_list_nr(&fc->work);
+	qlen += bio_list_nr(&fc->in);
+	spin_unlock_irq(&fc->lock);
+	DMEMIT("file %d", qlen);
+
+	return sz;
+}
+
+/*
+ * File status helper
+ */
+static ssize_t loop_block_status(struct loop_c *lc, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	struct block_map_c *bc = lc->map_data;
+	int mru;
+
+	spin_lock_irq(&bc->mru_lock);
+	mru = bc->mru - bc->map;
+	spin_unlock_irq(&bc->mru_lock);
+	DMEMIT("block %d %d", bc->nr_extents, mru);
+
+	return sz;
+}
+
+/*
+ * This needs some thought on handling unlinked backing files. some parts of
+ * the kernel return a cached name (now invalid), while others return a dcache
+ * "/path/to/foo (deleted)" name (never was/is valid). Which is "better" is
+ * debatable.
+ *
+ * On the one hand, using a cached name gives table output which is directly
+ * usable assuming the user re-creates the unlinked image file, on the other
+ * it is more consistent with e.g. swap to use the dcache name.
+ *
+*/
+static int loop_status(struct dm_target *ti, status_type_t type,
+				char *result, unsigned maxlen)
+{
+	struct loop_c *lc = (struct loop_c *) ti->private;
+	ssize_t sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		if (test_bit(LOOP_BMAP, &lc->flags))
+			sz += loop_block_status(lc, result, maxlen - sz);
+		else if (test_bit(LOOP_FSIO, &lc->flags))
+			sz += loop_file_status(lc, result, maxlen - sz);
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %llu", lc->path, lc->offset);
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Destroy a loopback mapping
+ */
+static void loop_dtr(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+
+	if ((dm_table_get_mode(ti->table) & FMODE_WRITE))
+		loop_invalidate_file(lc->filp);
+
+	if (test_bit(LOOP_BMAP, &lc->flags) && lc->map_data)
+		destroy_block_map((struct block_map_c *)lc->map_data);
+	if (test_bit(LOOP_FSIO, &lc->flags) && lc->map_data)
+		destroy_file_map(lc);
+
+	loop_put_file(lc->filp);
+	DMINFO("released file %s", lc->path);
+
+	kfree(lc);
+}
+
+/*
+ * Construct a loopback mapping: <path> <offset>
+ */
+static int loop_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct loop_c *lc = NULL;
+	int r = -EINVAL;
+
+	ti->error = "invalid argument count";
+	if (argc != 2)
+		goto out;
+
+	r = -ENOMEM;
+	ti->error = "cannot allocate loop context";
+	lc = kzalloc(sizeof(*lc), GFP_KERNEL);
+	if (!lc)
+		goto out;
+
+	/* default */
+	set_bit(LOOP_BMAP, &lc->flags);
+	ti->error = "cannot allocate loop path";
+	lc->path = kstrdup(argv[0], GFP_KERNEL);
+	if (!lc->path)
+		goto out;
+
+	ti->private = lc;
+
+	r = -EINVAL;
+	ti->error = "invalid file offset";
+	if (sscanf(argv[1], "%lld", &lc->offset) != 1)
+		goto out;
+
+	if (lc->offset)
+		DMDEBUG("setting file offset to %lld", lc->offset);
+
+	/* open & check file and set size parameters */
+	r = loop_get_file(ti);
+
+	/* ti->error has been set by loop_get_file */
+	if (r)
+		goto out;
+
+	ti->error = "could not create loop mapping";
+	if (test_bit(LOOP_BMAP, &lc->flags))
+		r = setup_block_map(lc, lc->filp->f_mapping->host);
+	if (test_bit(LOOP_FSIO, &lc->flags))
+		r = setup_file_map(lc);
+
+	if (r)
+		goto out_putf;
+
+	set_split_io(ti);
+	if (lc->bdev)
+		dm_set_device_limits(ti, lc->bdev);
+
+	DMDEBUG("constructed loop target on %s "
+		"(%lldk, %llu sectors)", lc->path,
+		(lc->size >> 10), lc->mapped_sectors);
+	ti->error = NULL;
+
+	return 0;
+
+out_putf:
+	loop_put_file(lc->filp);
+out:
+	if(lc)
+		kfree(lc);
+	return r;
+}
+
+static struct target_type loop_target = {
+	.name = "loop",
+	.version = {0, 0, 2},
+	.module = THIS_MODULE,
+	.ctr = loop_ctr,
+	.dtr = loop_dtr,
+	.map = loop_map,
+	.presuspend = loop_flush,
+	.flush = loop_flush,
+	.status = loop_status,
+};
+
+/*--------------------------------------------------------------------
+ * Module bits
+ *--------------------------------------------------------------------*/
+int __init dm_loop_init(void)
+{
+	int r;
+
+	r = dm_register_target(&loop_target);
+	if (r < 0) {
+		DMERR("register failed %d", r);
+		goto out;
+	}
+
+	r = -ENOMEM;
+	extent_cache = kmem_cache_create("extent_cache", sizeof(struct extent),
+					0, SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!extent_cache)
+		goto out;
+
+	DMINFO("registered %s", version);
+	return 0;
+
+out:
+	if (extent_cache)
+		kmem_cache_destroy(extent_cache);
+	return r;
+}
+
+void dm_loop_exit(void)
+{
+	int r;
+
+	r = dm_unregister_target(&loop_target);
+	kmem_cache_destroy(extent_cache);
+
+	if (r < 0)
+		DMERR("target unregister failed %d", r);
+	else
+		DMINFO("unregistered %s", version);
+}
+
+module_init(dm_loop_init);
+module_exit(dm_loop_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Bryn Reeves <breeves@redhat.com>");
+MODULE_DESCRIPTION("device-mapper loop target");



  

