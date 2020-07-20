From: Christoph Hellwig <hch@lst.de>
Subject: a fix and two cleanups around blk_stack_limits
Date: Mon, 20 Jul 2020 08:12:48 +0200
Message-ID: <20200720061251.652457-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Jens,

this series ensures that the zoned device limitations are properly
inherited in blk_stack_limits, and then cleanups up two rather
pointless wrappers around it.
