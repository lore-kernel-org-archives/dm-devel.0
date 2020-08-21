From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] block: replace bd_set_size with bd_set_nr_sectors
Date: Fri, 21 Aug 2020 11:24:17 +0200
Message-ID: <93b6d1f0-84e5-d1b9-ac00-bfb61968e2aa@suse.de>
References: <20200821085600.2395666-1-hch@lst.de>
 <20200821085600.2395666-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200821085600.2395666-2-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>, Josef Bacik <josef@toxicpanda.com>, Xianting Tian <xianting_tian@126.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

On 8/21/20 10:55 AM, Christoph Hellwig wrote:
> Replace bd_set_size with a version that takes the number of sectors
> instead, as that fits most of the current and future callers much better.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/loop.c     |  4 ++--
>  drivers/block/nbd.c      |  7 ++++---
>  drivers/block/pktcdvd.c  |  2 +-
>  drivers/nvme/host/nvme.h |  2 +-
>  fs/block_dev.c           | 10 +++++-----
>  include/linux/genhd.h    |  2 +-
>  6 files changed, 14 insertions(+), 13 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
