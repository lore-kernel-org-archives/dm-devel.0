Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09625C433EF
	for <dm-devel@archiver.kernel.org>; Sun,  9 Jan 2022 09:28:47 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-wq03muCeNW2TxMs0BlCt1g-1; Sun, 09 Jan 2022 04:28:41 -0500
X-MC-Unique: wq03muCeNW2TxMs0BlCt1g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7F402F25;
	Sun,  9 Jan 2022 09:28:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 545191059156;
	Sun,  9 Jan 2022 09:28:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5D18E1809CB8;
	Sun,  9 Jan 2022 09:28:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2099SVtu026119 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 9 Jan 2022 04:28:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D6A94141DED5; Sun,  9 Jan 2022 09:28:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1CDC141DED4
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 09:28:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A63612BD19E6
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 09:28:31 +0000 (UTC)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com
	[209.85.128.50]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-240-hdU1zNfDPuOc8oJFXEc-qQ-1; Sun, 09 Jan 2022 04:28:27 -0500
X-MC-Unique: hdU1zNfDPuOc8oJFXEc-qQ-1
Received: by mail-wm1-f50.google.com with SMTP id e5so6854984wmq.1;
	Sun, 09 Jan 2022 01:28:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=t1xVF1F1zr4Yth8TJzz2zdxz3a/Aw0CnB3tJIxsb4e4=;
	b=y/YsX519sPUbUZWpE4ac7sTrlha90nhTu99n+k1zlc2DjS5qZIKaxvHaNc2QpD6TLI
	bMLM+UuhzyHp9W1Kk6n7H/ivrlQyesoQBn6g8BOfmJf1dsLEQ9U8RYKoNdEv3P5PY6Tp
	Rtb1k+VJvMzvMUXhpJwXJOFMCqPTNS2B4e7fW0sVZpNpLSw5aiUTnIqsaCQZX9Is4CJt
	fyGMnSvLQ52yJ2XWqVHkT9o+EwKnATpHvr2huBw/UVFUgfJaC48lViYu25MBQr94bOn/
	pqYIcBz4248Ea8EK+q9COx4Pez58t9o9kVxnF3EABejpzJxhtg1qgqs2CipGihZXMH7b
	Skug==
X-Gm-Message-State: AOAM531BsMiJv91/IrBoF6ZYQf39/0V144Av5NLlJE340YJ6s4Z1xXNz
	tEMFCWqZQ+LrEzxsyN39eL4=
X-Google-Smtp-Source: ABdhPJx4dLuiWtaoMCqKiZCjuomlGk9LYoX8rPFruNUa+SQaEj/fRdPay2sceRS7NjgdpJ7LFImSLg==
X-Received: by 2002:a05:600c:154f:: with SMTP id
	f15mr17912118wmg.62.1641720506517; 
	Sun, 09 Jan 2022 01:28:26 -0800 (PST)
Received: from nz.home (host81-129-87-145.range81-129.btcentralplus.com.
	[81.129.87.145])
	by smtp.gmail.com with ESMTPSA id v1sm4332969wru.45.2022.01.09.01.28.25
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 09 Jan 2022 01:28:26 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
	id AB3B3190747E2; Sun,  9 Jan 2022 09:28:24 +0000 (GMT)
From: Sergei Trofimovich <slyich@gmail.com>
To: dm-devel@redhat.com
Date: Sun,  9 Jan 2022 09:28:14 +0000
Message-Id: <20220109092814.1861416-2-slyich@gmail.com>
In-Reply-To: <20220109092814.1861416-1-slyich@gmail.com>
References: <c7b3fc9ddabf54cb7644b7bdaf7e9076ebbf34bb.camel@suse.com>
	<20220109092814.1861416-1-slyich@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Sergei Trofimovich <slyich@gmail.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 2/2] kpartx/devmapper.c: fix unused variable
	error
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Without the change the build fails as:

    devmapper.c:58:69: error: unused parameter 'udev_flags' [-Werror=unused-parameter]
       58 | int dm_simplecmd(int task, const char *name, int no_flush, uint16_t udev_flags)
          |                                                            ~~~~~~~~~^~~~~~~~~~

The change adds __attribute__((used)) annotation to unused function parameter.

CC: Martin Wilck <mwilck@suse.com>
CC: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
---
 kpartx/devmapper.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 511c090f..49ffd310 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -18,6 +18,12 @@
 #define MAX_PREFIX_LEN (_UUID_PREFIX_LEN + 4)
 #define PARAMS_SIZE 1024
 
+#ifdef LIBDM_API_COOKIE
+#    define __DM_API_COOKIE_UNUSED__ /* empty */
+#else
+#    define __DM_API_COOKIE_UNUSED__ __attribute__((unused))
+#endif
+
 int dm_prereq(char * str, uint32_t x, uint32_t y, uint32_t z)
 {
 	int r = 1;
@@ -55,7 +61,7 @@ out:
 	return r;
 }
 
-int dm_simplecmd(int task, const char *name, int no_flush, uint16_t udev_flags)
+int dm_simplecmd(int task, const char *name, int no_flush, __DM_API_COOKIE_UNUSED__ uint16_t udev_flags)
 {
 	int r = 0;
 #ifdef LIBDM_API_COOKIE
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

