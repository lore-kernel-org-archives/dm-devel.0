From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 1] dm table cleanup warning message
Date: Fri, 20 Mar 2009 10:11:18 -0500
Message-ID: <200903201511.n2KFBIVp016118@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-table-cleanup-warning-message.patch

Adjust warning message, since there is no dm_table_remove_device
which the message references.  I found it also helpful to get
a message about /which/ device was not dm_put_device'ed.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -299,9 +299,11 @@ void dm_table_destroy(struct dm_table *t
 
 	/* free the device list */
 	if (t->devices.next != &t->devices) {
-		DMWARN("devices still present during destroy: "
-		       "dm_table_remove_device calls missing");
+		struct dm_dev_internal *dd;
 
+		DMWARN("dm_put_device calls missing for:");
+		list_for_each_entry(dd, &t->devices, list)
+			DMWARN(" - %s", dd->dm_dev.name);
 		free_devices(&t->devices);
 	}
 
