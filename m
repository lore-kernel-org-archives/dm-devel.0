Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4955C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jul 2022 07:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657868910;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZQ9nAjIi1IxVZHJianWwa7pmDnc5TfuGSwv/pCwmY3I=;
	b=AxxZmUjY7OqQWf+oA92+pyUX3F8nO6bLE2CxYPZjzWDk0ZNzakYTNOhJnlJmMysovwiwZg
	gubU6PcDFP22uAi9PKvDCU+JurmWCxjFT06bTqW1F1r/EJDekPzo6Bh/kJHB5TB4GsWojP
	mP2MACNpq3N59riV7uOYVGxGkP4d26M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-dQz8jD9FPz2m44fgXHcoZQ-1; Fri, 15 Jul 2022 03:08:27 -0400
X-MC-Unique: dQz8jD9FPz2m44fgXHcoZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5BA8D3803913;
	Fri, 15 Jul 2022 07:08:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 023FE404C49D;
	Fri, 15 Jul 2022 07:08:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB24E194706D;
	Fri, 15 Jul 2022 07:08:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED861194706C
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 11:33:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C93C51121315; Thu, 14 Jul 2022 11:33:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C4D231121314
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 11:33:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E98A3833286
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 11:33:42 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-OUQdp7FjMFGjcdHMsNOnQA-1; Thu, 14 Jul 2022 07:33:32 -0400
X-MC-Unique: OUQdp7FjMFGjcdHMsNOnQA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4LkBjV5qngz6PZWG;
 Thu, 14 Jul 2022 19:15:10 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgAXemnv+s9iQKT_Ag--.11129S4;
 Thu, 14 Jul 2022 19:16:11 +0800 (CST)
From: Luo Meng <luomeng@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, ejt@redhat.com
Date: Thu, 14 Jul 2022 19:28:25 +0800
Message-Id: <20220714112825.1591600-1-luomeng@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgAXemnv+s9iQKT_Ag--.11129S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWDtw1kWF1ftr4kCF4DArb_yoW5Xw18pF
 WrJryfAryqqrsrZr4xA3W09Fy5GFs2g3y7GF92k3sI93WDGrWFvF4jyFZ3ZF4UXFy3JFn8
 t3W5tFyj9rn8GrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUgEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6r1j6r18M7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
 c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
 CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
 MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6r
 W3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIY
 CTnIWIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: 5oxrzvtqj6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Fri, 15 Jul 2022 07:08:21 +0000
Subject: [dm-devel] dm thin: Fix crash in dm_sm_register_threshold_callback()
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
Cc: luomeng12@huawei.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Luo Meng <luomeng12@huawei.com>

Fault inject on pool metadata device report:
  BUG: KASAN: use-after-free in dm_pool_register_metadata_threshold+0x40/0x80
  Read of size 8 at addr ffff8881b9d50068 by task dmsetup/950

  CPU: 7 PID: 950 Comm: dmsetup Tainted: G        W         5.19.0-rc6 #1
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1.fc33 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x44
   print_address_description.constprop.0.cold+0xeb/0x3f4
   kasan_report.cold+0xe6/0x147
   dm_pool_register_metadata_threshold+0x40/0x80
   pool_ctr+0xa0a/0x1150
   dm_table_add_target+0x2c8/0x640
   table_load+0x1fd/0x430
   ctl_ioctl+0x2c4/0x5a0
   dm_ctl_ioctl+0xa/0x10
   __x64_sys_ioctl+0xb3/0xd0
   do_syscall_64+0x35/0x80
   entry_SYSCALL_64_after_hwframe+0x46/0xb0

This can be easy reproduce:
  echo offline > /sys/block/sda/device/state
  dd if=/dev/zero of=/dev/mapper/thin bs=4k count=10
  dmsetup load pool --table "0 20971520 thin-pool /dev/sda /dev/sdb 128 0 0"

If metadata commit failed, the transaction will be aborted and the metadata
space manager will be destroyed. If load table on this pool, when register the
metadata threshold callback, the UAF will happen on metadata space manager.

So return error when load table if the pool is on FAIL status.

Fixes: ac8c3f3df65e4 ("dm thin: generate event when metadata threshold passed")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Luo Meng <luomeng12@huawei.com>
---
 drivers/md/dm-thin-metadata.c | 8 +++++++-
 drivers/md/dm-thin.c          | 4 +++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 2db7030aba00..138f67abffd0 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -2048,9 +2048,15 @@ int dm_pool_register_metadata_threshold(struct dm_pool_metadata *pmd,
 	int r;
 
 	pmd_write_lock_in_core(pmd);
+	if (pmd->fail_io) {
+		r = -EINVAL;
+		goto out;
+	}
+
 	r = dm_sm_register_threshold_callback(pmd->metadata_sm, threshold, fn, context);
-	pmd_write_unlock(pmd);
 
+out:
+	pmd_write_unlock(pmd);
 	return r;
 }
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 84c083f76673..e76c96c760a9 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3375,8 +3375,10 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 						calc_metadata_threshold(pt),
 						metadata_low_callback,
 						pool);
-	if (r)
+	if (r) {
+		ti->error = "Error registering metadata threshold";
 		goto out_flags_changed;
+	}
 
 	dm_pool_register_pre_commit_callback(pool->pmd,
 					     metadata_pre_commit_callback, pool);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

