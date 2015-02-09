From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm: Get devices using name_to_dev_t
Date: Mon, 9 Feb 2015 16:14:08 -0500
Message-ID: <20150209211407.GA2904@redhat.com>
References: <1422485157-33423-1-git-send-email-dehrenberg@chromium.org>
 <1422485157-33423-2-git-send-email-dehrenberg@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422485157-33423-2-git-send-email-dehrenberg@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Ehrenberg <dehrenberg@chromium.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, agk@redhat.com, grundler@chromium.org, drewry@chromium.org, gwendal@chromium.org
List-Id: dm-devel.ids

On Wed, Jan 28 2015 at  5:45pm -0500,
Dan Ehrenberg <dehrenberg@chromium.org> wrote:

> If a device is used as the root filesystem, it can't be built
> off of devices which are within the root filesystem (just like
> command line arguments to root=). For this reason, Linux has a
> pseudo-filesystem for root= and md initialization based on the
> function name_to_dev_t, which handles different ways of specifying
> devices including PARTUUID and major:minor.
> 
> This patch applies name_to_dev_t to dm initialization. Rather
> than assuming that all things which are not major:minor are paths
> in an already-mounted filesystem, this patch first attempts
> to look up the device in the filesystem, and applies name_to_dev_t
> if it is not found there.
> 
> In terms of backwards compatibility, there are some cases where
> behavior will be different:
> - If you have a file in the current working directory named 1:2 and
>   you initialze DM there, then it will try to use that file rather
>   than the disk with that major/minor pair as a backing device.
> - Similarly for other bdev types which name_to_dev_t knows how to
>   interpret, the previous behavior was to repeatedly check for the
>   existence of the file (e.g., while waiting for rootfs to come up)
>   but the new behavior is to use the name_to_dev_t interpretation.
>   For example, if you have a file named /dev/ubiblock0_0 which is
>   a symlink to /dev/sda3, but it is not yet present when dm starts
>   to initialize, then the name_to_dev_t interpretation will take
>   precedence.
> I believe these incompatibilities would only show up in really
> strange setups with bad practices and we don't have to worry about
> them.
> 
> Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
> ---
>  drivers/md/dm-table.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 3afae9e..3ce1e01 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -18,6 +18,7 @@
>  #include <linux/mutex.h>
>  #include <linux/delay.h>
>  #include <linux/atomic.h>
> +#include <linux/mount.h>
>  
>  #define DM_MSG_PREFIX "table"
>  
> @@ -372,23 +373,18 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
>  	int r;
>  	dev_t uninitialized_var(dev);
>  	struct dm_dev_internal *dd;
> -	unsigned int major, minor;
>  	struct dm_table *t = ti->table;
> -	char dummy;
> +	struct block_device *bdev;
>  
>  	BUG_ON(!t);
>  
> -	if (sscanf(path, "%u:%u%c", &major, &minor, &dummy) == 2) {
> -		/* Extract the major/minor numbers */
> -		dev = MKDEV(major, minor);
> -		if (MAJOR(dev) != major || MINOR(dev) != minor)
> -			return -EOVERFLOW;
> +	/* convert the path to a device */
> +	bdev = lookup_bdev(path);
> +	if (IS_ERR(bdev)) {
> +		dev = name_to_dev_t(path);
> +		if (!dev)
> +			return -ENODEV;
>  	} else {
> -		/* convert the path to a device */
> -		struct block_device *bdev = lookup_bdev(path);
> -
> -		if (IS_ERR(bdev))
> -			return PTR_ERR(bdev);
>  		dev = bdev->bd_dev;
>  		bdput(bdev);
>  	}

name_to_dev_t isn't an exported symbol so it is undefined if DM is built
as a module (as many distros do).

I was going to pick this up to submit via linux-dm.git but lost
conviction once I hit compile errors and it became clear others need to
weigh in on the broader use of name_to_dev_t().

Please Cc Al Viro on v2 (and any others that are returned by
scripts/get_maintainer.pl).

Mike
