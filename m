From: Christoph Hellwig <hch@lst.de>
Subject: Re: fix block device size update serialization v2
Date: Thu, 27 Aug 2020 09:47:58 +0200
Message-ID: <20200827074758.GA8009@lst.de>
References: <20200823091043.2600261-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200823091043.2600261-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>, Josef Bacik <josef@toxicpanda.com>, Xianting Tian <xianting_tian@126.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

Jens, can you consider this for 5.9?  It reliably fixes the reported
hangs with nvme hotremoval that we've had for a few releases.

On Sun, Aug 23, 2020 at 11:10:40AM +0200, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series fixes how we update i_size for the block device inodes (and
> thus the block device).  Different helpers use two different locks
> (bd_mutex and i_rwsem) to protect the update, and it appears device
> mapper uses yet another internal lock.  A lot of the drivers do the
> update handcrafted in often crufty ways.  And in addition to that mess
> it turns out that the "main" lock, bd_mutex is pretty dead lock prone
> vs other spots in the block layer that acquire it during revalidation
> operations, as reported by Xianting.
> 
> Fix all that by adding a dedicated spinlock just for the size updates.
> 
> Changes since v1:
>  - don't call __invalidate_device under the new spinlock
>  - don't call into the file system code from the nvme removal code
---end quoted text---
