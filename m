Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84F19CCA47B
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jul 2022 21:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657833303;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LRPTK9XkNcr6zsMCnRS8hxV6yyKztDoq1t9NGu4Xsb8=;
	b=c0StxWUrv5gaS4niz88slSNwRdTIe2crLWSDgrsqz72WSMCN6dL4O5l1gzmupcvMnjNzF6
	6bxswTOWNlYRzAeXS3huYJR/s2yZBv9AYKr47EBxoG4bRSYzdglBUbuTnpz+etCnRXMlj5
	j91ZJf9QQxW8VGwJZhiJkQjV/rYdOsw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-IfPjgXlPMHynmp-Kb5no3g-1; Thu, 14 Jul 2022 17:14:53 -0400
X-MC-Unique: IfPjgXlPMHynmp-Kb5no3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 396D518A0665;
	Thu, 14 Jul 2022 21:14:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 42FC2400EAA4;
	Thu, 14 Jul 2022 21:14:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F0111194706F;
	Thu, 14 Jul 2022 21:14:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0A6E194706D
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 21:14:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CDFCDC27DB3; Thu, 14 Jul 2022 21:14:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C9567C15D67
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 21:14:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B11501C0513B
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 21:14:48 +0000 (UTC)
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com
 [209.85.128.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-8d5VdFERPeWRqnGCGXY2eg-1; Thu, 14 Jul 2022 17:14:46 -0400
X-MC-Unique: 8d5VdFERPeWRqnGCGXY2eg-1
Received: by mail-wm1-f42.google.com with SMTP id
 l22-20020a05600c4f1600b003a2e10c8cdeso3948593wmq.1; 
 Thu, 14 Jul 2022 14:14:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=McuweCVJqw09G0IUzSAdqropgpPicrCXZJTR9xEEq5s=;
 b=bImujyaluE3Mr//fjECZalf6gGnpMylJ+LnJiI8qTsw25ZfyjsUV2QdehbidTQEQDF
 XCPtR1gJKfWZNRdHDZQCJxlTTWgXHY21Z6ZTA7XMXVW/K23Y153AM+PSXIJcsQjmizoX
 JddoqEf+TARtJ561LM1ZgUWX/I6i5f5OAi0+bOgI6wwn2hV26eF6L0kuycozK4toCrdH
 7BlZzJ+wf0KgQui1aldQ88OwxOzdxRo5AbNwm9gjftpjWXM4jTW16yM4XIpTmbIiFLYT
 MY19K6obV1eJ+5el/rP03RzzsZATgi9aUXAOrlm0H/dpzNdln5Y6UMym+gS9fz3Zuv9F
 1Ekg==
X-Gm-Message-State: AJIora8+gd4116BzalUOX69/1HwYJdAKQ17kDGtZGfGL9NxwF35fM830
 gOXDw9K+jfoEVytWUXrLPg==
X-Google-Smtp-Source: AGRyM1sbNn/Uo1Gw4Hkor14T6GL4jP9S7kXq1Wlrw6G3jC9HpdzaeK/Aa49a80tVfLSx1x31nTPMlw==
X-Received: by 2002:a7b:cb56:0:b0:3a3:27e:e40b with SMTP id
 v22-20020a7bcb56000000b003a3027ee40bmr4605790wmj.186.1657833273003; 
 Thu, 14 Jul 2022 14:14:33 -0700 (PDT)
Received: from localhost (127.red-81-44-149.dynamicip.rima-tde.net.
 [81.44.149.127]) by smtp.gmail.com with ESMTPSA id
 l19-20020a05600c1d1300b003a300452f7esm3437261wms.28.2022.07.14.14.14.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Jul 2022 14:14:32 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 14 Jul 2022 23:14:31 +0200
Message-Id: <20220714211431.123911-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH] multipath-tools: add ALUA info to README.md
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
 README.md | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/README.md b/README.md
index dcf51f20..2322082c 100644
--- a/README.md
+++ b/README.md
@@ -146,3 +146,31 @@ The multipath-tools source code is covered by several different licences.
 Refer to the individual source files for details.
 Source files which do not specify a licence are shipped under LGPL-2.0
 (see `LICENSES/LGPL-2.0`).
+
+
+ALUA
+====
+This is a rough guide, consult your storage device manufacturer documentation.
+
+ALUA is supported in some devices, but usually it's disabled by default.
+To enable ALUA, the following options should be changed:
+
+- EMC CLARiiON/VNX:
+   "Failover Mode" should be changed to "4" or "Active-Active mode(ALUA)-failover mode 4"
+
+- HPE 3PAR, Primera, and Alletra 9000:
+   "Host:" should be changed to "Generic-ALUA Persona 2 (UARepLun, SESLun, ALUA)".
+
+- Promise VTrak/Vess:
+   "LUN Affinity" and "ALUA" should be changed to "Enable", "Redundancy Type"
+   must be "Active-Active".
+
+- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM arrays:
+   "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".
+
+- NetApp ONTAP:
+   To check ALUA state: "igroup show -v <igroup_name>", and to enable ALUA:
+   "igroup set <igroup_name> alua yes".
+
+- Huawei OceanStor:
+   "Host Access Mode" should be changed to "Asymmetric".
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

