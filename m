From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-io: reject unsupported DISCARD/WRITE SAME
 requests with EOPNOTSUPP
Date: Thu, 26 Feb 2015 15:10:14 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502261507300.15041@file01.intranet.prod.int.rdu2.redhat.com>
References: <20150213092432.GC11034@birch.djwong.org>
	<20150213155550.GA32670@redhat.com>
	<alpine.LRH.2.02.1502261446360.15041@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1502261446360.15041@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Cc: Srinivas Eeda <srinivas.eeda@oracle.com>, agk@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: dm-devel.ids



On Thu, 26 Feb 2015, Mikulas Patocka wrote:

> 
> 
> On Fri, 13 Feb 2015, Mike Snitzer wrote:
> 
> > On Fri, Feb 13 2015 at  4:24am -0500,
> > Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > > I created a dm-raid1 device backed by a device that supports DISCARD
> > > and another device that does NOT support DISCARD with the following
> > > dm configuration:
> > > 
> > > # echo '0 2048 mirror core 1 512 2 /dev/sda 0 /dev/sdb 0' | dmsetup create moo
> > > # lsblk -D
> > > NAME         DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
> > > sda                 0        4K       1G         0
> > > `-moo (dm-0)        0        4K       1G         0
> > > sdb                 0        0B       0B         0
> > > `-moo (dm-0)        0        4K       1G         0
> > > 
> > > Notice that the mirror device /dev/mapper/moo advertises DISCARD
> > > support even though one of the mirror halves doesn't.
> > > 
> > > If I issue a DISCARD request (via fstrim, mount -o discard, or ioctl
> > > BLKDISCARD) through the mirror, kmirrord gets stuck in an infinite
> > > loop in do_region() when it tries to issue a DISCARD request to sdb.
> > > The problem is that when we call do_region() against sdb, num_sectors
> > > is set to zero because q->limits.max_discard_sectors is zero.
> > > Therefore, "remaining" never decreases and the loop never terminates.
> > > 
> > > Before entering the loop, check for the combination of REQ_DISCARD and
> > > no discard and return -EOPNOTSUPP to avoid hanging up the mirror
> > > device.  Fix the same problem with WRITE_DISCARD while we're at it.
> > > 
> > > This bug was found by the unfortunate coincidence of pvmove and a
> > > discard operation in the RHEL 6.5 kernel; 3.19 is also affected.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> > > Cc: Srinivas Eeda <srinivas.eeda@oracle.com>
> > 
> > Your patch looks fine but it is laser focused on dm-io.  Again, that is
> > fine (fixes a real problem).  But I'm wondering how other targets will
> > respond in the face of partial discard support across the logical
> > address space of the DM device.
> > 
> > When I implemented dm_table_supports_discards() I consciously allowed a
> > DM table to contain a mix of discard support.  I'm now wondering where
> > it is we benefit from that?  Seems like more of a liability than
> > anything -- so a bigger hammer approach to fixing this would be to
> > require all targets and all devices in a DM table support discard.
> > Which amounts to changing dm_table_supports_discards() to be like
> > dm_table_supports_write_same().
> > 
> > BTW, given dm_table_supports_write_same(), your patch shouldn't need to
> > worry about WRITE SAME.  Did you experience issues with WRITE SAME too
> > or were you just being proactive?
> > 
> > Mike
> 
> I think that Darrick's patch is needed even for WRITE SAME.
> 
> Note that queue limits and flags can't be reliably prevent bios from 
> coming in.
> 
> For example:
> 
> 1. Some piece of code tests queue flags and sees that 
> max_write_same_sectors is non-zero, it constructs WRITE_SAME bio and sends 
> it with submit_bio.
> 
> 2. Meanwhile, the device is reconfigured so that it doesn't support 
> WRITE_SAME. q->limits.max_write_same_sectors is set to zero.
> 
> 3. The bio submitted at step 1 can't be reverted, so it arrives at the 
> device mapper even if it advertises that it doesn't support write same - 
> now, it causes the lockup that Darrick observed.
> 
> 
> Another problem is that queue flags are not propagated up when you reload 
> a single device - someone could reload a mirror leg with a different dm 
> table that doesn't support write_same, and even after the reload, the 
> mirror keeps advertising that it does support WRITE_SAME.

It comes to another idea - if the limits change while the do-while loop is 
in progress, even the original Darrick's patch is wrong and fails to 
prevent the lockup. So - we need to read the limits in advance, test them 
and never re-read them.

Mikulas
