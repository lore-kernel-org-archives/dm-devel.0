Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B33DEB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686843503;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ftpaC9rMa41ki/8BfGBuu4HWLDP8EIbqX9c7Qva54WE=;
	b=GZbjFvipeUVdymnwHlwos+yUknQdGHmlo9hE4CsyzLgl47aFCCZXCouPM2TugRAL5ehhRG
	OvhBF9WK08Xx2I5Z+Y7zBYF5F+0F3Nt2qpWuwhqVKKh/xUIGM5o5u+RgEcIvPMISVh4GZn
	ivTeD4OiNNqdLpQ3rk80Hw5FYJ1GpwQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-oXSK3wTWNQSRivQQMfQVQg-1; Thu, 15 Jun 2023 11:38:02 -0400
X-MC-Unique: oXSK3wTWNQSRivQQMfQVQg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 520148030B4;
	Thu, 15 Jun 2023 15:37:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD3522026D49;
	Thu, 15 Jun 2023 15:37:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9ED01946597;
	Thu, 15 Jun 2023 15:37:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1977F1946594
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 15:36:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4C34540CFD01; Thu, 15 Jun 2023 15:36:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 44BA740CFD00
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 15:36:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 242D338294A7
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 15:36:53 +0000 (UTC)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com
 [209.85.167.44]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-nCXsUFYHPT20b_jIR4frMQ-1; Thu, 15 Jun 2023 11:36:42 -0400
X-MC-Unique: nCXsUFYHPT20b_jIR4frMQ-1
Received: by mail-lf1-f44.google.com with SMTP id
 2adb3069b0e04-4f611ac39c5so10978932e87.2; 
 Thu, 15 Jun 2023 08:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686843398; x=1689435398;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=9/agbgifBFLPeQK2xfF+g+B3Io+nbJ8j/1cq5l4nn14=;
 b=SlXidahHWYO+RhfR/oetwsb60Z2KPYBBuTnoYuEZZEojYzB1zzglxDGK7IRGBJpPEz
 W72wEF8ADYNZ9uascWWWEaEWh/spX2Pbui2fUScqirAtsUrk6XEqOP8N/Ft1ohEi/72v
 +vL5j36QyZFQKX/GGdgsOsNTu/GVpFhKS8CmdXV3lp2Ep0q6qTjKx6+X4PfSFPUPMYOL
 arczHVn6cowZZtsTn+pxxIQOw+cY8PkMW4pXAeRveK8bLFsnvO0ZkwQxAU/+whGOJ0J7
 95lcMaYatasN598buI0TX9JS66v3JKha0r1J4dnwIywjNE/Wk5TjqcPWogKjTj6gIzlF
 Rp1A==
X-Gm-Message-State: AC+VfDxfeU9LbVraH9Ufm03yql+covdWH63jHWlH3UssIHQQwmFgNwf3
 t9OH/UfYQX/Ysr/RdqZq9t817nF6NA==
X-Google-Smtp-Source: ACHHUZ7lImwyixbK4BjtRwa+CxP8MTR5FPL/1PLDVEMKAz+hHf2DZ1D6+cwjie8OqxTB5PZGRlQAlg==
X-Received: by 2002:a19:9155:0:b0:4f8:453d:e56 with SMTP id
 y21-20020a199155000000b004f8453d0e56mr1073319lfj.5.1686843397373; 
 Thu, 15 Jun 2023 08:36:37 -0700 (PDT)
Received: from localhost (112.red-81-44-165.dynamicip.rima-tde.net.
 [81.44.165.112]) by smtp.gmail.com with ESMTPSA id
 ja15-20020a05600c556f00b003f61177faffsm11228414wmb.0.2023.06.15.08.36.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 15 Jun 2023 08:36:36 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 15 Jun 2023 17:36:34 +0200
Message-ID: <20230615153635.21183-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH] multipath-tools: fix spelling
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
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

libmultipath/structs_vec.c:270: mulitpath ==> multipath
libmultipath/libmultipath.version:36: overriden ==> overridden
libmpathutil/libmpathutil.version:36: overriden ==> overridden

SUMMARY:
mulitpath     1
overriden     2

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmpathutil/libmpathutil.version | 2 +-
 libmultipath/libmultipath.version | 2 +-
 libmultipath/structs_vec.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
index dd007be4..68f5ab91 100644
--- a/libmpathutil/libmpathutil.version
+++ b/libmpathutil/libmpathutil.version
@@ -33,7 +33,7 @@
 
 /*
  * Symbols exported by both libmpathutil and libmultipath
- * libmpathutil exports just dummy symbols, intended to be overriden
+ * libmpathutil exports just dummy symbols, intended to be overridden
  * by those in libmultipath.
  * CAUTION - the version in libmpathutil.version and libmultipath.version
  * must be THE SAME, otherwise the overriding will fail!
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index aba1a30e..8fcfd20f 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -33,7 +33,7 @@
 
 /*
  * Symbols exported by both libmpathutil and libmultipath
- * libmpathutil exports just dummy symbols, intended to be overriden
+ * libmpathutil exports just dummy symbols, intended to be overridden
  * by those in libmultipath.
  * CAUTION - the version in libmpathutil.version and libmultipath.version
  * must be THE SAME, otherwise the overriding will fail!
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f3fdc5a6..0e8a46e7 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -267,7 +267,7 @@ int adopt_paths(vector pathvec, struct multipath *mpp)
 			if (mpp->queue_mode == QUEUE_MODE_RQ &&
 			    pp->bus == SYSFS_BUS_NVME &&
 			    pp->sg_id.proto_id == NVME_PROTOCOL_TCP) {
-				condlog(2, "%s: mulitpath device %s created with request queue_mode. Unable to add nvme:tcp paths",
+				condlog(2, "%s: multipath device %s created with request queue_mode. Unable to add nvme:tcp paths",
 					pp->dev, mpp->alias);
 				continue;
 			}
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

