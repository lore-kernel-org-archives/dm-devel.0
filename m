Return-Path: <SRS0=mox9=IO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E26AC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 04:36:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DBD8565105
	for <dm-devel@archiver.kernel.org>; Tue, 16 Mar 2021 04:36:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBD8565105
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-261-UpoEuX5LPjmjYBE2D2YLPQ-1; Tue, 16 Mar 2021 00:36:28 -0400
X-MC-Unique: UpoEuX5LPjmjYBE2D2YLPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4DB184BA4D;
	Tue, 16 Mar 2021 04:36:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E41951F445;
	Tue, 16 Mar 2021 04:36:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2C78B18155DE;
	Tue, 16 Mar 2021 04:36:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12G4aH6M011471 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Mar 2021 00:36:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6F7C363F24; Tue, 16 Mar 2021 04:36:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68DDE6B5B4
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 04:36:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8DADA800140
	for <dm-devel@redhat.com>; Tue, 16 Mar 2021 04:36:10 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-289-wCkbUCyzMBqCHms1xbB71A-1; Tue, 16 Mar 2021 00:36:06 -0400
X-MC-Unique: wCkbUCyzMBqCHms1xbB71A-1
IronPort-SDR: TdPuOUBfQ6euiMWXfO7yV0GZQdvbsZ4wyRz+Z/3NnBRZnEGDLw+Z5aomjtccoBazif8WSqK9CQ
	5nG5Q5+OTCMCOLYW6gSjdLeN3UV3K+a4ySPwK1upB+5nF+eOJYAF840lhrwtjGVRvVJbn95Cr6
	GNAl63izWaWvgHyH71LE2PUWmxu3pzNPjIRnAToag4KKUfGeF10Qt+EjW8M7nFq+7RQjs3WeOL
	bVefOQ1TQEnQE80JW8TEHNhFNftLlFhw9hl2iMXIR9UmWDGdlw8XjLkZqGqQW0z5XVNzujBdDV
	b08=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; d="scan'208";a="162237835"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 12:36:04 +0800
IronPort-SDR: zawZe/rqwVCtfQ1WOBR2CpSxoesZkbB9MZD7u9+mo/gy4cM4BfkMmHV2QHzB3fEstuXOYrfAJc
	tCWEg8c733EucdMBTjr6SHzD6deg8g7GGNXmdYQBwN0vpGQE3LUfmFcqrUxFvSUQRVekSX2Wn3
	yMK/9+5l4BJk1Qy+SiIlkuS3vtxcGQ99seDT4Fmi6cO2oYNTJIgycSl6K1dJlRuhCPS55O+dCF
	sbFlSC08LoeXL//g4OJdMgK4KYZg9woPhyx8cfVYXdk0fzAWQHc3htvJwowXHzuBC7gx/46OQd
	W3TKjqtnphiqEwnZaBWePNDs
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	15 Mar 2021 21:16:41 -0700
IronPort-SDR: Oc/Rx3lW89E9ToktVSNltBD/g4+lo3IrURmH/Wug/pU2+8UHum4rXEmFjlYbqetN5BmWPa0Ivw
	BVdQKjtGqr4/tn/M2LvOXTAuRXMebESEkUt9bhM1v2llMAxsgN86zmy7suf+fCXeM2AyVeK+LE
	lgceRkIJz4k07vfQtMZ1k/uzIeb/KxZlPHbVllxrFzEubkHG5o3KX15loG1K9LTHJkfxPCyR5h
	ulaqj1UbNa/esAW+0utIlk9rGXhp8ahyd9ZKdw4tCXCIFL48e3WuKrLmVxI93ixBmDTZ2sBod6
	CeE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com ([10.149.52.189])
	by uls-op-cesaip02.wdc.com with ESMTP; 15 Mar 2021 21:36:03 -0700
