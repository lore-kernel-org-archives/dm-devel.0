From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] dm rq: Avoid that request processing stalls
	sporadically
Date: Fri, 19 Jan 2018 08:18:34 +0800
Message-ID: <20180119001834.GB4712@ming.t460p>
References: <20180118163707.11825-1-bart.vanassche@wdc.com>
	<20180119001136.GA4712@ming.t460p>
	<1516320863.2676.104.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1516320863.2676.104.camel@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 19, 2018 at 12:14:24AM +0000, Bart Van Assche wrote:
> On Fri, 2018-01-19 at 08:11 +0800, Ming Lei wrote:
> > On Thu, Jan 18, 2018 at 08:37:07AM -0800, Bart Van Assche wrote:
> > > diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> > > index f16096af879a..c59c59cfd2a5 100644
> > > --- a/drivers/md/dm-rq.c
> > > +++ b/drivers/md/dm-rq.c
> > > @@ -761,6 +761,7 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
> > >  		/* Undo dm_start_request() before requeuing */
> > >  		rq_end_stats(md, rq);
> > >  		rq_completed(md, rq_data_dir(rq), false);
> > > +		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
> > >  		return BLK_STS_RESOURCE;
> > >  	}
> > >  
> > 
> > Nak.
> 
> This patch fixes a regression that was introduced by you. You should know
> that regressions are not acceptable. If you don't agree with this patch,
> please fix the root cause.

Yesterday I sent a patch, did you test that?

-- 
Ming
