Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8987AC433EF
	for <dm-devel@archiver.kernel.org>; Wed,  1 Jun 2022 07:10:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-4X-d-amcMpOI6sbDvsVYNw-1; Wed, 01 Jun 2022 03:10:25 -0400
X-MC-Unique: 4X-d-amcMpOI6sbDvsVYNw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 010CF1D32371;
	Wed,  1 Jun 2022 07:10:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6F7B7492CA2;
	Wed,  1 Jun 2022 07:10:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 97E8A194707C;
	Wed,  1 Jun 2022 07:10:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E1D31947065
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 May 2022 16:15:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6FF161121315; Tue, 31 May 2022 16:15:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C6741121314
 for <dm-devel@redhat.com>; Tue, 31 May 2022 16:15:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 519E680B71A
 for <dm-devel@redhat.com>; Tue, 31 May 2022 16:15:05 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-572-uu4DbOchPViPyw1mBU_7NQ-1; Tue, 31 May 2022 12:15:03 -0400
X-MC-Unique: uu4DbOchPViPyw1mBU_7NQ-1
Received: by mail-wm1-f45.google.com with SMTP id
 r123-20020a1c2b81000000b0039c1439c33cso1482487wmr.5; 
 Tue, 31 May 2022 09:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=GBVGXc+1SeVm8+Dhr1BGRRweZbVkKpH/bDYOi0S9+xI=;
 b=FJ7u1nr0mopx3ReIJRKIicW/9kDMYNs9tHVwGT3gQ/1wDXHMgGURiCAH/eU0nm91ET
 uiqrTXQyugnCJbWXelS84WCU/nZW+5QAjsDJJwpV8eLFgndwQIyB4fQCEyZvjsGznWeb
 G1atK+QVmMJ0n5M2iEDZGEhe3UFHBy6ilNKZX/bBCsqQstlQ4APteVRK3EYi1JBjjmxe
 rt3pIs9tq1Z06T7Wbtdy6c6iSma4EeKhIFmrtprbBewjRrKdWubJBu9rzUAbifuDXY8k
 /uJdZhEPIsqBuu1bJCn2LsNlOBZs4+uGjbGr6eaySliaiIVT7RHYr7Qxd2G3VaEEs3+B
 l86Q==
X-Gm-Message-State: AOAM532IkL4NK/3dYjfSLoi3yViW+gEdSD1aCXD6sIXv9j/XAr4zoyEK
 x0ZyI5NcJ+btD7KPMc6R56A/kCTDqxo=
X-Google-Smtp-Source: ABdhPJw4g+iNLaRfFvHUC1tQE80ssPGpZq3EN1SonBUuB3Ynm8f3geQDIYVxJRBciQ8tQW1hn+l9mg==
X-Received: by 2002:a7b:c2e8:0:b0:397:4a00:6955 with SMTP id
 e8-20020a7bc2e8000000b003974a006955mr24464732wmk.74.1654013701507; 
 Tue, 31 May 2022 09:15:01 -0700 (PDT)
Received: from kali.home (2a01cb088e0b5b002be75de2a1caa253.ipv6.abo.wanadoo.fr.
 [2a01:cb08:8e0b:5b00:2be7:5de2:a1ca:a253])
 by smtp.gmail.com with ESMTPSA id
 t4-20020adfdc04000000b0021024f82e01sm9151392wri.16.2022.05.31.09.15.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 31 May 2022 09:15:01 -0700 (PDT)
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
To: dm-devel@redhat.com
Date: Tue, 31 May 2022 18:12:30 +0200
Message-Id: <20220531161230.3820698-1-fontaine.fabrice@gmail.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 01 Jun 2022 07:10:21 +0000
Subject: [dm-devel] [PATCH] multipathd/fpin_handlers.c: include stdint.h
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
Cc: mwilck@suse.com, Fabrice Fontaine <fontaine.fabrice@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Include stdint.h to avoid the following build failure since version
0.8.9 and commit cfff03efbca753ef485ad717087464dced9c721a:

In file included from /nvmedata/autobuild/instance-7/output-1/host/nios2-buildroot-linux-gnu/sysroot/usr/include/scsi/scsi_netlink_fc.h:25,
                 from fpin_handlers.c:6:
/nvmedata/autobuild/instance-7/output-1/host/nios2-buildroot-linux-gnu/sysroot/usr/include/scsi/scsi_netlink.h:44:2: error: unknown type name 'uint8_t'
   44 |  uint8_t version;
      |  ^~~~~~~

Fixes:
 - http://autobuild.buildroot.org/results/32f4ada6c49261924ca78f62dee43241bda379a3

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 multipathd/fpin_handlers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index aaf5655d..384ae318 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -1,5 +1,6 @@
 #include <errno.h>
 #include <unistd.h>
+#include <stdint.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <libudev.h>
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

