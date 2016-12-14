From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 3/3] multipathd: skip spurious event
 message for blacklisted paths
Date: Wed, 14 Dec 2016 08:05:30 +0100
Message-ID: <d2911aa6-39b7-5d4d-5fc9-3d2feac4dddb@suse.de>
References: <1481680921-6489-1-git-send-email-mauricfo@linux.vnet.ibm.com>
	<1481680921-6489-3-git-send-email-mauricfo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1481680921-6489-3-git-send-email-mauricfo@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>, dm-devel@redhat.com, bmarzins@redhat.com, christophe.varoqui@opensvc.com
List-Id: dm-devel.ids

On 12/14/2016 03:02 AM, Mauricio Faria de Oliveira wrote:
> Currently, multipath still prints the 'spurious uevent, path not found'
> message if a path is blacklisted by something different than a devnode
> in the 'change' uevent handling. (uev_trigger() calls filter_devnode()).
>
> Thus blacklisting by vendor/product, wwid, and udev property still get
> that message in the system log for paths that are explicitly marked to
> be ignored (since it's verbosity level 0).
>
> This problem happens on common scenarios such as creating filesystems
> on a blacklisted device (e.g., mkfs.* /dev/sdX), which is usually run
> several times on test environments, and the error message may mislead
> the error checker/monitor tools with false negatives.
>
> This patch resolves this by checking alloc_path_with_pathinfo()
> for PATHINFO_SKIPPED with just enough device information flags for
> blacklist verification -- and it prints a debug message (verbosity
> level 3) instead of an error message since this case is not an error.
>
> Even though this introduces a bit of overhead (to get the path info),
> it only happens in a corner case of an error path; so, not a problem.
>
> Test-cases (on QEMU):
> ----------
>
> Several versions of /etc/multipath.conf:
>
>   blacklist {
>       devnode "sdb"
>   }
>
>   blacklist {
>       property "ID_SERIAL"
>   }
>
>   blacklist {
>       wwid "0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1"
>   }
>
>   blacklist {
>       device {
>           vendor "QEMU"
>       }
>   }
>
> Either command can be used to generate a 'change' uevent:
>
>   # echo change > /sys/block/sdb/uevent
>
>   # mkfs.ext3 -F /dev/sdb
>
> The output of multipathd is monitored with:
>
>   # multipathd -d -s
>   ...
>
> Without the patch, only the devnode blacklisting is silent;
> all other cases (property, wwid, device) print the message:
>
>   sdb: spurious uevent, path not found
>
> With the patch applied, no message is printed by default
> (that is, verbosity level 2) in any case.
>
> With verbosity level 3 (debug), the following messages
> are printed, according to the performed test-case:
>
>   sdb: udev property ID_SERIAL blacklisted
>   sdb: spurious uevent, path is blacklisted
>
>   sdb: wwid 0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-1 blacklisted
>   sdb: spurious uevent, path is blacklisted
>
>   (null): (QEMU:QEMU HARDDISK) vendor/product blacklisted
>   sdb: spurious uevent, path is blacklisted
>
> Reported-by: Yueh Chyong (Ida) Jackson <idaj@us.ibm.com>
> Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
> ---
>  multipathd/main.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d6f081f2f83a..ee7a410e4782 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1010,8 +1010,29 @@ uev_update_path (struct uevent *uev, struct vector=
s * vecs)
>  	}
>  out:
>  	lock_cleanup_pop(vecs->lock);
> -	if (!pp)
> +	if (!pp) {
> +		/*
> +		 *  If the path is blacklisted, print a debug/non-default verbosity me=
ssage.
> +		 *  - filter_devnode()	- checked by uev_trigger() (caller);
> +		 *  - filter_device()	- checked by pathinfo() (DI_BLACKLIST | DI_SYSFS=
);
> +		 *  - filter_wwid()	- checked by pathinfo() (DI_BLACKLIST | DI_WWID);
> +		 *  - filter_property()	- checked by pathinfo() (DI_BLACKLIST)
> +		 */
> +		if (uev->udev) {
> +			int flag =3D DI_SYSFS | DI_WWID;
> +
> +			conf =3D get_multipath_config();
> +			retval =3D alloc_path_with_pathinfo(conf, uev->udev, flag, NULL);
> +			put_multipath_config(conf);
> +
> +			if (retval =3D=3D PATHINFO_SKIPPED) {
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
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
