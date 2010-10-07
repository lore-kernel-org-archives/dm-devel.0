From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] Make it possible to set a uuid if one was
	not set during DM_DEV_CREATE.
Date: Thu, 7 Oct 2010 18:19:24 -0500
Message-ID: <3864094C-EA28-4E8A-9BDE-6A70CE41C67B@redhat.com>
References: <1286479718-18274-1-git-send-email-pjones@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1286479718-18274-1-git-send-email-pjones@redhat.com>
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

Minor nits below

  brassow

On Oct 7, 2010, at 2:28 PM, Peter Jones wrote:

> This makes it possible to use DM_DEV_RENAME to add a uuid to a  
> device so
> long as one has not been previously set either with DM_DEV_CREATE or
> with DM_DEV_RENAME.

Seems like a sensible thing.  Is there a reason this is coming up now?

>
> Also bump the minor number to 19.
> ---
> drivers/md/dm-ioctl.c    |  113 +++++++++++++++++++++++++++++++ 
> +-------------
> include/linux/dm-ioctl.h |    9 +++-
> 2 files changed, 87 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 3e39193..bd76846 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -298,7 +298,7 @@ retry:
> static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
>

<snip>

> 	/*
> @@ -333,19 +347,42 @@ static struct mapped_device  
> *dm_hash_rename(struct dm_ioctl *param,
> 		DMWARN("asked to rename a non-existent device %s -> %s",
> 		       param->name, new);
> 		up_write(&_hash_lock);
> -		kfree(new_name);
> +		kfree(new_data);
> 		return ERR_PTR(-ENXIO);
> 	}
>
> -	/*
> -	 * rename and move the name cell.
> -	 */
> -	list_del(&hc->name_list);
> -	old_name = hc->name;
> -	mutex_lock(&dm_hash_cells_mutex);
> -	hc->name = new_name;
> -	mutex_unlock(&dm_hash_cells_mutex);
> -	list_add(&hc->name_list, _name_buckets + hash_str(new_name));
> +	if (param->flags & DM_NEW_UUID_FLAG) {
> +		/*
> +		 * Does this device already have a uuid?
> +		 */
> +		if (hc->uuid) {
> +			DMWARN("asked to change uuid of device with uuid "
> +			       "already set %s %s -> %s",
> +			       param->name, hc->uuid, param->uuid);

Message doesn't imply this is illegal... Perhaps "Unable to change...  
set"?

> +			up_write(&_hash_lock);
> +			kfree(new_uuid);

Will patch compile?  s/new_uuid/new_data/

> +			return ERR_PTR(-EINVAL);
> +		}
> +		/*
> +		 * reuuid and move the uuid cell.
> +		 */
> +		list_del(&hc->uuid_list);
> +		old_data = hc->uuid;
> +		mutex_lock(&dm_hash_cells_mutex);
> +		hc->uuid = new_data;
> +		mutex_unlock(&dm_hash_cells_mutex);
> +		list_add(&hc->uuid_list, _uuid_buckets + hash_str(new_data));
> +	} else {
> +		/*
> +		 * rename and move the name cell.
> +		 */
> +		list_del(&hc->name_list);
> +		old_data = hc->name;
> +		mutex_lock(&dm_hash_cells_mutex);
> +		hc->name = new_data;
> +		mutex_unlock(&dm_hash_cells_mutex);
> +		list_add(&hc->name_list, _name_buckets + hash_str(new_data));
> +	}
>
> 	/*
> 	 * Wake up any dm event waiters.
> @@ -361,7 +398,7 @@ static struct mapped_device  
> *dm_hash_rename(struct dm_ioctl *param,
>
> 	md = hc->md;
> 	up_write(&_hash_lock);
> -	kfree(old_name);
> +	kfree(old_data);
>
> 	return md;
> }
> @@ -774,21 +811,31 @@ static int invalid_str(char *str, void *end)
> static int dev_rename(struct dm_ioctl *param, size_t param_size)
> {
> 	int r;
> -	char *new_name = (char *) param + param->data_start;
> +	char *new_data = (char *) param + param->data_start;
> 	struct mapped_device *md;
>
> -	if (new_name < param->data ||
> -	    invalid_str(new_name, (void *) param + param_size) ||
> -	    strlen(new_name) > DM_NAME_LEN - 1) {
> -		DMWARN("Invalid new logical volume name supplied.");
> -		return -EINVAL;
> -	}
> +	if (param->flags & DM_NEW_UUID_FLAG) {
> +		struct hash_cell *hc;

Is this newly declared variable needed?

> +		if (new_data < param->data ||
> +		    invalid_str(new_data, (void *) param + param_size) ||
> +		    strlen(new_data) > DM_UUID_LEN - 1) {
> +			DMWARN("Invalid new logical volume uuid supplied.");

I wonder why we were using "logical volume" instead of "device" like  
everywhere else... can we change it now?

> +			return -EINVAL;
> +		}
> +	} else {
> +		if (new_data < param->data ||
> +		    invalid_str(new_data, (void *) param + param_size) ||
> +		    strlen(new_data) > DM_NAME_LEN - 1) {
> +			DMWARN("Invalid new logical volume name supplied.");

s/logical volume/device/

> +			return -EINVAL;
> +		}
>
> -	r = check_name(new_name);
> -	if (r)
> -		return r;
> +		r = check_name(new_data);
> +		if (r)
> +			return r;
> +	}
>
> -	md = dm_hash_rename(param, new_name);
> +	md = dm_hash_rename(param, new_data);
> 	if (IS_ERR(md))
> 		return PTR_ERR(md);
>
> diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
> index 49eab36..e369460 100644
> --- a/include/linux/dm-ioctl.h
> +++ b/include/linux/dm-ioctl.h
> @@ -267,9 +267,9 @@ enum {
> #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD,  
> struct dm_ioctl)
>
> #define DM_VERSION_MAJOR	4
> -#define DM_VERSION_MINOR	18
> +#define DM_VERSION_MINOR	19
> #define DM_VERSION_PATCHLEVEL	0
> -#define DM_VERSION_EXTRA	"-ioctl (2010-06-29)"
> +#define DM_VERSION_EXTRA	"-ioctl (2010-10-07)"
>
> /* Status bits */
> #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
> @@ -322,4 +322,9 @@ enum {
>  */
> #define DM_UEVENT_GENERATED_FLAG	(1 << 13) /* Out */
>
> +/*
> + * If set, rename operates on uuid, not name.
> + */
> +#define DM_NEW_UUID_FLAG        (1 << 14) /* In */
> +
> #endif				/* _LINUX_DM_IOCTL_H */
> -- 
> 1.7.2.2
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
