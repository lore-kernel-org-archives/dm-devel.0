Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E179F379C57
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336757; cv=none; b=Kp/xRlWXQrnYH57oexS/xJ5n4+8OlW5m3m/+4TLqP+0E523ZxlHZyH774CaxL6cZTiztujaCbJCtJB0Tpt78WnnbSrqR0WJiJqEV1Xww6Z8m2x0O/krholARlc75qJduFirCTkNbccaZeeu9T5Dv4l9bHciPro6gXLi2ZUx3HLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336757; c=relaxed/simple;
	bh=zkmmP/s3oaEnM5CZp4fq/TPO4woTgg6h/01Z24jsq/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmguoToINKe4HiTcGJFrKtJGFEdKqsIzYjfVh9W8bjcGAk92RfiC9pcd7qo09XK2OeRAhGKoE8MWiq3Q4lE9cFELokDB4wvVM5mEzRdcXlAib6EN+MHmuiR+IQz5xDo87LM4urXk2n/oQC6KUIyGmM462Bb33kbZh+YkO4LE6JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JecS9A4x; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JecS9A4x"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a021c809e3so13206215e9.0
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791336754; x=1791941554; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vy1zLQ9YKYGfqugQgTKt/AfV3rhwVDXY3KU8gp6bN10=;
        b=JecS9A4xDkwZR7ZXvVyDXV2DvX4e61SJqYjuaR85IcN5T5b7MT/4Ho/BINrQjOovUU
         TnWJCL5p6/rLOFmYdB60QhY5876vxanfHxc51hBEdLf2fwIEuP/WPdWVr4JdVpxiacWt
         NKPqjnR9nGb1FJ2qp6vsv63jYoqcZHf8K181YToLb+wIeXNApJeg3hka2eBfrExRZ7Sp
         liPziJG2Kshy8OoqGDebRKTA6+aUhebc3/LVHVeJsv0Spx39lviI/AbsWyE430lQ0zG4
         FHhDAPkVlzvI9rX9s8k+r8EzdRlP9eFxDWq08RVtIL6JMjGSBPRLturttmIf4DVGThty
         0o7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791336754; x=1791941554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vy1zLQ9YKYGfqugQgTKt/AfV3rhwVDXY3KU8gp6bN10=;
        b=o2MRDDmehTxcufoHBKRwtGXt9QJOJvugQkqaLQAHlb+MlGK9jRnHNQO8LB0Wa7VXzr
         l+S/aDQ4t/2k1DcwQ5kCpJtbUPdodvNo9Ich8f5ujw3lJPg3Ieb2VBrF70o2uVsnmkJp
         JkNMBfSnTMbK9HotTFY76fX7II3W7TUNWzuaQYiVNJWKc8lDejwuaGc/nynpapZ2qCyd
         TtyaVVEmJqL+B3fTWVTwaYvDUAuIQT9TvOMXerDvaz6B8uCc8u2zHwQz+bJYAvCd3rWL
         Z+JAQkdaPkrp4By+RxZNJWmKNaJheI4fO/cZc16l6KXUehcG/eXNQUViSIzjHaig+tjO
         Me0A==
X-Forwarded-Encrypted: i=1; AKwUvByYsBLKFktuXyKS1R7CAn8biOgAOSP3TQrs9CRhTmhI5J21KXokYY6F3OjNIt2xjQ5i3t0pu0LOBg==@lists.linux.dev
X-Gm-Message-State: AFuF++lzvfV2Ogg8TWMq/xSik9WeU2ZDuKHpKGxgjwgWnjfF5PlelUIg
	BrkYVa+//XGlGTxRfQ+bziD+C+Cb1UzwyilWpRwO0/fzrSuSXiqNgIWk
X-Gm-Gg: AYBFou1y6f4EG84VqNVNkOQK0N/5cwbvZ5PnA6fJt/qvH4DKCLy2wGVVghxpxRWlKsG
	fUYTInumVk7x6it3N3GefcmsU/5f49qPP+9y/H62TDwj/S/fXHWdaXjFF4JPH3MBjDab8kqbALY
	ADBSeztg7VdmP0ZOK3YZIVLMstZVC+gyrLX6SySDcGFcCVvwEzqfICgMo5N/hErC4+KW5gu+ymD
	K8hU/3Z5/kgzYvd/zw+KXUIiRz5378hCIggr8D+XK67i5OcpIQ3wJA8T8rqccHoyD7qywwe4/75
	Rk8FBiLHL8uEomOdGEWpbnVN7+ZPc3LC8ICHW1ikxCjAeKf977etq8l5ufiTGRFf+3p3huNSMc2
	eg6adlFxhkuds85w+J5qIhLlMt929iNco7P0BH7KjEQV7zN6652XkCfHe0NjzJ30YfuLMaq2lYm
	fPs3u8fkJmyxk3DqY7YaDrxXZuPF1RftewQ8QAc2PcuO5p3CD3dxQxt3eL3I1M8n5bsfR0RPlTn
	XHWcMB8UEP15wPVgQ7BIeGHbh5kqI6UjIwCAfHwwl0PVkRPtlH0cP/vk9UJV81TSo5NDBh5+QHj
X-Received: by 2002:a05:600c:3b99:b0:4a0:1c10:1372 with SMTP id 5b1f17b1804b1-4a1806501eamr8969125e9.27.1791336754109;
        Tue, 06 Oct 2026 18:32:34 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f6538b7sm21183615e9.13.2026.10.06.18.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:32:33 -0700 (PDT)
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
Subject: [PATCH v8 12/13] io_uring/rsrc: add regbuf import flags
Date: Wed,  7 Oct 2026 02:31:55 +0100
Message-ID: <4a4bfd9b4e444ecf9025e85b5cf0f864aa45c139.1791336002.git.asml.silence@gmail.com>
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

