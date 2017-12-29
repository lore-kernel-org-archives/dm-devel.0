From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [for-4.16 PATCH v2 2/5] nvme: use request_queue's failover_rq_fn
 callback for multipath failover
Date: Fri, 29 Dec 2017 15:22:00 -0500
Message-ID: <20171229202200.GB8876@redhat.com>
References: <20171227032257.8182-1-snitzer@redhat.com>
 <20171227032257.8182-3-snitzer@redhat.com>
 <20171229101119.GB25333@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171229101119.GB25333@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, keith.busch@intel.com, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Dec 29 2017 at  5:11am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Independent on any policy question as raised in reply to the previous
> patch:  until the ANA (ALUA equivalent for NVMe) spec has been finalized
> and our code for it has landed there is no way we're going to expose
> anything from this code based as it will be highly in flux.

Please stop hiding behind specs like they are governing this aspect of
Linux's NVMe implementation.

Please just own the need for NVMe to provide DM multipathing
compatibility.

Thanks.
