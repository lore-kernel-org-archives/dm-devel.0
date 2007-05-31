From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,  filesystems, and dm/md.
Date: Thu, 31 May 2007 20:58:37 +0200
Message-ID: <20070531185836.GC32105@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <465DAA15.3070703@cfl.rr.com> <465DDE1D.3000809@cfl.rr.com> <20070531062404.GH32105@kernel.dk> <465F15ED.1070304@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <465F15ED.1070304@cfl.rr.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>, David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>, Stefan Bader <Stefan.Bader@de.ibm.com>
List-Id: dm-devel.ids

On Thu, May 31 2007, Phillip Susi wrote:
> Jens Axboe wrote:
> >No Stephan is right, the barrier is both an ordering and integrity
> >constraint. If a driver completes a barrier request before that request
> >and previously submitted requests are on STABLE storage, then it
> >violates that principle. Look at the code and the various ordering
> >options.
> 
> I am saying that is the wrong thing to do.  Barrier should be about 
> ordering only.  So long as the order they hit the media is maintained, 
> the order the requests are completed in can change.  barrier.txt bears 

But you can't guarentee ordering without flushing the data out as well.
It all depends on the type of cache on the device, of course. If you
look at the ordinary sata/ide drive with write back caching, you can't
just issue the requests in order and pray that the drive cache will make
it to platter.

If you don't have write back caching, or if the cache is battery backed
and thus guarenteed to never be lost, maintaining order is naturally
enough.

Or if the drive can do ordered queued commands, you can relax the
flushing (again depending on the cache type, you may need to take
different paths).

> "Requests in ordered sequence are issued in order, but not required to 
> finish in order.  Barrier implementation can handle out-of-order 
> completion of ordered sequence.  IOW, the requests MUST be processed in 
> order but the hardware/software completion paths are allowed to reorder 
> completion notifications - eg. current SCSI midlayer doesn't preserve 
> completion order during error handling."

If you carefully re-read that paragraph, then it just tells you that the
software implementation can deal with reordered completions. It doesn't
relax the rconstraints on ordering and integrity AT ALL.

-- 
Jens Axboe

