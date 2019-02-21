From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 2/9] dm: eliminate 'split_discard_bios'
 flag from DM target interface
Date: Wed, 20 Feb 2019 23:36:26 -0500
Message-ID: <20190221043626.GC31000@redhat.com>
References: <20190220214436.38476-1-snitzer@redhat.com>
	<20190220214436.38476-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190220214436.38476-3-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 20 2019 at  4:44pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> There is no need to have DM core split discards on behalf of a DM target
> now that blk_queue_split() handles splitting discards based on the
> queue_limits.  A DM target just needs to set max_discard_sectors,
> discard_granularity, etc, in queue_limits.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-cache-target.c  |  1 -
>  drivers/md/dm-raid.c          | 14 +++++++++-----
>  drivers/md/dm-thin.c          |  1 -
>  drivers/md/dm-zoned-target.c  |  1 -
>  drivers/md/dm.c               | 28 ++++++----------------------
>  include/linux/device-mapper.h |  6 ------
>  include/uapi/linux/dm-ioctl.h |  4 ++--
>  7 files changed, 17 insertions(+), 38 deletions(-)
> 

...

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7a774fcd0194..b988e178a523 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1478,17 +1478,10 @@ static unsigned get_num_write_zeroes_bios(struct dm_target *ti)
>  	return ti->num_write_zeroes_bios;
>  }
>  
> -typedef bool (*is_split_required_fn)(struct dm_target *ti);
> -
> -static bool is_split_required_for_discard(struct dm_target *ti)
> -{
> -	return ti->split_discard_bios;
> -}
> -
>  static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *ti,
> -				       unsigned num_bios, bool is_split_required)
> +				       unsigned num_bios)
>  {
> -	unsigned len;
> +	unsigned len = ci->sector_count;
>  
>  	/*
>  	 * Even though the device advertised support for this type of
> @@ -1499,38 +1492,29 @@ static int __send_changing_extent_only(struct clone_info *ci, struct dm_target *
>  	if (!num_bios)
>  		return -EOPNOTSUPP;
>  
> -	if (!is_split_required)
> -		len = min((sector_t)ci->sector_count, max_io_len_target_boundary(ci->sector, ti));
> -	else
> -		len = min((sector_t)ci->sector_count, max_io_len(ci->sector, ti));
> -
>  	__send_duplicate_bios(ci, ti, num_bios, &len);
>  
> -	ci->sector += len;
> -	ci->sector_count -= len;
> -
>  	return 0;
>  }

The above was bogus, ci->sector and ci->sector_count must be updated.
Reintroducing adjustments based on 'len' fixed a discard crash Ming
reported.

Now fixed in linux-next.

Mike
