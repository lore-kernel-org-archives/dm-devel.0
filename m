From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH] dm btree: increase rebalance threshold in
	__rebalance2()
Date: Tue, 3 Dec 2019 12:52:48 +0000
Message-ID: <20191203125248.5doseun32vmc3mrp@reti>
References: <20191203114258.8912-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191203114258.8912-1-houtao1@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Hou Tao <houtao1@huawei.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Ack.  Thank you.

On Tue, Dec 03, 2019 at 07:42:58PM +0800, Hou Tao wrote:
> We got the following warnings from thin_check during thin-pool setup:
> 
>   $ thin_check /dev/vdb
>   examining superblock
>   examining devices tree
>     missing devices: [1, 84]
>       too few entries in btree_node: 41, expected at least 42 (block 138, max_entries = 126)
>   examining mapping tree
> 
> The phenomenon is the number of entries in one node of details_info tree is
> less than (max_entries / 3). And it can be easily reproduced by the following
> procedures:
> 
>   $ new a thin pool
>   $ presume the max entries of details_info tree is 126
>   $ new 127 thin devices (e.g. 1~127) to make the root node being full
>     and then split
>   $ remove the first 43 (e.g. 1~43) thin devices to make the children
>     reblance repeatedly
>   $ stop the thin pool
>   $ thin_check
> 
> The root cause is that the B-tree removal procedure in __rebalance2()
> doesn't guarantee the invariance: the minimal number of entries in
> non-root node should be >= (max_entries / 3).
> 
> Simply fix the problem by increasing the rebalance threshold to
> make sure the number of entries in each child will be greater
> than or equal to (max_entries / 3 + 1), so no matter which
> child is used for removal, the number will still be valid.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  drivers/md/persistent-data/dm-btree-remove.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
> index 21ea537bd55e..eff04fa23dfa 100644
> --- a/drivers/md/persistent-data/dm-btree-remove.c
> +++ b/drivers/md/persistent-data/dm-btree-remove.c
> @@ -203,7 +203,13 @@ static void __rebalance2(struct dm_btree_info *info, struct btree_node *parent,
>  	struct btree_node *right = r->n;
>  	uint32_t nr_left = le32_to_cpu(left->header.nr_entries);
>  	uint32_t nr_right = le32_to_cpu(right->header.nr_entries);
> -	unsigned threshold = 2 * merge_threshold(left) + 1;
> +	/*
> +	 * Ensure the number of entries in each child will be greater
> +	 * than or equal to (max_entries / 3 + 1), so no matter which
> +	 * child is used for removal, the number will still be not
> +	 * less than (max_entries / 3).
> +	 */
> +	unsigned int threshold = 2 * (merge_threshold(left) + 1);
>  
>  	if (nr_left + nr_right < threshold) {
>  		/*
> -- 
> 2.22.0
> 
