Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09AAEC7EE31
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 04:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684903838;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O3IQ8JYbs5Ly5XFll0Vb+WARHOvJOGj95mwBEciPgSc=;
	b=cPd0MAUxy/xR53Uf1CQe/zwRkQA+UCYGWXUA3re4w76SYGaMor5p5ABwQT068ioF780YPH
	j6eXMGGWkcE3Ie6Rb/kIrKKNhWLhTkjdlV3lgoXzvjHmd47xF331QnD4ajnWQ7ZtIQiLDx
	9utZkSQ5ZuLqT+5wRLGAubeSKyJjRPg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-621-kweuAjNzPKuBCD-zjDwu3g-1; Wed, 24 May 2023 00:50:36 -0400
X-MC-Unique: kweuAjNzPKuBCD-zjDwu3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 992AE8039CC;
	Wed, 24 May 2023 04:50:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 869421121314;
	Wed, 24 May 2023 04:50:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 13A6419452C3;
	Wed, 24 May 2023 04:50:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E5421946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:10:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E9EB91121314; Tue, 23 May 2023 08:10:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E2B601121315
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:10:04 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 649881C068C0
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:10:04 +0000 (UTC)
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net
 [52.175.55.52]) by relay.mimecast.com with ESMTP id
 us-mta-140-16tgbBnDP2yWO930sfiSHA-1; Tue, 23 May 2023 04:10:01 -0400
X-MC-Unique: 16tgbBnDP2yWO930sfiSHA-1
Received: from ubuntu.localdomain (unknown [218.12.19.251])
 by mail-app2 (Coremail) with SMTP id by_KCgDX_n1Ccmxk1PiyAw--.43277S2;
 Tue, 23 May 2023 15:59:07 +0800 (CST)
From: Duoming Zhou <duoming@zju.edu.cn>
To: linux-kernel@vger.kernel.org
Date: Tue, 23 May 2023 15:58:57 +0800
Message-Id: <20230523075857.76520-1-duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgDX_n1Ccmxk1PiyAw--.43277S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zr18ur45Ww47Wr1kXFyrWFg_yoW8Xw47pF
 WruF95CFy8Gr4Ygw1DKF18tFy5Gw4kGFW3GFW8Wa43AF15Xr1vvFy2krWUtr4UZF95ZFy7
 ZFWkAay5WF1qy37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUkS14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
 1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4U
 JVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
 Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
 I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
 4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_GF4l
 42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
 WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
 I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
 4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY
 6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU52NtUUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAwQEAWRrhN4LtgAxsb
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Wed, 24 May 2023 04:50:30 +0000
Subject: [dm-devel] [PATCH] dm crypt: fix sleep-in-atomic-context bug in
 kcryptd_crypt_tasklet
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
Cc: dm-devel@redhat.com, Duoming Zhou <duoming@zju.edu.cn>, snitzer@kernel.org,
 agk@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: zju.edu.cn
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

In order to improve the IO performance of the dm-crypt
implementation, the commit 39d42fa96ba1 ("dm crypt:
add flags to optionally bypass kcryptd workqueues")
adds tasklet to do the crypto operations.

The tasklet callback function kcryptd_crypt_tasklet()
calls kcryptd_crypt() which is an original workqueue
callback function that may sleep. As a result, the
sleep-in-atomic-context bug may happen. The process
is shown below.

   (atomic context)
kcryptd_crypt_tasklet()
  kcryptd_crypt()
    kcryptd_crypt_write_convert()
      wait_for_completion() //may sleep

The wait_for_completion() is a function that may sleep.
In order to mitigate the bug, this patch changes
wait_for_completion() to try_wait_for_completion().

Fixes: 39d42fa96ba1 ("dm crypt: add flags to optionally bypass kcryptd workqueues")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 drivers/md/dm-crypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8b47b913ee8..5e2b2463d87 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2085,7 +2085,8 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
 	if (!crypt_finished && kcryptd_crypt_write_inline(cc, ctx)) {
 		/* Wait for completion signaled by kcryptd_async_done() */
-		wait_for_completion(&ctx->restart);
+		while (!try_wait_for_completion(&ctx->restart))
+			;
 		crypt_finished = 1;
 	}
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

