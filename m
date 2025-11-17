Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D95275AFD
	for <dm-devel@lists.linux.dev>; Mon, 17 Nov 2025 10:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763377191; cv=none; b=iwphH0saBZjukK9EgEoIgtsPZS55Rm/JeODhWWKhgR/oayNrNkmR6lSCBkbaXACy5s0Djavjga4ujKJWcgJ6D9rpXlU7IJnuowbCEGeD71VRC8TZBGHp7DtHTkfl9O8B5atpHKIoh2WZl6ut8TW3dVoBYYWWNTczfZ2UPqUDRYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763377191; c=relaxed/simple;
	bh=rU8uVYLcF2AhmiLNNzi2LEgzFWs3egZ8KWbc8nmZbuM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IGqE2vXsSE/VS9KifIQk81O1bURW+rkdMJPCnNDfFavp/dQ/evyL/29wKRQnIWFCfiYwBH/73J0MwGKit59YPjmZ1nPl4wLziweb48gFaqvGIyFycYoqwUkKXdqFgHq9AVX5d9iFGcI1pQZ//zwInITZ0Hmp680cwsyUFBatBh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0TmuFd/; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0TmuFd/"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-591c9934e0cso5673144e87.0
        for <dm-devel@lists.linux.dev>; Mon, 17 Nov 2025 02:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763377188; x=1763981988; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5NVhDovZUT94TwG8yM18Fjy7iq+ALMqR310W9PkiJtA=;
        b=G0TmuFd/5QhNKEA53I3uZdsgvtoVj6rtNkCs+FGlrHIMdkWg9/laZUc7uzaeXnJxgB
         0ZWtZwyXyld3LkNuBDRUltyakcGPIfi18DQO0kVFodDYY1XwGVy+734KJyy+OCmqxTNM
         f0O/+8+dpSYrBKqjni3gfJEjtTpx/yVNwUVdnfkbdo9p3IqfA4EsXd/Gecm4r7Clu1HZ
         T+Gfv9P9L3AeFyhsszPffSm9Fglkz3KwQBZyhW8YRM+pYSUqqOZRWXaJ6TdMMwUJszVy
         nmVGWRKKRP1KqYTxABOYD1zaB6CMIKCiC/UWlZqRQO9tBwTDnEw1k/YD03/P8CkjTNnB
         5MAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763377188; x=1763981988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NVhDovZUT94TwG8yM18Fjy7iq+ALMqR310W9PkiJtA=;
        b=o9ogPOSl3oOB83rcOYD1+6sjjIomgSOW7GOFafcB7ji0mhcQHbJVjZSl4ruk1Qq2p5
         000/XTOmdtN8Wj7nxg8/4UpzkkXpeDK7LexLkC+q/j1SbvS+7ggXE430sjWFaTfuBXwg
         LILLX6KtN6WoaVHPOCZuz3iG5kt1ytWrRWTX/PfmiJ3Cznx/wOx/6AXMqSq9DgyZGekf
         20NF9Ri1dlLwbntGzpckOFKl/YNdZVesqZxbA/lRL9R9Ng+w83AbWGWZhSJV3Ug17C5W
         5wi74SOSh0h5juH3hZ8Mboze/yyWOEIXMGvSo1gervLFkR4wO728k6xe1H+szdT/KKjr
         /mzg==
X-Forwarded-Encrypted: i=1; AJvYcCVJFQZAzRU3snNXuyM/tesP+43mHpZZse6hKN3MHJgmjbuCPlOeQT/JELYSiYcctqp6z33WhJ9hOQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5lDDTl65Sw5JzPqXDTAYXI4ZpPwA1RcOF37KXZ2xolQkObx5r
	W8uy/xD4yBr3IrB1ofbAu5QI56WfllnQCosf3DpkizCbrJtsDLJJKsf3
X-Gm-Gg: ASbGncsLA+n3YaYvhbDwuGcaSQHyryKr5bbzbemluYXdDzJbjsirpJlDKh1/GH+aZX9
	YlrcSU6xdmqaAfQpPwehNHvWbPveqEYIcHdwMSovCyBL4jL3B1AX0bI5HEYKd3QV0IsILigKRKu
	HVMQjeH+ovyhf/3zTXR5W9EQMxDK9Y+zxQNsPpPieX4ImefsDe+S9vEDpSU9hrfsmegSZhujC9L
	9Jcb/3+KT1j7+9QbZS2KJdmxW5hVnDZgJYFpKTxRHf2wZXCvluNtts5ltWj2VbOgvsLmMvBhUZ9
	iSiMLm6ysH1EjX6jS3S9OMu1Zfm1c55+QVNCC7IZM8+Mr/pzXWOBeSW3+jEX1LND2TQ1ElB5q24
	XdhfiGvujSrtW5fhp/V5XvjAPWUzfj1ylg+uwRfbkA7ZU+A2Wyr1toUvX3ZSuOzrfyuKvdA==
X-Google-Smtp-Source: AGHT+IGarQgcheZEM1/QGJfcDisek79ClQ64kz+uPazDh9Gj4B7KdpfexapttsvBES1Aydqy9ysOyA==
X-Received: by 2002:a05:6512:ad3:b0:594:3570:3572 with SMTP id 2adb3069b0e04-595841985demr3155242e87.1.1763377187823;
        Mon, 17 Nov 2025 02:59:47 -0800 (PST)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5958040530fsm3135965e87.75.2025.11.17.02.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 02:59:47 -0800 (PST)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>,
	DMML <dm-devel@lists.linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [RESEND PATCH] dm-ebs: Mark full buffer dirty even on partial write
Date: Mon, 17 Nov 2025 11:59:45 +0100
Message-ID: <20251117105945.10179-1-urezki@gmail.com>
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

