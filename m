Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40078C433EF
	for <dm-devel@archiver.kernel.org>; Sun,  9 Jan 2022 09:28:43 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-dVkGHzTcM3u73tWjh8Y03Q-1; Sun, 09 Jan 2022 04:28:40 -0500
X-MC-Unique: dVkGHzTcM3u73tWjh8Y03Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BD311083F60;
	Sun,  9 Jan 2022 09:28:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50EE673179;
	Sun,  9 Jan 2022 09:28:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D97C54BB7C;
	Sun,  9 Jan 2022 09:28:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2099STdk026102 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 9 Jan 2022 04:28:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5536046D1FB; Sun,  9 Jan 2022 09:28:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 518C846D1FC
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 09:28:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37AC7801E95
	for <dm-devel@redhat.com>; Sun,  9 Jan 2022 09:28:29 +0000 (UTC)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com
	[209.85.128.46]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-650-jyL46-l1MmGhqGKA4Gxk-w-1; Sun, 09 Jan 2022 04:28:27 -0500
X-MC-Unique: jyL46-l1MmGhqGKA4Gxk-w-1
Received: by mail-wm1-f46.google.com with SMTP id
	n19-20020a7bc5d3000000b003466ef16375so7981284wmk.1; 
	Sun, 09 Jan 2022 01:28:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references:mime-version:content-transfer-encoding;
	bh=TigAoZNQRpZ1abKYEFzFvrbPxubVlQzk0jsEOy7VYpw=;
	b=E65HxLpk5Zg/uWumOee/7lvQY2wxA3JRkPp0VJWCf+jYR1AX3DTNxKZ7iP8gOB6FCD
	UKMhEkW6lYNnFIAyrlcFXv9lALHaoPsk6oaD2FGjkoPcBwSKVQpZA5RdS5ECibYcsONK
	x9CZpMwgB5ztFIus7mL+BcuVzicCh2NcJneHph3ztlv+jkuU7iQFSidMr0qaJMBXNg2X
	uIBhiRwJvQKKv8tfHWNJifk5DTsoC3jnUneBte+Zv4h3hMtgeV8GmjBhHzyGpUVjiuFU
	LUkSpsC7g4UFXKki5Vaw+Tid+Tq7rLLw6muZut3kOjTM2RJwzmcc24zcJWTT3CyzELm5
	syng==
X-Gm-Message-State: AOAM533zHYKshuEByy6vWgVwtJ9O2MWLW/L6tIcz/VeV6u7lahNHvKKP
	zttsnzTKh890lGxPyrnVCDAw2J+VlNs=
X-Google-Smtp-Source: ABdhPJwdgMlCKT0MtCXS7/JV2uaMYOfP5hVEaGL5BnsMUh1atPgGumSA2getcyK0WtyMTnH8u7Iiog==
X-Received: by 2002:a1c:f706:: with SMTP id v6mr17383907wmh.140.1641720506093; 
	Sun, 09 Jan 2022 01:28:26 -0800 (PST)
Received: from nz.home (host81-129-87-145.range81-129.btcentralplus.com.
	[81.129.87.145])
	by smtp.gmail.com with ESMTPSA id n7sm3521390wms.46.2022.01.09.01.28.24
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Sun, 09 Jan 2022 01:28:25 -0800 (PST)
Received: by nz.home (Postfix, from userid 1000)
	id F02CD190747DF; Sun,  9 Jan 2022 09:28:23 +0000 (GMT)
From: Sergei Trofimovich <slyich@gmail.com>
To: dm-devel@redhat.com
Date: Sun,  9 Jan 2022 09:28:13 +0000
Message-Id: <20220109092814.1861416-1-slyich@gmail.com>
In-Reply-To: <c7b3fc9ddabf54cb7644b7bdaf7e9076ebbf34bb.camel@suse.com>
References: <c7b3fc9ddabf54cb7644b7bdaf7e9076ebbf34bb.camel@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-loop: dm-devel@redhat.com
Cc: Sergei Trofimovich <slyich@gmail.com>, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 1/2] kpartx/devmapper.c: fix unused-but-set
	variable error
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

On gcc-12 build failed as:

    devmapper.c: In function 'dm_simplecmd':
    devmapper.c:61:13: error: unused variable 'udev_wait_flag' [-Werror=unused-variable]
       61 |         int udev_wait_flag = (task == DM_DEVICE_RESUME ||
          |             ^~~~~~~~~~~~~~

Fix error by hiding it's declaration under #ifdef that uses it.

CC: Martin Wilck <mwilck@suse.com>
CC: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sergei Trofimovich <slyich@gmail.com>
---
 kpartx/devmapper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 3efd6dfc..511c090f 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -58,9 +58,9 @@ out:
 int dm_simplecmd(int task, const char *name, int no_flush, uint16_t udev_flags)
 {
 	int r = 0;
+#ifdef LIBDM_API_COOKIE
 	int udev_wait_flag = (task == DM_DEVICE_RESUME ||
 			      task == DM_DEVICE_REMOVE);
-#ifdef LIBDM_API_COOKIE
 	uint32_t cookie = 0;
 #endif
 	struct dm_task *dmt;
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

