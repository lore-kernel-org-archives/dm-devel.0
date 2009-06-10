From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 17/19] io-controller: Support per cgroup per
	device weights and io class
Date: Wed, 10 Jun 2009 09:22:00 -0400
Message-ID: <20090610132159.GA19680@redhat.com>
References: <1244513342-11758-1-git-send-email-vgoyal@redhat.com>
	<1244513342-11758-18-git-send-email-vgoyal@redhat.com>
	<4A2F646A.8070403@cn.fujitsu.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <4A2F646A.8070403@cn.fujitsu.com>
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

On Wed, Jun 10, 2009 at 03:44:42PM +0800, Gui Jianfeng wrote:
> Vivek Goyal wrote:
> ...
> >  
> > @@ -1233,6 +1254,8 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
> >  		elv_get_iog(iog);
> >  
> >  		iog->iocg_id = css_id(&iocg->css);
> > +		io_group_init_entity(iocg, iog, iog->dev);
> 
> Hi Vivek,
> 
> A regression occurs in io.policy handling. IO Controller completely stops working when i use 
> this interface. 
> Make sure that we initialize entity after iog->dev is setting up properly.
> 

Thanks Gui. Will do in next posting.

Thanks
Vivek

> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  block/elevator-fq.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
> index 6b30c36..a516dce 100644
> --- a/block/elevator-fq.c
> +++ b/block/elevator-fq.c
> @@ -1451,7 +1451,6 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
>  		elv_get_iog(iog);
>  
>  		iog->iocg_id = css_id(&iocg->css);
> -		io_group_init_entity(iocg, iog, iog->dev);
>  		iog->my_entity = &iog->entity;
>  
>  		if (bio) {
> @@ -1459,6 +1458,8 @@ struct io_group *io_group_chain_alloc(struct request_queue *q, void *key,
>  			iog->dev = MKDEV(disk->major, disk->first_minor);
>  		}
>  
> +		io_group_init_entity(iocg, iog, iog->dev);
> +
>  		blk_init_request_list(&iog->rl);
>  #ifdef CONFIG_DEBUG_GROUP_IOSCHED
>  		io_group_path(iog, iog->path, sizeof(iog->path));
> -- 
> 1.5.4.rc3
