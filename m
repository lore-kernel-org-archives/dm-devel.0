From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] dm-multipath: delay retry of bypassed pg
Date: Tue, 17 Apr 2012 00:46:58 -0500
Message-ID: <1334641618-24512-1-git-send-email-michaelc@cs.wisc.edu>
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
Cc: Mike Christie <michaelc@cs.wisc.edu>
List-Id: dm-devel.ids

From: Mike Christie <michaelc@cs.wisc.edu>

If there are only bypassed PGs available then we do not want
to retry right away. If for example the controller was getting
reset or there was a fw upgrade going on and that was the reason
for the bypass, then retrying right away is going to cause a flood of
log messages and retries for what could be a longish time (more than
a couple seconds and possible up to several minutes).

For the case where the only PGs are ones that are bypassed this
patch will have dm-multipath delay the pg init by setting the
pg_init_delay_retry flag.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 801d92d..65e0d26 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -307,14 +307,18 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 	/*
 	 * Loop through priority groups until we find a valid path.
 	 * First time we skip PGs marked 'bypassed'.
-	 * Second time we only try the ones we skipped.
+	 * Second time we only try the ones we skipped, but will set
+	 * pg_init_delay_retry so we do not hammer controllers.
 	 */
 	do {
 		list_for_each_entry(pg, &m->priority_groups, list) {
 			if (pg->bypassed == bypassed)
 				continue;
-			if (!__choose_path_in_pg(m, pg, nr_bytes))
+			if (!__choose_path_in_pg(m, pg, nr_bytes)) {
+				if (!bypassed)
+					m->pg_init_delay_retry = 1;
 				return;
+			}
 		}
 	} while (bypassed--);
 
-- 
1.7.7.6
