From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH] dm: remove dummy definition of 'struct dm_table'
Date: Thu, 22 Sep 2016 19:36:39 +0300
Message-ID: <1474562199-27248-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>
List-Id: dm-devel.ids

There is no need for it.

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 drivers/md/dm-ioctl.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 966eb4b..2d5594e 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -36,14 +36,6 @@ struct hash_cell {
 	struct dm_table *new_map;
 };
 
-/*
- * A dummy definition to make RCU happy.
- * struct dm_table should never be dereferenced in this file.
- */
-struct dm_table {
-	int undefined__;
-};
-
 struct vers_iter {
     size_t param_size;
     struct dm_target_versions *vers, *old_vers;
-- 
2.7.3
