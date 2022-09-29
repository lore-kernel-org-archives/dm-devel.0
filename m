Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134C0C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 30 Sep 2022 07:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1664521906;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kpMMXeRm9timTQudeuzeNj2nQgbjLyA5xZZvjjP1POo=;
	b=Uk547npupYD2eaI6RkaFGlHYnNIpYjODHYdQvOQZsBlFMNZJHZEVzEyRItLr9HoJj4ZJYH
	FBzhw2BfMa3XKvPshwA+uzINhTjMZrcKanBHjIW+Kk11cwdhnmHjb6oTNgMVwk1XK221jn
	vvn0WJ48HvN6PG82Ecn9aI/oKmAj6VI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-fH3mcg--NvOziqAYKUIdYA-1; Fri, 30 Sep 2022 03:11:42 -0400
X-MC-Unique: fH3mcg--NvOziqAYKUIdYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C013780206D;
	Fri, 30 Sep 2022 07:11:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2EE6B2166B26;
	Fri, 30 Sep 2022 07:11:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1A2431946A52;
	Fri, 30 Sep 2022 07:11:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C90D19465B8
 for <dm-devel@listman.corp.redhat.com>; Thu, 29 Sep 2022 08:20:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1ABE240EFB0A; Thu, 29 Sep 2022 08:20:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1385140EFB00
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 08:20:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED15185A583
 for <dm-devel@redhat.com>; Thu, 29 Sep 2022 08:20:58 +0000 (UTC)
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-60-yXeCdOQFOjeQTtfaG04f4w-1; Thu, 29 Sep 2022 04:20:57 -0400
X-MC-Unique: yXeCdOQFOjeQTtfaG04f4w-1
Received: by mail-pf1-f193.google.com with SMTP id b75so802636pfb.7;
 Thu, 29 Sep 2022 01:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date;
 bh=oLacvrmMc7XWx51TtRRIZ78owPQV0/EOHAQ7fO1xE+c=;
 b=2JKRp/AAo04rBeHfY0opS2HvrKAbt0v7T+Bd4kha8RvYcjkmfvgIcRGE1UIOAdB8JV
 LbeyOsIVDAtgGU8TJDet3ujPrs/beiEdzqsr7so53A/CRcHf/kPjf5NauaJVrdnwfhOG
 Q7rPtQLdsfVnoalyggL4KxapTbR/THdh5fOc2FfySQxEz2UKCbts/PRovNtFQBVwtt5m
 QQ9LBKss62O8PLs47Y6A/ZR3b+UX5lUcVmFuJbhdDPllcYTZvAOU5BSvvqCrw/AAMMkM
 KwWPwcsec8j8X6xbopyKaSnH3bc89EENFYMyeWZ6FUOqx/9zAdxuYQzY2EQk+h7OPY9v
 t9Rg==
X-Gm-Message-State: ACrzQf2rZZEZcxEM9tHthq1c+hhXXznrTHXGi9nWokO4uMmFxz8OCmUf
 NFbpoLIzdZYGivoLuboM/RNf9SzpFNk=
X-Google-Smtp-Source: AMsMyM4hcvfnBMBNQsdXSLcD7fvAvMFeCJMwcZ0M5GpVa1k7lB1uTWWiLs/w0/wFRBJAkiUfMOytkA==
X-Received: by 2002:a62:2985:0:b0:544:77d4:f43b with SMTP id
 p127-20020a622985000000b0054477d4f43bmr2128909pfp.9.1664439655416; 
 Thu, 29 Sep 2022 01:20:55 -0700 (PDT)
Received: from localhost.localdomain ([218.188.148.16])
 by smtp.gmail.com with ESMTPSA id
 x9-20020a170902a38900b0017b65174c9esm581186pla.59.2022.09.29.01.20.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 29 Sep 2022 01:20:54 -0700 (PDT)
From: Genjian <zhanggenjian123@gmail.com>
X-Google-Original-From: Genjian <zhanggenjian@kylinos.cn>
To: agk@redhat.com,
	snitzer@kernel.org
Date: Thu, 29 Sep 2022 16:20:36 +0800
Message-Id: <20220929082036.913110-1-zhanggenjian@kylinos.cn>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Fri, 30 Sep 2022 07:11:37 +0000
Subject: [dm-devel] [PATCH] dm: Remove unnecessary assignment statements in
 alloc_dev().
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
Cc: zhanggenjian123@gmail.com, Genjian Zhang <zhanggenjian@kylinos.cn>,
 dm-devel@redhat.com, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Genjian Zhang <zhanggenjian@kylinos.cn>

Since there are related allocation and  assignment operations before this,
the two are already equal, so this assignment statement is not needed.

Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799..b4a2cb5333fc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2065,7 +2065,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->minors = 1;
 	md->disk->flags |= GENHD_FL_NO_PART;
 	md->disk->fops = &dm_blk_dops;
-	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

