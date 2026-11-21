Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795250519;
	b=lf7nozu4w+yJimbWD3gnYc2yssccaAqCfbSC7fxpAUFrgHq2efZEXaFLupZZCTCqBZVF
	 /29tPcC/ygXPq6wtGno0e9Kv6D3bvlKamby+WcImu0+WV0PhYLlrZmOb0x5r9+4V12rp6
	 Djy0HzonaryYWStgwCNjtXyDChAWt0B7ZGoVSB5BekY/xewhm6gpm7SyhoJEQ46YnsMb4
	 pUkGRQluCvzsQRStH06j0gpedItgqrVqj9Dl8+HOWDMYIabvAou4AVIt10JPV6vMx8SDa
	 bf7QKo/A9HbOE1SzoBcKmAex7LaHrSkmcSlFMTPyzUuColr5/N8O1xYaeED+euzW4Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795250519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
	b=acqAb9BtUQu1qfudr44CfGO7qqsFswY+KjjWW5NCju7Owo/l24wsrsqup/0yPpG/crRe
	 a5UhtGqhLiXD5WOscxqcx5ynWGwPX5obql2k5H8w8pmm0P9w0nQTGjVTtV56As5jT/uXX
	 fjx6lHvlkFlF7q0R5MHqkB/DO0DlkFsJy9Wiq++Dfw1z1vfmQVZ0/sKumksBQSeTLc0RF
	 6hBkqYyIr16LoQrEaoBNm0lt38PV37NgH94q8cE0Ns7/FOA4oEZm4QMvPCyMHLQytsXox
	 SSyVmuXwnPsBCh5XBOudUPXNvt3tMVJUycJd+a2RcqUbaiFCGDRwffeOF139kGoADYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x5lT4J3j;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294E8606A320
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 08:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 294E8606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=x5lT4J3j
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b29b83fdf1so856980b3a.2
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 00:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795250518; x=1795855318; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
        b=x5lT4J3jSbl8jrzyEnkipJ4xPeAUVzNej3jJMaPVOAiVMxADnAHc3S2rVNSbhCbaVV
         d+RGQjDaNXCDAAkkRXaJ7NXJ1VepW5dnFYOsXVOwXvmHkUch4AmXxC9bKeJgi7JUcp4G
         APy5r3sr/5yMBsndefMmVm09DCpFGriOhKWKe7NEmIT10fS/zwF70mxjUZs1ooysd+Yz
         cCvfjUSPuogbfwUCQeHhyRyxsGJoMqQ8xv1/njF6AztHb19NDV24LTg5Ku8GSLZSTL61
         s/z02fTBjTIagXe2SX6p+DfGZrcstXl/3QhpQcSCY/Yi1WIWVxWihSRzOy3AUW+zMick
         qlrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795250518; x=1795855318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
        b=BZVFqIAoGH8TjTeXis4N0jLhiwZ9cznqwatiwZcSHlviPvbov/pPXColquVWuA2mYr
         vIHv5bMcKNFjK2D0aqHt+ltqq716VEDHfLneKnM9AXXQihK6F2AdlkXWAI/u6NuBiov+
         naxbilFvJ9mL77CHGwns1lHCNO5UTgCgqHlOpD9w4bTMCc4qAlfAMEnicdagSSz/JUq3
         khg+I6rYn4hLfo/SFyX3Stf2b1gJmaIKD55lpFHhxqx9HrLj9l5USlU+mPZANe/WlHFw
         qJuiJpm5lOEpTgBHEoVAqJWY+8AbVcKS6AjoNRPJ+ZdSvjc2Gc6+35QBHxK7qwKxlDQZ
         F53w==
X-Forwarded-Encrypted: i=1; AL+hErGQd6zklyJ6MB1GN6TUuI9+QTkLyIwUm5masVNX8k9/ookeIE6CSvsUiKJ2+GYeLEiYrFlZsxM7ig==@lists.linux.dev
X-Gm-Message-State: APuU4Z96FuhIRTQ7kBLEH/FWxGldouy+7sNaAUNCfdQyIuLb9PgFwCW2
	nfujxPrskkhxaCvmByulI9bZR9BuUIBtkhWkcWXCVgXY7PWJOUKYcuJ5
X-Gm-Gg: AZFdTZeLRw2AnXhlsw/fqZvV8pt9FB2nb+Plgp8NPR9g4KctNHFGRhkL9p+6tPZFHgD
	8eQ7qwIiV9c75re/5/q6FtyIiNc70DJajs57UO1rkIBC88McX/woeWzXNJFnX2ltw4QfRe2D4sp
	NpUDp+YGGmbQdsT/VK3Q406DjdQ1g0k9PlhGyJxFFh6DSEToGTpHoF4fUQiunf8ixAbJh+CnbJ0
	lhwsKxwPMMARCoBaIPo+dB2inICtvz9NmXgi0rc4v9MjHudSN52RC7Fe5riQiO8B3cEgXU0UprN
	XaIlbw5HsR7Tz4ux9zuFoLNGkVLrv9srWI5nl238sXMfD5s93+FX9gpCrVU/FsKhj9t0U6zE2wX
	RMyJxNNG84iEvfhYOoCinnUMaNf7EP8pkM+JaKBoXOkcXzCLC1nSDwjc7yT+8B7iBi+1dvctAJt
	elesmUmWf9hqPwRcP9YttzNLtADmQT21NlyCMRyPRjNissSq5ulsqOG0eLJ10jJ66oP5AwPZa1m
	bnk5gR/xpSdzuTMzeKdSPH5FY7oTkw5ujko9f9zAVk5kuzaBmPdJ/8etRI/jJd272FG2zkKvzIm
	tFHf3o4e42/g4DAT7dTT5yPLD00nFq4ZvJFFwHch6HZaFfzFW6L1FxykS9Jdz7vl3XhrtmEzal7
	Hz9lPgMFL
