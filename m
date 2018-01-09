From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 2/5] nvme/multipath: Consult blk_status_t for failover
Date: Tue, 9 Jan 2018 10:38:58 -0700
Message-ID: <20180109173857.GF15154@localhost.localdomain>
References: <20180104224623.8944-1-keith.busch@intel.com>
 <20180104224623.8944-3-keith.busch@intel.com>
 <20180108095707.GD4673@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180108095707.GD4673@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On Mon, Jan 08, 2018 at 01:57:07AM -0800, Christoph Hellwig wrote:
> > -	if (unlikely(nvme_req(req)->status && nvme_req_needs_retry(req))) {
> > -		if (nvme_req_needs_failover(req)) {
> > +	blk_status_t status = nvme_error_status(req);
> > +
> > +	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
> > +		if (nvme_req_needs_failover(req, status)) {
> 
> We don't really need to call nvme_error_status if nvme_req(req)->status
> is zero.

We are already calling nvme_error_status unconditionally for
blk_mq_end_request, so we currently read nvme_req(req)->status multiple
times in the completion path. I think we'd prefer to read it just once.
