Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5BFEB64D9
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jun 2023 20:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686860090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UqaxToVVufi5j4LA0bSLwGqN2cyyHv3lyIY6YynmOvs=;
	b=IYZs7fjC+/TDxg2wvwVlKbfTVhbXkL6Wg/apMPSFTjPf7ginJdvQOEXB4CG4Zm0MrqfFBG
	5hWFvtnufnotURY2c2NVCFsszSSZtX5kDWZHOY+EJDSHTu0wxg3O6+s/fNbUVAf1j1DkVM
	hp8xXRqcps1arpFKrCL6SFq30nAz0GI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-508-MBfCAzhkNFO-nvOKPvGsjQ-1; Thu, 15 Jun 2023 16:14:47 -0400
X-MC-Unique: MBfCAzhkNFO-nvOKPvGsjQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DBC1800193;
	Thu, 15 Jun 2023 20:14:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1752148FB01;
	Thu, 15 Jun 2023 20:14:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E03AB1946594;
	Thu, 15 Jun 2023 20:14:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C14451946589
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Jun 2023 20:14:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 00D8C40D1B63; Thu, 15 Jun 2023 20:14:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EDF2440D1B60
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 20:14:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C79183C0DDBC
 for <dm-devel@redhat.com>; Thu, 15 Jun 2023 20:14:40 +0000 (UTC)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com
 [209.85.128.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-mm6NTK3uMcW6ysrxeGXiRw-1; Thu, 15 Jun 2023 16:14:38 -0400
X-MC-Unique: mm6NTK3uMcW6ysrxeGXiRw-1
Received: by mail-wm1-f51.google.com with SMTP id
 5b1f17b1804b1-3f8d5262dc8so623805e9.0; 
 Thu, 15 Jun 2023 13:14:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1686860077; x=1689452077;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=FaHPX8zQFTOHnqsBGAO1jvWsEkvTUOJreodQACulJg8=;
 b=akKQhwvwuB3noQLYMrMn3KfOWMh1a1QWaJX24SFvD/b0C2Soe+DkRaKI1oYExPcOuL
 9EpsQGhLLySvHiJStE33Z+hSsSUIKhhjoZ9V4MeL+eTZpxvcDrDjaKeiwrW6H93IE1Z2
 i8RxA0K/aJp79Z3ZhEfndFSQ6yXmKVSGeGzaxFp+QXsulVo8drl/43k0MWPsBT6+p3tF
 q8HqiJdePwNJb/hNaVgmOQIkS44XrnDqlffIb72pUNxjuCfRWqtnV+DX87zs4edoUC5U
 4PiK2f/yfJ4cITCxaNsA1dxDYcFtDU2uVkl4WycP6OAG1cqQf36a/NmeCP/M5WwpD4gR
 gHHg==
X-Gm-Message-State: AC+VfDy8nrVvql2ht6vsDnZbdphU9AhoEI7/7phMkYR7aVIcHzcd7AoO
 XMI0wgkrbsJwLU7hEo6g8A==
X-Google-Smtp-Source: ACHHUZ4xAm39bYAwX2sXnR2fMICSOFJJF3+Z2UWDJTW/ZZZ+blBwT0wUwLUSKmpHK4iNcfhMpqU9Qw==
X-Received: by 2002:a05:600c:203:b0:3f7:e660:cdc5 with SMTP id
 3-20020a05600c020300b003f7e660cdc5mr4805046wmi.9.1686860076980; 
 Thu, 15 Jun 2023 13:14:36 -0700 (PDT)
Received: from localhost (112.red-81-44-165.dynamicip.rima-tde.net.
 [81.44.165.112]) by smtp.gmail.com with ESMTPSA id
 s2-20020adfecc2000000b0030aed4223e0sm21636181wro.105.2023.06.15.13.14.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 15 Jun 2023 13:14:36 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Thu, 15 Jun 2023 22:14:34 +0200
Message-ID: <20230615201434.30482-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH] multipath-tools: fix syntax and spelling errors
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/multipath.conf.5 | 8 ++++----
 multipathd/main.c          | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 8a0ff0d8..c3a5f02f 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -243,26 +243,26 @@ The default is: \fBfailover\fR
 .
 .TP
 .B detect_pgpolicy
-If set to \fIyes\fR and all path devcices are configured with either the
+If set to \fIyes\fR and all path devices are configured with either the
 \fIalua\fR or \fIsysfs\fR prioritizer, the multipath device will automatically
 use the \fIgroup_by_prio\fR path_grouping_policy. If set to \fIno\fR, the
 path_grouping_policy will be selected as usual.
 .RS
 .TP
-The default is: \fIyes\fR
+The default is: \fByes\fR
 .RE
 .
 .
 .TP
 .B detect_pgpolicy_use_tpg
 If both this and \fIdetect_pgpolicy\fR are set to \fIyes\fR and all path
-devcices are configured with either the \fIalua\fR or \fIsysfs\fR prioritizer,
+devices are configured with either the \fIalua\fR or \fIsysfs\fR prioritizer,
 the multipath device will automatically use the \fIgroup_by_tpg\fR
 path_grouping_policy. If set to \fIno\fR, the path_grouping_policy will be
 selected by the method described for \fIdetect_pgpolicy\fR above.
 .RS
 .TP
-The default is: \fIno\fR
+The default is: \fBno\fR
 .RE
 .
 .
diff --git a/multipathd/main.c b/multipathd/main.c
index 6463d2b7..2e02a548 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -396,7 +396,7 @@ void put_multipath_config(__attribute__((unused)) void *arg)
 }
 
 /*
- * The path group orderings that this function finds acceptible are different
+ * The path group orderings that this function finds acceptable are different
  * from now select_path_group determines the best pathgroup. The idea here is
  * to only trigger a kernel reload when it is obvious that the pathgroups would
  * be out of order, even if all the paths were usable. Thus pathgroups with
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

