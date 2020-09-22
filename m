From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 3/6] block: use lcm_not_zero() when stacking
 chunk_sectors
Date: Tue, 22 Sep 2020 15:28:51 -0400
Message-ID: <yq13639r4po.fsf@ca-mkp.ca.oracle.com>
References: <20200922023251.47712-1-snitzer@redhat.com>
        <20200922023251.47712-4-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200922023251.47712-4-snitzer@redhat.com> (Mike Snitzer's
        message of "Mon, 21 Sep 2020 22:32:48 -0400")
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids


Mike,

> Like 'io_opt', blk_stack_limits() should stack 'chunk_sectors' using
> lcm_not_zero() rather than min_not_zero() -- otherwise the final
> 'chunk_sectors' could result in sub-optimal alignment of IO to
> component devices in the IO stack.
>
> Also, if 'chunk_sectors' isn't a multiple of 'physical_block_size'
> then it is a bug in the driver and the device should be flagged as
> 'misaligned'.

Looks good.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
