Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8B8C433F5
	for <dm-devel@archiver.kernel.org>; Sun,  9 Jan 2022 10:29:49 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-Ny1lapQWMjq81Q6fJtwJ1Q-1; Sun, 09 Jan 2022 05:29:44 -0500
X-MC-Unique: Ny1lapQWMjq81Q6fJtwJ1Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AA38801B0C;
	Sun,  9 Jan 2022 10:29:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F3D377A8D3;
	Sun,  9 Jan 2022 10:29:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CBBC74A7C9;
	Sun,  9 Jan 2022 10:29:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 209ATNTt029323 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 9 Jan 2022 05:29:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DD02A2166B14; Sun,  9 Jan 2022 10:29:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D76A22166B13
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 10:29:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF803811E76
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 10:29:19 +0000 (UTC)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
	[209.85.221.41]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-425-xUAEMezOOJKTqk28axDDpQ-1; Sun, 09 Jan 2022 05:29:16 -0500
X-MC-Unique: xUAEMezOOJKTqk28axDDpQ-1
Received: by mail-wr1-f41.google.com with SMTP id v6so20947090wra.8;
	Sun, 09 Jan 2022 02:29:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=HoSnsp9+XsDESK/B3kMi2Y0cey2XY3PZ0CkQxFNvsPE=;
	b=7Z/1r5xvAGNN4lBaV8Y5oSbSH2Ey7ltbfQpYEBnA/8Fq26wJnURpwrTnKrHtwMGV1x
	64fRb3qMH60d5gxRICSNsF/q7yAfCEZr/CqG0Hx/XzioPV59DLyTxWA5pzlsfXDq8x1v
	wrrDBuxvgmXmr3/tdzR1/IqyB62b4akR4FL9nbi5sDmvLdbHaGZsTCuD9yDoPX6ucmZC
	RSfxwCa3VoTrH5qyIpYore7eFohxgFbd/kuarORSvOaeNQ1mMj163BBYOSzehqQt2ybc
	GaotK4NdcbHikKbrskYz5AQ1N/zR9kz9vZk0tB6eeEOPnGfa+DRlTEssIwc+GGqT61Az
	/J2w==
X-Gm-Message-State: AOAM530nLNu49obsbKQoDwTUMiuJafuY5PehlF5CFtHx4E9XxD0NGluk
	JcZLfQQEKz6cvMkQq2xi4eU=
X-Google-Smtp-Source: ABdhPJwFhGazbH7/yHy60Cis1vM9nav3v3Xe9cnqfnJVyMcTs7rhpvWhoJE7im+7T9YHwPsmHroxnw==
X-Received: by 2002:a5d:64ee:: with SMTP id g14mr59839969wri.52.1641724154863; 
	Sun, 09 Jan 2022 02:29:14 -0800 (PST)
Received: from nz.home (host81-129-87-145.range81-129.btcentralplus.com.
	[81.129.87.145])
	by smtp.gmail.com with ESMTPSA id bi24sm293825wmb.9.2022.01.09.02.29.14
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 09 Jan 2022 02:29:14 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
	id F39D7190CB129; Sun,  9 Jan 2022 10:29:13 +0000 (GMT)
From: Sergei Trofimovich <slyich@gmail.com>
To: dm-devel@redhat.com
Date: Sun,  9 Jan 2022 10:29:07 +0000
Message-Id: <20220109102908.4102332-3-slyich@gmail.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Sergei Trofimovich <slyich@gmail.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/4] multipath-tools: autodiscover libudev.h
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

    $ pkg-config --variable=includedir libudev
    /nix/store/27mwkz5zhzw0gip8y7pvjyma5r0hzzaw-systemd-249.7-dev/include

The change switches libudev.h discovery to pkg-config provided path.

CC: Martin Wilck <mwilck@suse.com>
CC: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
---
 Makefile.inc          | 8 ++++++++
 libmultipath/Makefile | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 3b50395f..f5509db4 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -60,6 +60,14 @@ ifndef DEVMAPPER_INCDIR
 	endif
 endif
 
+ifndef LIBUDEV_INCDIR
+	ifeq ($(shell $(PKGCONFIG) --modversion libudev >/dev/null 2>&1 && echo 1), 1)
+		LIBUDEV_INCDIR = $(shell $(PKGCONFIG) --variable=includedir libudev)
+	else
+		LIBUDEV_INCDIR = /usr/include
+	endif
+endif
+
 prefix		=
 exec_prefix	= $(prefix)
 usr_prefix	= $(prefix)
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index be48775d..46972faf 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -33,7 +33,7 @@ ifneq ($(call check_func,dm_task_set_cookie,$(DEVMAPPER_INCDIR)/libdevmapper.h),
 	CFLAGS += -DLIBDM_API_COOKIE
 endif
 
-ifneq ($(call check_func,udev_monitor_set_receive_buffer_size,/usr/include/libudev.h),0)
+ifneq ($(call check_func,udev_monitor_set_receive_buffer_size,$(LIBUDEV_INCDIR)/libudev.h),0)
 	CFLAGS += -DLIBUDEV_API_RECVBUF
 endif
 
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