X-Received: by 2002:a05:6a00:14c9:b0:8b6:2ff7:ab9c with SMTP id d2e1a72fcca58-8c87c09e818mr5027712b3a.27.1795250518309;
        Sat, 21 Nov 2026 00:41:58 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87353b889sm2605350b3a.42.2026.11.21.00.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 00:41:57 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v4 3/4] dm-verity: add retain_bytes message to inspect and tune the cache floor
Date: Sat, 21 Nov 2026 16:41:19 +0800
Message-ID: <20261121084119.3418879-5-yangyongpeng.storage@gmail.com>
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

Nothing lets a user see how much memory a verity device keeps cached,
or tune it for one device without touching every future client.

Add the retain_bytes <hash|fec> [<bytes>] message.  It reports the
selected client's retain target, or sets it when <bytes> is given (0
resets to the dm-bufio default); the reply also reports the bytes and
buffers currently cached, so memory use can be watched through the
message itself.

Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Assisted-by: LLM
---
v3:
- The reply now also reports current_bytes and buffers, replacing the
  v1/v2 sysfs interface, which is dropped entirely.
---
 .../admin-guide/device-mapper/verity.rst      | 10 +++
 drivers/md/dm-verity-target.c                 | 63 +++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/verity.rst b/Documentation/admin-guide/device-mapper/verity.rst
index 7d6e567cef33..1e532c4251ae 100644
--- a/Documentation/admin-guide/device-mapper/verity.rst
+++ b/Documentation/admin-guide/device-mapper/verity.rst
@@ -343,6 +343,16 @@ The retain target is a floor applied by the memory shrinker, not a cap: when
 there is no memory pressure a fully warmed cache may grow past it, and when
 memory is short dm-bufio evicts buffers until the target is met again.
 
+Messages
+========
+
+``retain_bytes <hash|fec> [<bytes>]``
+    Report the retain target of the hash or FEC parity client, or set it
+    (0 resets to the dm-bufio default).  ``fec`` requires FEC to be
+    enabled.  The reply is
+    ``retain_bytes=<bytes> current_bytes=<bytes> buffers=<n>``, so the
+    client's actual memory use can be watched through the message.
+
 Example
 =======
 Set up a device::
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 0e8af1a57d75..bd2368312b05 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1837,6 +1837,68 @@ static void verity_postsuspend(struct dm_target *ti)
 	verity_security_clear_integrity(ti);
 }
 
+/*
+ * retain_bytes <hash|fec> [<bytes>]
+ *
+ * Report the selected client's retain target, or set it (0 resets to the
+ * dm-bufio default, non-zero is rounded up to a block boundary).  The reply
+ * also reports the bytes and buffers currently cached by the client.
+ */
+static int verity_retain_bytes(struct dm_verity *v, unsigned int argc,
+			       char **argv, char *result, unsigned int maxlen)
+{
+	struct dm_bufio_client *bufio;
+	unsigned long long value;
+	unsigned long buffers;
+	unsigned int sz = 0;
+
+	if (argc < 2 || argc > 3)
+		return -EINVAL;
+
+	if (!strcasecmp(argv[1], "hash")) {
+		bufio = v->bufio;
+	} else if (!strcasecmp(argv[1], "fec")) {
+		if (!verity_fec_is_enabled(v)) {
+			DMERR("FEC is not enabled");
+			return -EINVAL;
+		}
+		bufio = v->fec->bufio;
+	} else {
+		return -EINVAL;
+	}
+
+	if (argc == 3) {
+		if (kstrtoull(argv[2], 0, &value) ||
+		    (unsigned long)value != value)
+			return -EINVAL;
+		dm_bufio_set_retain_bytes(bufio, value);
+	}
+
+	buffers = dm_bufio_get_cached_buffers(bufio);
+
+	DMEMIT("retain_bytes=%lu current_bytes=%llu buffers=%lu",
+	       dm_bufio_get_retain_bytes(bufio),
+	       (u64)buffers * dm_bufio_get_block_size(bufio), buffers);
+
+	return 1;
+}
+
+static int verity_message(struct dm_target *ti, unsigned int argc, char **argv,
+			  char *result, unsigned int maxlen)
+{
+	struct dm_verity *v = ti->private;
+
+	if (!argc)
+		return -EINVAL;
+
+	if (!strcasecmp(argv[0], "retain_bytes"))
+		return verity_retain_bytes(v, argc, argv, result, maxlen);
+
+	DMERR("unknown message '%s'", argv[0]);
+
+	return -EINVAL;
+}
+
 static struct target_type verity_target = {
 	.name		= "verity",
 /* Note: the LSMs depend on the singleton and immutable features */
@@ -1848,6 +1910,7 @@ static struct target_type verity_target = {
 	.map		= verity_map,
 	.postsuspend	= verity_postsuspend,
 	.status		= verity_status,
+	.message	= verity_message,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,
 	.io_hints	= verity_io_hints,
-- 
2.43.0

