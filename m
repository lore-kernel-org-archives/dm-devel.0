Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5657B2638BC
	for <dm-devel@lists.linux.dev>; Mon, 20 Oct 2025 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760963637; cv=none; b=JEnzvLw/dKQXXAXQhQQTO4Pdw0vQGbMfrYv11RX3CoQbKbe2NS9FMXoTIe4di9wRdTtL7l9aUjpxCCPacAzEMYf/mZFVwwi+EfZ051D+uZbsdKO1I6nZyX7wUSt8TNldR6lbPt2M6fcpQZISU8eBVHGz4ckLjIUgzp3kRl2p0rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760963637; c=relaxed/simple;
	bh=rU8uVYLcF2AhmiLNNzi2LEgzFWs3egZ8KWbc8nmZbuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AgiVfqg3WfvrU3hKlUm/4kFEDDyopFKRSyZXZZ7jx88l5OI9DdXVmqAbepYjxainwGfFvT7uUIROclq1FArgLLkJ+nbYt6OrA8wi/An9AZvH9hl1EspkSTuwKY38ra/+T3BD5M1WHSQK75pKJcuDvfNWKtF6rKsQ1BmTFKjcdrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9Ky5NwD; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9Ky5NwD"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3717780ea70so47068921fa.1
        for <dm-devel@lists.linux.dev>; Mon, 20 Oct 2025 05:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760963633; x=1761568433; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5NVhDovZUT94TwG8yM18Fjy7iq+ALMqR310W9PkiJtA=;
        b=l9Ky5NwDy1wqxXhhtpxl5fTBvcqtSFJll2ElhxVip7Zrj9TTKEtmfbnx7d2Kq14fpa
         yFKEXhTrchFrnTDdafp+TN1tFF2UtIc1eeyMq1AhsCJSyPEAQzm5aUP44V2mM3rIo520
         TJQNWI4qqh+rHCOKRrUWjcc+NUmJRMFCqFEKI1cqUjkav6wONdWuSYxyqHKm+CSLjzOu
         4XKp7p1O3VRmaZc99dZUUYaVm5MiRsYS3Il1rGQmRKVH/9OpGKEmkxJZSTUESjL74MLh
         htjhGJEtLQThfLl1iAAGdSZPuTHtQ4EsbHvJC4WdxBqvGdbdz/M2s/wksShZWeZANtYr
         kB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760963633; x=1761568433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5NVhDovZUT94TwG8yM18Fjy7iq+ALMqR310W9PkiJtA=;
        b=YI8V21SxLDkcsUt3dtYC+fUGvN282yZH9LOgLCFccKnsj1/hGRGhheZftbVGp25bxW
         bcOpZzrBt4TUel2gH3KkOQbENVDsBF1qt5D0m1OEW9Lb4im36GdqugvLB0sSXk9piUmF
         Lu1aQJQUoxoeEAIvNW0dBbORkKWfP1j5onJZzAuiX5mMyEGPbxjBB0cY7OT8yul0B/DY
         QN+V3mT9Zj3H4aoZ3RM7ka61e9nsE1RnQmFvd46yP3LH/Sk0jYNTu7Vpt0G3jvu+ErIN
         7C3vmsQ42iaHkQhjKv6b0MVrFwsDhk6gbBL6AMQ/cWG3mj5kiF436iEwhoYB/Y2UDrCi
         DpFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAOn3UXmBgnoJRtCy7NWJPjyc+mcWzEue7a1VzavDcGnG5wZy6JBkkwlU01KTtmkPu2Y3XBXizOQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwBooPOIV2/G9WcJQ/Mn+sYMhG0CbgfuT8dlwkgqfanpaw8n+3J
	fpi0yyhHqoRFEteij3yDLULU3u+ih7QbGJb5AM5DuWLpOFicGZkj9bjI
X-Gm-Gg: ASbGncsfdeiId1mldmgPqZ7WDvujWR9as+t4vI6EbR3EXw74YdYqGwLA1yGph6pPnvD
	qaxAbE1ZCVi4goFWhaPSYdZxa06ACkYyhbqRNeC9/bzTO6hx3en2xhv0wIdrbv5l1hYuGBuv7nc
	fhaRd3vhcO2mw6ifNciw5YbugHZxPqRKFxX03UEYOMO8MEfJHPTGkCn7XNJXrPXVq1QmXFK0BY7
	VuvkOp8rJjaVfXch3ma72p0aK7zzZlgsJbS/rAflUz3Te+lJG/hSgEHASC6S3zVpmSYDQkt/eTC
	PhePuDt3c3OZvcRhC8/0Krp5Kmw077L2w76dqQ+l6mLPYYziitPr8oDG8Xapjbg03g5W2TeBrzu
	ZhfGGj0kHIIc707F1iw2hDI6FQGVHZFIFUzzGpA6UMO47DCkC0dqlwhl5bx8pIuMzSNV0i7yEDZ
	FdjTVt
