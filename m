Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A66C61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Mar 2023 16:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678120175;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZakoyvIJJbhAmIlaa8fMbeJxbD4Wd4/VLV0pJU6O7wI=;
	b=AFWTyTmmJkksdijMB2+2MARhbiRSHzEa8c7fgj4lzT5JFoPdauOnQILWE7+jQ7hwA6aUfR
	16g8RRC7GHlmJ7BlQND/2dAFnhRIpYuiNL1M76ZW/yL9gxBDgMJOhJo9pxO66/f0g7iZTL
	ZIM4Ug21ENPOYdchNlCRE4ZhEPtV5C4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-5tx7KQi8O0mHZ8UCX8SrLA-1; Mon, 06 Mar 2023 11:29:34 -0500
X-MC-Unique: 5tx7KQi8O0mHZ8UCX8SrLA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E95A41C05B0B;
	Mon,  6 Mar 2023 16:29:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDF55492C14;
	Mon,  6 Mar 2023 16:29:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A9F3A194658D;
	Mon,  6 Mar 2023 16:29:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D7F4F1946586
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Mar 2023 13:21:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AB3D2112132D; Mon,  6 Mar 2023 13:21:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A3E731121314
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 13:21:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D6E52810C01
 for <dm-devel@redhat.com>; Mon,  6 Mar 2023 13:21:21 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-KOY3RH3DOUyXHaAI-7kT2A-1; Mon, 06 Mar 2023 08:21:18 -0500
X-MC-Unique: KOY3RH3DOUyXHaAI-7kT2A-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4PVfNR1jffz4f3jJF;
 Mon,  6 Mar 2023 21:21:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
 by APP4 (Coremail) with SMTP id gCh0CgD3rLDH6AVkOFVrEw--.46662S4;
 Mon, 06 Mar 2023 21:21:13 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: dm-devel@redhat.com
Date: Mon,  6 Mar 2023 21:49:30 +0800
Message-Id: <20230306134930.2878660-1-houtao@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgD3rLDH6AVkOFVrEw--.46662S4
X-Coremail-Antispam: 1UD129KBjvJXoW7tw45ZrW7Zry8Zr4kJrWDurg_yoW8Aw1fpF
 W3G3yFyrWrJF47K34Ut3W8CryY9rn7KrW3Cr43C34j9F129F9YgFy2v3y0vF45AFZ5X3W3
 ZFWkta45CF1DArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUgKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
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
 daVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mailman-Approved-At: Mon, 06 Mar 2023 16:29:31 +0000
Subject: [dm-devel] [PATCH] dm crypt: initialize tasklet in crypt_io_init()
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
Cc: houtao1@huawei.com, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Ignat Korchagin <ignat@cloudflare.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Hou Tao <houtao1@huawei.com>

When neither no_read_workqueue nor no_write_workqueue are enabled,
tasklet_trylock() in crypt_dec_pending() may still return false due to
an uninitialized state, and dm-crypt will do io completion in io_queue
instead of current context unnecessarily.

Fix it by initializing io->tasklet in crypt_io_init().

Fixes: 8e14f610159d ("dm crypt: do not call bio_endio() from the dm-crypt tasklet")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-crypt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3aeeb8f2802f..caee6ce3b79f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -238,6 +238,7 @@ static void crypt_endio(struct bio *clone);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static struct scatterlist *crypt_get_sg_data(struct crypt_config *cc,
 					     struct scatterlist *sg);
+static void kcryptd_crypt_tasklet(unsigned long work);
 
 static bool crypt_integrity_aead(struct crypt_config *cc);
 
@@ -1725,6 +1726,7 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->sector = sector;
 	io->error = 0;
 	io->ctx.r.req = NULL;
+	tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
 	atomic_set(&io->io_pending, 0);
@@ -2226,7 +2228,6 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 		 * it is being executed with irqs disabled.
 		 */
 		if (in_hardirq() || irqs_disabled()) {
-			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;
 		}
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

