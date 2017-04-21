From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] block: get rid of blk_integrity_revalidate()
Date: Fri, 21 Apr 2017 14:18:08 -0600
Message-ID: <30a66f64-2785-dc9d-d64a-cb3cf4fc346e@fb.com>
References: <1492533800-30627-1-git-send-email-idryomov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1492533800-30627-1-git-send-email-idryomov@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, ceph-devel@vger.kernel.org
List-Id: dm-devel.ids

On 04/18/2017 10:43 AM, Ilya Dryomov wrote:
> Commit 25520d55cdb6 ("block: Inline blk_integrity in struct gendisk")
> introduced blk_integrity_revalidate(), which seems to assume ownership
> of the stable pages flag and unilaterally clears it if no blk_integrity
> profile is registered:
> 
>     if (bi->profile)
>             disk->queue->backing_dev_info->capabilities |=
>                     BDI_CAP_STABLE_WRITES;
>     else
>             disk->queue->backing_dev_info->capabilities &=
>                     ~BDI_CAP_STABLE_WRITES;
> 
> It's called from revalidate_disk() and rescan_partitions(), making it
> impossible to enable stable pages for drivers that support partitions
> and don't use blk_integrity: while the call in revalidate_disk() can be
> trivially worked around (see zram, which doesn't support partitions and
> hence gets away with zram_revalidate_disk()), rescan_partitions() can
> be triggered from userspace at any time.  This breaks rbd, where the
> ceph messenger is responsible for generating/verifying CRCs.
> 
> Since blk_integrity_{un,}register() "must" be used for (un)registering
> the integrity profile with the block layer, move BDI_CAP_STABLE_WRITES
> setting there.  This way drivers that call blk_integrity_register() and
> use integrity infrastructure won't interfere with drivers that don't
> but still want stable pages.

Applied, thanks.

-- 
Jens Axboe
