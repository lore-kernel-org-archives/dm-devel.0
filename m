From: Jens Axboe <axboe@kernel.dk>
Subject: Re: dedicated error codes for the block layer V3
Date: Fri, 9 Jun 2017 09:29:27 -0600
Message-ID: <20170609152926.GB24734@kernel.dk>
References: <20170603073806.2046-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170603073806.2046-1-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Jun 03 2017, Christoph Hellwig wrote:
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

Added for 4.13, thanks.

-- 
Jens Axboe

