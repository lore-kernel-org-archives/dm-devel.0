From: Christoph Hellwig <hch@lst.de>
Subject: add a bi_error field to struct bio V2
Date: Thu, 11 Jun 2015 17:54:01 +0200
Message-ID: <1434038042-7753-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Bio error reporting has been a mess for a while, and the increasing
use of chained bios makes it worse.  Add a bi_error field to struct
bio to fix this.
