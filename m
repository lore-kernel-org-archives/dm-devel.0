From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/3] dm: allow error target to replace
 immutable target
Date: Thu, 29 Aug 2013 10:37:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1308291036390.20142@file01.intranet.prod.int.rdu2.redhat.com>
References: <1377746464-2437-1-git-send-email-snitzer@redhat.com>
	<1377746464-2437-3-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1377746464-2437-3-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

As I said - I think it would be better to remove the immutable flag than 
to create more flags to bypass it.

Mikulas

On Wed, 28 Aug 2013, Mike Snitzer wrote:

> Introduce DM_TARGET_ALWAYS_RETURNS_IO_ERROR to indicate that a target
> always returns IO error.  Because the target will error all IO it can
> safely replace any target (including an immutable target) as along as
> the associated mapped device is not open.  If an error target replaces
> an immutable target it is elevated to the mapped device's immutable
> target type.
> 
> The "error" target can now replace an immutable target like the thin
> provisioning pool ("thin-pool") target.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-ioctl.c         | 27 ++++++++++++++++++++++++++-
>  drivers/md/dm-table.c         |  9 ++++++++-
>  drivers/md/dm-target.c        |  1 +
>  include/linux/device-mapper.h | 10 ++++++++++
>  4 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 301e0a5..08186cb 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -1248,6 +1248,30 @@ static int populate_table(struct dm_table *table,
>  	return dm_table_complete(table);
>  }
>  
> +static bool immutable_target_type_is_valid(struct mapped_device *md,
> +					   struct target_type *immutable_tt,
> +					   struct target_type *table_immutable_tt)
> +{
> +	if (immutable_tt == table_immutable_tt)
> +		return true;
> +
> +	if (!table_immutable_tt)
> +		return false;
> +
> +	if (dm_target_always_returns_io_error(table_immutable_tt)) {
> +		/*
> +		 * Only allow a transition to an error target_type if
> +		 * the mapped_device is no longer open.
> +		 */
> +		if (!dm_open_count(md))
> +			return true;
> +
> +		DMERR("can't change target type to error while device is in use");
> +	}
> +
> +	return false;
> +}
> +
>  static int table_load(struct dm_ioctl *param, size_t param_size)
>  {
>  	int r;
> @@ -1272,7 +1296,8 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
>  
>  	immutable_target_type = dm_get_immutable_target_type(md);
>  	if (immutable_target_type &&
> -	    (immutable_target_type != dm_table_get_immutable_target_type(t))) {
> +	    !immutable_target_type_is_valid(md, immutable_target_type,
> +					    dm_table_get_immutable_target_type(t))) {
>  		DMWARN("can't replace immutable target type %s",
>  		       immutable_target_type->name);
>  		r = -EINVAL;
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 8f87835..70d3067 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -745,7 +745,14 @@ int dm_table_add_target(struct dm_table *t, const char *type,
>  		return -EINVAL;
>  	}
>  
> -	if (t->immutable_target_type) {
> +	if (dm_target_always_returns_io_error(tgt->type) &&
> +	    dm_get_immutable_target_type(t->md)) {
> +		/*
> +		 * This error target must be upgraded to immutable because
> +		 * the mapped device is already using an immutable target.
> +		 */
> +		t->immutable_target_type = tgt->type;
> +	} else if (t->immutable_target_type) {
>  		if (t->immutable_target_type != tgt->type) {
>  			DMERR("%s: immutable target type %s cannot be mixed with other target types",
>  			      dm_device_name(t->md), t->immutable_target_type->name);
> diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
> index 242e3ce..3b9a988 100644
> --- a/drivers/md/dm-target.c
> +++ b/drivers/md/dm-target.c
> @@ -139,6 +139,7 @@ static int io_err_map_rq(struct dm_target *ti, struct request *clone,
>  
>  static struct target_type error_target = {
>  	.name = "error",
> +	.features = DM_TARGET_ALWAYS_RETURNS_IO_ERROR,
>  	.version = {1, 2, 0},
>  	.ctr  = io_err_ctr,
>  	.dtr  = io_err_dtr,
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 653073d..2451e6b 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -192,6 +192,16 @@ struct target_type {
>  #define dm_target_is_immutable(type)	((type)->features & DM_TARGET_IMMUTABLE)
>  
>  /*
> + * Indicates that a target always returns IO error.  Because the target will error
> + * all IO it can safely replace any target (including an immutable target) as long
> + * as the associated mapped device is not open.  If an error target replaces an
> + * immutable target it is elevated to the mapped device's immutable target type.
> + */
> +#define DM_TARGET_ALWAYS_RETURNS_IO_ERROR	0x00000008
> +#define dm_target_always_returns_io_error(type) \
> +		((type)->features & DM_TARGET_ALWAYS_RETURNS_IO_ERROR)
> +
> +/*
>   * Some targets need to be sent the same WRITE bio severals times so
>   * that they can send copies of it to different devices.  This function
>   * examines any supplied bio and returns the number of copies of it the
> -- 
> 1.8.1.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
