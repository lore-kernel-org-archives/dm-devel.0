From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] dm: allow a dm-fs-style device to be
 shared via dm-ioctl
Date: Thu, 13 May 2010 23:53:47 -0400
Message-ID: <20100514035347.GA20636@redhat.com>
References: <20100514013940.GA3523@z600>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20100514013940.GA3523@z600>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Will Drewry <wad@chromium.org>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Will,

On Thu, May 13 2010 at  9:39pm -0400,
Will Drewry <wad@chromium.org> wrote:

> Following on the discussion of booting directly to a device-mapper
> device, two things were made clear:
> 1. The ioctl interface's name and uuid are mandatory for udev to work
> 2. There is a functional gap between the dm(-fs) and dm-ioctl
> 
> This change adds one function which is used for binding a given mapped
> device to a name+uuid in the dm-ioctl hash table.  In addition, it
> ensures that public functions are available that allow mapped devices
> and tables to be created and associated with shared code paths in
> dm-ioctl:
> - suspend flags and block integrity registration are now exposed
> - dm_table_complete() now prepares a table for use completely
>   (builds the btree; sets the type; allocates md pools)

I have done a preliminary review and have some comments inlined below.

> Ideally, this lays the groundwork for any kernel code to create fully
> functional mapped devices, but I'd appreciate feedback on if this
> approach makes sense/is safe, preferred function names, and if it
> integrates with the current direction.
> 
> (I can also pair this with the init code patch if it makes sense to show
> consumer code.)

It would certainly help follow-on reviews as we take a closer look.  For
the next version of your work I'd recommend sharing all related code in
a series (e.g.: core DM patch 1/2, init patch 2/2).

> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 9924ea2..66726d1 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -900,7 +900,7 @@ static int setup_indexes(struct dm_table *t)
>  /*
>   * Builds the btree to index the map.
>   */
> -int dm_table_complete(struct dm_table *t)
> +int dm_table_build_index(struct dm_table *t)
>  {
>  	int r = 0;
>  	unsigned int leaf_nodes;
> @@ -919,6 +919,48 @@ int dm_table_complete(struct dm_table *t)
>  	return r;
>  }
>  
> +
> +/*
> + * Prepares the table for use by building the indices,
> + * setting the type, and allocating mempools.
> + */
> +int dm_table_complete(struct dm_table *t)
> +{
> +	int r = 0;
> +	
> +	r = dm_table_build_index(t);
> +	if (r) {
> +		DMWARN("unable to build btrees");
> +		return r;
> +	}
> +	r = dm_table_set_type(t);
> +	if (r) {
> +		DMWARN("unable to set table type");
> +		return r;
> +	}
> +	r = dm_table_alloc_md_mempools(t);
> +	if (r)
> +		DMWARN("unable to allocate mempools");
> +
> +	return r;
> +}

Please have dm_table_set_type() come before dm_table_build_index() to
preserve the existing call sequence.  It is better to check the type
related constraints before going on to build the indices.

> +
> +/*
> + * Register the mapped device for blk_integrity support if
> + * the underlying devices support it.
> + */
> +int dm_table_prealloc_integrity(struct dm_table *t, struct mapped_device *md)
> +{
> +	struct list_head *devices = dm_table_get_devices(t);
> +	struct dm_dev_internal *dd;
> +
> +	list_for_each_entry(dd, devices, list)
> +		if (bdev_get_integrity(dd->dm_dev.bdev))
> +			return blk_integrity_register(dm_disk(md), NULL);
> +
> +	return 0;
> +}

I think we need more justification for why you'd want to expose
dm_table_prealloc_integrity() as a public interface.  Makes DM a bit
more brittle with unknown gain at the moment.  Why not just move the
dm_table_prealloc_integrity() call to dm_table_complete() -- just before
dm_table_alloc_md_mempools()?

>  static DEFINE_MUTEX(_event_lock);
>  void dm_table_event_callback(struct dm_table *t,
>  			     void (*fn)(void *), void *context)
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index 1381cd9..95fea4c 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -215,6 +215,18 @@ void dm_set_mdptr(struct mapped_device *md, void *ptr);
>  void *dm_get_mdptr(struct mapped_device *md);
>  
>  /*
> + * Export the device via the ioctl interface
> + */
> +int dm_ioctl_export(struct mapped_device *md, const char *name,
> +		    const char *uuid);
> +
> +/*
> + * Suspend feature flags
> + */
> +#define DM_SUSPEND_LOCKFS_FLAG		(1 << 0)
> +#define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)

You're missing the matching removal of these flags from drivers/md/dm.h

Regards,
Mike
