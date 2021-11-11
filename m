Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45C0C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 514B76109D
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 08:16:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 514B76109D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-GNFxzaN6PS-KgNsZcA6QDQ-1; Thu, 11 Nov 2021 03:16:37 -0500
X-MC-Unique: GNFxzaN6PS-KgNsZcA6QDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A72FC871829;
	Thu, 11 Nov 2021 08:16:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CCBAE5FC25;
	Thu, 11 Nov 2021 08:16:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ECCE3181A1D0;
	Thu, 11 Nov 2021 08:16:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AB7rekZ018155 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 02:53:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 932C7404727C; Thu, 11 Nov 2021 07:53:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8ED814047279
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 07:53:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7589780A0AB
	for <dm-devel@redhat.com>; Thu, 11 Nov 2021 07:53:40 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
	[209.85.216.49]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-566-jnGdKreIOxiyPD3f1wwysw-1; Thu, 11 Nov 2021 02:53:38 -0500
X-MC-Unique: jnGdKreIOxiyPD3f1wwysw-1
Received: by mail-pj1-f49.google.com with SMTP id
	t5-20020a17090a4e4500b001a0a284fcc2so3988691pjl.2; 
	Wed, 10 Nov 2021 23:53:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=diz0NWx3rdvWrK+h2Sf0MO5zGVzedXNR+hpSRRnycnA=;
	b=z1SBtB/GXnc5jtgyPs1kQ2tdMrdOVVUKIre8YqOz5692xIzdHSvloKY8NJ7B5zd0dL
	h0/iYmcNa2Y4kXDZtU3gOKkR3d5h69IvBq8BjdKAHidUO0LBy5cWA0iNMYNbBQCIkNvB
	un9oQQ1T+Wra6+L1aL6Ng6YnImvG8VaNygmP8FKkC4Lk1jPHcddNhQvgS9904BNtSisB
	2BQeT5L/TkHGQ1VgzH9l2CRgutenvwiH25vpOV+X9V0vmGg1PdAHE7zjQtpsOuj4hSHP
	QSObX7IoWbhYUsQDmqSEOmC/aTLOgzLfsmLiQqjXX/eNDeqpEItrqreeilvYzpv4Awuq
	yxyg==
X-Gm-Message-State: AOAM532O6LrewHUNrCnDr0AEs4GZNQkudeQIo2MfKy9Hj68X46iyMvRI
	JKuCdtkFMuj2C+Khd/xVdX6ut6C1188=
X-Google-Smtp-Source: ABdhPJx4gxlJQ++7M32dN0ueUqjuOYAZbpVnYJHLFS+S2wzEmX735KSmG143dJm161eSP05yi7z94Q==
X-Received: by 2002:a17:902:e9c6:b0:141:c588:99b2 with SMTP id
	6-20020a170902e9c600b00141c58899b2mr5882063plk.63.1636617216784;
	Wed, 10 Nov 2021 23:53:36 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
	by smtp.gmail.com with ESMTPSA id
	il13sm4703883pjb.52.2021.11.10.23.53.35
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 10 Nov 2021 23:53:36 -0800 (PST)
From: cgel.zte@gmail.com
X-Google-Original-From: ran.jianping@zte.com.cn
To: agk@redhat.com
Date: Thu, 11 Nov 2021 07:53:31 +0000
Message-Id: <20211111075331.158061-1-ran.jianping@zte.com.cn>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 11 Nov 2021 03:16:24 -0500
Cc: dm-devel@redhat.com, ran jianping <ran.jianping@zte.com.cn>,
	linux-kernel@vger.kernel.org, snitzer@redhat.com,
	Zeal Robot <zealci@zte.com.cn>
Subject: [dm-devel] [PATCH] dm: remove unneeded variable
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: ran jianping <ran.jianping@zte.com.cn>

Fix the following coccicheck review:
./drivers/md/dm-ps-round-robin.c:91:5-7:Unneeded variable

Remove unneeded variable used to store return value.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: ran jianping <ran.jianping@zte.com.cn>
---
 drivers/md/dm-ps-round-robin.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index 27f44c5fa04e..455fc02af1cf 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -88,7 +88,6 @@ static int rr_status(struct path_selector *ps, struct dm_path *path,
 		     status_type_t type, char *result, unsigned int maxlen)
 {
 	struct path_info *pi;
-	int sz = 0;
 
 	if (!path)
 		DMEMIT("0 ");
@@ -107,7 +106,7 @@ static int rr_status(struct path_selector *ps, struct dm_path *path,
 		}
 	}
 
-	return sz;
+	return 0;
 }
 
 /*
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

