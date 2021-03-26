Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC35C433C1
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 00:55:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4839D61A1D
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 00:55:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4839D61A1D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616720106;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kGNFVpvio4E8T2sXZ19vliwQO9Fae6xRQqmVS0w5G8I=;
	b=U8Uov9yJuzK+CdWxwSCkN9fEnFV+AS43czyeZ7+ryXMd25LvuILBOAbXK5GkdxUZQFwVNe
	+M9hdJJEKkbSitPa+1AEp+3QBBXEGT1vfZLNP6xk3XkAtnLYzY5rJOfoflo12NxN0S84rI
	WlH/cjNKGaHRz+prc35BC01B3f3xfRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-JvcfiSbHM1CM64tgGkT2Ng-1; Thu, 25 Mar 2021 20:55:03 -0400
X-MC-Unique: JvcfiSbHM1CM64tgGkT2Ng-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F92110AF380;
	Fri, 26 Mar 2021 00:54:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6992F6E520;
	Fri, 26 Mar 2021 00:54:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 712E01809C83;
	Fri, 26 Mar 2021 00:54:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12Q0qrMv019153 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 20:52:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E05C71394F; Fri, 26 Mar 2021 00:52:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 407F55D9DE;
	Fri, 26 Mar 2021 00:52:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12Q0qmvg010267; 
	Thu, 25 Mar 2021 19:52:49 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12Q0qmkm010266;
	Thu, 25 Mar 2021 19:52:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 25 Mar 2021 19:52:44 -0500
Message-Id: <1616719966-10221-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 2/4] libmultipath: fix priorities in
	parse_vpd_pg83
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The priorities for the EUI-64 (0x02) and NAME (0x08) scsi identifiers in
parse_vpd_pg83() don't match their priorities in 55-scsi-sg3_id.rules.
Switch them so that they match.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 5727f7a6..f8044141 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1152,19 +1152,19 @@ parse_vpd_pg83(const unsigned char *in, size_t in_len,
 				vpd = d;
 			}
 			break;
-		case 0x8:
-			/* SCSI Name: Prio 4 */
-			if (memcmp(d + 4, "eui.", 4) &&
-			    memcmp(d + 4, "naa.", 4) &&
-			    memcmp(d + 4, "iqn.", 4))
-				break;
+		case 0x2:
+			/* EUI-64: Prio 4 */
 			if (prio < 4) {
 				prio = 4;
 				vpd = d;
 			}
 			break;
-		case 0x2:
-			/* EUI-64: Prio 3 */
+		case 0x8:
+			/* SCSI Name: Prio 3 */
+			if (memcmp(d + 4, "eui.", 4) &&
+			    memcmp(d + 4, "naa.", 4) &&
+			    memcmp(d + 4, "iqn.", 4))
+				break;
 			if (prio < 3) {
 				prio = 3;
 				vpd = d;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

