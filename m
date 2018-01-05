From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] dm-flakey: Use as->argc instead of argc
Date: Fri, 5 Jan 2018 16:59:47 -0500
Message-ID: <20180105215946.GA22028@redhat.com>
References: <20171204031412.2435-1-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20171204031412.2435-1-rgoldwyn@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sun, Dec 03 2017 at 10:14pm -0500,
Goldwyn Rodrigues <rgoldwyn@suse.de> wrote:

> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Since arguments are divided in argument sets, using argc
> fails corrupt_bio_byte because it is zero. We should
> be using as->argc to check the number of arguments.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  drivers/md/dm-flakey.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
> index b82cb1ab1eaa..e18c29672a88 100644
> --- a/drivers/md/dm-flakey.c
> +++ b/drivers/md/dm-flakey.c
> @@ -105,7 +105,7 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
>  		 * corrupt_bio_byte <Nth_byte> <direction> <value> <bio_flags>
>  		 */
>  		if (!strcasecmp(arg_name, "corrupt_bio_byte")) {
> -			if (!argc) {
> +			if (as->argc < 4) {
>  				ti->error = "Feature corrupt_bio_byte requires parameters";
>  				return -EINVAL;
>  			}
> @@ -113,7 +113,6 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
>  			r = dm_read_arg(_args + 1, as, &fc->corrupt_bio_byte, &ti->error);
>  			if (r)
>  				return r;
> -			argc--;
>  
>  			/*
>  			 * Direction r or w?
> @@ -127,7 +126,6 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
>  				ti->error = "Invalid corrupt bio direction (r or w)";
>  				return -EINVAL;
>  			}
> -			argc--;
>  
>  			/*
>  			 * Value of byte (0-255) to write in place of correct one.
> @@ -135,7 +133,6 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
>  			r = dm_read_arg(_args + 2, as, &fc->corrupt_bio_value, &ti->error);
>  			if (r)
>  				return r;
> -			argc--;
>  
>  			/*
>  			 * Only corrupt bios with these flags set.
> @@ -143,7 +140,6 @@ static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
>  			r = dm_read_arg(_args + 3, as, &fc->corrupt_bio_flags, &ti->error);
>  			if (r)
>  				return r;
> -			argc--;
>  
>  			continue;
>  		}

This is wrong.  The outer control loop is using argc.  Therefore it
needs to be managed.

But I'll grant you that the check should be "argc < 4" rather than the
less precise "!argc" check.

Mike
