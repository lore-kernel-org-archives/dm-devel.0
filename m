From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] DM RAID: fix a couple integer overflows
Date: Tue, 21 Oct 2014 15:43:54 +0300
Message-ID: <20141021124354.GB26918@mwanda>
References: <20140529082323.GA9209@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140529082323.GA9209@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

These array overflows are still there in linux-next.

regards,
dan carpenter

On Thu, May 29, 2014 at 11:23:23AM +0300, Dan Carpenter wrote:
> My static checker complains that if "num_raid_params" is UINT_MAX then
> the "if (num_raid_params + 1 > argc) {" check doesn't work as intended.
> 
> The other change is that I moved the "if (argc != (num_raid_devs * 2))"
> condition forward a few lines so it was before the call to
> context_alloc().  If we had an integer overflow inside that function
> then it would lead to an immediate crash.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker stuff.  Not tested.
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 4880b69..e0d53fe 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -1189,7 +1189,7 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	argv++;
>  
>  	/* Skip over RAID params for now and find out # of devices */
> -	if (num_raid_params + 1 > argc) {
> +	if (num_raid_params >= argc) {
>  		ti->error = "Arguments do not agree with counts given";
>  		return -EINVAL;
>  	}
> @@ -1200,6 +1200,12 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  		return -EINVAL;
>  	}
>  
> +	argc -= num_raid_params + 1; /* +1: we already have num_raid_devs */
> +	if (argc != (num_raid_devs * 2)) {
> +		ti->error = "Supplied RAID devices does not match the count given";
> +		return -EINVAL;
> +	}
> +
>  	rs = context_alloc(ti, rt, (unsigned)num_raid_devs);
>  	if (IS_ERR(rs))
>  		return PTR_ERR(rs);
> @@ -1208,16 +1214,8 @@ static int raid_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	if (ret)
>  		goto bad;
>  
> -	ret = -EINVAL;
> -
> -	argc -= num_raid_params + 1; /* +1: we already have num_raid_devs */
>  	argv += num_raid_params + 1;
>  
> -	if (argc != (num_raid_devs * 2)) {
> -		ti->error = "Supplied RAID devices does not match the count given";
> -		goto bad;
> -	}
> -
>  	ret = dev_parms(rs, argv);
>  	if (ret)
>  		goto bad;
