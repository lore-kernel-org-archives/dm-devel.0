From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] IO-Controller: clear ioq wait flag if a
	request goes into that ioq
Date: Thu, 20 Aug 2009 09:42:21 -0400
Message-ID: <20090820134221.GC10615@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-12-git-send-email-vgoyal@redhat.com>
	<4A8CAAE2.1030804@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A8CAAE2.1030804@cn.fujitsu.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, m-ikeda@ds.jp.nec.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, righi.andrea@gmail.com
List-Id: dm-devel.ids

On Thu, Aug 20, 2009 at 09:46:10AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  		/*
> >  		 * Remember that we saw a request from this process, but
> > @@ -1940,7 +2013,7 @@ void elv_ioq_request_add(struct request_queue *q, struct request *rq)
> >  		 * has other work pending, don't risk delaying until the
> >  		 * idle timer unplug to continue working.
> >  		 */
> > -		if (elv_ioq_wait_request(ioq)) {
> > +		if (group_wait || elv_ioq_wait_request(ioq)) {
> 
> Hi Vivek,
> 
> I guess we need to clear ioq_wait_request flags if there are requests to 
> go in this ioq. Otherwise, once waitting request on ioq, it will go into
> this path every time when a request is enqueued.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Hi Gui,

It does sound like that we need to clear ioq wait_request flag here. In
fact upstream CFQ code is also not clearing this flag. Looking at the
code, can't think why it should not be cleared here.

Can you please also generate a patch for CFQ and post to lkml.

Thanks
Vivek
 
> ---
>  block/elevator-fq.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index b3c387d..201543e 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2708,6 +2708,9 @@ void elv_ioq_request_add(struct request_queue *q, struct request *rq)
>  				__blk_run_queue(q);
>  			else
>  				elv_mark_ioq_must_dispatch(ioq);
> +
> +			if (elv_ioq_wait_request(ioq))
> +				elv_clear_ioq_wait_request(ioq);
>  		}
>  	} else if (elv_should_preempt(q, ioq, rq)) {
>  		/*
> -- 
> 1.5.4.rc3
