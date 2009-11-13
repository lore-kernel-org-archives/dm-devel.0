From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 1/2] dm: Add accessor dm_table_md_suspended
Date: Fri, 13 Nov 2009 00:06:42 -0800
Message-ID: <20091113080642.17587.37581.stgit@localhost.localdomain>
References: <20091113080637.17587.64935.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091113080637.17587.64935.stgit@localhost.localdomain>
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

Add a dm_table accessor function to check if md is suspended.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm-table.c         |    6 ++++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1a6cb3c..6616598 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1245,6 +1245,11 @@ struct mapped_device *dm_table_get_md(struct dm_table *t)
 	return t->md;
 }
 
+int dm_table_md_suspended(struct dm_table *t)
+{
+	return dm_suspended(t->md);
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
@@ -1255,3 +1260,4 @@ EXPORT_SYMBOL(dm_table_get_md);
 EXPORT_SYMBOL(dm_table_put);
 EXPORT_SYMBOL(dm_table_get);
 EXPORT_SYMBOL(dm_table_unplug_all);
+EXPORT_SYMBOL(dm_table_md_suspended);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index df7607e..3440c54 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -287,6 +287,7 @@ sector_t dm_table_get_size(struct dm_table *t);
 unsigned int dm_table_get_num_targets(struct dm_table *t);
 fmode_t dm_table_get_mode(struct dm_table *t);
 struct mapped_device *dm_table_get_md(struct dm_table *t);
+int dm_table_md_suspended(struct dm_table *t);
 
 /*
  * Trigger an event.
