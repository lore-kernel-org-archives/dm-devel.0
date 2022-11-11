Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26D6CC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 11 Nov 2022 12:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668168334;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IRsQ6R5A/o+ii4koCmesdjfVeFv6YO5eVvd7tsne4l0=;
	b=BGmprdxaFy+eafI6W4avsyzdJRrYbOkhPMiLzurF1GEIN7a246QBwG2uer1QAtqF9XlDYZ
	uEkCmvdYIwKJK4iPsu4YSjOS3u0QqdIwOF1hwwJ3XT3twBTCLNx1la6b5XS0ODHrHKzAkl
	EQBGBUUzewb1IoMfZDXwwN6WnjJ1KyI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-To9h46YLOYG1vkFjr19kmQ-1; Fri, 11 Nov 2022 07:05:32 -0500
X-MC-Unique: To9h46YLOYG1vkFjr19kmQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75964185A7A9;
	Fri, 11 Nov 2022 12:05:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C54EA4A9256;
	Fri, 11 Nov 2022 12:05:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AAD171946589;
	Fri, 11 Nov 2022 12:05:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 357161946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Nov 2022 12:05:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 16CF21415127; Fri, 11 Nov 2022 12:05:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EAD9140EBF5
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 12:05:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9DE7882820
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 12:05:26 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-KSRIz3niO-aeLInIxlsHhw-1; Fri, 11 Nov 2022 07:05:23 -0500
X-MC-Unique: KSRIz3niO-aeLInIxlsHhw-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7xmv4nKQzmV6p;
 Fri, 11 Nov 2022 19:48:47 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 19:49:03 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 19:49:02 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <snitzer@kernel.org>, <Martin.Wilck@suse.com>, <ejt@redhat.com>,
 <jack@suse.cz>, <tytso@mit.edu>, <yi.zhang@huawei.com>,
 <chengzhihao1@huawei.com>
Date: Fri, 11 Nov 2022 20:10:26 +0800
Message-ID: <20221111121029.3985561-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 0/3] dm thin: Fix ABBA deadlock between
 shrink_slab and dm_pool_abort_metadata
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
Cc: dm-devel@redhat.com, linux-ext4@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Zhihao Cheng (3):
  dm bufio: Fix missing decrement of no_sleep_enabled if
    dm_bufio_client_create failed
  dm bufio: Split main logic out of dm_bufio_client creation/destroy
  dm thin: Fix ABBA deadlock between shrink_slab and
    dm_pool_abort_metadata

 drivers/md/dm-bufio.c                         | 189 +++++++++++++-----
 drivers/md/dm-thin-metadata.c                 |  36 +++-
 drivers/md/persistent-data/dm-block-manager.c |  21 ++
 drivers/md/persistent-data/dm-block-manager.h |   4 +
 include/linux/dm-bufio.h                      |  14 +-
 5 files changed, 214 insertions(+), 50 deletions(-)

-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

