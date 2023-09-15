Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D639EED616
	for <dm-devel@archiver.kernel.org>; Fri, 15 Sep 2023 16:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694793881;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6Jg1bOVrokrZPoUpMwPFv+pSfFDjf7Pzg0bGnv9fuyk=;
	b=e8S1klNgEkxVfLTznztA9sK2q7CJPkxwD8lc6qm6DGdThw+zYpk/GzjcdacUF6Wpu5NXpc
	BGyhhQhGtJksc2gcu8FSaPfr6N07goWgLnMqYjuEw/yYY8CNO7K76EHo+W8AAvzdIDBMhg
	nG6xnHaO8Rog0dnGTdxtgUtLJngarmc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-Dq7KI_DgNLuzXTGVtzSR4A-1; Fri, 15 Sep 2023 12:04:37 -0400
X-MC-Unique: Dq7KI_DgNLuzXTGVtzSR4A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A0E594592B;
	Fri, 15 Sep 2023 16:04:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C57B40C2070;
	Fri, 15 Sep 2023 16:04:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2E36E194658F;
	Fri, 15 Sep 2023 16:04:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4804C194658C
 for <dm-devel@listman.corp.redhat.com>; Fri, 15 Sep 2023 16:04:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21D3A1C554; Fri, 15 Sep 2023 16:04:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 19D5F28FE
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 16:04:09 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB9371019C9E
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 16:04:08 +0000 (UTC)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
 [209.85.166.53]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-VE53-LGAPciORu13ll8fFw-1; Fri, 15 Sep 2023 12:04:06 -0400
X-MC-Unique: VE53-LGAPciORu13ll8fFw-1
Received: by mail-io1-f53.google.com with SMTP id
 ca18e2360f4ac-7950d0c85bbso14171539f.1
 for <dm-devel@redhat.com>; Fri, 15 Sep 2023 09:04:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20230601; t=1694793845; x=1695398645;
 h=content-transfer-encoding:subject:from:to:content-language
 :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
 :cc:subject:date:message-id:reply-to;
 bh=Y5WeHWcO0P3FEMSNm9fNk0OfJ+2haCpN0LEk2S64SwM=;
 b=eXRLo+Y1OYkxKaiiAjzSHQ7zlzvyETV3uAKjauxHH4jakJwONA31FDMbLAsgzHF4pX
 vjK2UFQwKCaDgw4V6CVhhRAVEEdZlhKcMKx8sKQu1PSFPDxj+0Rv+0cAMQEGNnHhrj2T
 a3qqzHTqiV+ZpQH3E3u679TzYilbcHj3n0FunsxTdsXlzNmG7yb2HJ5HnyxmnMSfmK2l
 9/cSzMJdmZSK6cGx4pnvO3g6ly8biDHAoXD2WhhQ08svvBrwPpXVY6sNrB3YbUCYjV1f
 6NzGwAgOSd8pKtAJQ3Il+adgztEzH3K2Iv136+VGDFyVoJGq92xX2DzjxlfPPvrp1mBs
 L01A==
X-Gm-Message-State: AOJu0YxO6wKUV2Qu1yHGXnFGLGT1kBBuUwo94RAUjUbBs1wTZ4SQnniP
 cPXt64CvNsJnUSjnWYwLMli2T8NWCg6L6zkeUpHjAw==
X-Google-Smtp-Source: AGHT+IFv87OMLFl9rATAeKY6fh4hZYt2fOSwRFi0g+8mGYTGruZ6Rp3E99cRIBg+woZmavM9uq6q+A==
X-Received: by 2002:a05:6602:2cd1:b0:794:cbb8:725e with SMTP id
 j17-20020a0566022cd100b00794cbb8725emr2709077iow.2.1694793845678; 
 Fri, 15 Sep 2023 09:04:05 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2]) by smtp.gmail.com with ESMTPSA id
 fx19-20020a0566381e1300b0042b91ec7e31sm1137934jab.3.2023.09.15.09.04.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 Sep 2023 09:04:04 -0700 (PDT)
