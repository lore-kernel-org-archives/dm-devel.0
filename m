From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/6] dm: fix then improve bio splitting
Date: Wed, 23 Sep 2020 10:38:26 -0600
Message-ID: <bc988bfa-5f81-3d04-82e8-489943143355@kernel.dk>
References: <20200922023251.47712-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200922023251.47712-1-snitzer@redhat.com>
Content-Language: en-US
To: Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 9/21/20 8:32 PM, Mike Snitzer wrote:
> Hi,
> 
> Patches 1 and 2 are queued for me to send to Linus later this week.
> 
> Patches 3 and 4 are block core and should get picked up for 5.10.
> Jens, please pick them up. I revised the header for patch 4 to give
> better context for use-case where non power-of-2 chunk_sectors
> occurs. Patch 4 enables DM to switch to using blk_max_size_offset() in
> Patch 6.
> 
> Patches 5 and 6 just show how DM will be enhanced for 5.10 once
> patches 3 and 4 land in the block tree.

Applied 3-4 for 5.10, thanks.

-- 
Jens Axboe
