From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: New kernel shared snapshots
Date: Tue, 25 Aug 2009 10:43:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0908251026430.19589@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0907270657080.527@hs20-bc2-1.build.redhat.com>
	<805301CC-A5EA-4905-9867-0B4762B63D8E@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <805301CC-A5EA-4905-9867-0B4762B63D8E@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

Hi

Thanks for review.

I fixed the "duplicate cache" thing (I use slub and it doesn't give this 
error; slab does) and uploaded it on the same address 
(http://people.redhat.com/mpatocka/patches/kernel/new-snapshot/devel/).

I also fixed most of checkpatch.pl warnings, but not the one for 80-column 
lines. I find it very unconvenient to constantly realign text for 80 
columns, so I use unlimited line size --- if I am the person who will do 
most development on the code, it is reasonable to code it the way that is 
convenient for me.


How do other people deal with this "80-column" requirement?

I mean, if I have function
static struct some_structure *some_function(int a, int b, int c,
                                            int d, long long e,
                                            struct blablabla *p)
... and now I decide that I want to add "int x" before "int a" --- so 
I have to realign all arguments ... and if I delete something, than again, 
realign --- I find it very annoying, much more annoying than writing 
everything just on one line and reading words split from the right to the 
left.

What the other developers do with it? Is there some vim editor option that 
aligns it automatically? (set textwidth= auto-aligns text, but to the 
left, it is unsuitable for C code, it also doesn't autorealign multiple 
lines). Or do others developers align code manually and not find it 
annoying?

Mikulas



On Wed, 19 Aug 2009, Jonathan Brassow wrote:

> Thanks for the recent repost (18-Aug-2009) of your patches at:
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshot/devel
> 
> The interface seems to be in-line with what we want.  I noticed that you can't
> have dm-snapshot and dm-multisnapshot loaded in the kernel at the same time
> (kmem_cache_create: duplicate cache dm_snap_tracked_chunk -- in the module
> init function).  You will also want to run your patches through
> 'linux/scripts/checkpatch.pl'.  It mostly gets angry about the 80 characters /
> line breakage, but there is some other things it catches.
> 
> brassow
> 
> On Jul 27, 2009, at 6:24 AM, Mikulas Patocka wrote:
> 
> > Hi
> > 
> > The new release of shared snapshots can be found here:
> > http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/devel/
> > 
> > It has the interface we talked about on Linux Tag.
> > So look at it as a last chance to review the interface. And also test it.
> > 
> > 
> > To create a snapshot, you have to:
> > - send a message
> > - ask for status, get the snapshot id
> > - suspend (this creates the snapshot, when the filesystem is quiescent)
> > - resume
> > 
> > Then, you can attach the snapshots by loading "multisnap-snap" target.
> > 
> > If the table line contains argument "sync-snapshots", it synchronizes the
> > snapshot list against what is given on the table --- i.e. creates
> > snapshots that are on the table but are not in the store and deletes those
> > that are not in the store but are on the table.
> > 
> > Other changes:
> > - make more structures private (move them to dm-multisnap-private.h), so
> > that ABI doesn't change if these are chaged.
> > - snapshot IDs are treated as strings, not numbers.
> > - metadata cache size can be specified as an argument to the "mikulas"
> > exception store.
> > - an argument "preserve-on-error" that says that on error or overflow,
> > writes to the origin should be disabled.
> > 	- if you don't specify this, the origin continues operation, but
> > 	snapshots are irreversibly damaged by this (use for non-important
> > 	snapshots such as backups)
> > 	- if you specify this, the data are always preserved, the whole
> > 	thing just halts on error (user when snapshots contain some
> > 	important data.
> > - fixed two bad bugs in dm-bufio.
> > 
> > 
> > Known bugs:
> > - that read-vs-realloc race (that I already fixed in the old snapshots a
> > year ago) is present there. I'll fix it, but it isn't so trivial as in
> > unshared snapshots.
> > 
> > 
> > Mikulas
