From: tang.junhui@zte.com.cn
Subject: [PATCH] dm mpath: add check for count of groups to avoid
	wild pointer access
Date: Fri, 4 Nov 2016 12:37:09 +0800
Message-ID: <1478234229-7480-1-git-send-email-tang.junhui@zte.com.cn>
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
To: agk@redhat.com, snitzer@redhat.com
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, "tang.junhui" <tang.junhui@zte.com.cn>
List-Id: dm-devel.ids

From: "tang.junhui" <tang.junhui@zte.com.cn>

pg is not assigned to a group address when count of multipath groups
is zero in bypass_pg_num(), then it is used in bypass_pg(), which may
cause wild pointer access.

Signed-off-by: tang.junhui <tang.junhui@zte.com.cn>
---
 drivers/md/dm-mpath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e477af8..ab4d716 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1394,7 +1394,7 @@ static int bypass_pg_num(struct multipath *m, const char *pgstr, bool bypassed)
 	char dummy;
 
 	if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
-	    (pgnum > m->nr_priority_groups)) {
+	    !m->nr_priority_groups || (pgnum > m->nr_priority_groups)) {
 		DMWARN("invalid PG number supplied to bypass_pg");
 		return -EINVAL;
 	}
-- 
2.8.1.windows.1
