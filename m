From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/5] nvme/multipath: Consult blk_status_t for failover
Date: Thu, 4 Jan 2018 18:42:59 -0500
Message-ID: <20180104234259.GC16051@redhat.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
 <20180104224623.8944-3-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104224623.8944-3-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On Thu, Jan 04 2018 at  5:46pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> This removes nvme multipath's specific status decoding to see if failover
> is needed, using the generic blk_status_t that was translated earlier. This
> abstraction from the raw NVMe status means nvme status decoding exists
> in just one place.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
