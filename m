From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath low performance with blk-mq
Date: Wed, 27 Jan 2016 13:16:56 -0500
Message-ID: <20160127181655.GB31802@redhat.com>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com>
	<20160125214016.GA10060@redhat.com>
	<20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com> <56A90388.1030105@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <56A90388.1030105@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "keith.busch@intel.com" <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Wed, Jan 27 2016 at 12:51pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 01/27/2016 10:48 AM, Mike Snitzer wrote:
> >
> >BTW, I _cannot_ get null_blk to come even close to your reported 1500K+
> >IOPs on 2 "fast" systems I have access to.  Which arguments are you
> >loading the null_blk module with?
> >
> >I've been using:
> >modprobe null_blk gb=4 bs=4096 nr_devices=1 queue_mode=2 submit_queues=12
> >
> >On my 1 system is a 12 core single socket, single NUMA node with 12G of
> >memory, I can only get ~500K read IOPs and ~85K write IOPs.
> >
> >On another much larger system with 72 cores and 4 NUMA nodes with 128G
> >of memory, I can only get ~310K read IOPs and ~175K write IOPs.
> 
> Look at the completion method (irqmode) and completion time
> (completion_nsec).

OK, I found that queue_mode=0 (bio-based) is _much_ faster than blk-mq
(2, the default).  Improving to ~950K read IOPs and ~675K write IOPs (on
the single numa node system).

Default for irqmode is 1 (softirq).  2 (timer) yields poor results.  0
(none) seems slightly slower than 1.

And if I use completion_nsec=1 I can bump up to ~990K read IOPs.

Seems the best, for IOPs, so far on this system is with:
modprobe null_blk gb=4 bs=4096 nr_devices=1 queue_mode=0 irqmode=1 completion_nsec=1 submit_queues=4
