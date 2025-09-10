Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E63320A29
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 15:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757517933; cv=pass; b=cqDTKhTarYlJwWZbAqwnIWh+nqvPhCSQRDHCzfadXKeS/NQsdBFot+7NRq36V8qrkfsit1e2tgEhLW+yVj2YUneWZZ36TwWUyOKl0Z/frL3am3TsNQ0VZvWdxR5YrtZpRUlDXvje9kCMPP69rv+L3gO/cdHPDIC6KwwnKUIdE/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757517933; c=relaxed/simple;
	bh=Dmh4L+V3caLUkqbCqRC4G8kv17dbhzMfzWTRKlcreq4=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=YqYyaaVVjLgivp1vL+caEZBpguqyh/woCPLDWK4DwN0S8VvPp54caNNw8moOPxr7/yjeTwGpUdxeSsuATrrfWZa5mwi4sDCSEFzZAbTdAZDBNnCAPEIkrqhwJFISKSkEkef0k6rmBeTnGPYeb21kYZ4ljRFs+B7bO+WSlUMa0A4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=bob.beckett@collabora.com header.b=Qjkg+lJB; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=bob.beckett@collabora.com header.b="Qjkg+lJB"
ARC-Seal: i=1; a=rsa-sha256; t=1757517919; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=aQy7M191yh9xUqQqzfom0jyFHESW6HBNghDwNBH2BhW1KNtXx2hnX0ySUyR1B+IEgnCpHtOOoyT4jzni5P4g+ULjL+vUlb97MpguKWOu1xFZRLigYF/D3bdpuTk6yuZASxjkaYgpwgMEPEa7ltgfhVAVnMHnc+oAeLslXQ3Vu80=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1757517919; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FFaZGxq/xuEguFKMMvyQhRE+ukA0dPxIqATP6wR3Frc=; 
	b=fx4zbs4hn9ys5pTirVsBtQtjSk6y5f1ka7s6NuxzACJknIoQmcjL+ZG05Ss2eg9Ekx3mZkXUtmHHaugfv4gkfuarf2QnI0PONqrHgV7cXE0o9YxfbUm6tgZmI9hPs/yCaj0YWA9oouk+oCyz/Rg6qYZRyubwJn/zi1DfceqWIYM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=bob.beckett@collabora.com;
	dmarc=pass header.from=<bob.beckett@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1757517919;
	s=zohomail; d=collabora.com; i=bob.beckett@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FFaZGxq/xuEguFKMMvyQhRE+ukA0dPxIqATP6wR3Frc=;
	b=Qjkg+lJB3Xgdhgv3hdJT/pPCH9qhMqe29xVD6TJVFLfwtIaaiFaX+dCZ2xBKdMlT
	Ur0gLRFx+CDRHK7Rg3FrvlbpMhz2eNWKlA7F732avhdIMeukEJPnvuMmR7F85gS/DRp
	YrUJ2i+s8Ub/dfg0e3bDShw/ICb1Mmm8IB4q1qUA=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1757517886154501.01505751233447; Wed, 10 Sep 2025 08:24:46 -0700 (PDT)
Date: Wed, 10 Sep 2025 16:24:46 +0100
From: Robert Beckett <bob.beckett@collabora.com>
To: "Mikulas Patocka" <mpatocka@redhat.com>
Cc: "dm-devel" <dm-devel@lists.linux.dev>,
	"linux-block" <linux-block@vger.kernel.org>,
	"kernel" <kernel@collabora.com>
