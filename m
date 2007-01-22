From: Mike Anderson <andmike@us.ibm.com>
Subject: [patch 3/3] dm-mpath: Add calls dm-netlink path event
	functions
Date: Mon, 22 Jan 2007 10:17:21 -0800
Message-ID: <885.726293972944$1169489827@news.gmane.org>
References: <20070122181718.377495483@us.ibm.com>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-netlink-mpath.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This patch adds calls to dm_path_event for a failed path and a reinstated
path.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 drivers/md/dm-mpath.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-patched/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm-mpath.c	2007-01-16 10:46:36.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm-mpath.c	2007-01-17 11:13:29.000000000 -0800
@@ -856,6 +856,9 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
+	dm_path_event(DM_EVENT_FAIL_PATH, m->ti->table,
+			 pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -895,6 +898,9 @@ static int reinstate_path(struct pgpath 
 	if (!m->nr_valid_paths++ && m->queue_size)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
+	dm_path_event(DM_EVENT_REINSTATE_PATH, m->ti->table,
+			      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:

-- 
