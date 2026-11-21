Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795250510;
	b=WQ+/Y1kUpcAHcDqpBrw2qXjjcsWUg3Y7WmZvX981qU1Ie6hTK3/bhToSklf1doiLrV6v
	 RHJw7J7AvXF3mRzBLutuYl1MX58n8yKjSE2qatq8gzaFwgKH9dnRr5bEVG1dZAGl9STS1
	 UUEMLX+M9AQW41qoJpBM8Aes7l3C+pRlfYdOSqcBAyUQNMjWdtqfpJ4N3aSGBiQwywRpY
	 KLjAv7gVoh9Ie0C4Lb9Sxg8zB1yfL/42iWzklk3XLg7D9I4XMyMzeCW2As/qtCoERv0OI
	 mjwm7fOFAIUkzjUlAeEStmHiKjf0zcQxIzuTADZzyJrkoyWU1s3v4xEAUblwJS0UImg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795250510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OR3LJDzn4Bw79tirFneWKPbBIU03aWfrfnVEZmXOG+s=;
	b=vZ6RAlxr9QT7fZM6aXM8nWJSIGdzAyVZ9og31jXjUP5rnDwt1GFVItE6UDXghJl2bfFk
	 Z/5jfTiSSsCoi3CaaUCILLyUe1GCWofYbFirS9tC9oGJOGU/ao/SxPaKzmfoWIbPkW7IX
	 wq1Zu8W/wxgjdVahnqf1WVy2nug5UUgzFTO3zC/LBIJQUdgD5wVS/A3LNKJ574r4uRu4d
	 96h/hFVEVsDihtnVY3uEtcVJ1FTVl5hHtu6qDjHVoL9qo9eItiCjQmLnWp/wHzKZ0O8nm
	 1DxQrHZ9ZQu/Ymxt/r/bxSvofgR9ePmFzmnumpC0NfNLVj68lWQjKRy4Ntx+TY/jVKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hNEzNIp4;
	arc=none smtp.remote-ip=209.85.215.178
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B50606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 08:41:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65B50606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hNEzNIp4
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so1701614a12.0
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 00:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795250510; x=1795855310; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OR3LJDzn4Bw79tirFneWKPbBIU03aWfrfnVEZmXOG+s=;
        b=hNEzNIp4x72pbtFbhBC1SBBI/7FzzW9isTz4CTCWmTLY/c0HIcAXsU2VEv4RZUc1pM
         4iuBL2+FyEQeEo4dpAButLONoJk9um4V2U8mFBezc3R+NR7TVltkF26nOdwZ5+rS6rRg
         edht3+bAzOPIepDOB4hPnmKcQKMIezZxLBgRO5HUUxUnPww3XgxE1ZwQzBYj76LqcMeQ
         3ccgTBAbEpVeaFXuZxEEjv8qEzlWeykBihu5xjM8D9kilnOUOijkgerADJA1AeO0U7QV
         v0oL6RpnytvzULdyhig+BdxiAOVJewYlgnWjYoOQIIg9G6tvNw47MuXPZKDx458rdjiU
         kKNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795250510; x=1795855310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OR3LJDzn4Bw79tirFneWKPbBIU03aWfrfnVEZmXOG+s=;
        b=YYAHyN3mP+Q8Wdie7m+hTUtY0jXMGzR5oRZqOWsJ2WxXYoGG+Ki1+vXWbktIG8dVbp
         pCr/Vk4LqDkJ1msxkGJRFOejIl5YdvbkE0iMu3tumD8XG5iSQY1TKA5+AvEGPf6kNr9u
         z+h+1T10u32I+s7TkKPipPUn+H4I1gRc473lkUV52s3S1zlwFbJkqUj86/J08fj14DdA
         LtidkVxdNsUvaPTSmRmT9xhpxNQs55Du0cKZTaN8r4PlHvoYHfNo+UReNzWGYYgoBFJh
         9Hk9oNYK00+6UVErVaTBoJWbnQUj4wK63Molfgnxl9FyRL3C1chZwroTfQh1TfNW5DZ+
         8GRw==
X-Forwarded-Encrypted: i=1; AL+hErGAJrMdFA9Fq+X52uIuxKxD7CSitQSPMTbKULxxXFWgkFCzzqaxlGxwHwz/mEyx3adQXAtAOoTfng==@lists.linux.dev
X-Gm-Message-State: APuU4Z/b/a3XvwJAM7UoCsB+Vd0CzH5l2zlQo5INe82Vtu5JTpDWpzb7
	ooU2wt2l5EIwusjt8f5KlnXnD03bmXHD2BLBSGHQWqyS4heDHhWG7Ywz
