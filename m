From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/18] io-controller: Common flat fair queuing code in
	elevaotor layer
Date: Fri, 22 May 2009 08:32:31 -0400
Message-ID: <20090522123231.GA14972@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-3-git-send-email-vgoyal@redhat.com> <4A164978.1020604@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757433AbZEVMfX@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A164978.1020604@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com, m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Fri, May 22, 2009 at 02:43:04PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +/* A request got completed from io_queue. Do the accounting. */
> > +void elv_ioq_completed_request(struct request_queue *q, struct request *rq)
> > +{
> > +	const int sync = rq_is_sync(rq);
> > +	struct io_queue *ioq = rq->ioq;
> > +	struct elv_fq_data *efqd = &q->elevator->efqd;
> > +
> > +	if (!elv_iosched_fair_queuing_enabled(q->elevator))
> > +		return;
> > +
> > +	elv_log_ioq(efqd, ioq, "complete");
> > +
> > +	elv_update_hw_tag(efqd);
> > +
> > +	WARN_ON(!efqd->rq_in_driver);
> > +	WARN_ON(!ioq->dispatched);
> > +	efqd->rq_in_driver--;
> > +	ioq->dispatched--;
> > +
> > +	if (sync)
> > +		ioq->last_end_request = jiffies;
> > +
> > +	/*
> > +	 * If this is the active queue, check if it needs to be expired,
> > +	 * or if we want to idle in case it has no pending requests.
> > +	 */
> > +
> > +	if (elv_active_ioq(q->elevator) == ioq) {
> > +		if (elv_ioq_slice_new(ioq)) {
> > +			elv_ioq_set_prio_slice(q, ioq);
> 
>   Hi Vivek,
> 
>   Would you explain a bit why slice_end should be set when first request completes.
>   Why not set it just when an ioq gets active?
>   

Hi Gui,

I have kept the behavior same as CFQ. I guess reason behind this is that
when a new queue is scheduled in, first request completion might take more
time as head of the disk might be quite a distance away (due to previous
queue) and one probably does not want to charge the new queue for that
first seek time. That's the reason we start the queue slice when first
request has completed.

Thanks
Vivek
