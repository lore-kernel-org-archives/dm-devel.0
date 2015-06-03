From: Christoph Hellwig <hch@lst.de>
Subject: [RFC] add a bi_error field
Date: Wed,  3 Jun 2015 15:42:38 +0200
Message-ID: <1433338959-24808-1-git-send-email-hch@lst.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Bio error reporting has been a mess for a while, and the increasing
use of chained bios makes it worse.

This series attempts to add a proper error field to struct bio
to sort this out.  It's working fine for me, but MD and btrfs were
doing pretty nasty things with the BIO_UPTODATE flag, so I would
appreciate some detailed review there.

