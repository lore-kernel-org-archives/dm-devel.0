From: David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Fri, 1 Jun 2007 17:53:36 +1000
Message-ID: <20070601075336.GX86004887@sgi.com>
References: <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com> <465F1479.70100@cfl.rr.com> <20070531233449.GT86004887@sgi.com> <18015.46551.209946.204238@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18015.46551.209946.204238@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Jens Axboe <jens.axboe@oracle.com>, david@lang.hm, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Fri, Jun 01, 2007 at 03:59:51PM +1000, Neil Brown wrote:
> On Friday June 1, dgc@sgi.com wrote:
> > On Thu, May 31, 2007 at 02:31:21PM -0400, Phillip Susi wrote:
> > > David Chinner wrote:
> > > >That sounds like a good idea - we can leave the existing
> > > >WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
> > > >behaviour that only guarantees ordering. The filesystem can then
> > > >choose which to use where appropriate....
> > > 
> > > So what if you want a synchronous write, but DON'T care about the order? 
> > 
> > submit_bio(WRITE_SYNC, bio);
> > 
> > Already there, already used by XFS, JFS and direct I/O.
> 
> Are you sure?
> 
> You seem to be saying that WRITE_SYNC causes the write to be safe on
> media before the request returns.

Sorry, I wasn't really all that clear :/

What I'm saying the *interface* for higher layer to tell the block layers
that a sync write is being executed is already there. i.e. we can already
tell the block layer that we are doing a synchronous I/O.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
