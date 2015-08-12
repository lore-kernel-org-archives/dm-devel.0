From: Yi Zhang <yizhan@redhat.com>
Subject: [PATCH] dm cache policy smq: mv module alias:
	dm-cache-default to SMQ
Date: Wed, 12 Aug 2015 19:22:43 +0800
Message-ID: <1439378563-14993-1-git-send-email-yizhan@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: ejt@redhat.com, snitzer@redhat.com, Yi Zhang <yizhan@redhat.com>
List-Id: dm-devel.ids

When creating dm-cache with the default policy, it will call
request_module("dm-cache-default") to register the default policy.
But the dm-cache-default is for dm-cache-mq which is incorrect, so
move the module alias: dm-cache-default to SMQ.

Signed-off-by: Yi Zhang <yizhan@redhat.com>
---
 drivers/md/dm-cache-policy-mq.c  | 2 --
 drivers/md/dm-cache-policy-smq.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 3281437..aa1b41c 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -1471,5 +1471,3 @@ module_exit(mq_exit);
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("mq cache policy");
-
-MODULE_ALIAS("dm-cache-default");
diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index d80506c..1ffbeb1 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1757,3 +1757,5 @@ module_exit(smq_exit);
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("smq cache policy");
+
+MODULE_ALIAS("dm-cache-default");
-- 
1.9.3
