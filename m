Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A80C4363A
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 00:18:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2B6FE20708
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 00:18:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B6FE20708
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-RXLte-FtOi2pt8aUarvATg-1; Mon, 26 Oct 2020 20:18:22 -0400
X-MC-Unique: RXLte-FtOi2pt8aUarvATg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E3C6D809DD1;
	Tue, 27 Oct 2020 00:18:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6DF555789;
	Tue, 27 Oct 2020 00:18:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A064A92F33;
	Tue, 27 Oct 2020 00:18:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09R0BnQX023584 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 20:11:49 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1E4BD207B44C; Tue, 27 Oct 2020 00:11:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 190EC207B2D7
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 00:11:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FE5A8007DF
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 00:11:44 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-494-GVJn1pZYPi26KjYk-0q8EA-1;
	Mon, 26 Oct 2020 20:11:41 -0400
X-MC-Unique: GVJn1pZYPi26KjYk-0q8EA-1
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net
	[73.47.72.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 768D921D42;
	Tue, 27 Oct 2020 00:11:39 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 26 Oct 2020 20:11:11 -0400
Message-Id: <20201027001123.1027642-13-sashal@kernel.org>
In-Reply-To: <20201027001123.1027642-1-sashal@kernel.org>
References: <20201027001123.1027642-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09R0BnQX023584
X-loop: dm-devel@redhat.com
Cc: Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: [dm-devel] [PATCH AUTOSEL 4.4 13/25] dm: change max_io_len() to use
	blk_max_size_offset()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Mike Snitzer <snitzer@redhat.com>

[ Upstream commit 5091cdec56faeaefa79de4b6cb3c3c55e50d1ac3 ]

Using blk_max_size_offset() enables DM core's splitting to impose
ti->max_io_len (via q->limits.chunk_sectors) and also fallback to
respecting q->limits.max_sectors if chunk_sectors isn't set.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ff017d148323d..41cb281685242 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1393,22 +1393,18 @@ static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti
 static sector_t max_io_len(sector_t sector, struct dm_target *ti)
 {
 	sector_t len = max_io_len_target_boundary(sector, ti);
-	sector_t offset, max_len;
+	sector_t max_len;
 
 	/*
 	 * Does the target need to split even further?
+	 * - q->limits.chunk_sectors reflects ti->max_io_len so
+	 *   blk_max_size_offset() provides required splitting.
+	 * - blk_max_size_offset() also respects q->limits.max_sectors
 	 */
-	if (ti->max_io_len) {
-		offset = dm_target_offset(ti, sector);
-		if (unlikely(ti->max_io_len & (ti->max_io_len - 1)))
-			max_len = sector_div(offset, ti->max_io_len);
-		else
-			max_len = offset & (ti->max_io_len - 1);
-		max_len = ti->max_io_len - max_len;
-
-		if (len > max_len)
-			len = max_len;
-	}
+	max_len = blk_max_size_offset(dm_table_get_md(ti->table)->queue,
+				      dm_target_offset(ti, sector));
+	if (len > max_len)
+		len = max_len;
 
 	return len;
 }
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

