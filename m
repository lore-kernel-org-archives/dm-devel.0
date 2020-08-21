From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH V2 4/5] vector: add lower boundary check in
 vector_foreach_slot_after
Date: Fri, 21 Aug 2020 13:20:15 +0200
Message-ID: <479007328bfbb4737c8e843dff563fa4ea32f246.camel@suse.com>
References: <52b3b834-6da6-99c1-a2d1-95c2387c47e3@huawei.com>
	<8e1d9d4d-a1c2-f75a-ec84-6d7968a9e0d7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8e1d9d4d-a1c2-f75a-ec84-6d7968a9e0d7@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Zhiqiang Liu <liuzhiqiang26@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, Yanxiaodan <yanxiaodan@huawei.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2020-08-21 at 19:00 +0800, Zhiqiang Liu wrote:
> In vector_foreach_slot_after macro, i is the input var, which
> may have a illegal value (i < 0). So we should add lower boundary
> check in vector_foreach_slot_after macro.
> 
> V1->V2:
> - check whether i is illegal before loop (As suggested by Martin)
> 

Reviewed-by: Martin Wilck <mwilck@suse.com>

> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  libmultipath/vector.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/libmultipath/vector.h b/libmultipath/vector.h
> index 2862dc28..ab80d06e 100644
> --- a/libmultipath/vector.h
> +++ b/libmultipath/vector.h
> @@ -38,11 +38,12 @@ typedef struct _vector *vector;
>  #define VECTOR_LAST_SLOT(V)   (((V) && VECTOR_SIZE(V) > 0) ? (V)-
> >slot[(VECTOR_SIZE(V) - 1)] : NULL)
> 
>  #define vector_foreach_slot(v,p,i) \
> -	for (i = 0; (v) && (int)i < VECTOR_SIZE(v) && ((p) = (v)-
> >slot[i]); i++)
> +	for ((i) = 0; (v) && (int)(i) < VECTOR_SIZE(v) && ((p) = (v)-
> >slot[i]); (i)++)
>  #define vector_foreach_slot_after(v,p,i) \
> -	for (; (v) && (int)i < VECTOR_SIZE(v) && ((p) = (v)->slot[i]);
> i++)
> +	if ((v) && (int)(i) >= 0) \
> +		for (; (int)(i) < VECTOR_SIZE(v) && ((p) = (v)-
> >slot[i]); (i)++)
>  #define vector_foreach_slot_backwards(v,p,i) \
> -	for (i = VECTOR_SIZE(v) - 1; (int)i >= 0 && ((p) = (v)-
> >slot[i]); i--)
> +	for ((i) = VECTOR_SIZE(v) - 1; (int)(i) >= 0 && ((p) = (v)-
> >slot[i]); (i)--)
> 
>  #define identity(x) (x)
>  /*
