From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 10/20] io-conroller: Prepare elevator layer
	for single queue schedulers
Date: Fri, 5 Jun 2009 09:22:11 -0400
Message-ID: <20090605132211.GC3491@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-11-git-send-email-vgoyal@redhat.com>
	<4A28E293.90402@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A28E293.90402@cn.fujitsu.com>
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

On Fri, Jun 05, 2009 at 05:17:07PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> > +				e->ops->elevator_free_sched_queue_fn(e,
> > +							sched_q);
> > +				sched_q = NULL;
> > +				goto queue_fail;
> > +			}
> > +		}
> > +
> > +		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE, 4, 1);
> 
> It's better to use IOPRIO_NORM here.
> 

Sure. Queued up for next posting.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index f1179aa..3c5f9da 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -2403,7 +2403,8 @@ alloc_ioq:
>  			}
>  		}
>  
> -		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE, 4, 1);
> +		elv_init_ioq(e, ioq, iog, sched_q, IOPRIO_CLASS_BE,
> +			     IOPRIO_NORM, 1);
>  		io_group_set_ioq(iog, ioq);
>  		elv_mark_ioq_sync(ioq);
>  		elv_get_iog(iog);
> -- 
> 1.5.4.rc3
