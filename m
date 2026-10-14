Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486DA50255B
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 11:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975773; cv=none; b=bTh6LOkUA/EPADk2B1l1CwKQBGtrHaN9Js0ySQlYPHIwqi+YXhBTobYkNN4dT7f+8ddzIjm3FCO1UcdtUSLOi5Xf+J3QRN91CDyPaz6xah5AcWuUNWENt+WCkxPoiJDITOLhjOCOAorwvVEPauPVD14S+hl35iHbhtfLZr4k2hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975773; c=relaxed/simple;
	bh=r60ha7f86tSXOy7awDRSeceZcMhT0AOlgJWaxT3jtGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+IUUnoUXxX1ee7oCpM5T1Efx5WeB09n7ueoZRe7+JF9f10Seig0toUn0hXPBruCVDMUtCpEeRkWU/NMM5bjk1+F7aPofb8FWyYrjUrgbhoy7cnpsX5k4YF6R2vFR3mBguwPdJsvp61q7678+Ndr0XMeCkTH7UDkVARN9r/CvVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5mOzFZL; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5mOzFZL"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a061a13884so34066745e9.3
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 04:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791975762; x=1792580562; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ays4SVba18pfRPB/Hpqu6QDaxGmpKJaoA/2lD097Khk=;
        b=c5mOzFZLeqBXcTrtAH8RE0oUCg5bbYgi6z4PCkXMvNOX3wle3IejuAoOd6XOTTkYVE
         u4LilwmLKPYc1YBnC2jzozAs/wgv3rlcdePvBYpWCYbIcRemGkRSFzAqU1BBZYmd2bva
         OmJwZAOTE5hK1e/mJIrPkz5oTL4IpRQMifrlkZ/QFpSCL7l4yTYTZhAfRw56k9Lux2Xh
         uOqXSLbSeYWX3Yr5ZKrgz9Kz7w9RkuU4gQOkbFMUgFJnGdogfQ76otORDXK8P4x5MZ3s
         ajUoluKO/iBd9pRHT9srhmvwbksoqGt8vjQQo1dgBTwfpf7+0zy0TpCWOhNgUaHGAJj0
         Y7CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791975762; x=1792580562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ays4SVba18pfRPB/Hpqu6QDaxGmpKJaoA/2lD097Khk=;
        b=e3o6kHXfF6wkbPwZIvjA1yuy+rQ542wUT3E9hxnLrimue3+ot/XM10WYGdPCkbHUDg
         bsMJ+58mXFaSQYL/Vbf1KHeG2jQlS97UvDoYT7M+RPBgeVBLLVcYN3HoWVc0GdbCNdcG
         OtmH3Em9dAiPNvOIa5x7qoKidUGwg3kpq5qt4OqUvHWAOdrxo/kMohHXXvzbcNxyLO9E
         6H0EWdSboXUOoVJUKJCcHxuquJAO0HYpmO2C2V3za/eI4RaY1qAJeYOgnyvRJFFmpbON
         ZSP4+nFsZUEaMq/FU8jNpvM9nP3SgrDgy3ln5/jmwudy8C2+CvBQLVkqDScF8Zwtrh00
         qSfA==
X-Forwarded-Encrypted: i=1; AKwUvBwUmLKLrT0E/R3CFF2+QoFniA2LnsdbFqBkFynrWf3LxB6FlYVUidfuugidSLD0313+/IOKdurgVQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYJIZV0b2LssTWwEpkN1y9WDjIc+G/DGxaP/1FzhVH6BKG5Szomo
	yVFLNDSPeWctAw+0PmK64wj8elsxMhD2Sc9rgyio5sTrFwDPL2OK2LFp
X-Gm-Gg: AYBFou1T1fTNUMYHGXYzMjxkVx3S23vtkR4fbSKyKGI4ZJIP0TgTTRK8stpKZkkoQhT
	iOfSHd8ygOoqAKwCY0LLPyrTgkeBoxWxz1cU64JrLaov9x0AhhvepiajEo+GEMOCOC5vSHspkot
	OKygsWGXsm+x8u1Wy1rXsZSM+f2c9Gpi+LGf8elti5xh0gXqq9uO+tHzORPD+mZiUO9ChXv3Dx3
	69/7ksyyDT07zMiwMKBi+upXVXgBUF2GhzmIUJjdRH84F8XFx5a17dUTEqfy2LKFfXhnDVWjdtZ
	z2aSHtzCYH57eXHTdUnSnyXx3sQM1/sEEu3urie4F4R3VMfmSCDUFCooRiZx51khN02Vn7+dzcl
	RSiWhOVyVeQmLsixgp6kJqEYLiArzAZ0bOMz822trrnp0qQP8yiBbsEe4SJof3JQ3wvA5yF2JQw
	bzwdtfUCF4TToapYsLLx3lGaihArge0JR4rfCTKIMli3OqQxma2izoaL09nc4paL9pL4uQg2/CM
	1W0hwRHA0YLYVdxsnEoVF1o0KelupZ/NOAfgEZoIQIpkCcNny2SrfCClrpAjQQBN4FkBeVdtWKs
X-Received: by 2002:a05:600c:154c:b0:49f:ce78:3562 with SMTP id 5b1f17b1804b1-4a18e4a9159mr329602185e9.19.1791975762395;
        Wed, 14 Oct 2026 04:02:42 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b45eb78csm38078845e9.2.2026.10.14.04.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:02:39 -0700 (PDT)
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
Subject: [PATCH v11 12/13] io_uring/rsrc: add regbuf import flags
Date: Wed, 14 Oct 2026 12:02:10 +0100
Message-ID: <eb798e045bc245ebb7b0b42ba09a34b92f8b216f.1791975048.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791975048.git.asml.silence@gmail.com>
References: <cover.1791975048.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll have special registered buffer types that can't be used with all
opcodes and need special handling. Add separate flags to control
registered buffer import, which will be used to specify what kind of
buffers the caller can handle.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c |  8 ++++----
 io_uring/rsrc.h | 24 ++++++++++++++++++++----
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 532866a1e9b9..f42d201738cd 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1317,9 +1317,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+			unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
@@ -1733,9 +1733,9 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	return 0;
 }
 
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags)
+			unsigned nr_iovs, unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 	struct io_mapped_ubuf *imu;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 73d7b1ebf0b6..351995b61e68 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -62,12 +62,28 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 				      unsigned issue_flags);
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags);
-int io_import_reg_vec(int ddir, struct iov_iter *iter,
+			unsigned issue_flags, unsigned import_flags);
+int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
-			unsigned nr_iovs, unsigned issue_flags);
+			unsigned nr_iovs, unsigned issue_flags,
+			unsigned import_flags);
+
+static inline int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+				    u64 buf_addr, size_t len, int ddir,
+				    unsigned issue_flags)
+{
+	return __io_import_reg_buf(req, iter, buf_addr, len, ddir, issue_flags, 0);
+}
+
+static inline int io_import_reg_vec(int ddir, struct iov_iter *iter,
+				    struct io_kiocb *req, struct iou_vec *vec,
+				    unsigned nr_iovs, unsigned issue_flags)
+{
+	return __io_import_reg_vec(ddir, iter, req, vec, nr_iovs, issue_flags, 0);
+}
+
 int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 			const struct iovec __user *uvec, size_t uvec_segs);
 
-- 
2.54.0

