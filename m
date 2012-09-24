From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: gracefully fail any request beyond
 the end of the device
Date: Mon, 24 Sep 2012 09:07:11 -0400
Message-ID: <20120924130711.GA27531@redhat.com>
References: <20120920192812.GA31495@redhat.com>
	<20120921154703.GB5967@redhat.com> <50602A28.8010402@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <50602A28.8010402@ce.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: dm-devel@redhat.com, Mike Christie <michaelc@cs.wisc.edu>
List-Id: dm-devel.ids

On Mon, Sep 24 2012 at  5:38am -0400,
Jun'ichi Nomura <j-nomura@ce.jp.nec.com> wrote:

> On 09/22/12 00:47, Mike Snitzer wrote:
> > @@ -1651,19 +1654,31 @@ static void dm_request_fn(struct request
> >  		if (!rq)
> >  			goto delay_and_out;
> >  
> > +		clone = rq->special;
> > +
> >  		/* always use block 0 to find the target for flushes for now */
> >  		pos = 0;
> >  		if (!(rq->cmd_flags & REQ_FLUSH))
> >  			pos = blk_rq_pos(rq);
> >  
> >  		ti = dm_table_find_target(map, pos);
> > -		BUG_ON(!dm_target_is_valid(ti));
> > +		if (!dm_target_is_valid(ti)) {
> > +			/*
> > +			 * Must perform setup, that dm_done() requires,
> > +			 * before calling dm_kill_unmapped_request
> > +			 */
> > +			DMERR_LIMIT("request attempted access beyond the end of device");
> > +			blk_start_request(rq);
> > +			atomic_inc(&md->pending[rq_data_dir(clone)]);
> > +			dm_get(md);
> > +			dm_kill_unmapped_request(clone, -EIO);
> > +			goto out;
> 
> This "goto out" should be "continue" so that request_fn
> process next requests in the queue.
> 
> Also I think introducing a function dm_start_request()
> will make this part of code a little bit easier for reading.
> An edited patch is attached.

Aside from the continue, matches exactly what I was going to do for v3
(based on Mike Christie's feedback -- which was to introduce
dm_start_request too).  Anyway, looks great.

I'll get a formal v3 posted so Alasdair can stage it.

Thanks,
Mike
