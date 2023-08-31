Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2D32C83F2F
	for <dm-devel@archiver.kernel.org>; Thu, 31 Aug 2023 21:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693519083;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4MB6SWJfp8sh94p7B1jbcjYnxt2kBSp9KrHukbOojDI=;
	b=Xvs3anlcGZdyXIjHzh+ouk4DaYKNOeIF5Jv9H3oxcUO35tNqbFTjtwnDHHuAM5cJ1WXrAA
	4huv0BuYSE7ldVRzI16D3xEW9JWGL429Tux5JrJ6HG59V+AhG5binOKQnkskLDHkiO5F6i
	dkBAZ5Ho1KVnxerBFvXKl5tVx9hEfm0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-319-4GLO5kswMHeZUZY1WKIPtQ-1; Thu, 31 Aug 2023 17:57:29 -0400
X-MC-Unique: 4GLO5kswMHeZUZY1WKIPtQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 57EFF101AA65;
	Thu, 31 Aug 2023 21:57:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 67BFD63F78;
	Thu, 31 Aug 2023 21:57:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 36FBF194658F;
	Thu, 31 Aug 2023 21:57:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CF67D1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Aug 2023 21:57:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BD4012026D38; Thu, 31 Aug 2023 21:57:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A59892026D35;
 Thu, 31 Aug 2023 21:57:22 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 37VLvEwp030155;
 Thu, 31 Aug 2023 16:57:14 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 37VLvERZ030154;
 Thu, 31 Aug 2023 16:57:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 31 Aug 2023 16:57:09 -0500
Message-Id: <1693519032-30111-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
References: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 1/4] libmultipath: don't bother to recheck
 timeout
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This is almost always pointless work. c->timeout has already been set.
The only reason why this recheck existed was to deal with the
possibility that the sysfs value had changed.  It is unlikely that users
will update the sysfs value to change the multipath timeout while
multipathd is running. They can alway reload multipathd if they want
it changed, anyways.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/discovery.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 5626d48d..c90c51a6 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -1965,9 +1965,6 @@ get_state (struct path * pp, struct config *conf, int daemon, int oldstate)
 		checker_set_async(c);
 	else
 		checker_set_sync(c);
-	if (!conf->checker_timeout &&
-	    sysfs_get_timeout(pp, &(c->timeout)) <= 0)
-		c->timeout = DEF_TIMEOUT;
 	state = checker_check(c, oldstate);
 	condlog(3, "%s: %s state = %s", pp->dev,
 		checker_name(c), checker_state_name(state));
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

