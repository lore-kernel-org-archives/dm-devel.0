From: Jens Axboe <axboe@kernel.dk>
Subject: Re: a fix and two cleanups around blk_stack_limits
Date: Mon, 20 Jul 2020 10:56:23 -0600
Message-ID: <dfe56cf2-db3d-3461-9834-be314f4080ef@kernel.dk>
References: <20200720061251.652457-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200720061251.652457-1-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 7/20/20 12:12 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> this series ensures that the zoned device limitations are properly
> inherited in blk_stack_limits, and then cleanups up two rather
> pointless wrappers around it.

We should probably make this against for-5.9/drivers instead, to avoid
an unnecessary conflict when merging.

-- 
Jens Axboe
