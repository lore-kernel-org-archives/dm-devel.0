From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH] Add missing del_gendisk to error path
Date: Wed, 23 Sep 2009 11:41:38 -0500
Message-ID: <2A187566-B84E-48F4-BED8-C562AE7FF9CB@redhat.com>
References: <4ABA1686.1000906@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4ABA1686.1000906@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

  brassow
On Sep 23, 2009, at 7:37 AM, Zdenek Kabelac wrote:

> Add missing del_gendisk() to error path when creation of workqueue  
> fails.
> Otherwice there is a resource leak and following warning is shown:
>
> WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xc5/0x160()
> sysfs: cannot create duplicate filename '/devices/virtual/block/dm-0'
>
> Signed-off-by: Zdenek Kabelac <zkabelac@redhat.com>
>
> ---
> drivers/md/dm.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index b4845b1..bf5961d 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1819,6 +1819,7 @@ static struct mapped_device *alloc_dev(int  
> minor)
> bad_bdev:
> 	destroy_workqueue(md->wq);
> bad_thread:
> +	del_gendisk(md->disk);
> 	put_disk(md->disk);
> bad_disk:
> 	blk_cleanup_queue(md->queue);
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
