From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm writecache: fix data corruption when reloading
	the target
Date: Wed, 15 Apr 2020 09:01:54 -0400
Message-ID: <20200415130153.GB29959@redhat.com>
References: <alpine.LRH.2.02.2004081459520.14853@file01.intranet.prod.int.rdu2.redhat.com>
	<20200414190515.GA25340@redhat.com>
	<alpine.LRH.2.02.2004150405330.3968@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2004150405330.3968@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, David Teigland <teigland@redhat.com>
List-Id: dm-devel.ids

On Wed, Apr 15 2020 at  4:14am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 14 Apr 2020, Mike Snitzer wrote:
> 
> > On Wed, Apr 08 2020 at  3:02pm -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > The dm-writecache reads metadata in the target constructor. However, when 
> > > we reload the target, there could be another active instance running on 
> > > the same device. This is the sequence of operations when doing a reload:
> > > 
> > > 1. construct new target
> > > 2. suspend old target
> > > 3. resume new target
> > > 4. destroy old target
> > > 
> > > Metadata that were written by the old target between steps 1 and 2 would
> > > not be visible by the new target.
> > > 
> > > This patch fixes the data corruption by loading the metadata in the resume
> > > handler.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Cc: stable@vger.kernel.org	# v4.18+
> > > Fixes: 48debafe4f2f ("dm: add writecache target")
> > > 
> > > ---
> > >  drivers/md/dm-writecache.c |   44 ++++++++++++++++++++++++++++++--------------
> > >  1 file changed, 30 insertions(+), 14 deletions(-)
> > > 
> > > Index: linux-2.6/drivers/md/dm-writecache.c
> > > ===================================================================
> > > --- linux-2.6.orig/drivers/md/dm-writecache.c	2020-04-08 14:47:17.000000000 +0200
> > > +++ linux-2.6/drivers/md/dm-writecache.c	2020-04-08 20:59:15.000000000 +0200
> > > @@ -931,6 +931,24 @@ static int writecache_alloc_entries(stru
> > >  	return 0;
> > >  }
> > >  
> > > +static int writecache_read_metadata(struct dm_writecache *wc, sector_t n_sectors)
> > > +{
> > > +	struct dm_io_region region;
> > > +	struct dm_io_request req;
> > > +
> > > +	region.bdev = wc->ssd_dev->bdev;
> > > +	region.sector = wc->start_sector;
> > > +	region.count = wc->metadata_sectors;
> > > +	req.bi_op = REQ_OP_READ;
> > > +	req.bi_op_flags = REQ_SYNC;
> > > +	req.mem.type = DM_IO_VMA;
> > > +	req.mem.ptr.vma = (char *)wc->memory_map;
> > > +	req.client = wc->dm_io;
> > > +	req.notify.fn = NULL;
> > > +
> > > +	return dm_io(&req, 1, &region, NULL);
> > > +}
> > > +
> > 
> > You aren't using the passed n_sectors (for region.count?)
> > 
> > 
> > >  static void writecache_resume(struct dm_target *ti)
> > >  {
> > >  	struct dm_writecache *wc = ti->private;
> > > @@ -941,8 +959,16 @@ static void writecache_resume(struct dm_
> > >  
> > >  	wc_lock(wc);
> > >  
> > > -	if (WC_MODE_PMEM(wc))
> > > +	if (WC_MODE_PMEM(wc)) {
> > >  		persistent_memory_invalidate_cache(wc->memory_map, wc->memory_map_size);
> > > +	} else {
> > > +		r = writecache_read_metadata(wc, wc->metadata_sectors);
> > > +		if (r) {
> > > +			writecache_error(wc, r, "unable to read metadata: %d", r);
> > > +			memset((char *)wc->memory_map + offsetof(struct wc_memory_superblock, entries), -1,
> > > +			       (wc->metadata_sectors << SECTOR_SHIFT) - offsetof(struct wc_memory_superblock, entries));
> > > +		}
> > > +	}
> > >  
> > >  	wc->tree = RB_ROOT;
> > >  	INIT_LIST_HEAD(&wc->lru);
> > > @@ -2200,8 +2226,6 @@ invalid_optional:
> > >  			goto bad;
> > >  		}
> > >  	} else {
> > > -		struct dm_io_region region;
> > > -		struct dm_io_request req;
> > >  		size_t n_blocks, n_metadata_blocks;
> > >  		uint64_t n_bitmap_bits;
> > >  
> > > @@ -2258,17 +2282,9 @@ invalid_optional:
> > >  			goto bad;
> > >  		}
> > >  
> > > -		region.bdev = wc->ssd_dev->bdev;
> > > -		region.sector = wc->start_sector;
> > > -		region.count = wc->metadata_sectors;
> > > -		req.bi_op = REQ_OP_READ;
> > > -		req.bi_op_flags = REQ_SYNC;
> > > -		req.mem.type = DM_IO_VMA;
> > > -		req.mem.ptr.vma = (char *)wc->memory_map;
> > > -		req.client = wc->dm_io;
> > > -		req.notify.fn = NULL;
> > > -
> > > -		r = dm_io(&req, 1, &region, NULL);
> > > +		r = writecache_read_metadata(wc,
> > > +			min((sector_t)bdev_logical_block_size(wc->ssd_dev->bdev) >> SECTOR_SHIFT,
> > > +			    (sector_t)wc->metadata_sectors));
> > 
> > Can you explain why this is needed?  Why isn't wc->metadata_sectors
> > already compatible with wc->ssd_dev->bdev ?
> 
> bdev_logical_block_size is the minimum size accepted by the device. If we 
> used just bdev_logical_block_size(wc->ssd_dev->bdev), someone could (by 
> using extremely small device with large logical_block_size) trigger 
> writing out of the allocated memory.

OK...
 
> > Yet you just use wc->metadata_sectors in the new call to
> > writecache_read_metadata() in writecache_resume()...
> 
> This was my mistake. Change it to "region.count = n_sectors";

sure, that addresses one aspect.  But I'm also asking:
given what yoou said above about reading past end of smaller device, why
is it safe to do this in writecache_resume ?

r = writecache_read_metadata(wc, wc->metadata_sectors);

Shouldn't ctr do extra validation and then all calls to
writecache_read_metadata() use wc->metadata_sectors?  Which would remove
need to pass extra 'n_sectors' arg to writecache_read_metadata()?

Mike
