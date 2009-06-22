From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] io-controller: Preempt a non-rt queue if a
	rt ioq is present in ancestor or sibling groups
Date: Mon, 22 Jun 2009 13:21:23 -0400
Message-ID: <20090622172123.GE15600@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-21-git-send-email-vgoyal@redhat.com>
	<4A3F3648.7080007@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A3F3648.7080007@cn.fujitsu.com>
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

On Mon, Jun 22, 2009 at 03:44:08PM +0800, Gui Jianfeng wrote:
> Preempt the ongoing non-rt ioq if there are rt ioqs waiting for dispatching
> in ancestor or sibling groups. It will give other group's rt ioq an chance 
> to dispatch ASAP.
> 

Hi Gui,

Will new preempton logic of traversing up the hiearchy so that both new
queue and old queue are at same level to take a preemption decision not
take care of above scenario?

Please have a look at bfq_find_matching_entity().

At the same time we probably don't want to preempt the non-rt queue
with an RT queue in sibling group until and unless sibling group is an
RT group.

		root
		/  \
	   BEgrpA  BEgrpB
	      |     |	
	  BEioq1   RTioq2

Above we got two BE group A and B and assume ioq in group A is being
served and then an RT request in group B comes. Because group B is an
BE class group, we should not preempt the queue in group A.

Thanks
Vivek


> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |   44 +++++++++++++++++++++++++++++++++++++++-----
>  block/elevator-fq.h |    1 +
>  2 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 2ad40eb..80526fd 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -3245,8 +3245,16 @@ void elv_add_ioq_busy(struct elv_fq_data *efqd, struct io_queue *ioq)
>  	elv_mark_ioq_busy(ioq);
>  	efqd->busy_queues++;
>  	if (elv_ioq_class_rt(ioq)) {
> +		struct io_entity *entity;
>  		struct io_group *iog = ioq_to_io_group(ioq);
> +
>  		iog->busy_rt_queues++;
> +		entity = iog->entity.parent;
> +
> +		for_each_entity(entity) {
> +			iog = io_entity_to_iog(entity);
> +			iog->sub_busy_rt_queues++;
> +		}
>  	}
>  
>  #ifdef CONFIG_DEBUG_GROUP_IOSCHED
> @@ -3290,9 +3298,18 @@ void elv_del_ioq_busy(struct elevator_queue *e, struct io_queue *ioq,
>  	elv_clear_ioq_busy(ioq);
>  	BUG_ON(efqd->busy_queues == 0);
>  	efqd->busy_queues--;
> +
>  	if (elv_ioq_class_rt(ioq)) {
> +		struct io_entity *entity;
>  		struct io_group *iog = ioq_to_io_group(ioq);
> +
>  		iog->busy_rt_queues--;
> +		entity = iog->entity.parent;
> +
> +		for_each_entity(entity) {
> +			iog = io_entity_to_iog(entity);
> +			iog->sub_busy_rt_queues--;
> +		}
>  	}
>  
>  	elv_deactivate_ioq(efqd, ioq, requeue);
> @@ -3735,12 +3752,32 @@ int elv_iosched_expire_ioq(struct request_queue *q, int slice_expired,
>  	return ret;
>  }
>  
> +static int check_rt_queue(struct io_queue *ioq)
> +{
> +	struct io_group *iog;
> +	struct io_entity *entity;
> +
> +	iog = ioq_to_io_group(ioq);
> +
> +	if (iog->busy_rt_queues)
> +		return 1;
> +
> +	entity = iog->entity.parent;
> +
> +	for_each_entity(entity) {
> +		iog = io_entity_to_iog(entity);
> +		if (iog->sub_busy_rt_queues)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  /* Common layer function to select the next queue to dispatch from */
>  void *elv_fq_select_ioq(struct request_queue *q, int force)
>  {
>  	struct elv_fq_data *efqd = &q->elevator->efqd;
>  	struct io_queue *new_ioq = NULL, *ioq = elv_active_ioq(q->elevator);
> -	struct io_group *iog;
>  	int slice_expired = 1;
>  
>  	if (!elv_nr_busy_ioq(q->elevator))
> @@ -3811,12 +3848,9 @@ void *elv_fq_select_ioq(struct request_queue *q, int force)
>  	/*
>  	 * If we have a RT cfqq waiting, then we pre-empt the current non-rt
>  	 * cfqq.
> -	 *
> -	 * TODO: This does not seem right across the io groups. Fix it.
>  	 */
> -	iog = ioq_to_io_group(ioq);
>  
> -	if (!elv_ioq_class_rt(ioq) && iog->busy_rt_queues) {
> +	if (!elv_ioq_class_rt(ioq) && check_rt_queue(ioq)) {
>  		/*
>  		 * We simulate this as cfqq timed out so that it gets to bank
>  		 * the remaining of its time slice.
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index b3193f8..be6c1af 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -248,6 +248,7 @@ struct io_group {
>  	 * non-RT cfqq in service when this value is non-zero.
>  	 */
>  	unsigned int busy_rt_queues;
> +	unsigned int sub_busy_rt_queues;
>  
>  	int deleting;
>  	unsigned short iocg_id;
> -- 
> 1.5.4.rc3
> 
