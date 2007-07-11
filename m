From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: Re: [2.6.23 PATCH 16/18] dm mpath: rdac
Date: Wed, 11 Jul 2007 15:19:42 -0700
Message-ID: <1184192382.5146.15.camel@linuxchandra>
References: <20070711210242.GH24114@agk.fab.redhat.com>
	<20070711144303.9400acba.akpm@linux-foundation.org>
Reply-To: sekharan@us.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070711144303.9400acba.akpm@linux-foundation.org>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, 2007-07-11 at 14:43 -0700, Andrew Morton wrote:
> On Wed, 11 Jul 2007 22:02:42 +0100
> Alasdair G Kergon <agk@redhat.com> wrote:
> 
> > From: Mike Christie <michaelc@cs.wisc.edu>
> > 
> > This patch from Chandra Seetharaman and updated to upstream by me,
> > supports LSI/Engenio devices in RDAC mode. Like dm-emc
> > it requires userspace support. In your multipath.conf file you must have:
> > 
> > path_checker            rdac
> > hardware_handler        "1 rdac"
> > 
> > And you also then must have a updated multipath tools release which
> > has rdac support.
> > 
> > ...
> >
> > +static spinlock_t list_lock = SPIN_LOCK_UNLOCKED;
> 
> This defeats lockdep.  Please use DEFINE_SPINLOCK.

Will do
> 
> > +#define submit_c9_inquiry(h) \
> > +	submit_inquiry(h, 0xC9, sizeof(struct c9_inquiry), c9_inquiry_endio)
> > +#define submit_c4_inquiry(h) \
> > +	submit_inquiry(h, 0xC4, sizeof(struct c4_inquiry), c4_inquiry_endio)
> > +#define submit_c8_inquiry(h) \
> > +	submit_inquiry(h, 0xC8, sizeof(struct c8_inquiry), c8_inquiry_endio)
> > +#define submit_c2_inquiry(h) \
> > +	submit_inquiry(h, 0xC2, sizeof(struct c2_inquiry), c2_inquiry_endio)
> 
> These don't have to be implemented as macros.

They were all spanning two lines, wanted to make it look clean were it
was used.

Will change.

> 
> > +static struct request *get_rdac_req(struct rdac_handler *h,
> > +			void *buffer, unsigned buflen, int rw)
> > +{
> > +	struct request *rq;
> > +	struct request_queue *q = bdev_get_queue(h->path->dev->bdev);
> > +
> > +	rq = blk_get_request(q, rw, GFP_ATOMIC);
> 
> GFP_ATOMIC is unreliable.  Is it really unavoidable?

We can avoid it here.

Will change.
> 
> > +	if (!rq) {
> > +		DMINFO("get_rdac_req: blk_get_request failed");
> > +		return NULL;
> > +	}
> > +
> > +	if (buflen && blk_rq_map_kern(q, rq, buffer, buflen, GFP_ATOMIC)) {
> > +		blk_put_request(rq);
> > +		DMINFO("get_rdac_req: blk_rq_map_kern failed");
> > +		return NULL;
> > +	}
> > +
> > + 	memset(&rq->cmd, 0, BLK_MAX_CDB);
> > +	rq->sense = h->sense;
> > +	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
> > +	rq->sense_len = 0;
> > +
> > +	rq->end_io_data = h;
> > +	rq->timeout = h->timeout;
> > +	rq->cmd_type = REQ_TYPE_BLOCK_PC;
> > +	rq->cmd_flags = REQ_FAILFAST | REQ_NOMERGE;
> > +	return rq;
> > +}
> > +
> >
> > ...
> >
> > +
> > +/* Acquires h->ctlr->lock */
> > +static void submit_mode_select(struct rdac_handler *h)
> > +{
> > +	struct request *rq;
> > +	struct request_queue *q = bdev_get_queue(h->path->dev->bdev);
> > +
> > +	spin_lock(&h->ctlr->lock);
> > +	if (h->ctlr->submitted) {
> > +		list_add(&h->entry, &h->ctlr->cmd_list);
> > +		goto drop_lock;
> > +	}
> > +
> > +	if (!q) {
> > +		DMINFO("submit_mode_select: no queue");
> > +		goto fail_path;
> > +	}
> > +
> > +	rq = rdac_failover_get(h);
> > +	if (!rq) {
> > +		DMERR("submit_mode_select: no rq");
> > +		goto fail_path;
> > +	}
> > +
> > +	DMINFO("queueing MODE_SELECT command on %s", h->path->dev->name);
> > +
> > +	blk_execute_rq_nowait(q, NULL, rq, 1, mode_select_endio);
> 
> I suspect we could call this after dropping the lock?

We could.

Will do.
> 
> > +	h->ctlr->submitted = 1;
> > +	goto drop_lock;
> > +fail_path:
> > +	dm_pg_init_complete(h->path, MP_FAIL_PATH);
> > +drop_lock:
> > +	spin_unlock(&h->ctlr->lock);
> > +}
> > +
> >
> > ...
> >
> > +static void c2_inquiry_endio(struct request *req, int error)
> > +{
> > +	struct rdac_handler *h = req->end_io_data;
> > +	struct c2_inquiry *sp;
> > +
> > +	if (had_failures(req, error)) {
> > +		dm_pg_init_complete(h->path, MP_FAIL_PATH);
> > +		goto done;
> > +	}
> > +
> > +	sp = (struct c2_inquiry *)&h->inq;
> 
> That's funny-looking and un-typesafe.  Why not do
> 
> 	sp = &h->inq.c2;
> 
> ?
> 
> (Dittoes in various other places..)

Will change.
> 
> > +
> > +	/* If more than MODE6_MAX_LUN luns are supported, use mode select 10 */
> > +	if (sp->max_lun_supported >= MODE6_MAX_LUN)
> > +		h->ctlr->use_10_ms = 1;
> > +	else
> > +		h->ctlr->use_10_ms = 0;
> > +
> > +	h->cmd_to_send = SEND_MODE_SELECT;
> > +	queue_work(rdac_wkqd, &h->work);
> > +done:
> > +	__blk_put_request(req->q, req);
> > +}
> > +
> > +static void rdac_destroy(struct hw_handler *hwh)
> > +{
> > +	struct rdac_handler *h = (struct rdac_handler *) hwh->context;
> 
> Unneeded (and undesirable) cast of void*.  Please check the whole
> patch(set) for this.

Will do.
> 
> > +	if (h->ctlr)
> > +		kref_put(&h->ctlr->kref, release_ctlr);
> > +	kfree(h);
> > +	hwh->context = NULL;
> > +}
> > +
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
