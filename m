From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 2/5] nvme/multipath: Consult blk_status_t for failover
Date: Mon, 8 Jan 2018 09:57:13 +0100
Message-ID: <1fbfce0c-2666-95c8-34e8-e0c1dd5f58af@suse.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
 <20180104224623.8944-3-keith.busch@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180104224623.8944-3-keith.busch@intel.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>, Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>
List-Id: dm-devel.ids

On 01/04/2018 11:46 PM, Keith Busch wrote:
> This removes nvme multipath's specific status decoding to see if failover
> is needed, using the generic blk_status_t that was translated earlier. This
> abstraction from the raw NVMe status means nvme status decoding exists
> in just one place.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> ---
>  drivers/nvme/host/core.c      |  9 +++++----
>  drivers/nvme/host/multipath.c | 44 ++++++++-----------------------------------
>  drivers/nvme/host/nvme.h      |  4 ++--
>  3 files changed, 15 insertions(+), 42 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
