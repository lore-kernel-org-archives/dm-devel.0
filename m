Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83981ECAAD3
	for <dm-devel@archiver.kernel.org>; Fri,  9 Sep 2022 22:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662762317;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oK+wIAglkkNywo8s6Tm+USfDIhakPFsI1VMzrxlZAzg=;
	b=VnkBzIMNArEhXMQ+HYqtpTJhWR5c719lhwQ9B7KR5Y1dXL7Dy3CcmInKg8R38CPugYTJLp
	tbqh5+LU6CdzZjjFG3WY9yG3g69O0OUJvrjZ0r6/ZCNXTWxE2/tPBsU5ruc7jIGjrC2MDR
	VRArZbcX8hTFOndowP5i8vInZUGx/4E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-v1RbV06NP-yHIiLgTK1QAg-1; Fri, 09 Sep 2022 18:25:14 -0400
X-MC-Unique: v1RbV06NP-yHIiLgTK1QAg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83966101A56C;
	Fri,  9 Sep 2022 22:25:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6E65492C3B;
	Fri,  9 Sep 2022 22:25:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 76DA31946A42;
	Fri,  9 Sep 2022 22:25:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 17E6A1946A41
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Sep 2022 22:25:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EC19A40B40C9; Fri,  9 Sep 2022 22:25:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E84DC400EAB6
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 22:25:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C72EE801755
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 22:25:08 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-244-3DsM2I7qNOWtaAzT4c7mKw-1; Fri, 09 Sep 2022 18:25:07 -0400
X-MC-Unique: 3DsM2I7qNOWtaAzT4c7mKw-1
Received: by mail-wm1-f45.google.com with SMTP id
 i203-20020a1c3bd4000000b003b3df9a5ecbso1001234wma.1; 
 Fri, 09 Sep 2022 15:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=s25tg5iTxgCGGV5DasIMkSxm4v2rmhXU+7rpfnoX8s8=;
 b=3jldaiAc5wClJA9sizxRYItyQm9rNNA9PB78VRFJJCpiLodBzJbxR+IMjuM2L3uy1N
 /zKRxtNISZ2ar2yhSm1O/y4HtcXkTNmhH8pILM0jyRdyQIVh7wbonZc78e70LN2w1rmr
 3/he+8FinZ0FGYGpYutpK1EONcXpgTSVqr9rk7HlTpoiNHgfUcHtked4SlqhbU455dLY
 3t6euPg7yGsPyI8nLIhgKguq27X5dDbs9CTct4qd0zObleIRf+pPr7FcYZ3NGDuPRETC
 x5ps94ksrd+lO6zNuAZiUT510TqUWByPK0+QIGsExky0cDtwuNS5Ka0Rn7sUNT6BzT0j
 JMRg==
X-Gm-Message-State: ACgBeo0DMno2ckJ1dgb566EjcZx8C3UFXhmmkegQ94qKJN5sIRYjjZOA
 uhyRlBj6zfwSoNAaPWGz7Q==
X-Google-Smtp-Source: AA6agR7DVRIkrX8KIATmD6/mWc0+VLtCdUgc1qkWB192jhi6fOZrjSVGfDKAY7xUA6ak2799ndTPpQ==
X-Received: by 2002:a05:600c:3c94:b0:3ae:ca8c:acfb with SMTP id
 bg20-20020a05600c3c9400b003aeca8cacfbmr6934041wmb.199.1662762305383; 
 Fri, 09 Sep 2022 15:25:05 -0700 (PDT)
Received: from localhost ([84.39.183.42]) by smtp.gmail.com with ESMTPSA id
 q15-20020a1ce90f000000b003a2f2bb72d5sm2017695wmc.45.2022.09.09.15.25.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Sep 2022 15:25:04 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sat, 10 Sep 2022 00:25:02 +0200
Message-Id: <20220909222502.42510-1-xose.vazquez@gmail.com>
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
Subject: [dm-devel] [PATCH] multipath-tools: update man pages with last
 modification date
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
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
 kpartx/kpartx.8                                | 2 +-
 libmpathpersist/mpath_persistent_reserve_in.3  | 2 +-
 libmpathpersist/mpath_persistent_reserve_out.3 | 2 +-
 mpathpersist/mpathpersist.8                    | 2 +-
 multipath/multipath.8                          | 2 +-
 multipath/multipath.conf.5                     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 08bb349b..2b144a7f 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -5,7 +5,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH KPARTX 8 2016-10-28 "Linux"
+.TH KPARTX 8 2019-04-27 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index 4691bdea..c168cae8 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -5,7 +5,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATH_PERSISTENT_RESERVE_IN 3 2016-11-01 "Linux"
+.TH MPATH_PERSISTENT_RESERVE_IN 3 2018-06-15 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index 55b00b00..f20be313 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -5,7 +5,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATH_PERSISTENT_RESERVE_OUT 3 2016-11-01 "Linux"
+.TH MPATH_PERSISTENT_RESERVE_OUT 3 2018-06-15 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/mpathpersist/mpathpersist.8 b/mpathpersist/mpathpersist.8
index 7b574592..d594422e 100644
--- a/mpathpersist/mpathpersist.8
+++ b/mpathpersist/mpathpersist.8
@@ -5,7 +5,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATHPERSIST 8 2019-05-27 "Linux"
+.TH MPATHPERSIST 8 2021-11-12 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 4c7e9885..88149d53 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -5,7 +5,7 @@
 .\"
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH 8 2018-10-10 "Linux"
+.TH MULTIPATH 8 2021-11-12 "Linux"
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 6018fa54..e098d555 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -6,7 +6,7 @@
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2021-09-08 Linux
+.TH MULTIPATH.CONF 5 2022-09-09 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.37.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