Message-ID: <199343ab2a7.11b1e13e161813.4990067961195858029@collabora.com>
In-Reply-To: <a7872ca2-be14-0720-190c-c03d4ddf7a5d@redhat.com>
References: <1992a9545eb.1ec14bf0659281.6434647558731823661@collabora.com> <2d517844-b7bf-3930-e811-e073ec347d4a@redhat.com> <1992f628105.2bf0303b1373545.4844645742991812595@collabora.com> <a7872ca2-be14-0720-190c-c03d4ddf7a5d@redhat.com>
Subject: Re: deadlock when swapping to encrypted swapfile
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail






 ---- On Wed, 10 Sep 2025 12:26:06 +0100  Mikulas Patocka <mpatocka@redhat.com> wrote --- 
 > 
 > 
 > On Tue, 9 Sep 2025, Robert Beckett wrote:
 > 
 > > 
 > >  ---- On Tue, 09 Sep 2025 15:37:09 +0100  Mikulas Patocka <mpatocka@redhat.com> wrote --- 
 > >  > 
 > >  > 
 > >  > On Mon, 8 Sep 2025, Robert Beckett wrote:
 > >  > 
 > >  > > Hi,
 > >  > > 
 > >  > > While testing resiliency of encrypted swap using dmcrypt we encounter easily reproducible deadlocks.
 > >  > > The setup is a simple 1GB encrypted swap file [1] with a little mem chewer program [2] to consume all ram.
 > >  > > 
 > >  > > [1] Swap file setup
 > >  > > ```
 > >  > > $ swapoff /home/swapfile
 > >  > > $ echo 'swap /home/swapfile /dev/urandom swap,cipher=aes-cbc-essiv:sha256,size=256' >> /etc/crypttab
 > >  > > $ systemctl daemon-reload
 > >  > > $ systemctl start systemd-cryptsetup@swap.service
 > >  > > $ swapon /dev/mapper/swap
 > >  > > ```
 > >  > 
 > >  > I have tried to swap on encrypted block device and it worked for me.
 > >  > 
 > >  > I've just realized that you are swapping to a file with the loopback 
 > >  > driver on the top of it and with the dm-crypt device on the top of the 
 > >  > loopback device.
 > >  > 
 > >  > This can't work in principle - the problem is that the filesystem needs to 
 > >  > allocate memory when you write to it, so it deadlocks when the machine 
 > >  > runs out of memory and needs to write back some pages. There is no easy 
 > >  > fix - fixing this would require major rewrite of the VFS layer.
 > >  > 
 > >  > When you swap to a file directly, the kernel bypasses the filesystem, so 
 > >  > it should work - but when you put encryption on the top of a file, there 
 > >  > is no way how to bypass the filesystem.
 > >  > 
 > >  > So, I suggest to create a partition or a logical volume for swap and put 
 > >  > dm-crypt on the top of it.
 > >  > 
 > >  > Mikulas
 > >  > 
 > >  > 
 > > 
 > > Yeah, unfortunately we are currently restricted to using a swapfile due to many units already shipped with that.
 > > We have longer term plans to dynamically allocate the swapfiles as neded based on a new query for estimated size
 > > required for hibernation etc. Moving to swap partition is just not viable currently.
 > 
 > You can try the dm-loop target that I created some times ago. It won't be 
 > in the official kernel because the Linux developers don't like the idea of 
 > creating fixed mapping for a file, but it may work better for you. Unlike 
 > the in-kernel loop driver, the dm-loop driver doesn't allocate memory when 
 > processing reads and write.

oh interesting. I hadn't seen that.
I was discussing a quick idea of potentially adding a new fallocate mode bit to request contiguous non-moveable
block assignment as it pre-allocates, which filesystems could then implement support for. Then use the known
file range with dm-crypt directly instead of going via the block device.
I guess this is roughly analaguous to that idea.

