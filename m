From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v4-mike 2/2] blk-mq: issue request directly for
 blk_insert_cloned_request
Date: Tue, 16 Jan 2018 13:16:18 -0500
Message-ID: <20180116181618.GA31767@redhat.com>
References: <20180116150148.21145-1-snitzer@redhat.com>
 <20180116150148.21145-2-snitzer@redhat.com>
 <c149d8f4-4e75-81e0-77bf-9390393738ba@kernel.dk>
 <20180116173825.GA31582@redhat.com>
 <4ba90f92-82db-07de-59b8-f9d7d113d4dc@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4ba90f92-82db-07de-59b8-f9d7d113d4dc@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Jan 16 2018 at 12:41pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 1/16/18 10:38 AM, Mike Snitzer wrote:
> > On Tue, Jan 16 2018 at 12:20pm -0500,
> > Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> On 1/16/18 8:01 AM, Mike Snitzer wrote:
> >>> From: Ming Lei <ming.lei@redhat.com>
> >>>
> >>> blk_insert_cloned_request() is called in fast path of dm-rq driver, and
> >>> in this function we append request to hctx->dispatch_list of the underlying
> >>> queue directly.
> >>>
> >>> 1) This way isn't efficient enough because hctx lock is always required
> >>>
> >>> 2) With blk_insert_cloned_request(), we bypass underlying queue's IO
> >>> scheduler totally, and depend on DM rq driver to do IO schedule
> >>> completely.  But DM rq driver can't get underlying queue's dispatch
> >>> feedback at all, and this information is extreamly useful for IO merge.
> >>> Without that IO merge can't be done basically by blk-mq, which causes
> >>> very bad sequential IO performance.
> >>>
> >>> Fix this by having blk_insert_cloned_request() make use of
> >>> blk_mq_try_issue_directly() via blk_mq_request_direct_issue().
> >>> blk_mq_request_direct_issue() allows a request to be dispatched to be
> >>> issue directly to the underlying queue and provides dispatch result to
> >>> dm-rq and blk-mq.
> >>>
> >>> With this, the DM's blk-mq sequential IO performance is vastly
> >>> improved (as much as 3X in mpath/virtio-scsi testing).
> >>
> >> This still feels pretty hacky...
> >>
> >>> diff --git a/block/blk-mq.c b/block/blk-mq.c
> >>> index 55f3a27fb2e6..3168a13cb012 100644
> >>> --- a/block/blk-mq.c
> >>> +++ b/block/blk-mq.c
> >>> @@ -1706,6 +1706,12 @@ static blk_status_t __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
> >>>  	blk_qc_t new_cookie;
> >>>  	blk_status_t ret = BLK_STS_OK;
> >>>  	bool run_queue = true;
> >>> +	/*
> >>> +	 * If @cookie is NULL do not insert the request, this mode is used
> >>> +	 * by blk_insert_cloned_request() via blk_mq_request_direct_issue()
> >>> +	 */
> >>> +	bool dispatch_only = !cookie;
> >>> +	bool need_insert = false;
> >>
> >> Overloading 'cookie' to also mean this isn't very future proof or solid.
> > 
> > It enables the existing interface to be used without needing to prop up
> > something else that extends out to the edge (blk_insert_cloned_request).
> 
> Doesn't really matter if the end result is too ugly/fragile to live.

Agreed.
 
> >> And now __blk_mq_try_issue_directly() is pretty much a mess. Feels like
> >> it should be split in two, where the other half would do the actual
> >> insert. Then let the caller do it, if we could not issue directly. That
> >> would be a lot more solid and easier to read.
> > 
> > That is effectively what Ming's variant did (by splitting out the issue
> > to a helper).
> > 
> > BUT I'll see what I can come up with...
> 
> Maybe I missed that version, there were many rapid fire versions posted.
> Please just take your time and get it right, that's much more important.

No trying to rush, going over it carefully now.

Think I have a cleaner way forward.

Thanks,
Mike
