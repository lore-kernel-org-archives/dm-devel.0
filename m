Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 767CDC77B7E
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 06:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682059677;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=os1hbude9J0T+iHrqHE24VyZe+Tu9d/zGaEoSXtAddc=;
	b=S/FpSJCvILxxgo1KdqsMMX8H1//uTwiSdZQbdDhxvScCzkZpVN6D9tq4K1v2/YQ6OveuTj
	B/vCP/rjfgbFgfJ47CSfn3VX9vZ76o3SMhCdM6xm4HTqZHYsPmZmTvo9RN+7t39pTQkHDm
	MHHwm7SFyzLqzpTtOtyC/NG5LOOm4LI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-z2T1nkLjPGq07-ErGmtGkw-1; Fri, 21 Apr 2023 02:47:54 -0400
X-MC-Unique: z2T1nkLjPGq07-ErGmtGkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 315AB884EC0;
	Fri, 21 Apr 2023 06:47:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 201AB40C83B7;
	Fri, 21 Apr 2023 06:47:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B7361946A6F;
	Fri, 21 Apr 2023 06:47:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2565919472C9
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 10:06:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6D279492B0F; Thu, 20 Apr 2023 10:06:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 648DF492B05
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 44E483C0E47B
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:13 +0000 (UTC)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-07n1bDh-Oiq-maHQQvlVCQ-1; Thu, 20 Apr 2023 06:06:09 -0400
X-MC-Unique: 07n1bDh-Oiq-maHQQvlVCQ-1
Received: by mail-wm1-f52.google.com with SMTP id
 5b1f17b1804b1-3f09b9ac51dso15224315e9.0; 
 Thu, 20 Apr 2023 03:06:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681985168; x=1684577168;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=u8TpFiJZXriCSIuX4H6qm/DmnDRMN3dAYFyNsYcZw7Y=;
 b=No7b5tDXUF95YU/N67p4XpDMSH/Fks6+p+fGKzPjLlYBApdxBWXlBq6XNs4cS/AAfX
 VSuC2MnqqJWnHy0odevnTtcix0w7aDYncgQHg5R9aZvF4IUENOTnkX78KDQva74ZsZxX
 Xm0KdpON7/VA8YCYRBWpHmR6cK6zi6id1w7W+HzrV3jd6SUpCLtM9X6ZOV/Z5x4a1nDw
 NkYj9b4XCIWSfWK0NkVNfRhxQUdpM4x6qgrC/h6CVvwk6wefu7cAjhuw0gFtQGNf7gMR
 uaDw2obJCSJf/+nC1Gufte+3r14mZjCF3CQq4e9spprm26ET6FLpGMn5yC5ihZ9ERfSG
 /71A==
X-Gm-Message-State: AAQBX9f4bhngnQ5ewPYaGwxsYhID1c+F6U6MByK2stIgkXD5IW72zPEC
 nXH5+jkHihfNWun6kJEi9m4=
X-Google-Smtp-Source: AKy350bW2EgyTCeppAYbGJgJ4MBVKwGKy3Cxhhh/Q4CkNUysK8MiWFufZI+smKPXyAJBB06Awe3bOQ==
X-Received: by 2002:a5d:6a11:0:b0:2f6:661:c03c with SMTP id
 m17-20020a5d6a11000000b002f60661c03cmr996930wru.28.1681985168177; 
 Thu, 20 Apr 2023 03:06:08 -0700 (PDT)
Received: from localhost.localdomain
 (aftr-62-216-205-208.dynamic.mnet-online.de. [62.216.205.208])
 by smtp.googlemail.com with ESMTPSA id
 l11-20020a5d674b000000b0030276f42f08sm201410wrw.88.2023.04.20.03.06.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 03:06:07 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: axboe@kernel.dk
Date: Thu, 20 Apr 2023 12:04:54 +0200
Message-Id: <20230420100501.32981-16-jth@kernel.org>
In-Reply-To: <20230420100501.32981-1-jth@kernel.org>
References: <20230420100501.32981-1-jth@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 21 Apr 2023 06:47:49 +0000
Subject: [dm-devel] [PATCH v4 15/22] md: check for failure when adding pages
 in alloc_behind_master_bio
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de, agruenba@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, willy@infradead.org,
 cluster-devel@redhat.com, kch@nvidia.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, rpeterso@redhat.com,
 dsterba@suse.com, linux-raid@vger.kernel.org, damien.lemoal@wdc.com,
 song@kernel.org, johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

alloc_behind_master_bio() can possibly add multiple pages to a bio, but it
is not checking for the return value of bio_add_page() if adding really
succeeded.

Check if the page adding succeeded and if not bail out.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/md/raid1.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 68a9e2d9985b..8283ef177f6c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1147,7 +1147,10 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 		if (unlikely(!page))
 			goto free_pages;
 
-		bio_add_page(behind_bio, page, len, 0);
+		if (!bio_add_page(behind_bio, page, len, 0)) {
+			free_page(page);
+			goto free_pages;
+		}
 
 		size -= len;
 		i++;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

