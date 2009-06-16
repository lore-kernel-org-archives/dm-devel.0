From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/19] io-controller: Common flat fair
	queuing code in elevaotor layer
Date: Tue, 16 Jun 2009 09:02:27 -0400
Message-ID: <20090616130227.GA10730@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-3-git-send-email-vgoyal@redhat.com>
	<4A37175C.80906@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A37175C.80906@cn.fujitsu.com>
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

On Tue, Jun 16, 2009 at 11:54:04AM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +int elv_nr_busy_rt_ioq(struct elevator_queue *e)
> > +{
> > +	return e->efqd.busy_rt_queues;
> > +}
> > +EXPORT_SYMBOL(elv_nr_busy_rt_ioq);
> 
> This function is no need now.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>

Thanks Gui. Queued for next posting.

Thanks
Vivek

> ---
>  block/elevator-fq.c |    6 ------
>  block/elevator-fq.h |    1 -
>  2 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index f33155c..912ac6a 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2553,12 +2553,6 @@ int elv_nr_busy_ioq(struct elevator_queue *e)
>  }
>  EXPORT_SYMBOL(elv_nr_busy_ioq);
>  
> -int elv_nr_busy_rt_ioq(struct elevator_queue *e)
> -{
> -	return e->efqd.busy_rt_queues;
> -}
> -EXPORT_SYMBOL(elv_nr_busy_rt_ioq);
> -
>  int elv_hw_tag(struct elevator_queue *e)
>  {
>  	return e->efqd.hw_tag;
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 0939735..285a1ff 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -711,7 +711,6 @@ extern void io_group_set_async_queue(struct io_group *iog, int ioprio_class,
>  extern struct io_group *io_get_io_group(struct request_queue *q,
>  					struct bio *bio, int create);
>  extern int elv_nr_busy_ioq(struct elevator_queue *e);
> -extern int elv_nr_busy_rt_ioq(struct elevator_queue *e);
>  extern struct io_queue *elv_alloc_ioq(struct request_queue *q, gfp_t gfp_mask);
>  extern void elv_free_ioq(struct io_queue *ioq);
>  
> -- 
> 1.5.4.rc3
> 
