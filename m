From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [PATCH 00/24] dm-raid456 support using md/raid5.c,
 now with dirty-log
Date: Wed, 16 Jun 2010 13:26:27 +0200
Message-ID: <1276687587.22425.62.camel@o>
References: <20100601094414.565.3638.stgit@notabene.brown>
	<1276608206.22425.11.camel@o> <20100616094518.5aa632fd@notabene.brown>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100616094518.5aa632fd@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2010-06-16 at 09:45 +1000, Neil Brown wrote:
> Hi Heinz,
> 
> On Tue, 15 Jun 2010 15:23:26 +0200
> Heinz Mauelshagen <heinzm@redhat.com> wrote:
> 
> > 
> > Neil,
> > 
> > for missing devices we (re)load the table with error mapped device(s) in
> > their place rather than identifying them with a special char/string.
> > Did you go for the later in order to avoid some MD hassle with error
> > targets being accessed by the MD personalities? If not so, we can drop
> > the special '-' char support to identify missing devices.
> 
> When raid5 determines that a device has failed and so it will not write to it
> again, it must be sure that the failure is record in the metadata before it
> proceeds with that decision not to even try writing to the failed device.

Yes, that's the mandatory order to avoid data loss.

> Otherwise a crash/restart before the metadata was safely updated would result
> in corruption.
> 
> This means that it must be possible for user-space to explicitly tell the
> raid5 that a device is known to be faulty.
> Doing that through the constructor seems the natural way to do it.

If /dev/mapper/error with an error target mapping would be used instead,
would that cause consistency troubles to the MD personality if accessing
those rather than the NULL device solution with the '-' argument you
have now?
If not so, we could drop the '-' support, which I'm aiming at.

> 
> > 
> > I'm thinking about adding a ctr wrapper to allow us to keep the "raid45"
> > ctr interfaces semantics (ie. the arguments) and the new interface to
> > "raid456" if you don't have objections. That would be implemented by 2
> > targets being registered implemented in one module.
> 
> I have no strong objections, though having two targets that do almost the
> same things seems rather ugly.

Keep in mind it'll only be another target_type structs, another
raid_ctr() function plus another (de)registration of the respective
target. The ctr functions for raid45 and raid456 can share moset of the
code anyway.

> 
> Is there existing published code that uses the extra arguments to raid45?

Yes, dmraid with a list of RAID5 supporting metadata format handlers.

Regards,
Heinz

> 
> Thanks,
> NeilBrown
> 
> 
> > 
> > Heinz
> > 
> > On Tue, 2010-06-01 at 19:56 +1000, NeilBrown wrote:
> > > Nearly two months ago I posted my first serious attempt and making
> > > md/raid5.c work as a dm target.  I met with cautious approval I think,
> > > but as it didn't interact with dirty-logs yet it wasn't really read
> > > for prime time.
> > > 
> > > It has taken longer than I hoped, but here is version 2, now with
> > > dirty-log integration.
> > > I have done a modest amount of testing, watching the bits in the log
> > > getting cleared and set just as you would expect, and watching the
> > > resync complete instantly when the dirty-log shows that all regions
> > > are clean.
> > > 
> > > There is not even a hint of cluster support yet, but that shouldn't be
> > > necessary for initial submission to mainline.
> > > 
> > > A significant difference to Heinz' dm-raid45 is that I only honour the
> > > table options that lvm actually sets.  The extra ones don't really fit
> > > with md/raid5 and I don't think they need to be table options.  If any
> > > are needed they might work OK as messages (???).
> > > 
> > > There are a number of changes to core-dm in here including:
> > >   - support for targets to be unplugged when the device is
> > >   - support for targets to report congestion beyond the congestion
> > >     of component devices
> > >   - support for the dirty-log to cover and extent different from the
> > >     size of the target (For raid5 it must be the size of the
> > >     components).
> > > I have tried to fit these to the general style of dm as best as I can.
> > > 
> > > There is certainly room for more testing and review, but I would like
> > > to see this entering -next soon with a view to seeing it merged in the
> > > next merge window.
> > > 
> > > Is this reasonable?  Achievable?
> > > 
> > > Comments?
> > > 
> > > These patches can all be found on the "md-dm-raid45" branch of
> > >    git://neil.brown.name/md/
> > > or at http://neil.brown.name/git?p=md;a=shortlog;h=refs/heads/md-dm-raid45
> > > 
> > > 
> > > Thanks,
> > > NeilBrown
> > > 
> > > 
> > > ---
> > > 
> > > NeilBrown (24):
> > >       md: reduce dependence on sysfs.
> > >       md/raid5: factor out code for changing size of stripe cache.
> > >       md/raid5: ensure we create a unique name for kmem_cache when mddev has no gendisk
> > >       md: be more careful setting MD_CHANGE_CLEAN
> > >       md: split out md_rdev_init
> > >       md: export various start/stop interfaces
> > >       md/dm: create dm-raid456 module using md/raid5
> > >       dm-raid456: add support for raising events to userspace.
> > >       raid5: Don't set read-ahead when there is no queue
> > >       dm-raid456: add congestion checking.
> > >       md/raid5: add simple plugging infrastructure.
> > >       md/plug: optionally use plugger to unplug an array during resync/recovery.
> > >       dm-raid456: support unplug
> > >       dm-raid456: add support for setting IO hints.
> > >       dm-raid456: add suspend/resume method
> > >       dm-raid456: add message handler.
> > >       md/bitmap: white space clean up and similar.
> > >       md/bitmap: reduce dependence on sysfs.
> > >       md/bitmap: clean up plugging calls.
> > >       md/bitmap: optimise scanning of empty bitmaps.
> > >       dm-dirty-log: allow log size to be different from target size.
> > >       md/bitmap: prepare for storing write-intent-bitmap via dm-dirty-log.
> > >       md/bitmap:  separate out loading a bitmap from initialising the structures.
> > >       dm-raid456: switch to use dm_dirty_log for tracking dirty regions.
> > > 
> > > 
> > >  drivers/md/Kconfig                 |    8 +
> > >  drivers/md/Makefile                |    1 
> > >  drivers/md/bitmap.c                |  508 +++++++++++++++++---------------
> > >  drivers/md/bitmap.h                |    6 
> > >  drivers/md/dm-log-userspace-base.c |   11 -
> > >  drivers/md/dm-log.c                |   18 +
> > >  drivers/md/dm-raid1.c              |    4 
> > >  drivers/md/dm-raid456.c            |  576 ++++++++++++++++++++++++++++++++++++
> > >  drivers/md/dm-table.c              |   19 +
> > >  drivers/md/md.c                    |  234 +++++++++------
> > >  drivers/md/md.h                    |   51 +++
> > >  drivers/md/raid5.c                 |  169 ++++++-----
> > >  drivers/md/raid5.h                 |    8 -
> > >  include/linux/device-mapper.h      |   13 +
> > >  include/linux/dm-dirty-log.h       |    3 
> > >  15 files changed, 1235 insertions(+), 394 deletions(-)
> > >  create mode 100644 drivers/md/dm-raid456.c
> > > 
> > 
> 
