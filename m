Return-Path: <SRS0=pJ9r=IR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFEFC433DB
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 16:19:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2636761963
	for <dm-devel@archiver.kernel.org>; Fri, 19 Mar 2021 16:19:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2636761963
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-EmFZgY0bOiGeGZ-hfZFcoQ-1; Fri, 19 Mar 2021 12:19:20 -0400
X-MC-Unique: EmFZgY0bOiGeGZ-hfZFcoQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB963180FCA9;
	Fri, 19 Mar 2021 16:19:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D01C260871;
	Fri, 19 Mar 2021 16:19:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B1AEF4BB7C;
	Fri, 19 Mar 2021 16:19:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12JGJ7ct010621 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Mar 2021 12:19:07 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 05DF4103437; Fri, 19 Mar 2021 16:19:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F211710343D
	for <dm-devel@redhat.com>; Fri, 19 Mar 2021 16:19:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A9BC185A7BA
	for <dm-devel@redhat.com>; Fri, 19 Mar 2021 16:19:04 +0000 (UTC)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
	[209.85.221.45]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-542-lkf5arSZMTqp1WOROvpBHw-1; Fri, 19 Mar 2021 12:19:00 -0400
X-MC-Unique: lkf5arSZMTqp1WOROvpBHw-1
Received: by mail-wr1-f45.google.com with SMTP id b9so9690401wrt.8;
	Fri, 19 Mar 2021 09:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=s6/T/ONiMX5qFq9mou1mq3t4m+p5MznT8MvwaOwHKpA=;
	b=SYnTUpxplyEyVKCYp2HXxRpsRsFcFdVwJ+mB75VW7dsi6UpFhHd9zgxMWJhaEVHoDi
	uhtbl9qYjhh8RKc/Z4iADMdHyxxSO9UH0/9wKxLB8kUwLuPAv4VDk7bvbXfGgSegQ4fK
	fT5CbVsyWOPKN9AVv6GzY+OzpNwlIL9WVRTCp0P3viqS8pFHoxXsms2p5kVkjEZXfswk
	X2TwqOrfPSbf7BkerMZcVECdG8o24MRr8TYnZ7SzF8AgPADs51tiz+PoLMc2tz6cWB2u
	ojgGsHQIhUXSI60rw5qYAbUyuGA9rGtuMlJDw2362UIPw9U021IowNh95fpKx/V53rko
	jl+g==
X-Gm-Message-State: AOAM533ZzGL+AS8etg6BywqJupyJH/RFKQX7hblg/+97A/JVesTxaHK7
	ipaDZjuFLf9lyMVb3IYZYCjcEtQTgA==
X-Google-Smtp-Source: ABdhPJwXwzvoJsGMm2alvdSBjQ7ITPZbL1VWVDn1mebP3QrfPSyJoWGHisU4egAkIE73sgvymxMIQg==
X-Received: by 2002:adf:e7cf:: with SMTP id e15mr5392680wrn.346.1616170739053; 
	Fri, 19 Mar 2021 09:18:59 -0700 (PDT)
Received: from localhost (47.red-83-37-107.dynamicip.rima-tde.net.
	[83.37.107.47]) by smtp.gmail.com with ESMTPSA id
	w132sm7173768wmg.39.2021.03.19.09.18.57
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 19 Mar 2021 09:18:58 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri, 19 Mar 2021 17:18:56 +0100
Message-Id: <20210319161856.57311-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: fix format in multipath.conf.5
	to be consistent
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 multipath/multipath.conf.5 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 73977b97..2aa0f526 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1283,7 +1283,7 @@ to use the default uid_attribute, \fIID_SERIAL\fR, or sysfs for getting their
 wwid.
 .RS
 .TP
-The default is \fBno\fR
+The default is: \fBno\fR
 .RE
 .
 .
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

