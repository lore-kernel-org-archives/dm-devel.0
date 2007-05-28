From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] Re: [RFD] BIO_RW_BARRIER - what it means for devices,  filesystems, and dm/md.
Date: Mon, 28 May 2007 20:32:52 +0200
Message-ID: <20070528183252.GH7653@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown> <20070525111557.GP85884050@sgi.com> <20070525114910.GQ7653@kernel.dk> <4656F783.3000603@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4656F783.3000603@cfl.rr.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: device-mapper development <dm-devel@redhat.com>, David Chinner <dgc@sgi.com>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


(dunny why you explicitly dropped me off the cc/to list when replying to
my email, hence I missed it for 3 days)

On Fri, May 25 2007, Phillip Susi wrote:
> Jens Axboe wrote:
> >A barrier write will include a flush, but it may also use the FUA bit to
> >ensure data is on platter. So the only situation where a fallback from a
> >barrier to flush would be valid, is if the device lied and told you it
> >could do FUA but it could not and that is the reason why the barrier
> >write failed. If that is the case, the block layer should stop using FUA
> >and fallback to flush-write-flush. And if it does that, then there's
> >never a valid reason to switch from using barrier writes to
> >blkdev_issue_flush() since both methods would either both work or both
> >fail.
> 
> IIRC, the FUA bit only forces THAT request to hit the platter before it 
> is completed; it does not flush any previous requests still sitting in 
> the write back queue.  Because all io before the barrier must be on the 
> platter as well, setting the FUA bit on the barrier request means you 
> don't have to follow it with a flush, but you still have to precede it 
> with a flush.

I'm well aware of how FUA works, hence the barrier FUA implementation
does flush and then write-fua. The win compared to flush-write-flush is
just a saved command, essentially.

> >It's not block layer breakage, it's a device issue.
> 
> How isn't it block layer breakage?  If the device does not support 
> barriers, isn't it the job of the block layer ( probably the scheduler ) 
> to fall back to flush-write-flush?

The problem is flush not working, the block layer can't fix that for you
obviously. If it's FUA not working, the block layer should fall back to
flush-write-flush, as they are obviously functionally equivalent.

-- 
Jens Axboe

