From: Christoph Hellwig <hch@lst.de>
Subject: move bounce limits settings into the drivers
Date: Mon, 19 Jun 2017 09:26:18 +0200
Message-ID: <20170619072628.12894-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Currently we still default to a bounce all highmem setting for block
drivers.  This series defaults to no bouncing and instead adds call
to blk_queue_bounce_limit to those drivers that need it.   It also
has a few cleanups in that area.
