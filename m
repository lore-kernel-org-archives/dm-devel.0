From: Christoph Hellwig <hch@lst.de>
Subject: Re: [for-4.16 PATCH v2 1/5] block: establish request failover
        callback
Date: Fri, 29 Dec 2017 11:10:13 +0100
Message-ID: <20171229101013.GA25333@lst.de>
References: <20171227032257.8182-1-snitzer@redhat.com> <20171227032257.8182-2-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171227032257.8182-2-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, hch@lst.de, keith.busch@intel.com, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Dec 26, 2017 at 10:22:53PM -0500, Mike Snitzer wrote:
> All requests allocated from a request_queue with this callback set can
> failover their requests during completion.
> 
> This callback is expected to use the blk_steal_bios() interface to
> transfer a request's bios back to an upper-layer bio-based
> request_queue.
> 
> This will be used by both NVMe multipath and DM multipath.  Without it
> DM multipath cannot get access to NVMe-specific error handling that NVMe
> core provides in nvme_complete_rq().

And the whole point is that it should not get any such access.

The reason why we did nvme multipathing differently is because the
design of dm-multipath inflicts so much pain on users that we absolutely
want to avoid it this time around.
