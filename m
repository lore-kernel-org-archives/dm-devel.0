From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 01/14] multipathd: return if
 dm_get_major_minor failed in, cli_add_map
Date: Thu, 03 Sep 2020 19:26:25 +0200
Message-ID: <e525938e5b810958512eb623898fd732bd8482c4.camel@suse.com>
References: <37544d4c-950f-4281-3b66-e4d1884c5167@huawei.com>
	<b1baac25-58c2-8f27-67bd-5d050fcdf8c7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <b1baac25-58c2-8f27-67bd-5d050fcdf8c7@huawei.com>
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

On Wed, 2020-09-02 at 15:15 +0800, lixiaokeng wrote:
> If dm_get_major_minor failed, log with major and minor should not
> be printed to avoid major and minor used before initialization.
> 
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  multipathd/cli_handlers.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 8db37961..2d297fd0 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -847,11 +847,12 @@ cli_add_map (void * v, char ** reply, int *
> len, void * data)

Why not just quit the "do" loop in the error case
for dm_get_major_minor()?

Martin

>  		else {
>  			sprintf(dev_path, "dm-%d", minor);
>  			alias = dm_mapname(major, minor);
> +			if (!alias)
> +				condlog(2, "%s: mapname not found for
> %d:%d",
> +					param, major, minor);
>  		}
>  		/*if there is no mapname found, we first create the
> device*/
>  		if (!alias && !count) {
> -			condlog(2, "%s: mapname not found for %d:%d",
> -				param, major, minor);
>  			get_refwwid(CMD_NONE, param, DEV_DEVMAP,
>  				    vecs->pathvec, &refwwid);
>  			if (refwwid) {
