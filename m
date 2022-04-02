Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC3C3C433EF
	for <dm-devel@archiver.kernel.org>; Sat,  2 Apr 2022 23:19:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-634-LzgpzykLP5W2_0c1y7amLg-1; Sat, 02 Apr 2022 19:19:21 -0400
X-MC-Unique: LzgpzykLP5W2_0c1y7amLg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8988C801585;
	Sat,  2 Apr 2022 23:19:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4ACD553373;
	Sat,  2 Apr 2022 23:19:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 362631940360;
	Sat,  2 Apr 2022 23:19:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 628B7194035F
 for <dm-devel@listman.corp.redhat.com>; Sat,  2 Apr 2022 23:19:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0DB6B553373; Sat,  2 Apr 2022 23:19:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 09DCB553361
 for <dm-devel@redhat.com>; Sat,  2 Apr 2022 23:18:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72F5B185A794
 for <dm-devel@redhat.com>; Sat,  2 Apr 2022 23:18:59 +0000 (UTC)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com
 [209.85.208.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-Dg4heMEVOYmJJeiP6BhsBA-1; Sat, 02 Apr 2022 19:18:57 -0400
X-MC-Unique: Dg4heMEVOYmJJeiP6BhsBA-1
Received: by mail-ed1-f42.google.com with SMTP id g22so6996717edz.2;
 Sat, 02 Apr 2022 16:18:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=fiV+0Q7yn6sZPLu9M76dM7vwkVMJdJIT2fEBTxfOMME=;
 b=DCWhbq1Otyiv7ju9Ybwhn9Fjzl0d2M+JjTIW/gxQpatXhqxD6KhObLqkHNcsc9VPBL
 tXsh28UzmnHtlbM8QE/OhnIdceYDbvQKK5j3lUuZMEDHGe6iQNIkm/BXyMlNcMRG/EgW
 cNYy0UW09DXZRBxnMfv6edFC1cILKvmfHDssJ5eOewbURBgVQH/VMsVt0/KMDW38Ukmr
 uRGf581b1dC5oYiY4mxD5RPu7AnpP52ZsxpiuP/DOn43q+z48F8l3ARz4uFUGuUBq/XR
 x0TyVF7VWfmHEbeWTiA5+K67jpR2VhV1xYJHBGlxUWqTP4fZM5B2NYz1yDxpKN/8X+EY
 oMww==
X-Gm-Message-State: AOAM531gQIcHatNXo7eiRyfBciAwAkNCy+8YSfSqbWsGpeMSsxP05pYM
 WWyWKNnTu6Kbnve3HPTLLA==
X-Google-Smtp-Source: ABdhPJxDNmQA8GnL5cwzMgUI7SaB97P8AwnKDAVqUxdteCDeluG3wlIlB6mL+uqtTD4DK8LiQW2L8w==
X-Received: by 2002:a05:6402:40ce:b0:41a:6817:5b07 with SMTP id
 z14-20020a05640240ce00b0041a68175b07mr26754245edb.7.1648941536366; 
 Sat, 02 Apr 2022 16:18:56 -0700 (PDT)
Received: from localhost (173.red-81-39-136.dynamicip.rima-tde.net.
 [81.39.136.173]) by smtp.gmail.com with ESMTPSA id
 x4-20020a170906b08400b006e493cb583esm2584285ejy.47.2022.04.02.16.18.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 02 Apr 2022 16:18:55 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun,  3 Apr 2022 01:18:54 +0200
Message-Id: <20220402231854.36956-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH] multipath-tools: remove duplicate headers
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
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
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
 libmultipath/foreign/nvme.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 838e1164..52ca56d8 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -23,7 +23,6 @@
 #include <stdlib.h>
 #include <string.h>
 #include <stdbool.h>
-#include <libudev.h>
 #include <pthread.h>
 #include <limits.h>
 #include <dirent.h>
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

