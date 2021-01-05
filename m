Return-Path: <SRS0=jKmk=GI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE76C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 04:00:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DBD122583
	for <dm-devel@archiver.kernel.org>; Tue,  5 Jan 2021 04:00:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DBD122583
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609819235;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=l1C3XIGgenAJXnDsgeoQneGZpWbKaFRw+QbHK7uggN0=;
	b=iKWdA8Cjqxyfp4w7K/0KA9ZQQ+lQPcwqa7amXLPSBNiDUVyySlTlYkswd5MD+tfpB7s0wA
	QESd2Ky231ZWiCZ0QYiZnwMxFKHU7DrswLWWK1pZS89WGmLrbJTWN3qe2uBwwAAKY1l+3k
	KtQEgo9Rt+CHX5HzqYOdN6Mkw1ZYgCk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-xt-8cwUsN76XZb_LTV0gQg-1; Mon, 04 Jan 2021 23:00:32 -0500
X-MC-Unique: xt-8cwUsN76XZb_LTV0gQg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D53D59;
	Tue,  5 Jan 2021 04:00:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E360C1002382;
	Tue,  5 Jan 2021 04:00:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 734CB4BB7B;
	Tue,  5 Jan 2021 04:00:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1054029Y008472 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 4 Jan 2021 23:00:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7FD5F1A7D9; Tue,  5 Jan 2021 04:00:02 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EBBD19D9C;
	Tue,  5 Jan 2021 03:59:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1053xvfV018348; 
	Mon, 4 Jan 2021 21:59:57 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1053xv86018347;
	Mon, 4 Jan 2021 21:59:57 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  4 Jan 2021 21:59:54 -0600
Message-Id: <1609819195-18306-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1609819195-18306-1-git-send-email-bmarzins@redhat.com>
References: <1609819195-18306-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 1/2] libmultipath: check for null wwid before
	strcmp
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

Commit 749aabd0 (libmultipath: ignore multipaths sections without wwid
option) removed all mpentries with a NULL wwid, but didn't stop strcmp()
from being run on them in merge_mptable(). The result of strcmp() with
a NULL parameter is undefined, so fix that.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/config.c b/libmultipath/config.c
index a643703e..be310159 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -518,7 +518,7 @@ void merge_mptable(vector mptable)
 		}
 		j = i + 1;
 		vector_foreach_slot_after(mptable, mp2, j) {
-			if (strcmp(mp1->wwid, mp2->wwid))
+			if (!mp2->wwid || strcmp(mp1->wwid, mp2->wwid))
 				continue;
 			condlog(1, "%s: duplicate multipath config section for %s",
 				__func__, mp1->wwid);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

