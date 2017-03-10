From: NeilBrown <neilb@suse.com>
Subject: [PATCH 5/5] block_dev: make blkdev_dio_pool a non-rescuing bioset
Date: Fri, 10 Mar 2017 17:00:47 +1100
Message-ID: <148912564767.4002.1734839418362310960.stgit@noble>
References: <148912539296.4002.219258660543808741.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148912539296.4002.219258660543808741.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

Allocations from blkdev_dio_pool are never made under
generic_make_request, so this bioset does not need a rescuer thread.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 fs/block_dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index c0ca5f0d0369..2eca00ec4370 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -436,7 +436,7 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 
 static __init int blkdev_init(void)
 {
-	blkdev_dio_pool = bioset_create_rescued(4, offsetof(struct blkdev_dio, bio));
+	blkdev_dio_pool = bioset_create(4, offsetof(struct blkdev_dio, bio));
 	if (!blkdev_dio_pool)
 		return -ENOMEM;
 	return 0;
