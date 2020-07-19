From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 66/74] libmultipath: update_pathvec_from_dm:
 handle pp->mpp mismatch
Date: Sun, 19 Jul 2020 00:12:00 -0500
Message-ID: <20200719051200.GX11089@octiron.msp.redhat.com>
References: <20200709105145.9211-1-mwilck@suse.com>
	<20200709105145.9211-14-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200709105145.9211-14-mwilck@suse.com>
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

On Thu, Jul 09, 2020 at 12:51:37PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Treat this like a WWID mismatch.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs_vec.c | 37 +++++++++++++++++++++++--------------
>  1 file changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 5dd37d5..8651b98 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -118,6 +118,12 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
>  			goto delete_pg;
>  
>  		vector_foreach_slot(pgp->paths, pp, j) {
> +
> +			if (pp->mpp && pp->mpp != mpp) {
> +				condlog(0, "BUG: %s: found path %s which is already in %s",
> +					mpp->alias, pp->dev, pp->mpp->alias);
> +				goto bad_path;
> +			}
>  			pp->mpp = mpp;
>  
>  			if (pp->udev) {
> @@ -163,25 +169,28 @@ bool update_pathvec_from_dm(vector pathvec, struct multipath *mpp,
>  
>  					condlog(0, "%s: path %s WWID %s doesn't match, removing from map",
>  						mpp->wwid, pp->dev_t, pp->wwid);
> -					/*
> -					 * This path exists, but in the wong map.
> -					 * We can't reload the map from here.
> -					 * Instead, treat this path like "missing udev",
> -					 * which it probably is.
> -					 * check_path() will trigger an uevent
> -					 * and reset pp->tick.
> -					 */
> -					must_reload = true;
> -					pp->mpp = NULL;
> -					dm_fail_path(mpp->alias, pp->dev_t);
> -					vector_del_slot(pgp->paths, j--);
> -					pp->initialized = INIT_MISSING_UDEV;
> -					pp->tick = 1;
> +					goto bad_path;
>  				}
>  				condlog(2, "%s: adding new path %s",
>  					mpp->alias, pp->dev);
>  				store_path(pathvec, pp);
> +
>  			}
> +			continue;
> +
> +		bad_path:
> +			/*
> +			 * This path exists, but in the wrong map.
> +			 * We can't reload the map from here.
> +			 * Instead, treat this path like "missing udev".
> +			 * check_path() will trigger an uevent and reset pp->tick.
> +			 */
> +			must_reload = true;
> +			pp->mpp = NULL;
> +			dm_fail_path(mpp->alias, pp->dev_t);
> +			vector_del_slot(pgp->paths, j--);
> +			pp->initialized = INIT_MISSING_UDEV;
> +			pp->tick = 1;

Is there a reason not to call orphan_path() to clean up things like any
open fd, until we figure out what to do with the path.

>  		}
>  		if (VECTOR_SIZE(pgp->paths) != 0)
>  			continue;
> -- 
> 2.26.2
