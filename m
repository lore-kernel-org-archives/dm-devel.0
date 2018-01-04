From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v2 0/5] block, nvme, dm: allow DM multipath to
 use NVMe's error handler
Date: Thu, 4 Jan 2018 09:08:52 -0500
Message-ID: <20180104140852.GA13288@redhat.com>
References: <20171227032257.8182-1-snitzer@redhat.com>
 <20180102232943.GC26533@localhost.localdomain>
 <20180104102631.GA4864@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104102631.GA4864@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <keith.busch@intel.com>, axboe@kernel.dk, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Jan 04 2018 at  5:26am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Jan 02, 2018 at 04:29:43PM -0700, Keith Busch wrote:
> > Instead of hiding NVMe path related errors, the NVMe driver needs to
> > code an appropriate generic block status from an NVMe status.
> > 
> > We already do this translation whether or not CONFIG_NVME_MULTIPATHING is
> > set, so I think it's silly NVMe native multipathing has a second status
> > decoder. This just doubles the work if we need to handle any new NVMe
> > status codes in the future.
> > 
> > I have a counter-proposal below that unifies NVMe-to-block status
> > translations, and combines common code for determining if an error is a
> > path failure. This should work for both NVMe and DM, and DM won't need
> > NVMe specifics.
> > 
> > I can split this into a series if there's indication this is ok and
> > satisfies the need.
> 
> You'll need to update nvme_error_status to account for all errors
> handled in nvme_req_needs_failover, and you will probably have to
> add additional BLK_STS_* code.  But if this is all that the rage was
> about I'm perfectly fine with it.

Glad you're fine with it.  I thought you'd balk at this too.  Mainly
because I was unaware nvme_error_status() existed; so I thought any
amount of new NVMe error translation for upper-layer consumption would
be met with resistence.

Keith arrived at this approach based on an exchange we had in private.

I gave him context for DM multipath's need to access the code NVMe uses
to determine if an NVMe-specific error is retryable or not.  Explained
how SCSI uses scsi_dh error handling and
drivers/scsi/scsi_lib.c:__scsi_error_from_host_byte() to establish a
"differentiated IO error", and then
drivers/md/dm-mpath.c:noretry_error() consumes the resulting BLK_STS_*.

Armed with this context Keith was able to take his NVMe knowledge and
arrive at something you're fine with.  Glad it worked out.

Thanks,
Mike
