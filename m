Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE71C2D0A3
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 00:05:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 41FD22151B
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 00:05:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41FD22151B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-jOBcOpEXOPq9KjGujfRjKg-1; Mon, 26 Oct 2020 20:05:14 -0400
X-MC-Unique: jOBcOpEXOPq9KjGujfRjKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC6F91074649;
	Tue, 27 Oct 2020 00:05:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AEFBF50B44;
	Tue, 27 Oct 2020 00:05:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7DE5E92F2F;
	Tue, 27 Oct 2020 00:05:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09R058n5022840 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 20:05:08 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 40E9885CC1; Tue, 27 Oct 2020 00:05:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BE6486D71
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 00:05:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0462F18056BF
	for <dm-devel@redhat.com>; Tue, 27 Oct 2020 00:05:06 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-499-T10LzsUeOseZRfvinDfqvA-1;
	Mon, 26 Oct 2020 20:05:01 -0400
X-MC-Unique: T10LzsUeOseZRfvinDfqvA-1
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net
	[73.47.72.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPSA id 3663720791;
	Tue, 27 Oct 2020 00:04:59 +0000 (UTC)
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Mon, 26 Oct 2020 20:03:52 -0400
Message-Id: <20201027000415.1026364-37-sashal@kernel.org>
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09R058n5022840
X-loop: dm-devel@redhat.com
Cc: Sasha Levin <sashal@kernel.org>, dm-devel@redhat.com,
	Mike Snitzer <snitzer@redhat.com>
Subject: [dm-devel] [PATCH AUTOSEL 4.19 37/60] dm: change max_io_len() to
	use blk_max_size_offset()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index 874bd542a7445..571d1cb2f6221 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -992,22 +992,18 @@ static sector_t max_io_len_target_boundary(sector_t sector, struct dm_target *ti
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

