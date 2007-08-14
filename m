From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC 3/3] dm: add calls for path event functions
Date: Tue, 14 Aug 2007 13:05:47 -0700
Message-ID: <11212.2971019291$1187122028@news.gmane.org>
References: <20070814200544.963756967@us.ibm.com>>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-uevent-mpath.patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: dm-devel.ids

This patch adds calls to dm_path_event for a failed path and a reinstated
path.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 drivers/md/dm-mpath.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/md/dm-mpath.c
===================================================================
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -10,6 +10,7 @@
 #include "dm-hw-handler.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
+#include "dm-uevent.h"
 
 #include <linux/ctype.h>
 #include <linux/init.h>
@@ -834,6 +835,9 @@ static int fail_path(struct pgpath *pgpa
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
+	dm_path_uevent(DM_UEVENT_PATH_FAILED, m->ti->table,
+		      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:
@@ -873,6 +877,9 @@ static int reinstate_path(struct pgpath 
 	if (!m->nr_valid_paths++ && m->queue_size)
 		queue_work(kmultipathd, &m->process_queued_ios);
 
+	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti->table,
+		      pgpath->path.dev->name, m->nr_valid_paths);
+
 	queue_work(kmultipathd, &m->trigger_event);
 
 out:

-- 
