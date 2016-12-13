From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 2/2] multipathd: skip spurious event
 message for blacklisted paths
Date: Tue, 13 Dec 2016 15:50:25 -0600
Message-ID: <20161213215024.GB19659@octiron.msp.redhat.com>
References: <1481653629-22430-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<1481653629-22430-2-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1481653629-22430-2-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 13, 2016 at 04:27:09PM -0200, Mauricio Faria de Oliveira wrote:

Thanks for working on this. I like this version much better, but I still
have some issues. First off, I don't see why the udev_device_ref/unref
is necessary. While servicing uevents, when we first get the udevice
from udev_monitor_receive_device() in uevent_listen() it comes with a
reference. After we finish servicing the uevent, we drop this reference
in service_uevq(). If we attach this udevice to a path (by setting
pp->udev), we need to get another reference, so that the udevice isn't
deleted when we drop the reference after servicing the event in
service_uevq(). Otherwise pp->udev would be pointing to freed memory.
We drop this reference when we free the path in free_path().

When you call alloc_path_with_pathinfo(), it already grabs the second
reference before calling pathinfo. When it exits without pp_ptr being
set, it frees that extra reference in free_path(). But this whole time,
we are still servicing the uevent, and that originl reference is always
held, so we don't ever need to worry about the udevice getting deleted
out from under us. I don't see any possible danger in removing the
udev_device_ref/unref calls from your code. They don't hurt anything,
but grabbing references when we don't need them just confuses other
people who are trying reading the code, and makes the purpose of the
references harder to understand.

My second issue is more for Hannes. Is there a reason why we don't check
filter_property in pathinfo if we call it with (DI_BLACKLIST | DI_WWID).
If we have the information to get the WWID, then we have the information
to check filter_property.  Looking at the code, I don't see how we could
be checking filter_property for paths added via uev_add_path. Am I
missing something subtle here, or should we just add a filter_property()
check to pathinfo()?

-Ben

> Reported-by: Yueh Chyong (Ida) Jackson <idaj@us.ibm.com>
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---
>  multipathd/main.c | 32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d6f081f2f83a..dd7e8d69491e 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1010,8 +1010,38 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
>  	}
>  out:
>  	lock_cleanup_pop(vecs->lock);
> -	if (!pp)
> +	if (!pp) {
> +		/*
> +		 *  If the path is blacklisted, print a debug/non-default verbosity message.
> +		 *  - filter_devnode()	- checked by uev_trigger() (caller);
> +		 *  - filter_device()	- checked by pathinfo() (DI_BLACKLIST | DI_SYSFS);
> +		 *  - filter_wwid()	- checked by pathinfo() (DI_BLACKLIST | DI_WWID);
> +		 *  - filter_property()	- checked here).
> +		 */
> +		if (uev->udev) {
> +			int flag = DI_SYSFS | DI_WWID;
> +			struct udev_device *udevice;
> +
> +			udevice = udev_device_ref(uev->udev);
> +
> +			if (filter_property(conf, udevice) > 0)
> +				retval = PATHINFO_SKIPPED;
> +			else {
> +				conf = get_multipath_config();
> +				retval = alloc_path_with_pathinfo(conf, udevice, flag, NULL);
> +				put_multipath_config(conf);
> +			}
> +
> +			udev_device_unref(uev->udev);
> +
> +			if (retval == PATHINFO_SKIPPED) {
> +				condlog(3, "%s: spurious uevent, path is blacklisted", uev->kernel);
> +				return 0;
> +			}
> +		}
> +
>  		condlog(0, "%s: spurious uevent, path not found", uev->kernel);
> +	}
>  
>  	return retval;
>  }
> -- 
> 1.8.3.1
