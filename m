From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 08/24] dm cache metadata: return bool from
	__superblock_all_zeroes
Date: Thu, 24 Oct 2013 14:30:21 -0400
Message-ID: <1382639437-27007-9-git-send-email-snitzer@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-metadata.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 1af7255..2262b4e 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -198,7 +198,7 @@ static int superblock_lock(struct dm_cache_metadata *cmd,
 
 /*----------------------------------------------------------------*/
 
-static int __superblock_all_zeroes(struct dm_block_manager *bm, int *result)
+static int __superblock_all_zeroes(struct dm_block_manager *bm, bool *result)
 {
 	int r;
 	unsigned i;
@@ -214,10 +214,10 @@ static int __superblock_all_zeroes(struct dm_block_manager *bm, int *result)
 		return r;
 
 	data_le = dm_block_data(b);
-	*result = 1;
+	*result = true;
 	for (i = 0; i < sb_block_size; i++) {
 		if (data_le[i] != zero) {
-			*result = 0;
+			*result = false;
 			break;
 		}
 	}
@@ -411,7 +411,8 @@ bad:
 static int __open_or_format_metadata(struct dm_cache_metadata *cmd,
 				     bool format_device)
 {
-	int r, unformatted;
+	int r;
+	bool unformatted = false;
 
 	r = __superblock_all_zeroes(cmd->bm, &unformatted);
 	if (r)
-- 
1.8.1.4
