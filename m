Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022519;
	b=rtIgR0EBKCFKMHEGL9/Anfxw0kPXrGTsZicTd5LTEWwr0FSHa4KCe6Fpbb+f3uo1BYoW
	 6TlXDtnyNwlNx+uxFYxtqB8gaPDFOvwbVlPoQP1VCQcgY5wHS8XtA36uQ/+p5GVmM1B5L
	 VMlY2ELS5oc3/NBydzPUFJ6kYcI49E7+hmd5DDEZEBoU1RuSn7mca3yHRGt4MCAI5jIY7
	 LaWdzxg9G/xzaIhHTgggxQXeYtJSvaBrtJ8zcvjjFPT9ZoP/O6oGrXYgOPMImwSYgKVLW
	 B++3FGKW0B0HKOZZZbboFoocZ0WPTU7dWamaRRaQw2rFh/6q2sk2nvef2gx72vykQIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HytQvuzoAAEaxdKQgRh3UPo2O2FzdGKptaHdmxKadtE=;
	b=H/MOYCG7KGfK5kJQLb7CLVRe6eYip0Pj5u+/E+G3sZctxX5DWcHv+mzmvDHp7Rbn8BVA
	 GX+qUjaY1DMIF8RK/wWAMaLqzsbUC79WomkMorDb3JZ3YBNcr7ZKuVmwp6Yoh9ayfEIzy
	 u8goIyu1zUwE1dYE6P++3eDplpzdAZpAm8Sd+HxUBbgbRWAbaSPi7f5sasO+h+nNT2fat
	 zqnW5QZsXwieNzvLKfXQhlgm6qjD9Q2dLYOUd18Xs36xhqr8zcIzQpOzDR86QZ9X33HRn
	 9rA48NzeDzVGcKaQoo04fbfSJqjkfnmUSoRwPWiY0TGs1gtKX4jb3jUKzRD/4n6Xzdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q7wCwtvH;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D92E606A31C
	for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 17:21:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D92E606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q7wCwtvH
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b0e0e65adbso675522a91.3
        for <dm-devel@lists.linux.dev>; Wed, 18 Nov 2026 09:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795022518; x=1795627318; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HytQvuzoAAEaxdKQgRh3UPo2O2FzdGKptaHdmxKadtE=;
        b=q7wCwtvHp1B3bzRwdrariTTFjpyR3vn32+usXX0uQjruuxNJPONSU2P+3u9UMPHASg
         0k8JxgjNyL+uTVQH1MX37hjbAVSDcSw8y3sv4q+DB7tcBVTVyXjzb2K9/b7Vo2HYvSZk
         mrYdMSP5pzXUTTaWuvT1Fio0eNbfrPEXWuTOwUyHTLAR88d7uwIB0pDDGeMAZ+dSwvCx
         EK3X1WXK5tXm8m1rdvqg6+EY0B9FI2mqUzIMicbAD/47KL4W73QKsSlJP1HeMIcwX45h
         ulSPs6fxqhCtlDPywQgw37bjP+LdgWkrP3KllBgP119oUCaHArrpnGRYsUQ8OYEnVP8+
         ZeAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022518; x=1795627318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HytQvuzoAAEaxdKQgRh3UPo2O2FzdGKptaHdmxKadtE=;
        b=cNAkLt0xMXrH54N+jzI5lP8qfThc4evI+lgUBquZLYFuZ3ChviQ5Lfy475p5m0rtVo
         wfg5NtALIrGMTUXQEDD0nLTbn8pXbc8cSCTOjPZ1TIvbpfS9DFFM0gecBGr2EzKW1oKo
         0FHGW34bFLHc6LXHpMDrp6dvis4mHHYRhaGPZvgnjgsU+S/o7/ULSMtlUo2wmte8qY7s
         SHYjxG5OUc5jx2SHfVOaKXDbo1FrT8Yr+HMSxwmX4F+e6eWYU42BVOw6ZByGmCuSWVej
         Gp8dLkCz6w+TcuzHUyefLpmA1SrV3oqLWJ55EPKLSlC/OdJXwC6aPQHgoyeoL7B95L2M
         3c7g==
X-Forwarded-Encrypted: i=1; AL+hErF/S1UuB2PUaGbd6BJodK/B7zvUqfToj1Iognr8OcAD1aFiZmnPWJZG8ZsexDzx8qC/AZTBTg8g2w==@lists.linux.dev
X-Gm-Message-State: APuU4Z83Be/B1J7cpvyk8aHqjTCO4WmkgmDEtp+88ff39n1pCPE0ytZh
	qw9VVaeq/KoqqEHbsZ1YuawXrC0p4GikQrY3BNPDXxzEV5YuEA2bVsd0Hcxjkr+P
