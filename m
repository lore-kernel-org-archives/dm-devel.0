From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 03/14] libmultipath: use map instead of
	dm_task_get_name
Date: Thu, 03 Sep 2020 19:35:30 +0200
Message-ID: <0aee805a1a8ce1528e6837a97c46abc2c7f20191.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<209c5f12-b041-371a-8a80-8201b5b2cf98@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <209c5f12-b041-371a-8a80-8201b5b2cf98@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Wed, 2020-09-02 at 15:17 +0800, lixiaokeng wrote:
> In dm_mapname, dm_task_get_name(dmt) has been called and the return
> value
> has been stored in map. Use map instead of second  dm_task_get_name.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  libmultipath/devmapper.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index cc2de1df..b4d77cb6 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1315,7 +1315,7 @@ dm_mapname(int major, int minor)
> 
>  	map = dm_task_get_name(dmt);
>  	if (map && strlen(map))
> -		response = STRDUP((const char *)dm_task_get_name(dmt));
> +		response = STRDUP((const char *)map);

dm_task_get_name() is not an expensive call. Anyway:

Reviewed-by: Martin Wilck <mwilck@suse.com>

> 
>  	dm_task_destroy(dmt);
>  	return response;
