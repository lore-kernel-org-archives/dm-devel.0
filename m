From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/2] dm mpath: stop queueing IO when no valid
	paths exist
Date: Thu, 18 Sep 2014 12:02:28 -0400
Message-ID: <1411056149-16418-2-git-send-email-snitzer@redhat.com>
References: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
	<1411056149-16418-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1411056149-16418-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hare@suse.de
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Benjamin Marzinski <bmarzins@redhat.com>

'queue_io' is set so that IO is queued while paths are being
initialized.  Clear queue_io in __choose_pgpath if there are no valid
paths, since there are obviously no paths that can be initialized.
Otherwise IOs to the device will back up.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 833d7e7..7b6b0f0 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -317,8 +317,10 @@ static void __choose_pgpath(struct multipath *m, size_t nr_bytes)
 	struct priority_group *pg;
 	unsigned bypassed = 1;
 
-	if (!m->nr_valid_paths)
+	if (!m->nr_valid_paths) {
+		m->queue_io = 0;
 		goto failed;
+	}
 
 	/* Were we instructed to switch PG? */
 	if (m->next_pg) {
-- 
1.9.3
