Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B71C83F15
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188311;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JFqM5aUQiX6635mTaNiVNfMMx7X/zxfGABabe7Wt6Kg=;
	b=fElXSDOaTeqhorinagcwEqMKliSGwQzmVy/YJnc9Cz0bUb84jLCe0wH8GzI72x0mkmupNL
	0Q4JY7Aw8k27p496QwSc8Rk5RuwNrIp2y2v+wkBzi7kS1IRVoO+mmdBZrnqqImZKKmJU7k
	4HDtIMGXxCO/HOJptATrQAgsRp12icc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-oCyNI8EGMYqqLX1XdKW5Hg-1; Sun, 27 Aug 2023 22:05:07 -0400
X-MC-Unique: oCyNI8EGMYqqLX1XdKW5Hg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 482FC8D40C2;
	Mon, 28 Aug 2023 02:05:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 304AF2166B25;
	Mon, 28 Aug 2023 02:05:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15E6619465B3;
	Mon, 28 Aug 2023 02:05:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B448F19465B9
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:05:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A4BA42166B28; Mon, 28 Aug 2023 02:05:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D0A42166B27
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:05:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 807433C0D856
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:05:01 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-7uhKuGWMM1iuQoqBA9LWuQ-1; Sun, 27 Aug 2023 22:04:58 -0400
X-MC-Unique: 7uhKuGWMM1iuQoqBA9LWuQ-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RYv5J5Fdfz4f3nKS;
 Mon, 28 Aug 2023 10:04:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S24;
 Mon, 28 Aug 2023 10:04:53 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 10:00:13 +0800
Message-Id: <20230828020021.2489641-21-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S24
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr4kXFWfAF4DCr48AFW5ZFb_yoW8ZF1kpF
 47ta4rWrWxJw45Gw4rZa1kuas0qw1vkrWqyrWagw1fZ3WxGwnrGFy5tr4DAF9Yv3ya9r43
 Xw4UK3y5GryfArDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAF
 wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
 0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
 SdkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH -next v2 20/28] md: use new apis to suspend array
 for adding/removing rdev from state_store()
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
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

User can write 'remove' and 're-add' to trigger array reconfiguration
through sysfs, suspend array in this case so that io won't concurrent
with array reconfiguration.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 81c7b9d1cc36..0f1006197afd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2918,11 +2918,7 @@ static int add_bound_rdev(struct md_rdev *rdev)
 		 */
 		super_types[mddev->major_version].
 			validate_super(mddev, rdev);
-		if (add_journal)
-			mddev_suspend(mddev);
 		err = mddev->pers->hot_add_disk(mddev, rdev);
-		if (add_journal)
-			mddev_resume(mddev);
 		if (err) {
 			md_kick_rdev_from_array(rdev);
 			return err;
@@ -3675,6 +3671,7 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	struct md_rdev *rdev = container_of(kobj, struct md_rdev, kobj);
 	struct kernfs_node *kn = NULL;
+	bool suspended = false;
 	ssize_t rv;
 	struct mddev *mddev = rdev->mddev;
 
@@ -3683,8 +3680,14 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (entry->store == state_store && cmd_match(page, "remove"))
-		kn = sysfs_break_active_protection(kobj, attr);
+	if (entry->store == state_store) {
+		if (cmd_match(page, "remove"))
+			kn = sysfs_break_active_protection(kobj, attr);
+		if (cmd_match(page, "remove") || cmd_match(page, "re-add")) {
+			__mddev_suspend(mddev);
+			suspended = true;
+		}
+	}
 
 	rv = mddev ? mddev_lock(mddev) : -ENODEV;
 	if (!rv) {
@@ -3693,6 +3696,9 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 		else
 			rv = entry->store(rdev, page, length);
 		mddev_unlock(mddev);
+
+		if (suspended)
+			__mddev_resume(mddev);
 	}
 
 	if (kn)
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

