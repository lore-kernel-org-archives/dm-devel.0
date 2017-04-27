From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 02/13] dm-mpath: Avoid that path removal can trigger an
 infinite loop
Date: Thu, 27 Apr 2017 11:36:42 -0400
Message-ID: <20170427153642.GC22608@redhat.com>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
 <20170426183728.10821-3-bart.vanassche@sandisk.com>
 <fabbb802-5743-1193-3d4e-841404db2372@suse.de>
 <1493305901.2625.1.camel@sandisk.com>
 <87938548-937c-004d-741b-ef3bd8c4ccc0@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87938548-937c-004d-741b-ef3bd8c4ccc0@suse.de>
Sender: stable-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>, "hare@suse.com" <hare@suse.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: dm-devel.ids

On Thu, Apr 27 2017 at 11:13am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 04/27/2017 05:11 PM, Bart Van Assche wrote:
> > On Thu, 2017-04-27 at 07:46 +0200, Hannes Reinecke wrote:
> >> On 04/26/2017 08:37 PM, Bart Van Assche wrote:
> >>> +	clone = blk_get_request(q, rq->cmd_flags | REQ_NOMERGE, GFP_ATOMIC);
> >>>  	if (IS_ERR(clone)) {
> >>>  		/* EBUSY, ENODEV or EWOULDBLOCK: requeue */
> >>> -		return r;
> >>> +		pr_debug("blk_get_request() returned %ld%s - requeuing\n",
> >>> +			 PTR_ERR(clone), blk_queue_dying(q) ?
> >>> +			 " (path offline)" : "");
> >>> +		if (blk_queue_dying(q)) {
> >>> +			atomic_inc(&m->pg_init_in_progress);
> >>> +			activate_path(pgpath);
> >>> +			return DM_MAPIO_REQUEUE;
> >>> +		}
> >>> +		return DM_MAPIO_DELAY_REQUEUE;
> >>>  	}
> >>>  	clone->bio = clone->biotail = NULL;
> >>>  	clone->rq_disk = bdev->bd_disk;
> >>
> >> At the very least this does warrant some inline comments.
> >> Why do we call activate_path() here, seeing that the queue is dying?
> > 
> > Hello Hannes,
> > 
> > activate_path() is not only able to activate a path but can also change
> > the state of a path to offline. The body of the activate_path() function
> > makes that clear and that is why I had not added a comment above the
> > activate_path() call:
> > 
> > static void activate_path(struct pgpath *pgpath)
> > {
> > 	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
> > 
> > 	if (pgpath->is_active && !blk_queue_dying(q))
> > 		scsi_dh_activate(q, pg_init_done, pgpath);
> > 	else
> > 		pg_init_done(pgpath, SCSI_DH_DEV_OFFLINED);
> > }
> > 
> So why not call 'pg_init_done()' directly and avoid the confusion?

Doing so is sprinkling more SCSI specific droppings in code that should
be increasingly transport agnostic.  Might be worth renaming
activate_path() to activate_or_offline_path() ?

Mike
