From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] fix mirror device creation with
	lvcreate	failed
Date: Wed, 17 Sep 2014 00:21:04 +0100
Message-ID: <20140916232104.GC2407@agk-dp.fab.redhat.com>
References: <1409127505-5246-1-git-send-email-lwang@suse.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1409127505-5246-1-git-send-email-lwang@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Liuhua Wang <lwang@suse.com>
Cc: nfbrown@suse.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Aug 27, 2014 at 04:18:25PM +0800, Liuhua Wang wrote:
>  On some devices, 

Which devices?  What is the necessary condition to trigger the problem?

> when create mirror device with lvcreate, it fails.
>  device-mapper: reload ioctl on  failed: Invalid argument
>  Failed to activate new LV.
 
What exactly causes this error?
- Do you get a kernel error message too?

>  We can use read size 4096 since md always use 4096.
 
How is that connected to problem?
Why does it fix it?

> +++ b/drivers/md/dm-raid.c
> @@ -860,7 +860,7 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
>  	rdev->sb_start = 0;
>  	rdev->sb_size = sizeof(*sb);
  
What should sb_size really be?

> -	ret = read_disk_sb(rdev, rdev->sb_size);
> +	ret = read_disk_sb(rdev, 4096);

Why aren't they both MD_SB_BYTES?
(Strictly, does sb_size need recalculating after the read?)

Alasdair
