From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] dm-mpath: do not activate failed paths
Date: Thu, 27 Feb 2014 08:30:29 +0100
Message-ID: <1393486229-72034-9-git-send-email-hare@suse.de>
References: <1393486229-72034-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393486229-72034-1-git-send-email-hare@suse.de>
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

activate_path() is run without a lock, so the path might be
set to failed before activate_path() had a chance to run.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0a40fa9..22e7365 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1196,8 +1196,11 @@ static void activate_path(struct work_struct *work)
 	struct pgpath *pgpath =
 		container_of(work, struct pgpath, activate_path.work);
 
-	scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
-				pg_init_done, pgpath);
+	if (pgpath->is_active)
+		scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
+				 pg_init_done, pgpath);
+	else
+		pg_init_done(pgpath, SCSI_DH_DEV_OFFLINED);
 }
 
 static int noretry_error(int error)
-- 
1.7.12.4
