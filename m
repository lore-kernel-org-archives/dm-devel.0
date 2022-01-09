Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68952C433F5
	for <dm-devel@archiver.kernel.org>; Sun,  9 Jan 2022 10:29:33 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-fbUPmKeJOiy0LpDHJN6c-g-1; Sun, 09 Jan 2022 05:29:28 -0500
X-MC-Unique: fbUPmKeJOiy0LpDHJN6c-g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE6372F24;
	Sun,  9 Jan 2022 10:29:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C05DA1F424;
	Sun,  9 Jan 2022 10:29:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 16A8A4CA93;
	Sun,  9 Jan 2022 10:29:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 209ATLG7029313 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 9 Jan 2022 05:29:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 85CC353C9; Sun,  9 Jan 2022 10:29:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80B2253B3
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 10:29:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 904421035AE1
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 10:29:18 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
	[209.85.221.49]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-66-N1afjJcUOjmuWFGaiiaKaw-1; Sun, 09 Jan 2022 05:29:16 -0500
X-MC-Unique: N1afjJcUOjmuWFGaiiaKaw-1
Received: by mail-wr1-f49.google.com with SMTP id s1so21035512wra.6;
	Sun, 09 Jan 2022 02:29:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=hhYC0MG2Bg8jy/J58to+5Ci4m/j/vXamnf+hcKQPaPI=;
	b=LA8CYmRaSbAWpTiwX+dMBVJRAQBrioapUlnswzr+8M0EfW0DuQ5Ci1O+VaxIt9w24I
	WJ9Ae0Zez/TF/Nm5eZlm86YO7vMDw0oGtnlR8Dwm0I1aODQsBQbqGcRa7HzJM7vt6JID
	npsoQpvIAdwJAo132Y32UCeWsZwmJZDk8Uc//LEBJ5UkobRwVZ0h2Zq1SbfIenWdpSZv
	+7NnjS/08KudqYiGKa9W3c7ilflPAce0ILl8ylQXTnJDsjPDfdPtSZAr85CqSSyatEsH
	CBECMYQw5fqBdlpZPz+ssINTQRkmbQnuQ/VDz2J56r7MWXKcEm7YuRX+5rlPmW2qkuYI
	jLUQ==
X-Gm-Message-State: AOAM532p6G/xDsKM7RluMTZz95fRk7unuEWGhgh0dOa88WB+0FOylCU6
	J80J0OEPg3fUuysBQJl/g/o=
X-Google-Smtp-Source: ABdhPJzsndBXmDMaCPdCsGgasOsDQkek9D/2FBE02lfnJfIhk38pzQH/z1b6yFdJthmGQbUSbgs0tg==
X-Received: by 2002:a05:6000:3c1:: with SMTP id
	b1mr59891543wrg.394.1641724155522; 
	Sun, 09 Jan 2022 02:29:15 -0800 (PST)
Received: from nz.home (host81-129-87-145.range81-129.btcentralplus.com.
	[81.129.87.145]) by smtp.gmail.com with ESMTPSA id
	l26sm3947304wms.24.2022.01.09.02.29.15
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 09 Jan 2022 02:29:15 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
	id 9F66D190CB12C; Sun,  9 Jan 2022 10:29:14 +0000 (GMT)
From: Sergei Trofimovich <slyich@gmail.com>
To: dm-devel@redhat.com
Date: Sun,  9 Jan 2022 10:29:08 +0000
Message-Id: <20220109102908.4102332-4-slyich@gmail.com>
In-Reply-To: <20220109102908.4102332-1-slyich@gmail.com>
References: <20220109102908.4102332-1-slyich@gmail.com>
MIME-Version: 1.0
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
Cc: Sergei Trofimovich <slyich@gmail.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 4/4] multipath-tools: allow passing non-standard
	linux-headers location
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On NixOS nothing is installed in /usr/include and instead lives
in it's own prefix.

The change switches linux/nvme_ioctl.h discovery to user provided path.

CC: Martin Wilck <mwilck@suse.com>
CC: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
---
 Makefile.inc                       | 5 +++++
 libmultipath/prioritizers/Makefile | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index f5509db4..a7d16dfd 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -68,6 +68,11 @@ ifndef LIBUDEV_INCDIR
 	endif
 endif
 
+# Allow user to override default location.
+ifndef LINUX_HEADERS_INCDIR
+	LINUX_HEADERS_INCDIR = /usr/include
+endif
+
 prefix		=
 exec_prefix	= $(prefix)
 usr_prefix	= $(prefix)
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index 8d34ae32..16c63977 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -23,7 +23,7 @@ LIBS = \
 	libpriopath_latency.so \
 	libpriosysfs.so
 
-ifneq ($(call check_file,/usr/include/linux/nvme_ioctl.h),0)
+ifneq ($(call check_file,$(LINUX_HEADERS_INCDIR)/linux/nvme_ioctl.h),0)
 	LIBS += libprioana.so
 	CFLAGS += -I../nvme
 endif
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

