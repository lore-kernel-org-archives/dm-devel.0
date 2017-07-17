From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 3/4] libmultipath: only listen for uevents
 with DEVTYPE=disk
Date: Mon, 17 Jul 2017 09:12:33 +0800
Message-ID: <4285ec16-9d83-cb6a-3b4d-e311cd5de3a3@huawei.com>
References: <20170714113209.17177-1-mwilck@suse.com>
	<20170714113209.17177-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170714113209.17177-4-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, tang.junhui@zte.com.cn, Benjamin
	Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Martin Wilck <mwilck@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>, guanjunxiong@huawei.com, Yang Feng <philip.yang@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>, dm-devel@redhat.com, "Hege (A)" <hege09@huawei.com>, linux-nvme@lists.infradead.org
List-Id: dm-devel.ids

Looks fine.

Reviewed-by: Guan Junxiong <guanjunxiong@huawei.com>

On 2017/7/14 19:32, Martin Wilck wrote:
> We are only interested in disks anyway. This saves us checking
> for devtype in the uevent processing queue, and is more powerful
> than the previous test in the dropped function
> uevent_can_discard_by_devpath().
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  libmultipath/uevent.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
> index b688ca03..eb44da56 100644
> --- a/libmultipath/uevent.c
> +++ b/libmultipath/uevent.c
> @@ -770,7 +770,7 @@ int uevent_listen(struct udev *udev)
>  		goto out;
>  	}
>  	err = udev_monitor_filter_add_match_subsystem_devtype(monitor, "block",
> -							      NULL);
> +							      "disk");
>  	if (err)
>  		condlog(2, "failed to create filter : %s", strerror(-err));
>  	err = udev_monitor_enable_receiving(monitor);
> 
