From: Christoph Hellwig <hch@lst.de>
Subject: add a bi_error field to struct bio V3
Date: Mon, 20 Jul 2015 15:29:36 +0200
Message-ID: <1437398977-8492-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Bio error reporting has been a mess for a while, and the increasing
use of chained bios makes it worse.  Add a bi_error field to struct
bio to fix this.

Note that the rebase to 4.2-rc means a lot of context changes, so I've
dropped the Reviewed-by tags from V2 as it will need a re-review.
