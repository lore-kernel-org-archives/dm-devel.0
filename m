Return-Path: <SRS0=/8Bn=IX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E88C433C1
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 22:34:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 841EB61A38
	for <dm-devel@archiver.kernel.org>; Thu, 25 Mar 2021 22:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 841EB61A38
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-ASfHpU1CMcaLFGL7ho0QyA-1; Thu, 25 Mar 2021 18:34:52 -0400
X-MC-Unique: ASfHpU1CMcaLFGL7ho0QyA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4582814337;
	Thu, 25 Mar 2021 22:34:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9177D5D741;
	Thu, 25 Mar 2021 22:34:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 55EB51800215;
	Thu, 25 Mar 2021 22:34:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12PMYRMB005290 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 18:34:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0EC63F8960; Thu, 25 Mar 2021 22:34:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 096AAF8957
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 22:34:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6DB0805F47
	for <dm-devel@redhat.com>; Thu, 25 Mar 2021 22:34:26 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
	[209.85.128.50]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-232-IlRjYDnFNbG2oR3TuQdO7g-1; Thu, 25 Mar 2021 18:34:22 -0400
X-MC-Unique: IlRjYDnFNbG2oR3TuQdO7g-1
Received: by mail-wm1-f50.google.com with SMTP id
	u5-20020a7bcb050000b029010e9316b9d5so2028123wmj.2; 
	Thu, 25 Mar 2021 15:34:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=PJr+RzCEahSq0L5fQOMXwlcGmgUuaw6cTi9xpIjaJSQ=;
	b=cQLs088hhOxxuKdUSiDilta/BfwO/dd9Uvue8pHd/eORn9y/aOzcOmW0LlwesCIXeK
	WbG82FhSpK7SGWGI6YXNwytYtxhA5I4vbZ3t4c9PDTP1OorsGTcWJDQ1uFxuqsgzOoCF
	RkrG8aopao7lav579zPBnRVZ2KttVwneLKhSNcdJvdPa3OFGiOsRusf3lYSFHEL/vLOz
	sfJvNdvrkcQ4aNmsK5ebQ4M9UGnSefSu7O+rXi7uths/rot+2Dd9jrU8igOyTgEeBvt4
	sdifHole/n8gqArY5+EyuJhtNbGjrLiUSyqdAwc3HmDcBx5ZPpum68xuj3ylTksmmM6X
	X85g==
X-Gm-Message-State: AOAM532ziU7FGLF7u3VPTVCzDQjDW/cYdk89WiBwmZAtrH/dLRDK27tm
	7DKRKxuPp/jIBc25yCEtjg==
X-Google-Smtp-Source: ABdhPJztZrhOyLCzIfcNOa7cY61EDzIptDUvJccSuNk1S14m19eEuVmUWX030sWFEktGLhHQ5ucBKw==
X-Received: by 2002:a05:600c:4ed1:: with SMTP id
	g17mr10050714wmq.67.1616711661099; 
	Thu, 25 Mar 2021 15:34:21 -0700 (PDT)
Received: from localhost (220.red-83-38-250.dynamicip.rima-tde.net.
	[83.38.250.220])
	by smtp.gmail.com with ESMTPSA id c9sm8668922wml.42.2021.03.25.15.34.20
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 25 Mar 2021 15:34:20 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 25 Mar 2021 23:34:14 +0100
Message-Id: <20210325223414.5185-3-xose.vazquez@gmail.com>
In-Reply-To: <20210325223414.5185-1-xose.vazquez@gmail.com>
References: <20210325223414.5185-1-xose.vazquez@gmail.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, Martin Wilck <mwilck@suse.com>,
	DM-DEVEL ML <dm-devel@redhat.com>
Subject: [dm-devel] [PATCH 2/2] multipath-tools: add more info about ALUA
	for CLARiiON arrays
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

EMC tool "Drop-down list" differs across product generations.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.alua | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.alua b/README.alua
index f9967595..b15eb487 100644
--- a/README.alua
+++ b/README.alua
@@ -4,7 +4,7 @@ ALUA is supported in some devices, but usually it's disabled by default.
 To enable ALUA, the following options should be changed:
 
 - EMC CLARiiON/VNX:
-   "Failover Mode" should be changed to "4".
+   "Failover Mode" should be changed to "4" or "Active-Active mode(ALUA)-failover mode 4"
 
 - HPE 3PAR:
    "Host:" should be changed to "Generic-ALUA Persona 2 (UARepLun, SESLun, ALUA)".
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

