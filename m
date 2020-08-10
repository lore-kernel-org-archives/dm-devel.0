From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2] libmultipath: free pp if store_path fails
 in disassemble_map
Date: Mon, 10 Aug 2020 14:20:27 +0200
Message-ID: <7d0e4a58ddec95d141433c5f472865cba6961459.camel@suse.com>
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
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, christophe.varoqui@opensvc.com, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong@huawei.com, yanxiaodan@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Hello Liu,

On Fri, 2020-07-24 at 09:40 +0800, Zhiqiang Liu wrote:
> In disassemble_map func, one pp will be allocated and stored in
> pgp->paths. However, if store_path fails, pp will not be freed,
> then memory leak problem occurs.
> 
> Here, we will call free_path to free pp when store_path fails.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
> V1->V2: update based on ups/submit-2007 branch.
> 
>  libmultipath/dmparser.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 

thanks for the patch. I'd suggest to do this without the pp_alloc_flag
variable, by pulling the store_path() call into the if (!pp)
conditional and treating failure differently in both branches of the
conditional. (Side note: if we introduce a boolean like this, we should
use "bool" as the variable type).

Unless you object, I'll add that change on top of my submit-2007
series, giving you appropriate credits.

@Ben, @Christophe: I've been considering for some time to start
handling cases like this with __attribute__((cleanup(f)))) (
https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html).
That could reduce the amount of goto clauses for error handling
significantly. It would be a major change in coding style though. What
do you think?

Regards,
Martin


> diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
> index b9858fa5..8a0501ba 100644
> --- a/libmultipath/dmparser.c
> +++ b/libmultipath/dmparser.c
> @@ -143,6 +143,7 @@ int disassemble_map(const struct _vector
> *pathvec,
>  	int def_minio = 0;
>  	struct path * pp;
>  	struct pathgroup * pgp;
> +	int pp_alloc_flag = 0;
> 
>  	assert(pathvec != NULL);
>  	p = params;
> @@ -292,6 +293,7 @@ int disassemble_map(const struct _vector
> *pathvec,
> 
>  		for (j = 0; j < num_paths; j++) {
>  			pp = NULL;
> +			pp_alloc_flag = 0;
>  			p += get_word(p, &word);
> 
>  			if (!word)
> @@ -304,13 +306,16 @@ int disassemble_map(const struct _vector
> *pathvec,
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
