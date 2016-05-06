From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/6] libmultipath: pass in 'cookie' as
 argument for dm_addmap()
Date: Fri, 6 May 2016 14:27:26 -0500
Message-ID: <20160506192726.GS26117@octiron.msp.redhat.com>
References: <1462341450-5507-1-git-send-email-hare@suse.de>
	<1462341450-5507-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1462341450-5507-3-git-send-email-hare@suse.de>
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
Cc: dm-devel@redhat.com, Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

On Wed, May 04, 2016 at 07:57:26AM +0200, Hannes Reinecke wrote:
> Instead of generating the cookie internally we should be
> passing in the cookie to dm_addmap().

Like I said in my comment to the last patch, you should never reuse a
cookie value once you've waited for it.  The only reason that this one
doesn't break is that multipath's cookie handling was already broken.
It got broken in this commit 4a2431aa944eb2e5b6f3ccd2d4fe1df67f9e5679
"Fixup device-mapper 'cookie' handling".

The thing that broke it was calling dm_udev_complete() instead of
dm_udev_wait() when dm_task_run() fails.  If dm_task_run() fails,
device-mapper will call dm_udev_complete() internally. However that
doesn't clean up the cookie.  The cookie won't be cleaned up until the
someone calls dm_udev_wait().  This won't actually wait for anything
since the cookie count has already been decremented, but it is necessary
for cleanup.

confusingly

# dmsetup udevcomplete_all

also cleans up the cookies, while

# dmsetup udevcomplete

doesn't.

You can easily see that multipath's udev cookie handling is currently
broken.  Just mount a path device, so that multipath will fail in
creating a multipath device with it, and then run

# multipath
# dmsetup udevcookies

and you will see a cooke with a value of 0, that is still sitting
around, because nobody has waited on it.  Because of that bug, this
patch doesn't break anything. The cookie you reuse is still around
because it hasn't been waited on, and you are able to increment it.
Once we replace the dm_udev_complete() calls with dm_udev_waits(), this
patch will start breaking things.

And again, while we could just reset the cookie to zero, and it wouldn't
break anything, we've just added a parameter that must always be set to
zero, and needlessly extended the cookie code outside of dm_addmap,
where it can all be contained.

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/devmapper.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 48e7d50..ab71fda 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -274,11 +274,10 @@ dm_device_remove (const char *name, int needsync, int deferred_remove) {
>  
>  static int
>  dm_addmap (int task, const char *target, struct multipath *mpp,
> -	   char * params, int ro) {
> +	   char * params, int ro, uint32_t *cookie) {
>  	int r = 0;
>  	struct dm_task *dmt;
>  	char *prefixed_uuid = NULL;
> -	uint32_t cookie = 0;
>  
>  	if (!(dmt = dm_task_create (task)))
>  		return 0;
> @@ -319,18 +318,18 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  	dm_task_no_open_count(dmt);
>  
>  	if (task == DM_DEVICE_CREATE &&
> -	    !dm_task_set_cookie(dmt, &cookie,
> +	    !dm_task_set_cookie(dmt, cookie,
>  				DM_UDEV_DISABLE_LIBRARY_FALLBACK)) {
> -		dm_udev_complete(cookie);
> +		dm_udev_complete(*cookie);
>  		goto freeout;
>  	}
>  	r = dm_task_run (dmt);
>  
>  	if (task == DM_DEVICE_CREATE) {
>  		if (!r)
> -			dm_udev_complete(cookie);
> +			dm_udev_complete(*cookie);
>  		else
> -			dm_udev_wait(cookie);
> +			dm_udev_wait(*cookie);
>  	}
>  	freeout:
>  	if (prefixed_uuid)
> @@ -345,11 +344,13 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  extern int
>  dm_addmap_create (struct multipath *mpp, char * params) {
>  	int ro;
> +	uint32_t cookie = 0;
>  
>  	for (ro = 0; ro <= 1; ro++) {
>  		int err;
>  
> -		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro))
> +		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH,
> +			      mpp, params, ro, &cookie))
>  			return 1;
>  		/*
>  		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
> @@ -374,11 +375,15 @@ dm_addmap_create (struct multipath *mpp, char * params) {
>  
>  extern int
>  dm_addmap_reload (struct multipath *mpp, char *params) {
> -	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RW))
> +	uint32_t cookie = 0;
> +
> +	if (dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
> +		      ADDMAP_RW, &cookie))
>  		return 1;
>  	if (errno != EROFS)
>  		return 0;
> -	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params, ADDMAP_RO);
> +	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, params,
> +			 ADDMAP_RO, &cookie);
>  }
>  
>  extern int
> -- 
> 2.6.6
