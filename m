Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B05C433E0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 11:42:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8CD6D60202
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 11:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8CD6D60202
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614080535;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iRf9ZvoL3sfn6vnM+CJpwen9W/fEGYlv+UxSVyFA/Tw=;
	b=TSA8m1ZTAygBdpfCkYdt3Y+3pdJgOedWJetYIFeRmavIzh2n/S4c2d3+u89hfWD/ipPPoU
	CJRwfaqDKKD5MSJNN01pfAdtWkmLmAIBAFXixh52bwbYft7XrMOzySjDpi0S3e6/FFWQs6
	BlDoL9NwEnU+1MKqHu88j4HWIKngDR4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-QKZfJExPMy2MHO4aI_NKWA-1; Tue, 23 Feb 2021 06:42:13 -0500
X-MC-Unique: QKZfJExPMy2MHO4aI_NKWA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12ED9193578B;
	Tue, 23 Feb 2021 11:42:09 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B65CA6F131;
	Tue, 23 Feb 2021 11:42:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4DC5C18095CB;
	Tue, 23 Feb 2021 11:42:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11NBg4I3002847 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 06:42:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1CD7760C43; Tue, 23 Feb 2021 11:42:04 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DDCF60C04;
	Tue, 23 Feb 2021 11:42:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 11NBg0M4029446; Tue, 23 Feb 2021 06:42:00 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 11NBg0HT029442; Tue, 23 Feb 2021 06:42:00 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Tue, 23 Feb 2021 06:42:00 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Milan Broz <mbroz@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2102230640450.21326@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm-bufio: subtract the number of initial sectors
 in dm_bufio_get_device_size
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_bufio_get_device_size returns returns the device size in blocks. Before
returning the value, we must subtract the nubmer of starting sectors. The
number of starting sectos may not be divisible by block size.

Note that currently, no target is using dm_bufio_set_sector_offset and
dm_bufio_get_device_size simultaneously, so this patch has no effect.
However, an upcoming patch that fixes dm-verity-fec needs this change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-bufio.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2021-01-22 17:28:39.000000000 +0100
+++ linux-2.6/drivers/md/dm-bufio.c	2021-02-23 12:35:16.000000000 +0100
@@ -1526,6 +1526,10 @@ EXPORT_SYMBOL_GPL(dm_bufio_get_block_siz
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 {
 	sector_t s = i_size_read(c->bdev->bd_inode) >> SECTOR_SHIFT;
+	if (s >= c->start)
+		s -= c->start;
+	else
+		s = 0;
 	if (likely(c->sectors_per_block_bits >= 0))
 		s >>= c->sectors_per_block_bits;
 	else

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

