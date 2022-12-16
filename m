Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11043C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 16 Dec 2022 13:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671198439;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=TGjuPxTPA+xHEUSB68XJ3nqddS25a9dl6dpWbMHR5ZA=;
	b=LhLEFn+n5+XEot7JwN0qA0eJA5qqvwA9z85D4dbQniuXsEBCqMujaPFjPhH2IS1oHau0xK
	phew0S0l5HwyPSA4FAuYZXy/GXQdWRd0TXLanqx0uiSQQ+QyvjC1jUOwHxp6oIBan8pn7O
	+HwP+qcakDsVR3xRRm3X9nOeVjTMXaM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-p-q_-IV0OfuBmoXZZpaTLA-1; Fri, 16 Dec 2022 08:47:16 -0500
X-MC-Unique: p-q_-IV0OfuBmoXZZpaTLA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7C783833292;
	Fri, 16 Dec 2022 13:47:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7E02B14171BE;
	Fri, 16 Dec 2022 13:47:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3DF9419465B2;
	Fri, 16 Dec 2022 13:47:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05B741946594
 for <dm-devel@listman.corp.redhat.com>; Fri, 16 Dec 2022 13:47:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E9E87492C18; Fri, 16 Dec 2022 13:47:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E1F48492C14
 for <dm-devel@redhat.com>; Fri, 16 Dec 2022 13:47:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C74BF3833289
 for <dm-devel@redhat.com>; Fri, 16 Dec 2022 13:47:08 +0000 (UTC)
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com
 [209.85.210.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-670-YrqxMbn9Pa2vaxBbdbyC4Q-1; Fri, 16 Dec 2022 08:47:07 -0500
X-MC-Unique: YrqxMbn9Pa2vaxBbdbyC4Q-1
Received: by mail-pf1-f173.google.com with SMTP id 21so1818496pfw.4
 for <dm-devel@redhat.com>; Fri, 16 Dec 2022 05:47:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=u+X4xnk9aHhISbktdBBL8H5Vi52sy5jWO519yZkksGo=;
 b=jcW9kGhxRmslfWAJhHJh13eEs7A/JYlOW7Gkjl+I1owFLGHqLvZEep0EI1slPxgTk5
 WVHIIh2WjkcnsVld/ldrgJJULdPEvwvDDHWlG+WWN7kPz1gGgRYq3et7LgwlciYYEoGy
 1rAa/PuX5+7etnoOp7pJK4wTi1E7Z9dWoAvPRJOM7dIXdd3Tcr2an3m+qkFbIS+/uRba
 rjMX2euMhdtNe4ksjIlOSs+ZonT0dvuxH2k/lkV+k+zOygHHyLe8NplFug70MkscPks3
 VJz9ZFBHfjXJX/2TP9yjTilG0/oEHTwuH6NiAkXy3pUDOlchOQZZyFGa7Eump4rAWrmI
 QrAg==
X-Gm-Message-State: ANoB5pmahfw/iI/FRy3YVaegFiaYGAjo+Y1wN4W/YS9TGZkrd+8UXecd
 WsOTJ4Bj8I7R/ovfo/5CtPo=
X-Google-Smtp-Source: AA0mqf4brcNOTElj6B0yf7Ukp2VKx7j60JZy0r4nGV+3yBuDpSTlo2+MzOrRqJs6daGqDEYB7GM6Gw==
X-Received: by 2002:aa7:9243:0:b0:56a:d3ff:f4b2 with SMTP id
 3-20020aa79243000000b0056ad3fff4b2mr31352139pfp.10.1671198425930; 
 Fri, 16 Dec 2022 05:47:05 -0800 (PST)
Received: from masabert ([202.12.244.3]) by smtp.gmail.com with ESMTPSA id
 o23-20020aa79797000000b005763f7606a2sm1488715pfp.200.2022.12.16.05.47.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 16 Dec 2022 05:47:05 -0800 (PST)
Received: by masabert (Postfix, from userid 1000)
 id E24C7236102C; Fri, 16 Dec 2022 22:47:01 +0900 (JST)
From: Masanari Iida <standby24x7@gmail.com>
To: dm-devel@redhat.com,
	mwilck@suse.com
Date: Fri, 16 Dec 2022 22:46:55 +0900
Message-Id: <20221216134655.167761-1-standby24x7@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH] kpartx_id: Add missing 3rd option in usage
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
Cc: standby24x7@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch adds missing 3rd option in kpatx_id usage.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 kpartx/kpartx_id | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/kpartx_id b/kpartx/kpartx_id
index 18732e7cbbaa..4672927e93e1 100755
--- a/kpartx/kpartx_id
+++ b/kpartx/kpartx_id
@@ -28,7 +28,7 @@ MINOR=$2
 UUID=$3
 
 if [ -z "$MAJOR" -o -z "$MINOR" ]; then
-    echo "usage: $0 major minor"
+    echo "usage: $0 major minor UUID"
     exit 1;
 fi
 
-- 
2.38.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

