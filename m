From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] dm integrity: Make dm_integrity_init and dm_integrity_exit static
Date: Fri, 22 Mar 2019 22:16:34 +0800
Message-ID: <20190322141634.20664-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, YueHaibing <yuehaibing@huawei.com>
List-Id: dm-devel.ids

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warnings:

drivers/md/dm-integrity.c:3619:12: warning:
 symbol 'dm_integrity_init' was not declared. Should it be static?
drivers/md/dm-integrity.c:3638:6: warning:
 symbol 'dm_integrity_exit' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/md/dm-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d57d997..0932c32 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3616,7 +3616,7 @@ static struct target_type integrity_target = {
 	.io_hints		= dm_integrity_io_hints,
 };
 
-int __init dm_integrity_init(void)
+static int __init dm_integrity_init(void)
 {
 	int r;
 
@@ -3635,7 +3635,7 @@ int __init dm_integrity_init(void)
 	return r;
 }
 
-void dm_integrity_exit(void)
+static void dm_integrity_exit(void)
 {
 	dm_unregister_target(&integrity_target);
 	kmem_cache_destroy(journal_io_cache);
-- 
2.7.0
