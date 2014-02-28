From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 8/8] dm-mpath: do not activate failed paths
Date: Fri, 28 Feb 2014 08:49:19 +0000
Message-ID: <11AF7C027C4C02408624617A49860784010D7C45@BPXM12GP.gisp.nec.co.jp>
References: <1393486229-72034-1-git-send-email-hare@suse.de>
	<1393486229-72034-9-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393486229-72034-9-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <72A13F606E66AA4195B95D42025BDF50@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/27/14 16:30, Hannes Reinecke wrote:
> activate_path() is run without a lock, so the path might be
> set to failed before activate_path() had a chance to run.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 0a40fa9..22e7365 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1196,8 +1196,11 @@ static void activate_path(struct work_struct *work)
>  	struct pgpath *pgpath =
>  		container_of(work, struct pgpath, activate_path.work);
>  
> -	scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
> -				pg_init_done, pgpath);
> +	if (pgpath->is_active)
> +		scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
> +				 pg_init_done, pgpath);
> +	else
> +		pg_init_done(pgpath, SCSI_DH_DEV_OFFLINED);

Hi Hannes,

What problem are you going to fix with this?
It is still possible that the path is set to failed just after
"if (pgpath->is_active)" and before "scsi_dh_activate".

-- 
Jun'ichi Nomura, NEC Corporation
