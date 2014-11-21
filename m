From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] virtio_blk: fix defaults for max_hw_sectors and
 max_segment_size
Date: Fri, 21 Nov 2014 01:54:56 -0800
Message-ID: <20141121095456.GB8866@infradead.org>
References: <20141120190058.GA31214@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141120190058.GA31214@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, mst@redhat.com, rusty@rustcorp.com.au, dm-devel@redhat.com, Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
List-Id: dm-devel.ids

On Thu, Nov 20, 2014 at 02:00:59PM -0500, Mike Snitzer wrote:
> virtio_blk incorrectly established -1U as the default for these
> queue_limits.  Set these limits to sane default values to avoid crashing
> the kernel.  But the virtio-blk protocol should probably be extended to
> allow proper stacking of the disk's limits from the host.
> 
> This change fixes a crash that was reported when virtio-blk was used to
> test linux-dm.git commit 604ea90641b4 ("dm thin: adjust max_sectors_kb
> based on thinp blocksize") that will initially set max_sectors to
> max_hw_sectors and then rounddown to the first power-of-2 factor of the
> DM thin-pool's blocksize.  Basically that commit assumes drivers don't
> suck when establishing max_hw_sectors so it acted like a canary in the
> coal mine.

Is that a crash in the host or guest?  What kind of mishandling did you
see?  Unless the recent virtio standard changed anything the host
should be able to handle our arbitrary limits, and even if it doesn't
that something we need to hash out with qemu and the virtio standards
folks.
