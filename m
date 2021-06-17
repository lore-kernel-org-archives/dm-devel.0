Return-Path: <SRS0=ZDE9=LL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C123BC2B9F4
	for <dm-devel@archiver.kernel.org>; Thu, 17 Jun 2021 07:49:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 54B88613C1
	for <dm-devel@archiver.kernel.org>; Thu, 17 Jun 2021 07:49:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54B88613C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-RFI-YDb4N9ixe6H9dj_GVg-1; Thu, 17 Jun 2021 03:49:29 -0400
X-MC-Unique: RFI-YDb4N9ixe6H9dj_GVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E467B1923763;
	Thu, 17 Jun 2021 07:49:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B97551007606;
	Thu, 17 Jun 2021 07:49:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 18AAE4A717;
	Thu, 17 Jun 2021 07:49:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15H7nMGc003273 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Jun 2021 03:49:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 23A0810CD2CA; Thu, 17 Jun 2021 07:49:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F0F110CD2C9
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 07:49:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61D348007B1
	for <dm-devel@redhat.com>; Thu, 17 Jun 2021 07:49:19 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
	[45.249.212.255]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-154-YjYYwSFDNZqr7OBaRDZpnQ-1; Thu, 17 Jun 2021 03:49:16 -0400
X-MC-Unique: YjYYwSFDNZqr7OBaRDZpnQ-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5DC12xWbz1BN5R;
	Thu, 17 Jun 2021 15:26:53 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2176.2; Thu, 17 Jun 2021 15:31:55 +0800
Received: from huawei.com (10.90.53.225) by dggpeml500025.china.huawei.com
	(7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2;
	Thu, 17 Jun 2021 15:31:55 +0800
From: Hou Tao <houtao1@huawei.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Joe
	Thornber" <ejt@redhat.com>, <dm-devel@redhat.com>
Date: Thu, 17 Jun 2021 15:45:47 +0800
Message-ID: <20210617074547.64255-1-houtao1@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.90.53.225]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
	dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15H7nMGc003273
X-loop: dm-devel@redhat.com
Cc: zhangxiaoxu5@huawei.com, houtao1@huawei.com
Subject: [dm-devel] [PATCH] dm btree remove: assign new_root only when
	removal succeeds
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

remove_raw() in dm_btree_remove() may fail due to IO read error
(e.g. read the content of origin block fails during shadowing),
and the value of shadow_spine::root is uninitialized, but
the uninitialized value is still assign to new_root in the
end of dm_btree_remove().

For dm-thin, the value of pmd->details_root or pmd->root will become
an uninitialized value, so if trying to read details_info tree again
out-of-bound memory may occur as showed below:

  general protection fault, probably for non-canonical address 0x3fdcb14c8d7520
  CPU: 4 PID: 515 Comm: dmsetup Not tainted 5.13.0-rc6
  Hardware name: QEMU Standard PC
  RIP: 0010:metadata_ll_load_ie+0x14/0x30
  Call Trace:
   sm_metadata_count_is_more_than_one+0xb9/0xe0
   dm_tm_shadow_block+0x52/0x1c0
   shadow_step+0x59/0xf0
   remove_raw+0xb2/0x170
   dm_btree_remove+0xf4/0x1c0
   dm_pool_delete_thin_device+0xc3/0x140
   pool_message+0x218/0x2b0
   target_message+0x251/0x290
   ctl_ioctl+0x1c4/0x4d0
   dm_ctl_ioctl+0xe/0x20
   __x64_sys_ioctl+0x7b/0xb0
   do_syscall_64+0x40/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixing it by only assign new_root when removal succeeds

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/persistent-data/dm-btree-remove.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-btree-remove.c b/drivers/md/persistent-data/dm-btree-remove.c
index eff04fa23dfa..9e4d1212f4c1 100644
--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -549,7 +549,8 @@ int dm_btree_remove(struct dm_btree_info *info, dm_block_t root,
 		delete_at(n, index);
 	}
 
-	*new_root = shadow_root(&spine);
+	if (!r)
+		*new_root = shadow_root(&spine);
 	exit_shadow_spine(&spine);
 
 	return r;
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

