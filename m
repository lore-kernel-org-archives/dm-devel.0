Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37F4C3A5A7
	for <dm-devel@archiver.kernel.org>; Thu,  8 Dec 2022 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670508451;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sFIT1zz06wrr+Y311F/B78ocaYsQsvQTa+QD/XbTfl8=;
	b=SE/9Qv1h5fztSp1tKP8MwmE6hllcgcx1wfBjydtvDF99GeS/ec11//vA0v9g4yta0C1nGC
	V6RXKaTnTko9UxpCDNpMUC2C8fDBULbzub2krpK7D9zdtFL4+f5fhStxedtJwDxIqnaKpE
	GZ+L+bWY/k355SmHKImyc0eYaAUfU/k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-i-IheJ3WN52eJ1jwajszUw-1; Thu, 08 Dec 2022 09:07:30 -0500
X-MC-Unique: i-IheJ3WN52eJ1jwajszUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 004E9801231;
	Thu,  8 Dec 2022 14:07:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2324B1121331;
	Thu,  8 Dec 2022 14:07:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE5141946A44;
	Thu,  8 Dec 2022 14:07:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8F68F1946A41
 for <dm-devel@listman.corp.redhat.com>; Thu,  8 Dec 2022 14:07:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4BECB40C2064; Thu,  8 Dec 2022 14:07:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 43D3640C2065
 for <dm-devel@redhat.com>; Thu,  8 Dec 2022 14:07:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 292BE803533
 for <dm-devel@redhat.com>; Thu,  8 Dec 2022 14:07:22 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
 [45.249.212.189]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-kJRhH2j8O9mNTTOJz-nvBQ-1; Thu, 08 Dec 2022 09:07:17 -0500
X-MC-Unique: kJRhH2j8O9mNTTOJz-nvBQ-1
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.54])
 by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NSbV36Xm6zJpCN;
 Thu,  8 Dec 2022 22:03:39 +0800 (CST)
Received: from huawei.com (10.175.127.227) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 8 Dec
 2022 22:07:11 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <snitzer@redhat.com>, <agk@redhat.com>, <snitzer@kernel.org>,
 <Martin.Wilck@suse.com>, <thornber@redhat.com>
Date: Thu, 8 Dec 2022 22:28:02 +0800
Message-ID: <20221208142802.1479048-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH -next] dm thin: Use last transaction's pmd->root
 when commit failed
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
Cc: dm-devel@redhat.com, chengzhihao1@huawei.com, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Recently we found a softlock up problem in dm thin pool looking up btree
caused by corrupted metadata:
 Kernel panic - not syncing: softlockup: hung tasks
 CPU: 7 PID: 2669225 Comm: kworker/u16:3
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
 Workqueue: dm-thin do_worker [dm_thin_pool]
 Call Trace:
   <IRQ>
   dump_stack+0x9c/0xd3
   panic+0x35d/0x6b9
   watchdog_timer_fn.cold+0x16/0x25
   __run_hrtimer+0xa2/0x2d0
   </IRQ>
   RIP: 0010:__relink_lru+0x102/0x220 [dm_bufio]
   __bufio_new+0x11f/0x4f0 [dm_bufio]
   new_read+0xa3/0x1e0 [dm_bufio]
   dm_bm_read_lock+0x33/0xd0 [dm_persistent_data]
   ro_step+0x63/0x100 [dm_persistent_data]
   btree_lookup_raw.constprop.0+0x44/0x220 [dm_persistent_data]
   dm_btree_lookup+0x16f/0x210 [dm_persistent_data]
   dm_thin_find_block+0x12c/0x210 [dm_thin_pool]
   __process_bio_read_only+0xc5/0x400 [dm_thin_pool]
   process_thin_deferred_bios+0x1a4/0x4a0 [dm_thin_pool]
   process_one_work+0x3c5/0x730

Following process may generate a broken btree mixed with fresh and stale
nodes, which could let dm thin trapped into an infinite loop while looking
up data block:
 Transaction 1: pmd->root = A, A->B->C   // One path in btree
                pmd->root = X, X->Y->Z   // Copy-up
 Transaction 2: X,Z is updated on disk, Y is written failed.
                // Commit failed, dm thin becomes read-only.
                process_bio_read_only
		 dm_thin_find_block
		  __find_block
		   dm_btree_lookup(pmd->root)
The pmd->root points to a broken btree, Y may contain stale node pointing
to any block, for example X, which lets dm thin trapped into a dead loop
while looking up Z.

Fix it by setting pmd->root in __open_metadata(), so that dm thin will use
last transaction's pmd->root if commit failed.

Fetch a reproducer in [Link].

Linke: https://bugzilla.kernel.org/show_bug.cgi?id=216790
Fixes: 991d9fa02da0 ("dm: add thin provisioning target")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/dm-thin-metadata.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 1a62226ac34e..26c42ee183ed 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -724,6 +724,15 @@ static int __open_metadata(struct dm_pool_metadata *pmd)
 		goto bad_cleanup_data_sm;
 	}
 
+	/*
+	 * For pool metadata opening process, root setting is redundant
+	 * because it will be set again in __begin_transaction(). But dm
+	 * pool aborting process really needs to get last transaction's
+	 * root in case accessing broken btree.
+	 */
+	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
+	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+
 	__setup_btree_details(pmd);
 	dm_bm_unlock(sblock);
 
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

