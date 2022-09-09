Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FC0ECAAA1
	for <dm-devel@archiver.kernel.org>; Fri,  9 Sep 2022 14:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662732522;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SD04oaPlr2zKp7nzYzcuS/7CRR+a5cnAWcHE8RhFE8k=;
	b=aLe4LIkihds4jqToIpIKu/0u65fKN0qjELr7H3sveFlJdVFEffbjRbmSfPoT0OC0DnWHMl
	L1hUluJU1xRIE46RP8woGBvXlJ/RH2Kn1W2l29MwK3/8KwcEc7gy5EywquYHuRcG4By6SB
	rDdbSulcafW52oqWFa1KNmJiBH+EfC0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-554-AamKNjYNOv-0nzjYFafpRA-1; Fri, 09 Sep 2022 10:08:39 -0400
X-MC-Unique: AamKNjYNOv-0nzjYFafpRA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E7F185A58C;
	Fri,  9 Sep 2022 14:08:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AC029492C3B;
	Fri,  9 Sep 2022 14:08:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C4E71946A42;
	Fri,  9 Sep 2022 14:08:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E1411946A41
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Sep 2022 14:08:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 606F4400EA8F; Fri,  9 Sep 2022 14:08:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C7DD4011A3E
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 14:08:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 45D598041BE
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 14:08:32 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-612-l5c8uwUoOFakJK9RWtYjTw-1; Fri, 09 Sep 2022 10:08:27 -0400
X-MC-Unique: l5c8uwUoOFakJK9RWtYjTw-1
Received: by mail-wm1-f45.google.com with SMTP id
 m17-20020a7bce11000000b003a5bedec07bso4585355wmc.0; 
 Fri, 09 Sep 2022 07:08:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=wHA6KDu2damRqMmOMeN/DD+CCAZIiH0UcNTZ3AkTQU4=;
 b=5GyjtssNfcnvguvuCVfPGbJw34e95NL1zzxIS09TEqkMmxA0HDkXxPG0bgY70XmDF5
 fM08c1d+ZEQXJSqsluwEzEnIeaRgL0Wrs7BVmm+DG2Yd0gNOtnBtM7nveWoKlpZOz9Oa
 rVTrnJIuCMrKru9BjxY98ATunAK5AbTCop8buVzK8dPZBM+L2VxkJWd5jeEc+uDnmP84
 xgJDF6Ofncxi+yws9FS3xTIA/RN2mtVMQFEmOHcUKSynoCktDnsbHdW8oDLk7MHDqOcc
 7fTfn34p2Boj0XKV92bVo/RGK6hDAoQ+XRDQEA8ShQm06wbJB1eU8q1DE87ixtqOO8l0
 IjQA==
X-Gm-Message-State: ACgBeo2cG3ekKd/i3OCWDfSTHgXY84xMVR8A/BFP4n1vhDQW2Ia3JFZv
 2pCJXCcBM804yD6vt1H5L4hKCEQ5h7NO
X-Google-Smtp-Source: AA6agR7AdjstxU2Oo146AR5F+8fg6Qssqy9xI7YIQ+PMIDutpdioltd7onogLYq6H7CoctNVhNGwVw==
X-Received: by 2002:a05:600c:2159:b0:3b2:4e0:6aa3 with SMTP id
 v25-20020a05600c215900b003b204e06aa3mr5603810wml.159.1662732505564; 
 Fri, 09 Sep 2022 07:08:25 -0700 (PDT)
Received: from localhost ([84.39.183.42]) by smtp.gmail.com with ESMTPSA id
 g1-20020a056000118100b0022a2f4fa042sm568238wrx.103.2022.09.09.07.08.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Sep 2022 07:08:25 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Fri,  9 Sep 2022 16:08:23 +0200
Message-Id: <20220909140823.22918-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH v2] multipath-tools: add more info for NetApp
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

To use ALUA mode:
"Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or later)".

To use RDAC mode:
"Select operating system:" should be changed to "Linux DM-MP (Kernel 3.9 or earlier)".

Add it to prio and hardware_handler.

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
v2: delete "Automatic Load Balancing option" obsolete info
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

