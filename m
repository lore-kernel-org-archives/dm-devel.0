From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm space map checker: fix allocation failure
	during init
Date: Thu, 21 Jun 2012 14:57:48 -0400
Message-ID: <1340305068-30096-2-git-send-email-snitzer@redhat.com>
References: <1340305068-30096-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1340305068-30096-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com, ejt@redhat.com, vgoyal@redhat.com
List-Id: dm-devel.ids

If CONFIG_DM_DEBUG_SPACE_MAPS is enabled, memory is fragmented and a
sufficiently large metadata device is used in a thin-pool then the space
map checker can fail to allocate via kmalloc.

Switch from kmalloc to vmalloc to allow larger virtually contiguous
allocations for the space map checker's internal count arrays.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-space-map-checker.c |   28 ++++++++++++--------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-checker.c b/drivers/md/persistent-data/dm-space-map-checker.c
index 6d7c832..f0eded3 100644
--- a/drivers/md/persistent-data/dm-space-map-checker.c
+++ b/drivers/md/persistent-data/dm-space-map-checker.c
@@ -89,13 +89,22 @@ static int ca_create(struct count_array *ca, struct dm_space_map *sm)
 
 	ca->nr = nr_blocks;
 	ca->nr_free = nr_blocks;
-	ca->counts = kzalloc(sizeof(*ca->counts) * nr_blocks, GFP_KERNEL);
-	if (!ca->counts)
-		return -ENOMEM;
+
+	if (nr_blocks) {
+		ca->counts = vzalloc(sizeof(*ca->counts) * nr_blocks);
+		if (!ca->counts)
+			return -ENOMEM;
+	} else
+		ca->counts = NULL;
 
 	return 0;
 }
 
+static void ca_destroy(struct count_array *ca)
+{
+	vfree(ca->counts);
+}
+
 static int ca_load(struct count_array *ca, struct dm_space_map *sm)
 {
 	int r;
@@ -126,12 +135,14 @@ static int ca_load(struct count_array *ca, struct dm_space_map *sm)
 static int ca_extend(struct count_array *ca, dm_block_t extra_blocks)
 {
 	dm_block_t nr_blocks = ca->nr + extra_blocks;
-	uint32_t *counts = kzalloc(sizeof(*counts) * nr_blocks, GFP_KERNEL);
+	uint32_t *counts = vzalloc(sizeof(*counts) * nr_blocks);
 	if (!counts)
 		return -ENOMEM;
 
-	memcpy(counts, ca->counts, sizeof(*counts) * ca->nr);
-	kfree(ca->counts);
+	if (ca->counts) {
+		memcpy(counts, ca->counts, sizeof(*counts) * ca->nr);
+		ca_destroy(ca);
+	}
 	ca->nr = nr_blocks;
 	ca->nr_free += extra_blocks;
 	ca->counts = counts;
@@ -151,11 +162,6 @@ static int ca_commit(struct count_array *old, struct count_array *new)
 	return 0;
 }
 
-static void ca_destroy(struct count_array *ca)
-{
-	kfree(ca->counts);
-}
-
 /*----------------------------------------------------------------*/
 
 struct sm_checker {
-- 
1.7.4.4
