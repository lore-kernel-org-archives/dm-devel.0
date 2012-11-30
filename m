From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/3] dm block manager: reinstate context for
	which block failed a validator check
Date: Fri, 30 Nov 2012 09:45:25 -0500
Message-ID: <1354286727-31933-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This was mistakenly eliminated when the block manager was converted to
use dm-bufio.  Restore it because it is useful if/when the validator
check fails.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-block-manager.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 5ba2777..47b683e 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -428,8 +428,11 @@ static int dm_bm_validate_buffer(struct dm_block_manager *bm,
 		if (!v)
 			return 0;
 		r = v->check(v, (struct dm_block *) buf, dm_bufio_get_block_size(bm->bufio));
-		if (unlikely(r))
+		if (unlikely(r)) {
+			DMERR("%s validator check failed for block %llu", v->name,
+			      (unsigned long long) dm_bufio_get_block_number(buf));
 			return r;
+		}
 		aux->validator = v;
 	} else {
 		if (unlikely(aux->validator != v)) {
-- 
1.7.4.4
