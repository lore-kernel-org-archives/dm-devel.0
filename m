Return-Path: <SRS0=a9Kz=KO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 461BFC433ED
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 02:58:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D602D6124C
	for <dm-devel@archiver.kernel.org>; Wed, 19 May 2021 02:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D602D6124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-zBayyJo4M-6pEfSqICisvw-1; Tue, 18 May 2021 22:58:34 -0400
X-MC-Unique: zBayyJo4M-6pEfSqICisvw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D82C501FC;
	Wed, 19 May 2021 02:58:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DC6510027A5;
	Wed, 19 May 2021 02:58:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1BE4A55355;
	Wed, 19 May 2021 02:58:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14J2te11029478 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 May 2021 22:55:41 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D55A421D0DB0; Wed, 19 May 2021 02:55:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFF7921D0DAD
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:38 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7273858F0D
	for <dm-devel@redhat.com>; Wed, 19 May 2021 02:55:38 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-472-oiFj1n7yOL6CR5_0vDGrcQ-3; Tue, 18 May 2021 22:55:34 -0400
X-MC-Unique: oiFj1n7yOL6CR5_0vDGrcQ-3
IronPort-SDR: F2tubQqmzgLW8cna7rW6aptUJYmdKeddrBf5Bvh8iAiZVIpBm/cwBqD79msh5baWfbY8FvjAfD
	il48QVcg5mQ6zwMkGkLx+fbpdIBpcudC8j2rHf8KU7kq0zP8XWKVuqESIKJY2KntutHNiKu0js
	5qrNwi+zmrAFwZVhruUASXktCdhTD/4JvPh39hiTtbtqsbBIiF8v+gdC1zFVIJle2Mv2GMLxvn
	UsIx1cU/H/+LdxMG5lSj0YC95ZZY5RR0EEKiQwE9A80gmj4xvi+/UOO6BsQ/F/Nta1U3X1uKwq
	CA4=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; d="scan'208";a="169197418"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
	([199.255.45.15])
	by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 10:55:34 +0800
IronPort-SDR: uVE+eiESJryeaEP3KaziOafyLl2CxNkp0aWXJBcTBC6uK2vQJ5Z0qE0eDykGBqoQiti2yfmohE
	FCPBYNpfFlsPfKECxHN/3HgO6R3YV8gXzu88umGFa1xnTDG/X3Tr1+4e2gCq0ZC9zHxZ0jOkwT
	ITu7OL5Qr61Z9e+qBUzTX6C9QmPcvxNtCIrMo5/EyTW2R5oN4T8ix0aW4IDw8MF3i2K+ohRA9B
	63kQCr4vvOagyK3gfNbEjnrX4k9aJXBDe0QuAqChw8XrPfSLQfBu5r2lzoDPmzb0q2NdWUyuE+
	2Jak1kv6dHYkWMZ9XKkfu12l
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	18 May 2021 19:33:59 -0700
IronPort-SDR: 9QM6sLf0b8XHcEBsjPanwKimxiG2FUfJgW45SQ+uT3Hcy6oXqx8Yf5xX761X7A2hSpq7ffIQn/
	XcAU0a0dQ16bebCHFZ4/elLaf+MVv2pexH+fqiNzaGIMKLWI9gyQu+E3jKDrSXgOfz8hVUaQ7B
	aG0Q1DoK+WauGjOU3e/hbGU3ZLnJ2go+XYuauwt0wAIJXLyoa2of0OeiNnwkp6gFFKnZhmzHSZ
	Tun2aj9/fC2iqEC0fmt+AAa2HK0mcMZ3qiN2e7hSGw6HEc3RlDYYpYYPlR5/EUqhMyWCPv50MC
	qzw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
	by uls-op-cesaip02.wdc.com with ESMTP; 18 May 2021 19:55:33 -0700
From: Damien Le Moal <damien.lemoal@wdc.com>
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
	linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Date: Wed, 19 May 2021 11:55:21 +0900
Message-Id: <20210519025529.707897-4-damien.lemoal@wdc.com>
In-Reply-To: <20210519025529.707897-1-damien.lemoal@wdc.com>
References: <20210519025529.707897-1-damien.lemoal@wdc.com>
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
Subject: [dm-devel] [PATCH 03/11] block: introduce BIO_ZONE_WRITE_LOCKED bio
	flag
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Introduce the BIO flag BIO_ZONE_WRITE_LOCKED to indicate that a BIO owns
the write lock of the zone it is targeting. This is the counterpart of
the struct request flag RQF_ZONE_WRITE_LOCKED. This new BIO flag is
reserved for now for zone write locking control for device mapper
targets exposing a zoned block device.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 include/linux/blk_types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index db026b6ec15a..e5cf12f102a2 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -304,6 +304,7 @@ enum {
 	BIO_CGROUP_ACCT,	/* has been accounted to a cgroup */
 	BIO_TRACKED,		/* set if bio goes through the rq_qos path */
 	BIO_REMAPPED,
+	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
 	BIO_FLAG_LAST
 };
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

