Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795502509;
	b=rt2tUGLyLurh1aNSNbUGlwaraUUL6zdnDupmNVUPBgoTxMfSvJHIBY96NIO+28WOACj1
	 ujgJ7VeXseF43ZncagyprJWodYz/O4W49b9bKZmV3G+wiCr8KHer3c9ea48dT+rK/z0Rn
	 KnUnH8WCAaCWjauI1eNCtk20e3BwdXh/lvdc7yuS5EF2k7kRkb/pLNRCGrKMA/aO5+p7X
	 H3b5DMFiA2oIJ+H3LJCQEQe9nfQXTdklvFhJ1iVLqtS4uuga6iKly2PcOAPZv8CUotIGc
	 G+hO8M0rQbrH8pB4+xlRBn7RtJK/tlTc4m+VKf+vHvE3WTpKcCN50puM50YQH8ClgvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795502509;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=4WuFVQOFRYWtvH5f7uOdSI8usx8SQMpezyzM1BSEdVs=;
	b=Gl7+c2nWVl0Dc7Znh9tcEAoinTV4CK9OiSp6L45D+QhhlpaXedjQxAKC4MRkmAw0RiRG
	 O/8NWYlvKsOKPQNsvYRik5C1wyKW4ZeqovBxnszrVLezyr1BeDv4B2I1m5/UAAy7YiUYU
	 C0uaF9LGWt/3FwhYIqlgPvtHzTfYOeWhoduAcLl0B6dZpR5AJnmrOrVDcOMRk6DX4ld/+
	 ukkPjIfMv4fohn4+cFnXzQ1JadkWuDQHfIB9snzLIm4gd7+ekiL5nELudR2xdTysS6iK5
	 Ap8UP0Ox85LeFQBme3nMXVDhA1uXTf3OC50/AZq7735jo7i3y8BjbD8IrHjUQu9oDDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fGi0a1ht;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44359606A321
	for <dm-devel@lists.linux.dev>; Tue, 24 Nov 2026 06:41:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44359606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fGi0a1ht
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8b6b22be970so1571442b3a.1
        for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 22:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795502508; x=1796107308; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4WuFVQOFRYWtvH5f7uOdSI8usx8SQMpezyzM1BSEdVs=;
        b=fGi0a1ht7kLqEBtLpyTNqXcDfGPGhnBIEC0QgqRIem8a7epH2e38PxE+6+RXQOOu9G
         pgr40vAmZDodYNNpTPT2Ulbcfo7g3bYveO5k8Ta/O3zX7zxwQK5ATrrID/FHJ8YoBFnT
         prKANOD24nmNJ9mmxv4ggK9TnB4BnB4tyRcp5w8puuv1ug8n/TLpsOohK/LDPei6UWIx
         qg9DKGBv/jUN2OjCAVYt0uJGxnUx80eH3PPfOdiRxdz5cnn2oD95QVVZPfhst3fkxgW3
         +Qduh1UMkUOQiyZajcZlwU3dGAVnlo28WzaRWhsshsCm4OxDglLvLLp772g2oz76b851
         1PhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795502508; x=1796107308;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4WuFVQOFRYWtvH5f7uOdSI8usx8SQMpezyzM1BSEdVs=;
        b=wdkzhX9NPXAIcQ66nFHfd1Yjv8teNYFbwb5JXa8mpY1qp3rEId+rPCaELMCLtJZO83
         bXxRo5/vgQxryXraGbUCXXgB8Zt1n0pbJfnD34Pb15C5LxUQEuIQloslcyzQ0i2tvaDu
         OUM3ADh2P6w1dXEofFPZHum+ZwwS6D4q8EssmePRI8HbSvxSsg1cy46wXvvq6Nmt5jZH
         OG0F6Df88l+N8h9W6z0WRTLxYPQTBo7KSArwq4Y31gCG/GN9i+en5oWATwfjBC4pDdiL
         ScJHj7tB0G/Ohsqp1eJtFOckCVTn7/oZt4twqkeVNTeKBmay9lfl6teEU2vXgYPTN2gV
         mr/A==
X-Gm-Message-State: APuU4Z+bjxRyyNQ0VAkpORbnn9YdFKAdhWrtuVE7xx3Uu4SclApW++Eo
	ab6wRAUpt7CtS1qy2gtpeXA6DDrdOogItDEZKZgpFF5UrQ4cTYsS4URx5cK2dw==
