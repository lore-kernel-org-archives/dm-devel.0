From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/4] dm rq: add a missing break to map_request
Date: Mon, 15 May 2017 17:28:36 +0200
Message-ID: <20170515152839.23375-2-hch@lst.de>
References: <20170515152839.23375-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170515152839.23375-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

We don't want to bug when receiving a DM_MAPIO_KILL value..

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-rq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 2af27026aa2e..b639fa7246ee 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -507,6 +507,7 @@ static int map_request(struct dm_rq_target_io *tio)
 	case DM_MAPIO_KILL:
 		/* The target wants to complete the I/O */
 		dm_kill_unmapped_request(rq, -EIO);
+		break;
 	default:
 		DMWARN("unimplemented target map return value: %d", r);
 		BUG();
-- 
2.11.0
