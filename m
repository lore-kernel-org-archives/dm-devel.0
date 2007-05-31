From: David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Thu, 31 May 2007 10:20:11 +1000
Message-ID: <20070531002011.GC85884050@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Wed, May 30, 2007 at 09:52:49AM -0700, david@lang.hm wrote:
> On Wed, 30 May 2007, David Chinner wrote:
> >with the barrier is on stable storage when I/o completion is
> >signalled.  The existing barrier implementation (where it works)
> >provide these requirements. We need barriers to retain these
> >semantics, otherwise we'll still have to do special stuff in
> >the filesystems to get the semantics that we need.
> 
> one of us is misunderstanding barriers here.

No, I thinkwe are both on the same level here - it's what
barriers are used for that is not clear understood, I think.

> you are understanding barriers to be the same as syncronous writes. (and 
> therefor the data is on persistant media before the call returns)

No, I'm describing the high level behaviour that is expected by
a filesystem. The reasons for this are below....

> I am understanding barriers to only indicate ordering requirements. things 
> before the barrier can be reordered freely, things after the barrier can 
> be reordered freely, but things cannot be reordered across the barrier.

Ok, that's my understanding of how *device based barriers* can work,
but there's more to it than that. As far as the filesystem is
concerned the barrier write needs to *behave* exactly like a sync
write because of the guarantees the filesystem has to provide
userspace. Specifically - sync, sync writes and fsync.

This is the big problem, right? If we use barriers for commit
writes, the filesystem can return to userspace after a sync write or
fsync() and an *ordered barrier device implementation* may not have
written the blocks to persistent media. If we then pull the plug on
the box, we've just lost data that sync or fsync said was
successfully on disk. That's BAD.

Right now a barrier write on the last block of the fsync/sync write
is sufficient to prevent that because of the FUA on the barrier
block write. A purely ordered barrier implementation does not
provide this guarantee.

This is the crux of my argument - from a filesystem perspective,
there is a *major* difference between a barrier implemented to just
guaranteeing ordering and a barrier implemented with a flush+FUA or
flush+write+flush.

IOWs, there are two parts to the problem:

	1 - guaranteeing I/O ordering
	2 - guaranteeing blocks are on persistent storage.

Right now, a single barrier I/O is used to provide both of these
guarantees. In most cases, all we really need to provide is 1); the
need for 2) is a much rarer condition but still needs to be
provided.

> if I am understanding it correctly, the big win for barriers is that you 
> do NOT have to stop and wait until the data is on persistant media before 
> you can continue.

Yes, if we define a barrier to only guarantee 1), then yes this
would be a big win (esp. for XFS). But that requires all filesystems
to handle sync writes differently, and sync_blockdev() needs to
call blkdev_issue_flush() as well....

So, what do we do here? Do we define a barrier I/O to only provide
ordering, or do we define it to also provide persistent storage
writeback? Whatever we decide, it needs to be documented....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
