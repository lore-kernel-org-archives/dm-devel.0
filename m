From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: fix alignment_offset math that assumes io_min
 is a power-of-2
Date: Wed, 08 Oct 2014 16:12:16 -0600
Message-ID: <5435B6C0.8020704@kernel.dk>
References: <1412805952-15316-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412805952-15316-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org
Cc: martin.petersen@oracle.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/08/2014 04:05 PM, Mike Snitzer wrote:
> The math in both blk_stack_limits() and queue_limit_alignment_offset()
> assume that a block device's io_min (aka minimum_io_size) is always a
> power-of-2.  Fix the math such that it works for non-power-of-2 io_min.
> 
> This issue (of alignment_offset != 0) became apparent when testing
> dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
> 1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's data
> block size") unlocked the potential for alignment_offset != 0 due to
> the dm-thin-pool's io_min possibly being a non-power-of-2.

Well that sucks, AND with a mask is considerably cheaper than a MOD...

-- 
Jens Axboe
