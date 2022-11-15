Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8730EC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 15 Nov 2022 15:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668525361;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tffdFEdF0MWeZuqe17Qk/caAF45psxu3SJE9mFCrU3E=;
	b=FgsjewbzOD2oBO+4W5FUyGnGCARUKGb/ju9cp67jBnd0sOOIZ5F5IAB5OStE10lEpnwncP
	ddBjELl2/nxpU1Kxw6C2XpIbnSTZ/ajp5s76xshee3rANlA221FSSQMkxAqU5sAL5Qz1W6
	vG6HIx0rRLLT1SOICAsm4nxSIRYfEHQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-166-2iwOsraGOdKGVS4MT3pjrA-1; Tue, 15 Nov 2022 10:15:56 -0500
X-MC-Unique: 2iwOsraGOdKGVS4MT3pjrA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D2C83802BA6;
	Tue, 15 Nov 2022 15:15:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46A812028E8F;
	Tue, 15 Nov 2022 15:15:47 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 948871946A40;
	Tue, 15 Nov 2022 15:15:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BEA919465B9
 for <dm-devel@listman.corp.redhat.com>; Tue, 15 Nov 2022 13:49:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 5F83540E9789; Tue, 15 Nov 2022 13:49:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 573C040C6EC3
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CE3D101A528
 for <dm-devel@redhat.com>; Tue, 15 Nov 2022 13:49:42 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-d3CKBp9aPouENm4qQdBpOQ-1; Tue, 15 Nov 2022 08:49:39 -0500
X-MC-Unique: d3CKBp9aPouENm4qQdBpOQ-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4NBSGL1zmsz4f41hX;
 Tue, 15 Nov 2022 21:49:30 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.127.227])
 by APP4 (Coremail) with SMTP id gCh0CgBni9jnmHNjrPFIAg--.61645S14;
 Tue, 15 Nov 2022 21:49:33 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@lst.de, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com
Date: Tue, 15 Nov 2022 22:10:54 +0800
Message-Id: <20221115141054.1051801-11-yukuai1@huaweicloud.com>
In-Reply-To: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
References: <20221115141054.1051801-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgBni9jnmHNjrPFIAg--.61645S14
X-Coremail-Antispam: 1UD129KBjvJXoWxXw4kCFy5Xw1kuF1fWrWDXFb_yoWrurWkpr
 1jqr4UGr48Jr1UXF4UAr1UJr1UJrW8AF48Jr17Xr1DJF15W3WUZr1UJrWUAr15Jr4Yqr17
 tw4DXw18tryUKaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mailman-Approved-At: Tue, 15 Nov 2022 15:15:46 +0000
Subject: [dm-devel] [PATCH v3 10/10] block: don't allow a disk link holder
 to itself
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
Cc: linux-block@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 linux-kernel@vger.kernel.org, yukuai1@huaweicloud.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

After creating a dm device, then user can reload such dm with itself,
and dead loop will be triggered because dm keep looking up to itself.

Test procedures:

1) dmsetup create test --table "xxx sda", assume dm-0 is created
2) dmsetup suspend test
3) dmsetup reload test --table "xxx dm-0"
4) dmsetup resume test

Test result:

BUG: TASK stack guard page was hit at 00000000736a261f (stack is 000000008d12c88d..00000000c8dd82d5)
stack guard page: 0000 [#1] PREEMPT SMP
CPU: 29 PID: 946 Comm: systemd-udevd Not tainted 6.1.0-rc3-next-20221101-00006-g17640ca3b0ee #1295
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
RIP: 0010:dm_prepare_ioctl+0xf/0x1e0
Code: da 48 83 05 4a 7c 99 0b 01 41 89 c4 eb cd e8 b8 1f 40 00 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57 48 83 05 a1 5a 99 0b 01 <41> 56 49 89 d6 41 55 4c 8d af 90 02 00 00 9
RSP: 0018:ffffc90002090000 EFLAGS: 00010206
RAX: ffff8881049d6800 RBX: ffff88817e589000 RCX: 0000000000000000
RDX: ffffc90002090010 RSI: ffffc9000209001c RDI: ffff88817e589000
RBP: 00000000484a101d R08: 0000000000000000 R09: 0000000000000007
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000005331
R13: 0000000000005331 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fddf9609200(0000) GS:ffff889fbfd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9000208fff8 CR3: 0000000179043000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 dm_blk_ioctl+0x50/0x1c0
 ? dm_prepare_ioctl+0xe0/0x1e0
 dm_blk_ioctl+0x88/0x1c0
 dm_blk_ioctl+0x88/0x1c0
 ......(a lot of same lines)
 dm_blk_ioctl+0x88/0x1c0
 dm_blk_ioctl+0x88/0x1c0
 blkdev_ioctl+0x184/0x3e0
 __x64_sys_ioctl+0xa3/0x110
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fddf7306577
Code: b3 66 90 48 8b 05 11 89 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 88 8
RSP: 002b:00007ffd0b2ec318 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00005634ef478320 RCX: 00007fddf7306577
RDX: 0000000000000000 RSI: 0000000000005331 RDI: 0000000000000007
RBP: 0000000000000007 R08: 00005634ef4843e0 R09: 0000000000000080
R10: 00007fddf75cfb38 R11: 0000000000000246 R12: 00000000030d4000
R13: 0000000000000000 R14: 0000000000000000 R15: 00005634ef48b800
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:dm_prepare_ioctl+0xf/0x1e0
Code: da 48 83 05 4a 7c 99 0b 01 41 89 c4 eb cd e8 b8 1f 40 00 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 57 48 83 05 a1 5a 99 0b 01 <41> 56 49 89 d6 41 55 4c 8d af 90 02 00 00 9
RSP: 0018:ffffc90002090000 EFLAGS: 00010206
RAX: ffff8881049d6800 RBX: ffff88817e589000 RCX: 0000000000000000
RDX: ffffc90002090010 RSI: ffffc9000209001c RDI: ffff88817e589000
RBP: 00000000484a101d R08: 0000000000000000 R09: 0000000000000007
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000005331
R13: 0000000000005331 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fddf9609200(0000) GS:ffff889fbfd40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc9000208fff8 CR3: 0000000179043000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Kernel panic - not syncing: Fatal exception in interrupt
Kernel Offset: disabled
---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Fix the problem by forbidding a disk to create link to itself.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/holder.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/holder.c b/block/holder.c
index 3332142bb867..37d18c13d958 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -65,6 +65,9 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 	if (WARN_ON_ONCE(!disk->slave_dir))
 		return -EINVAL;
 
+	if (bdev->bd_disk == disk)
+		return -EINVAL;
+
 	/*
 	 * del_gendisk drops the initial reference to bd_holder_dir, so we
 	 * need to keep our own here to allow for cleanup past that point.
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

