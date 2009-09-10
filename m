From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 07/23] io-controller: Common hierarchical
	fair queuing code in elevaotor layer
Date: Thu, 10 Sep 2009 16:11:48 -0400
Message-ID: <20090910201148.GA3617@redhat.com>
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com>
	<1251495072-7780-8-git-send-email-vgoyal@redhat.com>
	<4A9F3319.8040509@ds.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A9F3319.8040509@ds.jp.nec.com>
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
Cc: dhaval@linux.vnet.ibm.com, peterz@infradead.org, dm-devel@redhat.com, dpshah@google.com, jens.axboe@oracle.com, agk@redhat.com, balbir@linux.vnet.ibm.com, paolo.valente@unimore.it, jmarchan@redhat.com, guijianfeng@cn.fujitsu.com, fernando@oss.ntt.co.jp, mikew@google.com, jmoyer@redhat.com, nauman@google.com, mingo@elte.hu, righi.andrea@gmail.com, riel@redhat.com, lizf@cn.fujitsu.com, fchecconi@gmail.com, s-uchida@ap.jp.nec.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, torvalds@linux-foundation.org
List-Id: dm-devel.ids

On Wed, Sep 02, 2009 at 11:08:09PM -0400, Munehiro Ikeda wrote:
> Hi,
> 
> Vivek Goyal wrote, on 08/28/2009 05:30 PM:
> > +static struct io_group *io_find_alloc_group(struct request_queue *q,
> > +			struct cgroup *cgroup, struct elv_fq_data *efqd,
> > +			int create)
> > +{
> > +	struct io_cgroup *iocg = cgroup_to_io_cgroup(cgroup);
> > +	struct io_group *iog = NULL;
> > +	/* Note: Use efqd as key */
> > +	void *key = efqd;
> > +
> > +	/*
> > +	 * Take a refenrece to css object. Don't want to map a bio to
> > +	 * a group if it has been marked for deletion
> > +	 */
> > +
> > +	if (!css_tryget(&iocg->css))
> > +		return iog;
> 
> cgroup_to_io_cgroup() returns NULL if only blkio subsystem
> is mounted but io subsystem is not.  It can cause NULL pointer
> access.
> 

Good catch Muuhh.  Thanks. Applied for next release.

Thanks
Vivek

> Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
> ---
>  block/elevator-fq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index b723c12..6714e73 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1827,7 +1827,7 @@ static struct io_group *io_find_alloc_group(struct request_queue *q,
>          * a group if it has been marked for deletion
>          */
>  
> -       if (!css_tryget(&iocg->css))
> +       if (!iocg || !css_tryget(&iocg->css))
>                 return iog;
>  
>         iog = io_cgroup_lookup_group(iocg, key);
> -- 
> 1.6.2.5
> 
> 
> -- 
> IKEDA, Munehiro
>   NEC Corporation of America
>     m-ikeda@ds.jp.nec.com
