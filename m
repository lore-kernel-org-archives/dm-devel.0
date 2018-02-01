From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 2/4] dm unstriped: remove superfluous module init
	error path message
Date: Thu,  1 Feb 2018 19:06:10 +0100
Message-ID: <90eeaffb9abbc2bb6771b266a1dbf6ccbee58a64.1517504857.git.heinzm@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1517504857.git.heinzm@redhat.com>
In-Reply-To: <cover.1517504857.git.heinzm@redhat.com>
References: <cover.1517504857.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-unstripe.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
index c06a386bcc79..790b534c67d8 100644
--- a/drivers/md/dm-unstripe.c
+++ b/drivers/md/dm-unstripe.c
@@ -195,13 +195,7 @@ static struct target_type unstripe_target = {
 
 static int __init dm_unstripe_init(void)
 {
-	int r;
-
-	r = dm_register_target(&unstripe_target);
-	if (r < 0)
-		DMERR("target registration failed");
-
-	return r;
+	return dm_register_target(&unstripe_target);
 }
 
 static void __exit dm_unstripe_exit(void)
-- 
2.14.3
