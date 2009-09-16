From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] io-controller: Fix task hanging when there
	are more than one groups
Date: Wed, 16 Sep 2009 14:09:15 -0400
Message-ID: <20090916180915.GE5221@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<4AA4B905.8010801@cn.fujitsu.com>
	<20090908191941.GF15974@redhat.com>
	<4AA75B71.5060109@cn.fujitsu.com>
	<20090909150537.GD8256@redhat.com> <4AA9A4BE.30005@cn.fujitsu.com>
	<20090915033739.GA4054@redhat.com>
	<4AB05442.6080004@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4AB05442.6080004@cn.fujitsu.com>
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

On Wed, Sep 16, 2009 at 10:58:10AM +0800, Gui Jianfeng wrote:

[..]
> > o Fixed the issue of not expiring the queue for single ioq schedulers. Reported
> >   and fixed by Gui.
> > 
> > o If an AS queue is not expired for a long time and suddenly somebody
> >   decides to create a group and launch a job there, in that case old AS
> >   queue will be expired with a very high value of slice used and will get
> >   a very high disk time. Fix it by marking the queue as "charge_one_slice"
> >   and charge the queue only for a single time slice and not for whole
> >   of the duration when queue was running.
> > 
> > o There are cases where in case of AS, excessive queue expiration will take
> >   place by elevator fair queuing layer because of few reasons.
> > 	- AS does not anticipate on a queue if there are no competing requests.
> > 	  So if only a single reader is present in a group, anticipation does
> > 	  not get turn on.
> > 
> > 	- elevator layer does not know that As is anticipating hence initiates
> > 	  expiry requests in select_ioq() thinking queue is empty.
> > 
> > 	- elevaotr layer tries to aggressively expire last empty queue. This
> > 	  can lead to lof of queue expiry
> > 
> > o This patch now starts ANITC_WAIT_NEXT anticipation if last request in the
> >   queue completed and associated io context is eligible to anticipate. Also
> >   AS lets elevatory layer know that it is anticipating (elv_ioq_wait_request())
> >   . This solves above mentioned issues.
> >  
> > o Moved some of the code in separate functions to improve readability.
> > 
> ...
> 
> >  /* A request got completed from io_queue. Do the accounting. */
> >  void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
> >  {
> > @@ -3470,16 +3572,16 @@ void elv_ioq_completed_request(struct re
> >  			elv_set_prio_slice(q->elevator->efqd, ioq);
> >  			elv_clear_ioq_slice_new(ioq);
> >  		}
> > +
> >  		/*
> >  		 * If there is only root group present, don't expire the queue
> >  		 * for single queue ioschedulers (noop, deadline, AS). It is
> >  		 * unnecessary overhead.
> >  		 */
> >  
> > -		if (is_only_root_group() &&
> > -			elv_iosched_single_ioq(q->elevator)) {
> > -			elv_log_ioq(efqd, ioq, "select: only root group,"
> > -					" no expiry");
> > +		if (single_ioq_no_timed_expiry(q)) {
> 
>   Hi Vivek,
> 
>   So we make use of single_ioq_no_timed_expiry() to decide whether there is only
>   root ioq to be busy, right? But single_ioq_no_timed_expiry() only checks if
>   the root cgroup is the only group and if there is only one busy_ioq there. As
>   I explained in previous mail, these two checks are not sufficient to say the
>   current active ioq comes from root group. Because when the child cgroup is just
>   removed, and the ioq which belongs to child group is still there(maybe some
>   requests are in flight). In this case, only root cgroup and only one active ioq
>   (child ioq) checks are satisfied. So IMHO, in single_ioq_no_timed_expiry() we 
>   still need to check "efqd->root_group->ioq" is already created to ensure the only
>   ioq comes from root group. Am i missing something?
> 

Hi Gui,

The only side effect of not checking for "efqd->root_group->ioq" seems to
be that this ioq hence io group of the child will not be freed immediately
and release will be delayed until a some other queue in the system gets
backlogged or ioscheduler exits. At that point of time, this child queue will
be expired and ioq and iog will be freed.

The advantage is that if there is IO happening only in child group in that
case we can avoid expiring that queue.

So may be keeping the queue around for sometime is not a very idea. 

Am I missing something?

Thanks
Vivek
