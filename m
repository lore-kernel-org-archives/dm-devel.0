From: heinzm@redhat.com
Subject: [PATCH] dm raid: avoid WARN_ON() in
	raid10_md_layout_to_format()
Date: Thu, 13 Jul 2017 17:33:22 +0200
Message-ID: <20170713153322.24294-1-heinzm@redhat.com>
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
Cc: heinzm@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2e10c2f..b409015 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -564,9 +564,10 @@ static const char *raid10_md_layout_to_format(int layout)
 	if (__raid10_near_copies(layout) > 1)
 		return "near";
 
-	WARN_ON(__raid10_far_copies(layout) < 2);
+	if (__raid10_far_copies(layout) > 1)
+		return "far";
 
-	return "far";
+	return "unknown";
 }
 
 /* Return md raid10 algorithm for @name */
-- 
2.9.4
