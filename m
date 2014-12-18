From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 0/8] dm: add request-based blk-mq support
Date: Wed, 17 Dec 2014 23:58:24 -0500
Message-ID: <20141218045823.GA31672@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<alpine.LNX.2.00.1412172133240.4026@localhost.lm.intel.com>
	<5491F906.1090004@kernel.dk> <20141217230622.GC15390@redhat.com>
	<alpine.LNX.2.00.1412180101580.4026@localhost.lm.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1412180101580.4026@localhost.lm.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, bvanassche@acm.org, hch@infradead.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com
List-Id: dm-devel.ids

On Wed, Dec 17 2014 at  8:41pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> On Wed, 17 Dec 2014, Mike Snitzer wrote:
> >As for blk-mq support... I don't have access to any NVMe hardware, etc.
> >I only tested with virtio-blk (to a ramdisk, scsi-debug, device on the
> >host) so I'm really going to need to lean on Keith and others to
> >validate blk-mq performance.
> 
> There's a reason no one has multipath capable NVMe drives: they are not
> generally available to anyone right now. :) Mine is a prototype so not
> a good candidate for performance comparisons.
> 
> I was able to get my loaner back a couple hours ago though, so I built and
> tested your tree and happy to say it is very successful. While running
> filesystem fio, I simulated path alternating hot-removal/add sequences
> and everything worked. So functionally it appears great, but I can't
> speak on performance right now.

Great news.
 
> One thing with dual ported PCI-e SSDs is each path can be on a different
> pci domain local to different NUMA nodes. I think there's performance
> to gain if we select the target path closest to the CPU that the thread
> is scheduled on. I don't have data to back that up yet, but could such
> a path selection algorithm be considered in the future?

Definitely, if you look at the comment above
dm-mpath.c:parse_path_selector() you'll see that we have a very generic
mechanism for seeding the path selectors with information that they'll
use as the basis for deciding which path to select.  So in this case
we'd have userspace supply the path to NUMA node mapping, etc.  Not
exactly sure what it'd look like at this point but it should be doable.
