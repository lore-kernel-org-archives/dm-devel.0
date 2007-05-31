From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,   and dm/md.
Date: Thu, 31 May 2007 21:40:06 +0200
Message-ID: <20070531194005.GH32105@kernel.dk>
References: <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com> <465F1479.70100@cfl.rr.com> <20070531190013.GD32105@kernel.dk> <Pine.LNX.4.64.0705311220080.17389@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760214AbXEaTl1@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705311220080.17389@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
To: david@lang.hm
Cc: Phillip Susi <psusi@cfl.rr.com>, David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Thu, May 31 2007, david@lang.hm wrote:
> On Thu, 31 May 2007, Jens Axboe wrote:
> 
> >On Thu, May 31 2007, Phillip Susi wrote:
> >>David Chinner wrote:
> >>>That sounds like a good idea - we can leave the existing
> >>>WRITE_BARRIER behaviour unchanged and introduce a new WRITE_ORDERED
> >>>behaviour that only guarantees ordering. The filesystem can then
> >>>choose which to use where appropriate....
> >>
> >>So what if you want a synchronous write, but DON'T care about the order?
> >>  They need to be two completely different flags which you can choose
> >>to combine, or use individually.
> >
> >If you have a use case for that, we can easily support it as well...
> >Depending on the drive capabilities (FUA support or not), it may be
> >nearly as slow as a "real" barrier write.
> 
> true, but a "real" barrier write could have significant side effects on 
> other writes that wouldn't happen with a synchronous wrote (a sync wrote 
> can have other, unrelated writes re-ordered around it, a barrier write 
> can't)

That is true, the sync write also has side effects at the drive side
since it may have a varied cost depending on the workload (eg what
already resides in the cache when it is issued), unless FUA is active.
That is also true for the barrier of course, but only for previously
submitted IO as we don't reorder.

I'm not saying that a SYNC write wont be potentially useful, just that
it's definitely not free even outside of the write itself.

-- 
Jens Axboe
