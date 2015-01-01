From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] md: dm-thin-metadata:  Remove unused function
Date: Thu,  1 Jan 2015 18:52:57 +0100
Message-ID: <1420134777-1290-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Remove the function dm_pool_get_data_block_size() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/md/dm-thin-metadata.c |    9 ---------
 drivers/md/dm-thin-metadata.h |    2 --
 2 files changed, 11 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index e9d33ad..c7914a5 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1639,15 +1639,6 @@ int dm_pool_get_metadata_dev_size(struct dm_pool_metadata *pmd,
 	return r;
 }
 
-int dm_pool_get_data_block_size(struct dm_pool_metadata *pmd, sector_t *result)
-{
-	down_read(&pmd->root_lock);
-	*result = pmd->data_block_size;
-	up_read(&pmd->root_lock);
-
-	return 0;
-}
-
 int dm_pool_get_data_dev_size(struct dm_pool_metadata *pmd, dm_block_t *result)
 {
 	int r = -EINVAL;
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index e3c857d..6258c14 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -182,8 +182,6 @@ int dm_pool_get_free_metadata_block_count(struct dm_pool_metadata *pmd,
 int dm_pool_get_metadata_dev_size(struct dm_pool_metadata *pmd,
 				  dm_block_t *result);
 
-int dm_pool_get_data_block_size(struct dm_pool_metadata *pmd, sector_t *result);
-
 int dm_pool_get_data_dev_size(struct dm_pool_metadata *pmd, dm_block_t *result);
 
 int dm_pool_block_is_used(struct dm_pool_metadata *pmd, dm_block_t b, bool *result);
-- 
1.7.10.4
