Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC27C001DE
	for <dm-devel@archiver.kernel.org>; Tue, 11 Jul 2023 06:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689056023;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bsEv+oWTx+bGUVQK8ltI4CYD+52QT7bV8dHn52fu0SU=;
	b=hGuKTJclDAenhwqg5oYxb5l/8Q150OfzkkpUvt6ZH0FTMgXzx41sJaAJ2BAm4mQLfbwO7Z
	ZZU7k+dG31eekMK2gAB0e1G6KiBDeco5fftPgF34qtEK7sYaYcgckjNBJftE1fU9M+meh7
	uP1v3UtuQcDbd7EaEzNuRtrPGWz1mtQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-23vx8PTPOfubPAnP9IWqpQ-1; Tue, 11 Jul 2023 02:13:41 -0400
X-MC-Unique: 23vx8PTPOfubPAnP9IWqpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 775D8810BB4;
	Tue, 11 Jul 2023 06:13:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ABF80F66AD;
	Tue, 11 Jul 2023 06:13:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 45CF419465B9;
	Tue, 11 Jul 2023 06:13:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 245E219465B8
 for <dm-devel@listman.corp.redhat.com>; Tue, 11 Jul 2023 06:13:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7FE3C54FB3; Tue, 11 Jul 2023 06:13:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C06BDC478DE
 for <dm-devel@redhat.com>; Tue, 11 Jul 2023 06:13:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87EBB3C0E440
 for <dm-devel@redhat.com>; Tue, 11 Jul 2023 06:13:30 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-m4z5yANrMb2xVT-_4TxLgQ-1; Tue, 11 Jul 2023 02:13:24 -0400
X-MC-Unique: m4z5yANrMb2xVT-_4TxLgQ-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4R0Vt43QmFz4f3kG1;
 Tue, 11 Jul 2023 14:13:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP2 (Coremail) with SMTP id Syh0CgD3nOrx8qxkokOANg--.52214S4;
 Tue, 11 Jul 2023 14:13:18 +0800 (CST)
From: yangerkun <yangerkun@huaweicloud.com>
To: snitzer@kernel.org,
	mpatocka@redhat.com,
	agk@redhat.com,
	tj@kernel.org
Date: Tue, 11 Jul 2023 14:11:29 +0800
Message-Id: <20230711061129.2706759-1-yangerkun@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: Syh0CgD3nOrx8qxkokOANg--.52214S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCrW5trykuF1fKF4xAw13urg_yoW5Wr4UpF
 W5Jr13Gws5Kr47Kr90yr18Ja9xGF18GF9xCrWxZ343Cw15WryFqF12yF48XrWkAF95Ja1U
 ZFWkJa1qkFyFy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
 r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
 xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
 cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
 AvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
 xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VU1a9aPUUUUU==
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v3] dm-crypt: reexport sysfs of kcryptd workqueue
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
Cc: yukuai3@huawei.com, dm-devel@redhat.com, yangerkun@huawei.com,
 yangerkun@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: yangerkun <yangerkun@huawei.com>

Once there is a heavy IO load, so many encrypt/decrypt work will occupy
all of the cpu, which may lead the poor performance for other service.
So the idea like 'a2b8b2d97567 ("dm crypt: export sysfs of kcryptd
workqueue")' said seems necessary. We can export "kcryptd" workqueue
sysfs, the entry like cpumask/max_active and so on can help us to limit
the usage for encrypt/decrypt work.

However, that commit does not consider the reload table will call .ctr
before .dtr, so the reload for dm-crypt will fail since the same sysfs
problem, and then we revert that commit('48b0777cd93d ("Revert "dm
crypt: export sysfs of kcryptd workqueue"")').

Actually, what we should do is give a unique name once we try reload
table, we can use ida to fix the problem.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/md/dm-crypt.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

v1->v2:
rewrite the commit msg

v2->v3:
no logical change, just rebase to latest linux kernel

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1dc6227d353e..f4678eb71322 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -47,6 +47,8 @@
 
 #define DM_MSG_PREFIX "crypt"
 
+static DEFINE_IDA(crypt_queue_ida);
+
 /*
  * context holding the current state of a multi-part conversion
  */
@@ -182,6 +184,7 @@ struct crypt_config {
 		struct crypto_aead **tfms_aead;
 	} cipher_tfm;
 	unsigned int tfms_count;
+	int crypt_queue_id;
 	unsigned long cipher_flags;
 
 	/*
@@ -2735,6 +2738,9 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
+	if (cc->crypt_queue_id)
+		ida_free(&crypt_queue_ida, cc->crypt_queue_id);
+
 	crypt_free_tfms(cc);
 
 	bioset_exit(&cc->bs);
@@ -3371,12 +3377,24 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags))
-		cc->crypt_queue = alloc_workqueue("kcryptd/%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
+		cc->crypt_queue = alloc_workqueue("kcryptd-%s", WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM,
 						  1, devname);
-	else
-		cc->crypt_queue = alloc_workqueue("kcryptd/%s",
-						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM | WQ_UNBOUND,
-						  num_online_cpus(), devname);
+	else {
+		int id = ida_alloc_min(&crypt_queue_ida, 1, GFP_KERNEL);
+
+		if (id < 0) {
+			ti->error = "Couldn't get kcryptd queue id";
+			ret = id;
+			goto bad;
+		}
+
+		cc->crypt_queue_id = id;
+		cc->crypt_queue = alloc_workqueue("kcryptd-%s-%d",
+						  WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM |
+						  WQ_UNBOUND | WQ_SYSFS,
+						  num_online_cpus(), devname, id);
+	}
+
 	if (!cc->crypt_queue) {
 		ti->error = "Couldn't create kcryptd queue";
 		goto bad;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

