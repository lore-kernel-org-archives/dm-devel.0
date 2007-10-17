From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 04/04] dm mpath: send uevents
Date: Wed, 17 Oct 2007 13:55:11 +0100
Message-ID: <20071017125511.GP24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mike Anderson <andmike@linux.vnet.ibm.com>

This patch adds calls to dm_path_event for a failed path and a reinstated
path.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-mpath.c |    7 +++++++
 1 files changed, 7 insertions(+)

Index: linux-2.6.23/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-mpath.c	2007-10-16 23:39:02.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-mpath.c	2007-10-16 23:39:06.000000000 +0100
@@ -10,6 +10,7 @@
 #include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
+#include "dm-uevent.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -857,6 +858,9 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
+	dm_path_uevent(DM_UEVENT_PATH_FAILED, m->ti,
+		      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -896,6 +900,9 @@ static int reinstate_path(struct pgpath 
 	if (!m->nr_valid_paths++ && m->queue_size)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
+	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti,
+		      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
