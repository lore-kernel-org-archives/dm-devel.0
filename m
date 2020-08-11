From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2] vector: return false if realloc fails in
 vector_alloc_slot func
Date: Tue, 11 Aug 2020 11:46:48 +0200
Message-ID: <8254cda18f6f5e98f0c097d1065a39b937ce8628.camel@suse.com>
References: <7556f86a-0b45-8274-b9e7-0576813ca1fe@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7556f86a-0b45-8274-b9e7-0576813ca1fe@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, christophe.varoqui@opensvc.com, kabelac@redhat.com
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com, lixiaokeng <lixiaokeng@huawei.com>
List-Id: dm-devel.ids

On Tue, 2020-08-11 at 11:23 +0800, Zhiqiang Liu wrote:
> In vector_alloc_slot func, if REALLOC fails, it means new slot
> allocation fails. However, it just update v->allocated and then
> return the old v->slot without new slot. So, the caller will take
> the last old slot as the new allocated slot, and use it by calling
> vector_set_slot func. Finally, the data of last slot is lost.
> 
> Here, we rewrite vector_alloc_slot as suggested by Martin Wilck:
>  - increment v->allocated only after successful allocation,
>  - avoid the "if (v->slot)" conditional by just calling realloc(),
>  - make sure all newly allocated vector elements are set to NULL,
>  - change return value to bool.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>

Thanks a lot, this is very nice. We're almost there (see below).

> diff --git a/libmultipath/vector.c b/libmultipath/vector.c
> index 501cf4c5..39e2c20f 100644
> --- a/libmultipath/vector.c
> +++ b/libmultipath/vector.c
> @@ -35,26 +35,22 @@ vector_alloc(void)
>  }
> 
>  /* allocated one slot */
> -void *
> +bool
>  vector_alloc_slot(vector v)
>  {
>  	void *new_slot = NULL;
> 
>  	if (!v)
> -		return NULL;
> -
> -	v->allocated += VECTOR_DEFAULT_SIZE;
> -	if (v->slot)
> -		new_slot = REALLOC(v->slot, sizeof (void *) * v-
> >allocated);
> -	else
> -		new_slot = (void *) MALLOC(sizeof (void *) * v-
> >allocated);
> +		return false;
> 
> +	new_slot = REALLOC(v->slot, sizeof (void *) * (v->allocated +
> VECTOR_DEFAULT_SIZE));

Please wrap this line. We basically still use a 80-columns limit, with
the exception of string constants (mostly condlog() lines). We don't
strictly enforce it, but 92 columns is a bit too much for my taste.

>  	if (!new_slot)
> -		v->allocated -= VECTOR_DEFAULT_SIZE;
> -	else
> -		v->slot = new_slot;
> +		return false;
> 
> -	return v->slot;
> +	v->slot = new_slot;
> +	v->allocated += VECTOR_DEFAULT_SIZE;
> +	v->slot[VECTOR_SIZE(v) - 1] = NULL;

This assumes that VECTOR_DEFAULT_SIZE == 1. While that has been true
essentially forever, there's no guarantee for the future. Better use a
for loop, or memset().

Regards
Martin
