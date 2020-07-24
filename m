From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH V2] libmultipath: free pp if store_path fails
 in disassemble_map
Date: Fri, 24 Jul 2020 11:34:30 -0500
Message-ID: <20200724163430.GM11089@octiron.msp.redhat.com>
References: <40a7ea22-8897-363a-5821-99add9de6dc5@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <40a7ea22-8897-363a-5821-99add9de6dc5@huawei.com>
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
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Cc: yanxiaodan@huawei.com, linfeilong@huawei.com, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Fri, Jul 24, 2020 at 09:40:18AM +0800, Zhiqiang Liu wrote:
> In disassemble_map func, one pp will be allocated and stored in
> pgp->paths. However, if store_path fails, pp will not be freed,
> then memory leak problem occurs.
> 
> Here, we will call free_path to free pp when store_path fails.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
> V1->V2: update based on ups/submit-2007 branch.
> 
>  libmultipath/dmparser.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index b9858fa5..8a0501ba 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -143,6 +143,7 @@ int disassemble_map(const struct _vector *pathvec,
>  	int def_minio = 0;
>  	struct path * pp;
>  	struct pathgroup * pgp;
> +	int pp_alloc_flag = 0;
> 
>  	assert(pathvec != NULL);
>  	p = params;
> @@ -292,6 +293,7 @@ int disassemble_map(const struct _vector *pathvec,
> 
>  		for (j = 0; j < num_paths; j++) {
>  			pp = NULL;
> +			pp_alloc_flag = 0;
>  			p += get_word(p, &word);
> 
>  			if (!word)
> @@ -304,13 +306,16 @@ int disassemble_map(const struct _vector *pathvec,
> 
>  				if (!pp)
>  					goto out1;
> -
> +				pp_alloc_flag = 1;
>  				strlcpy(pp->dev_t, word, BLK_DEV_SIZE);
>  			}
>  			FREE(word);
> 
> -			if (store_path(pgp->paths, pp))
> +			if (store_path(pgp->paths, pp)) {
> +				if (pp_alloc_flag)
> +					free_path(pp);
>  				goto out;
> +			}
> 
>  			pgp->id ^= (long)pp;
>  			pp->pgindex = i + 1;
> -- 
> 2.24.0.windows.2
> 
