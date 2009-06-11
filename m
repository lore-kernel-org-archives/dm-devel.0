From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 10/19] io-conroller: Prepare elevator layer
	for single queue schedulers
Date: Thu, 11 Jun 2009 10:41:36 -0400
Message-ID: <20090611144136.GC27892@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-11-git-send-email-vgoyal@redhat.com>
	<4A30BC0F.3000401@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A30BC0F.3000401@cn.fujitsu.com>
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

On Thu, Jun 11, 2009 at 04:10:55PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  
> >  /*
> > @@ -1296,6 +1302,13 @@ void io_group_chain_link(struct request_queue *q, void *key,
> >  		iog = io_cgroup_lookup_group(iocg, key);
> >  		io_group_set_parent(prev, iog);
> >  	}
> > +
> > +	if (unlikely(efqd->only_root_group))
> > +		/*
> > +		 * TODO: Take care of force expiry of existing queue before
> > +		 * new queue is queued.
> > +		 */
> > +		efqd->only_root_group = 0;
> 
>   Hi Vivek,
> 
>   This flag isn't set back when all child groups go away. Am i missing something?
>   BTW, why not just determine "only root group" by cgroup itself? Although there might be 
>   some impact if cgroup is built but no request goes into it. but i think this isn't a big
>   deal. How about the following patch?
> 

Hi Gui,

Determining if there are any children present or not from cgroup sounds like
a good idea. Just that cost of the operation now has increased. I am not
sure how significant that is. But for the time being we can stick to your
implementation. 

One question inline below.

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |   21 ++++++++++-----------
>  block/elevator-fq.h |    1 -
>  2 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index a516dce..f33155c 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -76,7 +76,6 @@ void elv_del_ioq_busy(struct elevator_queue *e, struct io_queue *ioq,
>  void elv_activate_ioq(struct io_queue *ioq, int add_front);
>  void elv_deactivate_ioq(struct elv_fq_data *efqd, struct io_queue *ioq,
>  					int requeue);
> -
>  static int bfq_update_next_active(struct io_sched_data *sd)
>  {
>  	struct io_group *iog;
> @@ -1131,6 +1130,14 @@ struct io_cgroup io_root_cgroup = {
>  	.ioprio_class = IO_DEFAULT_GRP_CLASS,
>  };
>  
> +static int is_only_root_group(void)
> +{
> +	if (list_empty(&io_root_cgroup.css.cgroup->children))
> +		return 1;
> +

Do we need some kind of locking here to make sure cgroup->children list is not
being modified?

Thanks
Vivek

> +	return 0;
> +}
> +
>  void bfq_init_entity(struct io_entity *entity, struct io_group *iog)
>  {
>  	entity->ioprio = entity->new_ioprio;
> @@ -1543,13 +1550,6 @@ void io_group_chain_link(struct request_queue *q, void *key,
>  		iog = io_cgroup_lookup_group(iocg, key);
>  		io_group_set_parent(prev, iog);
>  	}
> -
> -	if (unlikely(efqd->only_root_group))
> -		/*
> -		 * TODO: Take care of force expiry of existing queue before
> -		 * new queue is queued.
> -		 */
> -		efqd->only_root_group = 0;
>  }
>  
>  /**
> @@ -3601,7 +3601,7 @@ void *elv_fq_select_ioq(struct request_queue *q, int force)
>  	 * overhead.
>  	 */
>  
> -	if (efqd->only_root_group && elv_iosched_single_ioq(q->elevator)) {
> +	if (is_only_root_group() && elv_iosched_single_ioq(q->elevator)) {
>  		elv_log_ioq(efqd, ioq, "select: only root group, no expiry");
>  		goto keep_queue;
>  	}
> @@ -3872,7 +3872,7 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>  		 * unnecessary overhead.
>  		 */
>  
> -		if (efqd->only_root_group &&
> +		if (is_only_root_group() &&
>  			elv_iosched_single_ioq(q->elevator)) {
>  			elv_log_ioq(efqd, ioq, "select: only root group,"
>  					" no expiry");
> @@ -4019,7 +4019,6 @@ int elv_init_fq_data(struct request_queue *q, struct elevator_queue *e)
>  
>  	/* For the time being keep fairness enabled by default */
>  	efqd->fairness = 1;
> -	efqd->only_root_group = 1;
>  	return 0;
>  }
>  
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 1b1fb0b..0939735 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -368,7 +368,6 @@ struct elv_fq_data {
>  	 * queues.
>  	 */
>  	unsigned int fairness;
> -	int only_root_group;
>  };
>  
>  extern int elv_slice_idle;
> -- 
> 1.5.4.rc3
> 
> 
> 
