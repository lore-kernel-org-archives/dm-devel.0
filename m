From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Thu, 31 May 2007 08:26:45 +0200
Message-ID: <20070531062644.GI32105@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070531002011.GC85884050@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: david@lang.hm, Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Thu, May 31 2007, David Chinner wrote:
> IOWs, there are two parts to the problem:
> 
> 	1 - guaranteeing I/O ordering
> 	2 - guaranteeing blocks are on persistent storage.
> 
> Right now, a single barrier I/O is used to provide both of these
> guarantees. In most cases, all we really need to provide is 1); the
> need for 2) is a much rarer condition but still needs to be
> provided.
> 
> > if I am understanding it correctly, the big win for barriers is that you 
> > do NOT have to stop and wait until the data is on persistant media before 
> > you can continue.
> 
> Yes, if we define a barrier to only guarantee 1), then yes this
> would be a big win (esp. for XFS). But that requires all filesystems
> to handle sync writes differently, and sync_blockdev() needs to
> call blkdev_issue_flush() as well....
> 
> So, what do we do here? Do we define a barrier I/O to only provide
> ordering, or do we define it to also provide persistent storage
> writeback? Whatever we decide, it needs to be documented....

The block layer already has a notion of the two types of barriers, with
a very small amount of tweaking we could expose that. There's absolutely
zero reason we can't easily support both types of barriers.

-- 
Jens Axboe

