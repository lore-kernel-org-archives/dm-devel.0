From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V1 Resend 04/11] drivers: md: Drop unlikely before IS_ERR(_OR_NULL)
Date: Mon, 10 Aug 2015 11:42:26 +0530
Message-ID: <f5979681afc5c1f30a2b5a0b61507580133bad04.1439187003.git.viresh.kumar@linaro.org>
References: <cover.1439187003.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1439187003.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1439187003.git.viresh.kumar@linaro.org>
References: <cover.1439187003.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>, Alasdair Kergon <agk@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.com>
List-Id: dm-devel.ids

IS_ERR(_OR_NULL) already contain an 'unlikely' compiler flag and there
is no need to do that again from its callers. Drop it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/md/dm-snap-persistent.c               | 2 +-
 drivers/md/dm-verity.c                        | 2 +-
 drivers/md/persistent-data/dm-block-manager.c | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 808b8419bc48..bf71583296f7 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -533,7 +533,7 @@ static int read_exceptions(struct pstore *ps,
 		chunk = area_location(ps, ps->current_area);
 
 		area = dm_bufio_read(client, chunk, &bp);
-		if (unlikely(IS_ERR(area))) {
+		if (IS_ERR(area)) {
 			r = PTR_ERR(area);
 			goto ret_destroy_bufio;
 		}
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 4b34df8fdb58..d224979f9633 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -271,7 +271,7 @@ static int verity_verify_level(struct dm_verity_io *io, sector_t block,
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
 	data = dm_bufio_read(v->bufio, hash_block, &buf);
-	if (unlikely(IS_ERR(data)))
+	if (IS_ERR(data))
 		return PTR_ERR(data);
 
 	aux = dm_bufio_get_aux_data(buf);
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 4d6c9b689eaa..88dbe7b97c2c 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -454,7 +454,7 @@ int dm_bm_read_lock(struct dm_block_manager *bm, dm_block_t b,
 	int r;
 
 	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		return PTR_ERR(p);
 
 	aux = dm_bufio_get_aux_data(to_buffer(*result));
@@ -490,7 +490,7 @@ int dm_bm_write_lock(struct dm_block_manager *bm,
 		return -EPERM;
 
 	p = dm_bufio_read(bm->bufio, b, (struct dm_buffer **) result);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		return PTR_ERR(p);
 
 	aux = dm_bufio_get_aux_data(to_buffer(*result));
@@ -523,7 +523,7 @@ int dm_bm_read_try_lock(struct dm_block_manager *bm,
 	int r;
 
 	p = dm_bufio_get(bm->bufio, b, (struct dm_buffer **) result);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		return PTR_ERR(p);
 	if (unlikely(!p))
 		return -EWOULDBLOCK;
@@ -559,7 +559,7 @@ int dm_bm_write_lock_zero(struct dm_block_manager *bm,
 		return -EPERM;
 
 	p = dm_bufio_new(bm->bufio, b, (struct dm_buffer **) result);
-	if (unlikely(IS_ERR(p)))
+	if (IS_ERR(p))
 		return PTR_ERR(p);
 
 	memset(p, 0, dm_bm_block_size(bm));
-- 
2.4.0
