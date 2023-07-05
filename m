Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0226FEB64DD
	for <dm-devel@archiver.kernel.org>; Wed,  5 Jul 2023 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688577526;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=B9jTWdWsPYbB1sSlEkGxWMi+AEeiL8ZIRqg39JiNWns=;
	b=aqdee+5C3cg5txE9vP/cK0FoVR+bGXg7QwNwULTgXjTKJjawX4WqQ1l5zUg1kUWLXXrTrz
	pCEUJdodshuUO3auLu76qpW/K3670pcPrB7b1Il1x/km/uKoGmebXWF/ToRoTpR4+wtmNt
	qdYOh9HcijzA/5WJZiaB/UFE905Ey74=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-Ccx8yO6KPvSBLhvKit47PA-1; Wed, 05 Jul 2023 13:18:43 -0400
X-MC-Unique: Ccx8yO6KPvSBLhvKit47PA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D24281C29AEA;
	Wed,  5 Jul 2023 17:18:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD38C40C2063;
	Wed,  5 Jul 2023 17:18:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 823201946589;
	Wed,  5 Jul 2023 17:18:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2BA011946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  5 Jul 2023 17:18:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D62FCF6401; Wed,  5 Jul 2023 17:18:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CD85118EB4
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 17:18:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A365F2932484
 for <dm-devel@redhat.com>; Wed,  5 Jul 2023 17:18:35 +0000 (UTC)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-UkSaYDhBNCSZlhea_-a6QQ-1; Wed, 05 Jul 2023 13:18:31 -0400
X-MC-Unique: UkSaYDhBNCSZlhea_-a6QQ-1
Received: by mail-wm1-f49.google.com with SMTP id
 5b1f17b1804b1-3fbc0609cd6so70221995e9.1; 
 Wed, 05 Jul 2023 10:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1688577510; x=1691169510;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=SgF0LRQEXktdPPNQCkPLGVSb5TbyO8qdUZM72o1HPMw=;
 b=itgR8jQWXXEbWh3hV3BdvunPes7upXtw7iJnf5RpYFkPf6BO91VpnQOxvZWzD3rCI+
 LyRDMASmVjWdz3dGANgEufCGdA3CWlDPzsj5tcR/u6CEotXZeh8TsEt4jd4LI3mLbG3F
 R3ycEMP7OX1Mj+WUtJdTyyIkDV5lNOSZlO7M2lQMv5K1mC8UKoF3jtA6wj0k9K7VGxO5
 Ry56xN/V3bZ5JMCP/HJQ+gEra9FOoSd3nypb20pI9Hsuu+8kXZcnNEvebBx/S4eS0mBF
 qIYqLdyvrqMylH+kwe0xecrFYuxCH2jX1l/5XRvF9uvpzV/4pZZAoNquB1+3vT8LLocN
 diVw==
X-Gm-Message-State: AC+VfDyUcRFUTguSHQA4JvsMiKrpdgEH5NDPS9rimpPLOyiD44Dl2wB1
 b4zJ1oI1elN/gQ0n43jooVl0cHbDk0xq
X-Google-Smtp-Source: ACHHUZ5tQ3aV1ge2bav/GKkghapiT6YeqsBoaazZoTd3kRtIyH7+HS4KP91sDzcEB9lOpEBcdK032w==
X-Received: by 2002:a05:600c:3655:b0:3fa:962e:e8f4 with SMTP id
 y21-20020a05600c365500b003fa962ee8f4mr12796691wmq.26.1688577509777; 
 Wed, 05 Jul 2023 10:18:29 -0700 (PDT)
Received: from localhost (118.red-88-28-21.dynamicip.rima-tde.net.
 [88.28.21.118]) by smtp.gmail.com with ESMTPSA id
 p13-20020a05600c204d00b003f605566610sm2700892wmg.13.2023.07.05.10.18.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 05 Jul 2023 10:18:28 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Wed,  5 Jul 2023 19:18:24 +0200
Message-ID: <20230705171826.11695-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH] multipath-tools: fix docs
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gmail.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Mainly; add multipathc info, and info to check man pages  

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README.md                                      | 1 +
 kpartx/kpartx.8                                | 5 +++--
 libmpathpersist/mpath_persistent_reserve_in.3  | 5 +++--
 libmpathpersist/mpath_persistent_reserve_out.3 | 5 +++--
 mpathpersist/mpathpersist.8                    | 5 +++--
 multipath/multipath.8                          | 5 +++--
 multipath/multipath.conf.5                     | 5 +++--
 multipathd/multipathc.8                        | 5 +++--
 multipathd/multipathd.8                        | 3 ++-
 9 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/README.md b/README.md
index 5e04f5c3..a7f994ae 100644
--- a/README.md
+++ b/README.md
@@ -8,6 +8,7 @@ https://github.com/opensvc/multipath-tools
 This package provides the following binaries to drive the Device Mapper multipathing driver:
 
 * multipath - Device mapper target autoconfig.
