From: Neil Brown <neilb@suse.de>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Mon, 28 May 2007 11:37:20 +1000
Message-ID: <18010.12880.258773.95448@notabene.brown>
References: <18006.38689.818186.221707@notabene.brown>
	<5201e28f0705250652mff2735dwd2c14f5ad130ae97@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stefan Bader on Friday May 25
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Bader <Stefan.Bader@de.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

On Friday May 25, Stefan.Bader@de.ibm.com wrote:
> 2007/5/25, Neil Brown <neilb@suse.de>:
> >  - Are there other bit that we could handle better?
> >     BIO_RW_FAILFAST?  BIO_RW_SYNC?  What exactly do they mean?
> >
> BIO_RW_FAILFAST: means low-level driver shouldn't do much (or no)
> error recovery. Mainly used by mutlipath targets to avoid long SCSI
> recovery. This should just be propagated when passing requests on.

Is it "much" or "no"?
Would it be reasonable to use this for reads from a non-degraded
raid1?  What about writes?

What I would really like is some clarification on what sort of errors
get retried, how often, and how much timeout there is..

And does the 'error' code returned in ->bi_end_io allow us to
differentiate media errors from other errors yet?

> 
> BIO_RW_SYNC: means this is a bio of a synchronous request. I don't
> know whether there are more uses to it but this at least causes queues
> to be flushed immediately instead of waiting for more requests for a
> short time. Should also just be passed on. Otherwise performance gets
> poor since something above will rather wait for the current
> request/bio to complete instead of sending more.

Yes, this one is pretty straight forward.. I mentioned it more as a
reminder to my self that I really should support it in raid5 :-(

NeilBrown
