From: Christoph Hellwig <hch@lst.de>
Subject: dedicated error codes for the block layer V2
Date: Fri, 26 May 2017 11:56:07 +0300
Message-ID: <20170526085620.3113-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org
List-Id: dm-devel.ids

This series introduces a new blk_status_t error code type for the block
layer so that we can have tigher control and explicit semantics for
block layer errors.

All but the last three patches are cleanups that lead to the new type.

The series it mostly limited to the block layer and drivers, and touching
file systems a little bit.  The only major exception is btrfs, which
does funny things with bios and thus sees a larger amount of propagation
of the new blk_status_t.

A git tree is also available at:

    git://git.infradead.org/users/hch/block.git block-errors

gitweb:

    http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/block-errors

Note the the two biggest patches didn't make it to linux-block and
linux-btrfs last time.  If you didn't get them they are available in
the git tree above.  Unfortunately there is no easy way to split them
up.

Changes since V1: 
 - keep blk_types.h for now
 - removed a BUG_ON in dm-mpath
