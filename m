From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm writecache: fix data corruption when reloading
	the target
Date: Wed, 15 Apr 2020 10:53:59 -0400
Message-ID: <20200415145359.GA30397@redhat.com>
References: <alpine.LRH.2.02.2004081459520.14853@file01.intranet.prod.int.rdu2.redhat.com>
	<20200414190515.GA25340@redhat.com>
	<alpine.LRH.2.02.2004150405330.3968@file01.intranet.prod.int.rdu2.redhat.com>
	<20200415130153.GB29959@redhat.com>
	<alpine.LRH.2.02.2004151044530.25321@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2004151044530.25321@file01.intranet.prod.int.rdu2.redhat.com>
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

On Wed, Apr 15 2020 at 10:49am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 15 Apr 2020, Mike Snitzer wrote:
> 
> > > > > +		r = writecache_read_metadata(wc,
> > > > > +			min((sector_t)bdev_logical_block_size(wc->ssd_dev->bdev) >> SECTOR_SHIFT,
> > > > > +			    (sector_t)wc->metadata_sectors));
> > > > 
> > > > Can you explain why this is needed?  Why isn't wc->metadata_sectors
> > > > already compatible with wc->ssd_dev->bdev ?
> > > 
> > > bdev_logical_block_size is the minimum size accepted by the device. If we 
> > > used just bdev_logical_block_size(wc->ssd_dev->bdev), someone could (by 
> > > using extremely small device with large logical_block_size) trigger 
> > > writing out of the allocated memory.
> > 
> > OK...
> >  
> > > > Yet you just use wc->metadata_sectors in the new call to
> > > > writecache_read_metadata() in writecache_resume()...
> > > 
> > > This was my mistake. Change it to "region.count = n_sectors";
> > 
> > sure, that addresses one aspect.  But I'm also asking:
> > given what yoou said above about reading past end of smaller device, why
> > is it safe to do this in writecache_resume ?
> > 
> > r = writecache_read_metadata(wc, wc->metadata_sectors);
> > 
> > Shouldn't ctr do extra validation and then all calls to
> > writecache_read_metadata() use wc->metadata_sectors?  Which would remove
> > need to pass extra 'n_sectors' arg to writecache_read_metadata()?
> > 
> > Mike
> 
> wc->memory_map = vmalloc(n_metadata_blocks << wc->block_size_bits);
> ...
> wc->metadata_sectors = n_metadata_blocks << (wc->block_size_bits - SECTOR_SHIFT);
> 
> So we are always sure that we can read/write wc->metadata_sectors safely. 
> 
> The problem is - what if bdev_logical_block_size is larger than 
> wc->metadata_sectors? Then, we would overread past the end of allocated 
> memory. The device wouldn't work anyway in this case, so perhaps a better 
> solution would be to reject this as an error in the constructor.

Yes, please reject in ctr.  No point allowing writecache to limp along
only to fail IO later.

By failing accordingly in ctr that'll allow writecache_read_metadata()
to not need an n_sectors override.

Thanks,
Mike
