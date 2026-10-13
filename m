Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077D7556B92
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924925; cv=none; b=RIOzNuW6f9YTDWElUGatWyyuVn+2Ks5hHteGlIJlExnnacriT+OMFUIa/ibwwLAmCv95DXHgUg52m6dDWGwQiW7Ds2SOAUVh9g5rs344X9dsL1Ekwtwb3PndDjkxHSp3NWV+RoWge0IrBXsL411cOI9nJGbTuo/YtOpuW0UnmDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924925; c=relaxed/simple;
	bh=lqtmMOq9NyJHWkCTixF/EfRvdzo9ti4x7BRbdW0dvpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIRrIdUtAl7sjNGL/EBBxNQE9wGD5HRUepBJVHXCaqvkgsDNxnxIakJExCfAa2RGaIgaq8MFY8UlnF+6I/AbbuqQ/SPHFPZkE7CPUoU/h/5vM2yDDBX9EezqEe3Bxdq1gCaYoBs5stnDXop2ikc28P9OwcuxxH9g882ZGzWJqlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BfiF5kRH; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BfiF5kRH"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a018792ab3so28468315e9.0
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791924920; x=1792529720; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=BfiF5kRHbTCNN2YzgzXvKqiEQYEmvxvyEHhpciq77Q1oU56SSfIFme/ziq2QKIfiZU
         tIgBYIXX2qPN6vs0MyTl/ajBkQ1fOAP4ltkdIixMUTv8iTAFCftIXip/xg85514yxJZh
         MUXLw9632b1jBzH69TI3TcinTIqzMZ5l9etKqpc3isL3BmAw4FC3PD05L5iOp3V86SZ/
         CNmRl1yLBKg0bSA3iQ4fEFnlvIkk6H69epKKDIHwoh8hZJgmZytKvDlxlyUS7SsjG2r4
         H+lLR+eItKgJiX5+RmT8+kGci1jitZvKe2h4gxpbrFsnc32JrGnLEDd6vgEl348KZnno
         YQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924920; x=1792529720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=q8H5jCy2aAxishf+V0WZs+mgtOwcUPLCUyfck3L4B+OyhjhFetJtzQG+DZuly5sejn
         PJ5NcE36IrXqPDB0XfTVTuhit/heDS/oCpL/tZ/jDEnVJ292Wy3wH353lOGzOJryv+H0
         wXVCr96oOVgg9dwVkex03eXfvzA0XQalGbl+WHQyKYxo3hTuXp6eDxWxxkUPTqVpCYx3
         w1I0o5Iu71FnZ/U2sgfXXlJzWJKytqa67sPD0PfbY7QcEm5I03XhnedX4FpHGBQKA/n9
         BNUK2/LMGDbjQ9EHivLrgsE+ffM/lIVVFHFpJ7dya6s3WIAXll5zyFP+Q1hxMYTKyem1
         LimA==
X-Forwarded-Encrypted: i=1; AKwUvBxEPsA3jhby8/uQHS4Wl82g8SNQqSY6cTVVp2KsCXx1lUPhh5IHVU2SLDwBiLVL8zZeAOrzIpIRKQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYKjfR4idaRzeYN5J/RnBq6wNgG0IaX+HODdU5Ox0vasJ8Yr1byD
	jHAgmFHzSdwZJ12ctsTPLzCwuzZTquWdf4S7NBlNZWiSk/JBt0Qr2ukP
X-Gm-Gg: AYBFou3Xxs9IFoOxMJHbRh+s4yw+QLdjCxoyPvZ/64X7KqcFXBa5h71e06qipYC+joX
	JDGYavSGdkdgnnoqoNChLjPbFmZ8nRrZYTZGrxbcA23zBrxiM2kZGyW4bdUmymcX7qczsFJmL79
	O+9CRhNMXzOjs0D14zGyEy48IpreBmHVOEksqOtr+tSmwAz5ZiBjOC9nOLYYPrzePf3cG0xdR5v
	4V/peplhI/5fcd5YE2FSdac2KFAQEtTXeTpBP0SACtN4dHvsWRhpGKxbSwUfBAxdkEGerjs0mUc
	wGyC3UCyS9MI2AwdsXp6V+diB/Vn3rFrK2UNY/zQFiw0jZkBZx1cU5xZJ5td2ws3L9SOaOtuRA3
	mV/Q+VeOrf16Dkx5aZt2XkrBzUl+2gvzmYp/2Y6QKZTCwEG+cYZH72J+c5UK3B+o9oUW1RYqLaW
	aBwOEm1mGqx+WLPp0L1SJRUL9KZEz389kARa0p1HwpMe0NiKzWgMl8ap2HAwrmf8pdE987FYWhW
	4EwcU7UihLiQ3aGIeLxb3pNENFTK4563PMbKBxXPGMcOdCCH+cBx0qf8F5SrdV7lBKfGCMrZzWm
X-Received: by 2002:a05:600c:3e83:b0:4a1:6d35:779a with SMTP id 5b1f17b1804b1-4a18e446880mr243665015e9.3.1791924919983;
        Tue, 13 Oct 2026 13:55:19 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de7273a0esm2380730f8f.29.2026.10.13.13.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:55:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org
Cc: asml.silence@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v10 03/13] block: always adjust bi_offset on bio_advance_iter
Date: Tue, 13 Oct 2026 21:54:47 +0100
Message-ID: <007fe19ad4e949ec70ee74ef5cb05774656c62e2.1791924581.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791924581.git.asml.silence@gmail.com>
References: <cover.1791924581.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend bio_no_advance_iter() iteration to also increment the offset.
It's not currently needed because the currently listed request types
don't have a buffer, but will be useful once we add bios backed by
dma-buf, which don't have a bvec but work with a single range.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/md/dm-io-rewind.c |  6 ++++--
 include/linux/bio.h       | 12 ++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index 04f3fc8aeb6f..b22719c6411c 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -113,10 +113,12 @@ static inline void dm_bio_rewind_iter(const struct bio *bio,
 	iter->bi_sector -= bytes >> 9;
 
 	/* No advance means no rewind */
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size += bytes;
-	else
+		iter->bi_offset -= bytes;
+	} else {
 		dm_bvec_iter_rewind(bio->bi_io_vec, iter, bytes);
+	}
 }
 
 /**
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 17944e44b584..892ca469c570 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -113,11 +113,13 @@ static inline void bio_advance_iter(const struct bio *bio,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+		iter->bi_offset += bytes;
+	} else {
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 		/* TODO: It is reasonable to complete bio with error here. */
+	}
 }
 
 /* @bytes should be less or equal to bvec[i->bi_idx].bv_len */
@@ -127,10 +129,12 @@ static inline void bio_advance_iter_single(const struct bio *bio,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+		iter->bi_offset += bytes;
+	} else {
 		bvec_iter_advance_single(bio->bi_io_vec, iter, bytes);
+	}
 }
 
 void __bio_advance(struct bio *, unsigned bytes);
-- 
2.54.0

