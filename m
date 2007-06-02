From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
  and dm/md.
Date: Sat, 02 Jun 2007 18:20:38 +0900
Message-ID: <46613666.7010800@gmail.com>
References: <465C871F.708@cfl.rr.com> <20070529234832.GT85884050@sgi.com> <Pine.LNX.4.64.0705291653230.31474@asgard.lang.hm> <20070530061723.GY85884050@sgi.com> <Pine.LNX.4.64.0705300946220.8246@asgard.lang.hm> <20070531002011.GC85884050@sgi.com> <20070531062644.GI32105@kernel.dk> <20070531070307.GK85884050@sgi.com> <20070531070656.GK32105@kernel.dk> <465F8F71.20302@gmail.com> <20070601082140.GP32105@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070601082140.GP32105@kernel.dk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Chinner <dgc@sgi.com>, david@lang.hm, Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Hello,

Jens Axboe wrote:
>> Would that be very different from issuing barrier and not waiting for
>> its completion?  For ATA and SCSI, we'll have to flush write back cache
>> anyway, so I don't see how we can get performance advantage by
>> implementing separate WRITE_ORDERED.  I think zero-length barrier
>> (haven't looked at the code yet, still recovering from jet lag :-) can
>> serve as genuine barrier without the extra write tho.
> 
> As always, it depends :-)
> 
> If you are doing pure flush barriers, then there's no difference. Unless
> you only guarantee ordering wrt previously submitted requests, in which
> case you can eliminate the post flush.
> 
> If you are doing ordered tags, then just setting the ordered bit is
> enough. That is different from the barrier in that we don't need a flush
> of FUA bit set.

Hmmm... I'm feeling dense.  Zero-length barrier also requires only one
flush to separate requests before and after it (haven't looked at the
code yet, will soon).  Can you enlighten me?

Thanks.

-- 
tejun

