Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BBAC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 01:29:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DB3F6135F
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 01:29:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DB3F6135F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-WreppMarO4eYYw4s7_opiA-1; Tue, 18 May 2021 21:29:30 -0400
X-MC-Unique: WreppMarO4eYYw4s7_opiA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C312B180FD63;
	Wed, 19 May 2021 01:29:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 542C85C1A1;
	Wed, 19 May 2021 01:29:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D4BE712E86;
	Wed, 19 May 2021 01:29:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J1QObp022100 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 May 2021 21:26:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 93D3E2015D0B; Wed, 19 May 2021 01:26:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8F76B20149DF
	for <dm-devel@redhat.com>; Wed, 19 May 2021 01:26:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F721101A531
	for <dm-devel@redhat.com>; Wed, 19 May 2021 01:26:22 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-24-7jAOSmpOP3GbzjVChEOwwQ-1; Tue, 18 May 2021 21:26:18 -0400
X-MC-Unique: 7jAOSmpOP3GbzjVChEOwwQ-1
IronPort-SDR: WkCG2JN7MvpfKlgDSJtDOfFMiIUlT3Tz8F5+pTvGJAPsSZH1JX5T9IXnyV2DptFfRN9ltssdXX
	DgZYDlKV17tO1J+R07x5YnMw8syO8NZDHbPY9x5aWdG66GS+XJ76jCUzHQgs9qRcSasF/lD2KK
	LnWjKvaSD9rFNndIOBfFSRXvia2QSrI9JIYgclkpG3xBqRPjk0xxRIqc8tuaUraY02tdm6cJXT
	1sTO1B2qtKypgAiUOSWzVt0aFAJecAdRX9SdUi7q6KXuRh7U9Sw2kaAygSWzmf4oh5O/2ef2Ot
	h68=
X-IronPort-AV: E=Sophos;i="5.82,310,1613404800"; d="scan'208";a="272584515"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 09:26:37 +0800
IronPort-SDR: P2VTeaU1JvbM//y7sszRt8871bPRpvX9W/Cf7nJJj97TTcA8mtC479P5PFnk/8JwB+XTNK7PJ9
	RRPFlvPO45Sl0W6koYRiKJx0DWNzrD19oBq7Cl7e4ug0ljLN2eFgLz2oulLl/siBOX9WGQd3oI
	zqoyIDpvalme+7OmzyRHLt0GwdVhD++7TPZ1BQJBzw6iUd0m7RHRbOx6W1SAr/FdtiJ53NCWa9
	jV09EKCFiKfaQLvPmLt51VvZeMMRXIUPk+Ls4aI1l6FIVEBrn973euC+t6/nGEkYP+d2YN1JuI
	jxtpQH6uDaBaniu0Mny06wiI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 May 2021 18:05:56 -0700
IronPort-SDR: 0NDDhGziN9iPfphmYSLgotPhPUX6pCHPaBnMWhszhi3kdrkya0MmtiKJiAovUZ/tfGPEyt3/dW
	B3POu8ilsMAL2gKWN1eDlkQAYVDxknnDoopeQt6Ufx56/Ey5DbM8qXGXCL+71Ay2qxu84Xdoqg
	piYsPwbItrK2SwjTwiwBbA52j0qMKqQije5jFXzphFXfRNg8lBKZIulRzEgIipSuBC92l6Wqvn
	riEXpsYwi59ry5RTEEJxjIB2r+1YXk6d3SSIE3IDqf9LQ0xYqGGru2NzmZwfg/50bqTBXJtjEm
	EEg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 May 2021 18:26:15 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Date: Wed, 19 May 2021 10:26:16 +0900
Message-Id: <20210519012616.664047-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm zoned: check zone capacity
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The dm-zoned target cannot support zoned block devices with zones that
have a capacity smaller than the zone size (e.g. NVMe zoned namespaces)
due to the current chunk zone mapping implementation as it is assumed
that zones and chunks have the same size with all blocks usable.
If a zoned drive is found to have zones with a capacity different from
the zone size, fail the target initialization.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 039d17b28938..ee4626d08557 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1390,6 +1390,13 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
 		return -ENXIO;
 	}
 
+	/*
+	 * Devices that have zones with a capacity smaller than the zone size
+	 * (e.g. NVMe zoned namespaces) are not supported.
+	 */
+	if (blkz->capacity != blkz->len)
+		return -ENXIO;
+
 	switch (blkz->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
 		set_bit(DMZ_RND, &zone->flags);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

