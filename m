From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/2] multipathd: skip spurious event message
 for blacklisted paths
Date: Mon, 12 Dec 2016 08:23:40 -0600
Message-ID: <20161212142340.GA19659@octiron.msp.redhat.com>
References: <1481385923-12407-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<1481385923-12407-2-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1481385923-12407-2-git-send-email-mauricfo@linux.vnet.ibm.com>
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

Why don't we just call pathinfo here? I see that you set the pathvec to
NULL so that you don't actually store the path, but this sure does a lot
of unnecessary work before failing. AFAICT, just calling pathinfo with
DI_BLACKLIST already gets you what you need (it checks both the device
and wwid blacklists). Am I missing something here?

-Ben

On Sat, Dec 10, 2016 at 02:05:23PM -0200, Mauricio Faria de Oliveira wrote:
> Currently, multipath still prints the 'spurious uevent, path not found'
> message if a path is blacklisted by something different than a devnode
> in the 'change' uevent handling. (uev_trigger() calls filter_devnode()).
> 
> Thus blacklisting by device vendor/product and wwid still renders that
> message in the system log -- since it's verbosity level 0 -- for paths
> that are explicitly marked to be ignored.
> 
> This problem happens on common scenarios such as creating filesystems
> on a blacklisted device (e.g., mkfs.* /dev/sdX), which is usually run
> several times on test environments, and the error message may mislead
> the error checker/monitor tools with false negatives.
> 
> This patch resolves this problem by calling/checking path_discover()
> for PATHINFO_SKIPPED with just enough device information flags for
> blacklist verification -- and it prints a debug message (verbosity
> level 3) instead of an error message since this case is not an error.
> 
> Even though it introduces a bit of overhead to get the path info,
> it is only exercised in the error/non-default path -- so not a problem.
> 
> Test-case (on QEMU):
> 
>   /etc/multipath.conf:
> 
>   blacklist {
>       device {
>           vendor "QEMU"
>        }
>   }
> 
>   # multipathd -d &
>   ...
>   Dec 10 08:06:27 | sda: (QEMU:QEMU HARDDISK) vendor/product blacklisted
>   ...
> 
>   # mkfs.ext3 -F /dev/sda
>   ...
> 
>   Dec 10 08:07:05 | sda: spurious uevent, path not found
> 
> With the patch applied, no message is printed by default.
> It's still possible to get the event logged for debug with '-v3':
> 
>   Dec 10 09:08:51 | sda: spurious uevent, path blacklisted
> 
> Reported-by: Yueh Chyong (Ida) Jackson <idaj@us.ibm.com>
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---
>  multipathd/main.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d6f081f..364fecb 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1010,8 +1010,28 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
>  	}
>  out:
>  	lock_cleanup_pop(vecs->lock);
> -	if (!pp)
> +	if (!pp) {
> +		/* If the path is blacklisted, print a debug/non-default verbosity message. */
> +		if (uev->udev) {
> +			int flag = DI_BLACKLIST | DI_SYSFS | DI_WWID;
> +			struct udev_device *udevice;
> +
> +			udevice = udev_device_ref(uev->udev);
> +			conf = get_multipath_config();
> +
> +			retval = path_discover(NULL, conf, udevice, flag);
> +
> +			put_multipath_config(conf);
> +			udev_device_unref(uev->udev);
> +
> +			if (retval == PATHINFO_SKIPPED) {
> +				condlog(3, "%s: spurious uevent, path blacklisted", uev->kernel);
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
> 2.7.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
