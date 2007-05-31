From: David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Fri, 1 Jun 2007 09:34:49 +1000
Message-ID: <20070531233449.GT86004887@sgi.com>
References: <20070528024559.GA85884050@sgi.com> <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com> <465F1479.70100@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <465F1479.70100@cfl.rr.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>, david@lang.hm, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Thu, May 31, 2007 at 02:31:21PM -0400, Phillip Susi wrote:
> David Chinner wrote:
> >That sounds like a good idea - we can leave the existing
> >WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
> >behaviour that only guarantees ordering. The filesystem can then
> >choose which to use where appropriate....
> 
> So what if you want a synchronous write, but DON'T care about the order? 

submit_bio(WRITE_SYNC, bio);

Already there, already used by XFS, JFS and direct I/O.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
