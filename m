From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v3 86/87] libmultipath: adopt_paths(): set
 pp->mpp only on success
Date: Wed, 19 Aug 2020 17:15:52 -0500
Message-ID: <20200819221552.GU19233@octiron.msp.redhat.com>
References: <20200819131819.13493-1-mwilck@suse.com>
	<20200819131819.13493-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200819131819.13493-4-mwilck@suse.com>
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

On Wed, Aug 19, 2020 at 03:18:18PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Make sure that pp->mpp is only set for paths that have been
> successfully added to mpp->paths.
> 
> Suggested-by: Benjamin Marzinki <bmarzins@redhat.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/structs_vec.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 2d85df9..cc2dafa 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -248,14 +248,10 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
>  					pp->dev, mpp->alias);
>  				continue;
>  			}
> -			pp->mpp = mpp;
>  			if (pp->initialized == INIT_REMOVED)
>  				continue;
> -			condlog(3, "%s: ownership set to %s",
> -				pp->dev, mpp->alias);
> -
>  			if (!mpp->paths && !(mpp->paths = vector_alloc()))
> -				return 1;
> +				goto err;
>  
>  			conf = get_multipath_config();
>  			pthread_cleanup_push(put_multipath_config, conf);
> @@ -270,10 +266,17 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
>  
>  			if (!find_path_by_devt(mpp->paths, pp->dev_t) &&
>  			    store_path(mpp->paths, pp))
> -					return 1;
> +				goto err;
> +
> +			pp->mpp = mpp;
> +			condlog(3, "%s: ownership set to %s",
> +				pp->dev, mpp->alias);
>  		}
>  	}
>  	return 0;
> +err:
> +	condlog(1, "error setting ownership of %s to %s", pp->dev, mpp->alias);
> +	return 1;
>  }
>  
>  void orphan_path(struct path *pp, const char *reason)
> -- 
> 2.28.0
