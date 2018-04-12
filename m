From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v4 11/20] multipath -u: common code path for
 result message
Date: Thu, 12 Apr 2018 13:34:49 -0500
Message-ID: <20180412183449.GN3103@octiron.msp.redhat.com>
References: <20180404161627.6244-1-mwilck@suse.com>
	<20180404161627.6244-12-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180404161627.6244-12-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Julian Andres Klode <julian.klode@canonical.com>
List-Id: dm-devel.ids

On Wed, Apr 04, 2018 at 06:16:18PM +0200, Martin Wilck wrote:
> Print the result message in one place only. This simplifies
> future changes. multipath -c is also affected.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipath/main.c | 32 +++++++++++++++++++-------------
>  1 file changed, 19 insertions(+), 13 deletions(-)
> 
> diff --git a/multipath/main.c b/multipath/main.c
> index 2be9b9c..bf28735 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -350,6 +350,16 @@ out:
>  	return r;
>  }
>  
> +static int print_cmd_valid(const char *devpath, int k)
> +{
> +	if (k < 0 || k > 1)
> +		return 1;
> +
> +	printf("%s is%s a valid multipath device path\n",
> +	       devpath, k ? "" : " not");
> +	return k == 1;
> +}
> +
>  /*
>   * Return value:
>   *  -1: Retry
> @@ -391,10 +401,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  	    cmd != CMD_REMOVE_WWID &&
>  	    (filter_devnode(conf->blist_devnode,
>  			    conf->elist_devnode, dev) > 0)) {
> -		if (cmd == CMD_VALID_PATH)
> -			printf("%s is not a valid multipath device path\n",
> -			       devpath);
> -		goto out;
> +		goto print_valid;
>  	}
>  
>  	/*
> @@ -407,7 +414,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  		if (!refwwid) {
>  			condlog(4, "%s: failed to get wwid", devpath);
>  			if (failed == 2 && cmd == CMD_VALID_PATH)
> -				printf("%s is not a valid multipath device path\n", devpath);
> +				goto print_valid;
>  			else
>  				condlog(3, "scope is null");
>  			goto out;
> @@ -447,9 +454,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  			if (r == 0 ||
>  			    !find_multipaths_on(conf) ||
>  			    !ignore_wwids_on(conf)) {
> -				printf("%s %s a valid multipath device path\n",
> -				       devpath, r == 0 ? "is" : "is not");
> -				goto out;
> +				goto print_valid;
>  			}
>  		}
>  	}
> @@ -493,9 +498,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  		 * the refwwid, then the path is valid */
>  		if (VECTOR_SIZE(curmp) != 0 || VECTOR_SIZE(pathvec) > 1)
>  			r = 0;
> -		printf("%s %s a valid multipath device path\n",
> -		       devpath, r == 0 ? "is" : "is not");
> -		goto out;
> +		goto print_valid;
>  	}
>  
>  	if (cmd != CMD_CREATE && cmd != CMD_DRY_RUN) {
> @@ -509,6 +512,10 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  	r = coalesce_paths(&vecs, NULL, refwwid,
>  			   conf->force_reload, cmd);
>  
> +print_valid:
> +	if (cmd == CMD_VALID_PATH)
> +		r = print_cmd_valid(devpath, r);
> +
>  out:
>  	if (refwwid)
>  		FREE(refwwid);
> @@ -844,8 +851,7 @@ main (int argc, char *argv[])
>  		if (fd == -1) {
>  			condlog(3, "%s: daemon is not running", dev);
>  			if (!systemd_service_enabled(dev)) {
> -				printf("%s is not a valid "
> -				       "multipath device path\n", dev);
> +				r = print_cmd_valid(dev, 1);
>  				goto out;
>  			}
>  		} else
> -- 
> 2.16.1
