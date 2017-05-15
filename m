From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] dm mpath: multipath_clone_and_map must not return -EIO
Date: Mon, 15 May 2017 17:28:38 +0200
Message-ID: <20170515152839.23375-4-hch@lst.de>
References: <20170515152839.23375-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170515152839.23375-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Since 412445ac ("dm: introduce a new DM_MAPIO_KILL return value"),  the
clone_and_map_rq methods must not return errno values, so fix it up
to properly return DM_MAPIO_KILL instead, instead of the -EIO value
that sneaked in due to a conflict between two patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d55454f98b59..3df056b73b66 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -481,7 +481,7 @@ static int multipath_clone_and_map(struct dm_target *ti, struct request *rq,
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			return DM_MAPIO_DELAY_REQUEUE;
 		dm_report_EIO(m);	/* Failed */
-		return -EIO;
+		return DM_MAPIO_KILL;
 	} else if (test_bit(MPATHF_QUEUE_IO, &m->flags) ||
 		   test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags)) {
 		if (pg_init_all_paths(m))
-- 
2.11.0
