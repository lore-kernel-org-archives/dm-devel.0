Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3467AC77B73
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 17:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686071570;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3MKwQZ+a1KnUix7X94p3lba1BW4po15+s046G+0kC64=;
	b=QBlCqDcCt9B/5pV1kOte9OgbgzOrrJ1E1r5wmgb9MZWwYrl/Bb7zYpIze4qYU7HaDRk3Eu
	R1AuG/qGbUrsJPnxCU32tiM6CxjXuMEsT2UgsFJh6HHsaTLuqyYxJHEYYObrD/nWAQG7Mq
	ZFsgC8vOJ6Gj56E75zLg/bZUVVecQjQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-jdHSw3lhN6S7RKPRpqYFRA-1; Tue, 06 Jun 2023 13:12:47 -0400
X-MC-Unique: jdHSw3lhN6S7RKPRpqYFRA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9D7C280BC8A;
	Tue,  6 Jun 2023 17:12:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CE69C1603B;
	Tue,  6 Jun 2023 17:12:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1440519465BD;
	Tue,  6 Jun 2023 17:12:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 74EF619465BC
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 17:12:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 557B3C0297C; Tue,  6 Jun 2023 17:12:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D7EDC0448E
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 17:12:42 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3242D800BFF
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 17:12:42 +0000 (UTC)
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-13-0aPo7Z4sP5WgYRFF3I8rAg-1; Tue,
 06 Jun 2023 13:12:40 -0400
X-MC-Unique: 0aPo7Z4sP5WgYRFF3I8rAg-1
Received: from authenticated user by stravinsky.debian.org with esmtpsa
 (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2) (envelope-from <zeha@debian.org>)
 id 1q6aEY-003eTT-0W; Tue, 06 Jun 2023 17:12:38 +0000
From: Chris Hofstaedtler <zeha@debian.org>
To: dm-devel@redhat.com
Date: Tue,  6 Jun 2023 19:12:21 +0200
Message-Id: <20230606171221.1472-1-zeha@debian.org>
MIME-Version: 1.0
X-Debian-User: zeha
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH] multipath-tools build: accept
 KBUILD_BUILD_TIMESTAMP from env
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
Cc: Chris Lamb <lamby@debian.org>, Chris Hofstaedtler <zeha@debian.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: debian.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Chris Lamb <lamby@debian.org>

It would appear KBUILD_BUILD_TIMESTAMP is meant to be used the same way as in
the linux kernel build. For linux, builders are supposed to set
KBUILD_BUILD_TIMESTAMP in the environment if they want a stable timestamp.

The libddmmp makefile however tries to directly call git to get a timestamp,
which fails in a typical Debian build environment, which is not a full git
source tree.

Have libdmmp/Makefile use KBUILD_BUILD_TIMESTAMP from the environment if
available, otherwise use git as before.

Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
---
 libdmmp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 9ece9528..601933aa 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -75,7 +75,7 @@ docs/man/dmmp_strerror.3:	$(HEADERS)
 	$(Q)TEMPFILE=$(shell mktemp); \
 	cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
 	LC_ALL=C \
-	KBUILD_BUILD_TIMESTAMP=`git log -n1 --pretty=%cd --date=iso -- $^` \
+	KBUILD_BUILD_TIMESTAMP=`echo $$KBUILD_BUILD_TIMESTAMP | grep . || git log -n1 --pretty=%cd --date=iso -- $^` \
 	perl docs/kernel-doc -man $$TEMPFILE | \
 	    perl docs/split-man.pl docs/man; \
 	$(RM) -f $$TEMPFILE
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

