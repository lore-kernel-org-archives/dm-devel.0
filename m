Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4595AC64EC7
	for <dm-devel@archiver.kernel.org>; Wed,  1 Mar 2023 07:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677656538;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gNL2bMdXl1oy1oD6y6580R64t39QyVYC3E8S2vdRav4=;
	b=OXJIQ2IDmtCFzH2a6r0xaWKeeByndBpWi33OqQZFT+mfgZoaCp8ZraVll3JYmQzUTWCcSX
	tdc/S2rnLx/ekaqbye8xW7hKrBrxw35sHEzLbzbaVJ4zAg4VqMnLnBXvwX9kQW3BDYDO/u
	xywoLYQ1wrMz2ZOr5MaA63UiaKj2JTw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-4fQGdrsbM_mCpSGcNROk0w-1; Wed, 01 Mar 2023 02:42:14 -0500
X-MC-Unique: 4fQGdrsbM_mCpSGcNROk0w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1C851C0878C;
	Wed,  1 Mar 2023 07:42:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 06FF3140EBF4;
	Wed,  1 Mar 2023 07:42:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3EA8019465B9;
	Wed,  1 Mar 2023 07:41:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 46C21194658C
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Mar 2023 03:05:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 37EFC1121315; Wed,  1 Mar 2023 03:05:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 308C91121314
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 03:05:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 125BC864766
 for <dm-devel@redhat.com>; Wed,  1 Mar 2023 03:05:57 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-345-whhk1HctP1KA_Tl-OXgSjw-1; Tue, 28 Feb 2023 22:05:54 -0500
X-MC-Unique: whhk1HctP1KA_Tl-OXgSjw-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PRJyh0r59z4f3jqh;
 Wed,  1 Mar 2023 11:05:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgCnUiAHwf5jtvWGEA--.46636S4;
 Wed, 01 Mar 2023 11:05:49 +0800 (CST)
From: yangerkun <yangerkun@huaweicloud.com>
To: snitzer@kernel.org, agk@redhat.com, jefflexu@linux.alibaba.com,
 dm-devel@redhat.com
Date: Wed,  1 Mar 2023 11:29:04 +0800
Message-Id: <20230301032904.3561641-1-yangerkun@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgCnUiAHwf5jtvWGEA--.46636S4
X-Coremail-Antispam: 1UD129KBjvJXoWxCrW5trykuF1fKF4xAw13urg_yoW5XFyUpF
 W5Jr13G395Kr47Kr90yr1kGasxGr18Gr9xCr4xZ343Cw15WryFqF12yr48XrW8AF95Ga15
 ZFWkta1qkFyIy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUyG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWUWVWUuwAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
 JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
 CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
 2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
 W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
 r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
 xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 01 Mar 2023 07:41:52 +0000
Subject: [dm-devel] [PATCH v2] dm-crypt: reexport sysfs of kcryptd workqueue
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
Cc: yukuai3@huawei.com, yangerkun@huawei.com, yangerkun@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
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
rewritten the commit msg

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 40cb1719ae4d..948d1e11d064 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -47,6 +47,8 @@
 
 #define DM_MSG_PREFIX "crypt"
 
+static DEFINE_IDA(crypt_queue_ida);
+
 /*
  * context holding the current state of a multi-part conversion
  */
@@ -180,6 +182,7 @@ struct crypt_config {
 		struct crypto_aead **tfms_aead;
 	} cipher_tfm;
 	unsigned int tfms_count;
+	int crypt_queue_id;
 	unsigned long cipher_flags;
 
 	/*
@@ -2704,6 +2707,9 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
+	if (cc->crypt_queue_id)
+		ida_free(&crypt_queue_ida, cc->crypt_queue_id);
+
 	crypt_free_tfms(cc);
 
 	bioset_exit(&cc->bs);
@@ -3340,12 +3346,24 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

