From: Minfei Huang <mnfhuang@gmail.com>
Subject: Re: [dm-devel] [PATCH] dm-ioctl: fix 4-characters indentations
Date: Sat, 28 Nov 2015 16:38:01 +0800
Message-ID: <20151128083801.GA16777@dhcp-129-10.nay.redhat.com>
References: <1f27d82f27c62841bcb9858f90ad27fd0dce78e3.1448455317.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1f27d82f27c62841bcb9858f90ad27fd0dce78e3.1448455317.git.geliangtang@163.com>
Sender: linux-raid-owner@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org, Geliang Tang <geliangtang@163.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi.

IMHO, this sort of defect shouldn't be fixed like this. It should be
fixed with other bugs, if necessary.

Once this patch is applied, it will break up the 'git blame'.

Thanks
Minfei

On 11/25/15 at 08:45pm, Geliang Tang wrote:
> Change 4-characters indentations to 8-characters.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>
> ---
>  drivers/md/dm-ioctl.c | 58 +++++++++++++++++++++++++--------------------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 80a4395..39aae6b 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -45,10 +45,10 @@ struct dm_table {
>  };
>  
>  struct vers_iter {
> -    size_t param_size;
> -    struct dm_target_versions *vers, *old_vers;
> -    char *end;
> -    uint32_t flags;
> +	size_t param_size;
> +	struct dm_target_versions *vers, *old_vers;
> +	char *end;
> +	uint32_t flags;
>  };
>  
>  
> @@ -557,36 +557,36 @@ static int list_devices(struct dm_ioctl *param, size_t param_size)
>  
>  static void list_version_get_needed(struct target_type *tt, void *needed_param)
>  {
> -    size_t *needed = needed_param;
> +	size_t *needed = needed_param;
>  
> -    *needed += sizeof(struct dm_target_versions);
> -    *needed += strlen(tt->name);
> -    *needed += ALIGN_MASK;
> +	*needed += sizeof(struct dm_target_versions);
> +	*needed += strlen(tt->name);
> +	*needed += ALIGN_MASK;
>  }
>  
>  static void list_version_get_info(struct target_type *tt, void *param)
>  {
> -    struct vers_iter *info = param;
> -
> -    /* Check space - it might have changed since the first iteration */
> -    if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 >
> -	info->end) {
> -
> -	info->flags = DM_BUFFER_FULL_FLAG;
> -	return;
> -    }
> -
> -    if (info->old_vers)
> -	info->old_vers->next = (uint32_t) ((void *)info->vers -
> -					   (void *)info->old_vers);
> -    info->vers->version[0] = tt->version[0];
> -    info->vers->version[1] = tt->version[1];
> -    info->vers->version[2] = tt->version[2];
> -    info->vers->next = 0;
> -    strcpy(info->vers->name, tt->name);
> -
> -    info->old_vers = info->vers;
> -    info->vers = align_ptr(((void *) ++info->vers) + strlen(tt->name) + 1);
> +	struct vers_iter *info = param;
> +
> +	/* Check space - it might have changed since the first iteration */
> +	if ((char *)info->vers + sizeof(tt->version) + strlen(tt->name) + 1 >
> +		info->end) {
> +
> +		info->flags = DM_BUFFER_FULL_FLAG;
> +		return;
> +	}
> +
> +	if (info->old_vers)
> +		info->old_vers->next = (uint32_t) ((void *)info->vers -
> +						   (void *)info->old_vers);
> +	info->vers->version[0] = tt->version[0];
> +	info->vers->version[1] = tt->version[1];
> +	info->vers->version[2] = tt->version[2];
> +	info->vers->next = 0;
> +	strcpy(info->vers->name, tt->name);
> +
> +	info->old_vers = info->vers;
> +	info->vers = align_ptr(((void *) ++info->vers) + strlen(tt->name) + 1);
>  }
>  
>  static int list_versions(struct dm_ioctl *param, size_t param_size)
> -- 
> 2.5.0
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
