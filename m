Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A104AC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 28 Mar 2022 06:44:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-4t-BZQJhOtyTlZrxPwG_eQ-1; Mon, 28 Mar 2022 02:44:01 -0400
X-MC-Unique: 4t-BZQJhOtyTlZrxPwG_eQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CC441C05ABD;
	Mon, 28 Mar 2022 06:44:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D899140CF8FA;
	Mon, 28 Mar 2022 06:43:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3217C19451F3;
	Mon, 28 Mar 2022 06:43:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 15E9C19451EF
 for <dm-devel@listman.corp.redhat.com>; Sun, 27 Mar 2022 05:37:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C325FC080AF; Sun, 27 Mar 2022 05:37:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BF19AC08F11
 for <dm-devel@redhat.com>; Sun, 27 Mar 2022 05:37:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A639D811E75
 for <dm-devel@redhat.com>; Sun, 27 Mar 2022 05:37:53 +0000 (UTC)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-xfOK74nYNOKU2FPhZ9_4Fw-1; Sun, 27 Mar 2022 01:37:50 -0400
X-MC-Unique: xfOK74nYNOKU2FPhZ9_4Fw-1
Received: by mail-pg1-f173.google.com with SMTP id c2so9741244pga.10;
 Sat, 26 Mar 2022 22:37:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=YdydescwhQudHUcMwcRf7BOVetd8YMQuuJ2ndUf+Dc0=;
 b=E1zlFzi5743scneggFZdmRIC/C8K0SsiMXsYA+SJL34MY0/fD7xmcrlHTTJdaLpflw
 luwpczoyToGLgWBQdwDMTM0dKNCYyvrl0pVll8zEqjXyOaj5QwF7TUoWqsFPlVptG1dz
 TZ4ksUXyhl2RGXngP/5zDi5sG3h3s9HNq/YXCVWcq/S4UgcJAwVZlI1Za3A/unmgJIpn
 kC1FowABi8e+V0/U8jbgjZpDAfH6jMdtMH4fwHVC/3/VhRUvLYTvWptESt0VPQFcw68i
 Q9DjuR7m66Y5NTpARFb9RCowNB9oipy3Eb9Ku4sv52BwOcPaUzgyIADJZt7H28U7tepd
 jZlw==
X-Gm-Message-State: AOAM530mdh8DlIecXDkL7tMulSFphba6vGZDwZTYvS7ZDKCVQojgbt3S
 72Fg6YK8oVUfcNVuY9h7e3/W32YMnm+nrw==
X-Google-Smtp-Source: ABdhPJyubYND3HSZH+Hz7/ildaeL/ooFKUO4nknydTh1SQSem3kX+BM8Ua6O0vUakkfuejmn6Jxa8w==
X-Received: by 2002:a63:2004:0:b0:375:ed63:ab4c with SMTP id
 g4-20020a632004000000b00375ed63ab4cmr5706231pgg.255.1648359468193; 
 Sat, 26 Mar 2022 22:37:48 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
 by smtp.googlemail.com with ESMTPSA id
 j14-20020a056a00174e00b004fb100a1b51sm7645394pfc.94.2022.03.26.22.37.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 26 Mar 2022 22:37:47 -0700 (PDT)
From: Xiaomeng Tong <xiam0nd.tong@gmail.com>
To: agk@redhat.com
Date: Sun, 27 Mar 2022 13:37:42 +0800
Message-Id: <20220327053742.2942-1-xiam0nd.tong@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Mon, 28 Mar 2022 06:43:55 +0000
Subject: [dm-devel] [PATCH] md: fix missing check on list iterator
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
Cc: stable@vger.kernel.org, dm-devel@redhat.com,
 Xiaomeng Tong <xiam0nd.tong@gmail.com>, linux-kernel@vger.kernel.org,
 snitzer@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The bug is here:
    bypass_pg(m, pg, bypassed);

The list iterator 'pg' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will lead
to a invalid memory access.

To fix this bug, run bypass_pg(m, pg, bypassed); and return 0
when found, otherwise return -EINVAL.

Cc: stable@vger.kernel.org
Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/md/dm-mpath.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f4719b65e5e3..6ba8f1133564 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1496,12 +1496,13 @@ static int bypass_pg_num(struct multipath *m, const char *pgstr, bool bypassed)
 	}
 
 	list_for_each_entry(pg, &m->priority_groups, list) {
-		if (!--pgnum)
-			break;
+		if (!--pgnum) {
+			bypass_pg(m, pg, bypassed);
+			return 0;
+		}
 	}
 
-	bypass_pg(m, pg, bypassed);
-	return 0;
+	return -EINVAL;
 }
 
 /*
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

