Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D734A842E
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998006; cv=none; b=BfvsgS/jfPD5RuLjtWZdvbALix2C9pu0mIrG/B0Jc1AIgiXtIwYnj05f2MdbDSANseRcR3Wld9UXBLz1WISX1IS/pBpvd7dc0QXjl3rIeYET4dtETxoQ7Mjpxrn9ZV0dEe4T+XCL9iQoH6IxkBhkFfpyTirhkODM97+u1Or8Nts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998006; c=relaxed/simple;
	bh=kBi8BbQVDcPE/2Q3Wr6NlZISspLakO5UHtrHPWtVj5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFz5sh5syYlp9Jdynl9xo91+7HML4XW2jWg4f+SpdPT3OwFt16TIn7OAU6IODLY3YvZMT29GKmf7TTd8mrSvVR8N43ie1oqkiOTiR9fV7ovXoCVnRcFJU8osCWVCv1JfVHDTAUM+jnbKmfr5M+jtyM7A/k7yU7cOgozjxa6zT3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lj+MJs+8; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lj+MJs+8"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e71cdb22bso22408495e9.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789998002; x=1790602802; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/FMRvm1BaZ6kTlzIVu1IAGTERBBcZPL0byDe3SvrYcY=;
        b=Lj+MJs+8e1pD4LWQ/qFbQXcpSwbfGcUj2Ip3JkjRO7RSWWU0aC/hgoh0HwxYUr1Web
         eAA2Lv7vEVDJJCU3FF6GrApCWyBxSfRtcL7CiruGnRUAgDYRv+FhJ64ZYsoSpqj4AJqh
         cDgMnX+1vi8P9btCeBetrQd4WoFyz+lnpYUwLaNG8du8lLa/JuGEAiIXgtWZSdUln4Mk
         IN4E9esWyeqrhEUuZ0LkI69y8yMX4ZynMrEqaAeT89sn4U5jOdi5Qj2vfRO4xRt9VFsE
         QSSJwG/5UOblD8xsYjaHbndQwUKcj4DQxyGTK/zq/teyBztGQv/ondk3IpB/yqJVbw16
         fHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789998002; x=1790602802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/FMRvm1BaZ6kTlzIVu1IAGTERBBcZPL0byDe3SvrYcY=;
        b=HXFfkNaFgMyDOXoXW51CP1ZJmumzmbqSCjpwEbFKa0va1f8Jh0HPdu9jPWCI0npthM
         0k/8RVIq0twOueegrextUY12+msq7+kSs6Ch8H+DnI1Vqzf+M5RuZKwB6Uzlx0JAgln3
         Odp+LUZLOBd8TcKHtuLK2MwldwtBh6bWpRgNbWyC7rR/7hdyZip4wN1OM0Ex+eqftrSj
         Ll/QF2iO5ury/O3qgAZj0OL0aRBVhFmMvjjJ/aXJugIP2CZiHqC79LlLAYnJMYBjIG6S
         LhYeHXyZhN3UpIfrp1/rBKUdiTUWeSbKPuOAKD3oe8ZE3mGpeMEhl0GISQEunKIKWOsn
         gJBw==
X-Forwarded-Encrypted: i=1; AKwUvBwcU95s4Hjz+VLSMX1EGK1pwJvhnK5SSjAn18XLW6jEcUuo/WEv1Dpx9tSRHRlScRNH213ZdFzEFg==@lists.linux.dev
X-Gm-Message-State: AFuF++nvJ4BMG4m6SIq4HvmRdZu4W8Y2kzQeYiyDzDxyFuhCmYC48AKr
	UxZkDRkPRoS4dw12BCrWmeV4fnOTZqCLGP50/qis8M9XBfKJppIQup9G
X-Gm-Gg: AYBFou2kQG2hs/pbSY3S9IInei20a53OyU0cNVsjbjqrV1B36LJGnTj/rgVfiBJ3m9v
	C4zHe8dIpcFEm4wlWHj67aiqzcluh1KrczoK2hMga8YcKohCcs6lx21KYGWXEA8cx8Uktf4fieU
	5PvJuwzyiSDdFOs8up4LpOscfpFg83qWKVFw7ehzzorKWtYjNVdXfTGkxpNh6neLxrk1W7kuyuS
	WEedxl65rgPofjYthNk03cpg+fIOdP2fZqaxsa5YP6OJX7f6CWeqWgTemcuLLrTohp4CPM9FJXL
	4yPDdL3uAdv3oheBQYsXE0M1Czt24kQcNDF3bKDq6AkEGb97qBSiGTLEBk3W0T+c98UfQOOi6Te
	CPDJoMppM47Os/uZc/n6G/CSy8P6b8XmdVQ48AGLEvtFtS9hoVfRnEzCDU5fNvjKoONKfWPOdZ3
	Zfk85gQx6IkosbbbTH9iBpFoQUayCVnbgjdbIyIr5rCGwgFv2U3M6uOXeZvkTBVCYaYYAuqN1Oc
	G5rJn7CsQV5yOu4rdguGbK2/lNq9W2HGZRk6R2dZKL6gj7WRW6i7FHzkRtmcIL0V7Ck5v4CtNqA
	+4w70b6PjuwXw2DOepVA6tOcqf/HLQ==
X-Received: by 2002:a05:600c:3107:b0:49c:ff9f:f6b6 with SMTP id 5b1f17b1804b1-49fc5669346mr153997265e9.6.1789998002057;
        Mon, 21 Sep 2026 06:40:02 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:40:01 -0700 (PDT)
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
	Phil Cayton <phil.cayton@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v6 12/13] io_uring/rsrc: add regbuf import flags
Date: Mon, 21 Sep 2026 14:38:56 +0100
Message-ID: <a7b154185897c7cd23de143f5bd834ef73cd7723.1789997898.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1789997898.git.asml.silence@gmail.com>
References: <cover.1789997898.git.asml.silence@gmail.com>
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
index 0b526b094dc9..79e3c686ecc1 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1298,9 +1298,9 @@ inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 	return NULL;
 }
 
-int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
+int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
-			unsigned issue_flags)
+			unsigned issue_flags, unsigned import_flags)
 {
 	struct io_rsrc_node *node;
 
@@ -1709,9 +1709,9 @@ static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
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

