Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794921605;
	b=YV/8AfxYd8Bg+5J/MmxNjUIXR1w4syaIg2dJ46MCwfEjbay58ZjzF2Amq+tjOR+i4xnP
	 XKbHmHxo/zGP+6gasQiBeXWLwXUd/AmH7g3jHsLxCFX4qxbN8ktlFQOUSfg42ti5M8Xng
	 tIqrAiYId1i5qazvVM2IXHXHD5AR2b5StAIOjOapTsdOBqa5WsdgSROGHxNut1gqgoYKR
	 UhJJIhIAEW7lJg3XMfDOtE8HdLCJcKWSuIMpU75udTvSlNrPy3aiAEmVrY0gzxCV+uRqb
	 lDSgjlrJOIVvRlv60x5swTxMaERZhiDKM+nvh/OKnRNpoMq7VFVmJ4VJqla/9ccS2VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794921605;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Y5kNgqPYALIqdVW9vNcq7ise4w/JkPbh40tMKMfpjF0=;
	b=BcW5i8DtCy0vRY53+VZk1ZjoqjOG+KHFDWpU5rGLrp/gl2CKiptAI01rhVh/be9kk/25
	 wxbPnAGo9eZ3yAM7X25R2FS+VGywNBh0O6HslFNB4U9JXByZAfek6E7hX5SXu/KFjT96S
	 7lJBg5AL7Ipdckb7sFn80GcZ1KFoP0H5Uo0fdkRuzOa3HvrgIRsVsTbIS8VA7O55NBD+L
	 W/+e2XdrMcCqsJtcdOnGhcHbl9q9ENLzZyCTXCVvGpTemJCcgqd497f9dJlLvO4/N7yt1
	 xssdsfJHc5lnIm4J2DmecmG5LmvmY0aKILd9jx+OtMbr1S2hDLm2Y/fdr0Rnhw5Wf6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qd9IemVW;
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757CD606A31C
	for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 13:20:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 757CD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qd9IemVW
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e95bd1c14cso51409585ad.2
        for <dm-devel@lists.linux.dev>; Tue, 17 Nov 2026 05:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794921605; x=1795526405; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y5kNgqPYALIqdVW9vNcq7ise4w/JkPbh40tMKMfpjF0=;
        b=qd9IemVW4koIYzXvJhPNFZTAMngDIlAWITIYnprQWxGfrwsSK69C9jvUC9vEO8V4JM
         OupWMqWArMk1Zq20ADsezbzrn5BmO/fqIDz0G5JSKrNKeRQe7MeCwjo3F8Bul5jSxJ/R
         O9MF6UCJ73mxe0Sa9ZMLoKNjn+TMAAG1KObrPvOn+ygTbDYUJvaxv6wW2UoJtMSJfiL6
         +y/7XQNxBz3hZjXBAzaaKS3K9g+5LefgYCoeLnBBlwYxe53gRFT8oEN2pRxkloPNz2jn
         y6o9HpRK0MLwZlWHwgd1hTkDem2K583CvuoNJtauiNejuFfgLDJaJz13wN3OBAs8gRfM
         ZYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794921605; x=1795526405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y5kNgqPYALIqdVW9vNcq7ise4w/JkPbh40tMKMfpjF0=;
        b=i4yu696lrzjZiu8it1HmG7grbqA3yXYoZaKEkbT9CoG92b07feysc5ma6xcyS+MMs0
         xxg73UQbOv9bpC+ha+QqQbnwlkHYPbMPWq5fHV4BPbWkIQodIaOOTvGnywNoYrGvwPzJ
         HKvq+z02Jnd5+5jAQ6FaMwMsatZls5ifufXlT8RM4DncQXiLDV2cx+oLW9c9Ubz44qrA
         uHFq6nM2pjPrRqlRyg8pdy6+GucGefrKTQ3Ccnnn2cJDMxKrJOlenzNpA8Sz3t8ZEkCD
         /h5uI0UDgXMzIi96HtOpIqbclaCTxeQSfOofkhKGkYe0c1okJiq1hE9HN5nfC2niF0aQ
         zbXQ==
X-Gm-Message-State: APuU4Z+qwsK3gcFn1VY4Eh3kXRR45qcTf4dDqnX+WzLjJcmJn7mhe5dh
	GXnfDhYgkZOMAzhQQf74QTtRrIfTLxcGTYGYRg77URdJBEVdqBfhhp+XgCNBfA==
