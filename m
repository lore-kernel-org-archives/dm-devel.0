From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
Subject: Re: [PATCH] dm writecache: reject asynchronous pmem.
Date: Tue, 30 Jun 2020 16:10:22 +0200
Message-ID: <20200630141022.GZ21462@kitsune.suse.cz>
References: <20200630123528.29660-1-msuchanek@suse.de>
 <alpine.LRH.2.02.2006300929580.4801@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006300929580.4801@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-nvdimm@lists.01.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, Jan Kara <jack@suse.cz>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Pankaj Gupta <pagupta@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, Cornelia Huck <cohuck@redhat.com>, Jakub Staron <jstaron@google.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Jun 30, 2020 at 09:32:01AM -0400, Mikulas Patocka wrote:
> 
> 
> On Tue, 30 Jun 2020, Michal Suchanek wrote:
> 
> > The writecache driver does not handle asynchronous pmem. Reject it when
> > supplied as cache.
> > 
> > Link: https://lore.kernel.org/linux-nvdimm/87lfk5hahc.fsf@linux.ibm.com/
> > Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
> > 
> > Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> > ---
> >  drivers/md/dm-writecache.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> > index 30505d70f423..57b0a972f6fd 100644
> > --- a/drivers/md/dm-writecache.c
> > +++ b/drivers/md/dm-writecache.c
> > @@ -2277,6 +2277,12 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
> >  
> >  		wc->memory_map_size -= (uint64_t)wc->start_sector << SECTOR_SHIFT;
> >  
> > +		if (!dax_synchronous(wc->ssd_dev->dax_dev)) {
> > +			r = -EOPNOTSUPP;
> > +			ti->error = "Asynchronous persistent memory not supported as pmem cache";
> > +			goto bad;
> > +		}
> > +
> >  		bio_list_init(&wc->flush_list);
> >  		wc->flush_thread = kthread_create(writecache_flush_thread, wc, "dm_writecache_flush");
> >  		if (IS_ERR(wc->flush_thread)) {
> > -- 
> 
> Hi
> 
> Shouldn't this be in the "if (WC_MODE_PMEM(wc))" block?
That should be always the case at this point.
> 
> WC_MODE_PMEM(wc) retrurns true if we are using persistent memory as a 
> cache device, otherwise we are using generic block device as a cache 
> device.
This is to prevent the situation where we have WC_MODE_PMEM(wc) but
cannot guarantee consistency because the async flush is not handled.

Thanks

Michal
