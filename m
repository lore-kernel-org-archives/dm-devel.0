From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/7] dm mpath: do not call pg_init when it is
	already running
Date: Mon,  3 Feb 2014 15:28:40 -0500
Message-ID: <1391459326-21569-2-git-send-email-snitzer@redhat.com>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Hannes Reinecke <hare@suse.de>

When pg_init is running we shouldn't be calling the same
routine twice; we need to wait for the first pg_init to
complete.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 6eb9dc9..304ee5c 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -261,6 +261,9 @@ static void __pg_init_all_paths(struct multipath *m)
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
+	if (m->pg_init_in_progress || m->pg_init_disabled)
+		return;
+
 	m->pg_init_count++;
 	m->pg_init_required = 0;
 	if (m->pg_init_delay_retry)
@@ -501,8 +504,7 @@ static void process_queued_ios(struct work_struct *work)
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress && pgpath &&
-	    !m->pg_init_disabled)
+	if (pgpath && m->pg_init_required)
 		__pg_init_all_paths(m);
 
 	spin_unlock_irqrestore(&m->lock, flags);
-- 
1.8.1.4
