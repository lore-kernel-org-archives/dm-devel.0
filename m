Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0863F4A688F
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998002; cv=none; b=XKkZPZjzc4Q/WPOFqRHHSVMwcWF9iSQmP7qipq8w06EiI/sE2iVopCn9WrBg8yul+LNIVIR56NbYCLLOZbsA8ekUheWXaaZjInjup39UhFabglh28Yos/TChamDZ52Veqh78H00jAEP8uFLMtg0N3h78z6HSQ7JptYk+L7JFuOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998002; c=relaxed/simple;
	bh=iU1u1X7cruHQchsBcaFSFlP5wT6XT+YL719bzSe6aAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E6bkKzl6iIrZsapoUag0BJzGxgKBtfEOpnm/xFp0zybrQe442NbiDlFHRaaIEFHYi2CwRcZepPeM12nDG2w70oEISBHrbUFP+UJyQcWuDGUyCoKE74IZMmsDeHmjoarAJjbCem7QZ4E1Xha0D9WWchLfVL0bRzZJStcYPqradrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NLkll9A8; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLkll9A8"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912df756so20614695e9.3
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997998; x=1790602798; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0usqXOyq3o4rQ+AIVUUfsp1gP3m25NdfBnNXnNuf6eU=;
        b=NLkll9A82x4WbOby9pF6hJS7mfFYb8JYgyeTIpVqsLJVw7kmRP620ZdsaeAWC9BW8T
         0ex8Xp1Ob6Ilco00djmy6FfPCZUjbVkt1J+FoHd5OQZGZNuizdtd7WQqTMUHykVR4H7R
         /5OtsbBG+3qq34+H4x45ydSEn72i5mY4rxRcQr9ygGTm2GUQIvFLfr0Xj9r3Sk1a3j9F
         oIwPVj3v+THDDB+UtQJDeswmfO+ZCmE7ydymXvYLwJU87FGTTD5eV56hIhMPXjf21S1M
         vtSYoPl4QD9Q5VMopk8ctRy9HbvETPCU1KfMGFat02hZxLH8Me7h2KiR+v4OYm87zp3y
         YIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997998; x=1790602798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0usqXOyq3o4rQ+AIVUUfsp1gP3m25NdfBnNXnNuf6eU=;
        b=K8ZJT8w4yTRlSwavHEqhTss8IQfaRcD6WZtZL/xXao8yq0hzAdYNGMGGdZKH2k/5GH
         jYpECGM/jClyM8ZlqO8GGsPUOxACCCnqDDfFmYtW8q89CNrpwa+uvUZiTU0vVnlwBVrR
         7sdeOZ6cw/CD7c1Z1sHIT2QUMVn5VUxi6ieqvRaz7c5piglQcUZ8KRe7DUuSbR+cnx48
         1ayJjMxqG6SxxIRRgRcvAdoBMXWifKCp9BC4Bfy4sa52qowN9bJOZlul77AYuZ9spnfA
         a9ni5sZQfgMbBP4pmtM81oODixNn9UzgXqfWetq08oIKpKnQEmmsMPUhj1rNv4yuYqdi
         GMug==
X-Forwarded-Encrypted: i=1; AKwUvBxjRn7qnMJIYApqFspOgVgQ3uxBQLF4+q6bEEd0Pj8MUekNf1KnibvfZb/IljCS+qKi1QF0s5k4yw==@lists.linux.dev
X-Gm-Message-State: AFuF++kECK9DmzEmyfhmHNYjRjME42iPzzDHv6ZkdS0aZFianVGK1/ub
	gmenpdKHtrB8iyZUVZYjyat+M6D+NHiU7L3jcdlJ3e9uEOJjSmZ0No6x
X-Gm-Gg: AYBFou0QBq5o4lDqVSGz/LSKITIIW9v0dDN0OO8TAODUdyZtSpdmT1wmkhR1/ONt3+4
	uMmKQP9vwpfzS/B7FE7reJPhIYeVWonY0vhnzpejw9y6/V3X0cGk/NAAlm7/R2qa+fZuWR8+pTS
	Fkr0nIPyhd4S4aRthHAZ+1fPy7I93+meAaOcurPxhcxjKr3Pddotul3yfeE1qKVa+T45IROhiQc
	YfehkGjHrOz5crI8ZrYm248jmW3RhlsoT0rEFrt/N691L333AQlZp6eaN4ygDVZ7kGzQg8SGUM4
	S3k0xrdNW5IyTviP176MwRl+3YnjBDYxW/YT+P+VQ61wXNnn30Wux/joFePGpuxbmIrrCjav3gr
	Yc64/7u08kaxzy1j1ylL46WJDnjCrluSsgaOaxSAvENjNf8kpx0Pb/w5vnw/d5sYCAyjBFVYP5X
	HxInVC5TV+xK4DReQwFk4LL457lknK2+H5cfiFCh1seY9yYvUhoue6CdBwRFm4KMbsac2dmIzdn
	cljJPmmvgHPb0pgPRXUbhgelmTzykshh8ieoMJucUx30AYmKqrQkjgoIR9CA3hjL0gQv0BALQNS
	DKOk4ebaqKqsBFIsvMUSM/67TLjHyHV6/cq9sI5H
X-Received: by 2002:a05:600c:34c8:b0:49e:732e:6b79 with SMTP id 5b1f17b1804b1-49fc574eff6mr149861745e9.32.1789997998153;
        Mon, 21 Sep 2026 06:39:58 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:39:57 -0700 (PDT)
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
Subject: [PATCH v6 11/13] io_uring/rsrc: add uncloneable regbuf flag
Date: Mon, 21 Sep 2026 14:38:55 +0100
Message-ID: <9b71636a03f2345bcc09127d77eb6b294a1d0938.1789997898.git.asml.silence@gmail.com>
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

It's hard to implement cloning if the internal structure needs to be
mutable and/or relies on other ring resources. In preparation to such
buffer types, add a flag indicating that the buffer can't be cloned. It
might be possible to add cloning in the future for them, but that would
likely need reallocating the structure and reacquiring resources in case
by case manner.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 5 +++++
 io_uring/rsrc.h | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 83a7ad9f5bc7..0b526b094dc9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1434,6 +1434,11 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		if (!src_node) {
 			dst_node = NULL;
 		} else {
+			if (src_node->buf->flags & IO_REGBUF_F_UNCLONEABLE) {
+				io_rsrc_data_free(ctx, &data);
+				return -ENOMEM;
+			}
+
 			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
 			if (!dst_node) {
 				io_rsrc_data_free(ctx, &data);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 9ef88383b363..73d7b1ebf0b6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -26,7 +26,8 @@ struct io_rsrc_node {
 };
 
 enum {
-	IO_REGBUF_F_KBUF		= 1,
+	IO_REGBUF_F_KBUF		= 1 << 0,
+	IO_REGBUF_F_UNCLONEABLE		= 1 << 1,
 };
 
 struct io_mapped_ubuf {
-- 
2.54.0

