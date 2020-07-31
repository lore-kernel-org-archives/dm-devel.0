From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [dm- devel][PATCH] vector: return null when realloc
 fails in vector_alloc_slot func
Date: Fri, 31 Jul 2020 12:11:11 -0500
Message-ID: <20200731171111.GE19233@octiron.msp.redhat.com>
References: <a04e1267-0f1c-3a8b-c163-1697469ffeca@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a04e1267-0f1c-3a8b-c163-1697469ffeca@huawei.com>
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, linfeilong@huawei.com, dm-devel@redhat.com, kabelac@redhat.com, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Fri, Jul 31, 2020 at 06:41:57PM +0800, Zhiqiang Liu wrote:
> 
> In vector_alloc_slot func, if REALLOC fails, it means new slot
> allocation fails. However, it just update v->allocated and then
> return the old v->slot without new slot. So, the caller will take
> the last old slot as the new allocated slot, and use it by calling
> vector_set_slot func. Finally, the data of last slot is lost.
>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
 
> Here, if REALLOC or MALLOC fails, we will return NULL.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  libmultipath/vector.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/vector.c b/libmultipath/vector.c
> index 501cf4c5..29dc9848 100644
> --- a/libmultipath/vector.c
> +++ b/libmultipath/vector.c
> @@ -49,12 +49,14 @@ vector_alloc_slot(vector v)
>  	else
>  		new_slot = (void *) MALLOC(sizeof (void *) * v->allocated);
> 
> -	if (!new_slot)
> +	/* If REALLOC or MALLOC fails, it means new slot allocation fails, so return NULL. */
> +	if (!new_slot) {
>  		v->allocated -= VECTOR_DEFAULT_SIZE;
> -	else
> -		v->slot = new_slot;
> +		return NULL;
> +	}
> 
> -	return v->slot;
> +	v->slot = new_slot;
> +	return v->slot[VECTOR_SIZE(v) - 1];
>  }
> 
>  int
> -- 
> 2.24.0.windows.2
