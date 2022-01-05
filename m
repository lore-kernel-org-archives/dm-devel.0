Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE3EC433F5
	for <dm-devel@archiver.kernel.org>; Wed,  5 Jan 2022 22:30:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-OiZXjl-kPaiDFUjIP_P_XA-1; Wed, 05 Jan 2022 17:30:32 -0500
X-MC-Unique: OiZXjl-kPaiDFUjIP_P_XA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B309081CCB8;
	Wed,  5 Jan 2022 22:30:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 622EF55F64;
	Wed,  5 Jan 2022 22:30:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9BFBB1809CB8;
	Wed,  5 Jan 2022 22:30:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 205MUKou028324 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 5 Jan 2022 17:30:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 008B253D6; Wed,  5 Jan 2022 22:30:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF5E853D4
	for <dm-devel@redhat.com>; Wed,  5 Jan 2022 22:30:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D726485A5A8
	for <dm-devel@redhat.com>; Wed,  5 Jan 2022 22:30:19 +0000 (UTC)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com
	[209.85.128.43]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-251-uAe5F4keOFafIfQIVaBG-g-1; Wed, 05 Jan 2022 17:30:18 -0500
X-MC-Unique: uAe5F4keOFafIfQIVaBG-g-1
Received: by mail-wm1-f43.google.com with SMTP id
	p1-20020a1c7401000000b00345c2d068bdso2727785wmc.3; 
	Wed, 05 Jan 2022 14:30:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=B6PWrK+AcGV/g0hzf0u1m7IQru4Wry/heLpKGE7istw=;
	b=Oybvm/2QQX33B/B9VXbUe1Nt12NQBRQEh3PSty1Bvd9KhfVjoibX81qu9F8fXzEzeG
	o9SXtaII5IhmyUTcA8TovGEyLsHkvOjwGx3artf1k/lkrFiOKqqc+g7ZxIeczyz6f9IT
	mB8xpESeW5qtlmQMm/rmCpZ0S7jMK7YjsHEWxQkEchwfpxMP23uQ1edNdrW4+Fv5DOXa
	NA/Wvk0vlcreEl3Nz/5Blhq24nJy9yjUayvNEyGJajTx3TCI4dkN0l4QEBniivPzqUCu
	eOkwbmZsbKcy8Dgbsz3TVSvP9OteZqZ5UneYvR+QkHoLrtGoaxidc34HDFJo134lmwAf
	CO1g==
X-Gm-Message-State: AOAM530lSdOJsaOo06QFHJ/oxfZLks8cmizMwFygS8oacoyxp3fkADr4
	DHghkFiU1bLyiIq+NxMYKkc=
X-Google-Smtp-Source: ABdhPJx/4192ohi4+Ov29aGdsi5geMzYrSRXWiBSy5nCwHwcM1U6ou3RjtjFyZL6i4Kwsq2ipmUv5A==
X-Received: by 2002:a7b:c198:: with SMTP id y24mr4572130wmi.1.1641421816969;
	Wed, 05 Jan 2022 14:30:16 -0800 (PST)
Received: from nz.home (host81-129-87-145.range81-129.btcentralplus.com.
	[81.129.87.145]) by smtp.gmail.com with ESMTPSA id
	ay29sm3713283wmb.13.2022.01.05.14.30.16
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 05 Jan 2022 14:30:16 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
	id DB998183274EA; Wed,  5 Jan 2022 22:30:15 +0000 (GMT)
From: Sergei Trofimovich <slyich@gmail.com>
To: dm-devel@redhat.com
Date: Wed,  5 Jan 2022 22:30:13 +0000
Message-Id: <20220105223013.162599-1-slyich@gmail.com>
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
Subject: [dm-devel] [PATCH] kpartx/devmapper.c: fix unused variable error
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

Without the change the build fails as:

    devmapper.c:58:69: error: unused parameter 'udev_flags' [-Werror=unused-parameter]
       58 | int dm_simplecmd(int task, const char *name, int no_flush, uint16_t udev_flags)
          |                                                            ~~~~~~~~~^~~~~~~~~~

The change adds __attribute__((used)) annotation to unused function parameter.
CC: Martin Wilck <mwilck@suse.com>
CC: Benjamin Marzinski <bmarzins@redhat.com>
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

