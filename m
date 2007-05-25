From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Re: [RFD] BIO_RW_BARRIER - what it means for devices,
	filesystems, and dm/md.
Date: Fri, 25 May 2007 10:49:39 -0400
Message-ID: <4656F783.3000603@cfl.rr.com>
References: <18006.38689.818186.221707@notabene.brown>
	<20070525111557.GP85884050@sgi.com>
	<20070525114910.GQ7653@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070525114910.GQ7653@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Jens Axboe wrote:
> A barrier write will include a flush, but it may also use the FUA bit to
> ensure data is on platter. So the only situation where a fallback from a
> barrier to flush would be valid, is if the device lied and told you it
> could do FUA but it could not and that is the reason why the barrier
> write failed. If that is the case, the block layer should stop using FUA
> and fallback to flush-write-flush. And if it does that, then there's
> never a valid reason to switch from using barrier writes to
> blkdev_issue_flush() since both methods would either both work or both
> fail.

IIRC, the FUA bit only forces THAT request to hit the platter before it 
is completed; it does not flush any previous requests still sitting in 
the write back queue.  Because all io before the barrier must be on the 
platter as well, setting the FUA bit on the barrier request means you 
don't have to follow it with a flush, but you still have to precede it 
with a flush.

> It's not block layer breakage, it's a device issue.

How isn't it block layer breakage?  If the device does not support 
barriers, isn't it the job of the block layer ( probably the scheduler ) 
to fall back to flush-write-flush?
