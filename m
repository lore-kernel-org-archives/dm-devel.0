From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 02/20] io-controller: Common flat fair
	queuing code in elevaotor layer
Date: Mon, 8 Jun 2009 09:56:52 -0400
Message-ID: <20090608135652.GE3652@redhat.com>
References: <1243377729-2176-1-git-send-email-vgoyal@redhat.com>
	<1243377729-2176-3-git-send-email-vgoyal@redhat.com>
	<4A2CC15F.2010708@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A2CC15F.2010708@cn.fujitsu.com>
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

On Mon, Jun 08, 2009 at 03:44:31PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> > +
> > +static inline pid_t elv_ioq_pid(struct io_queue *ioq)
> > +{
> > +	return ioq->pid;
> > +}
> > +
> > +static inline unsigned long elv_ioq_ttime_mean(struct io_queue *ioq)
> > +{
> > +	return ioq->ttime_mean;
> > +}
> > +
> > +static inline unsigned long elv_ioq_sample_valid(struct io_queue *ioq)
> > +{
> > +	return ioq_sample_valid(ioq->ttime_samples);
> > +}
> > +
> 
> These three functions are dead now, just remove them.
> 

Thanks Gui. queued up for next posting.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.h |   15 ---------------
>  1 files changed, 0 insertions(+), 15 deletions(-)
> 
> diff --git a/block/elevator-fq.h b/block/elevator-fq.h
> index 24a3af9..b2bb11a 100644
> --- a/block/elevator-fq.h
> +++ b/block/elevator-fq.h
> @@ -452,21 +452,6 @@ static inline int elv_ioq_nr_queued(struct io_queue *ioq)
>  	return ioq->nr_queued;
>  }
>  
> -static inline pid_t elv_ioq_pid(struct io_queue *ioq)
> -{
> -	return ioq->pid;
> -}
> -
> -static inline unsigned long elv_ioq_ttime_mean(struct io_queue *ioq)
> -{
> -	return ioq->ttime_mean;
> -}
> -
> -static inline unsigned long elv_ioq_sample_valid(struct io_queue *ioq)
> -{
> -	return ioq_sample_valid(ioq->ttime_samples);
> -}
> -
>  static inline void elv_get_ioq(struct io_queue *ioq)
>  {
>  	atomic_inc(&ioq->ref);
> -- 
> 1.5.4.rc3
