From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle
Date: Fri, 19 Jan 2018 15:34:23 +0800
Message-ID: <20180119073423.GC25369@ming.t460p>
References: <20180118024124.8079-1-ming.lei@redhat.com>
 <b2e5b7e6-ce4b-6053-adae-63cc44d773af@wdc.com>
 <20180118170353.GB19734@redhat.com>
 <1516296056.2676.23.camel@wdc.com>
 <20180118183039.GA20121@redhat.com>
 <1516301278.2676.35.camel@wdc.com>
 <deeb2b2e-6d0e-a144-843d-d08626de8aea@kernel.dk>
 <20180119023212.GA25413@ming.t460p>
 <1516338585.4077.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516338585.4077.1.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@infradead.org" <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 19, 2018 at 05:09:46AM +0000, Bart Van Assche wrote:
> On Fri, 2018-01-19 at 10:32 +0800, Ming Lei wrote:
> > Now most of times both NVMe and SCSI won't return BLK_STS_RESOURCE, and
> > it should be DM-only which returns STS_RESOURCE so often.
> 
> That's wrong at least for SCSI. See also https://marc.info/?l=linux-block&m=151578329417076.
> 

> For other scenario's, e.g. if a SCSI initiator submits a
> SCSI request over a fabric and the SCSI target replies with "BUSY" then the

Could you explain a bit when SCSI target replies with BUSY very often?

Inside initiator, we have limited the max per-LUN requests and per-host
requests already before calling .queue_rq().

> SCSI core will end the I/O request with status BLK_STS_RESOURCE after the
> maximum number of retries has been reached (see also scsi_io_completion()).
> In that last case, if a SCSI target sends a "BUSY" reply over the wire back
> to the initiator, there is no other approach for the SCSI initiator to
> figure out whether it can queue another request than to resubmit the
> request. The worst possible strategy is to resubmit a request immediately
> because that will cause a significant fraction of the fabric bandwidth to
> be used just for replying "BUSY" to requests that can't be processed
> immediately.


-- 
Ming
