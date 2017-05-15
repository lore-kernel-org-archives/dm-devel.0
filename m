From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] dm: fix REQ_RAHEAD handling
Date: Mon, 15 May 2017 17:28:39 +0200
Message-ID: <20170515152839.23375-5-hch@lst.de>
References: <20170515152839.23375-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170515152839.23375-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

A few (but not all) dm targets use a special EWOULDBLOCK error code for
failing REQ_RAHEAD requests that fail due to a lack of available resources.
But no one else knows about this magic code, and lower level drivers also
don't generate it when failing read-ahead requests for similar reasons.

So remove this special casing and ignore all additional error handling for
REQ_RAHEAD - if this was a real underlying error we'd get a normal read
once the real read comes in.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-raid1.c  | 4 ++--
 drivers/md/dm-stripe.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index a95cbb80fb34..5e30b08b91d9 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1214,7 +1214,7 @@ static int mirror_map(struct dm_target *ti, struct bio *bio)
 	 */
 	if (!r || (r == -EWOULDBLOCK)) {
 		if (bio->bi_opf & REQ_RAHEAD)
-			return -EWOULDBLOCK;
+			return -EIO;
 
 		queue_bio(ms, bio, rw);
 		return DM_MAPIO_SUBMITTED;
@@ -1258,7 +1258,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
 	if (error == -EOPNOTSUPP)
 		return error;
 
-	if ((error == -EWOULDBLOCK) && (bio->bi_opf & REQ_RAHEAD))
+	if (bio->bi_opf & REQ_RAHEAD)
 		return error;
 
 	if (unlikely(error)) {
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 75152482f3ad..780e95889a7c 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -384,7 +384,7 @@ static int stripe_end_io(struct dm_target *ti, struct bio *bio, int error)
 	if (!error)
 		return 0; /* I/O complete */
 
-	if ((error == -EWOULDBLOCK) && (bio->bi_opf & REQ_RAHEAD))
+	if (bio->bi_opf & REQ_RAHEAD)
 		return error;
 
 	if (error == -EOPNOTSUPP)
-- 
2.11.0
