Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26F55EEEC01
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 19:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694805327;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I7uB/fsBszBdRAs3N+I993knyClJzN1VkIp9fgQO8Nc=;
	b=MmW+DvY17fWlBOetGGdDVTHkvZjc/tAv1qWjIKweDm3N5bUC+2/yuxndeuHnsqaUG11I8h
	V4vnVXVPUB2boNgYCHwD22T5g4VmPI6pq3mlzXDWehM0TYrUs7jnL5lxP9l1eMA70KsLuJ
	603vMIBxyuHm3crj9As5e7p/W3K45VA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-9gLdaDDVOOSqBMNv0vVY8g-1; Fri, 15 Sep 2023 15:15:23 -0400
X-MC-Unique: 9gLdaDDVOOSqBMNv0vVY8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3C6C858299;
	Fri, 15 Sep 2023 19:15:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4DE1A2026D76;
	Fri, 15 Sep 2023 19:15:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC13F194658C;
	Fri, 15 Sep 2023 19:15:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2879E1946588
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 19:14:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 165C51CBC6; Fri, 15 Sep 2023 19:14:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EF4D28FD
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 19:14:29 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFD3A85A5A8
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 19:14:28 +0000 (UTC)
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com
 [209.85.210.177]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-mL5uScDhNcm9tsB_Dzektw-1; Fri, 15 Sep 2023 15:14:27 -0400
X-MC-Unique: mL5uScDhNcm9tsB_Dzektw-1
Received: by mail-pf1-f177.google.com with SMTP id
 d2e1a72fcca58-68fc49ccbf2so592377b3a.0
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 12:14:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694805265; x=1695410065;
 h=content-transfer-encoding:subject:from:to:content-language
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=eWJOV5XsemjysiUpqqTlWixBHYEJBF6N70fU4fRpQac=;
 b=lLePpZeDS9yLdQt2/SC5xQCR0nXJeKA4RwkRwocfkf3sNZsIyUTjw+isJZPxxnMIxE
 4E981QMsMf4MxEAPd/aKqf+QnADP0DAIgM9Rom9SQlXX7Yy6/z1mok3ksAND3mnQ2vZC
 xHAufWelmDAjKTcTsdqIf+jlTJfsUFyYJk0WXFZ2n4fYdElTBwOWpKDPjn1sfS0YHeqb
 okf383CRXGV6EzaRMv35s7SKh5qzZw+5R0Eiph9i72KzCBDRpCZbMe+wW9QznvLvf2kD
 0bsPQT5f1lHmTz48AH2FjBW5JidZH2cce/BqO6LugKNgigemYR8f8lvNGkPLJ3zZnPma
 0QRw==
X-Gm-Message-State: AOJu0Yz4hdaJlQQyPailmacBYbwXa0zNeNsgT5ksiyFOOjCqfAfGaCE4
 l+piyo6NsK7PkR0SHr6OjMF0k81pybyDmAOqIbRzEw==
X-Google-Smtp-Source: AGHT+IFTUhxHitG6oaih9o5uFI7nyIPMju3ho/4KV6bOVB00GYPrckNnu/7KuuLWP9+M+TOyWv/o4w==
X-Received: by 2002:a05:6a20:428a:b0:13e:7439:1449 with SMTP id
 o10-20020a056a20428a00b0013e74391449mr3367749pzj.0.1694805265263; 
 Fri, 15 Sep 2023 12:14:25 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
 by smtp.gmail.com with ESMTPSA id
 k10-20020a637b4a000000b00573f958f6a3sm3133966pgn.5.2023.09.15.12.14.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 Sep 2023 12:14:24 -0700 (PDT)
Message-ID: <22a0563f-0fed-4dd8-ae9a-8de443e6ce4e@kernel.dk>
Date: Fri, 15 Sep 2023 13:14:23 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Mike Snitzer <snitzer@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH] dm: don't attempt to queue IO under RCU
 protection
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
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm looks up the table for IO based on the request type, with an
assumption that if the request is marked REQ_NOWAIT, it's fine to
attempt to submit that IO while under RCU read lock protection. This
is not OK, as REQ_NOWAIT just means that we should not be sleeping
waiting on other IO, it does not mean that we can't potentially
schedule.

A simple test case demonstrates this quite nicely:

int main(int argc, char *argv[])
{
        struct iovec iov;
        int fd;

        fd = open("/dev/dm-0", O_RDONLY | O_DIRECT);
        posix_memalign(&iov.iov_base, 4096, 4096);
        iov.iov_len = 4096;
        preadv2(fd, &iov, 1, 0, RWF_NOWAIT);
        return 0;
}

which will instantly spew:

