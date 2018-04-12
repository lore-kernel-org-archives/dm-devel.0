From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 17/20] multipath -u: test if path is busy
Date: Thu, 12 Apr 2018 13:41:09 -0500
Message-ID: <20180412184109.GS3103@octiron.msp.redhat.com>
References: <20180402195051.26854-1-mwilck@suse.com>
	<20180402195051.26854-18-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180402195051.26854-18-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Mon, Apr 02, 2018 at 09:50:48PM +0200, Martin Wilck wrote:
> For "find_multipaths smart", check if a path is already in use
> before setting DM_MULTIPATH_DEVICE_PATH to 1 or 2 (and thus,
> SYSTEMD_READY=0). If we don't do this, a device which has already been
> mounted (e.g. during initrd processing) may be unmounted by systemd, causing
> havoc to the boot process.

I'm reviewing  v3 of this patch because I don't see patch 17/20 in your
emails from v4. Am I missing an email, or did it not get sent?


> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index d09f117..392d5f0 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -629,16 +629,45 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  
>  
>  	if (cmd == CMD_VALID_PATH) {
> +		struct path *pp;
> +		int fd;
> +
>  		/* This only happens if find_multipaths and
>  		 * ignore_wwids is set.
>  		 * If there is currently a multipath device matching
>  		 * the refwwid, or there is more than one path matching
>  		 * the refwwid, then the path is valid */
> -		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
> +		if (VECTOR_SIZE(curmp) != 0) {
> +			r = 0;
> +			goto print_valid;
> +		} else if (VECTOR_SIZE(pathvec) > 1)
>  			r = 0;
>  		else
>  			/* Use r=2 as an indication for "maybe" */
>  			r = 2;
> +
> +		/*
> +		 * If opening the path with O_EXCL fails, the path
> +		 * is in use (e.g. mounted during initramfs processing).
> +		 * We know that it's not used by dm-multipath.
> +		 * We may not set SYSTEMD_READY=0 on such devices, it
> +		 * might cause systemd to umount the device.
> +		 * Use O_RDONLY, because udevd would trigger another
> +		 * uevent for close-after-write.
> +		 *
> +		 * get_refwwid() above stores the path we examine in slot 0.
> +		 */
> +		pp = VECTOR_SLOT(pathvec, 0);
> +		fd = open(udev_device_get_devnode(pp->udev),
> +			  O_RDONLY|O_EXCL);

I'm worried about this.  Since we can't be sure that is_failed_wwid()
will really tell us that multipathd has tried to multipath the device
and failed, it is totally possible to get a maybe after multipath has
turned the path device over to the rest of the system. If this is true,
then the exclusive open might race with something else that is trying to
use the device, and cause that to fail.  Or worse, it might win but have
the other process mount the file system on it, only to have multipath go
and claim the device, unmounting it. I still think that the only safe
course is to only do this grab when we know that it is safe, such as on
add events, or if we have already labelled this device as a maybe
device, and we are still waiting on it.

Of course, this means I would exlcude the whole second "if (cmd ==
CMD_VALID_PATH)" section in configure() unless we know that it is safe
to grab the device.  Otherwise, there is nothing to stop us from
claiming a device that is in use. Clearly that exclusive grab check is
racy at any time except on add events or when the device already is set
to SYSTEMD_READY=0.  I'm pretty sure that the coldplug add event after
the switchroot is safe, since nothing will be racing to grab the device
then. 

You've already agreed that it should be fine to allow multipathd to try
to create a multipath device on top of a non-claimed path, since we can
just claim it later by issuing a uevent.  I feel like this is just
another instance of that.  If this isn't a new path, where we have
excluded everyone else from using it, we can't suddenly claim it just
because a second path appears. However, if multipathd manages to create
a multipath device on top of it, then it will add the wwid to the wwids
file, and be able to claim it.  But otherwise, I don't think that the
exclusive grab is safe or reliable enough to allow us to simply do this
on any uevent.

I would add a new option to multipath, that works with -u, to tell it
that maybes are allowed. If find_multipaths == FIND_MULTIPATHS_SMART,
then it should not claim the device if it doesn't get positively claimed
in the first "if (cmd == CMD_VALID_PATH)" section of configure(). That
will save us from claiming devices that are already in use, and speed
the multipath -u calls up.
 

> +		if (fd >= 0)
> +			close(fd);
> +		else {
> +			condlog(3, "%s: path %s is in use: %s",
> +				__func__, pp->dev,
> +				strerror(errno));
> +			r = 1;
> +		}
>  		goto print_valid;
>  	}
>  
> -- 
> 2.16.1
