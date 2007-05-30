From: David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Wed, 30 May 2007 16:17:23 +1000
Message-ID: <20070530061723.GY85884050@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
Sender: linux-fsdevel-owner@vger.kernel.org
To: david@lang.hm
Cc: David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Tue, May 29, 2007 at 05:01:24PM -0700, david@lang.hm wrote:
> On Wed, 30 May 2007, David Chinner wrote:
> 
> >On Tue, May 29, 2007 at 04:03:43PM -0400, Phillip Susi wrote:
> >>David Chinner wrote:
> >>>The use of barriers in XFS assumes the commit write to be on stable
> >>>storage before it returns.  One of the ordering guarantees that we
> >>>need is that the transaction (commit write) is on disk before the
> >>>metadata block containing the change in the transaction is written
> >>>to disk and the current barrier behaviour gives us that.
> >>
> >>Barrier != synchronous write,
> >
> >Of course. FYI, XFS only issues barriers on *async* writes.
> >
> >But barrier semantics - as far as they've been described by everyone
> >but you indicate that the barrier write is guaranteed to be on stable
> >storage when it returns.
> 
> this doesn't match what I have seen
> 
> wtih barriers it's perfectly legal to have the following sequence of 
> events
> 
> 1. app writes block 10 to OS
> 2. app writes block 4 to OS
> 3. app writes barrier to OS
> 4. app writes block 5 to OS
> 5. app writes block 20 to OS

hmmmmm - applications can't issue barriers to the filesystem.
However, if you consider the barrier to be an "fsync()" for example,
then it's still the filesystem that is issuing the barrier and
there's a block that needs to be written that is associated with
that barrier (either an inode or a transaction commit) that needs to
be on stable storage before the filesystem returns to userspace.

> 6. OS writes block 4 to disk drive
> 7. OS writes block 10 to disk drive
> 8. OS writes barrier to disk drive
> 9. OS writes block 5 to disk drive
> 10. OS writes block 20 to disk drive

Replace OS with filesystem, and combine 7+8 together - we don't have
zero-length barriers and hence they are *always* associated with a
write to a certain block on disk. i.e.:

1. FS writes block 4 to disk drive
2. FS writes block 10 to disk drive
3. FS writes *barrier* block X to disk drive
4. FS writes block 5 to disk drive
5. FS writes block 20 to disk drive

The order that these are expected by the filesystem to hit stable
storage are:

1. block 4 and 10 on stable storage in any order
2. barrier block X on stable storage
3. block 5 and 20 on stable storage in any order

The point I'm trying to make is that in XFS,  block 5 and 20 cannot
be allowed to hit the disk before the barrier block because they
have strict order dependency on block X being stable before them,
just like block X has strict order dependency that block 4 and 10
must be stable before we start the barrier block write.

> 11. disk drive writes block 10 to platter
> 12. disk drive writes block 4 to platter
> 13. disk drive writes block 20 to platter
> 14. disk drive writes block 5 to platter

> if the disk drive doesn't support barriers then step #8 becomes 'issue 
> flush' and steps 11 and 12 take place before step #9, 13, 14

No, you need a flush on either side of the block X write to maintain
the same semantics as barrier writes currently have.

We have filesystems that require barriers to prevent reordering of
writes in both directions and to ensure that the block associated
with the barrier is on stable storage when I/o completion is
signalled.  The existing barrier implementation (where it works)
provide these requirements. We need barriers to retain these
semantics, otherwise we'll still have to do special stuff in
the filesystems to get the semantics that we need.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