X-Gm-Gg: AZFdTZdZt6WTRTa55lJInUtQ7BhPwyWXNjwPAWjpI8pLYGunoiWOILS0EHrdNzVMgJE
	MG3kJ2FFdP9WUWi54zYWFVxArpK5H3omWeSc/w5fok0GCvzhZAanUAjxptdxf88db/IofIzzaJS
	fOrtTCY7MankfVMI6eLmcj9VwvydGrevqS1IOQVZKeRrp9WZ+Udfp+uhbQMyeM7sCRKc7QxVg1t
	8TJtFnZAdbVLou1slioDneWJ8ca++c2NaYMETuoaaKmFIUvzPOQTyWPFl9vvf6m89g1N1CL0+uz
	pNLzuS9SdcgRpLjKCb/7zoxtF0OLq0+UNqzM2wWNdvHKo736uUBJ2rxwmuVW50SV3Pxv4Nq0vHN
	7N1utSnZsAjRqhc6FG9BSry/0bi3dsJzuRHUf6uqwHbO2BwRLTE0Cz/5jFkYMEGL1IKSIdovWZU
	WlXJUQrnutrd7kf2Gzp6GvpigBmd+fsY5/OtR9NgKI02QWNVk5nUhMdHtJXD40S9BsVB0DdQp3o
	OtM2qYEz4ZOgDxNbbVlUdIXf9S9syyI0hyhELkrf8op/6mewVpt/9VhETMKAtIx6JJegUJtq+Hk
	iQ/kJsePaxequl/jyesdFt5Z2tWostjbg7oUzBDyq8MQKqQIC+AnctHwBQivL9nyqUx+8QiQq5W
	6xtMwmcBMl6fzqxKrUb6jYIJz1oqddg==
X-Received: by 2002:a17:903:3788:b0:2ef:ddd6:716a with SMTP id d9443c01a7336-2efddd67320mr23925125ad.50.1794921604686;
        Tue, 17 Nov 2026 05:20:04 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7a5f754sm16064915ad.52.2026.11.17.05.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 05:20:02 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Yongpeng Yang <yangyongpeng@xiaomi.com>
Subject: [PATCH 1/4] dm-bufio: make the retain target per client
Date: Tue, 17 Nov 2026 21:19:17 +0800
Message-ID: <20261117131918.2745193-4-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
References: <20261117131918.2745193-2-yangyongpeng.storage@gmail.com>
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
 drivers/md/dm-bufio.c    | 31 ++++++++++++++++++++++++++++++-
 include/linux/dm-bufio.h |  7 +++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 3b66cf1cb931..75b6e5c027ae 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -994,6 +994,8 @@ struct dm_bufio_client {
 
 	unsigned int minimum_buffers;
 
+	unsigned long retain_bytes;	/* READ_ONCE/WRITE_ONCE, no lock needed */
+
 	sector_t start;
 
 	struct shrinker *shrinker;
@@ -2284,6 +2286,32 @@ void dm_bufio_set_minimum_buffers(struct dm_bufio_client *c, unsigned int n)
 }
 EXPORT_SYMBOL_GPL(dm_bufio_set_minimum_buffers);
 
+/*
+ * Set the number of bytes this client tries to keep cached; 0 resets it
+ * to the module default.  Non-zero values are rounded to a block
+ * boundary, at least one block.
+ */
+void dm_bufio_set_retain_bytes(struct dm_bufio_client *c, unsigned long bytes)
+{
+	if (!bytes) {
+		WRITE_ONCE(c->retain_bytes, READ_ONCE(dm_bufio_retain_bytes));
+		return;
+	}
+
+	bytes -= bytes % c->block_size;
+	if (!bytes)
+		bytes = c->block_size;
+
+	WRITE_ONCE(c->retain_bytes, bytes);
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
@@ -2389,7 +2417,7 @@ static void drop_buffers(struct dm_bufio_client *c)
 
 static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 {
-	unsigned long retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
+	unsigned long retain_bytes = READ_ONCE(c->retain_bytes);
 
 	if (likely(c->sectors_per_block_bits >= 0))
 		retain_bytes >>= c->sectors_per_block_bits + SECTOR_SHIFT;
@@ -2522,6 +2550,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 
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

