From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] io-controller: Fix task hanging when there
	are more than one groups
Date: Sun, 13 Sep 2009 22:44:01 -0400
Message-ID: <20090914024401.GA14077@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<4AA4B905.8010801@cn.fujitsu.com>
	<20090908191941.GF15974@redhat.com>
	<4AA75B71.5060109@cn.fujitsu.com>
	<20090909150537.GD8256@redhat.com> <4AA9A4BE.30005@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AA9A4BE.30005@cn.fujitsu.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Sep 11, 2009 at 09:15:42AM +0800, Gui Jianfeng wrote:

[..]
> Hi Vivek, Jens,
> 
> Currently, If there's only the root cgroup and no other child cgroup available, io-controller will
> optimize to stop expiring the current ioq, and we thought the current ioq belongs to root group. But
> in some cases, this assumption is not true. Consider the following scenario, if there is a child cgroup
> located in root cgroup, and task A is running in the child cgroup, and task A issues some IOs. Then we
> kill task A and remove the child cgroup, at this time, there is only root cgroup available. But the ioq
> is still under service, and from now on, this ioq won't expire because "only root" optimization.
> The following patch ensures the ioq do belongs to the root group if there's only root group existing.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Cool. Good catch Gui. Queued for next posting.

Thanks
Vivek

> ---
>  block/elevator-fq.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index b723c12..3f86552 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2338,9 +2338,10 @@ void elv_reset_request_ioq(struct request_queue *q, struct request *rq)
>  	}
>  }
>  
> -static inline int is_only_root_group(void)
> +static inline int is_only_root_group(struct elv_fq_data *efqd)
>  {
> -	if (list_empty(&io_root_cgroup.css.cgroup->children))
> +	if (list_empty(&io_root_cgroup.css.cgroup->children) &&
> +	    efqd->busy_queues == 1 && efqd->root_group->ioq)
>  		return 1;
>  
>  	return 0;
> @@ -2383,7 +2384,7 @@ static void io_free_root_group(struct elevator_queue *e)
>  int elv_iog_should_idle(struct io_queue *ioq) { return 0; }
>  EXPORT_SYMBOL(elv_iog_should_idle);
>  
> -static inline int is_only_root_group(void)
> +static inline int is_only_root_group(struct elv_fq_data *efqd)
>  {
>  	return 1;
>  }
> @@ -2547,7 +2548,7 @@ elv_iosched_expire_ioq(struct request_queue *q, int slice_expired, int force)
>  	struct elevator_queue *e = q->elevator;
>  	struct io_queue *ioq = elv_active_ioq(q->elevator);
>  	int ret = 1;
> -
> +	
>  	if (e->ops->elevator_expire_ioq_fn) {
>  		ret = e->ops->elevator_expire_ioq_fn(q, ioq->sched_queue,
>  							slice_expired, force);
> @@ -2969,7 +2970,7 @@ void *elv_select_ioq(struct request_queue *q, int force)
>  	 * single queue ioschedulers (noop, deadline, AS).
>  	 */
>  
> -	if (is_only_root_group() && elv_iosched_single_ioq(q->elevator))
> +	if (is_only_root_group(efqd) && elv_iosched_single_ioq(q->elevator))
>  		goto keep_queue;
>  
>  	/* We are waiting for this group to become busy before it expires.*/
> @@ -3180,7 +3181,7 @@ void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
>  		 * unnecessary overhead.
>  		 */
>  
> -		if (is_only_root_group() &&
> +		if (is_only_root_group(ioq->efqd) &&
>  			elv_iosched_single_ioq(q->elevator)) {
>  			elv_log_ioq(efqd, ioq, "select: only root group,"
>  					" no expiry");
> -- 
> 1.5.4.rc3
> 
> 
> 
> 
> 
