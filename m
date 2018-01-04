From: Christoph Hellwig <hch@lst.de>
Subject: Re: [for-4.16 PATCH v2 0/5] block, nvme, dm: allow DM multipath to
        use NVMe's error handler
Date: Thu, 4 Jan 2018 11:26:31 +0100
Message-ID: <20180104102631.GA4864@lst.de>
References: <20171227032257.8182-1-snitzer@redhat.com> <20180102232943.GC26533@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180102232943.GC26533@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jan 02, 2018 at 04:29:43PM -0700, Keith Busch wrote:
> Instead of hiding NVMe path related errors, the NVMe driver needs to
> code an appropriate generic block status from an NVMe status.
> 
> We already do this translation whether or not CONFIG_NVME_MULTIPATHING is
> set, so I think it's silly NVMe native multipathing has a second status
> decoder. This just doubles the work if we need to handle any new NVMe
> status codes in the future.
> 
> I have a counter-proposal below that unifies NVMe-to-block status
> translations, and combines common code for determining if an error is a
> path failure. This should work for both NVMe and DM, and DM won't need
> NVMe specifics.
> 
> I can split this into a series if there's indication this is ok and
> satisfies the need.

You'll need to update nvme_error_status to account for all errors
handled in nvme_req_needs_failover, and you will probably have to
add additional BLK_STS_* code.  But if this is all that the rage was
about I'm perfectly fine with it.
