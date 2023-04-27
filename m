Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26670C77B60
	for <dm-devel@archiver.kernel.org>; Thu, 27 Apr 2023 02:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682563419;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rzN0QzTsljUKWSB7YCQhEvHD6TFBfljE/EBajeZ9aRg=;
	b=bMZ+3F7/iGOXb/rbR2NN2NgMNKsAWP2R04gJiuhv32U6geVskeyHBLXbrfjLQA50pJTWLV
	woR5JchbJYalHKL4atdZuVcibV6oxN0+nQwLhcR5wO3sQNLpIkf37M039X89bxpqxIh6j4
	gO0L37FbBBdWU0bZAZx56zkEi8XB3z4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-4nEWprdmNCW-vq7_iUeOfw-1; Wed, 26 Apr 2023 22:43:36 -0400
X-MC-Unique: 4nEWprdmNCW-vq7_iUeOfw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C41F23C1484E;
	Thu, 27 Apr 2023 02:43:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 946902027043;
	Thu, 27 Apr 2023 02:43:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 547041946A41;
	Thu, 27 Apr 2023 02:43:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A728119465BD
 for <dm-devel@listman.corp.redhat.com>; Thu, 27 Apr 2023 02:43:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86B3D492B0F; Thu, 27 Apr 2023 02:43:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F5FB492B03
 for <dm-devel@redhat.com>; Thu, 27 Apr 2023 02:43:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64730185A78B
 for <dm-devel@redhat.com>; Thu, 27 Apr 2023 02:43:31 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-570-ZVRap-_KO_a4g2LsoXwmjA-1; Wed, 26 Apr 2023 22:43:20 -0400
X-MC-Unique: ZVRap-_KO_a4g2LsoXwmjA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Q6KmL2PFFz4f3tDJ
 for <dm-devel@redhat.com>; Thu, 27 Apr 2023 10:43:14 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAHcLNC4UlkQGzvIA--.1778S4;
 Thu, 27 Apr 2023 10:43:16 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: shinichiro@fastmail.com, snitzer@kernel.org, linux-block@vger.kernel.org,
 dm-devel@redhat.com
Date: Thu, 27 Apr 2023 10:41:26 +0800
Message-Id: <20230427024126.1417646-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAHcLNC4UlkQGzvIA--.1778S4
X-Coremail-Antispam: 1UD129KBjvJXoW7WF1Uuw4kXw1DCF4ktw45Awb_yoW8AryUp3
 yUur1Ykrs2y3W7tFy3W3W7Xa4rAws7uF4UCr17Ww18Ary3Jw1UK3W7Kry7AryfXFZYqan3
 ZasYqa1rur48J3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUgKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
 6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
 vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
 xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
 0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
 6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
 Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCj
 c4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4
 CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1x
 MIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJV
 Cq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBI
 daVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH blktests v2] tests/dm: add a regression test
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
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Verify that reload a dm with maps to itself will fail.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 tests/dm/001     | 29 +++++++++++++++++++++++++++++
 tests/dm/001.out |  2 ++
 tests/dm/rc      | 13 +++++++++++++
 3 files changed, 44 insertions(+)
 create mode 100644 tests/dm/001
 create mode 100644 tests/dm/001.out
 create mode 100644 tests/dm/rc

diff --git a/tests/dm/001 b/tests/dm/001
new file mode 100644
index 0000000..6deab1f
--- /dev/null
+++ b/tests/dm/001
@@ -0,0 +1,29 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2023 Yu Kuai
+#
+# Regression test for commit 077a4033541f ("block: don't allow a disk link
+# holder to itself")
+
+. tests/dm/rc
+
+DESCRIPTION="reload a dm with maps to itself"
+QUICK=1
+
+requires() {
+	_have_kver 6 2
+}
+
+test_device() {
+	echo "Running ${TEST_NAME}"
+
+	dmsetup create test --table "0 8192 linear ${TEST_DEV} 0"
+	dmsetup suspend test
+	dmsetup reload test --table "0 8192 linear /dev/mapper/test 0" &> /dev/null
+	if [ $? -eq 0 ]; then
+		echo "reload a dm with maps to itself succeed."
+	fi
+	dmsetup remove test
+
+	echo "Test complete"
+}
diff --git a/tests/dm/001.out b/tests/dm/001.out
new file mode 100644
index 0000000..4bd2c08
--- /dev/null
+++ b/tests/dm/001.out
@@ -0,0 +1,2 @@
+Running dm/001
+Test complete
diff --git a/tests/dm/rc b/tests/dm/rc
new file mode 100644
index 0000000..0486db0
--- /dev/null
+++ b/tests/dm/rc
@@ -0,0 +1,13 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2023 Yu Kuai
+#
+# Tests for device-mapper
+
+. common/rc
+
+group_requires() {
+	_have_root
+	_have_program dmsetup
+	_have_driver dm-mod
+}
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

