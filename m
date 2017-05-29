From: David Sterba <dsterba@suse.cz>
Subject: Re: dedicated error codes for the block layer V2
Date: Mon, 29 May 2017 15:16:37 +0200
Message-ID: <20170529131637.GB14523@twin.jikos.cz>
References: <20170526085620.3113-1-hch@lst.de>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170526085620.3113-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

On Fri, May 26, 2017 at 11:56:07AM +0300, Christoph Hellwig wrote:
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

For btrfs bits in patch 13

Acked-by: David Sterba <dsterba@suse.com>
