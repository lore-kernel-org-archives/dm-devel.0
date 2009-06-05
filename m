From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 05/20] io-controller: Common hierarchical
	fair queuing code in elevaotor layer
Date: Fri, 5 Jun 2009 09:21:44 -0400
Message-ID: <20090605132144.GB3491@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-6-git-send-email-vgoyal@redhat.com>
	<4A28E710.5080307@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A28E710.5080307@cn.fujitsu.com>
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

On Fri, Jun 05, 2009 at 05:36:16PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +#ifdef CONFIG_GROUP_IOSCHED
> > +extern int io_group_allow_merge(struct request *rq, struct bio *bio);
> > +extern void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,
> 
> io_ioq_move is not used anymore, removing the dead code.
> 

Thanks Gui. Will include the patch in next posting.

Vivek

> Singed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.h |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 1c99e83..24a3af9 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -537,8 +537,6 @@ static inline struct io_group *ioq_to_io_group(struct io_queue *ioq)
>  
>  #ifdef CONFIG_GROUP_IOSCHED
>  extern int io_group_allow_merge(struct request *rq, struct bio *bio);
> -extern void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,
> -					struct io_group *iog);
>  static inline bfq_weight_t iog_weight(struct io_group *iog)
>  {
>  	return iog->entity.weight;
> @@ -588,15 +586,6 @@ static inline int update_requeue(struct io_queue *ioq, int requeue)
>  }
>  
>  #else /* !GROUP_IOSCHED */
> -/*
> - * No ioq movement is needed in case of flat setup. root io group gets cleaned
> - * up upon elevator exit and before that it has been made sure that both
> - * active and idle tree are empty.
> - */
> -static inline void io_ioq_move(struct elevator_queue *e, struct io_queue *ioq,
> -					struct io_group *iog)
> -{
> -}
>  
>  static inline int io_group_allow_merge(struct request *rq, struct bio *bio)
>  {
> -- 
> 1.5.4.rc3
> 