From: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Date: Tue, 16 Mar 2021 13:36:02 +0900
Message-Id: <20210316043602.1208915-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: [dm-devel] [PATCH v2] dm table: Fix zoned model check and zone
	sectors check
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 24f6b6036c9e ("dm table: fix zoned iterate_devices based device
capability checks") triggered dm table load failure when dm-zoned device
is set up for zoned block devices and a regular device for cache.

The commit inverted logic of two callback functions for iterate_devices:
device_is_zoned_model() and device_matches_zone_sectors(). The logic of
device_is_zoned_model() was inverted then all destination devices of all
targets in dm table are required to have the expected zoned model. This
is fine for dm-linear, dm-flakey and dm-crypt on zoned block devices
since each target has only one destination device. However, this results
in failure for dm-zoned with regular cache device since that target has
both regular block device and zoned block devices.

As for device_matches_zone_sectors(), the commit inverted the logic to
require all zoned block devices in each target have the specified
zone_sectors. This check also fails for regular block device which does
not have zones.

To avoid the check failures, fix the zone model check and the zone
sectors check. For zone model check, introduce the new feature flag
DM_TARGET_MIXED_ZONED_MODEL, and set it to dm-zoned target. When the
target has this flag, allow it to have destination devices with any
zoned model. For zone sectors check, skip the check if the destination
device is not a zoned block device. Also add comments and improve an
error message to clarify expectations to the two checks.

Fixes: 24f6b6036c9e ("dm table: fix zoned iterate_devices based device capability checks")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
Changes from v1:
* Added DM_TARGET_MIXED_ZONED_MODEL feature for zoned model check of dm-zoned

 drivers/md/dm-table.c         | 34 ++++++++++++++++++++++++++--------
 drivers/md/dm-zoned-target.c  |  2 +-
 include/linux/device-mapper.h | 15 ++++++++++++++-
 3 files changed, 41 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 95391f78b8d5..cc73d5b473eb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1594,6 +1594,13 @@ static int device_not_zoned_model(struct dm_target *ti, struct dm_dev *dev,
 	return blk_queue_zoned_model(q) != *zoned_model;
 }
 
+/*
+ * Check the device zoned model based on the target feature flag. If the target
+ * has the DM_TARGET_ZONED_HM feature flag set, host-managed zoned devices are
+ * also accepted but all devices must have the same zoned model. If the target
+ * has the DM_TARGET_MIXED_ZONED_MODEL feature set, the devices can have any
+ * zoned model with all zoned devices having the same zone size.
+ */
 static bool dm_table_supports_zoned_model(struct dm_table *t,
 					  enum blk_zoned_model zoned_model)
 {
@@ -1603,13 +1610,16 @@ static bool dm_table_supports_zoned_model(struct dm_table *t,
 	for (i = 0; i < dm_table_get_num_targets(t); i++) {
 		ti = dm_table_get_target(t, i);
 
-		if (zoned_model == BLK_ZONED_HM &&
-		    !dm_target_supports_zoned_hm(ti->type))
-			return false;
-
-		if (!ti->type->iterate_devices ||
-		    ti->type->iterate_devices(ti, device_not_zoned_model, &zoned_model))
-			return false;
+		if (dm_target_supports_zoned_hm(ti->type)) {
+			if (!ti->type->iterate_devices ||
+			    ti->type->iterate_devices(ti,
+						      device_not_zoned_model,
+						      &zoned_model))
+				return false;
+		} else if (!dm_target_supports_mixed_zoned_model(ti->type)) {
+			if (zoned_model == BLK_ZONED_HM)
+				return false;
+		}
 	}
 
 	return true;
@@ -1621,9 +1631,17 @@ static int device_not_matches_zone_sectors(struct dm_target *ti, struct dm_dev *
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 	unsigned int *zone_sectors = data;
 
+	if (!blk_queue_is_zoned(q))
+		return 0;
+
 	return blk_queue_zone_sectors(q) != *zone_sectors;
 }
 
+/*
+ * Check consistency of zoned model and zone sectors across all targets. For
+ * zone sectors, if the destination device is a zoned block device, it shall
+ * have the specified zone_sectors.
+ */
 static int validate_hardware_zoned_model(struct dm_table *table,
 					 enum blk_zoned_model zoned_model,
 					 unsigned int zone_sectors)
@@ -1642,7 +1660,7 @@ static int validate_hardware_zoned_model(struct dm_table *table,
 		return -EINVAL;
 
 	if (dm_table_any_dev_attr(table, device_not_matches_zone_sectors, &zone_sectors)) {
-		DMERR("%s: zone sectors is not consistent across all devices",
+		DMERR("%s: zone sectors is not consistent across all zoned devices",
 		      dm_device_name(table->md));
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 697f9de37355..7e88df64d197 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1143,7 +1143,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
 static struct target_type dmz_type = {
 	.name		 = "zoned",
 	.version	 = {2, 0, 0},
-	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
+	.features	 = DM_TARGET_SINGLETON | DM_TARGET_MIXED_ZONED_MODEL,
 	.module		 = THIS_MODULE,
 	.ctr		 = dmz_ctr,
 	.dtr		 = dmz_dtr,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 7f4ac87c0b32..5c641f930caf 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -253,7 +253,11 @@ struct target_type {
 #define dm_target_passes_integrity(type) ((type)->features & DM_TARGET_PASSES_INTEGRITY)
 
 /*
- * Indicates that a target supports host-managed zoned block devices.
+ * Indicates support for zoned block devices:
+ * - DM_TARGET_ZONED_HM: the target also supports host-managed zoned
+ *   block devices but does not support combining different zoned models.
+ * - DM_TARGET_MIXED_ZONED_MODEL: the target supports combining multiple
+ *   devices with different zoned models.
  */
 #ifdef CONFIG_BLK_DEV_ZONED
 #define DM_TARGET_ZONED_HM		0x00000040
@@ -275,6 +279,15 @@ struct target_type {
 #define DM_TARGET_PASSES_CRYPTO		0x00000100
 #define dm_target_passes_crypto(type) ((type)->features & DM_TARGET_PASSES_CRYPTO)
 
+#ifdef CONFIG_BLK_DEV_ZONED
+#define DM_TARGET_MIXED_ZONED_MODEL	0x00000200
+#define dm_target_supports_mixed_zoned_model(type) \
+	((type)->features & DM_TARGET_MIXED_ZONED_MODEL)
+#else
+#define DM_TARGET_MIXED_ZONED_MODEL	0x00000000
+#define dm_target_supports_mixed_zoned_model(type) (false)
+#endif
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

