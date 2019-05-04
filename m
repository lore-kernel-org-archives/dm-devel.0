From: YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] dm dust: Make dm_dust_init and dm_dust_exit static
Date: Sat, 4 May 2019 18:30:36 +0800
Message-ID: <20190504103036.34436-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, YueHaibing <yuehaibing@huawei.com>
List-Id: dm-devel.ids

Fix sparse warnings:

drivers/md/dm-dust.c:495:12: warning: symbol 'dm_dust_init' was not declared. Should it be static?
drivers/md/dm-dust.c:505:13: warning: symbol 'dm_dust_exit' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/md/dm-dust.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index 178587b..3d42e40 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -492,7 +492,7 @@ static struct target_type dust_target = {
 	.prepare_ioctl = dust_prepare_ioctl,
 };
 
-int __init dm_dust_init(void)
+static int __init dm_dust_init(void)
 {
 	int result = dm_register_target(&dust_target);
 
@@ -502,7 +502,7 @@ int __init dm_dust_init(void)
 	return result;
 }
 
-void __exit dm_dust_exit(void)
+static void __exit dm_dust_exit(void)
 {
 	dm_unregister_target(&dust_target);
 }
-- 
2.7.4
