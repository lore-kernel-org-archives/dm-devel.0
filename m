From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Sat, 2 Jun 2007 16:34:39 +0200
Message-ID: <20070602143438.GB32105@kernel.dk>
References: <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm>
	<20070530061723.GY85884050@sgi.com>
	<Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm>
	<20070531002011.GC85884050@sgi.com>
	<20070531062644.GI32105@kernel.dk>
	<20070531070307.GK85884050@sgi.com>
	<20070531070656.GK32105@kernel.dk> <465F8F71.20302@gmail.com>
	<20070601082140.GP32105@kernel.dk> <46613666.7010800@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <46613666.7010800@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Tejun Heo <htejun@gmail.com>
Cc: david@lang.hm, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

On Sat, Jun 02 2007, Tejun Heo wrote:
> Hello,
> 
> Jens Axboe wrote:
> >> Would that be very different from issuing barrier and not waiting for
> >> its completion?  For ATA and SCSI, we'll have to flush write back cache
> >> anyway, so I don't see how we can get performance advantage by
> >> implementing separate WRITE_ORDERED.  I think zero-length barrier
> >> (haven't looked at the code yet, still recovering from jet lag :-) can
> >> serve as genuine barrier without the extra write tho.
> > 
> > As always, it depends :-)
> > 
> > If you are doing pure flush barriers, then there's no difference. Unless
> > you only guarantee ordering wrt previously submitted requests, in which
> > case you can eliminate the post flush.
> > 
> > If you are doing ordered tags, then just setting the ordered bit is
> > enough. That is different from the barrier in that we don't need a flush
> > of FUA bit set.
> 
> Hmmm... I'm feeling dense.  Zero-length barrier also requires only one
> flush to separate requests before and after it (haven't looked at the
> code yet, will soon).  Can you enlighten me?

Yeah, that's what the zero-length barrier implementation I posted does.
Not sure if you have a question beyond that, if so fire away :-)

-- 
Jens Axboe
