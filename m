From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: fold direct_make_requst into generic_make_request
Date: Mon, 26 Feb 2018 19:58:53 -0500
Message-ID: <20180227005852.GA15971@redhat.com>
References: <alpine.LRH.2.02.1802261524090.5096@file01.intranet.prod.int.rdu2.redhat.com>
	<20180227001328.GA15748@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180227001328.GA15748@redhat.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Javier =?iso-8859-1?B?R29uesOhbGV6?= <javier@cnexlabs.com>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Mon, Feb 26 2018 at  7:13pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Mon, Feb 26 2018 at  5:56pm -0500,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > The block layer provides a function direct_make_request - but it doesn't
> > provide any test whether this function may be used or not.
> > 
> > Device mapper currently uses a dirty trick - it compares the result of
> > bdevname against the string "nvme" to test if direct_make_request can be
> > used.
> 
> dm's DM_TYPE_NVME_BIO_BASED is backed by that crude "nvme" check _but_
> it is a means to an end.  Alternative would be to have NVMe (and other
> devices) set something like QUEUE_FLAG_NO_PARTIAL_COMPLETION or
> something -- and then DM would need to verify all underlying devices set
> that flag.
> 
> > The information whether the driver will or won't recurse can be easily
> > obtained in generic_make_request (by comparing make_request_fn - or
> > alternatively, we could introduce a queue flag for this), so my suggestion
> > is to just delete direct_make_request and fold this "norecurse"
> > optimization directly into generic_make_request This will allow us to
> > simplify device mapper paths and get rid of device name matching.
> 
> Sorry, Nack from me as implemented.  Please see below.

As we discussed, but for the benefit of others: I was mistaken.. I
reviewed your proposal too quickly.

> > Index: linux-2.6/block/blk-core.c
> > ===================================================================
> > --- linux-2.6.orig/block/blk-core.c	2018-02-26 20:37:19.088499000 +0100
> > +++ linux-2.6/block/blk-core.c	2018-02-26 20:43:57.839999000 +0100
> > @@ -2265,6 +2265,8 @@ end_io:
> >  	return false;
> >  }
> >  
> > +blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio);
> > +
> >  /**
> >   * generic_make_request - hand a buffer to its device driver for I/O
> >   * @bio:  The bio describing the location in memory and on the device.
> > @@ -2300,10 +2302,14 @@ blk_qc_t generic_make_request(struct bio
> >  	 */
> >  	struct bio_list bio_list_on_stack[2];
> >  	blk_qc_t ret = BLK_QC_T_NONE;
> > +	bool may_recurse;
> >  
> >  	if (!generic_make_request_checks(bio))
> >  		goto out;
> >  
> > +	may_recurse = bio->bi_disk->queue->make_request_fn != blk_queue_bio &&
> > +		      bio->bi_disk->queue->make_request_fn != blk_mq_make_request;
> > +
> 
> This does _not_ allow dm's DM_TYPE_NVME_BIO_BASED to make use of your
> direct_make_request() equivalent that you've encoded into
> generic_make_request().
> 
> There is no easy way to _know_, at runtime, that an arbitrary queue
> (e.g. stacked DM device) does _not_ split IO (therefore not needing to
> recurse).
> 
> Same can be said of NVMe given NVMe multipath sets its make_request_fn
> to nvme_ns_head_make_request().
> 
> So for both cases that don't need to recurse you're setting @may_recurse
> to true.

Both DM multipath and NVMe native multipath will change the bio->bi_disk
to the underlying NVMe device (which has make_request_fn set to
blk_mq_make_request).  SO: @may_recurse is set to false for both cases.

Sorry for tainting your work, I retract my Nack.  Avoiding the need for
drivers to reason about whether it best to call direct_make_request() vs
generic_make_request() is a welcome advance.  I think you plan on
submitting a v2 that avoids the make_request_fn check.  I'll review that
much more carefully before commenting ;)

Thanks,
Mike
