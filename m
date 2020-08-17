From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 81/84] multipath: check_path_valid():
 eliminate some failure modes
Date: Mon, 17 Aug 2020 16:56:11 -0500
Message-ID: <20200817215611.GJ19233@octiron.msp.redhat.com>
References: <20200812113601.26658-1-mwilck@suse.com>
	<20200812113601.26658-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200812113601.26658-2-mwilck@suse.com>
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

On Wed, Aug 12, 2020 at 01:35:58PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The memory allocations can fail, and pathvec is not needed until the
> path_discovery() call. Eliminate the failure modes by not setting up
> pathvec before it's actually needed.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 9d6b482..9e65070 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -637,15 +637,6 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
>  			 minor(devt));
>  	}
>  
> -	pathvec = vector_alloc();
> -	if (!pathvec)
> -		goto fail;
> -
> -	if (store_path(pathvec, pp) != 0) {
> -		free_path(pp);
> -		goto fail;
> -	}
> -
>  	if ((r == PATH_IS_VALID || r == PATH_IS_MAYBE_VALID) &&
>  	    released_to_systemd())
>  		r = PATH_IS_NOT_VALID;
> @@ -684,6 +675,15 @@ check_path_valid(const char *name, struct config *conf, bool is_uevent)
>  		goto out;
>  	}
>  
> +	pathvec = vector_alloc();
> +	if (!pathvec)
> +		goto fail;
> +
> +	if (store_path(pathvec, pp) != 0) {
> +		free_path(pp);
> +		goto fail;
> +	}
> +
>  	/* For find_multipaths = SMART, if there is more than one path
>  	 * matching the refwwid, then the path is valid */
>  	if (path_discovery(pathvec, DI_SYSFS | DI_WWID) < 0)
> -- 
> 2.28.0
