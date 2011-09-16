From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm mpath: maintain reference count for
	underlying devices
Date: Fri, 16 Sep 2011 09:59:31 -0400
Message-ID: <1316181571-4691-1-git-send-email-snitzer@redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

When processing a request, DM-mpath's map_io() set the cloned request's
request_queue to the appropriate underlying device's request_queue
without getting a reference on that request_queue.

DM-mpath now maintains a reference count on the underlying devices'
request_queue.  This change wasn't motivated by a specific report but
code, like blk_insert_cloned_request(), will access the request_queue
with the understanding that the request_queue is valid.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

[v2: refreshes original patch and changes subject]

Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c
+++ linux-2.6/drivers/md/dm-mpath.c
@@ -160,11 +160,14 @@ static void free_pgpaths(struct list_hea
 {
 	struct pgpath *pgpath, *tmp;
 	struct multipath *m = ti->private;
+	struct request_queue *q;
 
 	list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
 		list_del(&pgpath->list);
+		q = bdev_get_queue(pgpath->path.dev->bdev);
 		if (m->hw_handler_name)
-			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
+			scsi_dh_detach(q);
+		blk_put_queue(q);
 		dm_put_device(ti, pgpath->path.dev);
 		free_pgpath(pgpath);
 	}
@@ -545,6 +548,7 @@ static struct pgpath *parse_path(struct 
 {
 	int r;
 	struct pgpath *p;
+	struct request_queue *q;
 	struct multipath *m = ti->private;
 
 	/* we need at least a path arg */
@@ -564,9 +568,14 @@ static struct pgpath *parse_path(struct 
 		goto bad;
 	}
 
-	if (m->hw_handler_name) {
-		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+	q = bdev_get_queue(p->path.dev->bdev);
+	r = blk_get_queue(q);
+	if (r) {
+		ti->error = "error getting request queue";
+		goto bad_queue;
+	}
 
+	if (m->hw_handler_name) {
 		r = scsi_dh_attach(q, m->hw_handler_name);
 		if (r == -EBUSY) {
 			/*
@@ -579,8 +588,7 @@ static struct pgpath *parse_path(struct 
 
 		if (r < 0) {
 			ti->error = "error attaching hardware handler";
-			dm_put_device(ti, p->path.dev);
-			goto bad;
+			goto bad_finish;
 		}
 
 		if (m->hw_handler_params) {
@@ -589,21 +597,22 @@ static struct pgpath *parse_path(struct 
 				ti->error = "unable to set hardware "
 							"handler parameters";
 				scsi_dh_detach(q);
-				dm_put_device(ti, p->path.dev);
-				goto bad;
+				goto bad_finish;
 			}
 		}
 	}
 
 	r = ps->type->add_path(ps, &p->path, as->argc, as->argv, &ti->error);
-	if (r) {
-		dm_put_device(ti, p->path.dev);
-		goto bad;
-	}
+	if (r)
+		goto bad_finish;
 
 	return p;
 
- bad:
+bad_finish:
+	blk_put_queue(q);
+bad_queue:
+	dm_put_device(ti, p->path.dev);
+bad:
 	free_pgpath(p);
 	return ERR_PTR(r);
 }
