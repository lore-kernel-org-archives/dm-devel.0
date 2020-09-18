From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 5/6] libmultipath: check udev* renturn value
 in get_ctrl_blkdev
Date: Fri, 18 Sep 2020 08:59:55 +0200
Message-ID: <d2a60cf65fc4d3d5833a963bcaffbcc3eb03abd8.camel@suse.com>
References: <d89bc33d-8e5d-d194-3b26-83ff4d170c5c@huawei.com>
	<2e194628-4c9b-e259-f2b3-3c09e134575c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <2e194628-4c9b-e259-f2b3-3c09e134575c@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: lixiaokeng <lixiaokeng@huawei.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski <bmarzins@redhat.com>, dm-devel mailing list <dm-devel@redhat.com>
Cc: linfeilong <linfeilong@huawei.com>, "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
List-Id: dm-devel.ids

On Tue, 2020-09-15 at 12:41 +0800, lixiaokeng wrote:
> We check return value of udev_device_get_devtype before
> dereference it.
> 
> Signed-off-by:Lixiaokeng<lixiaokeng@huawei.com>
> Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
> Signed-off-by: Linfeilong <linfeilong@huawei.com>
> ---
>  libmultipath/foreign/nvme.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/libmultipath/foreign/nvme.c
> b/libmultipath/foreign/nvme.c
> index 0bc5106e..a0668713 100644
> --- a/libmultipath/foreign/nvme.c
> +++ b/libmultipath/foreign/nvme.c
> @@ -538,6 +538,7 @@ struct udev_device *get_ctrl_blkdev(const struct
> context *ctx,
>  	struct udev_list_entry *item;
>  	struct udev_device *blkdev = NULL;
>  	struct udev_enumerate *enm = udev_enumerate_new(ctx->udev);
> +	const char *devtype;
> 
>  	if (enm == NULL)
>  		return NULL;
> @@ -562,7 +563,9 @@ struct udev_device *get_ctrl_blkdev(const struct
> context *ctx,
>  					   udev_list_entry_get_name(ite
> m));
>  		if (tmp == NULL)
>  			continue;
> -		if (!strcmp(udev_device_get_devtype(tmp), "disk")) {
> +
> +		devtype = udev_device_get_devtype(tmp);
> +		if (!devtype && !strcmp(devtype, "disk")) {
>  			blkdev = tmp;
>  			break;
>  		} else

This looks wrong.
