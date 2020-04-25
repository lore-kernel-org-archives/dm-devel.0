From: Christoph Hellwig <hch@lst.de>
Subject: avoid the ->make_request_fn indirect for blk-mq drivers
Date: Sat, 25 Apr 2020 09:53:33 +0200
Message-ID: <20200425075336.721021-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Hi Jens,

this small series avoids an indirect call for every submitted bio that
eventually ends up being handled by blk-mq drivers.  Let me know what
you think.
