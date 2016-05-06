From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 5/6] devmapper: do not flush I/O for
	DM_DEVICE_CREATE
Date: Fri, 6 May 2016 15:18:29 -0500
Message-ID: <20160506201829.GV26117@octiron.msp.redhat.com>
References: <1462341450-5507-1-git-send-email-hare@suse.de>
	<1462341450-5507-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1462341450-5507-6-git-send-email-hare@suse.de>
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

On Wed, May 04, 2016 at 07:57:29AM +0200, Hannes Reinecke wrote:
> DM_DEVICE_CREATE loads a new table, so there cannot be any
> I/O pending. Hence we should be setting the 'no flush'
> and 'skip lockfs' flag to avoid delays during creation.

ACK

-Ben

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/devmapper.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 04dcb72..0ae72fc 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -294,16 +294,23 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  	if (ro)
>  		dm_task_set_ro(dmt);
>  
> -	if ((task == DM_DEVICE_CREATE) && strlen(mpp->wwid) > 0){
> -		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(mpp->wwid) + 1);
> -		if (!prefixed_uuid) {
> -			condlog(0, "cannot create prefixed uuid : %s",
> -				strerror(errno));
> -			goto addout;
> +	if (task == DM_DEVICE_CREATE) {
> +		if (strlen(mpp->wwid) > 0) {
> +			prefixed_uuid = MALLOC(UUID_PREFIX_LEN +
> +					       strlen(mpp->wwid) + 1);
> +			if (!prefixed_uuid) {
> +				condlog(0, "cannot create prefixed uuid : %s",
> +					strerror(errno));
> +				goto addout;
> +			}
> +			sprintf(prefixed_uuid, UUID_PREFIX "%s", mpp->wwid);
> +			if (!dm_task_set_uuid(dmt, prefixed_uuid))
> +				goto freeout;
>  		}
> -		sprintf(prefixed_uuid, UUID_PREFIX "%s", mpp->wwid);
> -		if (!dm_task_set_uuid(dmt, prefixed_uuid))
> -			goto freeout;
> +		dm_task_skip_lockfs(dmt);
> +#ifdef LIBDM_API_FLUSH
> +		dm_task_no_flush(dmt);
> +#endif
>  	}
>  
>  	if (mpp->attribute_flags & (1 << ATTR_MODE) &&
> -- 
> 2.6.6
