Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5ACC636D7
	for <dm-devel@archiver.kernel.org>; Thu, 23 Feb 2023 07:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677138048;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MS/vRrVmr66n1X8aWYnBVj1vLKxUL/1e1OAYugqLa9Q=;
	b=ZD3PVG8LAj5OyNgRvJujDK9nuHzpx7wSvG8gBZkgCRu/UcRumF/n+7WnjjaX8+VZX2Astu
	116hXMOZA6S9UUj6qAfobDZNoIhUY2fikdpdJ4/130f+UYbu+2w65qR2POOqYwzOSSSRe2
	FCgrf8iZz3GNsEtV2UHR+2zCJJhiSRQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-jloiMG3MNtGk1ZNyVDfwew-1; Thu, 23 Feb 2023 02:40:45 -0500
X-MC-Unique: jloiMG3MNtGk1ZNyVDfwew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81342101471A;
	Thu, 23 Feb 2023 07:40:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6EA7E1121314;
	Thu, 23 Feb 2023 07:40:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 97F7A19465B1;
	Thu, 23 Feb 2023 07:39:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63FC3194658C
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Feb 2023 03:11:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 287481415117; Thu, 23 Feb 2023 03:11:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2033C1415114
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 03:11:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C22A91C04B6D
 for <dm-devel@redhat.com>; Thu, 23 Feb 2023 03:11:30 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-367-WT6NozAePp22eu5JkDvfzg-1; Wed, 22 Feb 2023 22:11:27 -0500
X-MC-Unique: WT6NozAePp22eu5JkDvfzg-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PMd196bZ3z4f3tqc;
 Thu, 23 Feb 2023 10:55:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP3 (Coremail) with SMTP id _Ch0CgBH9CF41fZjSOQlDw--.18870S4;
 Thu, 23 Feb 2023 10:55:11 +0800 (CST)
From: yangerkun <yangerkun@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Thu, 23 Feb 2023 11:18:18 +0800
Message-Id: <20230223031818.3713509-1-yangerkun@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: _Ch0CgBH9CF41fZjSOQlDw--.18870S4
X-Coremail-Antispam: 1UD129KBjvJXoW7ur43tFW5WF47WryDWFyrCrg_yoW8KF1xpF
 Z5Xr13t3y8Kr47KrWYyr1kJwnxJF18GasxGrWxZ393C3W5Wr9YqF12yF48ZrWDAF95Gay5
 ZFWkJa1qkFy0yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUgEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6r1j6r18M7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
 c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
 CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
 MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Wr1j6r
 W3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIY
 CTnIWIevJa73UjIFyTuYvjxU7pnQUUUUU
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Thu, 23 Feb 2023 07:39:58 +0000
Subject: [dm-devel] [PATCH] dm-crypt: reexport sysfs of kcryptd workqueue
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
Cc: yangerkun@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: yangerkun <yangerkun@huawei.com>

'a2b8b2d97567 ("dm crypt: export sysfs of kcryptd workqueue")' give us
idea to set specific CPU or limit max_active crypt work. However sysfs
will report a warnning and fail 'cryptsetup refresh test' since the
reload will alloc workqueue with same sysfs name, and we temporarily
revert this feature to fix the problem.

What we actually should do is give a unique name once we try reload
table, we can use ida now.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/md/dm-crypt.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 755a01d72cdb..f0b8cb4364a1 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -46,6 +46,8 @@
 
 #define DM_MSG_PREFIX "crypt"
 
+static DEFINE_IDA(crypt_queue_ida);
+
 /*
  * context holding the current state of a multi-part conversion
  */
@@ -179,6 +181,7 @@ struct crypt_config {
 		struct crypto_aead **tfms_aead;
 	} cipher_tfm;
 	unsigned tfms_count;
+	int crypt_queue_id;
 	unsigned long cipher_flags;
 
 	/*
@@ -2708,6 +2711,9 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
+	if (cc->crypt_queue_id)
+		ida_free(&crypt_queue_ida, cc->crypt_queue_id);
+
 	crypt_free_tfms(cc);
 
 	bioset_exit(&cc->bs);
@@ -3344,12 +3350,24 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
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

