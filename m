From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm raid: ensure metadata IO matches device block
	size.
Date: Tue, 14 Oct 2014 22:55:50 -0400
Message-ID: <20141015025550.GC19683@redhat.com>
References: <20141015121907.265b3aed@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141015121907.265b3aed@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.de>
Cc: Liuhua Wang <lwang@suse.com>, Heinz Mauelshagen <heinzm@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 14 2014 at  9:19pm -0400,
NeilBrown <neilb@suse.de> wrote:

> 
> dm_raid_superblock is 512.
> Reading or writing this on a 512-byte sector works fine.
> On a 4096-byte sector device, this fails.
> 
> If we round up rdev->sb_size to match the block size of
> the device, all IO will work correctly.
> 
> Reported-by: "Liuhua Wang" <lwang@suse.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> ---
> this issue has been discussed already a bit. See email thread
>  Subject: Re: [dm-devel] [PATCH] fix mirror device creation with lvcreate failed
> I think this is the best fix.  It handles boths read and writes, and (I think)
> at the best level.
> 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> index 4880b69e2e9e..31bdd73bc368 100644
> --- a/drivers/md/dm-raid.c
> +++ b/drivers/md/dm-raid.c
> @@ -858,7 +858,8 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
>  	uint64_t events_sb, events_refsb;
>  
>  	rdev->sb_start = 0;
> -	rdev->sb_size = sizeof(*sb);
> +	rdev->sb_size = roundup(sizeof(*sb),
> +				bdev_logical_block_size(rdev->meta_bdev));
>  
>  	ret = read_disk_sb(rdev, rdev->sb_size);
>  	if (ret)

Wouldn't it be better to use bdev_physical_block_size()?

Even on a 4K device that emulates 512b logical sectors it is better to
use the physical block size (4K).
