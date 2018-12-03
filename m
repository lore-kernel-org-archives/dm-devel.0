From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 23/24] domap(): never return DOMAP_RETRY
	in daemon mode
Date: Mon, 3 Dec 2018 17:45:48 -0600
Message-ID: <20181203234548.GA13270@octiron.msp.redhat.com>
References: <20181203193624.21870-1-mwilck@suse.com>
	<20181203193624.21870-6-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20181203193624.21870-6-mwilck@suse.com>
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

On Mon, Dec 03, 2018 at 08:36:23PM +0100, Martin Wilck wrote:
> DOMAP_RETRY is only used by the multipath tool. multipathd always treats
> it exactly like DOMAP_FAIL. Simplify logic by only returning
> DOMAP_RETRY in non-daemon mode from domap().
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 28 +++++++++++++---------------
>  multipathd/main.c        |  9 +--------
>  2 files changed, 14 insertions(+), 23 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 84ae5f56..1c549817 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -831,7 +831,7 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
>  		if (lock_multipath(mpp, 1)) {
>  			condlog(3, "%s: failed to create map (in use)",
>  				mpp->alias);
> -			return DOMAP_RETRY;
> +			return is_daemon ? DOMAP_FAIL : DOMAP_RETRY;
>  		}
>  
>  		sysfs_set_max_sectors_kb(mpp, 0);
> @@ -1110,20 +1110,18 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  
>  		r = domap(mpp, params, is_daemon);
>  
> -		if (r == DOMAP_FAIL || r == DOMAP_RETRY) {
> -			condlog(3, "%s: domap (%u) failure "
> -				   "for create/reload map",
> -				mpp->alias, r);
> -			if (r == DOMAP_FAIL || is_daemon) {
> -				condlog(2, "%s: %s map",
> -					mpp->alias, (mpp->action == ACT_CREATE)?
> -					"ignoring" : "removing");
> -				remove_map(mpp, vecs, 0);
> -				continue;
> -			} else /* if (r == DOMAP_RETRY && !is_daemon) */ {
> -				ret = CP_RETRY;
> -				goto out;
> -			}
> +		if (r == DOMAP_RETRY) {
> +			/* This happens in non-daemon case only */
> +			ret = CP_RETRY;
> +			goto out;
> +		}
> +
> +		if (r == DOMAP_FAIL) {
> +			condlog(2, "%s: domap failure, %s map",
> +				mpp->alias, (mpp->action == ACT_CREATE) ?
> +				"ignoring" : "removing");
> +			remove_map(mpp, vecs, 0);
> +			continue;
>  		}
>  		if (r == DOMAP_DRY)
>  			continue;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d0e7107c..1bf3c481 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -998,15 +998,8 @@ rescan:
>  	/*
>  	 * reload the map for the multipath mapped device
>  	 */
> -retry:
>  	ret = domap(mpp, params, 1);
> -	if (ret == DOMAP_FAIL || ret == DOMAP_RETRY) {
> -		if (ret < 0 && retries-- > 0) {
> -			condlog(0, "%s: retry domap for addition of new "
> -				"path %s", mpp->alias, pp->dev);
> -			sleep(1);
> -			goto retry;
> -		}
> +	if (ret == DOMAP_FAIL) {

I'm kind of conflicted about this change.  According to the commit
message (commit 1c50cd32), Hannes put this code in to deal with lock
contention on the paths (back when we used an exclusive lock in
lock_multipath(), and actually saw contention). I don't know of any
purpose for lock_multipath(), so removing this code probably won't hurt
anything. But if we believe that we need lock_multipath(), then we
should probably retry here (unless you have some understanding of
lock_multipath()'s purpose where retrying won't help).

If we do keep lock_multipath(), I definitely don't see a reason to retry
here if we got DOMAP_FAIL instead of DOMAP_RETRY, which means that
multipathd needs to continue to distingush between them.  On the other
hand, if we decide we don't need lock_multipath(), and thus DOMAP_RETRY,
then there's no point in coalesce_paths returning symbolic return
values, since we only have one non-failure return value.

Probably the most important question I have is "Does anyone know why we
lock the paths?" I believe that the code originally existed to keep
multipath and multipathd from trying to load a device at the same time.
It ended up causing problems with udev, because that tries to grab a
shared lock on the path while working on it.  When multipath switched to
using a shared lock (commit 5ec07b3a), I agreed based on the rational
that udev must be protecting against something, and we could need
protecting against the same thing. The discussion is at:

https://www.redhat.com/archives/dm-devel/2016-May/msg00009.html

But we've always seemed to be one step away from just removing this
code. I would be nice to either determine what we do need it for, or that we
don't need it at all.

-Ben

>  		condlog(0, "%s: failed in domap for addition of new "
>  			"path %s", mpp->alias, pp->dev);
>  		/*
> -- 
> 2.19.1
