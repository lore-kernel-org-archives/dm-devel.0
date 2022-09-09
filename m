Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D24B0ECAAA1
	for <dm-devel@archiver.kernel.org>; Fri,  9 Sep 2022 14:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662732874;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PZ2SJ/XBCKHzp52gwq8ft8gMmAvIr5UmThtHISRDqMc=;
	b=bducv09Hpg6CvHr5qWVIifT10ZjbX1u7lcB2uOWcB5qH9uj5Aecgh9KRuYJZV2G495EWwq
	dP8M27b4YodBX5yOl6KbChrPFhmWJB3p5JNHyXaNWh21oWtzR5iB3uY/oipvsgGjnE6+Mm
	v68pjuKMMYSE1TWa2tq9527AexzcNCY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-B9AdrbJEMpq82PxsHcIsxQ-1; Fri, 09 Sep 2022 10:14:31 -0400
X-MC-Unique: B9AdrbJEMpq82PxsHcIsxQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 934B138149A9;
	Fri,  9 Sep 2022 14:14:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C739945DB;
	Fri,  9 Sep 2022 14:14:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 17FB71946A48;
	Fri,  9 Sep 2022 14:14:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE5C41946A41
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Sep 2022 14:14:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D22872026D64; Fri,  9 Sep 2022 14:14:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CE5952026D4C
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 14:14:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A46A038149B0
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 14:14:27 +0000 (UTC)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-524-WjP3YCgsM5i2Y973jzHmcQ-1; Fri, 09 Sep 2022 10:14:24 -0400
X-MC-Unique: WjP3YCgsM5i2Y973jzHmcQ-1
Received: by mail-wr1-f54.google.com with SMTP id n12so2970319wru.6;
 Fri, 09 Sep 2022 07:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=EHLk5JLupCfOQDOaEdc4GZZ8au442QLm7jBaaDEUvYU=;
 b=r4ctDlb1cLHoOb348L8EZmbWQQ/nuuySAInfUrdNsSRAjjLxw2v1TAL9PetB4IRdYm
 iqnhz4VmsaVZT2m5nfkNrl7icDUNlfF1WuSWCCOyy9ApxfnMEaYLjOmRk/I03Fdg8A7N
 IjVlkG9gOE/Pm2NgvCaHisdbMpP1tYg6HjV4f6HpaJJaGMEiXqUAHJqQSS49w45FtW8C
 d+22pWvCKtDM0I9Unns7tmhvBsRZNcsFEOOEufsO72avGt8ivsjSaHSJYzgJehp1rrLg
 UX/SP3YMmO9KABaqZDXRMksPRk7yqHpdO3apSHTI/aiwQe0nYUm4OK2cMfNbKXfgwVjd
 wO1w==
X-Gm-Message-State: ACgBeo1tjLqeDRK/xo7ZiNjpZuz10G0NJRZtP71mgUUXUbuu2XnIqmmq
 getZuRERNWEQL25DGoQFtuu2vVsSdbu9
X-Google-Smtp-Source: AA6agR7cbqonheBkSI6fF0dw3vPoSTM0pjabq1ufGMt/p/7y7XRq+74Fv9T5BuO6Kx6wBuvjlKH1Ow==
X-Received: by 2002:a5d:4745:0:b0:228:d9ec:6b5d with SMTP id
 o5-20020a5d4745000000b00228d9ec6b5dmr8294004wrs.257.1662732862381; 
 Fri, 09 Sep 2022 07:14:22 -0700 (PDT)
Received: from localhost ([84.39.183.42]) by smtp.gmail.com with ESMTPSA id
 z5-20020a05600c0a0500b003a540fef440sm1070390wmp.1.2022.09.09.07.14.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Sep 2022 07:14:21 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri,  9 Sep 2022 16:14:20 +0200
Message-Id: <20220909141420.23188-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v3] multipath-tools: add more info for NetApp
 RDAC arrays
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

To use ALUA mode:
"Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".

To use RDAC mode:
"Select operating system:" should be changed to "Linux DM-MP (Kernel 3.9 or earlier)".

Info from:
 https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-49E94674-947F-4921-A1D1-CE9B42DCBA39.html
 https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-CA17AE34-F5B2-4FF4-8FD4-4A7AA4238976.html
 https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-3DA657A9-FF4A-4237-90EC-BA8863B7431E.html

Add it to prio and hardware_handler.

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: delete "Automatic Load Balancing option" obsolete info
v3: a part of the body wa trimmed by git
---
 README.md                  | 2 +-
 multipath/multipath.conf.5 | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/README.md b/README.md
index b05b1332..45234dc6 100644
--- a/README.md
+++ b/README.md
@@ -165,7 +165,7 @@ To enable ALUA, the following options should be changed:
    "LUN Affinity" and "ALUA" should be changed to "Enable", "Redundancy Type"
    must be "Active-Active".
 
-- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM arrays:
+- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and rebranded arrays:
    "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".
 
 - NetApp ONTAP:
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index acdd1ae6..6018fa54 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -320,7 +320,7 @@ Generate the path priority for NetApp ONTAP class, and rebranded arrays.
 .I rdac
 (Hardware-dependent)
 Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp SANtricity
-E/EF Series, and rebranded arrays.
+E/EF Series and rebranded arrays, with "Linux DM-MP (Kernel 3.9 or earlier)" option.
 .TP
 .I hp_sw
 (Hardware-dependent)
@@ -1568,7 +1568,7 @@ with Failover Mode 1 (Passive Not Ready(PNR)).
 .I 1 rdac
 (Hardware-dependent)
 Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp SANtricity E/EF
-Series, and rebranded arrays.
+Series and rebranded arrays, with "Linux DM-MP (Kernel 3.9 or earlier)" option.
 .TP
 .I 1 hp_sw
 (Hardware-dependent)
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

