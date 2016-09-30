From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] dm: Change return type of pg_init_all_paths()
 from int into void
Date: Fri, 30 Sep 2016 10:44:10 -0700
Message-ID: <159b1209-ab2b-a0a0-bfeb-89edcefbc1a0@sandisk.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

None of the callers of pg_init_all_paths() check its return value.
Hence change the return type of pg_init_all_paths() from int into
void.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-mpath.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index dd66653..8e2341d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -378,16 +378,13 @@ static int __pg_init_all_paths(struct multipath *m)
 	return atomic_read(&m->pg_init_in_progress);
 }
 
-static int pg_init_all_paths(struct multipath *m)
+static void pg_init_all_paths(struct multipath *m)
 {
-	int r;
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
-	r = __pg_init_all_paths(m);
+	__pg_init_all_paths(m);
 	spin_unlock_irqrestore(&m->lock, flags);
-
-	return r;
 }
 
 static void __switch_pg(struct multipath *m, struct priority_group *pg)
-- 
2.10.0
