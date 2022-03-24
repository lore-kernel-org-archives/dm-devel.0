Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A06C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 17:30:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-LFceQw6nN3Sxr75afOzlEw-1; Thu, 24 Mar 2022 13:30:52 -0400
X-MC-Unique: LFceQw6nN3Sxr75afOzlEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACEC21044566;
	Thu, 24 Mar 2022 17:30:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 550969E60;
	Thu, 24 Mar 2022 17:30:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0B153194034B;
	Thu, 24 Mar 2022 17:30:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 525641940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 17:30:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D87A6409B3E1; Thu, 24 Mar 2022 17:30:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D3BBA409B3E0
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 17:30:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BADE81C0EDC0
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 17:30:47 +0000 (UTC)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-HsMIBJYBOI2q30hvuO0joQ-1; Thu, 24 Mar 2022 13:30:42 -0400
X-MC-Unique: HsMIBJYBOI2q30hvuO0joQ-1
Received: by mail-wr1-f48.google.com with SMTP id h4so7607349wrc.13;
 Thu, 24 Mar 2022 10:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=NxDfR37VjkWNGAsH25fGYcoYhpVBEmYx8v4YSuTKrCA=;
 b=0uLvXKJAdUlkyjkJ4lW5vEecH2FqTiNk21FCqC2DBsKMpC7C2DyQv/5NqgEPdE0Ynr
 G3diNPYtDMMz3Lu1pWwz+XKcI94YTpI2cXn2Wgk9Vl5lvB0zMQ5GHkQIZB8ZhkMNYm2/
 Ie4tRUxlDZaM6oiqqb42IFNH+0ye8dhEqAwkiZx7z8TxnkqkCBbhFYzgQ57FIkKwPTcV
 SKdRGjbn23+pz9yuwHABzpKIJJ6RY4YigEvaiEZ+YFMIowWrxUKUXNKiQOlZk4q8RRvo
 FaYgtCcyr2WYbCFhyU2w5unenv48jMhZV5kFKq7nRFb/Cy0aU1xwtbOqxr2qmthXLeeh
 D25g==
X-Gm-Message-State: AOAM533RhJxRQpw5Ad+jChjsRvCk+gdTQ2Nkq2N6TN/81juQ/C1bwOgV
 sdkHG3AhkKyNL1D8lzNlgg==
X-Google-Smtp-Source: ABdhPJw73THcwRcVL78ZiAYDUSpoaxiUQ7roV/cj6ZSaJpHTtihEP1RiEGVRw6y34XRsU86O2C5MwQ==
X-Received: by 2002:a05:6000:1a85:b0:205:a234:d0a5 with SMTP id
 f5-20020a0560001a8500b00205a234d0a5mr135468wry.126.1648143041426; 
 Thu, 24 Mar 2022 10:30:41 -0700 (PDT)
Received: from localhost (153.red-88-4-24.dynamicip.rima-tde.net.
 [88.4.24.153]) by smtp.gmail.com with ESMTPSA id
 p16-20020a5d6390000000b00203ffebddf3sm4232425wru.99.2022.03.24.10.30.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 10:30:41 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 24 Mar 2022 18:30:39 +0100
Message-Id: <20220324173039.6155-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH] multipath-tools: add Martin and Benjamin as
 maintainers
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
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
 README.md | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/README.md b/README.md
index 15478625..10ddf463 100644
--- a/README.md
+++ b/README.md
@@ -129,10 +129,12 @@ pre-0.4.5: https://web.archive.org/web/20070309224034/http://christophe.varoqui.
 post-0.4.5: https://github.com/opensvc/multipath-tools/commits/master
 
 
-Maintainer
-==========
+Maintainers
+===========
 
 Christophe Varoqui <christophe.varoqui@opensvc.com>
+Benjamin Marzinski <bmarzins@redhat.com>
+Martin Wilck <mwilck@suse.com>
 Device-mapper development mailing list <dm-devel@redhat.com>
 
 
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

