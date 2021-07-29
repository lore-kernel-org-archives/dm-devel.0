Return-Path: <SRS0=hAiq=MV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEFEBC432BE
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 21:47:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7725960F23
	for <dm-devel@archiver.kernel.org>; Thu, 29 Jul 2021 21:47:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7725960F23
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627595231;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ms/jhByRUUvx4VsQ2UbH1uZDqScB/pmeR/yQ8MsxEzU=;
	b=UEfexoKpPzLr1xJyZs9ofH2eJByDcjHWnNE9TXarlgQUZ05y33aUp9EQGi7C275+9bUgNI
	HAHmIkhu7s9r2GQa4+8zzCkET1wBD9QboY4GCJPikdB2hI57lfWQD2Fc1veea3yFRF+fwO
	SnZ89GQgZILq9hE3g5QdPswMBFpdAW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-F4Z7Q6nQN-aagtnz_Q1WuQ-1; Thu, 29 Jul 2021 17:47:09 -0400
X-MC-Unique: F4Z7Q6nQN-aagtnz_Q1WuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6BA8B190B2A0;
	Thu, 29 Jul 2021 21:47:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04C711A26A;
	Thu, 29 Jul 2021 21:47:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 386FA180BAB1;
	Thu, 29 Jul 2021 21:47:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16TLkFcZ030914 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Jul 2021 17:46:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C2C731A26A; Thu, 29 Jul 2021 21:46:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB1E64A66;
	Thu, 29 Jul 2021 21:46:15 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 16TLkELC020038; 
	Thu, 29 Jul 2021 16:46:14 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 16TLkDce020037;
	Thu, 29 Jul 2021 16:46:13 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 29 Jul 2021 16:46:05 -0500
Message-Id: <1627595165-19980-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1627595165-19980-1-git-send-email-bmarzins@redhat.com>
References: <1627595165-19980-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 5/5] libmultipath: deal with dynamic
	PTHREAD_STACK_MIN
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

Starting in glibc-2.34 (commit 5d98a7da), PTHREAD_STACK_MIN is defined
as sysconf(_SC_THREAD_STACK_MIN) if _GNU_SOURCE is defined. sysconf()
returns a long and can, at least in theory, return -1.  This change
causes compilation to fail in setup_thread_attr() due to a comparision
with different signedness, since stacksize is a size_t.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index e2fafe85..ea858409 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -223,8 +223,8 @@ setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
 
 	ret = pthread_attr_init(attr);
 	assert(ret == 0);
-	if (stacksize < PTHREAD_STACK_MIN)
-		stacksize = PTHREAD_STACK_MIN;
+	if (PTHREAD_STACK_MIN > 0 && stacksize < (size_t)PTHREAD_STACK_MIN)
+		stacksize = (size_t)PTHREAD_STACK_MIN;
 	ret = pthread_attr_setstacksize(attr, stacksize);
 	assert(ret == 0);
 	if (detached) {
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

