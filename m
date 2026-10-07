Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF4233FE05
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336737; cv=none; b=mAo1UAdtlnxXAORQhZtAr3f/mu1+bpb0TB1cUvXGNQ/s1ldZ3AeE37ONK13j4o7a5EjzZnb251i1tpDzIhB9gU+MWcNnz2lcEY6IUG5f9om7A5D6G4AD4kYCw0g6x3AloI6vxJxg8NHxtcYH1ZWEtqva79sDH8noKWEZs535pAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336737; c=relaxed/simple;
	bh=lqtmMOq9NyJHWkCTixF/EfRvdzo9ti4x7BRbdW0dvpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rImPWfneo6Uz0rtMMReDO1wIDssNnkUsbBIVn70xV4K09ZabKiZnAEvRy/6IRKSJYooNrv7SZ7b8YlSEeVaFWCumiJ0CF5d/wRa8nWcoQqjx1lls3TtQIk6ynxpUxZT8TxW+MNpyKbdZVGVXKu5MRo7T/cGQM47PUjoKUOhSyLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yst1UV5b; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yst1UV5b"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a16c1608faso15399095e9.0
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791336734; x=1791941534; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=Yst1UV5bhffeMHXQq90G816DPzFZsjbZy8/ZmIF3TbThb2pHQdif0wWlnXc1cqaJXC
         xjkBKwvZuEqfqigjV8RSN68wkfvvnLwSqZlmNlzqcDmo9oJxKm2XLe4DMHIYn2KvUQr3
         6uY81E+CCdGi3kVZDYpOJ8fQpJhNC78+rH9mm8w64Q0bghPMYm3eZk8o2imT36e2I1us
         RzbUUoD3IG0wnNrgKn9rOtzJuOLA09OHUPq478StrrLvIHz90+xctn7YfVQpNw+wYp4o
         2rYToBxaOp8VP9imu4hh3oY9ospOc77U8C6rwsEQyCuqy8SdeNBjwpe4ppyLchIQTEa9
         qZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791336734; x=1791941534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BooWm7URUcyrH2E2qkRWxlx7KQoz7GWFpr53v56Fl9k=;
        b=pNPmiygwkJuvoenmGCNe6GW8r2wJMM+/b6JUq5r2AnnRAsTZ67fhJPFBVqHMgr4eCq
         nn2YXGgMd4/QoJ9jSTHLm1Wvu8zUEcKDYwHRtGDvYoMAsFC0ktpcxxupvN6wxdgskrnX
         n1RSu3KHueeAZRevqSMgtCp9XIOktZC2d+BNpgblduN+jgKMCZEk5Fmb9X/tnng1WJUf
         B7d8o4jLMGO/VRThoBQo22VOG6RJFbZq6ZcMC0yk4zlQ6XCcGA9boPZ+6H7DmzxrAKIO
         RQu33kMNlY9XTAaBp+T+Rw7dEaDQVQwXDCILZKpTBGr05wzewzfxHjC6jktMYMiw9oUt
         PuyA==
X-Forwarded-Encrypted: i=1; AKwUvBwRWTG/0k62vJL77HLSetlJjRp5pXPcYzCkR9UXDBY5y8RUkvgcruX8nxeE5TAe2C7HTxuz7SKE9A==@lists.linux.dev
X-Gm-Message-State: AFuF++lkHmMEFOPo7Frw3OfyRtEe6RW4etEPwC7ONroPZpnWpALBNNSm
	X6K+03UovRp2S6W91zecQGTZlNFTm4AazH3xOiUmqFfOGWU+T8J1myaj
X-Gm-Gg: AYBFou2rUKpZIoeKIUncSsbbA/IP2PIUl6ffqSTiiHQl/aQvC9j9ingU/JPwNXFyj7X
	neD+ROlDS+n0aqbCygNKR1LdQCMJRSHuTTLk7WYbdrttsk0J+K3xOUaZ0i/T/U9yeLGRpv5NlBr
	akqY+hvekD/XhfVGp9GoY5d+ZUZ8oZxp9kc9om+6LPWWmvvLoeYBuFtx5Ptxh6hwt85t5xwRG11
	yNLih2CbjojDyVx3rX1xx/0DCD8ibqz6Pu1BFI5HrHXrwzpCyXO8LS5tYETOKZnJ7CQcOG2QuR4
	P94MtCyx2BSqxP6Hf4WLX72In1a0r92PFWU9BZE3zoqsmxmB/4PG5lh6LQOir/dzPonPJdb6x5c
	ZeOZJldKsesENVrXy81FzDtv+oYXPt0IUFQIArgjYUzIITHI2cj9rHAN9tuf3mlA4XdPYVCuopi
	dbxGWaKmqyPujuahGLyPLPqkFiG9nv3vQ/ZSCxfqEyq/UfBNwNDRYVqP42ezxlTjr5vk2bZMwjn
	YfZQCkTRxNB10OJWjsfgjLFt0Inaig8/cUH964xP8dJH1h3w1qLTPjHxKF9TWoSjwMwaxS8ih7M
	KDDW/x4g1/s=
X-Received: by 2002:a05:600c:810c:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-4a180422b6fmr8623225e9.8.1791336734141;
        Tue, 06 Oct 2026 18:32:14 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f6538b7sm21183615e9.13.2026.10.06.18.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:32:13 -0700 (PDT)
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
Subject: [PATCH v8 01/13] block: always adjust bi_offset on bio_advance_iter
Date: Wed,  7 Oct 2026 02:31:44 +0100
Message-ID: <beec7303891dac21cd620d2a47842f843b391192.1791336002.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791336002.git.asml.silence@gmail.com>
References: <cover.1791336002.git.asml.silence@gmail.com>
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