X-Gm-Gg: AZFdTZf0kUY6hN/YqA4qwHJ6g2A6K+NTEkPzEkSe4sqaILyBiBJ6hCcdWXle7CPBIpn
	GmOF/EwABSjTGMhQYeTsVipdJHVItuBMBKRsXNeo38odSTUCxl2KV9QB0xm/JqCm/O7TWwH6vVo
	sVjouLBljOs4mUK71gwXE3pzihMG3Mdt3C4WTNM+75/CgelukVYxnwmP+/zj24ObkLHEJ9mlqKi
	oymPZd1RiW09SsWuBgozI7UYkHtgTAsqZrONmsksAq/yuEzqvOFmAz9UbLA6zJbUOVSplxgdCMb
	QiXvVue2555CX7v9OYvjY8m0e2XkpGn1oMHs+etQi/a8DxVbHmlpiADJUXplnG/2pdsIA3+7YoV
	Ju2Kaq7iDge24TB9QoUMze3aARMCMOyswQHiGq4PBIrIYCXQ9Mr2t5+Q+oLzEa9s7x2UzCecb4p
	/+Op9sn4sgQNcVKpk0pk6hvXWh2yTOdm2WNAAkxI3Mkvj4s6/gB1pnlGgWPNPdcZRpAyKcRNMSB
	jFe+toBCpn40/F9v+CX6CnU4aBhURSKqp6EYgA5dNTE692lyXQ6zUOq2uHQZEqfHXz8nWTsupcw
	7Uzs2PpC9Tk7cs/TVwMkea09z6zsPUMnAdKHDoeCYn+49DrTcBeG4DLhAU0aL3kroxfW+yyAM1P
	rqsInHplw
X-Received: by 2002:a05:6a21:4cc7:b0:3dd:85aa:4524 with SMTP id adf61e73a8af0-4014b56547dmr6029712637.31.1795250509627;
        Sat, 21 Nov 2026 00:41:49 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87353b889sm2605350b3a.42.2026.11.21.00.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 00:41:49 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v4 1/4] dm-bufio: make the retain target per client
Date: Sat, 21 Nov 2026 16:41:17 +0800
Message-ID: <20261121084119.3418879-3-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261121084119.3418879-2-yangyongpeng.storage@gmail.com>
References: <20261121084119.3418879-2-yangyongpeng.storage@gmail.com>
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
clients; clients that already exist are not affected.  Also export a
way to query the retain target and the cached buffer count, so a
target can report its memory use.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v3:
- Round a non-zero target up to a block boundary instead of down, so
  it keeps at least as many bytes as requested.
---
 drivers/md/dm-bufio.c    | 41 +++++++++++++++++++++++++++++++++++++++-
 include/linux/dm-bufio.h |  8 ++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 3b66cf1cb931..f3abf90793c9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -994,6 +994,8 @@ struct dm_bufio_client {
 
 	unsigned int minimum_buffers;
 
+	unsigned long retain_bytes;	/* READ_ONCE/WRITE_ONCE, no lock needed */
+
 	sector_t start;
 
 	struct shrinker *shrinker;
@@ -2284,6 +2286,42 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n)
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
+/*
+ * The number of buffers currently cached by this client.
+ */
+unsigned long dm_bufio_get_cached_buffers(struct dm_bufio_client *c)
+{
+	return cache_total(&c->cache);
+}
+EXPORT_SYMBOL_GPL(dm_bufio_get_cached_buffers);
+
 unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c)
 {
 	return c->block_size;
@@ -2389,7 +2427,7 @@ static void drop_buffers(struct dm_bufio_client *c)
 
 static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 {
-	unsigned long retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
+	unsigned long retain_bytes = READ_ONCE(c->retain_bytes);
 
 	if (likely(c->sectors_per_block_bits >= 0))
 		retain_bytes >>= c->sectors_per_block_bits + SECTOR_SHIFT;
@@ -2522,6 +2560,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 
 	mutex_init(&c->lock);
 	spin_lock_init(&c->spinlock);
+	c->retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
 	INIT_LIST_HEAD(&c->reserved_buffers);
 	c->need_reserved_buffers = reserved_buffers;
 
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index d1503b815a78..f4d86b4b7e0f 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -158,6 +158,14 @@ void dm_bufio_forget_buffers(struct dm_bufio_client *c, sector_t block, sector_t
  */
 void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n);
 
+/*
+ * Configure and query the per-client retain target; 0 resets the
+ * module default.
+ */
+void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes);
+unsigned long dm_bufio_get_retain_bytes(struct dm_bufio_client *c);
+unsigned long dm_bufio_get_cached_buffers(struct dm_bufio_client *c);
+
 unsigned int dm_bufio_get_block_size(struct dm_bufio_client *c);
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c);
 struct dm_io_client *dm_bufio_get_dm_io_client(struct dm_bufio_client *c);
-- 
2.43.0

