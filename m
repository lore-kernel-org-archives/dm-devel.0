From: Dave Chinner <david@fromorbit.com>
Subject: Re: generic wrappers for multi-device FS operations
Date: Wed, 9 Mar 2011 13:11:42 +1100
Message-ID: <20110309021142.GI1956@dastard>
References: <4D766199.4010307@gmail.com>
 <B2CB305A-1268-4F0A-98AA-CA08FA10FDE8@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B2CB305A-1268-4F0A-98AA-CA08FA10FDE8@dilger.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Karel Zak <kzak@redhat.com>, Jim Meyering <jim@meyering.net>, Chris Mason <chris.mason@oracle.com>, Josef Bacik <josef@redhat.com>
List-Id: dm-devel.ids

On Tue, Mar 08, 2011 at 01:54:37PM -0700, Andreas Dilger wrote:
> On 2011-03-08, at 10:04 AM, Ric Wheeler wrote:
> > After seeing some of the feedback and confusion that happened in the fedora community after Josef suggestion that we default to btrfs in an upcoming Fedora release, it became clear to me that many users are incredibly unaware of the common features that we have across file systems today given LVM/device mapper support.
> > 
> > btrfs will make multi-volume/multi-disk operations common place and easy to do, but there is no reason not to do most/all of this today with ext4, xfs, etc on top of lvm.
> > 
> > To make this trivial to do for users, I think that it would be really nice to have a two-level wrappers for things like resize, add a volume, shrink, etc. Similar to the way we have mount or fsck invoke file system specific bits.
> 
> I definitely think this makes sense.  However, taking a quick look at fsadm,
> I don't think it is the right starting point for this work.  It is essentially
> a single script that is special-casing each filesystem it is touching, which
> makes it a maintenance nightmare to add in support for different filesystems.
> 
> A better structure is the mkfs.* and fsck.* tools that extend the basic
> mkfs/fsck functionality for each new filesystem.  That allows new filesystems
> to be added without the requirement to modify the upstream fsadm script.

That seems like a sensible approach to me, however handling the
different volumes could be trouble. e.g. the top level app would
still need to know about the difference between log devices and data
devices for XFS/ext3/ext4, realtime devices for XFS (as they can be
grown separately to the data device but as still part of the same
filesystem), while for btrfs just uses generic block devices, pools
and volumes....

> Another tool similar to this that I've been trying to push upstream for some
> time is the "lvcheck" script, which is essentially a wrapper for online
> filesystem checking.  It is currently structured as an extension to the LVM
> tools, since it depends on creating a snapshot of an LV and does a check on
> the snapshot.  If the snapshot is clean the original filesystem is marked
> checked as well, which avoids the "slow ext* check on boot" problem, while
> still ensuring that periodic filesystem checks will catch latent errors.

I think this is very different to the well defined operations of
growing and shrinking filesystems and block devices.

Checking snapshots isn't really "online" checking at all - it's
generating a temporary stable image of the filesystem that is used
for an offline check. If anything is found wrong, you've still got
to take the fs offline and run the offline repair program.

As it is, dm-snapshot based checking really isn't a solution that
can be employed in production environments with performance SLAs or
that require sustained high performance because of the performance
hit the COW based snapshot mechanism causes while there are active
snapshots. And that's before considering the impact of all the IO
the check process would issue...

> It wouldn't be unreasonable to have a new wrapper for online filesystem
> checking (e.g. ofsck) or just an extension to fsck that does this in a more
> "plug-in" manner like fsck.* does today.  It would naturally progress into
> real online checking for filesystems that support this (e.g. btrfs, and I
> think XFS is going in this direction as well).

Online filesystem scrubbing and repair is highly filesystem
specific, just like offline repair is. It can't be easily separated
from the kernel code because of the need to be coherent with
current operations.

My current line of thinking is that for XFS it would be an entirely
in-kernel operation in combination with a scrubber and additional
on-disk metadata structures (such as an rmap btree) to make the
operation of the scrubber as efficient as possible. The scrubber
would run in the background and trigger repair of problems it
encounters, with extra triggers for when normal operation encounter
corruption problems. i.e. check and reapir with no specific external
userspace control or intervention.

IOWs, until we actually have real online repair implemented in more
than one filesystem and can determine similarites in their
operation, I think trying to develop a generic interface for them
is premature....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