+* multipathc - Interactive client for multipathd.
 * multipathd - Multipath daemon.
 * mpathpersist - Manages SCSI persistent reservations on dm multipath devices.
 * kpartx - Create device maps from partition tables.
diff --git a/kpartx/kpartx.8 b/kpartx/kpartx.8
index 2b144a7f..ef8051a5 100644
--- a/kpartx/kpartx.8
+++ b/kpartx/kpartx.8
@@ -1,11 +1,12 @@
 .\" ----------------------------------------------------------------------------
-.\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t kpartx/kpartx.8
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z  kpartx/kpartx.8 > /dev/null
 .\"
+.\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH KPARTX 8 2019-04-27 "Linux"
+.TH KPARTX 8 2019-04-27 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_in.3 b/libmpathpersist/mpath_persistent_reserve_in.3
index c168cae8..2f9b8f79 100644
--- a/libmpathpersist/mpath_persistent_reserve_in.3
+++ b/libmpathpersist/mpath_persistent_reserve_in.3
@@ -1,11 +1,12 @@
 .\" ----------------------------------------------------------------------------
-.\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_in.3
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z libmpathpersist/mpath_persistent_reserve_in.3 > /dev/null
 .\"
+.\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATH_PERSISTENT_RESERVE_IN 3 2018-06-15 "Linux"
+.TH MPATH_PERSISTENT_RESERVE_IN 3 2018-06-15 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/libmpathpersist/mpath_persistent_reserve_out.3 b/libmpathpersist/mpath_persistent_reserve_out.3
index f20be313..d3204c56 100644
--- a/libmpathpersist/mpath_persistent_reserve_out.3
+++ b/libmpathpersist/mpath_persistent_reserve_out.3
@@ -1,11 +1,12 @@
 .\" ----------------------------------------------------------------------------
-.\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t libmpathpersist/mpath_persistent_reserve_out.3
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z libmpathpersist/mpath_persistent_reserve_out.3 > /dev/null
 .\"
+.\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATH_PERSISTENT_RESERVE_OUT 3 2018-06-15 "Linux"
+.TH MPATH_PERSISTENT_RESERVE_OUT 3 2018-06-15 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/mpathpersist/mpathpersist.8 b/mpathpersist/mpathpersist.8
index d594422e..8d26b37c 100644
--- a/mpathpersist/mpathpersist.8
+++ b/mpathpersist/mpathpersist.8
@@ -1,11 +1,12 @@
 .\" ----------------------------------------------------------------------------
-.\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t mpathpersist/mpathpersist.8
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z mpathpersist/mpathpersist.8 > /dev/null
 .\"
+.\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MPATHPERSIST 8 2021-11-12 "Linux"
+.TH MPATHPERSIST 8 2021-11-12 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/multipath/multipath.8 b/multipath/multipath.8
index 88149d53..5fed6df7 100644
--- a/multipath/multipath.8
+++ b/multipath/multipath.8
@@ -1,11 +1,12 @@
 .\" ----------------------------------------------------------------------------
-.\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t multipath/multipath.8
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.8 > /dev/null
 .\"
+.\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH 8 2021-11-12 "Linux"
+.TH MULTIPATH 8 2021-11-12 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index c3a5f02f..93af17db 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -1,12 +1,12 @@
 .\" ----------------------------------------------------------------------------
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t multipath/multipath.conf.5
-.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5 >/dev/null
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipath/multipath.conf.5 > /dev/null
 .\"
 .\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
-.TH MULTIPATH.CONF 5 2022-10-01 Linux
+.TH MULTIPATH.CONF 5 2023-06-15 Linux
 .
 .
 .\" ----------------------------------------------------------------------------
@@ -1991,6 +1991,7 @@ specified the order of precedence is \fIno_path_retry, queue_if_no_path, dev_los
 .BR udev (8),
 .BR dmsetup (8),
 .BR multipath (8),
+.BR multipathc (8),
 .BR multipathd (8).
 .
 .
diff --git a/multipathd/multipathc.8 b/multipathd/multipathc.8
index 6c57c6cc..cf7ae5be 100644
--- a/multipathd/multipathc.8
+++ b/multipathd/multipathc.8
@@ -1,8 +1,9 @@
 .\" ----------------------------------------------------------------------------
-.\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
-.\" groff -z -wall -b -e -t multipathd/multipathd.8
+.\" groff -z -wall -b -e -t multipathd/multipathc.8
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathc.8 > /dev/null
 .\"
+.\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
 .TH MULTIPATHC 8 2022-09-03 Linux
diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index bdf102eb..cc72b775 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -1,8 +1,9 @@
 .\" ----------------------------------------------------------------------------
-.\" Update the date below if you make any significant change.
 .\" Make sure there are no errors with:
 .\" groff -z -wall -b -e -t multipathd/multipathd.8
+.\" man --warnings -E UTF-8 -l -Tutf8 -Z multipathd/multipathd.8 > /dev/null
 .\"
+.\" Update the date below if you make any significant change.
 .\" ----------------------------------------------------------------------------
 .
 .TH MULTIPATHD 8 2022-09-03 Linux
-- 
2.41.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

