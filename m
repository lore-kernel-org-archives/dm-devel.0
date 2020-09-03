From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 06/14] kpartx: check return value of malloc
	in main func
Date: Thu, 03 Sep 2020 21:23:37 +0200
Message-ID: <1943756aaa8a6543c981f3abbc6994b913adcbb4.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<dae35ea9-6825-bd0f-68b5-c327fc1a5a95@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <dae35ea9-6825-bd0f-68b5-c327fc1a5a95@huawei.com>
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

On Wed, 2020-09-02 at 15:19 +0800, lixiaokeng wrote:
> In main func of kpartx.c, we should check return value of
> malloc before using it.
> 
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>  kpartx/kpartx.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
> index 98f6176e..2f6dea7c 100644
> --- a/kpartx/kpartx.c
> +++ b/kpartx/kpartx.c
> @@ -384,6 +384,10 @@ main(int argc, char **argv){
> 
>  	if (delim == NULL) {
>  		delim = malloc(DELIM_SIZE);
> +		if (!delim) {
> +			fprintf(stderr, "malloc delim failed.\n");
> +			exit(1);
> +		}
>  		memset(delim, 0, DELIM_SIZE);
>  		set_delimiter(mapname, delim);
>  	}

Please have a look at kpartx' xmalloc() function.

Regards,
Martin
