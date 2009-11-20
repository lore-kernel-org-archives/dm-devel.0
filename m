From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] multipath-tools: multipath should allow
	only path with valid size to get added in the map
Date: Fri, 20 Nov 2009 13:57:15 -0800
Message-ID: <1258754235.20768.1.camel@chandra-ubuntu>
References: <0D1E8821739E724A86F4D16902CE275C1C93C74DFE@inbmail01.lsi.com>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93C74DFE@inbmail01.lsi.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>, "Stankey,
	Robert" <Robert.Stankey@lsi.com>, "sekharan@linux.vnet.ibm.com" <sekharan@linux.vnet.ibm.com>, "Moger, Babu" <Babu.Moger@lsi.com>
List-Id: dm-devel.ids

Looks good to me except one comment below.

On Fri, 2009-11-20 at 20:38 +0530, Chauhan, Vijay wrote:
> Hi,
> 
> If READ_CAPACITY fails during device discovery, sd device gets attached with device size 0. Currently multipath discover these paths and adds into the map. RDAC patch checker sends inquiry on each path to check path status, which eventually marks this path as up. If this path is from owning controller then mode select will be issued to switch the pathgroup. But any I/O sent to this path(path with size 0) will eventually fail in sd_prep_fn due to incorrect device size and resulting to ping pong between pathgroups.  We should only allow valid paths to get added in the map. Below patch checks two cases before adding paths; i.e.:
> 	1) device size of path is not 0
> 	2) there is no mismatch between mpp size and new path size.
> 
> 
> Thanks,
> Vijay
> 
> ----
> multipath should only add paths with valid size to the map. If there is mismatch between map and path size it should not be added. This patch also check if the device size is not 0 before adding path. During device discovery if READ_CAPACITY fails, sd device get attached with device size 0. multipath should not allow the such device to get added in the map.
> 
> Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> 
> ---
> 
> diff -uprN multipath-tools-orig/multipathd/main.c multipath-tools/multipathd/main.c
> --- multipath-tools-orig/multipathd/main.c	2009-11-20 23:39:09.000000000 +0530
> +++ multipath-tools/multipathd/main.c	2009-11-21 01:09:16.000000000 +0530
> @@ -398,6 +398,17 @@ ev_add_path (char * devname, struct vect
>  	mpp = pp->mpp = find_mp_by_wwid(vecs->mpvec, pp->wwid);
>  rescan:
>  	if (mpp) {
> +			if ((!pp->size) || (mpp->size != pp->size)) {
> +				condlog(0, "%s: failed to add new path %s, "
> +					"device size mismatch",

Appropriate error message for the two different cases (pp->size = 0 and
mpp->size!= pp->size) would be the right thing to do, IMO.

> +					devname, pp->dev);
> +				int i = find_slot(vecs->pathvec, (void *)pp);
> +				if (i != -1)
> +					vector_del_slot(vecs->pathvec, i);
> +				free_path(pp);
> +				return 1;
> +			}
> +
>  		condlog(4,"%s: adopting all paths for path %s",
>  			mpp->alias, pp->dev);
>  		if (adopt_paths(vecs->pathvec, mpp))
> @@ -408,6 +419,16 @@ rescan:
>  		mpp->action = ACT_RELOAD;
>  	}
>  	else {
> +		if (!pp->size) {
> +			condlog(0, "%s: failed to create new map,"
> +				" %s device size is 0 ", devname, pp->dev);
> +			int i = find_slot(vecs->pathvec, (void *)pp);
> +			if (i != -1)
> +				vector_del_slot(vecs->pathvec, i);
> +			free_path(pp);
> +			return 1;
> +		}
> +
>  		condlog(4,"%s: creating new map", pp->dev);
>  		if ((mpp = add_map_with_path(vecs, pp, 1)))
>  			mpp->action = ACT_CREATE;
> 
> --
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
