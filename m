From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: trouble with generic/081
Date: Mon, 9 Jan 2017 20:30:15 -0800
Message-ID: <20170110043015.GG14033@birch.djwong.org>
References: <5806882c-4807-cb2a-80dd-147de5bf176a@sandeen.net>
	<a0c8e06f-db87-393b-419d-d6f8c345fbc8@redhat.com>
	<86b3a61e-5088-4614-1a27-60a5d095ee24@sandeen.net>
	<577228bb-523c-2dbf-1387-e1cb03d07905@redhat.com>
	<18e7613b-5a83-d802-a38f-35a9a604fdb3@sandeen.net>
	<7b8fa79f-89f8-bb9a-a2fc-8a3b966a877d@redhat.com>
	<20170105224600.GC4326@dastard>
	<20170109133919.GB19577@infradead.org>
	<15605149-0590-1555-6522-38d2eff69026@redhat.com>
	<0cb45b07-4cae-0dc5-0605-752f2e0dfda1@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <0cb45b07-4cae-0dc5-0605-752f2e0dfda1@sandeen.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Dave Chinner <david@fromorbit.com>, eguan@redhat.com, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Mon, Jan 09, 2017 at 08:54:02AM -0600, Eric Sandeen wrote:
> On 1/9/17 8:22 AM, Zdenek Kabelac wrote:
> > But could anyone from XFS specify -  why  umount is causing some
> > 'more' damage, then  no umount at all ?
> 
> Please reread this thread...  it /started/ with problems
> /caused by unmount/ for Christoph.
> 
> It's not that unmount damages the filesystem per se; it damages the
> /system/ when it uncovers the underlying mountpoint and applications
> continue writing without error, to the /wrong filesystem/.
> 
> Further, if unmount requires IO that can't complete due to ENOSPC,
> then launching the unmount behind the admin's back may cause other
> problems when it gets detached from the namespace.
> 
> Christoph later clarified:
> 
> > Even on a production system I'd much rather have a shutdown XFS fs
> > than LVM trying to unmount, probably hanging because there are busy
> > fds on the fs, and if not the application might not write to another
> > fs becaus of this.  It's just an amazingly stupid idea.
> 
> And again:
> 
> > invi[si]bly unmounting
> > a file system behind the users back is actively harmful, as it is
> > contradicting the principle of least surprise, and the xfstests mess
> > is one simple example for it.
> ...
> > [ it's undesirable to ] unmount and expose the namespace below it,
> > which the administrator has probably intentionally hid.
> 
> > Even worse unmount may trigger further writes and with fses not
> > handling them the fs might now be stuck after being detached from
> > the namespace without a way for the admin to detect or recover this.
> 
> Dave agreed:
> 
> > And my 2c worth on the "lvm unmounting filesystems on error" - stop
> > it, now. It's the wrong thing to do, and it makes it impossible for
> > filesystems to handle the error and recover gracefully when
> > possible.
> 
> Now, as for:
> 
> > Is xfs refusing to umount 'erroring' device ? 
> 
> I'm not sure what you mean by this.  XFS never unmounts itself.
> If you're asking if an XFS filesystem in an error state (i.e., shutdown,
> or with failing IOs) can unmount - yes, it is possible to unmount
> a filesystem in this state.  The administrator can make that choice.
> 
> 
> 
> You've had two preeminent XFS developers ask repeatedly that

Three.  We've improved XFS' behavior w.r.t. error codes from lower
layers, so please just let XFS (and everything else) deal with it.  If
the FS actually gets corrupt when log writes fail then let's get a bug
report going and actually fix that.  Every filesystem driver has some
sort of well-known strategy for dealing with problems -- XFS shuts down;
ext4 can remount, continue, or panic; etc.  As a convention we don't
nuke mountpoints from orbit when storage errors happen; this is clearly
a surprising deviation from that.

--D

> you stop unmounting xfs from lvm2.  I really wish you would take their
> advice.
> 
> We need to work together to ensure that these subsystems react
> in the best possible way to overprovisioned storage, and give the admin
> the best chance at recovery without more adverse affects.  For the reasons
> stated above, unmounting the filesystem does not achieve this goal.
> 
> It leads to application IO to wrong filesystems (quite possibly root),
> detached filesystems which can no longer be administered, possible hung
> unmounts, etc.  Automatic unmount is the wrong reaction, please stop doing
> it.
> 
> Thanks,
> -Eric
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
