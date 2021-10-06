Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E297C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:04:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8B496610CC
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:04:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8B496610CC
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633550679;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JM4XgRlU1kuCmb14kcvGS0UkM2W3ml7h0i4jrs3Iyo4=;
	b=OdaBP4vwjDxSZjkXkz/hN/H2hT/D60xXF3cTrXwb0/8kRlbH/NSCryYxmBo0BXa773ENBO
	rjSv+COfR4uWtLy9F7sYcCIAxLmWDYMfU1TBzoR1tZm+WONhlMZH062H9Kbxx6F4cBA+0O
	tKmZxNF3G/E78dl6+QYcpCnN4HAN80Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-137-dG_FcBlNO4GBWJoaCDGYdw-1; Wed, 06 Oct 2021 16:04:37 -0400
X-MC-Unique: dG_FcBlNO4GBWJoaCDGYdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13A365074B;
	Wed,  6 Oct 2021 20:04:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B4EA119D9F;
	Wed,  6 Oct 2021 20:04:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 56E644EA2A;
	Wed,  6 Oct 2021 20:04:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196K4U8k020051 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 16:04:30 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 99E7A19D9F; Wed,  6 Oct 2021 20:04:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F3DA17001;
	Wed,  6 Oct 2021 20:04:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 196K4SFw025621; 
	Wed, 6 Oct 2021 15:04:29 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 196K4SGg025620;
	Wed, 6 Oct 2021 15:04:28 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  6 Oct 2021 15:04:18 -0500
Message-Id: <1633550663-25571-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 3/8] libmultipath: print the correct file when
	parsing fails
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Don't assume that parsing failed on multipath.conf

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/parser.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index ebe1cbd9..d5595fb0 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -561,8 +561,8 @@ process_stream(struct config *conf, FILE *stream, vector keywords,
 				    t = keyword->handler(conf, strvec);
 					r += t;
 					if (t)
-						condlog(1, "multipath.conf +%d, parsing failed: %s",
-							line_nr, buf);
+						condlog(1, "%s line %d, parsing failed: %s",
+							file, line_nr, buf);
 				}
 
 				if (keyword->sub) {
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

