From: Martin Wilck <mwilck@suse.de>
Subject: Re: [PATCH] dm mpath: fix memory leak for
	attached_handler_name
Date: Mon, 29 Apr 2019 11:36:55 +0200
Message-ID: <40abc8f16f781f8f6de1e9dac489fd023cc1e657.camel@suse.de>
References: <20190427105409.36721-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190427105409.36721-1-yuyufen@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Yufen Yu <yuyufen@huawei.com>, dm-devel@redhat.com, snitzer@redhat.com
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, mpatocka@redhat.com
List-Id: dm-devel.ids

On Sat, 2019-04-27 at 18:54 +0800, Yufen Yu wrote:
> If multipath does not set flag MPATHF_RETAIN_ATTACHED_HW_HANDLER,
> parse_path() would forget to free attached_handler_name when
> successfully exit, resulting in memory leak.

I believe this should rather be done in parse_path(), as
setup_scsi_dh() nullifies the pointer anyway when it "steals" it.
I'll send a patch shortly.

Thanks,
Martin





> 
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> ---
>  drivers/md/dm-mpath.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 00e738c1222f..850a7c637a88 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -841,6 +841,8 @@ static int setup_scsi_dh(struct block_device
> *bdev, struct multipath *m,
>  			m->hw_handler_name = *attached_handler_name;
>  			*attached_handler_name = NULL;
>  		}
> +	} else {
> +		kfree(*attached_handler_name);
>  	}
>  
>  	if (m->hw_handler_name) {
