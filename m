Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D774C433FE
	for <dm-devel@archiver.kernel.org>; Sun,  9 Jan 2022 10:29:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-I7XGt_wdP5S_4VcX0QYocQ-1; Sun, 09 Jan 2022 05:29:30 -0500
X-MC-Unique: I7XGt_wdP5S_4VcX0QYocQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FDC5801B0C;
	Sun,  9 Jan 2022 10:29:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 812BB78342;
	Sun,  9 Jan 2022 10:29:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5A8071809CB8;
	Sun,  9 Jan 2022 10:29:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 209ATMLx029318 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 9 Jan 2022 05:29:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3BF64112131F; Sun,  9 Jan 2022 10:29:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 37B9F1121319
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 10:29:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B2F11C04B46
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 10:29:19 +0000 (UTC)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
	[209.85.128.44]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-134-JwVWiCUEMJuXIxAXGcWDcw-1; Sun, 09 Jan 2022 05:29:15 -0500
X-MC-Unique: JwVWiCUEMJuXIxAXGcWDcw-1
Received: by mail-wm1-f44.google.com with SMTP id
	n19-20020a7bc5d3000000b003466ef16375so8029790wmk.1; 
	Sun, 09 Jan 2022 02:29:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=rv0dyR2dh94ZCXCB2q6ogV7Yt9PpSDDmv9fP2+8192c=;
	b=KOaly7wSRMkocG0i08bab+cXzs3K9zHnjkQvi1sumc9ACamfPV4XwG/E6pYvgy8Ijk
	KB8mU3syh6IaCNZ4wqvJe1V7IicKJ75eGw7b5CZGEHmQJ0Qj7ILrBS0n6ncExPS2wEUw
	w+kkC00aDocT+x0pln/6Q0qDCLMkyhNJmQVdLbtxLd6BtbhhiMHDzPGzcFeWmoYzxPHP
	iA9t7ZtFXGUChPar79kGpIA10bpZnyTrL0rBTNwM2l2MecMZwA7+40QHn4PYpEJPMvMN
	Gj3zDEkp/fUWaigfbxYh6BRSWjbQaAPI+bBbAsxlyZ4YyJr3KNe4UfB4Xlkxo37NZqXr
	86Qg==
X-Gm-Message-State: AOAM533eJMn1FJBtWW5ZMAgAli/daZsghKWMD5NCURDcBewVrVwFt3nT
	5iBPGjdIO5aAsQjRjoeCEpSPR+3W3DI=
X-Google-Smtp-Source: ABdhPJzs4QkyBhJqM9cIPmtBF7fOBWndqp8e1YkYiSmKm+aTKAilUQ0TgjJ7ETLbFs3bIk9NV7lNLQ==
X-Received: by 2002:a05:600c:3b18:: with SMTP id
	m24mr3192235wms.4.1641724154009; 
	Sun, 09 Jan 2022 02:29:14 -0800 (PST)
Received: from nz.home (host81-129-87-145.range81-129.btcentralplus.com.
	[81.129.87.145]) by smtp.gmail.com with ESMTPSA id
	l13sm4213585wrs.73.2022.01.09.02.29.13
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 09 Jan 2022 02:29:13 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
	id 0EA0B190CB127; Sun,  9 Jan 2022 10:29:13 +0000 (GMT)
From: Sergei Trofimovich <slyich@gmail.com>
To: dm-devel@redhat.com
Date: Sun,  9 Jan 2022 10:29:06 +0000
Message-Id: <20220109102908.4102332-2-slyich@gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Sergei Trofimovich <slyich@gmail.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/4] multipath-tools: autodiscover libdevmapper.h
	headers
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

On NixOS nothing is installed in /usr/include and instead lives
in it's own prefix. pkg-config variables are expected to be used
for installation discovery:

    $ pkg-config --variable=includedir devmapper
    /nix/store/c30fr0ahpa285sjkjgiinc2rr68ysmid-lvm2-2.03.14-dev/include

The change switches libdevmapper.h discovery to pkg-config provided path.

CC: Martin Wilck <mwilck@suse.com>
CC: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
---
 Makefile.inc          |  8 ++++++++
 kpartx/Makefile       |  2 +-
 libmultipath/Makefile | 10 +++++-----
 multipathd/Makefile   |  2 +-
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 59856f24..3b50395f 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -52,6 +52,14 @@ ifndef SYSTEMDPATH
 	SYSTEMDPATH=usr/lib
 endif
 
+ifndef DEVMAPPER_INCDIR
+	ifeq ($(shell $(PKGCONFIG) --modversion devmapper >/dev/null 2>&1 && echo 1), 1)
+		DEVMAPPER_INCDIR = $(shell $(PKGCONFIG) --variable=includedir devmapper)
+	else
+		DEVMAPPER_INCDIR = /usr/include
+	endif
+endif
+
 prefix		=
 exec_prefix	= $(prefix)
 usr_prefix	= $(prefix)
diff --git a/kpartx/Makefile b/kpartx/Makefile
index 9be115d6..d2943a99 100644
--- a/kpartx/Makefile
+++ b/kpartx/Makefile
@@ -8,7 +8,7 @@ LDFLAGS += $(BIN_LDFLAGS)
 
 LIBDEPS += -ldevmapper
 
-ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),0)
+ifneq ($(call check_func,dm_task_set_cookie,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index d4af1a54..be48775d 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -21,15 +21,15 @@ ifdef SYSTEMD
 	endif
 endif
 
-ifneq ($(call check_func,dm_task_no_flush,/usr/include/libdevmapper.h),0)
+ifneq ($(call check_func,dm_task_no_flush,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_FLUSH -D_GNU_SOURCE
 endif
 
-ifneq ($(call check_func,dm_task_get_errno,/usr/include/libdevmapper.h),0)
+ifneq ($(call check_func,dm_task_get_errno,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_GET_ERRNO
 endif
 
-ifneq ($(call check_func,dm_task_set_cookie,/usr/include/libdevmapper.h),0)
+ifneq ($(call check_func,dm_task_set_cookie,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
@@ -37,11 +37,11 @@ ifneq ($(call check_func,udev_monitor_set_receive_buffer_size,/usr/include/libud
 	CFLAGS += -DLIBUDEV_API_RECVBUF
 endif
 
-ifneq ($(call check_func,dm_task_deferred_remove,/usr/include/libdevmapper.h),0)
+ifneq ($(call check_func,dm_task_deferred_remove,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_DEFERRED
 endif
 
-ifneq ($(call check_func,dm_hold_control_dev,/usr/include/libdevmapper.h),0)
+ifneq ($(call check_func,dm_hold_control_dev,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_HOLD_CONTROL
 endif
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 64df2214..5f4ef6c2 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -1,6 +1,6 @@
 include ../Makefile.inc
 
-ifneq ($(call check_func,dm_task_get_errno,/usr/include/libdevmapper.h),0)
+ifneq ($(call check_func,dm_task_get_errno,$(DEVMAPPER_INCDIR)/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_GET_ERRNO
 endif
 
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

