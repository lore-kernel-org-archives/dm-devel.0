From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Fri, 25 May 2007 19:03:09 -0600
Message-ID: <20070526010308.GE5181@schatzie.adilger.int>
References: <18006.38689.818186.221707@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

On May 25, 2007  17:58 +1000, Neil Brown wrote:
>    These devices would find it very hard to support BIO_RW_BARRIER.
>    Doing this would require keeping track of all in-flight requests
>    (which some, possibly all, of the above don't) and then:
>      When a BIO_RW_BARRIER request arrives:
>         wait for all pending writes to complete
>         call blkdev_issue_flush on all devices
>         issue the barrier write to the target device(s)
>            as BIO_RW_BARRIER,
>         if that is -EOPNOTSUP, re-issue, wait, flush.

We noticed when testing the SLES10 kernel (which has barriers enabled
by default) that ext3 write throughput went from about 170MB/s to about
130MB/s (on high-end RAID storage using no-op scheduler).

The reason (as far as we could tell) is that the barriers are implemented
by flushing and waiting for all previosly submitted IOs to finish, but
all that ext3/jbd really care about is that the journal blocks are safely
on disk.

Since the journal blocks are only a small fraction of the total IO in
flight, the barrier + write cache ends up being a lot worse than just
doing synchronous IO with the write cache disabled because no new IO can
be submitted past the barrier, and since that IO is large and contiguous
it might complete much faster than the scattered metadata updates that are
also being checkpointed to disk from the previous transactions.  With jbd
there can be both a running and a committing transaction, and multiple
checkpointing transactions, and the use of barriers breaks this important
optimization.

If ext3 used an external journal this problem would be avoided,
but then there isn't really a need for barriers in the first place, since
the jbd code already will handle the wait for the commit block itself.

We've got a pretty-much complete version of the ext3 journal checksumming
patch that avoids the need to do the pre-commit barrier, since the checksum
can verify at recovery time whether all of the transaction's blocks made
it to disk or not (which is what the commit block is all about in the end).

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

