Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9CBC47088
	for <dm-devel@archiver.kernel.org>; Sat,  3 Dec 2022 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670079653;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=f98gZsP7BEw7OXjHn4T+3ztBX7OWBhidl5RAObOCAxU=;
	b=WfFrv6ewLMTKMNs2vNl3ydgjYmx4QkSG2TiyQwYJXw50QwP8Crs06E+UTrFjspL0cZaqj5
	YrPtMUd81RfokcI6mKHEQOsBWQ4K19J7sHgqBaI/oXGEkRGmFlKP5FkE6JJybm1D8usLJR
	eMMon3gzjhSaCm8rx8pEs6hy+slK+40=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-uG6fy4-LP1unN1fd7M8yeg-1; Sat, 03 Dec 2022 10:00:50 -0500
X-MC-Unique: uG6fy4-LP1unN1fd7M8yeg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C83D800186;
	Sat,  3 Dec 2022 15:00:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A73651121330;
	Sat,  3 Dec 2022 15:00:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 79E931946588;
	Sat,  3 Dec 2022 15:00:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 124A91946587
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Dec 2022 15:00:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 03E7A1415121; Sat,  3 Dec 2022 15:00:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EF161141511E
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 15:00:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D33963C0E463
 for <dm-devel@redhat.com>; Sat,  3 Dec 2022 15:00:40 +0000 (UTC)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com
 [209.85.221.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-650-UzevJfXHOzKsFQwL2eaH-A-1; Sat, 03 Dec 2022 10:00:38 -0500
X-MC-Unique: UzevJfXHOzKsFQwL2eaH-A-1
Received: by mail-wr1-f47.google.com with SMTP id bs21so12182449wrb.4;
 Sat, 03 Dec 2022 07:00:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=GxwWomWDRMDII4GXwQbQO0fzgOuu+33blvKpaPE9p/E=;
 b=VY8jklSkkm/x5Nrs7l03JaGbtb+uyIVKYZs8wstM7eSAbcw9tDXtaXbKkHH6qKIj4s
 SN5cLTbhLb5cnVv2fMO6+uPv3f5mV83uk/VIXHHLRod2hSZageF19XVwUbjD9Za+4Eg4
 O6eaqBDy0Hh+qjEqOQ89JQXJt+crx+9pvhhAtjh0cVB2wgE+G5HjheGbiVpb8UG6Y2rz
 gLXF4GXRPIN+BNoTaUtqME69cXp7WKLZ508UNysfRBBZhT26Von1PQnF2uqiOJqI0tx7
 sj/8JBWQ6qkPm/t3Rg/ggAYLpzIpmJJJFpjIQ3F180lpWurNFOo4uYQ+upAfHmG6sL4j
 u5wA==
X-Gm-Message-State: ANoB5pmOwJCYA5EAIqO1jLagpQ2dnNNgRcGTK9R5YZQHGpW+G9DDm8A9
 JC0NG6AtRxHRoMg3zaTvyA==
X-Google-Smtp-Source: AA0mqf4UMFBVdPA3Aq0ucP6VRFsAiAIYAiz3et5n56JNQer8NcATJ8JNfClDqgjwd5TfDmh3UOo6yw==
X-Received: by 2002:a5d:4564:0:b0:242:4e1e:98ec with SMTP id
 a4-20020a5d4564000000b002424e1e98ecmr2176208wrc.247.1670079637143; 
 Sat, 03 Dec 2022 07:00:37 -0800 (PST)
Received: from localhost (230.red-81-44-152.dynamicip.rima-tde.net.
 [81.44.152.230]) by smtp.gmail.com with ESMTPSA id
 d5-20020adffd85000000b0022e57e66824sm11186493wrr.99.2022.12.03.07.00.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 03 Dec 2022 07:00:36 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat,  3 Dec 2022 16:00:35 +0100
Message-Id: <20221203150035.50356-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH] multipath-tools: mailing list url was changed
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 README.md              | 2 +-
 libmultipath/propsel.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/README.md b/README.md
index fb118822..5e04f5c3 100644
--- a/README.md
+++ b/README.md
@@ -172,7 +172,7 @@ Mailing list
 ============
 
 (subscribers-only)
-To subscribe and archives: https://www.redhat.com/mailman/listinfo/dm-devel
+To subscribe and archives: https://listman.redhat.com/mailman/listinfo/dm-devel
 Searchable: https://marc.info/?l=dm-devel
 
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index cd3d74e1..a25cc921 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -574,7 +574,7 @@ out:
  * Using the sysfs priority checker defeats this purpose.
  *
  * Moreover, NetApp would also prefer the RDAC checker over ALUA.
- * (https://www.redhat.com/archives/dm-devel/2017-September/msg00326.html)
+ * (https://listman.redhat.com/archives/dm-devel/2017-September/msg00326.html)
  */
 static int
 check_rdac(struct path * pp)
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

