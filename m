From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [dm- devel][PATCH] tests/hwtable: fix a memory free
 in replicate_config
Date: Mon, 3 Aug 2020 13:01:54 -0500
Message-ID: <20200803180154.GI19233@octiron.msp.redhat.com>
References: <0c482278-37d5-9875-c22c-b14fd02f30d9@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0c482278-37d5-9875-c22c-b14fd02f30d9@huawei.com>
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

On Mon, Aug 03, 2020 at 10:43:54AM +0800, Zhiqiang Liu wrote:
> 
> In replicate_config func, hwtable is allocated by calling get_used_hwes
> func, however it is not freed.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  tests/hwtable.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/hwtable.c b/tests/hwtable.c
> index 473028b7..84d2b35f 100644
> --- a/tests/hwtable.c
> +++ b/tests/hwtable.c
> @@ -468,6 +468,7 @@ static void replicate_config(const struct hwt_state *hwt, bool local)
>  		/* "local" configuration */
>  		hwtable = get_used_hwes(hwt->vecs->pathvec);
>  		cfg1 = snprint_config(conf, NULL, hwtable, hwt->vecs->mpvec);
> +		vector_free(hwtable);
>  	}
> 
>  	assert_non_null(cfg1);
> -- 
> 2.24.0.windows.2
> 
