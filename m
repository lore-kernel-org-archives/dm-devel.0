From: "Stefan Bader" <sbader3@googlemail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Tue, 29 May 2007 11:12:27 +0200
Message-ID: <5201e28f0705290212q60dc1bcfkfc234b321f3c3b64@mail.gmail.com>
References: <18006.38689.818186.221707@notabene.brown>
	 <5201e28f0705250652mff2735dwd2c14f5ad130ae97@mail.gmail.com>
	 <18010.12880.258773.95448@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <18010.12880.258773.95448@notabene.brown>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

> > 2007/5/25, Neil Brown <neilb@suse.de>:
> > BIO_RW_FAILFAST: means low-level driver shouldn't do much (or no)
> > error recovery. Mainly used by mutlipath targets to avoid long SCSI
> > recovery. This should just be propagated when passing requests on.
>
> Is it "much" or "no"?
> Would it be reasonable to use this for reads from a non-degraded
> raid1?  What about writes?
>
This depends on the device driver's implementation. AFAIK there is no
fix rule how to handle that flag exactly. The SCSI driver seems to
omit internal recovery procedures but requests still can take as long
as the SCSI request time-out. I am not sure of all internals. Maybe
some error recovery is done as long as it shouldn't take very long.
For the DASD driver on zSeries this flags will only affect situations
when the driver decides there is no other way of succeeding. Recovery
is still done.
Using this flag was intended to move error handling to an upper layer
in the device stack. For multipathing it is good to be able to map a
request to another path instead of waiting until the SCSI layer
finally would give up with one path. For a RAID1 this might cause
requests to fail which would have been recovered. This might require
more error handling in md.
The error code as it is at this time doesn't say much in detail. I
once saw patches (and there are comments about a path missing from
Jens Axboe) to pass sense data (from SCSI) in the bio. I am not sure
whether this was dropped for some reason or just is in the pipe. Jens?

Stefan