X-Google-Smtp-Source: AGHT+IEHmugvulxBOoF5zYCC89SrkirMs/0QQ7fiUfyd2YWN72j+Jt3IPDQcNBZxXduznnLGhxQC3Q==
X-Received: by 2002:a2e:9fc9:0:b0:336:72be:3339 with SMTP id 38308e7fff4ca-377979feb62mr45322971fa.28.1760963633075;
        Mon, 20 Oct 2025 05:33:53 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-377a90e2555sm20278271fa.0.2025.10.20.05.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 05:33:52 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	DMML <dm-devel@lists.linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v2] dm-ebs: Mark full buffer dirty even on partial write
Date: Mon, 20 Oct 2025 14:33:50 +0200
Message-ID: <20251020123350.2671495-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When performing a read-modify-write(RMW) operation, any modification
to a buffered block must cause the entire buffer to be marked dirty.

Marking only a subrange as dirty is incorrect because the underlying
device block size(ubs) defines the minimum read/write granularity. A
lower device can perform I/O only on regions which are fully aligned
and sized to ubs.

This change ensures that write-back operations always occur in full
ubs-sized chunks, matching the intended emulation semantics of the
EBS target.

As for user space visible impact, submitting sub-ubs and misaligned
I/O for devices which are tuned to ubs sizes only, will reject such
requests, therefore it can lead to losing data. Example:

1) Create a 8K nvme device in qemu by adding

-device nvme,drive=drv0,serial=foo,logical_block_size=8192,physical_block_size=8192

2) Setup dm-ebs to emulate 512B to 8K mapping

urezki@pc638:~/bin$ cat dmsetup.sh

lower=/dev/nvme0n1
len=$(blockdev --getsz "$lower")

echo "0 $len ebs $lower 0 1 16" | dmsetup create nvme-8k
urezki@pc638:~/bin$

offset 0, ebs=1 and ubs=16(in sectors).

3) Create an ext4 filesystem(default 4K block size)

urezki@pc638:~/bin$ sudo mkfs.ext4 -F /dev/dm-0
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done
Creating filesystem with 2072576 4k blocks and 518144 inodes
Filesystem UUID: bd0b6ca6-0506-4e31-86da-8d22c9d50b63
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
urezki@pc638:~/bin$ dmesg

<snip>
[ 1618.875449] buffer_io_error: 1028 callbacks suppressed
[ 1618.875456] Buffer I/O error on dev dm-0, logical block 0, lost async page write
[ 1618.875527] Buffer I/O error on dev dm-0, logical block 1, lost async page write
[ 1618.875602] Buffer I/O error on dev dm-0, logical block 2, lost async page write
[ 1618.875620] Buffer I/O error on dev dm-0, logical block 3, lost async page write
[ 1618.875639] Buffer I/O error on dev dm-0, logical block 4, lost async page write
[ 1618.894316] Buffer I/O error on dev dm-0, logical block 5, lost async page write
[ 1618.894358] Buffer I/O error on dev dm-0, logical block 6, lost async page write
[ 1618.894380] Buffer I/O error on dev dm-0, logical block 7, lost async page write
[ 1618.894405] Buffer I/O error on dev dm-0, logical block 8, lost async page write
[ 1618.894427] Buffer I/O error on dev dm-0, logical block 9, lost async page write
<snip>

Many I/O errors because the lower 8K device rejects sub-ubs/misaligned
requests.

with a patch:

urezki@pc638:~/bin$ sudo mkfs.ext4 -F /dev/dm-0
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done
Creating filesystem with 2072576 4k blocks and 518144 inodes
Filesystem UUID: 9b54f44f-ef55-4bd4-9e40-c8b775a616ac
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

urezki@pc638:~/bin$ sudo mount /dev/dm-0 /mnt/
urezki@pc638:~/bin$ ls -al /mnt/
total 24
drwxr-xr-x  3 root root  4096 Oct 17 15:13 .
drwxr-xr-x 19 root root  4096 Jul 10 19:42 ..
drwx------  2 root root 16384 Oct 17 15:13 lost+found
urezki@pc638:~/bin$

After this change: mkfs completes; mount succeeds.

v1 -> v2:
 - reflect a user space visible impact in the commit message.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 drivers/md/dm-ebs-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 6abb31ca9662..b354e74a670e 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -103,7 +103,7 @@ static int __ebs_rw_bvec(struct ebs_c *ec, enum req_op op, struct bio_vec *bv,
 			} else {
 				flush_dcache_page(bv->bv_page);
 				memcpy(ba, pa, cur_len);
-				dm_bufio_mark_partial_buffer_dirty(b, buf_off, buf_off + cur_len);
+				dm_bufio_mark_buffer_dirty(b);
 			}
 
 			dm_bufio_release(b);
-- 
2.47.3

