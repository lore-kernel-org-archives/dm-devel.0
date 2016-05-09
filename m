From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 4/7] devmapper: wait for udev in
	dm_simplecmd_noflush()
Date: Mon, 9 May 2016 12:57:17 -0500
Message-ID: <20160509175717.GZ26117@octiron.msp.redhat.com>
References: <1462791185-2903-1-git-send-email-hare@suse.de>
	<1462791185-2903-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1462791185-2903-5-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Mon, May 09, 2016 at 12:53:02PM +0200, Hannes Reinecke wrote:
> When calling dm_simplecmd_noflush() with udev_flags set we
> need to set the 'need_sync' flag otherwise the udev flags
> will never be set.

The other possibility here would be to temporarily disable udev sync
support, and then restore it afterwards. That way we could still pass
the flags, but we wouldn't need to wait on these table reloads.  Either
that or to get libdevmapper to give us a cookie flag that says, "while,
I do have sync support enabled, for this one command, I'd like to skip
it".  But neither of those options has any significant benefit over this
solution.

ACK.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  libmultipath/configure.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index b976da7..9c6904a 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -628,7 +628,7 @@ domap (struct multipath * mpp, char * params)
>  		r = dm_addmap_reload(mpp, params);
>  		if (r)
>  			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
> -						 0, MPATH_UDEV_RELOAD_FLAG);
> +						 1, MPATH_UDEV_RELOAD_FLAG);
>  		break;
>  
>  	case ACT_RESIZE:
> @@ -646,7 +646,9 @@ domap (struct multipath * mpp, char * params)
>  		if (r) {
>  			r = dm_addmap_reload(mpp, params);
>  			if (r)
> -				r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, 0, MPATH_UDEV_RELOAD_FLAG);
> +				r = dm_simplecmd_noflush(DM_DEVICE_RESUME,
> +							 mpp->alias, 1,
> +							 MPATH_UDEV_RELOAD_FLAG);
>  		}
>  		break;
>  
> -- 
> 2.6.6
