Return-Path: <SRS0=8PHT=N6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC3FC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  8 Sep 2021 20:38:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B72DA61157
	for <dm-devel@archiver.kernel.org>; Wed,  8 Sep 2021 20:38:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B72DA61157
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-YLkBZxghNlC9dG8uxAYDxw-1; Wed, 08 Sep 2021 16:38:40 -0400
X-MC-Unique: YLkBZxghNlC9dG8uxAYDxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E68EA84A5E3;
	Wed,  8 Sep 2021 20:38:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3116760C7F;
	Wed,  8 Sep 2021 20:38:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4A7A34E58E;
	Wed,  8 Sep 2021 20:38:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 188KY5FD003849 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 8 Sep 2021 16:34:05 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id EBFD92094D00; Wed,  8 Sep 2021 20:34:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6B222094D01
	for <dm-devel@redhat.com>; Wed,  8 Sep 2021 20:34:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36EAF8934F6
	for <dm-devel@redhat.com>; Wed,  8 Sep 2021 20:34:02 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
	[209.85.221.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-122-8MF5ndIuONSPAJFG0nrMUA-1; Wed, 08 Sep 2021 16:33:57 -0400
X-MC-Unique: 8MF5ndIuONSPAJFG0nrMUA-1
Received: by mail-wr1-f45.google.com with SMTP id n5so5068810wro.12;
	Wed, 08 Sep 2021 13:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=QUxKjCH/ib+dig8Db6dLUih6TrmscRfjCi8vDb5TONs=;
	b=gV1V05D8i6bojvE1zb0eaJ2haKUpnLvLf5KeTjFBtZSzy6IN8ozLy4QZCRBsNZODae
	MEIPM6DrapQrq8dqI1U+MXzysf7HbZsvf25PQrEdaZWb+/Pa8NjMXSNV5uc6aNk/1XRo
	u01Mz/JpS7pweWsBuKWNEw5UgaZmQDNpQfzdwlWUPW5zuYLqCpdxnWl7SQW1IDB9u5Ru
	hF9h535db3uRN5sbU4Xu7e3U3lkeKoONTMNbmvCEZUvZoMXBRGsY+TptFoCzmURmlGlx
	wPc59zNQzBe6deerj2HfNFH7bkmTvTm4k3U5CJIp4hXpqcIkWoV9zp6TIb1goL15irTA
	QGHA==
X-Gm-Message-State: AOAM532RyK6NdyatQc5rZ2GCsf3irtbwQobl5Jwc6wsX5D9ldCnLacGB
	1lvDbOQrqLyZUY9eFvn+hw==
X-Google-Smtp-Source: ABdhPJyPL0gHnvF4zkJhE4tJkw/DXt7D4M2jb+nNI31g8+62yZjvWlAA/IGS8D6eZTm6nmt3YAZbKA==
X-Received: by 2002:adf:b741:: with SMTP id n1mr179477wre.354.1631133236442;
	Wed, 08 Sep 2021 13:33:56 -0700 (PDT)
Received: from localhost ([84.39.177.213])
	by smtp.gmail.com with ESMTPSA id c7sm107456wmq.13.2021.09.08.13.33.55
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 08 Sep 2021 13:33:56 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed,  8 Sep 2021 22:33:54 +0200
Message-Id: <20210908203354.13312-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>,
	Mike Christie <michael.christie@oracle.com>
Subject: [dm-devel] [PATCH] multipath-tools: add info about IO affinity path
	selector to manpage
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Added in 5.11: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e4d2e82b2300b03f66b3ca8417590c86e661fab1

Cc: Mike Christie <michael.christie@oracle.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index d6b8c7f6..42a15ffd 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -6,7 +6,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2018-05-21 Linux
+.TH MULTIPATH.CONF 5 2021-09-08 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -210,6 +210,10 @@ of outstanding I/O to the path and its relative throughput.
 estimation of future service time based on the history of previous I/O submitted
 to each path.
 .TP
+.I "io-affinity 0"
+(Since 5.11 kernel) Choose the path for the next bunch of I/O based on a CPU to
+path mapping the user passes in and what CPU we are executing on.
+.TP
 The default is: \fBservice-time 0\fR
 .RE
 .
-- 
2.32.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

