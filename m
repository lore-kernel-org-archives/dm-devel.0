Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3601C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 00:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669162428;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZjBkpI7t4JGd3XeSTtFBzugbWeZa26ahvfDJremQpJw=;
	b=E+KEXZ8PTiK7Aa1pQtcw+Ylm9Jj6iAGqtVYrJDuBu767TdCZm/5RFqrZzGrtJbcOs+SmIH
	bIUTq+Wo6OGWveMppnwqETW34srPiHZ/vEXF6OLGf9dNDXa8vlja6WCCeOBbVByN+WXey1
	cbqXI+2ChXCrjW8iZnzOFNcqchLrZsI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-137-JBzMO5IqP-Wl1IV49sn8_g-1; Tue, 22 Nov 2022 19:13:47 -0500
X-MC-Unique: JBzMO5IqP-Wl1IV49sn8_g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC4A385A588;
	Wed, 23 Nov 2022 00:13:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C84EE2024CBE;
	Wed, 23 Nov 2022 00:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8B1011946589;
	Wed, 23 Nov 2022 00:13:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DC6391946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 00:13:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F4A04B3FCD; Wed, 23 Nov 2022 00:13:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 681BF4B3FC6
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 00:13:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DCC5185A794
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 00:13:39 +0000 (UTC)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-428-kAFYkic-OhGXIKgk-t3ItQ-1; Tue, 22 Nov 2022 19:13:37 -0500
X-MC-Unique: kAFYkic-OhGXIKgk-t3ItQ-1
Received: by mail-wr1-f41.google.com with SMTP id cl5so27214988wrb.9;
 Tue, 22 Nov 2022 16:13:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=Xb80az8TmkXYF4jEkFQ+MU6K3Ep9k/mVfg7s6rhzlrc=;
 b=gpXSxo9SR1eC8KFpto+SCQ1jbVuoQy+7KU7r6cbFn4rSoXui4ACFHUFtqeQm/9x4VS
 uzpCJ2yvZkxbGaMLqBmlLlPSjP7EED007Om9emNkoVCuZvPzoHAphqd6DQOQPcSz83+e
 ZWufgvjmaypYotCRZIVCH2X7PtN7rSPWCrk3nTxP+snvGkUzyf1resiD9/8Mqvz2N6oy
 /L/20IF4gcWGyp3uW2LdJfuje1CbSKpTAFUo3I+lfNbG/gVpksE9WJg98e86feRCn/Kt
 qt9O0prsGiavrrWoZhko9LamwEh3W5Ob9VYHqIBvN2zXpMSzxbXuDlsJFWALHBJFjHhH
 IGKw==
X-Gm-Message-State: ANoB5plW/5qoatMkL4W2PzyGUEhxU4ZQDGHuhXlKH3vEAPQT9aGIuH9O
 i9wcTy1kzp23+5MRe2zDOYYQ4zgZ4g==
X-Google-Smtp-Source: AA0mqf6uMp4wtFXqXU+ElTmMlv5CbviAxTtAS2FHfMzDmUiOE3Dey/LFHr6CADQ6by7Ngpf5IRyVmw==
X-Received: by 2002:adf:dbd2:0:b0:236:3cf5:4528 with SMTP id
 e18-20020adfdbd2000000b002363cf54528mr15891488wrj.355.1669162415625; 
 Tue, 22 Nov 2022 16:13:35 -0800 (PST)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 p1-20020a1c5441000000b003b4cba4ef71sm275860wmi.41.2022.11.22.16.13.34
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 22 Nov 2022 16:13:35 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 23 Nov 2022 01:13:33 +0100
Message-Id: <20221123001334.116613-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH] multipath-tools: add EF to rdac info
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/propsel.c     | 2 +-
 multipath/multipath.conf.5 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d1d5cc25..cd3d74e1 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -568,7 +568,7 @@ out:
 }
 
 /*
- * Current RDAC (NetApp E-Series) firmware relies
+ * Current RDAC (NetApp E/EF Series) firmware relies
  * on periodic REPORT TARGET PORT GROUPS for
  * internal load balancing.
  * Using the sysfs priority checker defeats this purpose.
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 063b05a7..a7796c65 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -364,7 +364,7 @@ prio_args keyword.
 .PP
 The default depends on the \fBdetect_prio\fR setting: If \fBdetect_prio\fR is
 \fByes\fR (default), the default priority algorithm is \fBsysfs\fR (except for
-NetAPP E-Series, where it is \fBalua\fR). If \fBdetect_prio\fR is
+NetAPP E/EF Series, where it is \fBalua\fR). If \fBdetect_prio\fR is
 \fBno\fR, the default priority algorithm is \fBconst\fR.
 .RE
 .
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

