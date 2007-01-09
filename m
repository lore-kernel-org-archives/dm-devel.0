From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 3/4] dm-netlink: Add calls for failed and
	reinstated paths
Date: Tue, 9 Jan 2007 01:33:49 -0800
Message-ID: <20070109093349.GD11649@us.ibm.com>
References: <20070109093006.GA11649@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070109093006.GA11649@us.ibm.com>
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

From: Mike Anderson <andmike@us.ibm.com>

This patch adds calls to dm_path_event for a failed path and a reinstated
path.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 drivers/md/dm-mpath.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6-patched/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm-mpath.c	2007-01-09 01:11:44.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm-mpath.c	2007-01-09 01:12:05.000000000 -0800
@@ -834,6 +834,9 @@
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
+	dm_path_event(DM_EVENT_FAIL_PATH, m->ti->table,
+			 pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -873,6 +876,9 @@
 	if (!m->nr_valid_paths++ && m->queue_size)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
+	dm_path_event(DM_EVENT_REINSTATE_PATH, m->ti->table,
+			      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
