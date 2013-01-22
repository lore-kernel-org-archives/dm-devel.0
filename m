From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 7/8] [persistent-data] transactional bitset
Date: Tue, 22 Jan 2013 21:59:20 +0000
Message-ID: <20130122215920.GC30267@agk-dp.fab.redhat.com>
References: <1355429956-22785-1-git-send-email-ejt@redhat.com>
	<1355429956-22785-8-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1355429956-22785-8-git-send-email-ejt@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Please add more comments to the functions in dm-bitset.h to confirm
what they do and how to use them.  (I've not repeated comments about
dm-array.h that apply here too.)

On Thu, Dec 13, 2012 at 08:19:15PM +0000, Joe Thornber wrote:
> --- /dev/null
> +++ b/drivers/md/persistent-data/dm-bitset.h
> +struct dm_bitset_info {
> +	struct dm_array_info array_info;
> +
> +	uint32_t current_index;
> +	uint64_t current_bits;

Put the uint64_t before the uint32_t perhaps?  (Better packing?)

> +
> +	bool current_index_set:1;
> +};
> +
> +void dm_bitset_info_init(struct dm_transaction_manager *tm,
> +			 struct dm_bitset_info *info);

Does this function populate info->array_info and track the array
size so the caller doesn't need to do it in the way described in
dm-array.h?

> +int dm_bitset_empty(struct dm_bitset_info *info, dm_block_t *root);
> +
> +int dm_bitset_resize(struct dm_bitset_info *info, dm_block_t root,
> +		     uint32_t old_nr_entries, uint32_t new_nr_entries,
> +		     bool default_value, dm_block_t *new_root);
> +

But does the caller need to track old/new nr_entries?

> +
> +/*
> + * May flush and thus update the root.
> + */
> +int dm_bitset_set_bit(struct dm_bitset_info *info, dm_block_t root,
> +		      uint32_t index, dm_block_t *new_root);

What are the constraints on index?
Can index be too big and require a resize first?  If so, what
error is returned?

> +int dm_bitset_clear_bit(struct dm_bitset_info *info, dm_block_t root,
> +			uint32_t index, dm_block_t *new_root);

Error if out of defined range?

> +int dm_bitset_test_bit(struct dm_bitset_info *info, dm_block_t root,
> +		       uint32_t index, dm_block_t *new_root, bool *result);
> +

Error if out of defined range?

> +/*
> + * You must call this to flush recent changes to disk.
> + */
> +int dm_bitset_flush(struct dm_bitset_info *info, dm_block_t root,
> +		    dm_block_t *new_root);

If there's a disk error, does flush fail and then could it be retried?
Or does the bitset become unusable or read-only after a disk error?

> +
> +/*----------------------------------------------------------------*/
> +
> +#endif

Conventionally, add /* _LINUX_DM_BITSET_H */ after the #endif.
(Helps when reading files with nested includes.)
- dm-array.h similarly.

Alasdair
