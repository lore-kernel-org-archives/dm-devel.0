Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9E83C433F5
	for <dm-devel@archiver.kernel.org>; Sat, 14 May 2022 23:04:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-128-6FCBIh24OrqO2zb0tPIooA-1; Sat, 14 May 2022 19:04:40 -0400
X-MC-Unique: 6FCBIh24OrqO2zb0tPIooA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F8AB1C05AE0;
	Sat, 14 May 2022 23:04:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5B22D15088B4;
	Sat, 14 May 2022 23:04:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E6197194704E;
	Sat, 14 May 2022 23:04:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BAF251947040
 for <dm-devel@listman.corp.redhat.com>; Sat, 14 May 2022 23:04:36 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8BD5F15088B0; Sat, 14 May 2022 23:04:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8825515063F8
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:04:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70359801210
 for <dm-devel@redhat.com>; Sat, 14 May 2022 23:04:36 +0000 (UTC)
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com
 [209.85.221.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-219-gR1OWzCcOJaM0r3x0Mta6Q-1; Sat, 14 May 2022 19:04:34 -0400
X-MC-Unique: gR1OWzCcOJaM0r3x0Mta6Q-1
Received: by mail-wr1-f49.google.com with SMTP id f2so8921824wrc.0;
 Sat, 14 May 2022 16:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Pxnjn0fGVw8mc4YpiZPNnnXmTEVIt1n6zOBAqgUQyPk=;
 b=yCC0ZbSWNe2nO47E50dpXKT3tbKPbbBIaOkEe4VC39oVdQ09A4646AE65+ONh2wRB7
 Js5tJlwnN8wUS6phLPjcaKTA1LSGO9AdXIxTo19K++0jOE0NvH7Tk8d6a6LDZeQNYDQ4
 8bEa0AiJvpop0LNe81qs5Yntb7bpHxOUMFD+rnnQyGdcsp8y+JsDNEa57m7pts8wwf1C
 moFA7vk0m3YEyl64rdMVj2kWwwLK0Z160Nn70FEfOasVNhZqmjJvQF5cj6yYiYbG8SZ/
 oZIa/aXjOU5TJn4TP+3XnoqsjBQCDhsud0TEOcY/jDrZiRA7m2dllHK18KbOv3WYw3mN
 b1xg==
X-Gm-Message-State: AOAM532YpWiUZ5FJiTiLEYok/e0LZAPiuti4AOsLfk6t/DbYXtEKcEHU
 AOJGOY6xoX1m9I8Ue5gUbOxl9VpXF6r/
X-Google-Smtp-Source: ABdhPJxrBp+aK7d9kQhCkjcxgPyupQYMfrjeWZks0ytYWHuZFcjDZ2lmGNlMUozRIPZE0D7YA37Fkg==
X-Received: by 2002:a5d:584a:0:b0:20c:5bad:11c1 with SMTP id
 i10-20020a5d584a000000b0020c5bad11c1mr9039251wrf.62.1652569473540; 
 Sat, 14 May 2022 16:04:33 -0700 (PDT)
Received: from localhost (50.red-81-44-142.dynamicip.rima-tde.net.
 [81.44.142.50]) by smtp.gmail.com with ESMTPSA id
 j32-20020a05600c1c2000b00394832af31csm10831213wms.0.2022.05.14.16.04.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sat, 14 May 2022 16:04:33 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Date: Sun, 15 May 2022 01:04:31 +0200
Message-Id: <20220514230431.139763-1-xose.vazquez@gmail.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: [dm-devel] [PATCH 0/9] add new devices to hw table
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
Cc: Zou Ming <zouming.zouming@huawei.com>,
 Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Uday Shankar <ushankar@purestorage.com>,
 NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
 DM-DEVEL ML <dm-devel@redhat.com>, Brian Bunker <brian@purestorage.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Zhouweigang <zhouweigang09@huawei.com>, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Xose Vazquez Perez (9):
  multipath-tools: fix misspellings
  multipath-tools: add HPE Alletra 9000 NVMe to hardware table
  multipath-tools: delete redundant ONTAP NVMe comment
  multipath-tools: add NetApp E-Series NVMe to hardware table
  multipath-tools: add Huawei OceanStor NVMe to hardware table
  multipath-tools: add IBM FlashSystem(TMS RamSan) NVMe to hardware table
  multipath-tools: add IBM FlashSystem(Storwize/SVC) NVMe to hardware table
  multipath-tools: add Pure FlashArray NVMe to hardware table
  multipath-tools: add Dell EMC PowerStore NVMe to hardware table

 README.md                       |  2 +-
 libmultipath/checkers/rdac.c    |  2 +-
 libmultipath/hwtable.c          | 60 ++++++++++++++++++++++++++++++---
 libmultipath/prioritizers/iet.c |  2 +-
 multipath/multipath.conf.5      |  2 +-
 tests/directio.c                |  2 +-
 6 files changed, 60 insertions(+), 10 deletions(-)

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Uday Shankar <ushankar@purestorage.com>
Cc: Brian Bunker <brian@purestorage.com>
Cc: Zhouweigang (Jack) <zhouweigang09@huawei.com>
Cc: Zou Ming <zouming.zouming@huawei.com>
Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
-- 
2.36.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

