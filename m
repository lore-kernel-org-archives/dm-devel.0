Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0436C4D17B5
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602391; cv=none; b=N0Y0Q2zbNz21CfIWCnH+c7eBB1rt6cTTBifoOlxjrkfy6M2fP6shiKjWg35bC1DrzcmnFGD8zfie8RwP2JapO0ZDtj33Icur8nHL/qNydArpTm2aHHpYy9WFdblns6Aa5gZpwtE1g8IFRjgXw6W4tW8cVtPVp0XPKhXQO9WGTgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602391; c=relaxed/simple;
	bh=IlrTb51Yp7Rjs5yQkZp4t/TrynsY1IZo7uIZ92+N310=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DSmN/i3UU/PJ1fnQ6T/Y9b/BFy0CWhen6jfebnFoS5l3tjTuBHqlODUBzeecailLlXIqzAYUiNf6lhquFHiJbfQZqJ3ffuhdr8KnMTr3556F+n9xDSHhnaXo48M+bzfz65b+EEfTlKq+kc+ZNZDQyMT68QU1ANpIMyrXqKmhFbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JMTz5aDU; arc=none smtp.client-ip=74.125.225.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JMTz5aDU"
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48884b926f0so1856553f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790602383; x=1791207183; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vb+nXysx6Pid1tQCSKOtIWL9IN5+XlO/q6rrI+ZzfOE=;
        b=JMTz5aDUrFCcKlVcuBbQkk+2xMwhmnPvfTJDLSp5YoLFB683nyMbjXlnr0lWFOYHWi
         FJirAmWbe6AGN87sh+JgamUkg8Avru3mJXBKAJHlVkwDwWpGUtRebxFzis5QHVG0/ixp
         sChkbDkxTGyBtIuETbScUFHXubZxpH6ScK9DakkeSmP1IkFE53qtZv4/6J2ovwCFmQyJ
         ekm+TA3PQtnqzGnL5CveQcjeMnP9p7W9KK48usZUc0jWyI+KK7vQzWwnshR8EA5KaR+R
         CaFFemfMGWPIO5QZnWDnFTd5YD0uIrCWtx5+Wl3Q5BukT3poVyt+DunmHT3R5DCDxLBe
         sqBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602383; x=1791207183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vb+nXysx6Pid1tQCSKOtIWL9IN5+XlO/q6rrI+ZzfOE=;
        b=H5/Z9pCAW2vCRvf6jDjLJXabVdYX0nwaIifQqQ+g2LBfrTbmDRP5ML9/nBY6LHJSsw
         Eafhx2b8EsYiSZ9ip5D8lNdrzF5iJnDeGzP6aOYf8dDr0G9KcNqAL67gQtZzIGBTTs1k
         eqfyY/1AX8TCSm7u/wJ+X7pgjl8U4KY4jECfYF3Csbl2JITiplIFLE6KkdPfP01w0gsn
         v9bepAtPYSBMmfS9CC6n6gH75hm65Bm1CZSIG7cNh1Df4B4KfXGF0WiuDJSxt7SegMQB
         ayK47HTtfKomP/MjXvPB0xPQ3EJgL9UPDzTDkwqmgJ1dgfCconlrgqrL65/wnl1TdhPc
         17hQ==
X-Forwarded-Encrypted: i=1; AKwUvByMu4Xz0fZWOETR70tkU2CeZfg2lxJOIdEikQEhEMfu/5aSxmMd55Rc+EEnJTI32tLoeb2MQdEiNQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYJjUMuoD7HU/kegCG2quN4ogpmaE/mgJU7y8pZ+rTv+jIxilP9/
	Hy/asc0W31m/nt2UbzCt/kmigvzfS+ujxrS87B4FzKuLCCQw6i8Sr1Fy
X-Gm-Gg: AYBFou27CTCQQDrEEF9ga7S8uWH3PsxfZXHJ3cdKzpUgqlwvlaSDu/sTBwfRDGvCjmJ
	0Z64tm53wQgcJL7WKBAuaWTbLz4cqmAG4ss+ifNGcFGm1uclENazrTwzUVbdRH+Joesfraezd/a
	hP+Q2Fj798+bbEXFxPJ+MW/Nr/nbaa9Ib3CuvigLjg8b8Gm21SR7Gzcg45Z5HNb3LyX2/uz3R/Z
	1TOuCIxiY/UFrVX18St/k1gLuiwIchzBe7D8t97c0eI3gNO3Z4OY+ISeuLa/a7JN/wzuywWDURh
	1ZFmMYj4wm/EvVhKa34kGCVA9V6y775O7xQfWZUxCiVnpG9NKRyyRRkcp1ObFIHrG4kztX63bkY
	9WklzkRF6yl7lQc2hb2LAHmHGZovssrzAF5Jho0aoy7ruy1+HWMScb/4x+yWWGyb3gGI6cOP1Ah
	s+Wb4yxk/N1ppVWQwZOXJ7l2TM7NzJqH9DdjOBFXSWVAg5Q0o/e/UJsdss0QGJN+j2ZFgdzHao6
	4RWdpomTmo/PPQP4eLHl1tA2Dwz9HNi6mXjECv1YbD+UeyWzk/YDPjMjIEx0lKeb9fhu5pxB8vg
X-Received: by 2002:a05:6000:2893:b0:487:10a9:57cb with SMTP id ffacd0b85a97d-488719756c5mr21965332f8f.49.1790602382736;
        Mon, 28 Sep 2026 06:33:02 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a349731sm28090164f8f.12.2026.09.28.06.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 06:33:02 -0700 (PDT)
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
Subject: [PATCH v7 12/13] io_uring/rsrc: add regbuf import flags
Date: Mon, 28 Sep 2026 14:32:28 +0100
Message-ID: <692972b0ea345774fda580a53e2b1bbe5f771aa3.1790602223.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1790602223.git.asml.silence@gmail.com>
References: <cover.1790602223.git.asml.silence@gmail.com>
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
index 65d6cf7201ce..6f6860d6ca03 100644
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

