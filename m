From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair
	queuing code in elevaotor layer
Date: Mon, 8 Jun 2009 08:58:23 -0400
Message-ID: <20090608125823.GC3652@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-3-git-send-email-vgoyal@redhat.com>
	<4A2C649C.8070806@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A2C649C.8070806@cn.fujitsu.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, jbaron@redhat.com, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, righi.andrea@gmail.com, containers@lists.linux-foundation.org
List-Id: dm-devel.ids

On Mon, Jun 08, 2009 at 09:08:44AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +/* Get next queue for service. */
> > +struct io_queue *elv_get_next_ioq(struct request_queue *q, int extract)
> > +{
> > +	struct elv_fq_data *efqd = &q->elevator->efqd;
> > +	struct io_entity *entity = NULL;
> > +	struct io_queue *ioq = NULL;
> > +	struct io_sched_data *sd;
> > +
> > +	/*
> > +	 * one can check for which queue will be selected next while having
> > +	 * one queue active. preempt logic uses it.
> > +	 */
> > +	BUG_ON(extract && efqd->active_queue != NULL);
> > +
> > +	if (!efqd->busy_queues)
> > +		return NULL;
> > +
> > +	sd = &efqd->root_group->sched_data;
> > +	if (extract)
> > +		entity = bfq_lookup_next_entity(sd, 1);
> > +	else
> > +		entity = bfq_lookup_next_entity(sd, 0);
> 
> This if and else branch is not needed.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 3c5f9da..655162b 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -3069,10 +3069,7 @@ struct io_queue *elv_get_next_ioq(struct request_queue *q, int extract)
>  
>  	sd = &efqd->root_group->sched_data;
>  	for (; sd != NULL; sd = entity->my_sched_data) {
> -		if (extract)
> -			entity = bfq_lookup_next_entity(sd, 1);
> -		else
> -			entity = bfq_lookup_next_entity(sd, 0);
> +		entity = bfq_lookup_next_entity(sd, extract);
>  
>  		/*
>  		 * entity can be null despite the fact that there are busy

Thanks Gui. Queued for next posting.

Thanks
Vivek
