Return-Path: <SRS0=SKY2=EP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8AF0C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon,  9 Nov 2020 23:13:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E23EC206ED
	for <dm-devel@archiver.kernel.org>; Mon,  9 Nov 2020 23:13:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btUhDsHl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E23EC206ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1604963580;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zh+5hIIzTM0AvP62C6fRm67YyTpJbiRsRr8rYXBqQaQ=;
	b=btUhDsHlWecSU1XLmSegurU7bgchP20/xJi2y+k2wIdHFzUBJd+tluEPP8cLpyb+o9FP4B
	s4B0/79bonvA3AB5eCeqQjWULTIWg7YNnVesqrUWprDxEtYGMeRaWRDKDLQf9j7y24LBjs
	xxH1JYVFY4upuaQtAZh0vObtrqXeeTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-8zG2wNo_NrSlRSzxcGILuw-1; Mon, 09 Nov 2020 18:12:58 -0500
X-MC-Unique: 8zG2wNo_NrSlRSzxcGILuw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E177E809DDC;
	Mon,  9 Nov 2020 23:12:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92CDC27BA3;
	Mon,  9 Nov 2020 23:12:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7C59F180C5A2;
	Mon,  9 Nov 2020 23:12:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A9NCl0B001835 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 9 Nov 2020 18:12:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EF7805C5B0; Mon,  9 Nov 2020 23:12:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B8ED25C1DA;
	Mon,  9 Nov 2020 23:12:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0A9NChC9031945; 
	Mon, 9 Nov 2020 17:12:43 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0A9NCgxn031944;
	Mon, 9 Nov 2020 17:12:42 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  9 Nov 2020 17:12:42 -0600
Message-Id: <1604963562-31905-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH] mpathpersist: Fix Register and Ignore with 0x00
	SARK
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

When the Register and Ignore command is run with sg_persist, if a 0x00
Service Action Reservation Key is given or the --param-sark option is
not used at all, sg_persist will clear the registration.  mpathpersist
will fail with an error.  This patch fixes mpathpersist to work like
sg_persist in this case.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 79322e86..703f8e13 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -289,8 +289,8 @@ int __mpath_persistent_reserve_out ( int fd, int rq_servact, int rq_scope,
 	put_multipath_config(conf);
 
 	memcpy(&prkey, paramp->sa_key, 8);
-	if (mpp->prkey_source == PRKEY_SOURCE_FILE && prkey &&
-	    ((!get_be64(mpp->reservation_key) &&
+	if (mpp->prkey_source == PRKEY_SOURCE_FILE &&
+	    ((!get_be64(mpp->reservation_key) && prkey &&
 	      rq_servact == MPATH_PROUT_REG_SA) ||
 	     rq_servact == MPATH_PROUT_REG_IGN_SA)) {
 		memcpy(&mpp->reservation_key, paramp->sa_key, 8);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

