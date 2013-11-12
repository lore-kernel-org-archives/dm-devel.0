From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 5/6] dm cache: add remove_cblock method
	to	policy interface
Date: Tue, 12 Nov 2013 00:18:52 +0000
Message-ID: <20131112001851.GI24324@agk-dp.fab.redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
	<1384190448-3861-6-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1384190448-3861-6-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 11, 2013 at 12:20:47PM -0500, Mike Snitzer wrote:
> From: Joe Thornber <ejt@redhat.com>
 
> +static struct entry *epool_find(struct entry_pool *ep, dm_cblock_t cblock)
> +{
> +	struct entry *e = ep->entries + from_cblock(cblock);
> +	return e->hlist.pprev ? e : NULL;

Please use hlist_unhashed() rather than accessing pprev explicitly where possible.

static inline int hlist_unhashed(const struct hlist_node *h)
{
        return !h->pprev;
}

> +++ b/drivers/md/dm-cache-policy.h
> @@ -135,9 +135,6 @@ struct dm_cache_policy {
>  	 */
>  	int (*lookup)(struct dm_cache_policy *p, dm_oblock_t oblock, dm_cblock_t *cblock);
>  
> -	/*
> -	 * oblock must be a mapped block.  Must not block.
> -	 */
>  	void (*set_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
>  	void (*clear_dirty)(struct dm_cache_policy *p, dm_oblock_t oblock);
  
So a policy can no longer assume oblock is a mapped block, and these functions
may block?

Is this consistent with 
          BUG_ON(!e || !in_cache(mq, e));
in __mq_set_clear_dirty?

Alasdair
