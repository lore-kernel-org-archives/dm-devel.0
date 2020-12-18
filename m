Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6172C4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:07:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4FFC423BA7
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FFC423BA7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608332821;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6gCf1jeho2wBK5S+pKGfqMrXcf22giFG5F5jGcpY8yo=;
	b=O2dLMq4eHHZy2N0L8BL/Q3mgn0eFbdFzdmxR622+qcgrJVj0m/DdNnAo0Ma8cPcyRYtcPu
	XTF+Xq4XEJJ/IcFPtQb41fo/ecrJu1l0qJUa/YkGHHpBkfvFjJI/ofbc1xMtxNsfolPLo3
	vOLRoDpgWV27ZUPKzWWGBTPI2zIhZyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-RLyjnyiVM4ex6PMRYYvCcg-1; Fri, 18 Dec 2020 18:06:59 -0500
X-MC-Unique: RLyjnyiVM4ex6PMRYYvCcg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 301FC15727;
	Fri, 18 Dec 2020 23:06:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1072D10016FF;
	Fri, 18 Dec 2020 23:06:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DB1EA4BB7B;
	Fri, 18 Dec 2020 23:06:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIN6oYo026977 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:06:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AAFBF5C1C5; Fri, 18 Dec 2020 23:06:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 315DD5C233;
	Fri, 18 Dec 2020 23:06:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BIN6jAV009770; 
	Fri, 18 Dec 2020 17:06:46 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BIN6jBf009769;
	Fri, 18 Dec 2020 17:06:45 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 18 Dec 2020 17:06:39 -0600
Message-Id: <1608332802-9720-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 3/6] libmultipath: warn about missing braces at
	end of multipath.conf
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Multipath doesn't warn when multipath.conf is missing closing braces at
the end of the file. This has confused people about the correct config
file syntax, so add a warning.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/parser.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 163ffbc9..c70243c3 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -537,7 +537,7 @@ process_stream(struct config *conf, FILE *stream, vector keywords,
 		if (!strcmp(str, EOB)) {
 			if (kw_level > 0) {
 				free_strvec(strvec);
-				break;
+				goto out;
 			}
 			condlog(0, "unmatched '%s' at line %d of %s",
 				EOB, line_nr, file);
@@ -576,7 +576,8 @@ process_stream(struct config *conf, FILE *stream, vector keywords,
 
 		free_strvec(strvec);
 	}
-
+	if (kw_level == 1)
+		condlog(1, "missing '%s' at end of %s", EOB, file);
 out:
 	FREE(buf);
 	free_uniques(uniques);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

