From: Jens Axboe <axboe@kernel.dk>
Subject: Re: dedicated error codes for the block layer V3
Date: Thu, 8 Jun 2017 09:42:44 -0600
Message-ID: <d4840574-0fd2-4f12-b77c-bf7409a785e4@kernel.dk>
References: <20170603073806.2046-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170603073806.2046-1-hch@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 06/03/2017 01:37 AM, Christoph Hellwig wrote:
> This series introduces a new blk_status_t error code type for the block
> layer so that we can have tigher control and explicit semantics for
> block layer errors.
> 
> All but the last three patches are cleanups that lead to the new type.
> 
> The series it mostly limited to the block layer and drivers, and touching
> file systems a little bit.  The only major exception is btrfs, which
> does funny things with bios and thus sees a larger amount of propagation
> of the new blk_status_t.
> 
> A git tree is also available at:
> 
>     git://git.infradead.org/users/hch/block.git block-errors
> 
> gitweb:
> 
>     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-errors
> 
> Note the the two biggest patches didn't make it to linux-block and
> linux-btrfs last time.  If you didn't get them they are available in
> the git tree above.  Unfortunately there is no easy way to split them
> up.

Mike, can you take a look at the dm bits in this series? I'd like to get
this queued up, but I'd also greatly prefer if the dm patches had sign
off from your end.

-- 
Jens Axboe
