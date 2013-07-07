From: Robin Dong <robin.k.dong@gmail.com>
Subject: [PATCH] dm: make alloc error info more clearly.
Date: Sun,  7 Jul 2013 15:08:46 +0800
Message-ID: <1373180926-29264-1-git-send-email-robin.k.dong@gmail.com>
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
Cc: Robin Dong <sanbai@taobao.com>
List-Id: dm-devel.ids

From: Robin Dong <sanbai@taobao.com>

If dm-delay structure allocation failed, report more precise error information.

If dm-flakey structure alocation failed, it will report wrong error information which
should be fixed.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 drivers/md/dm-delay.c  |    2 +-
 drivers/md/dm-flakey.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 496d5f3..dfc26f1 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -140,7 +140,7 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	dc = kmalloc(sizeof(*dc), GFP_KERNEL);
 	if (!dc) {
-		ti->error = "Cannot allocate context";
+		ti->error = "Cannot allocate delay context";
 		return -ENOMEM;
 	}
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 7fcf21c..9ab809f 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -176,7 +176,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	fc = kzalloc(sizeof(*fc), GFP_KERNEL);
 	if (!fc) {
-		ti->error = "Cannot allocate linear context";
+		ti->error = "Cannot allocate flakey context";
 		return -ENOMEM;
 	}
 	fc->start_time = jiffies;
-- 
1.7.1
