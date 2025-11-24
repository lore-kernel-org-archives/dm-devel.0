Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A984129B795
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 02:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953072; cv=none; b=uxV+0laT3hD/gPF5rD7Eu/CmVjd4XvvtXM1/fBf53m9No0IS0QPmLLQ2DclLhu/1gu7RO1gjZHW4akx9/MUtKm39K5m2WUYGonvSxzeSy8teOrxoXxNfPHW4Dhi9Ib+Rqkp+htSaCE0xZ2nkqqOIKMaCFHRXK9pvhmyOzBvnzbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953072; c=relaxed/simple;
	bh=1rxomFQWvF3IATN9kucOuHHGa2FB/YCgzDqnGWQM12I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eBdfwADcVzRLNaNMMdsaVwPrAoqOuO4FiKx6dHCkguCo/++aU2RVSzu0ZSeLHS0CY0OPG4gTWrPH4wn/PdxTzGfWeK91suq7MHt14hUE5I5j4eapFko30Skq75UlHjdOpMPQVYcOwhgsXKZNKSrjMHx5rTmigH6cwnG7PPPeWVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ul7aLDPE; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ul7aLDPE"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-ba2450aba80so2173924a12.1
        for <dm-devel@lists.linux.dev>; Sun, 23 Nov 2025 18:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953069; x=1764557869; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7A/o1KMdHnERZPkaP005IU3nW52A8GrE+BEL9651kiM=;
        b=Ul7aLDPEimsoF+FQxiFnOnntygbqTYP5XYKWRmhl2jvx6/9p5fMQ3ODNVUS+Z3c2cn
         HSk0CwYiyTGh81C+VTHgmoJE1VAyiatEr9R5cCv2q9bm0JULMxazBBQEs/bDl0Z8xLkP
         YnpvxV0hceIiHR0eGhowpB+hxUJ/li+RejlvCLM4GZdEbrRloeTHj1HWap0nSdPph3hL
         a08TglI1hkENUBrFJBOHDVt9BJAO8cBLbO2GeII1YAQ/xpDDFusRGvSX+xHDuyJtGyDK
         iP34ECTNLRW6sOB/gJUIkmY0CaJkdjXTIZtZPJN922UJ1mwgzUM3pbg3F2NDO1R/NQF+
         oH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953069; x=1764557869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7A/o1KMdHnERZPkaP005IU3nW52A8GrE+BEL9651kiM=;
        b=VUGJcuX6CTXL40Sm4iyoNEXiz24d1O1CF/YX72jLmuhHJFrVl34KxEb/XoRWX6X56g
         GBxZkxWRz8ixOVDgtfw3JbmARzlYiWHW3lDD1+El3tHOvF/W0YOLrE3+UmdctNACX4l4
         sPUCEaojhXQUFKjvsZb4CchaXu9eAbtqSq7/ALZi+EurD8TycfP+/OzydAmb0aXTuBGK
         +bklfjKe/jt2WOvE4aYh8B37VSVxi9EW5u8NqiCe25qDCkTXuftF1s9hkGN3rBsgZNJL
         1P2Ms9NXODVPUGeV2tGH0+qzDL7VqQJmX19jSMLAryDmFDBZ80JE4IQuUw6eV1+2+p6p
         yWGA==
X-Forwarded-Encrypted: i=1; AJvYcCXdblEfReihHQON8CB2pSHs6hIlm2yWmhBzcENiqwvhZ+mL2mhhI/6IagC7Y2RvXjgeDGRETsNnvA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRVuGjtXtmTtFgQNO61ED3jSeSsIGjRCu8nwneNrVq/7rnN9jm
	0iTn7BbE47U4TdS1ihOEoNRhsQmEf23O0i6GMa1dZLxnc78v0GnfrJkF
X-Gm-Gg: ASbGncueG0TdGls1zAu76PVaWiYFsSFgMsuiSvYKbexq+EkeXjgd6BYAs7WquaQUUmA
	/7No1vByKLz80LCMFbWqjDnDCAcXhFM/sfzrnwXxYuAKO0gIht7LNm9DHpV1Z7Mjp59nslusw57
	/l+OMBO+F0DoYmpPczYvHGBp3JVVbeEqivXUpjHgB8MOnnasEU0TdSw7yRVSgBcCBHn1M7Imx5L
	ciVr3LdED+KyKMQkMG65gJU5mLzOWzs27oMoYnRoUrFnraMLneN2hXWlW4gE7TRyybr5/HGNTrQ
	SFqP0IUwyDQKodIzHgVrczlb/5Ie/DuupqwEKiUN3rBT0L8cEG5mjZVEJB01KElQEy+iBgbXSre
	WOJ9qfC2XEOQMVfsXo41KCBJrbxbWVMkUE3sEpkgjTTfeqj+nLU2tusogS09t3KrtghOzOTmQBC
	JRG7ciQb5/+WywFQ18nejcAufVJ79DZRceyqx2eHYyRuxu8VA=
X-Google-Smtp-Source: AGHT+IEmMLANDAnmsBNCneTvCZSlRusetXy+m9HCywmHN66AM/499qf8PoyOZ4xW94y10CRf7NdkQA==
X-Received: by 2002:a05:7300:538c:b0:2a4:7cb9:b7da with SMTP id 5a478bee46e88-2a71927d85amr6563682eec.25.1763953068821;
        Sun, 23 Nov 2025 18:57:48 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc3d0bb6sm67532109eec.2.2025.11.23.18.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:48 -0800 (PST)
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
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V2 4/5] f2fs: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:36 -0800
Message-Id: <20251124025737.203571-5-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
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
__blkdev_issue_discard() call tp err. Move fault injection code into
already present if branch where err is set to -EIO.

This preserves the fault injection behavior while removing dead error
handling.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 fs/f2fs/segment.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b45eace879d7..3dbcfb9067e9 100644
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
@@ -1360,6 +1354,10 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 			break;
 		}
 
+		__blkdev_issue_discard(bdev,
+				SECTOR_FROM_BLOCK(start),
+				SECTOR_FROM_BLOCK(len),
+				GFP_NOFS, &bio);
 		f2fs_bug_on(sbi, !bio);
 
 		/*
-- 
2.40.0

