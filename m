From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V4 09/14] libmultipath: check whether
 mpp->features is NUll in setup_map
Date: Thu, 10 Sep 2020 18:48:56 +0200
Message-ID: <07b61c335cbdbd7c029474c92a5d6f156ef523e0.camel@suse.com>
References: <f8c2133b-6c02-4cc4-59cd-162828154689@huawei.com>
	<22e82157-f180-b95b-c72c-b7b13acf1c8a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <22e82157-f180-b95b-c72c-b7b13acf1c8a@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Thu, 2020-09-10 at 18:51 +0800, lixiaokeng wrote:
> In assemble_map func, f = STRDUP(mp->features) is just used
> for APPEND(). We can directly pass mp->features to APPEND().
> The mpp->features, hwhandler and selector got form strdup
> should be check after select* function.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>

Thanks for submitting the new version. Looking at your patch, I realize
that my previous suggestion wasn't perfect. 

> ---
>  libmultipath/configure.c |  5 +++++
>  libmultipath/dmparser.c  | 11 ++++-------
>  2 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 5bc65fd3..5d5d9415 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -355,6 +355,11 @@ int setup_map(struct multipath *mpp, char
> *params, int params_size,
>  	select_ghost_delay(conf, mpp);
>  	select_flush_on_last_del(conf, mpp);
> 
> +	if (!mpp->features || !mpp->hwhandler || !mpp->selector) {
> +		condlog(0, "%s: map select failed", mpp->alias);
> +		return 1;
> +	}
> +

We have a new failure mode for setup_map() here. While this is a good
thing in principle, there are issues. 

 1) by returning, we skip the rest of the initialization steps for the
map. Thus paths and pathgroups may be set up wrongly after setup_map().
 2) Not every caller deletes the map from the mpvec after setup_map()
fails. For some callers like resize_map() or reload_map(), that's
actually not possible.

1) is a minor problem because no caller calls domap() after setup_map()
failure, afaics. But 2) is a problem, because the broken, partially
initialized struct multipath will remain in our data structures, and my
assumption that features etc. are always valid will be violated.
2) is not a regression of this patch though, it has always been the
case.

I'm not yet decided how to deal with this. Perhaps setup_map()
shouldn't free features, hwhandler, and selector until the new values
have been successfully obtained.

(Actually, what's the point in running through *all* select_xyz()
functions just for a map resize?)

Ben?

Regards
Martin






>  	sysfs_set_scsi_tmo(mpp, conf->checkint);
>  	marginal_pathgroups = conf->marginal_pathgroups;
>  	pthread_cleanup_pop(1);
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 482e9d0e..685918da 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -65,7 +65,7 @@ assemble_map (struct multipath * mp, char * params,
> int len)
>  	int i, j;
>  	int minio;
>  	int nr_priority_groups, initial_pg_nr;
> -	char * p, * f;
> +	char * p;
>  	const char *const end = params + len;
>  	char no_path_retry[] = "queue_if_no_path";
>  	char retain_hwhandler[] = "retain_attached_hw_handler";
> @@ -86,10 +86,9 @@ assemble_map (struct multipath * mp, char *
> params, int len)
>  	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
>  		add_feature(&mp->features, retain_hwhandler);
> 
> -	f = STRDUP(mp->features);
> -
> -	APPEND(p, end, "%s %s %i %i", f, mp->hwhandler,
> nr_priority_groups,
> -	       initial_pg_nr);
> +	/* mp->features must not be NULL */
> +	APPEND(p, end, "%s %s %i %i", mp->features, mp->hwhandler,
> +		nr_priority_groups, initial_pg_nr);
> 
>  	vector_foreach_slot (mp->pg, pgp, i) {
>  		pgp = VECTOR_SLOT(mp->pg, i);
> @@ -110,12 +109,10 @@ assemble_map (struct multipath * mp, char *
> params, int len)
>  		}
>  	}
> 
> -	FREE(f);
>  	condlog(4, "%s: assembled map [%s]", mp->alias, params);
>  	return 0;
> 
>  err:
> -	FREE(f);
>  	return 1;
>  }
> 
