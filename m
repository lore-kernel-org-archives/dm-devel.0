Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009B647F2C9
	for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 21:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785274214; cv=none; b=YgMnPPajxQ9W8KZyU4OoDEZlr3Ej3nozjhlYAd15LDbuXtjNVzEqcsp2xDaMCK9UdLAgBmdsVskuTAKty+0XSD46Z52CisaGhObtWHs1GRBa9pdoU1+pqI4ZgppBQfALBv3yRST92FSwdRF+HTO6rt498fDVviv5kpxppeU/dyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785274214; c=relaxed/simple;
	bh=bt1fjQx57j1sUPSIKU54YXB3emwAGpiLG3SIBERbcvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM4ijPhRnebatPBLvT2EwWZSRp/LUlnoHMIqFnQBfAZkaxbSIVBejUVIj08/LsHN8QK/0rLFRLswb92LuV8kQlHJxxL5mGVarUA8ZHrlMAG+ALHNJK4mlJ+ZmrbXgQiOh2YDoDxwpYjQEz37gfDyQPkHq0YsxX5XqbWRuhlfsIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RAIZPDFX; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RAIZPDFX"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f703a9e5dso167298f8f.0
        for <dm-devel@lists.linux.dev>; Tue, 28 Jul 2026 14:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785274210; x=1785879010; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mhCvEG3xgv0esCi48jrWlXZeUf+lVK0keP2zUsWb1Q8=;
        b=RAIZPDFXltPMBIdUX3v8Ei6gLJ6KBq1kiPj/4cUlXVayp9I1MYCw1N3IMhVy/hiiPO
         fROpVhizMHY7jVFCWijc2k+/js4ueWIzk/HihXvenHhodDEU8lowyDEo1WiKy5+PnrhY
         ALronGbhRPiWfK8W5F4P7273sB62EMRY6BM5/PbAN8iHAzskcFDOUrYfI+zrgGrqXQ88
         SawbvurUIqn/UggFuf11UQoMblEFCkpG4EWUeUX5sdc640vGx5nSiaYPo4u8lCfV2AJ9
         Xq334c52aOb5PcZYeMA3WwDWKPKEVWdOZnqO9p0Wxj36+2ByEG0NcsACihuOTc5sLRcE
         FHvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785274210; x=1785879010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mhCvEG3xgv0esCi48jrWlXZeUf+lVK0keP2zUsWb1Q8=;
        b=b6lsfX3VKPB1MfVekpoiVGnmo72EAKbcGRdy23zVlbZ5/r9TJa03yHGO6DfhkrPfGP
         tTY9EOKFzLQ7vXG4ZbvLeqY4xnODENT31IC17ai0BV/KKA94kqAhaqbyzqHY56V4Gf+v
         tM8pZFvApTV54ixVEre862qX3L6AL+4jhMpFpzFQEj1XwTao/kotNqGyk06Nc6ZNndvm
         d1n8TSb+CT4CkkNrxzd+ySbaV3L4OA3KfazOSiNDhBlwAIHtkAYbbGJW18Pk8/C2Igp2
         1NeVQ2t1MLORHWUK4tYiPwsNxavajFG2HEN5Ow1gC5SqfzHN95Zxi4y7LYdPfz0RSWTx
         +3dQ==
X-Forwarded-Encrypted: i=1; AHgh+Rop/3nr/kegbi7/ZCN+raPWyY4KXXuOlPxxAJ2HIa8J1fLFuapxvDYFmPoqHwd8eATdjjDYZXDNmQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwH5ubXFiA2EslX8iDQRaSWpzHn3rjpDA8TcYjAsYsUnO+QCgFn
	h2iEoGUxaXfuzJlIBUH14Ucld2kShi1PWFKyZ1dr137n/Yj8MVA0GIk5
X-Gm-Gg: AR+sD13NAuGVK7uKHnzMPQJH8QsymHoI9UJ27FpOueA+P67XkqZjj8YYf9l5L1laVQ0
	q2NAlvUVxx6TpJy8EG5BPhLCg/ldhWGxFBXv1oY8nIOpvC6YM0UZnMi8VTY9Q3Saeho7Ve9wJHd
	Ikk7/ZK7KC9eeVGbZRA4LLJauosaIt2BgyVYs+Y/T9pzm6r5INmo2uv/25UoBj5OiDE419n37lm
	MiagWF+rwuJcoNB5loZg8jVPtjzgABIFmCVmZQc0h7WPSg7Tsd4BBAcpEnm0CHvnsqBD5+cnXZX
	20h6Dk5RRE3u9TneDlH9H67uy4XdDhw95ZNP34lA9uV7hX7j9zI66Ecy9iAUxq8/84Xj7b77Ln1
	DwSGx7mciQrOQyq+9NUzy6kk37173pFatzKElo8HW+gU4POzgvpFrbvEmO/AWE04H3CWQXhaE5T
	QTAxsdpPw3aWKBg/3sQ57XTYRzPIBlxpAltYmPtOPHUeMJkagOELlsyip0xIzoyOeNsYynRD+uC
	OluFy/y
X-Received: by 2002:a05:6000:26c1:b0:476:8a:5 with SMTP id ffacd0b85a97d-47fb1f12d18mr4496873f8f.34.1785274210211;
        Tue, 28 Jul 2026 14:30:10 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6ac44bcsm2245329f8f.11.2026.07.28.14.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 14:30:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v4 13/14] io_uring/rsrc: add regbuf import flags
Date: Tue, 28 Jul 2026 22:29:25 +0100
Message-ID: <9eac63cb6aae06f591e6d0c67505ea2c16dd99e6.1785274111.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785274111.git.asml.silence@gmail.com>
References: <cover.1785274111.git.asml.silence@gmail.com>
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
index d57e8a0380b5..05877b4c0ee5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1245,9 +1245,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+			unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
@@ -1656,9 +1656,9 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
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
index 83aa86e6f320..f12abaf63270 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -65,12 +65,28 @@ int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
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

