From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 09/26] dm mpath: log device name
Date: Tue, 8 May 2007 20:45:54 +0100
Message-ID: <20070508194554.GP24114@agk.fab.redhat.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Edward Goggin <egoggin@emc.com>
List-Id: dm-devel.ids

From: Edward Goggin <egoggin@emc.com>

Make the mapped device structure accessible to hardware
handlers so error messages can include the device name.

Signed-off-by: Edward Goggin <egoggin@emc.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-hw-handler.h |    1 +
 drivers/md/dm-mpath.c      |    3 +++
 drivers/md/dm.c            |    1 +
 3 files changed, 5 insertions(+)

Index: linux-2.6.21/drivers/md/dm-hw-handler.h
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-hw-handler.h	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-hw-handler.h	2007-05-01 17:40:50.000000000 +0100
@@ -16,6 +16,7 @@
 struct hw_handler_type;
 struct hw_handler {
 	struct hw_handler_type *type;
+	struct mapped_device *md;
 	void *context;
 };
 
Index: linux-2.6.21/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-mpath.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-mpath.c	2007-05-01 17:40:50.000000000 +0100
@@ -668,6 +668,9 @@ static int parse_hw_handler(struct arg_s
 		return -EINVAL;
 	}
 
+	m->hw_handler.md = dm_table_get_md(ti->table);
+	dm_put(m->hw_handler.md);
+
 	r = hwht->create(&m->hw_handler, hw_argc - 1, as->argv);
 	if (r) {
 		dm_put_hw_handler(hwht);
Index: linux-2.6.21/drivers/md/dm.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm.c	2007-05-01 17:40:50.000000000 +0100
@@ -1236,6 +1236,7 @@ void dm_put(struct mapped_device *md)
 		free_dev(md);
 	}
 }
+EXPORT_SYMBOL_GPL(dm_put);
 
 /*
  * Process the deferred bios
