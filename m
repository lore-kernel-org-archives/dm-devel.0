From: Joe Perches <joe@perches.com>
Subject: [PATCH 2/7] dm_table: Use bool function return values of true/false not 1/0
Date: Mon, 30 Mar 2015 10:43:18 -0700
Message-ID: <e89210c7bf1423deef3cf16b618cd314307261db.1427736972.git.joe@perches.com>
References: <cover.1427736972.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1427736972.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: dm-devel.ids

Use the normal return values for bool functions

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/md/dm-table.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e0f618b..d9b00b8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1336,14 +1336,14 @@ static bool dm_table_supports_flush(struct dm_table *t, unsigned flush)
 			continue;
 
 		if (ti->flush_supported)
-			return 1;
+			return true;
 
 		if (ti->type->iterate_devices &&
 		    ti->type->iterate_devices(ti, device_flush_capable, &flush))
-			return 1;
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
 static bool dm_table_discard_zeroes_data(struct dm_table *t)
@@ -1356,10 +1356,10 @@ static bool dm_table_discard_zeroes_data(struct dm_table *t)
 		ti = dm_table_get_target(t, i++);
 
 		if (ti->discard_zeroes_data_unsupported)
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
@@ -1405,10 +1405,10 @@ static bool dm_table_all_devices_attribute(struct dm_table *t,
 
 		if (!ti->type->iterate_devices ||
 		    !ti->type->iterate_devices(ti, func, NULL))
-			return 0;
+			return false;
 	}
 
-	return 1;
+	return true;
 }
 
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
@@ -1465,14 +1465,14 @@ static bool dm_table_supports_discards(struct dm_table *t)
 			continue;
 
 		if (ti->discards_supported)
-			return 1;
+			return true;
 
 		if (ti->type->iterate_devices &&
 		    ti->type->iterate_devices(ti, device_discard_capable, NULL))
-			return 1;
+			return true;
 	}
 
-	return 0;
+	return false;
 }
 
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
-- 
2.1.2
