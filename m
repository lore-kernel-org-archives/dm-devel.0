Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499CFC433B4
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 17:24:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E567A61421
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 17:24:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E567A61421
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1620926651;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=L26z0X7mibby2s+FYZiCHw5sZkbAFMq4ypbAetjD07M=;
	b=eaChKO4hU5FXIdi9ip88ml96M1TsSwwgwkEqgdgPADXUsJMGkT14tsGKVD9Plo6SdJ7oLs
	ywbYCf+czf3tTlGaKq7O78fO3Gin5soFhpdckDTceKTRwYEJNSWvKjQUWcrIqhb+icqCJr
	LxxmdTU52xSqn0ufnHbEKsEH0DGKXII=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-agbU_y1yMyutOzbdtx8-Pw-1; Thu, 13 May 2021 13:24:08 -0400
X-MC-Unique: agbU_y1yMyutOzbdtx8-Pw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0FE6FCB4;
	Thu, 13 May 2021 17:23:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A38265D9DC;
	Thu, 13 May 2021 17:23:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7B8B0180B464;
	Thu, 13 May 2021 17:23:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DHNOs6005663 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 13:23:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id ABC035D9FC; Thu, 13 May 2021 17:23:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 93F945D9DC;
	Thu, 13 May 2021 17:23:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 14DHNNSH012087; 
	Thu, 13 May 2021 12:23:23 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 14DHNMB3012086;
	Thu, 13 May 2021 12:23:22 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 13 May 2021 12:23:14 -0500
Message-Id: <1620926595-12029-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
References: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 5/6] kpartx: Don't leak memory when getblock
	returns NULL
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If a new block was allocated, but couldn't be filled, getblock will
discard it. When it does so, it needs to free the block to avoid leaking
memory. Found by coverity.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 kpartx/kpartx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 8ff116b8..7bc64543 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -766,6 +766,8 @@ getblock (int fd, unsigned int blknr) {
 	if (read(fd, bp->block, secsz) != secsz) {
 		fprintf(stderr, "read error, sector %d\n", secnr);
 		blockhead = bp->next;
+		free(bp->block);
+		free(bp);
 		return NULL;
 	}
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

