From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/8] dm mpath: do not call pg_init when it is
	already running
Date: Fri, 28 Feb 2014 15:33:42 +0100
Message-ID: <1393598029-67995-2-git-send-email-hare@suse.de>
References: <1393598029-67995-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393598029-67995-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

This patch moves condition checks as a preparation of following
patches and has no effect on behaviour.
process_queued_ios() is the only caller of __pg_init_all_paths()
and 2 condition checks are moved from outside to inside without
side effects.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e8431fb..bb2f6b2 100644
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
1.7.12.4