Message-ID: <4f5737f0-9299-4968-8cb5-07c7645bbffd@kernel.dk>
Date: Fri, 15 Sep 2023 10:04:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Mike Snitzer <snitzer@redhat.com>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] DM brokeness with NOWAIT
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.dk
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

Threw some db traffic into my testing mix, and that ended in tears
very quickly:

CPU: 7 PID: 49609 Comm: ringbuf-read.t Tainted: G        W          6.6.0-rc1-g39956d2dcd81 #129
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x11d/0x1b0
 __might_resched+0x3c3/0x5e0
 ? preempt_count_sub+0x150/0x150
 mempool_alloc+0x1e2/0x390
 ? sanity_check_pinned_pages+0x23/0x1010
 ? mempool_resize+0x7d0/0x7d0
 bio_alloc_bioset+0x417/0x8c0
 ? bvec_alloc+0x200/0x200
 ? __gup_device_huge+0x900/0x900
 bio_alloc_clone+0x53/0x100
 dm_submit_bio+0x27f/0x1a20
 ? lock_release+0x4b7/0x670
 ? pin_user_pages_fast+0xb6/0xf0
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
 ? folio_flags+0x6c/0x1e0
 submit_bio_noacct+0x53e/0x1b30
 blkdev_direct_IO.part.0+0x833/0x1810
 ? rcu_is_watching+0x12/0xb0
 ? lock_release+0x4b7/0x670
 ? blkdev_read_iter+0x40d/0x530
 ? reacquire_held_locks+0x4e0/0x4e0
 ? __blkdev_direct_IO_simple+0x780/0x780
 ? rcu_is_watching+0x12/0xb0
 ? __mark_inode_dirty+0x297/0xd50
 ? preempt_count_add+0x72/0x140
 blkdev_read_iter+0x2a4/0x530
 ? blkdev_write_iter+0xc40/0xc40
 io_read+0x369/0x1490
 ? rcu_is_watching+0x12/0xb0
 ? io_writev_prep_async+0x260/0x260
 ? __fget_files+0x279/0x410
 ? rcu_is_watching+0x12/0xb0
 io_issue_sqe+0x18a/0xd90
 io_submit_sqes+0x970/0x1ed0
 __do_sys_io_uring_enter+0x14d4/0x2650
 ? io_submit_sqes+0x1ed0/0x1ed0
 ? rcu_is_watching+0x12/0xb0
 ? __do_sys_io_uring_register+0x3f6/0x2190
 ? io_req_caches_free+0x500/0x500
 ? ksys_mmap_pgoff+0x85/0x5b0
 ? rcu_is_watching+0x12/0xb0
 ? trace_irq_enable.constprop.0+0xd0/0x100
 do_syscall_64+0x39/0xb0
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

which seems to demonstrate a misunderstanding on what REQ_NOWAIT is
about. In particulary, it seems to assume you can then submit with
atomic context? DM does an rcu_read_lock() and happily proceeds to
attempt to submit IO under RCU being disabled.

A test case for this is pretty trivial, just do RWF_NOWAIT IO on any dm
device:

int main(int argc, char *argv[])
{
	struct iovec iov;
	void *buf;
	int fd;

	fd = open("/dev/dm-0", O_RDONLY | O_DIRECT);
	if (fd < 0) {
		perror("open");
		return 1;
	}

	if (posix_memalign(&buf, 4096, 4096))
		return 1;

	iov.iov_base = buf;
	iov.iov_len = 4096;
	preadv2(fd, &iov, 1, 0, RWF_NOWAIT);

	return 0;
}

and watch the splat go by. I didn't check which kernel had this
brokeness introduced, a quick check shows it's in 6.5 too at least.
Really looks like someone added a fast NOWAIT version, but then didn't
actually test it at all...

Quick patch below makes it go away, as expected, as we'd resort to using
SRCU.

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

