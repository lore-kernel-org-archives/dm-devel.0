Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 936CCC43334
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jul 2022 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657825565;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JkQrBgpohWGX78YspYYgfFYp4xQoMHy2ghF6J8Q0NKo=;
	b=gnwR+2S8AYA5z9secPGRfAm3CFEvbETq9SHj3hEUB/9QYV87sgtL3rfA9kTB+vD18jBBsf
	DqbaDPxHSXrnX1WDLX5y2zHpiTg7jKaiKPP/aqr26EbnbmugokowRGkSOs0zcQ/LtOQWh1
	jul9ORP0HSjQeSbVULHm1dESHWuUcps=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-9pZ5T5_3Obml4ar49rKdrQ-1; Thu, 14 Jul 2022 15:05:59 -0400
X-MC-Unique: 9pZ5T5_3Obml4ar49rKdrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBCA018E5345;
	Thu, 14 Jul 2022 19:05:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B8ABE18EB5;
	Thu, 14 Jul 2022 19:05:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 95131194706C;
	Thu, 14 Jul 2022 19:05:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5C6541947042
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 19:05:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E361618ECC; Thu, 14 Jul 2022 19:05:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DF95A18EB5
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 19:05:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C995E101A54E
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 19:05:54 +0000 (UTC)
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com
 [209.85.221.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-zPJs9pfpMXyIqXfMloxlMQ-1; Thu, 14 Jul 2022 15:05:45 -0400
X-MC-Unique: zPJs9pfpMXyIqXfMloxlMQ-1
Received: by mail-wr1-f51.google.com with SMTP id a5so3769179wrx.12;
 Thu, 14 Jul 2022 12:05:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=6MQ5yf74z7yYjkj6AjZ7qDlMFnu2VtIEaA99kxe9jVQ=;
 b=ad71f3bQ739F/ZkcAsYwRqxxTAIUMTevCos2N1E0uv+nyqdfKpbOoanoFinp/Tgcb/
 ZYw9aIxXn4fVmV4paE48cKHLqqjWbpcmBU1d1P7g+2WsZ8I5dgxZAHo7t+8VZqq1msxl
 MrYaZqVJoB/FZM0JVdTpNI8yX5EWh+DK37ierUN/kh9aoJyA218LJE8HZcdOIttNj8Pk
 3W58qalchwsVjlJPhyhYwkUylbDyiwwZ3PSI23eedMfIXgnrh626rYGxuq2LqhOi/KAB
 ypEBuu1Gpwmv+xdipwfLH6t2/mYLWh5vFayaq9j8kbyr+pusl+hmuRUrfbsK1hP3N5m2
 +F+Q==
X-Gm-Message-State: AJIora8iYo6FvIj+DQ9HbzGue1onfESkA+o6w6IjBAUV0mE4z48C4iyA
 JcG9Ah5hNkTzP6niPy+Jaw==
X-Google-Smtp-Source: AGRyM1tMX8tspWGqrXcTU2teHQ0sySI4b1AEpiyTGqZns2JGk4IMqQilpcrZ0e2n1d2NbrpE2TV8iA==
X-Received: by 2002:a5d:6a09:0:b0:21d:7a73:c48a with SMTP id
 m9-20020a5d6a09000000b0021d7a73c48amr9370824wru.366.1657825543930; 
 Thu, 14 Jul 2022 12:05:43 -0700 (PDT)
Received: from localhost (127.red-81-44-149.dynamicip.rima-tde.net.
 [81.44.149.127]) by smtp.gmail.com with ESMTPSA id
 bg32-20020a05600c3ca000b003a04d19dab3sm10535125wmb.3.2022.07.14.12.05.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Jul 2022 12:05:43 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 14 Jul 2022 21:05:39 +0200
Message-Id: <20220714190540.117283-2-xose.vazquez@gmail.com>
In-Reply-To: <20220714190540.117283-1-xose.vazquez@gmail.com>
References: <20220714190540.117283-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 1/2] multipath-tools: update devel repo info in
 README.md
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
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
 README.md | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/README.md b/README.md
index f06f8cea..dcf51f20 100644
--- a/README.md
+++ b/README.md
@@ -3,7 +3,6 @@
 multipath-tools for Linux
 =========================
 
-
 https://github.com/opensvc/multipath-tools
 
 This package provides the following binaries to drive the Device Mapper multipathing driver:
@@ -42,14 +41,12 @@ Go to: https://github.com/opensvc/multipath-tools/tags
 Select a release-tag and then click on "zip" or "tar.gz".
 
 
-Source code
-===========
+Devel code
+==========
 
 To get latest devel code:
 
-    git clone https://github.com/opensvc/multipath-tools.git
-
-Github page: https://github.com/opensvc/multipath-tools
+    git clone -b queue https://github.com/openSUSE/multipath-tools
 
 
 Building multipath-tools
@@ -149,4 +146,3 @@ The multipath-tools source code is covered by several different licences.
 Refer to the individual source files for details.
 Source files which do not specify a licence are shipped under LGPL-2.0
 (see `LICENSES/LGPL-2.0`).
-
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

