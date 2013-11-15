From: Joe Thornber <thornber@redhat.com>
Subject: Re: [dm-devel] [PATCH -next] dm cache policy mq:: use list_del_init
 instead of list_del/INIT_LIST_HEAD
Date: Fri, 15 Nov 2013 10:58:23 +0000
Message-ID: <20131115105822.GA18770@debian>
References: <CAPgLHd_iO2aHnn-uBp=1OYafVonrSfXnEcW7Mz=vp3btkkygPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPgLHd_iO2aHnn-uBp=1OYafVonrSfXnEcW7Mz=vp3btkkygPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: agk@redhat.com, snitzer@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org, yongjun_wei@trendmicro.com.cn
List-Id: dm-devel.ids

ACK

On Fri, Nov 15, 2013 at 05:47:12PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using list_del_init() instead of list_del() + INIT_LIST_HEAD().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/md/dm-cache-policy-mq.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
> index 7209fab..ac7d3b3 100644
> --- a/drivers/md/dm-cache-policy-mq.c
> +++ b/drivers/md/dm-cache-policy-mq.c
> @@ -287,9 +287,8 @@ static struct entry *alloc_entry(struct entry_pool *ep)
>  static struct entry *alloc_particular_entry(struct entry_pool *ep, dm_cblock_t cblock)
>  {
>  	struct entry *e = ep->entries + from_cblock(cblock);
> -	list_del(&e->list);
>  
> -	INIT_LIST_HEAD(&e->list);
> +	list_del_init(&e->list);
>  	INIT_HLIST_NODE(&e->hlist);
>  	ep->nr_allocated++;
>  
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
