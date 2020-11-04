Return-Path: <SRS0=DU+z=EK=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74D59C388F9
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:00:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CC65E2225B
	for <dm-devel@archiver.kernel.org>; Wed,  4 Nov 2020 07:00:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rp1Z5otI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC65E2225B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604473241;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UjK4PUluibxzUskhca9s2E7bsuXY0ZfRYhqqT1QkvZU=;
	b=Rp1Z5otI+1l1WvB+1yCp6UeWGLSUuKQ9N33dCVAQe+zO8e8SyZwLd/Ri5atFJFI2v2VE8l
	0qyrTPYMZIXmv/Dfbp+w+jI6CwG5sTvX3lxx9h01Bm6qYpOLrrMnWhnBvZrUomyKqXNvvZ
	9ZiMBRhEemLEk/ikBKWfhsddEzWbMmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-v34JC7K4MVOppDhkxzeIKQ-1; Wed, 04 Nov 2020 02:00:39 -0500
X-MC-Unique: v34JC7K4MVOppDhkxzeIKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BECC9186DD24;
	Wed,  4 Nov 2020 07:00:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 996E821E78;
	Wed,  4 Nov 2020 07:00:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 65ED618199F6;
	Wed,  4 Nov 2020 07:00:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A46sJpD017322 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 4 Nov 2020 01:54:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3B4941002D61; Wed,  4 Nov 2020 06:54:19 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D3CC10589A0;
	Wed,  4 Nov 2020 06:54:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A46sEoi022472; 
	Wed, 4 Nov 2020 00:54:14 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A46sE37022471;
	Wed, 4 Nov 2020 00:54:14 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  4 Nov 2020 00:54:06 -0600
Message-Id: <1604472849-22422-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 3/6] multipathd: remove redundant
	vector_free() int configure
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

remove_maps(vecs) already calls vector_free(vecs->mpvec)

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 0cf8a264..e114bab7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2634,14 +2634,10 @@ configure (struct vectors * vecs)
 	}
 
 	/*
-	 * purge dm of old maps
+	 * purge dm of old maps and save new set of maps formed by
+	 * considering current path state
 	 */
 	remove_maps(vecs);
-
-	/*
-	 * save new set of maps formed by considering current path state
-	 */
-	vector_free(vecs->mpvec);
 	vecs->mpvec = mpvec;
 
 	/*
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

