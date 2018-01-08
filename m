From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/5] nvme/multipath: Consult blk_status_t for failover
Date: Mon, 8 Jan 2018 10:57:07 +0100
Message-ID: <20180108095707.GD4673@lst.de>
References: <20180104224623.8944-1-keith.busch@intel.com> <20180104224623.8944-3-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104224623.8944-3-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

> -	if (unlikely(nvme_req(req)->status && nvme_req_needs_retry(req))) {
> -		if (nvme_req_needs_failover(req)) {
> +	blk_status_t status = nvme_error_status(req);
> +
> +	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
> +		if (nvme_req_needs_failover(req, status)) {

We don't really need to call nvme_error_status if nvme_req(req)->status
is zero.

> -static inline bool nvme_req_needs_failover(struct request *req)
> +static inline bool nvme_req_needs_failover(struct request *req, blk_status_t error)

line break after 80 characters, please.
