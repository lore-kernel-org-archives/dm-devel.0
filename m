Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34380C433E6
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:33:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3C8F64EC3
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:33:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3C8F64EC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614148426;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Vq5ULADlEZ4nnwj2Pjd75/uPeko91hvprCla0voeY4s=;
	b=gt0f4NdCBGtsTLK6UOWoMwPzwhDZ+IfpPJytA0zGh98bxmjv9VVNsAv2rMF63BD5oiCkiU
	FqXJmDLM6mPD4K7IQkg66uEBiJw+L2+jPm4P20UglER+P9AyI0whJBJWKnlGZNEjjuGQFE
	WZHaH7HfGhMjsJOLoOF8pgSU72ReROE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-WMS5lrVjMxOVd3adUJeVJQ-1; Wed, 24 Feb 2021 01:33:41 -0500
X-MC-Unique: WMS5lrVjMxOVd3adUJeVJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE29B64A93;
	Wed, 24 Feb 2021 06:33:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 69CB65D9D0;
	Wed, 24 Feb 2021 06:33:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0E11318095CB;
	Wed, 24 Feb 2021 06:33:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O6XYLN029055 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 01:33:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0BD835D6A1; Wed, 24 Feb 2021 06:33:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C26B6362B;
	Wed, 24 Feb 2021 06:33:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 11O6XSVe019889; 
	Wed, 24 Feb 2021 00:33:28 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 11O6XRvf019888;
	Wed, 24 Feb 2021 00:33:27 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 Feb 2021 00:33:20 -0600
Message-Id: <1614148402-19847-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
References: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Chongyun Wu <wucy11@chinatelecom.cn>, Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/3] libmultipath: cleanup code to strip wwid
	trailing spaces
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

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 9be94cd1..3a06f319 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2152,11 +2152,11 @@ int
 get_uid (struct path * pp, int path_state, struct udev_device *udev,
 	 int allow_fallback)
 {
-	char *c;
 	const char *origin = "unknown";
 	ssize_t len = 0;
 	struct config *conf;
 	int used_fallback = 0;
+	size_t i;
 
 	if (!pp->uid_attribute && !pp->getuid) {
 		conf = get_multipath_config();
@@ -2210,12 +2210,9 @@ get_uid (struct path * pp, int path_state, struct udev_device *udev,
 		return 1;
 	} else {
 		/* Strip any trailing blanks */
-		c = strchr(pp->wwid, '\0');
-		c--;
-		while (c && c >= pp->wwid && *c == ' ') {
-			*c = '\0';
-			c--;
-		}
+		for (i = strlen(pp->wwid); i > 0 && pp->wwid[i-1] == ' '; i--);
+			/* no-op */
+		pp->wwid[i] = '\0';
 	}
 	condlog((used_fallback)? 1 : 3, "%s: uid = %s (%s)", pp->dev,
 		*pp->wwid == '\0' ? "<empty>" : pp->wwid, origin);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

