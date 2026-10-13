Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1E8560ABD
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924950; cv=none; b=UgPJl2p8a47nL+FdUmeaTiMF42yIGlpkwGoMAtq5J4rqryc0MIiNeim2F5O8u89fhVWUyh7cm7BCnPSMZBLFhia1QrUS2Ruqg2hTG66MzEX1bWTZYlRtaE/EAO+M485EwNCH5YzPUWjpQQpFvFniiHoSP4VFq77Gqww98Xkmkdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924950; c=relaxed/simple;
	bh=r60ha7f86tSXOy7awDRSeceZcMhT0AOlgJWaxT3jtGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Co1N+bthEBL1NR/SQQ0hC2QAKBW3cU5yAsujAyMvCWCbEWpQurQjqWHL/WLxLmyH59pBSqQYoAb4qig6wcteA6f8SaBhJnB1WV2b4K5dYQe+tQxqiFfhO1FqXGpJf0nG5I+7mOgdEz0ew+Zz+sd7UnEYzGF46YQEwQvQMVBuBcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxQZaSAS; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxQZaSAS"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48af27fe287so2974086f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791924945; x=1792529745; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ays4SVba18pfRPB/Hpqu6QDaxGmpKJaoA/2lD097Khk=;
        b=ZxQZaSASYTECFrRfn0RzGQyw+uyGC3jpyagebd3nFdE5BTFtU3pSxy56HZBdCpSUbP
         /62N3wL5jDE0oYX0+TRpU87N+0JIzMWlPDYUZQl+4tH1MEuttkNanWGwqCBFc3/G15Nf
         VbzjKzR5o7cSf1B4AolL5N8j1p5u/bRhgKzx6Oms6vPKeH6JqdAcpSuaAhPvZMWX2aEh
         Fvd99J71Ua2pl54qizcpYl8gyCVXTGLA2ucwRs3AOyCHiajW0S+oMyxrpSqqn5jElJgP
         SYTQ1d3oMLUtzXhS/w86n6+4z4s9cB1c0mFLxkn+23+6CCm3ugyhXHONNgYRReFquw7z
         hx6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924945; x=1792529745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ays4SVba18pfRPB/Hpqu6QDaxGmpKJaoA/2lD097Khk=;
        b=BAmC/BBYoOKgdnTtzAwlw6mzwBj0ZUWYhvvuOShXZNIh9QpeFfanNl4Qk1Wce54AuO
         vBZCsxo1y1nBBuiXwtEHkuL5bA7UQzhT4M/EunLOa3B/Lkh7agyjktqh1kZOIcU1vF5h
         uL6ZdNa/Uahp8VANkyaNaDQalvVpNdmZ3bH3ziHtptEBRzOlcawTgJDdw/HSTcb+PEk0
         +WynBwn3VYFob7qLih027LOqb+on3eFFwdV9hpXB8sTwimsqlQmlAiNKvvJGlmpxXQT4
         l5eLW9gPQFYZGnT1chVCr1ryrfH8QtPQzx/UtF7oK/SxAyG1PlAXedJnGFApEU+V8Kf4
         GZBw==
X-Forwarded-Encrypted: i=1; AKwUvBxJd0OxQ3kP1XnxlO1oaNKbOQQm01V+H3qfi9GhnP/c0XbcNESpYd3XyKN909Fc73vJ7tFPanKISg==@lists.linux.dev
X-Gm-Message-State: AFq9FYJg3HtL+F4NaQktYe5Nbo4B1vPUM7+NhQasrItIo4N//uwdXCF5
	B1l8+dUi7RUeRHmXGHP9Jjr7VVAVaBPQubWiFcFcMuvP2T5Ovw1JF0nK
X-Gm-Gg: AYBFou3U9NmRB2MLu+iaArXLDd43A11BFqozlOpkY6dM3lOM+ykmI9CZHfJjwSwZXlg
	uYlH99vHfnXDTaqMTkaCyZVXzO2cVpIIBK1t/2WbMQRULY/kbtX4TbvTmQaiGbtGVyV+VH17X68
	o/jozomHt9UuyVhVvz/NCm1W/uAUJBXCv5+ney5qKOS34n0mVvg+MYQB/eVAlHVziKppGDr1AcW
	29SgHJNb7FP8vdFpyetLRzSswAfKABeLlm0GmmCvjvtJ6F85jhUMkkW+5WQOiblfxzuVycP7uDA
	4LoSLn/UdCelMKujYbq3l9RrmE+Q0pS1oKL0sl71ic4MlFqxyPJLTMKyFwzEhMBZC5m7tZDKayz
	zqWhoMBhXFhbLPb+v3j5c2W9jiXIIkmCFgoY3dMwsiw2Nc1KealmK3Zli7AbbyItNMLNbX/+5nY
	q6WTFXisQGskriPCfTKJwqr9ehM83yoaaQ7pHxiGnEsgUHQzl3kXnVrvrW5JbCAjF+RCmglo53z
	razvyAxH4VDmpcWV6URxlyC/5y2sLfrF/ov0uUElVJHBrhVf8pE+RGFIHVQ/q0V3dZGY4PZzFQP
	oJvwwVSKZfA=
X-Received: by 2002:a05:6000:27c6:b0:487:27f9:82b with SMTP id ffacd0b85a97d-48dbaae34e3mr16754768f8f.32.1791924944821;
        Tue, 13 Oct 2026 13:55:44 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de7273a0esm2380730f8f.29.2026.10.13.13.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:55:42 -0700 (PDT)
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
Subject: [PATCH v10 12/13] io_uring/rsrc: add regbuf import flags
Date: Tue, 13 Oct 2026 21:54:56 +0100
Message-ID: <4b7c13d9860640499460862c8cd4a13602ca174b.1791924581.git.asml.silence@gmail.com>
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

