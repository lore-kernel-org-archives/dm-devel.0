From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-writecache: avoid unnecessary lookups in
 writecache_find_entry
Date: Tue, 23 Apr 2019 11:44:28 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1904231140240.17390@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190420162102.6460-1-yehs2007@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190420162102.6460-1-yehs2007@zoho.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Huaisheng Ye <yehs2007@zoho.com>
Cc: prarit@redhat.com, Huaisheng Ye <yehs1@lenovo.com>, snitzer@redhat.com, chengnt@lenovo.com, linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids



On Sun, 21 Apr 2019, Huaisheng Ye wrote:

> From: Huaisheng Ye <yehs1@lenovo.com>
> 
> Only when entry has been found, that would only be necessary to check the
> lowest or highest seq-count.
> 
> Add local variable "found" in writecache_find_entry, if no entry has been
> found, it is meaningless that having a useless rb_prev or rb_next.


Hi

I don't quite see what is this patch trying to fix.
Don't fix something that isn't broken.

Mikulas


> Signed-off-by: Huaisheng Ye <yehs1@lenovo.com>
> ---
>  drivers/md/dm-writecache.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index ddf1732..047ae09 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -537,14 +537,18 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
>  {
>  	struct wc_entry *e;
>  	struct rb_node *node = wc->tree.rb_node;
> +	bool found = false;
>  
>  	if (unlikely(!node))
>  		return NULL;
>  
>  	while (1) {
>  		e = container_of(node, struct wc_entry, rb_node);
> -		if (read_original_sector(wc, e) == block)
> +		if (read_original_sector(wc, e) == block) {
> +			found = true;
>  			break;
> +		}
> +
>  		node = (read_original_sector(wc, e) >= block ?
>  			e->rb_node.rb_left : e->rb_node.rb_right);
>  		if (unlikely(!node)) {
> @@ -564,7 +568,8 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
>  		}
>  	}
>  
> -	while (1) {
> +	/* only need to check lowest or highest seq-count when entry has been found */
> +	while (found) {
>  		struct wc_entry *e2;
>  		if (flags & WFE_LOWEST_SEQ)
>  			node = rb_prev(&e->rb_node);
> @@ -577,6 +582,9 @@ static struct wc_entry *writecache_find_entry(struct dm_writecache *wc,
>  			return e;
>  		e = e2;
>  	}
> +
> +	/* no entry has been found, return the following entry */
> +	return e;
>  }
>  
>  static void writecache_insert_entry(struct dm_writecache *wc, struct wc_entry *ins)
> -- 
> 1.8.3.1
> 
> 