X-Gm-Gg: AZFdTZf7bnIKZt1P4BVGEGXqa4GCVFGeYS+IsCKyKFd/+kOF15GWkAD0OGOTtoYORCi
	9apdykONfJCBmCa5jdLzPPX/q61v2FNcGXg896lGN9MotfJ/hAScnztlYwciGa5MBwFc/CD7H4E
	va40bA4VK3VP0oQOfXjQfch3AwjdvEg/tsiTEZrq41AwDMHiOgFTXoc3GhMb3zY+q8prttczEVj
	1POZ880hOYXPyxOFUWpLYGQ9RJrwejeXkOgKIdVXiDdExU0nxziztnOjIETOCDYYKU+1VMzgXwr
	UDTIL4/00WFfuNH8qs3z4AFUvnfdyLHQegwEZX4fKppiY0ssyqKxcW22xmSq+y9WTQxiiIRZYFK
	s71wMF3FPmyKN6d0/lHr7DbyIaCx+WahNRnXrxeIgxFz7LKIqzm4Ifp9ofcVnKCtT9rd+teSckW
	jY9vzzmfQGmeu38NWskIxByOaeQKYpq9L1Ol+PJGR0TRCl3jCTfv6v6oXOO1G2D5+eEESeo3c3P
	SgwvzWl42sdjC0P5PpU8lIdAVqSdDwWf3BRiMc2AILH1PbN4fEAIqkmSw5V5DV4cLbXzAq/m8LS
	Or+/2GX+5fYYnkw/1cCr/ujvS547U/X0GPy5vff0qdKfaVY6ILQ65BWISQFSMT+Tp4XA/cvG0vp
	gWryNGGk4ePaJeODZhYPpRgNroqxPWg==
X-Received: by 2002:a17:90b:440d:b0:3ac:9176:e837 with SMTP id 98e67ed59e1d1-3b3d07c7c8dmr3347348a91.50.1795022517984;
        Wed, 18 Nov 2026 09:21:57 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f7067012sm135659a91.12.2026.11.18.09.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:21:57 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	snitzer@kernel.org
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v2 1/4] dm-bufio: make the retain target per client
Date: Thu, 19 Nov 2026 01:21:31 +0800
Message-ID: <20261118172133.689163-3-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
References: <20261118172133.689163-2-yangyongpeng.storage@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

dm_bufio_retain_bytes is a module-wide value shared by every dm-bufio
user, so raising it to keep one device's metadata cached also makes
every small, idle device hold on to memory it does not need.

Give each client its own target, initialized from the module parameter
at creation.  The parameter keeps its meaning as the default for new
clients; clients that already exist are not affected.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v2:
- Round a non-zero target up to a block boundary instead of down, so
  it keeps at least as many bytes as requested.
---
 drivers/md/dm-bufio.c    | 32 +++++++++++++++++++++++++++++++-
 include/linux/dm-bufio.h |  7 +++++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 3b66cf1cb931..367f878c17dc 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -994,6 +994,8 @@ struct dm_bufio_client {
 
 	unsigned int minimum_buffers;
 
+	unsigned long retain_bytes;	/* READ_ONCE/WRITE_ONCE, no lock needed */
+
 	sector_t start;
 
 	struct shrinker *shrinker;
@@ -2284,6 +2286,33 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_set_minimum_buffers);
 
+/*
+ * Set the number of bytes this client tries to keep cached; 0 resets it
+ * to the module default.  Non-zero values are rounded up to a block
+ * boundary, so the target keeps at least as many bytes as requested.
+ */
+void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes)
+{
+	if (!bytes) {
+		WRITE_ONCE(c->retain_bytes, READ_ONCE(dm_bufio_retain_bytes));
+		return;
+	}
+
+	/* clamp so the round-up below cannot overflow */
+	if (bytes > ULONG_MAX - c->block_size + 1)
+		bytes = ULONG_MAX - c->block_size + 1;
+
+	WRITE_ONCE(c->retain_bytes,
+		   DIV_ROUND_UP(bytes, c->block_size) * c->block_size);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_set_retain_bytes);
+
+unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c)
+{
+	return READ_ONCE(c->retain_bytes);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_get_retain_bytes);
+
 unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c)
 {
 	return c->block_size;
@@ -2389,7 +2418,7 @@ static void drop_buffers(struct dm_bufio_client *c)
 
 static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 {
-	unsigned long retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
+	unsigned long retain_bytes = READ_ONCE(c->retain_bytes);
 
 	if (likely(c->sectors_per_block_bits >= 0))
 		retain_bytes >>= c->sectors_per_block_bits + SECTOR_SHIFT;
@@ -2522,6 +2551,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 
 	mutex_init(&c->lock);
 	spin_lock_init(&c->spinlock);
+	c->retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
 	INIT_LIST_HEAD(&c->reserved_buffers);
 	c->need_reserved_buffers = reserved_buffers;
 
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index d1503b815a78..9bf3f805c43c 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -158,6 +158,13 @@ void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t
  */
 void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n);
 
+/*
+ * Configure and query the per-client retain target; 0 resets the
+ * module default.
+ */
+void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes);
+unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c);
+
 unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
-- 
2.43.0

