From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/19] io-controller: Modify cfq to make use
	of flat elevator fair queuing
Date: Mon, 15 Jun 2009 09:02:25 -0400
Message-ID: <20090615130225.GB5717@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-5-git-send-email-vgoyal@redhat.com>
	<4A360CD2.8060707@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A360CD2.8060707@cn.fujitsu.com>
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

On Mon, Jun 15, 2009 at 04:56:50PM +0800, Gui Jianfeng wrote:
> > -static inline int
> > -cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
> > +static inline int cfq_class_rt(struct cfq_queue *cfqq)
> >  {
> > -	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
> > +	return elv_ioq_class_rt(cfqq->ioq);
> >  }
> 
> Hi Vivek,
> 
> cfq_class_rt isn't needed now, clean it up.
> 

Thanks Gui. Queued up for next posting.

Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/cfq-iosched.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 705e7ba..23b24b9 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -234,11 +234,6 @@ static inline int cfq_class_idle(struct cfq_queue *cfqq)
>  	return elv_ioq_class_idle(cfqq->ioq);
>  }
>  
> -static inline int cfq_class_rt(struct cfq_queue *cfqq)
> -{
> -	return elv_ioq_class_rt(cfqq->ioq);
> -}
> -
>  static inline int cfq_cfqq_sync(struct cfq_queue *cfqq)
>  {
>  	return elv_ioq_sync(cfqq->ioq);
> -- 
> 1.5.4.rc3
> 
