From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm raid: ensure metadata IO matches device block
	size.
Date: Thu, 16 Oct 2014 15:56:11 -0400
Message-ID: <20141016195611.GA14141@redhat.com>
References: <20141015121907.265b3aed@notabene.brown>
	<20141015025550.GC19683@redhat.com>
	<20141015144003.7b17752d@notabene.brown>
	<20141015131307.GA23955@redhat.com>
	<20141016080054.7c906901@notabene.brown>
	<543FC8A0.8000709@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <543FC8A0.8000709@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Heinz Mauelshagen <heinzm@redhat.com>
Cc: lwang@suse.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Oct 16 2014 at  9:31am -0400,
Heinz Mauelshagen <heinzm@redhat.com> wrote:

> 
> On 10/15/2014 11:00 PM, NeilBrown wrote:
> >On Wed, 15 Oct 2014 09:13:08 -0400 Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >>On Tue, Oct 14 2014 at 11:40pm -0400,
> >>NeilBrown <neilb@suse.de> wrote:
> >>
> >>>On Tue, 14 Oct 2014 22:55:50 -0400 Mike Snitzer <snitzer@redhat.com> wrote:
> >>>
> >>>>On Tue, Oct 14 2014 at  9:19pm -0400,
> >>>>NeilBrown <neilb@suse.de> wrote:
> >>>>
> >>>>>dm_raid_superblock is 512.
> >>>>>Reading or writing this on a 512-byte sector works fine.
> >>>>>On a 4096-byte sector device, this fails.
> >>>>>
> >>>>>If we round up rdev->sb_size to match the block size of
> >>>>>the device, all IO will work correctly.
> >>>>>
> >>>>>Reported-by: "Liuhua Wang" <lwang@suse.com>
> >>>>>Signed-off-by: NeilBrown <neilb@suse.de>
> >>>>>
> >>>>>---
> >>>>>this issue has been discussed already a bit. See email thread
> >>>>>  Subject: Re: [dm-devel] [PATCH] fix mirror device creation with lvcreate failed
> >>>>>I think this is the best fix.  It handles boths read and writes, and (I think)
> >>>>>at the best level.
> >>>>>
> >>>>>Thanks,
> >>>>>NeilBrown
> >>>>>
> >>>>>
> >>>>>diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >>>>>index 4880b69e2e9e..31bdd73bc368 100644
> >>>>>--- a/drivers/md/dm-raid.c
> >>>>>+++ b/drivers/md/dm-raid.c
> >>>>>@@ -858,7 +858,8 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
> >>>>>  	uint64_t events_sb, events_refsb;
> >>>>>  	rdev->sb_start = 0;
> >>>>>-	rdev->sb_size = sizeof(*sb);
> >>>>>+	rdev->sb_size = roundup(sizeof(*sb),
> >>>>>+				bdev_logical_block_size(rdev->meta_bdev));
> >>>>>  	ret = read_disk_sb(rdev, rdev->sb_size);
> >>>>>  	if (ret)
> >>>>Wouldn't it be better to use bdev_physical_block_size()?
> >>>>
> >>>>Even on a 4K device that emulates 512b logical sectors it is better to
> >>>>use the physical block size (4K).
> >>>
> >>>_logical_ is the smallest value for which the IO actually works.
> >>>And the goal of the change is to make it work.
> >>>
> >>>I don't object to using _physical_, but it isn't clear to me how I would
> >>>justify that as "correct".
> >>>
> >>>A big question in my mind is: how much space does LVM reserve in this device
> >>>for the metadata?  It seems reasonable to assume that it reserves at least
> >>>1 logical block.  If the API guarantees that at least one physical block is
> >>>reserved, then that would justify using _physical_.
> 
> dm-raid uses 512 bytes for its superblock including padding in the
> current code
> (with way less payload), followed by the bitmap at offset 4096 bytes.
> 
> With Neil's proposal, the padding will be avoided alltogether.
> 
> So logical looks fine to me, because physical may well be more than
> 4K in the future.
> Admittingly a longer time in the future though.
> 
> If that happens, we'd end up with the bitmap start at offset 4096
> bytes in the same physical sector
> and would have to cope with it plus the issues involved with 4K page sizes.
> 
> In order to prevent this to occur unrecognized in dm/md later,
> we should have an "if (rdev->sb_size > PAGE_SIZE) return -EINVAL;"
> after the setting
> of rdev->sb_size in dm-raid.c and appropriate checks in md.c.
> 
> BTW: even with additions to the dm-raid superblock I have to make in
> order to allow for reshaping etc.,
>          it's paylod is going to stay < 512 bytes.

Heinz,

If you could propose a revised patch I'd appreciate it.

Thanks,
Mike
