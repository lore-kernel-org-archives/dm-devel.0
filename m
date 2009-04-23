From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Reattach device_handler for multipathing
Date: Thu, 23 Apr 2009 08:35:29 +0200
Message-ID: <20090423063529.DB686D381C@pentland.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


When specifying a different hardware handler via multipath
features we should be able to override the built-in defaults.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-mpath.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 095f77b..e6611de 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -592,9 +592,19 @@ static struct pgpath *parse_path(struct arg_set *as, struct path_selector *ps,
 	}
 
 	if (m->hw_handler_name) {
-		r = scsi_dh_attach(bdev_get_queue(p->path.dev->bdev),
-				   m->hw_handler_name);
+		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+
+		r = scsi_dh_attach(q, m->hw_handler_name);
+		if (r == -EBUSY) {
+			/*
+			 * Already attached to different hw_handler,
+			 * try to reattach with correct one.
+			 */
+			scsi_dh_detach(q);
+			r = scsi_dh_attach(q, m->hw_handler_name);
+		}
 		if (r < 0) {
+			ti->error = "error attaching hardware handler";
 			dm_put_device(ti, p->path.dev);
 			goto bad;
 		}
-- 
1.5.3.2