I see that dm-loop is very old at this point. Do you know the rationale for rejection?
was there any hope to get it included with more work?
If the main objection was regarding file spans that they can't gurantee persist, maybe a new fallocate based
contrace with the filesystems could aleviate the worries? 


 > 
 > Create a swap file on the filesystem, load the dm-loop target on the top 
 > of that file and then create dm-crypt on the top of the dm-loop target. 
 > Then, run mkswap and swapon on the dm-crypt device.
 > 
 > > I tried halving /sys/module/dm_mod/parameters/swap_bios but it didn't help, which based on your more recent
 > > reply is not unexpected.
 > > 
 > > I have a work around for now, which is to run a userland earlyoom daemon. That seems to get in and oomkill in time.
 > > I guess another option would be to have the swapfile in a luks encrypted partition, but that equally is not viable for
 > > steamdeck currently.
 > > 
 > > However, I'm still interested in the longer term solution of fixing the kernel so that it can handle scenarios
 > > like this no matter how ill advised they may be. Telling users not to do something seems like a bad solution :)
 > 
 > You would have to rewrite the filesystems not to allocate memory when 
 > processing reads and writes. I think that this is not feasible.
 > 
 > > Do you have any ideas about the unreliable kernel oomkiller stepping in? I definitely fill ram and swap, seems like
 > > it should be firing.
 > 
 > I think that the main problem with the OOM killer is that it sometimes 
 > doesn't fire for big applications.

perhaps oom_kill_allocating_task helps in that scenario?
in this lockup scenario I don't see oomkiller starting at all. It looks like it soft
locks and never feels the need to step in.
Perhaps because it sees some (tiny) amount of forward progress with
some swapout requests completing?

 > 
 > If you create a simple program that does malloc in a loop, the OOM killer 
 > will kill it reliably. However, if some big program (such as web browser, 
 > text editor, ...) allocates too much memory, the OOM killer may not kill 
 > it.
 > 

this doesn't appear to be the case. The memchewer program that llocates 512MB
chunks in a loop never triggers oomkiller


 > The problem is that when the kernel runs out of memory, it tries to flush 
 > filesystem caches first. However the program code is also executed from 
 > filesystem cache. So, it flushes the pages with the program code, which 
 > makes the big program run slower. The program that is running out of 
 > memory allocates more pages, so more code will be flushed and the program 
 > will run even slower - and so on, in a loop. So, the system slows down 
 > gradually to a halt without really going out of memory and killing the big 
 > program.
 > 
 > I think that using userspace OOM killer is appropriate to prevent this 
 > problem with the kernel OOM killer. 

Turns out I spoke too soon on the userland earloom daemon being a solution.
It worked for some patterns, but not others.
It mostly worked well when swap was either pre-filled with data greater than it's
threshold so as soon as ram is exhausted it stepped in, or when the allocations are
sufficiently spaced for it to fill greater than it's threshold without many more
outstanding swapouts before it gets to evaluate again.

