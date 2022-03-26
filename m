Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D36A2C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 26 Mar 2022 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648304707;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=J2BcuyqSAeX/YZ8t5zYzaFDpdxYzQyVelcFMYXrIN0Y=;
	b=X+qomZqzNEq/FEYaG7kURbt6NslMNcsYGxiSg3Ym2vFhrfx2N8XiKsu6YaNhBXF77hTAt0
	EZ9aB76iZRrzDix2650JsGaLxbIfsYti0P3mRw4+l528aO99IpvN2RR0wvWbxEyydV9ag9
	P7Z2ms7Aom5Vpm0ljlPp9YDJvBPiZbE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-SRBoBlm7M3WVjljbEMqcxQ-1; Sat, 26 Mar 2022 10:25:06 -0400
X-MC-Unique: SRBoBlm7M3WVjljbEMqcxQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 322898002BF;
	Sat, 26 Mar 2022 14:25:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0D7AE400E54B;
	Sat, 26 Mar 2022 14:25:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39AE219451F0;
	Sat, 26 Mar 2022 14:25:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6AF2519451EF
 for <dm-devel@listman.corp.redhat.com>; Sat, 26 Mar 2022 14:25:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 56F852144B4E; Sat, 26 Mar 2022 14:25:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 188CC2144B4C;
 Sat, 26 Mar 2022 14:24:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 22QEOvdd021391; Sat, 26 Mar 2022 10:24:57 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 22QEOvM2021387; Sat, 26 Mar 2022 10:24:57 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Sat, 26 Mar 2022 10:24:56 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Ondrej Kozina <okozina@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
In-Reply-To: <4ed29ab9-5cbc-2185-d87d-9a6dbe82a460@redhat.com>
Message-ID: <alpine.LRH.2.02.2203261023170.21027@file01.intranet.prod.int.rdu2.redhat.com>
References: <4ed29ab9-5cbc-2185-d87d-9a6dbe82a460@redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: [dm-devel] [PATCH] dm-integrity: fix a BUG if we shrink the device
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
Cc: dm-devel@redhat.com, Daniel Zatovic <dzatovic@redhat.com>,
 gmazyland@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patch f6f72f32c22c ("dm integrity: don't replay journal data past the
end of the device") skips journal replay if the target sector points
beyond the end of the device. Unfortunatelly, it doesn't set the journal
entry unused, which resulted in this BUG being triggered:
BUG_ON(!journal_entry_is_unused(je))

This patch fixes the crash.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: f6f72f32c22c ("dm integrity: don't replay journal data past the end of the device")
Cc: stable@vger.kernel.org	# v5.7+

---
 drivers/md/dm-integrity.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-dm/drivers/md/dm-integrity.c
===================================================================
--- linux-dm.orig/drivers/md/dm-integrity.c	2022-02-10 18:16:42.000000000 +0100
+++ linux-dm/drivers/md/dm-integrity.c	2022-03-25 18:20:27.000000000 +0100
@@ -2473,9 +2473,11 @@ static void do_journal_write(struct dm_i
 					dm_integrity_io_error(ic, "invalid sector in journal", -EIO);
 					sec &= ~(sector_t)(ic->sectors_per_block - 1);
 				}
+				if (unlikely(sec >= ic->provided_data_sectors)) {
+					journal_entry_set_unused(je);
+					continue;
+				}
 			}
-			if (unlikely(sec >= ic->provided_data_sectors))
-				continue;
 			get_area_and_offset(ic, sec, &area, &offset);
 			restore_last_bytes(ic, access_journal_data(ic, i, j), je);
 			for (k = j + 1; k < ic->journal_section_entries; k++) {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

