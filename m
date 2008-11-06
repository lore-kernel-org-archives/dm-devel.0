From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH] Do not try to activate path if pgpath is NULL
Date: Wed, 05 Nov 2008 19:58:46 -0800
Message-ID: <1225943926.14830.1099.camel@chandra-ubuntu>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Path activation code is called even when the pgpath is NULL. This could
lead to a panic in activate_path(). Such a panic is seen in -rt kernel.

This problem has been there before the pg_init() was moved to a
workqueue.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---

Index: linux-2.6.28-rc3/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.28-rc3.orig/drivers/md/dm-mpath.c
+++ linux-2.6.28-rc3/drivers/md/dm-mpath.c
@@ -441,13 +441,13 @@ static void process_queued_ios(struct wo
 		__choose_pgpath(m);
 
 	pgpath = m->current_pgpath;
-	m->pgpath_to_activate = m->current_pgpath;
 
 	if ((pgpath && !m->queue_io) ||
 	    (!pgpath && !m->queue_if_no_path))
 		must_queue = 0;
 
-	if (m->pg_init_required && !m->pg_init_in_progress) {
+	if (m->pg_init_required && !m->pg_init_in_progress && pgpath) {
+		m->pgpath_to_activate = pgpath;
 		m->pg_init_count++;
 		m->pg_init_required = 0;
 		m->pg_init_in_progress = 1;
