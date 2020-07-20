From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 42/42] libmultipath: dm_addmap(): refuse
 creating map with empty WWID
Date: Mon, 20 Jul 2020 16:11:00 -0500
Message-ID: <20200720211100.GE11089@octiron.msp.redhat.com>
References: <20200709103513.8142-1-mwilck@suse.com>
	<20200709103513.8142-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709103513.8142-4-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jul 09, 2020 at 12:35:13PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> We already avoid creating maps with empty WWID in coalesce_paths()
> as well as in ev_add_path(). The only code path where it's difficult
> to prove (although extremely unlikely) that we can't call
> dm_addmap(ACT_CREATE) with an empty WWID is update_path_groups()->
> reload_map(). To make the code easier to review and avoid ugly
> corner cases, simply refuse to create maps with a zero-length
> WWID.
> 

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index a177a54..fb7675c 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -352,6 +352,12 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  	char *prefixed_uuid = NULL;
>  	uint32_t cookie = 0;
>  
> +	if (task == DM_DEVICE_CREATE && strlen(mpp->wwid) == 0) {
> +		condlog(1, "%s: refusing to create map with empty WWID",
> +			mpp->alias);
> +		return 0;
> +	}
> +
>  	/* Need to add this here to allow 0 to be passed in udev_flags */
>  	udev_flags |= DM_UDEV_DISABLE_LIBRARY_FALLBACK;
>  
> @@ -368,18 +374,16 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  		dm_task_set_ro(dmt);
>  
>  	if (task == DM_DEVICE_CREATE) {
> -		if (strlen(mpp->wwid) > 0) {
> -			prefixed_uuid = MALLOC(UUID_PREFIX_LEN +
> -					       strlen(mpp->wwid) + 1);
> -			if (!prefixed_uuid) {
> -				condlog(0, "cannot create prefixed uuid : %s",
> -					strerror(errno));
> -				goto addout;
> -			}
> -			sprintf(prefixed_uuid, UUID_PREFIX "%s", mpp->wwid);
> -			if (!dm_task_set_uuid(dmt, prefixed_uuid))
> -				goto freeout;
> +		prefixed_uuid = MALLOC(UUID_PREFIX_LEN +
> +				       strlen(mpp->wwid) + 1);
> +		if (!prefixed_uuid) {
> +			condlog(0, "cannot create prefixed uuid : %s",
> +				strerror(errno));
> +			goto addout;
>  		}
> +		sprintf(prefixed_uuid, UUID_PREFIX "%s", mpp->wwid);
> +		if (!dm_task_set_uuid(dmt, prefixed_uuid))
> +			goto freeout;
>  		dm_task_skip_lockfs(dmt);
>  #ifdef LIBDM_API_FLUSH
>  		dm_task_no_flush(dmt);
> -- 
> 2.26.2
