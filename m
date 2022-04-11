Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BF8EC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 09:38:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-RlVTbu0dOQq76jUf6Bhgsw-1; Mon, 11 Apr 2022 05:38:53 -0400
X-MC-Unique: RlVTbu0dOQq76jUf6Bhgsw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 793991014A6D;
	Mon, 11 Apr 2022 09:38:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 20DAF145B991;
	Mon, 11 Apr 2022 09:38:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B29FD19451F2;
	Mon, 11 Apr 2022 09:38:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 35CCF19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Apr 2022 09:38:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 182D32026D2D; Mon, 11 Apr 2022 09:38:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 136F22024CCB
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 09:38:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB76F8038E3
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 09:38:44 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-UoBsjDZ1MCO6p_WDEvAPNA-1; Mon, 11 Apr 2022 05:38:42 -0400
X-MC-Unique: UoBsjDZ1MCO6p_WDEvAPNA-1
X-IronPort-AV: E=Sophos;i="5.90,251,1643644800"; d="scan'208";a="198510892"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 11 Apr 2022 17:38:42 +0800
IronPort-SDR: xRqOIUPzv1Yvu/g4XZVS4FgNL17XZFpOehR1Ncuvoadk9ropGjsJndCSxD0q/l0AvMx9LTRE1Q
 lC20Cv4W/Hb1AzBPMcZOJFrokZCXidCFlXJvKi5G2/7UHCt01eHfABi0cYs8lzkI7AzONHCi/J
 X3xSDXnL+lOGkE8UXItHjhQqX3jJPqR3GjWVugT1cwx9oNsf6I6HimMcNxCUXpJEIog/5pfU6U
 6r/xuUzuwA4vA8Swc0jMBSCWPuJqhIgX3QI7eGjk0CndJFJU6L5862QnBgE6dBJDLMSnOqWvvz
 0xYZXgf3th4jlcISCaCF4I2i
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 02:09:11 -0700
IronPort-SDR: os2g1yyZXeQxQUDiLa6TfbTgWUOOyGli0sg0Up2Zj5J5DMZzz1d+ICvcyUafwTZR1quj1ctWP6
 BOZbQ/WxjMqy6rglfGYjNNv2AhQ/0bwt7i9Nf4VZgzQkCbq829Z0A8fdSkqZO086BmHdxgML0c
 iekvjQ1iNENNtqHArdPizQpE0s/wjCF6soDf9Ggdgw+VETCR18jvXACHdUR8GEq5KC4W7HeN1I
 WlxLkJLpgIcV6dBjZpVCwKoGFHVX+2LW7qfz8pZ3gR6kaAL4EPdm4wKsQWp8IvppoZcm9cIbmW
 myg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
 by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 11 Apr 2022 02:38:42 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KcP1Y2fMpz1Rwrw
 for <dm-devel@redhat.com>; Mon, 11 Apr 2022 02:38:41 -0700 (PDT)
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
 by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new,
 port 10026) with ESMTP id 2Q5CYNF1kpIU for <dm-devel@redhat.com>;
 Mon, 11 Apr 2022 02:38:41 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com
 [10.149.53.254])
 by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KcP1X1b0rz1Rvlx;
 Mon, 11 Apr 2022 02:38:39 -0700 (PDT)
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
To: dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Date: Mon, 11 Apr 2022 18:38:38 +0900
Message-Id: <20220411093838.1729001-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH] dm: dm-zone: Fix NULL pointer dereference in
 dm_zone_map_bio()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface") changed
the alloc_io() function to delay the initialization of struct dm_io
orig_bio field, leaving this field as NULL until the first call to
__split_and_process_bio() is executed for the user submitted BIO. This
change causes a NULL pointer dereference in dm_zone_map_bio() when the
original user BIO is inspected to detect the need for zone append
command emulation.

Avoid this problem by adding a struct clone_info *ci argument to the
__map_bio() function and a struct bio *orig_bio argument to
dm_zone_map_bio(). Doing so, the call to dm_zone_map_bio() can be passed
directly a pointer to the original user BIO using the bio field of
struct clone_info.

Fixes: 0fbb4d93b38b ("dm: add dm_submit_bio_remap interface")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/md/dm-zone.c |  3 +--
 drivers/md/dm.c      | 10 +++++-----
 drivers/md/dm.h      |  5 +++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index c1ca9be4b79e..772161f0b029 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -513,13 +513,12 @@ static bool dm_need_zone_wp_tracking(struct bio *orig_bio)
 /*
  * Special IO mapping for targets needing zone append emulation.
  */
-int dm_zone_map_bio(struct dm_target_io *tio)
+int dm_zone_map_bio(struct dm_target_io *tio, struct bio *orig_bio)
 {
 	struct dm_io *io = tio->io;
 	struct dm_target *ti = tio->ti;
 	struct mapped_device *md = io->md;
 	struct request_queue *q = md->queue;
-	struct bio *orig_bio = io->orig_bio;
 	struct bio *clone = &tio->clone;
 	unsigned int zno;
 	blk_status_t sts;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3c5fad7c4ee6..1d8f24f04c7d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1258,7 +1258,7 @@ static noinline void __set_swap_bios_limit(struct mapped_device *md, int latch)
 	mutex_unlock(&md->swap_bios_lock);
 }
 
-static void __map_bio(struct bio *clone)
+static void __map_bio(struct clone_info *ci, struct bio *clone)
 {
 	struct dm_target_io *tio = clone_to_tio(clone);
 	int r;
@@ -1287,7 +1287,7 @@ static void __map_bio(struct bio *clone)
 	 * map operation.
 	 */
 	if (dm_emulate_zone_append(io->md))
-		r = dm_zone_map_bio(tio);
+		r = dm_zone_map_bio(tio, ci->bio);
 	else
 		r = ti->type->map(ti, clone);
 
@@ -1364,13 +1364,13 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 	case 1:
 		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
 		dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
-		__map_bio(clone);
+		__map_bio(ci, clone);
 		break;
 	default:
 		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 		while ((clone = bio_list_pop(&blist))) {
 			dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
-			__map_bio(clone);
+			__map_bio(ci, clone);
 		}
 		break;
 	}
@@ -1532,7 +1532,7 @@ static int __split_and_process_bio(struct clone_info *ci)
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
-	__map_bio(clone);
+	__map_bio(ci, clone);
 
 	ci->sector += len;
 	ci->sector_count -= len;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 9013dc1a7b00..6e148590ec9c 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -108,7 +108,7 @@ void dm_cleanup_zoned_dev(struct mapped_device *md);
 int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data);
 bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
-int dm_zone_map_bio(struct dm_target_io *io);
+int dm_zone_map_bio(struct dm_target_io *io, struct bio *orig_bio);
 #else
 static inline void dm_cleanup_zoned_dev(struct mapped_device *md) {}
 #define dm_blk_report_zones	NULL
@@ -116,7 +116,8 @@ static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
 {
 	return false;
 }
-static inline int dm_zone_map_bio(struct dm_target_io *tio)
+static inline int dm_zone_map_bio(struct dm_target_io *tio,
+				  struct bio *orig_bio)
 {
 	return DM_MAPIO_KILL;
 }
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

