From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm raid: ensure metadata IO matches device block
	size.
Date: Wed, 15 Oct 2014 09:13:08 -0400
Message-ID: <20141015131307.GA23955@redhat.com>
References: <20141015121907.265b3aed@notabene.brown>
	<20141015025550.GC19683@redhat.com>
	<20141015144003.7b17752d@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20141015144003.7b17752d@notabene.brown>
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

On Tue, Oct 14 2014 at 11:40pm -0400,
NeilBrown <neilb@suse.de> wrote:

> On Tue, 14 Oct 2014 22:55:50 -0400 Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > On Tue, Oct 14 2014 at  9:19pm -0400,
> > NeilBrown <neilb@suse.de> wrote:
> > 
> > > 
> > > dm_raid_superblock is 512.
> > > Reading or writing this on a 512-byte sector works fine.
> > > On a 4096-byte sector device, this fails.
> > > 
> > > If we round up rdev->sb_size to match the block size of
> > > the device, all IO will work correctly.
> > > 
> > > Reported-by: "Liuhua Wang" <lwang@suse.com>
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > 
> > > ---
> > > this issue has been discussed already a bit. See email thread
> > >  Subject: Re: [dm-devel] [PATCH] fix mirror device creation with lvcreate failed
> > > I think this is the best fix.  It handles boths read and writes, and (I think)
> > > at the best level.
> > > 
> > > Thanks,
> > > NeilBrown
> > > 
> > > 
> > > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > > index 4880b69e2e9e..31bdd73bc368 100644
> > > --- a/drivers/md/dm-raid.c
> > > +++ b/drivers/md/dm-raid.c
> > > @@ -858,7 +858,8 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
> > >  	uint64_t events_sb, events_refsb;
> > >  
> > >  	rdev->sb_start = 0;
> > > -	rdev->sb_size = sizeof(*sb);
> > > +	rdev->sb_size = roundup(sizeof(*sb),
> > > +				bdev_logical_block_size(rdev->meta_bdev));
> > >  
> > >  	ret = read_disk_sb(rdev, rdev->sb_size);
> > >  	if (ret)
> > 
> > Wouldn't it be better to use bdev_physical_block_size()?
> > 
> > Even on a 4K device that emulates 512b logical sectors it is better to
> > use the physical block size (4K).
> 
> 
> _logical_ is the smallest value for which the IO actually works.
> And the goal of the change is to make it work.
> 
> I don't object to using _physical_, but it isn't clear to me how I would
> justify that as "correct".
> 
> A big question in my mind is: how much space does LVM reserve in this device
> for the metadata?  It seems reasonable to assume that it reserves at least
> 1 logical block.  If the API guarantees that at least one physical block is
> reserved, then that would justify using _physical_.

I'll have to check with Jon and/or Heinz on this point.

> A quick look at the code shows that the bitmap superblock is placed 4K after
> the start of the metadata.

"the code" being the MD kernel code right?  Any reason not to export a
#define that reflects the space MD reserves and just have dm-raid use that?

Starting to feel like hardcoding 4K is the right thing to do given the
current code.
