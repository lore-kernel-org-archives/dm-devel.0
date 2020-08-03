From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [dm- devel][PATCH] vector: fix upper boundary check
 of vector size in vector_del_slot
Date: Mon, 3 Aug 2020 12:49:12 -0500
Message-ID: <20200803174912.GG19233@octiron.msp.redhat.com>
References: <94c8222f-a941-dee3-54eb-f243fd28b85a@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <94c8222f-a941-dee3-54eb-f243fd28b85a@huawei.com>
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

On Mon, Aug 03, 2020 at 10:39:29AM +0800, Zhiqiang Liu wrote:
> 
> In vector_del_slot func, legal value of input slot is in range of
> [0, VECTOR_SIZE(v)), it means slot value should be less then VECTOR_SIZE(v).
> 
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/vector.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/vector.c b/libmultipath/vector.c
> index 501cf4c5..5b047e40 100644
> --- a/libmultipath/vector.c
> +++ b/libmultipath/vector.c
> @@ -109,7 +109,7 @@ vector_del_slot(vector v, int slot)
>  {
>  	int i;
> 
> -	if (!v || !v->allocated || slot < 0 || slot > VECTOR_SIZE(v))
> +	if (!v || !v->allocated || slot < 0 || slot >= VECTOR_SIZE(v))
>  		return;
> 
>  	for (i = slot + 1; i < VECTOR_SIZE(v); i++)
> -- 
> 2.24.0.windows.2
> 
