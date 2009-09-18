From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] io-controller: Fix another bug that causing
	system hanging
Date: Fri, 18 Sep 2009 10:47:07 -0400
Message-ID: <20090918144707.GA11338@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-12-git-send-email-vgoyal@redhat.com>
	<4AB30508.6010206@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB30508.6010206@cn.fujitsu.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, m-ikeda@ds.jp.nec.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Fri, Sep 18, 2009 at 11:56:56AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> 
> >   * If io scheduler has functionality of keeping track of close cooperator, check
> >   * with it if it has got a closely co-operating queue.
> > @@ -2057,6 +2171,7 @@ void *elv_select_ioq(struct request_queue *q, int force)
> >  {
> >  	struct elv_fq_data *efqd = q->elevator->efqd;
> >  	struct io_queue *new_ioq = NULL, *ioq = elv_active_ioq(q->elevator);
> > +	struct io_group *iog;
> >  
> >  	if (!elv_nr_busy_ioq(q->elevator))
> >  		return NULL;
> > @@ -2064,6 +2179,8 @@ void *elv_select_ioq(struct request_queue *q, int force)
> >  	if (ioq == NULL)
> >  		goto new_queue;
> >  
> > +	iog = ioq_to_io_group(ioq);
> > +
> >  	/*
> >  	 * Force dispatch. Continue to dispatch from current queue as long
> >  	 * as it has requests.
> > @@ -2075,11 +2192,47 @@ void *elv_select_ioq(struct request_queue *q, int force)
> >  			goto expire;
> >  	}
> >  
> > +	/* We are waiting for this group to become busy before it expires.*/
> > +	if (elv_iog_wait_busy(iog)) {
> > +		ioq = NULL;
> > +		goto keep_queue;
> > +	}
> > +
> >  	/*
> >  	 * The active queue has run out of time, expire it and select new.
> >  	 */
> > -	if (elv_ioq_slice_used(ioq) && !elv_ioq_must_dispatch(ioq))
> > -		goto expire;
> > +	if ((elv_ioq_slice_used(ioq) || elv_ioq_class_idle(ioq))
> > +	     && !elv_ioq_must_dispatch(ioq)) {
> > +		/*
> > +		 * Queue has used up its slice. Wait busy is not on otherwise
> > +		 * we wouldn't have been here. If this group will be deleted
> > +		 * after the queue expiry, then make sure we have onece
> > +		 * done wait busy on the group in an attempt to make it
> > +		 * backlogged.
> > +		 *
> > +		 * Following check helps in two conditions.
> > +		 * - If there are requests dispatched from the queue and
> > +		 *   select_ioq() comes before a request completed from the
> > +		 *   queue and got a chance to arm any of the idle timers.
> > +		 *
> > +		 * - If at request completion time slice had not expired and
> > +		 *   we armed either a ioq timer or group timer but when
> > +		 *   select_ioq() hits, slice has expired and it will expire
> > +		 *   the queue without doing busy wait on group.
> > +		 *
> > +		 * In similar situations cfq lets delte the queue even if
> > +		 * idle timer is armed. That does not impact fairness in non
> > +		 * hierarhical setup due to weighted slice lengths. But in
> > +		 * hierarchical setup where group slice lengths are derived
> > +		 * from queue and is not proportional to group's weight, it
> > +		 * harms the fairness of the group.
> > +		 */
> > +		if (elv_iog_should_idle(ioq) && !elv_iog_wait_busy_done(iog)) {
> 
> Hi Vivek,
> 
> Here is another bug which will cause task hanging when accessing into a certain disk.
> For the moment, last ioq(corresponding CGroup has been removed) is optimized not to 
> expire unitl another ioq get backlogged. Here just checking "iog_wait_busy_done" flag
> is not sufficient, because idle timer can be inactive at that moment. This will cause
> the ioq keeping service all the time and won't stop, causing the whole system hanging. 
> This patch adds extra check for "iog_wait_busy" to make sure that the idle timer is 
> pending, and this ioq will be expired after timer is up.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Good point. I think keeping the signle queue around with-in child group is
getting complicated.

For the time being I will continue to expire the single ioq of child group
even if other competing queues are not present. (Bring back the check of
efqd->root_group->ioq).

Once rest of the things stablize, we can revisit this optimzation later
that don't expire the single queue in child groups also.

Thanks
Vivek

> ---
>  block/elevator-fq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 40d0eb5..c039ba2 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -3364,7 +3364,8 @@ void *elv_select_ioq(struct request_queue *q, int force)
>  		 * harms the fairness of the group.
>  		 */
>  		slice_expired = 1;
> -		if (elv_iog_should_idle(ioq) && !elv_iog_wait_busy_done(iog)) {
> +		if (elv_iog_should_idle(ioq) && !elv_iog_wait_busy_done(iog) &&
> +		    elv_iog_wait_busy(iog)) {
>  			ioq = NULL;
>  			goto keep_queue;
>  		} else
> -- 
> 1.5.4.rc3
> 
> 
> 
