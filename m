Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A296301711
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 23:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028111; cv=none; b=aRkhpaaex8SePUYpOpi+tB+MKWKGO4eKVYBy7c2oxEolxx+MK7jB9k0q0S/PxuWDZDgfomSp4VsVcZN15IfStWtX+8+vNPZHTXBftVMrEmzMZjPHG2ZC6nS9oYK6RD7PzF9Na7132rsG2gLHBmH55a2g53aRWs3LupJitC8o/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028111; c=relaxed/simple;
	bh=Am7Xg6QJV818HftQaQoJheIX+hzBGkDxL1hHod2VREY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eH65WDOhWDUGJIzJSyq1t3NPY6mfPD8oYdZyhgYdSZpDq0SPAQT3rlqKXnFHP4srKPcedMshCL6KmjPyKMuITtJhu/lsRU5ua8in0a0CELo4oyYjYf9XRArwMZorAwrYj/6sZ32dvOsRAq3vLmMnBiNarb6AB9PQY4d+wDnfJJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aStkcUnx; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aStkcUnx"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2955623e6faso57155045ad.1
        for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 15:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028108; x=1764632908; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=14mujLSQeTKxSJUy/um1pAgQzTbPorW1qBu/kH6klR8=;
        b=aStkcUnxiaPnn4uIA9dkWsWnzZTi/hjpBtMmkhr4cwwwyKy0IBUdz9bVz87h56Vw32
         u4BZtz7qhGbBKYQgHyeh/WQXY803HevaAGvDT//wQ+6gsvmKv6dFvZSYnJl8uIjZ3e+E
         TruGAws3ye52hilzl55gmSfBa52nXwQiTbiMvUr/H7FT/YX7CDNsKDNmVWHeD+goJxkd
         /4cwc474j3cVWSGcif+HDyAjZWBsLuQZpzq4Ehpx0F14wmo+IHmMOUgZZfMDsRBRFbSF
         WVRR0MLrHzVP3m/pMslQs3OJH5sxd7oobxbzT2uyOQWSvMjQU64nMAM7uHqqdOSJR5cq
         A/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028108; x=1764632908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=14mujLSQeTKxSJUy/um1pAgQzTbPorW1qBu/kH6klR8=;
        b=aSqVyvsiHLnSyInAKH3faI6g+gjXc1iw8uj1lSmWtk2QbmShDz3aP6spfPMvH15dIz
         V9UzN7nFnpqySCDq++pqxBtGcQmpxefZrIEG8lvdgXtVWwU1V6Xzj+91SODYiEQpjfkA
         Kv5mnomhe/DP5U6JBBkdHDPjEXTPNSfQu3h33tRf+Pg+ZpNOn3EBYYuQAj5zvHhQis3u
         6qsHmLuAglghxUDzAvdXyd4zv5M0R1WIxIUOVW7FZGSg80lRLzwLZL74qNILrSB3f6n2
         GaLxIDNnhv9oKFfNawplQiEwkr7KVoEwscLeiAACrZCgs3yNEbr8GLAVBjMLczzr3Jl3
         KpYg==
X-Forwarded-Encrypted: i=1; AJvYcCUNa3/TJyJcp5MF/G01vv53PpBWEKvj0afRo3QmMHNPQRfWcwsUOk11/FkeJsDKbl+nUgCiP7qS3Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzQ3oIyVvE1UZJ6/aqlmiKwuvDkxBRkr95l5/5obP55xrVV500Q
	eWA2fW+cT2RtL2kR0FbCve/OGNpdz0D6O1kkKlxOHJLz/Jhhe3tPiIeL
X-Gm-Gg: ASbGncsLzfaZOn7MiFC3lcYkc0ly2PySax5W7eDA/lfU8re6IHja7hnQLCyCvNkk4Jz
	fB7zMasiGv/hLEE5MLMMUWm8QoqHtxewyLkJaD0nQleIUHi5alkP7NTV9GGVwD1YXEoIxKFXyEx
	m3eQOmMcvZOKCJmfEtN7g9GxC++mzjMraLjhkuRIyLQ0WkwcKBmnbF6ABpKXKypHVzSMSjvOrLz
	mtnCMjs+i6xVlfaBYOFW7kAT4EoPfi0QPdW6ipfw7q1iLaRYp5nctGrA22WppluazohFmVJE0ef
	DbExhi3wWoPbwif52mBQAdEgGUY85xdxd78NNpWqHYFBaN7hO+MfZkQ10xZf5AWyEOL9hf/YVex
	3ZHZX8Dbk0hLWjKsT0qO1uAYcKrQflSKLFyu/JhfgULDFTSkRgLclMe5FG/iVBX3NyjqL7lYEUv
	ngEXxnFoHYXt4kO07fg3Ku7OKGP7qwu7hOHho1/+gOdi0BMAM=
X-Google-Smtp-Source: AGHT+IFryzmc/XiOW9LSO9isjtYB1LRYx6LJmKSX/rJnv82E/9f71NMvnHJMZsWalBLPhm0XU6n7Vg==
X-Received: by 2002:a05:7022:ec88:b0:119:e55a:9bf5 with SMTP id a92af1059eb24-11cb3ef2594mr558577c88.17.1764028108043;
        Mon, 24 Nov 2025 15:48:28 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93de6d5csm50934844c88.4.2025.11.24.15.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:27 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH V3 5/6] f2fs: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:05 -0800
Message-Id: <20251124234806.75216-6-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making the error assignment
in __submit_discard_cmd() dead code.

Initialize err to 0 and remove the error assignment from the
__blkdev_issue_discard() call to err. Move fault injection code into
already present if branch where err is set to -EIO.

This preserves the fault injection behavior while removing dead error
handling.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 fs/f2fs/segment.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b45eace879d7..22b736ec9c51 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1343,15 +1343,9 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 
 		dc->di.len += len;
 
+		err = 0;
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
 			err = -EIO;
-		} else {
-			err = __blkdev_issue_discard(bdev,
-					SECTOR_FROM_BLOCK(start),
-					SECTOR_FROM_BLOCK(len),
-					GFP_NOFS, &bio);
-		}
-		if (err) {
 			spin_lock_irqsave(&dc->lock, flags);
 			if (dc->state == D_PARTIAL)
 				dc->state = D_SUBMIT;
@@ -1360,6 +1354,8 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 			break;
 		}
 
+		__blkdev_issue_discard(bdev, SECTOR_FROM_BLOCK(start),
+				SECTOR_FROM_BLOCK(len), GFP_NOFS, &bio);
 		f2fs_bug_on(sbi, !bio);
 
 		/*
-- 
2.40.0