For now the only really reliable way to work around is to disable memory
overcommit, but we really don't want to go looking down that route as it 
will have all sorts of other impacts.

 > 
 > Mikulas
 > 
 > > Thanks
 > > 
 > > Bob
 > 
 > ---
 >  drivers/md/Kconfig   |    9 +
 >  drivers/md/Makefile  |    1 
 >  drivers/md/dm-loop.c |  404 +++++++++++++++++++++++++++++++++++++++++++++++++++
 >  3 files changed, 414 insertions(+)
 > 
 > Index: linux-2.6/drivers/md/Kconfig
 > ===================================================================
 > --- linux-2.6.orig/drivers/md/Kconfig    2025-09-10 13:06:15.000000000 +0200
 > +++ linux-2.6/drivers/md/Kconfig    2025-09-10 13:06:15.000000000 +0200
 > @@ -647,6 +647,15 @@ config DM_ZONED
 >  
 >        If unsure, say N.
 >  
 > +config DM_LOOP
 > +    tristate "Loop target"
 > +    depends on BLK_DEV_DM
 > +    help
 > +      This device-mapper target allows you to treat a regular file as
 > +      a block device.
 > +
 > +      If unsure, say N.
 > +
 >  config DM_AUDIT
 >      bool "DM audit events"
 >      depends on BLK_DEV_DM
 > Index: linux-2.6/drivers/md/Makefile
 > ===================================================================
 > --- linux-2.6.orig/drivers/md/Makefile    2025-09-10 13:06:15.000000000 +0200
 > +++ linux-2.6/drivers/md/Makefile    2025-09-10 13:06:15.000000000 +0200
 > @@ -79,6 +79,7 @@ obj-$(CONFIG_DM_CLONE)        += dm-clone.o
 >  obj-$(CONFIG_DM_LOG_WRITES)    += dm-log-writes.o
 >  obj-$(CONFIG_DM_INTEGRITY)    += dm-integrity.o
 >  obj-$(CONFIG_DM_ZONED)        += dm-zoned.o
 > +obj-$(CONFIG_DM_LOOP)        += dm-loop.o
 >  obj-$(CONFIG_DM_WRITECACHE)    += dm-writecache.o
 >  obj-$(CONFIG_SECURITY_LOADPIN_VERITY)    += dm-verity-loadpin.o
 >  
 > Index: linux-2.6/drivers/md/dm-loop.c
 > ===================================================================
 > --- /dev/null    1970-01-01 00:00:00.000000000 +0000
 > +++ linux-2.6/drivers/md/dm-loop.c    2025-09-10 13:06:15.000000000 +0200
 > @@ -0,0 +1,404 @@
 > +#include <linux/device-mapper.h>
 > +
 > +#include <linux/module.h>
 > +#include <linux/pagemap.h>
 > +
 > +#define DM_MSG_PREFIX "loop"
 > +
 > +struct loop_c {
 > +    struct file *filp;
 > +    char *path;
 > +    loff_t offset;
 > +    struct block_device *bdev;
 > +    struct inode *inode;
 > +    unsigned blkbits;
 > +    bool read_only;
 > +    sector_t mapped_sectors;
 > +
 > +    sector_t nr_extents;
 > +    struct dm_loop_extent *map;
 > +};
 > +
 > +struct dm_loop_extent {
 > +    sector_t start;         /* start sector in mapped device */
 > +    sector_t to;            /* start sector on target device */
 > +    sector_t len;            /* length in sectors */
 > +};
 > +
 > +static sector_t blk2sect(struct loop_c *lc, blkcnt_t block)
 > +{
 > +    return block << (lc->blkbits - SECTOR_SHIFT);
 > +}
 > +
 > +static blkcnt_t sec2blk(struct loop_c *lc, sector_t sector)
 > +{
 > +    return sector >> (lc->blkbits - SECTOR_SHIFT);
 > +}
 > +
 > +static blkcnt_t sec2blk_roundup(struct loop_c *lc, sector_t sector)
 > +{
 > +    return (sector + (1 << (lc->blkbits - SECTOR_SHIFT)) - 1) >> (lc->blkbits - SECTOR_SHIFT);
 > +}
 > +
 > +static struct dm_loop_extent *extent_binary_lookup(struct loop_c *lc, sector_t sector)
 > +{
 > +    ssize_t first = 0;
 > +    ssize_t last = lc->nr_extents - 1;
 > +
 > +    while (first <= last) {
 > +        ssize_t middle = (first + last) >> 1;
 > +        struct dm_loop_extent *ex = &lc->map[middle];
 > +        if (sector < ex->start) {
 > +            last = middle - 1;
 > +            continue;
 > +        }
 > +        if (likely(sector >= ex->start + ex->len)) {
 > +            first = middle + 1;
 > +            continue;
 > +        }
 > +        return ex;
 > +    }
 > +
 > +    return NULL;
 > +}
 > +
 > +static int loop_map(struct dm_target *ti, struct bio *bio)
 > +{
 > +    struct loop_c *lc = ti->private;
 > +    sector_t sector, len;
 > +    struct dm_loop_extent *ex;
 > +
 > +    sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
 > +    ex = extent_binary_lookup(lc, sector);
 > +    if (!ex)
 > +        return DM_MAPIO_KILL;
 > +
 > +    bio_set_dev(bio, lc->bdev);
 > +    bio->bi_iter.bi_sector = ex->to + (sector - ex->start);
 > +    len = ex->len - (sector - ex->start);
 > +    if (len < bio_sectors(bio))
 > +        dm_accept_partial_bio(bio, len);
 > +
 > +    if (unlikely(!ex->to)) {
 > +        if (unlikely(!lc->read_only))
 > +            return DM_MAPIO_KILL;
 > +        zero_fill_bio(bio);
 > +        bio_endio(bio);
 > +        return DM_MAPIO_SUBMITTED;
 > +    }
 > +
 > +    return DM_MAPIO_REMAPPED;
 > +}
 > +
 > +static void loop_status(struct dm_target *ti, status_type_t type,
 > +        unsigned status_flags, char *result, unsigned maxlen)
 > +{
 > +    struct loop_c *lc = ti->private;
 > +    size_t sz = 0;
 > +
 > +    switch (type) {
 > +        case STATUSTYPE_INFO:
 > +            result[0] = '\0';
 > +            break;
 > +        case STATUSTYPE_TABLE:
 > +            DMEMIT("%s %llu", lc->path, lc->offset);
 > +            break;
 > +        case STATUSTYPE_IMA:
 > +            DMEMIT_TARGET_NAME_VERSION(ti->type);
 > +            DMEMIT(",file_name=%s,offset=%llu;", lc->path, lc->offset);
 > +            break;
 > +    }
 > +}
 > +
 > +static int loop_iterate_devices(struct dm_target *ti,
 > +                iterate_devices_callout_fn fn, void *data)
 > +{
 > +    return 0;
 > +}
 > +
 > +static int extent_range(struct loop_c *lc,
 > +            sector_t logical_blk, sector_t last_blk,
 > +            sector_t *begin_blk, sector_t *nr_blks,
 > +            char **error)
 > +{
 > +    sector_t dist = 0, phys_blk, probe_blk = logical_blk;
 > +    int r;
 > +
 > +    /* Find beginning physical block of extent starting at logical_blk. */
 > +    *begin_blk = probe_blk;
 > +    *nr_blks = 0;
 > +    r = bmap(lc->inode, begin_blk);
 > +    if (r) {
 > +        *error = "bmap failed";
 > +        return r;
 > +    }
 > +    if (!*begin_blk) {
 > +        if (!lc->read_only) {
 > +            *error = "File is sparse";
 > +            return -ENXIO;
 > +        }
 > +    }
 > +
 > +    for (phys_blk = *begin_blk; phys_blk == *begin_blk + dist; dist += !!*begin_blk) {
 > +        cond_resched();
 > +
 > +        (*nr_blks)++;
 > +        if (++probe_blk > last_blk)
 > +            break;
 > +
 > +        phys_blk = probe_blk;
 > +        r = bmap(lc->inode, &phys_blk);
 > +        if (r) {
 > +            *error = "bmap failed";
 > +            return r;
 > +        }
 > +        if (unlikely(!phys_blk)) {
 > +            if (!lc->read_only) {
 > +                *error = "File is sparse";
 > +                return -ENXIO;
 > +            }
 > +        }
 > +    }
 > +
 > +    return 0;
 > +}
 > +
 > +static int loop_extents(struct loop_c *lc, sector_t *nr_extents,
 > +            struct dm_loop_extent *map, char **error)
 > +{
 > +    int r;
 > +    sector_t start = 0;
 > +    sector_t nr_blks, begin_blk;
 > +    sector_t after_last_blk = sec2blk_roundup(lc,
 > +            (lc->mapped_sectors + (lc->offset >> 9)));
 > +    sector_t logical_blk = sec2blk(lc, lc->offset >> 9);
 > +
 > +    *nr_extents = 0;
 > +
 > +    /* for each block in the mapped region */
 > +    while (logical_blk < after_last_blk) {
 > +        r = extent_range(lc, logical_blk, after_last_blk - 1,
 > +                 &begin_blk, &nr_blks, error);
 > +
 > +        if (unlikely(r))
 > +            return r;
 > +
 > +        if (map) {
 > +            if (*nr_extents >= lc->nr_extents) {
 > +                *error = "The file changed while mapping it";
 > +                return -EBUSY;
 > +            }
 > +            map[*nr_extents].start = start;
 > +            map[*nr_extents].to = blk2sect(lc, begin_blk);
 > +            map[*nr_extents].len = blk2sect(lc, nr_blks);
 > +        }
 > +
 > +        (*nr_extents)++;
 > +        start += blk2sect(lc, nr_blks);
 > +        logical_blk += nr_blks;
 > +    }
 > +
 > +    if (*nr_extents != lc->nr_extents) {
 > +        *error = "The file changed while mapping it";
 > +        return -EBUSY;
 > +    }
 > +
 > +    return 0;
 > +}
 > +
 > +static int setup_block_map(struct loop_c *lc, struct dm_target *ti)
 > +{
 > +    int r;
 > +    sector_t n_file_sectors, offset_sector, nr_extents_tmp;
 > +
 > +    if (!S_ISREG(lc->inode->i_mode) || !lc->inode->i_sb || !lc->inode->i_sb->s_bdev) {
 > +        ti->error = "The file is not a regular file";
 > +        return -ENXIO;
 > +    }
 > +
 > +    lc->bdev = lc->inode->i_sb->s_bdev;
 > +    lc->blkbits = lc->inode->i_blkbits;
 > +    n_file_sectors = i_size_read(lc->inode) >> lc->blkbits << (lc->blkbits - 9);
 > +
 > +    if (lc->offset & ((1 << lc->blkbits) - 1)) {
 > +        ti->error = "Unaligned offset";
 > +        return -EINVAL;
 > +    }
 > +    offset_sector = lc->offset >> 9;
 > +    if (offset_sector >= n_file_sectors) {
 > +        ti->error = "Offset is greater than file size";
 > +        return -EINVAL;
 > +    }
 > +    if (ti->len > (n_file_sectors - offset_sector)) {
 > +        ti->error = "Target maps area after file end";
 > +        return -EINVAL;
 > +    }
 > +    lc->mapped_sectors = ti->len >> (lc->blkbits - 9) << (lc->blkbits - 9);
 > +
 > +    r = loop_extents(lc, &lc->nr_extents, NULL, &ti->error);
 > +    if (r)
 > +        return r;
 > +
 > +    if (lc->nr_extents != (size_t)lc->nr_extents) {
 > +        ti->error = "Too many extents";
 > +        return -EOVERFLOW;
 > +    }
 > +
 > +    lc->map = kvcalloc(lc->nr_extents, sizeof(struct dm_loop_extent), GFP_KERNEL);
 > +    if (!lc->map) {
 > +        ti->error = "Failed to allocate extent map";
 > +        return -ENOMEM;
 > +    }
 > +
 > +    r = loop_extents(lc, &nr_extents_tmp, lc->map, &ti->error);
 > +    if (r)
 > +        return r;
 > +
 > +    return 0;
 > +}
 > +
 > +static int loop_lock_inode(struct inode *inode)
 > +{
 > +    int r;
 > +    inode_lock(inode);
 > +    if (IS_SWAPFILE(inode)) {
 > +        inode_unlock(inode);
 > +        return -EBUSY;
 > +    }
 > +    inode->i_flags |= S_SWAPFILE;
 > +    r = inode_drain_writes(inode);
 > +    if (r) {
 > +        inode->i_flags &= ~S_SWAPFILE;
 > +        inode_unlock(inode);
 > +        return r;
 > +    }
 > +    inode_unlock(inode);
 > +    return 0;
 > +}
 > +
 > +static void loop_unlock_inode(struct inode *inode)
 > +{
 > +    inode_lock(inode);
 > +    inode->i_flags &= ~S_SWAPFILE;
 > +    inode_unlock(inode);
 > +}
 > +
 > +static void loop_free(struct loop_c *lc)
 > +{
 > +    if (!lc)
 > +        return;
 > +    if (!IS_ERR_OR_NULL(lc->filp)) {
 > +        loop_unlock_inode(lc->inode);
 > +        filp_close(lc->filp, NULL);
 > +    }
 > +    kvfree(lc->map);
 > +    kfree(lc->path);
 > +    kfree(lc);
 > +}
 > +
 > +static int loop_ctr(struct dm_target *ti, unsigned argc, char **argv)
 > +{
 > +    struct loop_c *lc = NULL;
 > +    int r;
 > +    char dummy;
 > +
 > +    if (argc != 2) {
 > +        r = -EINVAL;
 > +        ti->error = "Invalid number of arguments";
 > +        goto err;
 > +    }
 > +
 > +    lc = kzalloc(sizeof(*lc), GFP_KERNEL);
 > +    if (!lc) {
 > +        r = -ENOMEM;
 > +        ti->error = "Cannot allocate loop context";
 > +        goto err;
 > +    }
 > +    ti->private = lc;
 > +
 > +    lc->path = kstrdup(argv[0], GFP_KERNEL);
 > +    if (!lc->path) {
 > +        r = -ENOMEM;
 > +        ti->error = "Cannot allocate loop path";
 > +        goto err;
 > +    }
 > +
 > +    if (sscanf(argv[1], "%lld%c", &lc->offset, &dummy) != 1) {
 > +        r = -EINVAL;
 > +        ti->error = "Invalid file offset";
 > +        goto err;
 > +    }
 > +
 > +    lc->read_only = !(dm_table_get_mode(ti->table) & FMODE_WRITE);
 > +
 > +    lc->filp = filp_open(lc->path, lc->read_only ? O_RDONLY : O_RDWR, 0);
 > +    if (IS_ERR(lc->filp)) {
 > +        r = PTR_ERR(lc->filp);
 > +        ti->error = "Could not open backing file";
 > +        goto err;
 > +    }
 > +
 > +    lc->inode = lc->filp->f_mapping->host;
 > +
 > +    r = loop_lock_inode(lc->inode);
 > +    if (r) {
 > +        ti->error = "Could not lock inode";
 > +        goto err;
 > +    }
 > +
 > +    r = setup_block_map(lc, ti);
 > +    if (r) {
 > +        goto err;
 > +    }
 > +
 > +    return 0;
 > +
 > +err:
 > +    loop_free(lc);
 > +    return r;
 > +}
 > +
 > +static void loop_dtr(struct dm_target *ti)
 > +{
 > +    struct loop_c *lc = ti->private;
 > +    loop_free(lc);
 > +}
 > +
 > +static struct target_type loop_target = {
 > +    .name = "loop",
 > +    .version = {1, 0, 0},
 > +    .module = THIS_MODULE,
 > +    .ctr = loop_ctr,
 > +    .dtr = loop_dtr,
 > +    .map = loop_map,
 > +    .status = loop_status,
 > +    .iterate_devices = loop_iterate_devices,
 > +};
 > +
 > +static int __init dm_loop_init(void)
 > +{
 > +    int r;
 > +
 > +    r = dm_register_target(&loop_target);
 > +    if (r < 0) {
 > +        DMERR("register failed %d", r);
 > +        goto err_target;
 > +    }
 > +
 > +    return 0;
 > +
 > +err_target:
 > +    return r;
 > +}
 > +
 > +static void __exit dm_loop_exit(void)
 > +{
 > +    dm_unregister_target(&loop_target);
 > +}
 > +
 > +module_init(dm_loop_init);
 > +module_exit(dm_loop_exit);
 > +
 > +MODULE_LICENSE("GPL");
 > +MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
 > +MODULE_DESCRIPTION("device-mapper loop target");
 > 
 > 

