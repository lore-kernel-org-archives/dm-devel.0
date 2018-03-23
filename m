From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 06/20] libmultipath: trigger path uevent
 only when necessary
Date: Fri, 23 Mar 2018 12:58:38 -0500
Message-ID: <20180323175838.GJ3103@octiron.msp.redhat.com>
References: <20180319150155.5363-1-mwilck@suse.com>
	<20180319150155.5363-7-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180319150155.5363-7-mwilck@suse.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 19, 2018 at 04:01:41PM +0100, Martin Wilck wrote:
> Paths that are already classified as DM_MULTIPATH_DEVICE_PATH don't
> need to be retriggered.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 245bd11672cb..838d145a5aa2 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -456,8 +456,20 @@ trigger_paths_udev_change(const struct multipath *mpp)
>  		if (!pgp->paths)
>  			continue;
>  		vector_foreach_slot(pgp->paths, pp, j) {
> +			const char *env;
> +
>  			if (!pp->udev)
>  				continue;
> +			/*
> +			 * Paths that are already classified as multipath
> +			 * members don't need another uevent.
> +			 */
> +			env = udev_device_get_property_value(
> +				pp->udev, "DM_MULTIPATH_DEVICE_PATH");
> +			if (env != NULL && !strcmp(env, "1"))
> +					continue;
> +
> +			condlog(4, "triggering change uevent for %s", pp->dev);
>  			sysfs_attr_set_value(pp->udev, "uevent", "change",
>  					     strlen("change"));
>  		}
> -- 
> 2.16.1
