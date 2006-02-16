From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] User-configurable HDIO_GETGEO for dm volumes
Date: Wed, 15 Feb 2006 19:05:56 -0800
Message-ID: <20060215190556.59c343b4.akpm@osdl.org>
References: <43F38D83.3040702@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43F38D83.3040702@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, lcm@us.ibm.com
List-Id: dm-devel.ids

"Darrick J. Wong" <djwong@us.ibm.com> wrote:
>
> Here's a rework of last week's HDIO_GETGEO patch.  Based on all the 
>  feedback that I received last week, it seems that a better way to 
>  approach this problem is:
> 
>  - Store a hd_geometry structure with each dm_table entry.
>  - Provide a dm getgeo method that returns that geometry (or
>     -ENOTTY if there is no geometry).
>  - Add a dm control ioctl to set the geometry of an arbitrary dm device.
>  - Modify dmsetup to be able to set geometries.
> 
>  This way, dmraid can associate geometries with bootable fakeraid 
>  devices, and dmsetup can be told to assign a geometry to a single-device 
>  linear/multipath setup as desired.  Furthermore, HDIO_GETGEO callers 
>  will go away empty-handed if the userspace config tools do not set up a 
>  geometry, as is the case now.  The decision to assign a geometry (and 
>  what that should be) is totally deferred to userspace.
> 
>  So, dm-getgeo_1.patch is a patch to 2.6.16-rc3 that modifies the dm 
>  driver to store and retrieve geometries.  I chose to attach the 
>  hd_geometry structure to dm_table because it seemed like a convenient 
>  place to attach config data.  The only part of this patch that I think 
>  to be particularly dodgy is the dev_setgeo function, because I'm using 
>  the dm_target_msg struct to pass the user's hd_geometry into the kernel. 
>    I'm not really sure if or how I'm supposed to send binary blobs into 
>  the dm code, though the piggyback method works adequately.  Obviously, 
>  this introduces a new dm control ioctl DM_DEV_SETGEO.
> 
>  The second patch (device-mapper-geometry_1.patch), unsurprisingly, is a 
>  patch to the userspace libdevmapper/dmsetup code to enable the passing 
>  of hd_geometry structures to the kernel.
>
> ...
>
> diff -Naurp old/drivers/md/dm.c linux-2.6.16-rc3/drivers/md/dm.c
> --- old/drivers/md/dm.c	2006-02-15 10:49:46.000000000 -0800
> +++ linux-2.6.16-rc3/drivers/md/dm.c	2006-02-15 10:42:14.000000000 -0800
> @@ -17,6 +17,7 @@
>  #include <linux/mempool.h>
>  #include <linux/slab.h>
>  #include <linux/idr.h>
> +#include <linux/hdreg.h>
>  
>  static const char *_name = DM_NAME;
>  
> @@ -225,6 +226,16 @@ static int dm_blk_close(struct inode *in
>  	return 0;
>  }
>  
> +static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
> +{
> +	int ret;
> +	struct mapped_device *md = bdev->bd_disk->private_data;
> +
> +	ret = dm_table_get_geometry(md->map, geo);
> +
> +	return (ret ? 0 : -ENOTTY);
> +}	

Normally kernel functions return zero on success.  So that they can return
negative errno on failure.  Is that appropriate here?  Just propagate the
dm_table_get_geometry() return value?

> +static int dev_setgeo(struct dm_ioctl *param, size_t param_size)
> +{
> +	int r = 0;
> +	size_t len;
> +	struct mapped_device *md;
> +	struct dm_table *tbl;
> +	struct dm_geometry_msg *dgm;
> +	struct dm_target_msg *tmsg;
> +
> +	md = find_device(param);
> +	if (!md)
> +		return -ENXIO;
> +
> +	/*
> +	 * Grab our output buffer.
> +	 */
> +	tmsg = get_result_buffer(param, param_size, &len);
> +	dgm = (struct dm_geometry_msg *)tmsg->message;
> +
> +	tbl = dm_get_table(md);
> +
> +	r = dm_table_set_geometry(tbl, &dgm->geo);
> +
> +	dm_table_put(tbl);
> +	dm_put(md);
> +
> +	return (r ? 0 : -EINVAL);
> +}
> +
> ...
> +int dm_table_set_geometry(struct dm_table *t, struct hd_geometry *geo)
> +{
> +	memcpy(&t->forced_geometry, geo, sizeof(*geo));
> +
> +	return 1;
> +}

That's brave - we take the hd_geometry straight from userspace without
checking anything?

Will this code dtrt if userspace is 32-bit and the kernel is 64-bit?

struct hd_geometry looks like something which different compilers could lay
out differently, perhaps even different gcc versions.  We're relying upon
the userspace representation being identical to the kernel's
representation.

It means that struct hd_geometry becomes part of the kernel ABI.  We can
never again change it and neither we (nor the compiler) can ever change its
layout.  That's dangerous.  I'd suggest that you not use hd_geometry in
this way (unless we're already using it that way, which might be the case).

It'd be better to use some carefully laid-out and documented structure
which is private to DM and which is designed for future-compatibility and
for user<->kernel communication.
