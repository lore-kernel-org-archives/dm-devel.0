From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 09/31] libmultipath: support
 MPATH_UDEV_NO_PATHS_FLAG on map creation
Date: Wed, 13 Sep 2017 15:33:03 -0500
Message-ID: <20170913203303.GK3145@octiron.msp.redhat.com>
References: <20170902223900.7339-1-mwilck@suse.com>
	<20170902223900.7339-10-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170902223900.7339-10-mwilck@suse.com>
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

On Sun, Sep 03, 2017 at 12:38:38AM +0200, Martin Wilck wrote:
> Some vendor kernels (e.g. SUSE) have supported loading multipath
> maps without valid paths for a long time. Without that feature,
> problems can occur in failover scenarios when multipathd tries
> to (re)load maps after device failure/removal, because multipathd's
> attempts to reload the configuration may fail unnecessarily.
> The discussion in the kernel community is ongoing
> (see e.g. https://patchwork.kernel.org/patch/4579551/).

I don't object to the patch itself, but I'm pretty sure that this
solution to multipath's reloading issues is not currently under
consideration upstream.  It got Naked, and I wrote and alternative
method, which got accepted

https://www.redhat.com/archives/dm-devel/2014-September/msg00094.html

Do you still need this patch? The solution that's currently upstream
doesn't allow you to load new devices with failed paths, but it avoids
the issues that caused the SUSE patch to get Nak'ed. The multipath
user-space code already won't allow you to create a multipath device if
it can't open the path device, so I don't see why you need the ability
for the kernel to allow creation of devices with only failed paths. I
admit, there is a small window where multipath could open the path
device, and then the path device could fail before the load is sent to
the kernel.  In this case, with your patch, you could still create the
device (I believe).  But the much more likely case, where the path has
failed before multipath tries to open it, is still there. I don't see
the benefit of adding code to fix the corner case, while the common case
still doesn't work. Is there some other case where your patch is helpful
that I'm missing?

At any rate. Even if that kernel patch doesn't go upstream, I have no
objection to changing the code so the udev rules are robust enough to
handle this situation.

ACK

-Ben

> 
> One corner case of this is creation of a map with only failed
> paths. Such maps can be created if the kernel patch mentioned above
> is applied. The current udev rules for dm-multipath can't detect
> this situation. This patch fixes that by setting
> DM_SUBSYSTEM_UDEV_FLAG2, which is already used for the "map reload"
> case with no valid paths. Thus no additional udev rules are required
> to detect this situation.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index e701e806..7a3390a7 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -300,12 +300,14 @@ dm_device_remove (const char *name, int needsync, int deferred_remove) {
>  
>  static int
>  dm_addmap (int task, const char *target, struct multipath *mpp,
> -	   char * params, int ro, int skip_kpartx) {
> +	   char * params, int ro, uint16_t udev_flags) {
>  	int r = 0;
>  	struct dm_task *dmt;
>  	char *prefixed_uuid = NULL;
>  	uint32_t cookie = 0;
> -	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
> +
> +	/* Need to add this here to allow 0 to be passed in udev_flags */
> +	udev_flags |= DM_UDEV_DISABLE_LIBRARY_FALLBACK;
>  
>  	if (!(dmt = libmp_dm_task_create (task)))
>  		return 0;
> @@ -371,15 +373,27 @@ addout:
>  	return r;
>  }
>  
> +static uint16_t build_udev_flags(const struct multipath *mpp, int reload)
> +{
> +	/* DM_UDEV_DISABLE_LIBRARY_FALLBACK is added in dm_addmap */
> +	return	(mpp->skip_kpartx == SKIP_KPARTX_ON ?
> +		 MPATH_UDEV_NO_KPARTX_FLAG : 0) |
> +		(mpp->nr_active == 0 ?
> +		 MPATH_UDEV_NO_PATHS_FLAG : 0) |
> +		(reload && !mpp->force_udev_reload ?
> +		 MPATH_UDEV_RELOAD_FLAG : 0);
> +}
> +
>  int dm_addmap_create (struct multipath *mpp, char * params)
>  {
>  	int ro;
> +	uint16_t udev_flags = build_udev_flags(mpp, 0);
>  
>  	for (ro = 0; ro <= 1; ro++) {
>  		int err;
>  
>  		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
> -			      mpp->skip_kpartx))
> +			      udev_flags))
>  			return 1;
>  		/*
>  		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
> @@ -405,11 +419,7 @@ int dm_addmap_create (struct multipath *mpp, char * params)
>  int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  {
>  	int r = 0;
> -	uint16_t udev_flags = ((mpp->force_udev_reload)?
> -			       0 : MPATH_UDEV_RELOAD_FLAG) |
> -			      ((mpp->skip_kpartx == SKIP_KPARTX_ON)?
> -			       MPATH_UDEV_NO_KPARTX_FLAG : 0) |
> -			      ((mpp->nr_active)? 0 : MPATH_UDEV_NO_PATHS_FLAG);
> +	uint16_t udev_flags = build_udev_flags(mpp, 1);
>  
>  	/*
>  	 * DM_DEVICE_RELOAD cannot wait on a cookie, as
> @@ -419,12 +429,12 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  	 */
>  	if (!mpp->force_readonly)
>  		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
> -			      ADDMAP_RW, SKIP_KPARTX_OFF);
> +			      ADDMAP_RW, 0);
>  	if (!r) {
>  		if (!mpp->force_readonly && errno != EROFS)
>  			return 0;
>  		r = dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp,
> -			      params, ADDMAP_RO, SKIP_KPARTX_OFF);
> +			      params, ADDMAP_RO, 0);
>  	}
>  	if (r)
>  		r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, !flush,
> -- 
> 2.14.0
