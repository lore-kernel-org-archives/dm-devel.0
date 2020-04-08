From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] dm integrity: remove set but not used variables
Date: Wed, 8 Apr 2020 07:29:48 +0000
Message-ID: <20200408072948.156175-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: YueHaibing <yuehaibing@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>
List-Id: dm-devel.ids

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/md/dm-integrity.c: In function 'integrity_metadata':
drivers/md/dm-integrity.c:1557:12: warning:
 variable 'save_metadata_offset' set but not used [-Wunused-but-set-variable]
drivers/md/dm-integrity.c:1556:12: warning:
 variable 'save_metadata_block' set but not used [-Wunused-but-set-variable]

They are never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/md/dm-integrity.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b989d109d55d..94fb584854b8 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1553,8 +1553,6 @@ static void integrity_metadata(struct work_struct *w)
 		char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		sector_t sector;
 		unsigned sectors_to_process;
-		sector_t save_metadata_block;
-		unsigned save_metadata_offset;
 
 		if (unlikely(ic->mode == 'R'))
 			goto skip_io;
@@ -1605,8 +1603,6 @@ static void integrity_metadata(struct work_struct *w)
 			goto skip_io;
 		}
 
-		save_metadata_block = dio->metadata_block;
-		save_metadata_offset = dio->metadata_offset;
 		sector = dio->range.logical_sector;
 		sectors_to_process = dio->range.n_sectors;
