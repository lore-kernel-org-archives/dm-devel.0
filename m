From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] nvme: don't call revalidate_disk from
 nvme_set_queue_dying
Date: Mon, 24 Aug 2020 09:37:56 +0200
Message-ID: <bec1889c-5e0f-cd33-f74a-a7d44161a0ee@suse.de>
References: <20200823091043.2600261-1-hch@lst.de>
 <20200823091043.2600261-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200823091043.2600261-4-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>, Josef Bacik <josef@toxicpanda.com>, Xianting Tian <xianting_tian@126.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

On 8/23/20 11:10 AM, Christoph Hellwig wrote:
> In nvme_set_queue_dying we really just want to ensure the disk and bdev
> sizes are set to zero.  Going through revalidate_disk leads to a somewhat
> arcance and complex callchain relying on special behavior in a few
> places.  Instead just lift the set_capacity directly to
> nvme_set_queue_dying, and rename and move the nvme_mpath_update_disk_size
> helper so that we can use it in nvme_set_queue_dying to propagate the
> size to the bdev without detours.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/nvme/host/core.c | 33 +++++++++++++++++++++++----------
>  drivers/nvme/host/nvme.h | 13 -------------
>  2 files changed, 23 insertions(+), 23 deletions(-)
> 
YES!
I've been bitten by this far too often.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
