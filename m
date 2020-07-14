From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.7 18/19] dm: use bio_uninit instead of bio_disassociate_blkg
Date: Tue, 14 Jul 2020 10:38:48 -0400
Message-ID: <20200714143849.4035283-18-sashal@kernel.org>
References: <20200714143849.4035283-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200714143849.4035283-1-sashal@kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <johannes.thumshirn@wdc.com>, Mike Snitzer <snitzer@redhat.com>, Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 382761dc6312965a11f82f2217e16ec421bf17ae ]

bio_uninit is the proper API to clean up a BIO that has been allocated
on stack or inside a structure that doesn't come from the BIO allocator.
Switch dm to use that instead of bio_disassociate_blkg, which really is
an implementation detail.  Note that the bio_uninit calls are also moved
to the two callers of __send_empty_flush, so that they better pair with
the bio_init calls used to initialize them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index db9e461146531..c33aaf29f1379 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1445,9 +1445,6 @@ static int __send_empty_flush(struct clone_info *ci)
 	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
 		__send_duplicate_bios(ci, ti, ti->num_flush_bios, NULL);
-
-	bio_disassociate_blkg(ci->bio);
-
 	return 0;
 }
 
@@ -1635,6 +1632,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 		ci.bio = &flush_bio;
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
+		bio_uninit(ci.bio);
 		/* dec_pending submits any data associated with flush */
 	} else if (op_is_zone_mgmt(bio_op(bio))) {
 		ci.bio = bio;
@@ -1709,6 +1707,7 @@ static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
 		ci.bio = &flush_bio;
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
+		bio_uninit(ci.bio);
 		/* dec_pending submits any data associated with flush */
 	} else {
 		struct dm_target_io *tio;
-- 
2.25.1
