From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath [PATCH] multipathd adding devices.
Date: Thu, 2 Mar 2006 12:09:31 +0100
Message-ID: <20060302110931.GB14155@pundit>
References: <20060225023329.GB18957@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20060225023329.GB18957@ether.msp.redhat.com>
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
List-Id: dm-devel.ids

On Fri, Feb 24, 2006 at 08:33:29PM -0600, Benjamin Marzinski wrote:
> The way multipathd currently works, if you add a map that isn't known to
> device mapper from multipathd, the first time you run the command, it won't
> add the map to the mpvec vector.  With the attached patch, multipathd will
> initialize the map and add it to the mpvec vector.
> 
How does the current behaviour affects you ?
Is this about races between DM and netlink events ?

Regards,
cvaroqui

> diff -urpN mp-devel-clean/multipathd/main.c mp-devel-patched/multipathd/main.c
> --- mp-devel-clean/multipathd/main.c	2006-02-23 17:33:58.000000000 -0600
> +++ mp-devel-patched/multipathd/main.c	2006-02-24 21:16:17.000000000 -0600
> @@ -550,6 +550,7 @@ ev_add_map (char * devname, struct vecto
>  	char * alias;
>  	char * refwwid;
>  	struct multipath * mpp;
> +	vector mpvec;
>  	int map_present;
>  	int r = 1;
>  
> @@ -597,10 +598,33 @@ ev_add_map (char * devname, struct vecto
>  	refwwid = get_refwwid(devname, DEV_DEVMAP, vecs->pathvec);
>  
>  	if (refwwid) {
> -		r = coalesce_paths(vecs, NULL, refwwid);
> +		int i;
> +		if (!(mpvec = vector_alloc()))
> +			goto out;
> +		r = coalesce_paths(vecs, mpvec, refwwid);
>  		dm_lib_release();
> +		if (r)
> +			goto out_free;
> +		r = 1;
> +		vector_foreach_slot(mpvec, mpp, i){
> +			if (!vector_alloc_slot(vecs->mpvec)) {
> +				orphan_paths(vecs->pathvec, mpp);
> +				free_multipath(mpp, KEEP_PATHS);
> +				goto out_free;
> +			}
> +			vector_set_slot(vecs->mpvec, mpp);
> +			sync_map_state(mpp);
> +			if (setup_multipath(vecs, mpp))
> +				goto out_free;
> +			if (start_waiter_thread(mpp, vecs))
> +				goto out_free;
> +			r = 0;
> +		}
>  	}
>  	
> +out_free:
> +	vector_free(mpvec);
> +out:
>  	if (!r)
>  		condlog(3, "%s: devmap %s added", alias, devname);
>  	else

> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
