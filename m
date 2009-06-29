From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] io-controller: optimization for iog deletion
	when elevator exiting
Date: Mon, 29 Jun 2009 10:06:31 -0400
Message-ID: <20090629140631.GA4622@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	<1245443858-8487-6-git-send-email-vgoyal@redhat.com>
	<4A4850D3.3000700@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A4850D3.3000700@cn.fujitsu.com>
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

On Mon, Jun 29, 2009 at 01:27:47PM +0800, Gui Jianfeng wrote:
> Hi Vivek,
> 
> There's no need to travel the iocg->group_data for each iog
> when exiting a elevator, that costs too much. An alternative 
> solution is reseting iocg_id as soon as an io group unlinking 
> from a iocg. Make a decision that whether it's need to carry 
> out deleting action by checking iocg_id.
> 

Thanks Gui. This makes sense to me. We can check iog->iocg_id to determine
wheter group is still on iocg list or not instead of traversing the list.

Nauman, do you see any issues with the patch?

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |   29 ++++++++++-------------------
>  1 files changed, 10 insertions(+), 19 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index d779282..b26fe0f 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2218,8 +2218,6 @@ void io_group_cleanup(struct io_group *iog)
>  	BUG_ON(iog->sched_data.active_entity != NULL);
>  	BUG_ON(entity != NULL && entity->tree != NULL);
>  
> -	iog->iocg_id = 0;
> -
>  	/*
>  	 * Wait for any rcu readers to exit before freeing up the group.
>  	 * Primarily useful when io_get_io_group() is called without queue
> @@ -2376,6 +2374,7 @@ remove_entry:
>  			  group_node);
>  	efqd = rcu_dereference(iog->key);
>  	hlist_del_rcu(&iog->group_node);
> +	iog->iocg_id = 0;
>  	spin_unlock_irqrestore(&iocg->lock, flags);
>  
>  	spin_lock_irqsave(efqd->queue->queue_lock, flags);
> @@ -2403,35 +2402,27 @@ done:
>  void io_group_check_and_destroy(struct elv_fq_data *efqd, struct io_group *iog)
>  {
>  	struct io_cgroup *iocg;
> -	unsigned short id = iog->iocg_id;
> -	struct hlist_node *n;
> -	struct io_group *__iog;
>  	unsigned long flags;
>  	struct cgroup_subsys_state *css;
>  
>  	rcu_read_lock();
>  
> -	BUG_ON(!id);
> -	css = css_lookup(&io_subsys, id);
> +	css = css_lookup(&io_subsys, iog->iocg_id);
>  
> -	/* css can't go away as associated io group is still around */
> -	BUG_ON(!css);
> +	if (!css)
> +		goto out;
>  
>  	iocg = container_of(css, struct io_cgroup, css);
>  
>  	spin_lock_irqsave(&iocg->lock, flags);
> -	hlist_for_each_entry_rcu(__iog, n, &iocg->group_data, group_node) {
> -		/*
> -		 * Remove iog only if it is still in iocg list. Cgroup
> -		 * deletion could have deleted it already.
> -		 */
> -		if (__iog == iog) {
> -			hlist_del_rcu(&iog->group_node);
> -			__io_destroy_group(efqd, iog);
> -			break;
> -		}
> +
> +	if (iog->iocg_id) {
> +		hlist_del_rcu(&iog->group_node);
> +		__io_destroy_group(efqd, iog);
>  	}
> +
>  	spin_unlock_irqrestore(&iocg->lock, flags);
> +out:
>  	rcu_read_unlock();
>  }
>  
> -- 1.5.4.rc3 
