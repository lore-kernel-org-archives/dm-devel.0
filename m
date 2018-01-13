From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH V3 0/5]  dm-rq: improve sequential I/O performance
Date: Fri, 12 Jan 2018 19:52:14 -0500
Message-ID: <20180113005213.GB7207@redhat.com>
References: <20180112014232.GB25090@ming.t460p>
 <20180112015721.GB32298@redhat.com>
 <20180112033308.GC25090@ming.t460p>
 <20180112171840.GA4541@redhat.com>
 <1515778013.2396.3.camel@wdc.com>
 <20180112174000.GB5134@redhat.com>
 <1515779211.2396.11.camel@wdc.com>
 <20180112180635.GD5134@redhat.com>
 <1515783288.2396.37.camel@wdc.com>
 <AT5PR8401MB0387801D9DC1686503921AE5AB170@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AT5PR8401MB0387801D9DC1686503921AE5AB170@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
Sender: linux-block-owner@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 12 2018 at  2:53pm -0500,
Elliott, Robert (Persistent Memory) <elliott@hpe.com> wrote:

> 
> 
> > -----Original Message-----
> > From: linux-block-owner@vger.kernel.org [mailto:linux-block-
> > owner@vger.kernel.org] On Behalf Of Bart Van Assche
> ...
> > The intention of commit 6077c2d706097c0 was to address the last mentioned
> > case. It may be possible to move the delayed queue rerun from the
> > dm_queue_rq() into dm_requeue_original_request(). But I think it would be
> > wrong to rerun the queue immediately in case a SCSI target system returns
> > "BUSY".
> 
> Seeing SCSI BUSY mentioned here...
> 
> On its own, patch 6077c2d706 seems to be adding an arbitrarily selected
> magic value of 100 ms without explanation in the patch description or
> in the added code.

It was 50 ms before it was 100 ms.  No real explaination for these
values other than they seem to make Bart's IB SRP testbed happy?
 
> But, dm_request_original_request() already seems to have chosen that value
> for similar purposes:
>         unsigned long delay_ms = delay_requeue ? 100 : 0;
> 
> So, making them share a #define would indicate there's a reason for that
> particular value.  Any change to the value would be picked up everywhere.
> 
> All the other callers of blk_mq_delay_run_hw_queue() use macros:
> drivers/md/dm-rq.c:             blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
> drivers/nvme/host/fc.c:         blk_mq_delay_run_hw_queue(queue->hctx, NVMEFC_QUEUE_DELAY);
> drivers/scsi/scsi_lib.c:                blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
> drivers/scsi/scsi_lib.c:                        blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);

Sure, I'll add a #define.

> Those both happen to be set to 3 (ms).

As for the value of 100, we're dealing with path faults so retrying them
extremely fast could be wasted effort.  But there is obviously no once
size fits all.  As storage gets faster 100 ms could prove to be very
bad.

But without tests to verify a change, there won't be one.

Thanks,
Mike
