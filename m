From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH 7/9] dm thin: add method to provision space
Date: Thu, 17 Mar 2016 10:30:35 -0400
Message-ID: <1458225037-24155-8-git-send-email-bfoster@redhat.com>
References: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1458225037-24155-1-git-send-email-bfoster@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

This is a hacky interface added to support the filesystem experiment for
reserving blocks out of thin pools. The XFS POC uses this method
provision space in the pool when blocks are allocated. The number of
actual blocks allocated is returned, which is used to update the
filesystem accounting.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 drivers/md/dm-thin.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index ac770d89..00b7322 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4389,6 +4389,52 @@ static int thin_get_reserved_space(struct dm_target *ti, sector_t *nr_sects)
 	return 0;
 }
 
+static int thin_provision_space(struct dm_target *ti, sector_t offset, sector_t len)
+{
+	struct thin_c *tc = ti->private;
+	struct pool *pool = tc->pool;
+	sector_t end;
+	dm_block_t pblock;
+	dm_block_t vblock;
+	int error;
+	struct dm_thin_lookup_result lookup;
+	sector_t count;
+
+	if (!is_factor(offset, pool->sectors_per_block))
+		return -EINVAL;
+
+	if (!len || !is_factor(len, pool->sectors_per_block))
+		return -EINVAL;
+
+	end = offset + len;
+
+	count = 0;
+	while (offset < end) {
+		vblock = offset / pool->sectors_per_block;
+
+		error = dm_thin_find_block(tc->td, vblock, true, &lookup);
+		if (error == 0)
+			goto next;
+		if (error != -ENODATA)
+			return error;
+
+		error = alloc_data_block(tc, &pblock);
+		if (error)
+			return error;
+
+		error = dm_thin_insert_block(tc->td, vblock, pblock);
+		if (error)
+			return error;
+
+		count += pool->sectors_per_block;
+next:
+		offset += pool->sectors_per_block;
+	}
+
+	/* XXX: int -> sector_t ! */
+	return count;
+}
+
 static struct target_type thin_target = {
 	.name = "thin",
 	.version = {1, 18, 0},
@@ -4405,6 +4451,7 @@ static struct target_type thin_target = {
 	.io_hints = thin_io_hints,
 	.reserve_space = thin_reserve_space,
 	.get_reserved_space = thin_get_reserved_space,
+	.provision_space = thin_provision_space,
 };
 
 /*----------------------------------------------------------------*/
-- 
2.4.3

