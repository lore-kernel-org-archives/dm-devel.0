From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [dm- devel][PATCH] libmultipath: fix a memory leak
	in dm_get_maps
Date: Thu, 30 Jul 2020 12:25:20 -0500
Message-ID: <20200730172520.GA19233@octiron.msp.redhat.com>
References: <e2fb3241-6829-86e1-bc0c-5ba6b0e399c7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e2fb3241-6829-86e1-bc0c-5ba6b0e399c7@huawei.com>
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
Cc: liuzhiqiang26@huawei.com, linfeilong@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>, lutianxiong@huawei.com
List-Id: dm-devel.ids

On Thu, Jul 30, 2020 at 12:01:36PM +0800, lixiaokeng wrote:
> In dm_get_maps func, if vector_alloc_slot(mp) fails, the
> mpp should be free.
> 
> Here we call free_multipath(mpp, KEEP_PATHS) to free map.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> 
> ---
>  libmultipath/devmapper.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index f597ff8b..92eef6f1 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1198,8 +1198,10 @@ dm_get_maps (vector mp)
>  		if (!mpp)
>  			goto out;
> 
> -		if (!vector_alloc_slot(mp))
> +		if (!vector_alloc_slot(mp)) {
> +			free_multipath(mpp, KEEP_PATHS);
>  			goto out;
> +		}
> 
>  		vector_set_slot(mp, mpp);
>  		mpp = NULL;
> -- 
