From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 22/25] io-controller: Per io group bdi
	congestion interface
Date: Fri, 17 Jul 2009 09:52:46 -0400
Message-ID: <20090717135246.GA16839@redhat.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	<1246564917-19603-23-git-send-email-vgoyal@redhat.com>
	<4A5FC2CA.1040609@ds.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A5FC2CA.1040609@ds.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
Cc: dhaval@linux.vnet.ibm.com, snitzer@redhat.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, righi.andrea@gmail.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, akpm@linux-foundation.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, s-uchida@ap.jp.nec.com, jbaron@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 16, 2009 at 08:16:10PM -0400, Munehiro Ikeda wrote:
> Hi,
> 
> Vivek Goyal wrote, on 07/02/2009 04:01 PM:
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 2035c20..79fe6a9 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -90,6 +90,27 @@ void blk_queue_congestion_threshold(struct request_queue *q)
> >   	q->nr_congestion_off = nr;
> >   }
> > 
> > +#ifdef CONFIG_GROUP_IOSCHED
> > +int blk_queue_io_group_congested(struct backing_dev_info *bdi, int bdi_bits,
> > +					struct page *page)
> > +{
> > +	int ret = 0;
> > +	struct request_queue *q = bdi->unplug_io_data;
> > +
> > +	if (!q&&  !q->elevator)
> > +		return bdi_congested(bdi, bdi_bits);
> 
> It causes NULL pointer dereference for brd etc.
> 
> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
> ---
>  block/blk-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 79fe6a9..39fab66 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -97,7 +97,7 @@ int blk_queue_io_group_congested(struct backing_dev_info *bdi, int bdi_bits,
>  	int ret = 0;
>  	struct request_queue *q = bdi->unplug_io_data;
>  
> -	if (!q && !q->elevator)
> +	if (!q || !q->elevator)
>  		return bdi_congested(bdi, bdi_bits);
>  

Hi,

Thanks for the patch. I also noticed this recently and fixed it for next
to be posted version.

Thanks
Vivek

>  	/* Do we need to hold queue lock? */
> -- 
> 1.6.2.5
> 
> 
> -- 
> IKEDA, Munehiro
>   NEC Corporation of America
>     m-ikeda@ds.jp.nec.com
