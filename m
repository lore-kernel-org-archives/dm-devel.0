From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] block: disallow changing max_sectors_kb on a request
 stacking device
Date: Mon, 7 Nov 2016 12:32:18 -0700
Message-ID: <8d0f16fe-7293-3b1c-1c60-32a50c77fa89@kernel.dk>
References: <20161028194549.14556-1-snitzer@redhat.com>
 <20161107164029.GA27464@redhat.com> <20161107192646.GA11572@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20161107192646.GA11572@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/07/2016 12:26 PM, Mike Snitzer wrote:
> Otherwise users can easily shoot themselves in the foot by creating the
> situation where the top-level stacked device (e.g. DM multipath) has a
> larger max_sectors_kb than the underlying device(s).  Which will
> certainly lead to IO errors due to the "over max size limit" check in
> blk_cloned_rq_check_limits().
>
> This is a crude, yet effective, solution that forces the use of system
> software (e.g. udev rules or multipathd) to tweak max_sectors_kb of the
> underlying devices _before_ a layer like DM multipath is layered ontop.

Maybe I'm missing something, but the code we have in place splits it
into max sectors for software and hardware. Shouldn't the stacked
devices have max_hw_sectors capped to what the lower levels support? If
that was done, we would not have to worry about a user fiddling with
max_sectors_kb, since it could only be smaller (or equal to) the max
size of the lower level.

-- 
Jens Axboe

