Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F289DC433FE
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 04:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669784220;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=cg+VPAW3Rt2VC3LmmyDnVhnsXBbIbLUK7TkcPPcgy2g=;
	b=eu3z19tonMuRYrcMsLymBK0zj/KsInBaTGE05vuxkyyL6B9NtivAE+IQh+AfIUBvncLylt
	7Zv13zKFlTMhdFNqJBM1FXsQLfD02vYrH/ss1MsjhWMnYKKPAOugoUKMNumfAhQ678KHEJ
	DhZl1qW7EUzuidlIDWXzNpCMUulEIOQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-47-ap5lUOjVMYaXkOMAfrsOCA-1; Tue, 29 Nov 2022 23:56:57 -0500
X-MC-Unique: ap5lUOjVMYaXkOMAfrsOCA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 46962833AED;
	Wed, 30 Nov 2022 04:56:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F29340C6EC4;
	Wed, 30 Nov 2022 04:56:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB14319465A2;
	Wed, 30 Nov 2022 04:56:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2169E19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 04:56:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 002DD492B0E; Wed, 30 Nov 2022 04:56:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DC1CE492B09;
 Wed, 30 Nov 2022 04:56:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2AU4unVW009792;
 Tue, 29 Nov 2022 22:56:49 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2AU4unJl009791;
 Tue, 29 Nov 2022 22:56:49 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 29 Nov 2022 22:56:47 -0600
Message-Id: <1669784208-9754-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/2] multipath.conf(5): remove io-affinity
 information
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The multpath-tools do not support the io-affinity path selector.  We
always add a repeat count as the path argument. The io-affinity selector
doesn't take one. Instead it takes a bitmap of CPUs that a path can run
on. This isn't something that lends itself to the kind of
auto-assembling that multipathd does. But even if we did want to try to
support this path-selector, until we do, we shouldn't be listing it in
the multipath.conf documentation.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipath/multipath.conf.5 | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 1fea9d5a..3a45ac89 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -205,10 +205,6 @@ of outstanding I/O to the path and its relative throughput.
 estimation of future service time based on the history of previous I/O submitted
 to each path.
 .TP
-.I "io-affinity 0"
-(Since 5.11 kernel) Choose the path for the next bunch of I/O based on a CPU to
-path mapping the user passes in and what CPU we are executing on.
-.TP
 The default is: \fBservice-time 0\fR
 .RE
 .
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

