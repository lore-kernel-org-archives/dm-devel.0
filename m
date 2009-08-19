From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 03/24] io-controller: Common flat fair
	queuing code in elevaotor layer
Date: Wed, 19 Aug 2009 14:39:42 -0400
Message-ID: <20090819183942.GC4391@redhat.com>
References: <1250451046-9966-1-git-send-email-vgoyal@redhat.com>
	<1250451046-9966-4-git-send-email-vgoyal@redhat.com>
	<4A8B7336.7010800@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A8B7336.7010800@cn.fujitsu.com>
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

On Wed, Aug 19, 2009 at 11:36:22AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> 
> > +
> > +static void elv_preempt_queue(struct request_queue *q, struct io_queue *ioq)
> > +{
> > +	elv_log_ioq(q->elevator->efqd, ioq, "preempt");
> > +	elv_slice_expired(q);
> > +
> > +	/*
> > +	 * Put the new queue at the front of the of the current list,
> > +	 * so we know that it will be selected next.
> > +	 */
> > +
> > +	requeue_ioq(ioq);
> > +	ioq->slice_start = ioq->slice_end = 0;
> 
> I think this assignment is redundant because these two members will be reset
> when this ioq is scheduled.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

thanks Gui. Queued for next posting.

Vivek

> ---
>  block/elevator-fq.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index d04e925..b3c387d 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2650,7 +2650,6 @@ static void elv_preempt_queue(struct request_queue *q, struct io_queue *ioq)
>  		 */
>  
>  		requeue_ioq(ioq);
> -		ioq->slice_start = ioq->slice_end = 0;
>  		elv_mark_ioq_slice_new(ioq);
>  	}
>  }
> -- 
> 1.5.4.rc3
> 
> 
