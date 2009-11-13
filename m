From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 2/3] dm: Add accessor dm_table_md_deleting
Date: Fri, 13 Nov 2009 00:04:33 -0800
Message-ID: <20091113080433.17412.48559.stgit@localhost.localdomain>
References: <20091113080422.17412.49305.stgit@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091113080422.17412.49305.stgit@localhost.localdomain>
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

Add a dm_table accessor function to check if md is being deleted.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm-table.c         |    6 ++++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6616598..fdf86fe 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1250,6 +1250,11 @@ int dm_table_md_suspended(struct dm_table *t)
 	return dm_suspended(t->md);
 }
 
+int dm_table_md_deleting(struct dm_table *t)
+{
+	return dm_deleting(t->md);
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
@@ -1261,3 +1266,4 @@ EXPORT_SYMBOL(dm_table_put);
 EXPORT_SYMBOL(dm_table_get);
 EXPORT_SYMBOL(dm_table_unplug_all);
 EXPORT_SYMBOL(dm_table_md_suspended);
+EXPORT_SYMBOL(dm_table_md_deleting);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 16cd291..5a0fb6c 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -289,6 +289,7 @@ unsigned int dm_table_get_num_targets(struct dm_table *t);
 fmode_t dm_table_get_mode(struct dm_table *t);
 struct mapped_device *dm_table_get_md(struct dm_table *t);
 int dm_table_md_suspended(struct dm_table *t);
+int dm_table_md_deleting(struct dm_table *t);
 
 /*
  * Trigger an event.
