Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAACC3526C
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:07:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BA70123BA7
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 23:07:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA70123BA7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608332838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=DO8r2QZgP62uuFbTJA/dPvfFxRGzb8ltqQGVyC6gQMM=;
	b=HwU6Tt78GgzF3WUkzeQxKefulmOwMBYI2ARsE4UciDLCkK9RPsKHByb698HQoONuFvtgm1
	mFZeESzhdueu+N8JMFcyVuMB6oPQppz9x4yTbSi3roQrehBf5ibFPx06BRDfXI6ceCvhRZ
	5GJ2wpkMcQBdxugANX2iu/PrfQBj4nk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-tmrMboMuMt-twV6JyDSDag-1; Fri, 18 Dec 2020 18:07:06 -0500
X-MC-Unique: tmrMboMuMt-twV6JyDSDag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EA3F801817;
	Fri, 18 Dec 2020 23:07:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F7BF2C161;
	Fri, 18 Dec 2020 23:07:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1943E5002C;
	Fri, 18 Dec 2020 23:07:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIN6r0j027004 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 18:06:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6074B60C61; Fri, 18 Dec 2020 23:06:53 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0572660C47;
	Fri, 18 Dec 2020 23:06:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BIN6mWK009782; 
	Fri, 18 Dec 2020 17:06:48 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BIN6mwn009781;
	Fri, 18 Dec 2020 17:06:48 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Fri, 18 Dec 2020 17:06:42 -0600
Message-Id: <1608332802-9720-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
References: <1608332802-9720-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 6/6] multipath.conf.5: Improve checker_timeout
	description
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

I was asked to explain how checker_timeout works for checkers like
directio, that don't issue scsi commands with an explicit timeout

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index ea66a01e..c7c4184b 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -639,8 +639,13 @@ The default is: \fBno\fR
 .
 .TP
 .B checker_timeout
-Specify the timeout to use for path checkers and prioritizers that issue SCSI
-commands with an explicit timeout, in seconds.
+Specify the timeout to use for path checkers and prioritizers, in seconds.
+Only prioritizers that issue scsi commands use checker_timeout. Checkers
+that support an asynchronous mode (\fItur\fR and \fIdirectio\fR), will
+return shortly after being called by multipathd, regardless of whether the
+storage array responds. If the storage array hasn't responded, mulitpathd will
+check for a response every second, until \fIchecker_timeout\fR seconds have
+elapsed.
 .RS
 .TP
 The default is: in \fB/sys/block/sd<x>/device/timeout\fR
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