BUG: sleeping function called from invalid context at include/linux/sched/mm.h:306
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5580, name: dm-nowait
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
INFO: lockdep is turned off.
CPU: 7 PID: 5580 Comm: dm-nowait Not tainted 6.6.0-rc1-g39956d2dcd81 #132
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x11d/0x1b0
 __might_resched+0x3c3/0x5e0
 ? preempt_count_sub+0x150/0x150
 mempool_alloc+0x1e2/0x390
 ? mempool_resize+0x7d0/0x7d0
 ? lock_sync+0x190/0x190
 ? lock_release+0x4b7/0x670
 ? internal_get_user_pages_fast+0x868/0x2d40
 bio_alloc_bioset+0x417/0x8c0
 ? bvec_alloc+0x200/0x200
 ? internal_get_user_pages_fast+0xb8c/0x2d40
 bio_alloc_clone+0x53/0x100
 dm_submit_bio+0x27f/0x1a20
 ? lock_release+0x4b7/0x670
 ? blk_try_enter_queue+0x1a0/0x4d0
 ? dm_dax_direct_access+0x260/0x260
 ? rcu_is_watching+0x12/0xb0
 ? blk_try_enter_queue+0x1cc/0x4d0
 __submit_bio+0x239/0x310
 ? __bio_queue_enter+0x700/0x700
 ? kvm_clock_get_cycles+0x40/0x60
 ? ktime_get+0x285/0x470
 submit_bio_noacct_nocheck+0x4d9/0xb80
 ? should_fail_request+0x80/0x80
 ? preempt_count_sub+0x150/0x150
 ? lock_release+0x4b7/0x670
 ? __bio_add_page+0x143/0x2d0
 ? iov_iter_revert+0x27/0x360
 submit_bio_noacct+0x53e/0x1b30
 submit_bio_wait+0x10a/0x230
 ? submit_bio_wait_endio+0x40/0x40
 __blkdev_direct_IO_simple+0x4f8/0x780
 ? blkdev_bio_end_io+0x4c0/0x4c0
 ? stack_trace_save+0x90/0xc0
 ? __bio_clone+0x3c0/0x3c0
 ? lock_release+0x4b7/0x670
 ? lock_sync+0x190/0x190
 ? atime_needs_update+0x3bf/0x7e0
 ? timestamp_truncate+0x21b/0x2d0
 ? inode_owner_or_capable+0x240/0x240
 blkdev_direct_IO.part.0+0x84a/0x1810
 ? rcu_is_watching+0x12/0xb0
 ? lock_release+0x4b7/0x670
 ? blkdev_read_iter+0x40d/0x530
 ? reacquire_held_locks+0x4e0/0x4e0
 ? __blkdev_direct_IO_simple+0x780/0x780
 ? rcu_is_watching+0x12/0xb0
 ? __mark_inode_dirty+0x297/0xd50
 ? preempt_count_add+0x72/0x140
 blkdev_read_iter+0x2a4/0x530
 do_iter_readv_writev+0x2f2/0x3c0
 ? generic_copy_file_range+0x1d0/0x1d0
 ? fsnotify_perm.part.0+0x25d/0x630
 ? security_file_permission+0xd8/0x100
 do_iter_read+0x31b/0x880
 ? import_iovec+0x10b/0x140
 vfs_readv+0x12d/0x1a0
 ? vfs_iter_read+0xb0/0xb0
 ? rcu_is_watching+0x12/0xb0
 ? rcu_is_watching+0x12/0xb0
 ? lock_release+0x4b7/0x670
 do_preadv+0x1b3/0x260
 ? do_readv+0x370/0x370
 __x64_sys_preadv2+0xef/0x150
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f5af41ad806
Code: 41 54 41 89 fc 55 44 89 c5 53 48 89 cb 48 83 ec 18 80 3d e4 dd 0d 00 00 74 7a 45 89 c1 49 89 ca 45 31 c0 b8 47 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 be 00 00 00 48 85 c0 79 4a 48 8b 0d da 55
RSP: 002b:00007ffd3145c7f0 EFLAGS: 00000246 ORIG_RAX: 0000000000000147
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f5af41ad806
RDX: 0000000000000001 RSI: 00007ffd3145c850 RDI: 0000000000000003
RBP: 0000000000000008 R08: 0000000000000000 R09: 0000000000000008
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffd3145c850 R14: 000055f5f0431dd8 R15: 0000000000000001
 </TASK>

where in fact it is dm itself that attempts to allocate a bio clone with
GFP_NOIO under the rcu read lock, regardless of the request type.

Fix this by getting rid of the special casing for REQ_NOWAIT, and just
use the normal SRCU protected table lookup. Get rid of the bio based
table locking helpers at the same time, as they are now unused.

Cc: stable@vger.kernel.org
Fixes: 563a225c9fd2 ("dm: introduce dm_{get,put}_live_table_bio called from dm_submit_bio")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f0f118ab20fa..64a1f306c96c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -715,24 +715,6 @@ static void dm_put_live_table_fast(struct mapped_device *md) __releases(RCU)
 	rcu_read_unlock();
 }
 
-static inline struct dm_table *dm_get_live_table_bio(struct mapped_device *md,
-					int *srcu_idx, blk_opf_t bio_opf)
-{
-	if (bio_opf & REQ_NOWAIT)
-		return dm_get_live_table_fast(md);
-	else
-		return dm_get_live_table(md, srcu_idx);
-}
-
-static inline void dm_put_live_table_bio(struct mapped_device *md, int srcu_idx,
-					 blk_opf_t bio_opf)
-{
-	if (bio_opf & REQ_NOWAIT)
-		dm_put_live_table_fast(md);
-	else
-		dm_put_live_table(md, srcu_idx);
-}
-
 static char *_dm_claim_ptr = "I belong to device-mapper";
 
 /*
@@ -1833,9 +1815,8 @@ static void dm_submit_bio(struct bio *bio)
 	struct mapped_device *md = bio->bi_bdev->bd_disk->private_data;
 	int srcu_idx;
 	struct dm_table *map;
-	blk_opf_t bio_opf = bio->bi_opf;
 
-	map = dm_get_live_table_bio(md, &srcu_idx, bio_opf);
+	map = dm_get_live_table(md, &srcu_idx);
 
 	/* If suspended, or map not yet available, queue this IO for later */
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
@@ -1851,7 +1832,7 @@ static void dm_submit_bio(struct bio *bio)
 
 	dm_split_and_process_bio(md, map, bio);
 out:
-	dm_put_live_table_bio(md, srcu_idx, bio_opf);
+	dm_put_live_table(md, srcu_idx);
 }
 
 static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,

-- 
Jens Axboe

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

