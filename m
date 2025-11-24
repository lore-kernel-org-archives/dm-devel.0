Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1746229A9F9
	for <dm-devel@lists.linux.dev>; Mon, 24 Nov 2025 02:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953071; cv=none; b=gaXbglwdlAHlTjq9o1hLwumysLJ2uUTpUeQZelcgueD8zeWOSNtrF0xubYmoAq9TGKkvGv+lZh1s1vewycaio8A4byLKLASWOoxE2NflTHHQz9MW7WNy0ek7PkBSNzknAi1hiqGvTei5zFb2OB8kszfAqFpk0wDK6+arZGFLpO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953071; c=relaxed/simple;
	bh=CHhIhTF7NAlbIHo/7TRGjQSC5FGBam+nH0hmtRIrdo4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jiGjHe8tpk/1959rPyJITALFddiPJPkhXickwmyXgmvMww2Tlpe5TvIgchAl7HtRvaVobWeVe6IM1BecQWsHGUR5RSplrXiLvFZikGy4OqIyw3QiGRoBMJUaYzBAf+jGy1WbbuxFTvlzjSI8GXBCx0X0uptQXNCoUgGCS0+4WuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBHUTEUT; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBHUTEUT"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso2859420b3a.1
        for <dm-devel@lists.linux.dev>; Sun, 23 Nov 2025 18:57:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953067; x=1764557867; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNwYZl+W2fvcXiK6f1dLRuPmVDUoM4hiP4tOVDl+CUs=;
        b=MBHUTEUT0uX1Asj8ovqIzNn8eZsKBK37UkIgckbLdmQWO4qu3UCIRMp2CTGuoh3hxE
         7OcnNWCe2O4vcQtvebEsaVZgNJFavBqMDcdrEXcY+06I/r3mDkMVKeBmx5wzJ6yYKlSx
         dx5S3T9zDBnu2tkOOyU0kJwHrXqmgFu74kCGSYgDgixu7KCnsO1zxiz14gN00vJ4kd8v
         V1xDbGS1vOnq7U78ws95LwuuqMbw4kOeqLO+4XnATUWCuiTDUbLPjFzZcShCCcYirS0j
         Rhhnq9410RtAvfJj8vxhh2Tg3GeSkP5Kx1l2rK97Xm0BXvH84342pGR9Oti8j7Xl6L0F
         x37Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953067; x=1764557867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sNwYZl+W2fvcXiK6f1dLRuPmVDUoM4hiP4tOVDl+CUs=;
        b=q6nwwD+192wxW+aJwUxGA4JqUdvEMAqU//FLsIVNSKo1mtli96g2nGoKE6CGHHH8Xr
         64Alm7jn/0HyOZe86YyyVcXpZJcQ5KiCB6b8a3+4enodeJTrgWgA4/OIFNFhXT1zQyca
         /Xf9dB5Hlymc0xmRPR4jguIx9kYbptZynEYY0KXTS7RNzFXp9hk3i6q410Te/qINzeDH
         rlbxgmQ0oq9y68179/bSMhJYKT6hqsP833q0wUstownut3MXSL8EbDvJCRFgwwQjLC3k
         qX6J4tzDxsQC91zIaZdal6A7IDt8Y5CnKsBHEeuKgEI6iSUWoExQXj7BevZviYESoF/I
         8Jbw==
X-Forwarded-Encrypted: i=1; AJvYcCUgJInOtx1RwnuBbiO3i6gv49YThuRExX+WNL9/e1ZZaGNj9IlvMtOk6XHYzz39yTWkIn1JbHRwjA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwHPBoEpwWwdUVk1hgLLT5gm1XogpFvnIh5YluWw3cAJUIXO+nH
	a8TqhIefnWFdpLjxxYL3v0ty8vxI2veX1uqYR5mPdcvIj4NhcFpg2biR
X-Gm-Gg: ASbGncvxWNlND9OzgC7y4fWPQE+N0+50xrr952pm6zYwFYy/t7vAXRZ7PKpF/9Vk0If
	78esTryKoF8MVuHVGGv+K0z4FvGgRdnHvTkxrtUPaxvq9lxA+63sVlfQYxqkp8yXVGOw5wk/BRL
	jtGz4qgX4NVfZN9rHG3gAq9SUtdRUnNJHrLB3lf8yk0oLKhGsl6aBGMnfr9b66I3Y0rWo5npJvm
	dK0KlbMnHXM2lE8vGvJXVlZw7iUCJf83uSX4PmQAVPdpDJhHFZu2+r8CIH1w/EaVluf6tp81d+V
	ie9E1fUMa+PV+HMOtKKgXnX7JVDaGtToZ5m/JYR/g/PyCuObQCpTy4/qszTaCxTxi5jb0okMnuk
	Q070WqNxWifGNYNLkCS1Z8ng2/4KautNYCukM0G2AZuoHpSbWOrLteo1a5GTiGMP6Y9Ag7HZJFI
	cw6SV0vZrD/0c5GpAWL/wE4o0BNLp7U1c5gK43JLyRJX9DXA0=
X-Google-Smtp-Source: AGHT+IEZXRFduMWog8lY/WEBRyb3MZQs6kfaoxzTi2A/dpYZvd44wI5EVbBBu8fatXwqYTbLGqTaxw==
X-Received: by 2002:a05:7022:6285:b0:11b:923d:774c with SMTP id a92af1059eb24-11c9d613979mr6980540c88.4.1763953067290;
        Sun, 23 Nov 2025 18:57:47 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93de82c1sm45441687c88.3.2025.11.23.18.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:47 -0800 (PST)
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
Subject: [PATCH V2 3/5] nvmet: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:35 -0800
Message-Id: <20251124025737.203571-4-ckulkarnilinux@gmail.com>
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

__blkdev_issue_discard() always returns 0, making the error checking
in nvmet_bdev_discard_range() dead code.

Kill the function nvmet_bdev_discard_range() and call
__blkdev_issue_discard() directly from nvmet_bdev_execute_discard(),
since no error handling is needed anymore for __blkdev_issue_discard()
call.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/nvme/target/io-cmd-bdev.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca604..97d868d6e01a 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -362,29 +362,14 @@ u16 nvmet_bdev_flush(struct nvmet_req *req)
 	return 0;
 }
 
-static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
-		struct nvme_dsm_range *range, struct bio **bio)
-{
-	struct nvmet_ns *ns = req->ns;
-	int ret;
-
-	ret = __blkdev_issue_discard(ns->bdev,
-			nvmet_lba_to_sect(ns, range->slba),
-			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
-			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
-	return NVME_SC_SUCCESS;
-}
-
 static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 {
+	struct nvmet_ns *ns = req->ns;
 	struct nvme_dsm_range range;
 	struct bio *bio = NULL;
+	sector_t nr_sects;
 	int i;
-	u16 status;
+	u16 status = NVME_SC_SUCCESS;
 
 	for (i = 0; i <= le32_to_cpu(req->cmd->dsm.nr); i++) {
 		status = nvmet_copy_from_sgl(req, i * sizeof(range), &range,
@@ -392,9 +377,11 @@ static void nvmet_bdev_execute_discard(struct nvmet_req *req)
 		if (status)
 			break;
 
-		status = nvmet_bdev_discard_range(req, &range, &bio);
-		if (status)
-			break;
+		nr_sects = le32_to_cpu(range.nlb) << (ns->blksize_shift - 9);
+		__blkdev_issue_discard(ns->bdev,
+				nvmet_lba_to_sect(ns, range.slba),
+				nr_sects,
+				GFP_KERNEL, &bio);
 	}
 
 	if (bio) {
-- 
2.40.0

