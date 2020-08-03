From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [dm- devel][PATCH] vector: add lower bound check of
 E in VECTOR_SLOT
Date: Mon, 3 Aug 2020 12:49:44 -0500
Message-ID: <20200803174944.GH19233@octiron.msp.redhat.com>
References: <db186a10-8244-c9cd-4da0-b03976ce48b9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <db186a10-8244-c9cd-4da0-b03976ce48b9@huawei.com>
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, linfeilong <linfeilong@huawei.com>, dm-devel@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>, Martin Wilck <mwilck@suse.com>
List-Id: dm-devel.ids

On Mon, Aug 03, 2020 at 10:41:48AM +0800, Zhiqiang Liu wrote:
> 
> In VECTOR_SLOT(V, E), we add the lower bound check of E.
> E cannot be less than zero.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/vector.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/vector.h b/libmultipath/vector.h
> index e16ec461..cdb94b24 100644
> --- a/libmultipath/vector.h
> +++ b/libmultipath/vector.h
> @@ -32,7 +32,7 @@ typedef struct _vector *vector;
> 
>  #define VECTOR_DEFAULT_SIZE 1
>  #define VECTOR_SIZE(V)   ((V) ? ((V)->allocated) / VECTOR_DEFAULT_SIZE : 0)
> -#define VECTOR_SLOT(V,E) (((V) && (E) < VECTOR_SIZE(V)) ? (V)->slot[(E)] : NULL)
> +#define VECTOR_SLOT(V,E) (((V) && (E) < VECTOR_SIZE(V) && (E) >= 0) ? (V)->slot[(E)] : NULL)
>  #define VECTOR_LAST_SLOT(V)   (((V) && VECTOR_SIZE(V) > 0) ? (V)->slot[(VECTOR_SIZE(V) - 1)] : NULL)
> 
>  #define vector_foreach_slot(v,p,i) \
> -- 
> 2.24.0.windows.2
> 
