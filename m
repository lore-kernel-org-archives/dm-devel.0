From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm cache metadata: Fix loading discard bitset
Date: Wed, 17 Apr 2019 10:35:43 -0400
Message-ID: <20190417143542.GA28069@redhat.com>
References: <20190417141918.10648-1-ntsironis@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190417141918.10648-1-ntsironis@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, Apr 17 2019 at 10:19am -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Add missing dm_bitset_cursor_next() to properly advance the bitset
> cursor.
> 
> Otherwise, the discarded state of all blocks is set according to the
> discarded state of the first block.
> 
> Fixes: ae4a46a1f6 ("dm cache metadata: use bitset cursor api to load discard bitset")
> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>

Nice catch, I'll obviously mark this for stable@ too.

One comment below.

> ---
>  drivers/md/dm-cache-metadata.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
> index 6fc93834da44..151aa95775be 100644
> --- a/drivers/md/dm-cache-metadata.c
> +++ b/drivers/md/dm-cache-metadata.c
> @@ -1167,11 +1167,18 @@ static int __load_discards(struct dm_cache_metadata *cmd,
>  		if (r)
>  			return r;
>  
> -		for (b = 0; b < from_dblock(cmd->discard_nr_blocks); b++) {
> +		for (b = 0; ; b++) {
>  			r = fn(context, cmd->discard_block_size, to_dblock(b),
>  			       dm_bitset_cursor_get_value(&c));
>  			if (r)
>  				break;
> +
> +			if (b >= (from_dblock(cmd->discard_nr_blocks) - 1))
> +				break;

Not understanding why you moved the conditional inside the loop, I'd
rather keep it in the for().  Or did you have some reason for this?

> +
> +			r = dm_bitset_cursor_next(&c);
> +			if (r)
> +				break;
>  		}
>  
>  		dm_bitset_cursor_end(&c);
> -- 
> 2.11.0
> 
