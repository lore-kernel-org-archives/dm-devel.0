From: "goggin, edward" <egoggin@emc.com>
Subject: patch to dm.c to wakeup event waiters when map name
	changed
Date: Thu, 10 Nov 2005 13:40:08 -0500
Message-ID: <C2EEB4E538D3DC48BF57F391F422779321ADD8@srmanning.eng.emc.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: "'dm-devel@redhat.com'" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Changed dm_hash_rename() to wake up any dm event waiters for
a mapped device after changing the name of the mapped device.


--- ../base/linux-2.6.14-rc4/drivers/md/dm-ioctl.c	2005-10-10
20:19:19.000000000 -0500
+++ drivers/md/dm-ioctl.c	2005-11-03 13:25:57.000000000 -0600
@@ -270,6 +270,7 @@ static int dm_hash_rename(const char *ol
 {
 	char *new_name, *old_name;
 	struct hash_cell *hc;
+	struct dm_table *table;
 
 	/*
 	 * duplicate new.
@@ -317,6 +318,15 @@ static int dm_hash_rename(const char *ol
 	/* rename the device node in devfs */
 	register_with_devfs(hc);
 
+	/*
+	 * Wakeup any dm event waiters.
+	 */
+	table = dm_get_table(hc->md);
+	if (table) {
+		dm_table_event(table);
+		dm_table_put(table);
+	}
+
 	up_write(&_hash_lock);
 	kfree(old_name);
 	return 0;
