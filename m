From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm raid: fix parse_raid_params() variable
	range issue
Date: Thu, 22 Mar 2018 15:41:45 -0400
Message-ID: <20180322194144.GA32294@redhat.com>
References: <6386b9f02b3513bd0ba5ddccd437502313448f7d.1521738866.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <6386b9f02b3513bd0ba5ddccd437502313448f7d.1521738866.git.heinzm@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 22 2018 at  1:21pm -0400,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> This v2 addresses Mikulas' point about the variable range and folds in
> "[PATCH] dm raid: use __within_range() more in parse_raid_params()":
> 
> parse_raid_parames() compared variable "int value" with
> INT_MAX to prevent overflow of mddev variables set.
> 
> Change type to "long long value".

Can you elaborate on the risk/issue that is being fixed here?

User specifying a value that overflows an int?

(also: see below for inline comment about last hunk)

> Whilst on it, use __within_range() throughout and
> add a sync min/max rate check.
> 
> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> ---
>  drivers/md/dm-raid.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index c1d1034ff7b7..c0e3d2aa9346 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -1141,7 +1141,7 @@ static int validate_raid_redundancy(struct raid_set *rs)
>  static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  			     unsigned int num_raid_params)
>  {
> -	int value, raid10_format = ALGORITHM_RAID10_DEFAULT;
> +	long long value, raid10_format = ALGORITHM_RAID10_DEFAULT;
>  	unsigned int raid10_copies = 2;
>  	unsigned int i, write_mostly = 0;
>  	unsigned int region_size = 0;
> @@ -1153,7 +1153,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  	arg = dm_shift_arg(as);
>  	num_raid_params--; /* Account for chunk_size argument */
>  
> -	if (kstrtoint(arg, 10, &value) < 0) {
> +	if (kstrtoll(arg, 10, &value) < 0) {
>  		rs->ti->error = "Bad numerical argument given for chunk_size";
>  		return -EINVAL;
>  	}
> @@ -1315,7 +1315,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  		/*
>  		 * Parameters with number values from here on.
>  		 */
> -		if (kstrtoint(arg, 10, &value) < 0) {
> +		if (kstrtoll(arg, 10, &value) < 0) {
>  			rs->ti->error = "Bad numerical argument given in raid params";
>  			return -EINVAL;
>  		}
> @@ -1430,7 +1430,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  				rs->ti->error = "Only one min_recovery_rate argument pair allowed";
>  				return -EINVAL;
>  			}
> -			if (value > INT_MAX) {
> +			if (!__within_range(value, 0, INT_MAX)) {
>  				rs->ti->error = "min_recovery_rate out of range";
>  				return -EINVAL;
>  			}
> @@ -1440,7 +1440,7 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  				rs->ti->error = "Only one max_recovery_rate argument pair allowed";
>  				return -EINVAL;
>  			}
> -			if (value > INT_MAX) {
> +			if (!__within_range(value, 0, INT_MAX)) {
>  				rs->ti->error = "max_recovery_rate out of range";
>  				return -EINVAL;
>  			}
> @@ -1472,6 +1472,12 @@ static int parse_raid_params(struct raid_set *rs, struct dm_arg_set *as,
>  		}
>  	}
>  
> +	if (rs->md.sync_speed_max &&
> +	    rs->md.sync_speed_max < rs->md.sync_speed_min) {
> +		rs->ti->error = "sync speed max smaller than min";
> +		return -EINVAL;
> +	}
> +
>  	if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags) &&
>  	    test_bit(__CTR_FLAG_NOSYNC, &rs->ctr_flags)) {
>  		rs->ti->error = "sync and nosync are mutually exclusive";
> -- 
> 2.14.3
> 

Isn't this last hunk unrelated?
