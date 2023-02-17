Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A91CC636D7
	for <dm-devel@archiver.kernel.org>; Fri, 17 Feb 2023 20:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676664473;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WHQqh66SH0XQizgpNRBHIyjcbI5tMRbquV8dkMbOjOM=;
	b=EmIq/quaYKCH4kxd/R6ii+HWaMD492tPOVDAZoT6XrEXULdpmtDXkx2oTZRfP2Byt6kHtv
	zLGJxCy0dNGMlTulyhboecz3nlOE3Wmj9ZtxVeyFTLwjugVQPFRmJorgLS9GYRrsAyPW5e
	mSA1GtmtsAbrBqpP6AYEMqCDeC1XK0c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-674-8Ts1TFk7PL2ShwCbD7x_Sg-1; Fri, 17 Feb 2023 15:07:48 -0500
X-MC-Unique: 8Ts1TFk7PL2ShwCbD7x_Sg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4383803493;
	Fri, 17 Feb 2023 20:07:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 50658C15BAD;
	Fri, 17 Feb 2023 20:07:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3B8CC194658C;
	Fri, 17 Feb 2023 20:07:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 804781946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 17 Feb 2023 20:07:45 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7155240CF8EC; Fri, 17 Feb 2023 20:07:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 69C754010E83
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F483833941
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 20:07:45 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-76-k-AR27dCMouEr0GyCQvKFQ-1; Fri, 17 Feb 2023 15:07:40 -0500
X-MC-Unique: k-AR27dCMouEr0GyCQvKFQ-1
Received: by mail-qv1-f46.google.com with SMTP id qh27so2334099qvb.2
 for <dm-devel@redhat.com>; Fri, 17 Feb 2023 12:07:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=xZezWnJLyreWBGxt6knrjZjSEIzP5PVQtvc1j7WHRnY=;
 b=ZSX5+Ge0JTAfPQ5IFOLeFYeEqduO/GnBbbUGaEBl3JAvo7qk96iqDeCPm6byOIpDnB
 3HbbBPpclDnen2Ce4KXuisl4s8me/G6n6IuJnLARML0KL0sDxMMXxSKPhOBAN6PWmlNc
 aFun5i2BLRFFEfpDN5e1SblzpOYzqnsUcatw4QwyawqGIx8UBgmYEsGeuWB4EUIyEsz0
 oiRzqZudc/X3MhGNgnyBpj1avuJeulEBGUf4oozpEtJl8tb3xc8SkK0+1FFELEs4LrhK
 sj48IT5f8tXOL2ZIpbrj4b8O2jJYQItF9OHdkFnwCIcslHeTGSXJ34TVcQdFtZSGFW2T
 512A==
X-Gm-Message-State: AO0yUKVKC2B7nn/8Uwpdxv9AKYN5LZHnjM1zticBRNuW/3LuA4Nkfhrv
 hbFZrYf1UrfyLqxZi4cns/vNgN1IoPI3mkjQutDlW/59ZLPAsbq2oFjp9xeqTRj6Z8haxtjawPC
 Z+NZJ33nk/Cs3N2NcNS6MZuTvPO5KZqwoAgXnAIiB7RxgSLmr/zFMMZVZWpFh6a07koUB8A==
X-Google-Smtp-Source: AK7set+cDHq/mRW5eMrx8oxJTZjhlqjobfuUhX5PU7YJlVn+b5UGLbHw65iMrPsOIUHtFqMSCq3RMQ==
X-Received: by 2002:a05:6214:da4:b0:56e:9c91:6cd with SMTP id
 h4-20020a0562140da400b0056e9c9106cdmr2774703qvh.44.1676664459168; 
 Fri, 17 Feb 2023 12:07:39 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 s200-20020a3745d1000000b006fed58fc1a3sm3859373qka.119.2023.02.17.12.07.38
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Feb 2023 12:07:38 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Fri, 17 Feb 2023 15:07:31 -0500
Message-Id: <20230217200737.12481-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH 0/6] dm: some changes just staged for 6.3
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
Cc: Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hou Tao (1):
  dm ioctl: remove unnecessary check when using dm_get_mdptr()

Mike Snitzer (4):
  dm: add cond_resched() to dm_wq_requeue_work()
  dm thin: add cond_resched() to various workqueue loops
  dm cache: add cond_resched() to various workqueue loops
  dm ioctl: assert _hash_lock is held in __hash_remove

Pingfan Liu (1):
  dm: add cond_resched() to dm_wq_work()

 drivers/md/dm-cache-target.c |  4 ++++
 drivers/md/dm-ioctl.c        | 10 +++++++---
 drivers/md/dm-thin.c         |  2 ++
 drivers/md/dm.c              |  2 ++
 4 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

