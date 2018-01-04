From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 4/5] nvme/multipath: Use blk_retryable
Date: Thu, 4 Jan 2018 18:44:37 -0500
Message-ID: <20180104234436.GE16051@redhat.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
 <20180104224623.8944-5-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180104224623.8944-5-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On Thu, Jan 04 2018 at  5:46pm -0500,
Keith Busch <keith.busch@intel.com> wrote:

> Uses common code for determining if an error should be retried on
> alternate path.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>

Acked-by: Mike Snitzer <snitzer@redhat.com>
