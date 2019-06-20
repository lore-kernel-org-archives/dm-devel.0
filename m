From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH] dm-verity: Use message limit for data block
	corruption message.
Date: Thu, 20 Jun 2019 13:00:19 +0200
Message-ID: <20190620110019.8057-1-gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

The dm-verity already uses DMERR_LIMIT on other places, so it
should also limit repeated data block corruption messages.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 720d06531aa3..08f83e160ad5 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -235,7 +235,7 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
 		BUG();
 	}
 
-	DMERR("%s: %s block %llu is corrupted", v->data_dev->name, type_str,
+	DMERR_LIMIT("%s: %s block %llu is corrupted", v->data_dev->name, type_str,
 		block);
 
 	if (v->corrupted_errs == DM_VERITY_MAX_CORRUPTED_ERRS)
-- 
2.20.1
