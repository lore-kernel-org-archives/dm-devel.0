Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A733630BE
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337413; cv=none; b=G0CdWEg+ge03nK9E2aYiepCwHsOpEMTNO+0pYKbHNO9ojWDB1a0EC3d7e3iK4EBcMUEbOkdV7qjoryeKQTxaaIoQ0CC3X6RERTA9hT3nb52PR59QE5sCVq0MjmN52KRlsFewU2RVBxApswF8xdzrb9hB5I1dj2EvFXBF4shGzrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337413; c=relaxed/simple;
	bh=zkmmP/s3oaEnM5CZp4fq/TPO4woTgg6h/01Z24jsq/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAIHsbKTGGFtXuICo5Z6BveBQqQUOU1bgXUHzi6Bu77PSqUc4Xs8s+nIMlw3o5ueAG2237ern/MHWgqtUg6/7vyPzJjtwPg/Y6WpnCvM7WMFO8B8EhxWltrEyw+TYNL04KsK11Ls47yuLYbXT8lA3MbmpKJa+wBRgyYrzbi1aU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tN1hlUv6; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tN1hlUv6"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49e73611928so8953255e9.1
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337409; x=1791942209; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vy1zLQ9YKYGfqugQgTKt/AfV3rhwVDXY3KU8gp6bN10=;
        b=tN1hlUv6a2EeXXIg/DfYOx7N8gqY3zOZYjHn4T/jwQp6BZaJBilEY8aHQN1v44pkvG
         sTUqEPJzplbzm4hitwsVjUJqtGqSFDFfIbVnb2hfcjMBO7h+n+N/jIxCbAZHYwFY6knV
         yj3eBx4wGQp/mVBb1bR7hj8q2j35/7zDut9fQY2D7CaIWeHJyZEeFQmPOhgKHf7zrGMc
         UltYGFlX1WHgstjZEYKlbDLB63fGUWpQM9pw8zGflB8KMpqoCHQl4W19mSLYMZ4VJVAG
         DZQ+R7KWjQ3BoEbb/QxbME16tNTIBaBL7Xvc+bkcJ4kyJwPBHPrbdsgSu6G40HC28QpM
         w6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337409; x=1791942209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vy1zLQ9YKYGfqugQgTKt/AfV3rhwVDXY3KU8gp6bN10=;
        b=AaA1RjLN51GgNeSmoVVe/SW8qZoprJV+e5dACM/MLJbRFXhzAM9trCE2m5GpD+ZIZ+
         1IXA/WueKqF8kY+3k723tZk7KaTbPJP/pJ+oIWH2K9wLMiUZnCHh7CaRkJm3oAMfZvum
         sLEjRZzAbuyTPtqf/K5CdzEG8HIgzV6vn2StHrAPgr7sBCnII3gFtUNdTu+jaObh9XGY
         TEfVrJwaCy4AmTKVtK84Uw1VVjmKUtD2YpBDcWc7PiJZ8F/Hu1iSdgu5AVxuovJRYAfz
         QDgzlL+MXcqhR2BztS1T32iv2yPSfPmSAZHd3kjxA8Afn+LP7g7ujFjt4vDB3VgLGri9
         HiWw==
X-Forwarded-Encrypted: i=1; AKwUvBwWmPLgu4dzg/3vk8Ju4dpngqdw3GzR2DEWc8c63T4jQmbDo+3gP1owtYGxBEaHFcoTBfgDnLmhlw==@lists.linux.dev
X-Gm-Message-State: AFuF++l+Ba4KNseaIV8Hzo+0ngxBfUfihdGBjKrv5YvCOm52SNLYk7Lz
	nGd3Gs49moXC996Sf0kz9VSLS5sXeEkswJGJtZGzGKy2REEGsylt1fMD
X-Gm-Gg: AYBFou2cz0myJcPWwoq2ghk7SCQNlBBAgY+g9Vd0ktXMW1NaaKbXx0GVz4k+nH/hOkI
	pbWuGhlYafEM+04K/4MoXcWx14aFRzMS2y+399fH0sTFCNu0eaeAGEI+z1eUgzEZx3mbsOpJcSM
	fPrnzSXbfuyBgW3SIreNvEyfn7Pw7tALok1XYJMgIrLF5Vl7b/++s1bSbJ9TNha4F//bgYbGLax
	UsVjwD8hVYH/vyJGM+rgDmhRvlvctSAK6HkFaUymjbjfSc6ijZg3UjrDNdK4erzR/wDG7aYEjWN
	n5JbDVI7v76S02hpQ29oyYl0WCu6oMHuZsDJ4ZV+szF4uJ03003NZTUfVyLT+1Mp6Ghpj13Kgkw
	fFVGoNFtsHiLB+wUIPZz0FyXGcolyHmgMUlvoA0gR/iCxdUqzyKL4JtN/QnPQxIl4jW6NBJuF2s
	7jxSZwsh7uVWe2gLodjRs6fJGEHFGfT5B/1nJlW49qWr61EHy2IDoH1q6QGDggT68w+ciGELJdx
	eCKr/6SqWuCEbsnGCMG8F3k66OAvJFNLFv4qj2T/ELlrJchxiJolRf4iYXfmAC4/lzsJdMBH7OZ
	0tglIvT+keM=
X-Received: by 2002:a05:600c:810c:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-4a180422b6fmr8853055e9.8.1791337409336;
        Tue, 06 Oct 2026 18:43:29 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f653d7csm26423895e9.14.2026.10.06.18.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:43:28 -0700 (PDT)
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
Subject: [PATCH v9 12/13] io_uring/rsrc: add regbuf import flags
Date: Wed,  7 Oct 2026 02:42:55 +0100
Message-ID: <97d5632343330131e3de5874e482ce5dfa341f99.1791336930.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791336930.git.asml.silence@gmail.com>
References: <cover.1791336930.git.asml.silence@gmail.com>
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
index 6930a6897b41..6e4fe70b316f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1315,9 +1315,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+			unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
@@ -1731,9 +1731,9 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
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