X-Gm-Gg: AZFdTZcnJdq3d3i1l4N2UHqiU0+RHCLlHTw90fFDq5nMJm+i9F79r6aNfEJPcPs26NV
	Q56wyWrZRFL2qGMykgMqf+LONRVjWFZzrfvnb0sI1HT7nzJx0RzJitOv+dmpL/qduaCN5a3pCg7
	SyMauZWS8vc/f9eADej9aqOvCTFTnj+7MK7fFc6A9nDmSOKjTEhuCFAUylWSwVdqooos6KR6uAG
	xQWv1LkcNwst/4zTM/gBZSxbt9tY3feRnYGlW0xXAfO0xluHFtwjkuIqxxvc92GLdYmJRV6mv/q
	kojs2zl4uIWd0ykGuBM9L+byM611LXtbQPN7dlUb10FHZM8BKEPskRQlWCDekl76PN7zPj7LHqb
	EH1HEZXkurjIRfD7bD6gwSwae0wWOGtZzd825dzYA5BUcNiKhowZOj7TjXpztOwDNFT1IKJjQn2
	r9jhjqEeIJooM2iSBLN55q7AVjVcpCNOB0aqVxdM7TYgvQIwmr3aONusu+X6B3liNU6WJ5MupOW
	0aCex4whanvEcsX9Es67e9fUri+9t5JDEIwfAcG5/gnagJQcMEuloqhy6G7TYR7DzYp8wRVh/Z2
	+8PlfG9BfIHx+eJXuzuNGqVtKITYt6Y=
X-Received: by 2002:a05:6a00:4a06:b0:8c9:4ad:abf5 with SMTP id d2e1a72fcca58-8c904adb638mr8505595b3a.27.1795502508396;
        Mon, 23 Nov 2026 22:41:48 -0800 (PST)
Received: from thangnn-ASUS.. ([2a09:bac1:7ac0:e88::247:18])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87077a058sm6745089b3a.8.2026.11.23.22.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 22:41:48 -0800 (PST)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: dm-devel@lists.linux.dev
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	linux-kernel@vger.kernel.org,
	syzbot+dbad68398c8646e5a382@syzkaller.appspotmail.com
Subject: [PATCH] dm cache metadata: drop the last reference under table_lock
Date: Tue, 24 Nov 2026 13:41:43 +0700
Message-ID: <20261124064143.118819-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_cache_metadata_close() drops the reference with
refcount_dec_and_test() and only then takes table_lock to unlink the
object from the shared table. In between, a concurrent
dm_cache_metadata_open() on the same metadata device can find the
object in the table and call refcount_inc() on a zero refcount:

  refcount_t: addition on 0; use-after-free.
  WARNING: lib/refcount.c:34 at refcount_warn_saturate+0xc0/0xe0
  Call Trace:
   lookup+0xa9/0xc0
   dm_cache_metadata_open+0x104a/0x1560
   cache_ctr+0x145f/0x37b0
   dm_table_add_target
   table_load
   ctl_ioctl

The closing thread then destroys and frees the object, leaving the
opener holding a dangling pointer.

Use refcount_dec_and_mutex_lock() so the final decrement and the
list_del() happen atomically with respect to lookup().

Fixes: 9b1cc9f251af ("dm cache: share cache-metadata object across inactive and active DM tables")
Reported-by: syzbot+dbad68398c8646e5a382@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dbad68398c8646e5a382
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
Tested in QEMU (x86_64, 4 vCPUs, KASAN + lockdep) with the syzbot C
reproducer (4 threads racing DM_TABLE_LOAD of a cache target on the
same metadata device):
  - unpatched: "refcount_t: addition on 0" in lookup() in 3 of 5 boots
  - patched:   0 hits in 4 boots x 8 runs x 25s, no other warnings

 drivers/md/dm-cache-metadata.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 461044dca367a..04140e6b1fb92 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -877,15 +877,16 @@ struct dm_cache_metadata *dm_cache_metadata_open(struct block_device *bdev,
 
 void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 {
-	if (refcount_dec_and_test(&cmd->ref_count)) {
-		mutex_lock(&table_lock);
-		list_del(&cmd->list);
-		mutex_unlock(&table_lock);
+	/* Drop the last ref under table_lock so lookup() never sees it at 0. */
+	if (!refcount_dec_and_mutex_lock(&cmd->ref_count, &table_lock))
+		return;
 
-		if (!cmd->fail_io)
-			__destroy_persistent_data_objects(cmd, true);
-		kfree(cmd);
-	}
+	list_del(&cmd->list);
+	mutex_unlock(&table_lock);
+
+	if (!cmd->fail_io)
+		__destroy_persistent_data_objects(cmd, true);
+	kfree(cmd);
 }
 
 /*
-- 
2.43.0

