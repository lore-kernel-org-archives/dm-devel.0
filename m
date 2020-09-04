From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 09/14] libmultipath: check whether
 mp->features is NULl in, assemble_map
Date: Fri, 4 Sep 2020 16:30:48 -0500
Message-ID: <20200904213048.GE11108@octiron.msp.redhat.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<40cf77df-eaa3-fb72-69fd-9f865d12dc34@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <40cf77df-eaa3-fb72-69fd-9f865d12dc34@huawei.com>
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
To: lixiaokeng <lixiaokeng@huawei.com>
Cc: linfeilong <linfeilong@huawei.com>, dm-devel mailing list <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, Sep 02, 2020 at 03:21:15PM +0800, lixiaokeng wrote:
> In assemble_map func, if add_feature fails and mp->features is
> default value (NULL), STRDUP(mp->features) will cause a seg-fault.
> In addition, f = STRDUP(mp->features) is just used for APPEND().
> We can directly pass mp->features to APPEND().
> 
> Here, we firstly check whether mp->features is null.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  libmultipath/dmparser.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index 482e9d0e..12182bf5 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -65,7 +65,7 @@ assemble_map (struct multipath * mp, char * params, int len)
>  	int i, j;
>  	int minio;
>  	int nr_priority_groups, initial_pg_nr;
> -	char * p, * f;
> +	char * p;
>  	const char *const end = params + len;
>  	char no_path_retry[] = "queue_if_no_path";
>  	char retain_hwhandler[] = "retain_attached_hw_handler";
> @@ -86,9 +86,12 @@ assemble_map (struct multipath * mp, char * params, int len)
>  	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0))
>  		add_feature(&mp->features, retain_hwhandler);
> 
> -	f = STRDUP(mp->features);

clearly strdup()ing without checking if mp->features NULL is incorrect.
However, I'm not sure that we need to fail if mp->features is NULL.
instead, int the APPEND call, we could use the gcc ternary operator
extension

(mp->features)?: "0"

to use "0" if mp->features is NULL.

Also, have you seen this actually occur?  Or is this just a theoretical
issue that you've found from reading the code.  It seems like
setup_map() will always call select_features() before calling
assemble_map(), which should mean that mp->features will always be set
in this case. Perhaps I'm missing something here.

-Ben

> +	if (!mp->features) {
> +		condlog(0, "mp->features is still NULL.");
> +		goto err;
> +	}
> 
> -	APPEND(p, end, "%s %s %i %i", f, mp->hwhandler, nr_priority_groups,
> +	APPEND(p, end, "%s %s %i %i", mp->features, mp->hwhandler, nr_priority_groups,
>  	       initial_pg_nr);
> 
>  	vector_foreach_slot (mp->pg, pgp, i) {
> @@ -110,12 +113,10 @@ assemble_map (struct multipath * mp, char * params, int len)
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
> -- 
