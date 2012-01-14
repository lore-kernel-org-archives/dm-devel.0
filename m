From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: don't remove dm device on remove
 uevent
Date: Sat, 14 Jan 2012 12:21:41 +0100
Message-ID: <1326540101.3211.1.camel@lapoo.opensvc.com>
References: <20120113041721.GM1241@ether.msp.redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120113041721.GM1241@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On jeu., 2012-01-12 at 22:17 -0600, Benjamin Marzinski wrote:
> multipathd gets remove uevents for dm devices when the devices have
> been removed.  It shouldn't try to actually remove the device itself,
> since that has already been done, or it wouldn't have gotten the uevent.
> 
Applied.

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  multipathd/main.c |   22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> Index: multipath-tools-111219/multipathd/main.c
> ===================================================================
> --- multipath-tools-111219.orig/multipathd/main.c
> +++ multipath-tools-111219/multipathd/main.c
> @@ -310,7 +310,8 @@ static int
>  uev_remove_map (struct uevent * uev, struct vectors * vecs)
>  {
>  	char *alias;
> -	int minor, rc;
> +	int minor;
> +	struct multipath *mpp;
>  
>  	condlog(2, "%s: remove map (uevent)", uev->kernel);
>  	alias = uevent_get_dm_name(uev);
> @@ -319,9 +320,24 @@ uev_remove_map (struct uevent * uev, str
>  		return 0;
>  	}
>  	minor = uevent_get_minor(uev);
> -	rc = ev_remove_map(uev->kernel, alias, minor, vecs);
> +	mpp = find_mp_by_minor(vecs->mpvec, minor);
> +
> +	if (!mpp) {
> +		condlog(2, "%s: devmap not registered, can't remove",
> +			uev->kernel);
> +		goto out;
> +	}
> +	if (strcmp(mpp->alias, alias)) {
> +		condlog(2, "%s: minor number mismatch (map %d, event %d)",
> +			mpp->alias, mpp->dmi->minor, minor);
> +		goto out;
> +	}
> +
> +	orphan_paths(vecs->pathvec, mpp);
> +	remove_map_and_stop_waiter(mpp, vecs, 1);
> +out:
>  	FREE(alias);
> -	return rc;
> +	return 0;
>  }
>  
>  int
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
