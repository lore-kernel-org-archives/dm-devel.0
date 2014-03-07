From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.15 3/3] dm bitset: only flush the current
	word if it has been dirtied
Date: Thu,  6 Mar 2014 19:47:28 -0500
Message-ID: <1394153248-32217-3-git-send-email-snitzer@redhat.com>
References: <1394153248-32217-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1394153248-32217-1-git-send-email-snitzer@redhat.com>
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
Cc: Morgan.Mears@netapp.com, ejt@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

This change offers a big performance boost for dm-era.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/persistent-data/dm-bitset.c | 10 +++++++++-
 drivers/md/persistent-data/dm-bitset.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-bitset.c b/drivers/md/persistent-data/dm-bitset.c
index cd9a86d..36f7cc2 100644
--- a/drivers/md/persistent-data/dm-bitset.c
+++ b/drivers/md/persistent-data/dm-bitset.c
@@ -65,7 +65,7 @@ int dm_bitset_flush(struct dm_disk_bitset *info, dm_block_t root,
 	int r;
 	__le64 value;
 
-	if (!info->current_index_set)
+	if (!info->current_index_set || !info->dirty)
 		return 0;
 
 	value = cpu_to_le64(info->current_bits);
@@ -77,6 +77,8 @@ int dm_bitset_flush(struct dm_disk_bitset *info, dm_block_t root,
 		return r;
 
 	info->current_index_set = false;
+	info->dirty = false;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_bitset_flush);
@@ -94,6 +96,8 @@ static int read_bits(struct dm_disk_bitset *info, dm_block_t root,
 	info->current_bits = le64_to_cpu(value);
 	info->current_index_set = true;
 	info->current_index = array_index;
+	info->dirty = false;
+
 	return 0;
 }
 
@@ -126,6 +130,8 @@ int dm_bitset_set_bit(struct dm_disk_bitset *info, dm_block_t root,
 		return r;
 
 	set_bit(b, (unsigned long *) &info->current_bits);
+	info->dirty = true;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_bitset_set_bit);
@@ -141,6 +147,8 @@ int dm_bitset_clear_bit(struct dm_disk_bitset *info, dm_block_t root,
 		return r;
 
 	clear_bit(b, (unsigned long *) &info->current_bits);
+	info->dirty = true;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_bitset_clear_bit);
diff --git a/drivers/md/persistent-data/dm-bitset.h b/drivers/md/persistent-data/dm-bitset.h
index e1b9bea..c2287d6 100644
--- a/drivers/md/persistent-data/dm-bitset.h
+++ b/drivers/md/persistent-data/dm-bitset.h
@@ -71,6 +71,7 @@ struct dm_disk_bitset {
 	uint64_t current_bits;
 
 	bool current_index_set:1;
+	bool dirty:1;
 };
 
 /*
-- 
1.8.1.4
