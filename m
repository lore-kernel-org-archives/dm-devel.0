From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm raid: fix parse_raid_params() variable
 range issue
Date: Mon, 19 Mar 2018 16:24:52 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1803191619541.7544@file01.intranet.prod.int.rdu2.redhat.com>
References: <0ac594ac72b9ddf16c50da4e97361a4471f6651c.1521470284.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0ac594ac72b9ddf16c50da4e97361a4471f6651c.1521470284.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: dm-devel@redhat.com, snitzer@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

But on 32-bit architectures, INT_MAX is equivalent to LONG_MAX, so it 
won't shut up the warning.

The question is - why should it depend on architecture at all? If 32-bit 
values are enough, use int (and just delete the comparison with INT_MAX), 
if you need 64-bit values, use long long or int64_t.

Mikulas


On Mon, 19 Mar 2018, Heinz Mauelshagen wrote:

> parse_raid_parames() compared variable "int value" with INT_MAX to
> prevent overflow of mddev variables set.
> 
> Change type to "long value".
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
>  drivers/md/dm-raid.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 335ebd46a986..7ffa1839b206 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -1141,7 +1141,7 @@ static int validate_raid_redundancy(struct raid_set *rs)
>  static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  			     unsigned int num_raid_params)
>  {
> -	int value, raid10_format = ALGORITHM_RAID10_DEFAULT;
> +	long value, raid10_format = ALGORITHM_RAID10_DEFAULT;
>  	unsigned int raid10_copies = 2;
>  	unsigned int i, write_mostly = 0;
>  	unsigned int region_size = 0;
> @@ -1153,7 +1153,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  	arg = dm_shift_arg(as);
>  	num_raid_params--; /* Account for chunk_size argument */
>  
> -	if (kstrtoint(arg, 10, &value) < 0) {
> +	if (kstrtol(arg, 10, &value) < 0) {
>  		rs->ti->error = "Bad numerical argument given for chunk_size";
>  		return -EINVAL;
>  	}
> @@ -1315,7 +1315,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  		/*
>  		 * Parameters with number values from here on.
>  		 */
> -		if (kstrtoint(arg, 10, &value) < 0) {
> +		if (kstrtol(arg, 10, &value) < 0) {
>  			rs->ti->error = "Bad numerical argument given in raid params";
>  			return -EINVAL;
>  		}
> -- 
> 2.14.3
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
