From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 1/3] dm: Add dm_deleting accesor function
Date: Fri, 13 Nov 2009 00:04:28 -0800
Message-ID: <20091113080427.17412.41405.stgit@localhost.localdomain>
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

Add dm_deleting accesor function to allow checking of the DMF_DELETING bit.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/md/dm.c               |    5 +++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 724efc6..96127cc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2604,6 +2604,11 @@ int dm_suspended(struct mapped_device *md)
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_deleting(struct mapped_device *md)
+{
+	return test_bit(DMF_DELETING, &md->flags);
+}
+
 int dm_noflush_suspending(struct dm_target *ti)
 {
 	struct mapped_device *md = dm_table_get_md(ti->table);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 3440c54..16cd291 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -236,6 +236,7 @@ const char *dm_device_name(struct mapped_device *md);
 int dm_copy_name_and_uuid(struct mapped_device *md, char *name, char *uuid);
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
+int dm_deleting(struct mapped_device *md);
 int dm_noflush_suspending(struct dm_target *ti);
 union map_info *dm_get_mapinfo(struct bio *bio);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
