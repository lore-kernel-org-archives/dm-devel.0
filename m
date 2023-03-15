Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B43E3C6FD1D
	for <dm-devel@archiver.kernel.org>; Wed, 15 Mar 2023 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678899745;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Uqg8zJM1i6W6x1J1YpX7f4KCBpNATRbZItp2RXjsIw0=;
	b=MfuWlqvBY3A9dWposk1BHEw0yRljkegIaPbLjS//kOeREq7LudVl2DZOF5LOzCzNRICoMr
	MCzjIgiOmB+051lYxHzi62S286+7tKmG99AME138LEmQbe7i0xvJfhHRZwzaA0TApeatu4
	pBTHLgpxMl8XZReP21YIsiSz/+cNQhA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-MCZg6WEIM9OzBDRnaRRYdw-1; Wed, 15 Mar 2023 13:02:22 -0400
X-MC-Unique: MCZg6WEIM9OzBDRnaRRYdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDC4F280558D;
	Wed, 15 Mar 2023 17:02:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6D5D240C6E68;
	Wed, 15 Mar 2023 17:02:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4AD8D19466DF;
	Wed, 15 Mar 2023 17:02:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3E8271946597
 for <dm-devel@listman.corp.redhat.com>; Wed, 15 Mar 2023 17:02:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 229FC492B02; Wed, 15 Mar 2023 17:02:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AEB7492B00
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 17:02:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F17F48028B2
 for <dm-devel@redhat.com>; Wed, 15 Mar 2023 17:02:17 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
 [209.85.128.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-SKc-BCz9NZOx1cjMo5H1Jw-1; Wed, 15 Mar 2023 13:02:14 -0400
X-MC-Unique: SKc-BCz9NZOx1cjMo5H1Jw-1
Received: by mail-wm1-f46.google.com with SMTP id g18so1334852wmk.0;
 Wed, 15 Mar 2023 10:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1678899732;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=SUtIBKK56FPkcAkKqvC1FHvR1BUehYjS9Z0a03eHm6M=;
 b=x5TjygZxGoy/2J8Vfh5jkXTVjoHJHcOb4DlsReCRA1DlS/hmN1T4RmTJ4rUJf3aeSM
 PPYamyxNRLvj1tnXtXcW86nd/vCetD407PPRmyp89UV5tPgKiwrnqgIFaAmJVJgmETDv
 u0WGKXoYifvjuFJ0viEYG7Pg3nm5ra52mn9gkGzEgky3E6O4L+Sryv1bceBsKyAtxJC0
 R57ohK0Tx9k8TCMj97I0Uv6RPS4U+LHuNL0Q6i+3MefEZVW+ce2qpec5VKWCvYX85gqP
 nLsOl3HybDiuqpRiVBeSkH2iJEVDj/Lh+GaPpqWTiOr2iiAptqlTdLVwYNgR/bDWfdhm
 twPA==
X-Gm-Message-State: AO0yUKVQKt086diy9eTVrcm7j5TaKwXFHmG9sAU7SRVrrxVOE6K2o3nf
 uq0fkwp/laVFirx3ddGxJIkQAvmO/2Lu
X-Google-Smtp-Source: AK7set+spM5Jf6dq7nplxWxzw/ys68zIAtwN9SXQl9vSmteT3wcNV5oQHJRFGzYqVrLZp07olE3Exg==
X-Received: by 2002:a05:600c:1912:b0:3ed:2217:4636 with SMTP id
 j18-20020a05600c191200b003ed22174636mr11341680wmq.19.1678899731757; 
 Wed, 15 Mar 2023 10:02:11 -0700 (PDT)
Received: from localhost (5.red-88-29-187.dynamicip.rima-tde.net.
 [88.29.187.5]) by smtp.gmail.com with ESMTPSA id
 g6-20020a05600c288600b003ed2357f7f1sm2392481wmd.37.2023.03.15.10.02.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 15 Mar 2023 10:02:11 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed, 15 Mar 2023 18:02:09 +0100
Message-Id: <20230315170209.13886-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: delete multipathd/multipathc.d
 file when "make clean"
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
 multipathd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/Makefile b/multipathd/Makefile
index 9d531329..ba879102 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -79,7 +79,7 @@ uninstall:
 	$(Q)$(RM) $(DESTDIR)$(unitdir)/$(EXEC).socket
 
 clean: dep_clean
-	$(Q)$(RM) core *.o $(EXEC) $(CLI)
+	$(Q)$(RM) core *.o $(EXEC) $(CLI) multipathc.d
 
 include $(wildcard $(OBJS:.o=.d))
 
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

