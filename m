Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F64CC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 22:50:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A9E3F61152
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 22:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A9E3F61152
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-12-KiMOrumAPi6qBaPMTkRiSQ-1; Wed, 13 Oct 2021 18:50:03 -0400
X-MC-Unique: KiMOrumAPi6qBaPMTkRiSQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 076B7362F8;
	Wed, 13 Oct 2021 22:49:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCFE85BAF8;
	Wed, 13 Oct 2021 22:49:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 54B021800FE4;
	Wed, 13 Oct 2021 22:49:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DMnqUR003966 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 18:49:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A9599404727A; Wed, 13 Oct 2021 22:49:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A55ED4047272
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:49:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91BB9899EC1
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 22:49:52 +0000 (UTC)
Received: from sender11-of-o53.zoho.eu (sender11-of-o53.zoho.eu
	[31.186.226.239]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-459-8z6VPtJKMlmLIu4sO38Ktg-1; Wed, 13 Oct 2021 18:49:50 -0400
X-MC-Unique: 8z6VPtJKMlmLIu4sO38Ktg-1
Received: from thinkbage.fritz.box (pd95443c5.dip0.t-ipconnect.de
	[217.84.67.197]) by mx.zoho.eu
	with SMTPS id 1634164482310184.07718177301456;
	Thu, 14 Oct 2021 00:34:42 +0200 (CEST)
From: Bastian Germann <bage@debian.org>
To: dm-devel@redhat.com
Message-ID: <20211013223433.7190-1-bage@debian.org>
Date: Thu, 14 Oct 2021 00:34:33 +0200
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 19DMnqUR003966
X-loop: dm-devel@redhat.com
Cc: Bastian Germann <bage@debian.org>
Subject: [dm-devel] [PATCH] multipathd: Add missing ctype include
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In uxclnt.c, there are isspace calls. Add an explicit include.

Signed-off-by: Bastian Germann <bage@debian.org>
---
 multipathd/uxclnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index a76f8e29..f16a7309 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdarg.h>
+#include <ctype.h>
 #include <fcntl.h>
 #include <errno.h>
 #include <sys/ioctl.h>
-- 
2.33.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

