From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3] block,
	dm: don't copy bios for request clones
Date: Mon, 11 May 2015 11:55:58 -0400
Message-ID: <20150511155558.GA19940@redhat.com>
References: <1429957432-20672-1-git-send-email-hch@lst.de>
	<20150428005950.GA31039@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150428005950.GA31039@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@fb.com>
Cc: dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Mon, Apr 27 2015 at  8:59pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> Currently dm-multipath has to clone the bios for every request sent
> to the lower devices, which wastes cpu cycles and ties down memory.
> 
> This patch instead adds a new REQ_CLONE flag that instructs req_bio_endio
> to not complete bios attached to a request, which we set on clone
> requests similar to bios in a flush sequence.  With this change I/O
> errors on a path failure only get propagated to dm-multipath, which
> can then either resubmit the I/O or complete the bios on the original
> request.
> 
> I've done some basic testing of this on a Linux target with ALUA support,
> and it survives path failures during I/O nicely.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-core.c          |  94 +++----------------------
>  drivers/md/dm-table.c     |  25 ++++---
>  drivers/md/dm.c           | 171 +++++++++++-----------------------------------
>  drivers/md/dm.h           |   5 +-
>  include/linux/blk_types.h |   2 +
>  include/linux/blkdev.h    |   6 +-
>  6 files changed, 73 insertions(+), 230 deletions(-)
> 
> v3: really just some line-wrapping, whitespace, and misc small nits

Hey Jens,

Given the blk-core changes, would you like to pick this up for 4.2 and
I'll just base DM ontop of linux-block.git again for the 4.2 cycle?

The patch is available here: https://patchwork.kernel.org/patch/6285081/

Mike

p.s. I do have a followup DM patch that cleans things up further but I
can just stage it via linux-dm.git:
https://patchwork.kernel.org/patch/6285091/
