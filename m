From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 15/28] io-controller: Allow CFQ specific
	extra preemptions
Date: Fri, 25 Sep 2009 14:24:34 +0800
Message-ID: <4ABC6222.9090103@cn.fujitsu.com>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	<1253820332-10246-16-git-send-email-vgoyal@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1253820332-10246-16-git-send-email-vgoyal@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

Vivek Goyal wrote:
> o CFQ allows a reader preemting a writer. So far we allow this with-in group
>   but not across groups. But there seems to be following special case where
>   this preemption might make sense.
> 
> 			root
> 			/  \
> 		       R   Group
> 			     |
> 			     W
> 
>   Now here reader should be able to preempt the writer. Think of there are
>   10 groups each running a writer and an admin trying to do "ls" and he
>   experiences suddenly high latencies for ls.

  Hi Vivek, 

  This preemption might be unfair to the readers who stay in the same group with
  writer. Consider the following:

                     root
                     /  \
                    R1  Group
                        /  \
                       R2   W

  Say W is running and late preemption is enabled, then a request goes into R1,
  R1 will preempt W immediately regardless of R2. Now R2 don't have a chance to
  get scheduled even if R1 has a very high vdisktime. It seems not so fair to R2.
  So I suggest the number of readers in group should be taken into account when
  making this preemption decision. R1 should only preempts W when there are not 
  any readers in that group.

  Thanks,
  Gui Jianfeng

> 
>   Same is true for meta data requests. If there is a meta data request and
>   a reader is running inside a sibling group, preemption will be allowed.
>   Note, following is not allowed.
> 			root
> 			/  \
> 	            group1 group2
> 		      |      |
> 	              R	     W
> 
>   Here reader can't preempt writer.
> 
> o Put meta data requesting queues at the front of the service tree. Generally
>   such queues will preempt currently running queue but not in following case.
> 			root
> 			/  \
> 	            group1 group2
> 		      |     / \
> 	              R1   R3  R2 (meta data)
> 
>  Here R2 is having a meta data request but it will not preempt R1. We need
>  to make sure that R2 gets queued ahead of R3 so taht once group2 gets
>  going, we first service R2 and then R3 and not vice versa.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  block/elevator-fq.c |   47 +++++++++++++++++++++++++++++++++++++++++++++--
>  block/elevator-fq.h |    3 +++
>  2 files changed, 48 insertions(+), 2 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 25beaf7..8ff8a19 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -701,6 +701,7 @@ static void enqueue_io_entity(struct io_entity *entity)
>  	struct io_service_tree *st;
>  	struct io_sched_data *sd = io_entity_sched_data(entity);
>  	struct io_queue *ioq = ioq_of(entity);
> +	int add_front = 0;
>  
>  	if (entity->on_idle_st)
>  		dequeue_io_entity_idle(entity);
> @@ -716,12 +717,22 @@ static void enqueue_io_entity(struct io_entity *entity)
>  	st = entity->st;
>  	st->nr_active++;
>  	sd->nr_active++;
> +
>  	/* Keep a track of how many sync queues are backlogged on this group */
>  	if (ioq && elv_ioq_sync(ioq) && !elv_ioq_class_idle(ioq))
>  		sd->nr_sync++;
>  	entity->on_st = 1;
> -	place_entity(st, entity, 0);
> -	__enqueue_io_entity(st, entity, 0);
> +
> +	/*
> +	 * If a meta data request is pending in this queue, put this
> +	 * queue at the front so that it gets a chance to run first
> +	 * as soon as the associated group becomes eligbile to run.
> +	 */
> +	if (ioq && ioq->meta_pending)
> +		add_front = 1;
> +
> +	place_entity(st, entity, add_front);
> +	__enqueue_io_entity(st, entity, add_front);
>  	debug_update_stats_enqueue(entity);
>  }
>  
> @@ -2280,6 +2291,31 @@ static int elv_should_preempt(struct request_queue *q, struct io_queue *new_ioq,
>  		return 1;
>  
>  	/*
> +	 * Allow some additional preemptions where a reader queue gets
> +	 * backlogged and some writer queue is running under any of the
> +	 * sibling groups.
> +	 *
> +	 * 		     root
> +	 * 		     /  \
> +	 * 		    R  group
> +	 * 			 |
> +	 * 			 W
> +	 */
> +
> +	if (ioq_of(new_entity) == new_ioq  && iog_of(entity)) {
> +		/* Let reader queue preempt writer in sibling group */
> +		if (elv_ioq_sync(new_ioq) && !elv_ioq_sync(active_ioq))
> +			return 1;
> +		/*
> +		 * So both queues are sync. Let the new request get disk time if
> +		 * it's a metadata request and the current queue is doing
> +		 * regular IO.
> +		 */
> +		if (new_ioq->meta_pending && !active_ioq->meta_pending)
> +			return 1;
> +	}
> +
> +	/*
>  	 * If both the queues belong to same group, check with io scheduler
>  	 * if it has additional criterion based on which it wants to
>  	 * preempt existing queue.
> @@ -2335,6 +2371,8 @@ void elv_ioq_request_add(struct request_queue *q, struct request *rq)
>  	BUG_ON(!efqd);
>  	BUG_ON(!ioq);
>  	ioq->nr_queued++;
> +	if (rq_is_meta(rq))
> +		ioq->meta_pending++;
>  	elv_log_ioq(efqd, ioq, "add rq: rq_queued=%d", ioq->nr_queued);
>  
>  	if (!elv_ioq_busy(ioq))
> @@ -2669,6 +2707,11 @@ void elv_ioq_request_removed(struct elevator_queue *e, struct request *rq)
>  	ioq = rq->ioq;
>  	BUG_ON(!ioq);
>  	ioq->nr_queued--;
> +
> +	if (rq_is_meta(rq)) {
> +		WARN_ON(!ioq->meta_pending);
> +		ioq->meta_pending--;
> +	}
>  }
>  
>  /* A request got dispatched. Do the accounting. */
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 2992d93..27ff5c4 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -100,6 +100,9 @@ struct io_queue {
>  
>  	/* Pointer to io scheduler's queue */
>  	void *sched_queue;
> +
> +	/* pending metadata requests */
> +	int meta_pending;
>  };
>  
>  #ifdef CONFIG_GROUP_IOSCHED /* CONFIG_GROUP_IOSCHED */

-- 
