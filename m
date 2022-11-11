Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F25C433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Nov 2022 12:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668168335;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yWCQedHWP7kTXUFUGDEaLMAxgnReGhKcpHwu/PWs0vQ=;
	b=KfQS9UrtleLBoFLaUNprcC/UlVP8nJOEzCdrxK2yAxrWM5vGR3btSQ2TsNoy9eq9jaF77O
	2DESTIgkkXPB9EYOr0a8C6/GfJ1sG9zHYBci6iH1Wm4F/ON3xQNEfEeFxgC37+Xc4eSjy0
	ENMwJTC3PCVj1FUdvNeEmYiAsRyrmcw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-9az2k-8LMr6wwOI0sHy2RQ-1; Fri, 11 Nov 2022 07:05:32 -0500
X-MC-Unique: 9az2k-8LMr6wwOI0sHy2RQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75EFC811728;
	Fri, 11 Nov 2022 12:05:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ACD8C140EBF5;
	Fri, 11 Nov 2022 12:05:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8A8791946587;
	Fri, 11 Nov 2022 12:05:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6DCA91946586
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Nov 2022 12:05:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F4812166B36; Fri, 11 Nov 2022 12:05:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 58A132166B26
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 12:05:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 383D1882823
 for <dm-devel@redhat.com>; Fri, 11 Nov 2022 12:05:26 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-Cd5sssVgMhCTAPxSaHtcMA-1; Fri, 11 Nov 2022 07:05:22 -0500
X-MC-Unique: Cd5sssVgMhCTAPxSaHtcMA-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N7xmw3pG7zmVpK;
 Fri, 11 Nov 2022 19:48:48 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (7.193.23.68) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 19:49:04 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 11 Nov
 2022 19:49:03 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <snitzer@kernel.org>, <Martin.Wilck@suse.com>, <ejt@redhat.com>,
 <jack@suse.cz>, <tytso@mit.edu>, <yi.zhang@huawei.com>,
 <chengzhihao1@huawei.com>
Date: Fri, 11 Nov 2022 20:10:27 +0800
Message-ID: <20221111121029.3985561-2-chengzhihao1@huawei.com>
In-Reply-To: <20221111121029.3985561-1-chengzhihao1@huawei.com>
References: <20221111121029.3985561-1-chengzhihao1@huawei.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 1/3] dm bufio: Fix missing decrement of
 no_sleep_enabled if dm_bufio_client_create failed
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The 'no_sleep_enabled' should be decreased in error handling path
in dm_bufio_client_create() when flag DM_BUFIO_CLIENT_NO_SLEEP is
set, otherwise static_branch_unlikely() will always return true
even no dm_bufio_client instances has DM_BUFIO_CLIENT_NO_SLEEP flag.

Fixes: 3c1c875d0586 ("dm bufio: conditionally enable branching for DM_BUFIO_CLIENT_NO_SLEEP")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/dm-bufio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 9c5ef818ca36..bb786c39545e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1858,6 +1858,8 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
 	mutex_destroy(&c->lock);
+	if (c->no_sleep)
+		static_branch_dec(&no_sleep_enabled);
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

