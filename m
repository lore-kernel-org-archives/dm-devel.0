From: Christoph Hellwig <hch@lst.de>
Subject: Re: [for-4.16 PATCH v2 2/5] nvme: use request_queue's
        failover_rq_fn callback for multipath failover
Date: Fri, 29 Dec 2017 11:11:19 +0100
Message-ID: <20171229101119.GB25333@lst.de>
References: <20171227032257.8182-1-snitzer@redhat.com> <20171227032257.8182-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171227032257.8182-3-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, hch@lst.de, keith.busch@intel.com, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Independent on any policy question as raised in reply to the previous
patch:  until the ANA (ALUA equivalent for NVMe) spec has been finalized
and our code for it has landed there is no way we're going to expose
anything from this code based as it will be highly in flux.
