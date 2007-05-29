From: David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Wed, 30 May 2007 09:48:32 +1000
Message-ID: <20070529234832.GT85884050@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <465C871F.708@cfl.rr.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Tue, May 29, 2007 at 04:03:43PM -0400, Phillip Susi wrote:
> David Chinner wrote:
> >The use of barriers in XFS assumes the commit write to be on stable
> >storage before it returns.  One of the ordering guarantees that we
> >need is that the transaction (commit write) is on disk before the
> >metadata block containing the change in the transaction is written
> >to disk and the current barrier behaviour gives us that.
> 
> Barrier != synchronous write,

Of course. FYI, XFS only issues barriers on *async* writes.

But barrier semantics - as far as they've been described by everyone
but you indicate that the barrier write is guaranteed to be on stable
storage when it returns.

> so if XFS relies on that block being on 
> the media when the request is completed, then it is broken.

XFS relies on the block being stable before any other write
goes to disk. That is the semantic that the barrier I/Os currently
have. How that is implemented in the device is irrelevant to me,
but if I issue a barrier I/O, I do not expect *any* I/O to be
reordered around it.

> It should 
> only care that the ordering of log-data-log is maintained, not exactly 
> when each specific request completes.

Yes, and that is provided to XFS by the fact that barrier I/Os are
full barriers....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
