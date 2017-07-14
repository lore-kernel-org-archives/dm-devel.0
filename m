From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 3/4] libmultipath: only listen for uevents
 with DEVTYPE=disk
Date: Fri, 14 Jul 2017 17:29:56 -0500
Message-ID: <20170714222956.GC2940@octiron.msp.redhat.com>
References: <20170714113209.17177-1-mwilck@suse.com>
	<20170714113209.17177-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170714113209.17177-4-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: Martin Wilck <mwilck@suse.de>, Xose Vazquez Perez <xose.vazquez@gmail.com>, tang.junhui@zte.com.cn, Guan Junxiong <guanjunxiong@huawei.com>, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

ACK

-Ben

On Fri, Jul 14, 2017 at 01:32:08PM +0200, Martin Wilck wrote:
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
> -- 
> 2.13.2
