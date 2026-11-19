Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795105919;
	b=i3O6tuJ2Yp6+wvOogXGulMpvo8S5n5eFq8GpTGH6eosqbKZ/AIKyhTWiumjtqqPNy/M2
	 OKONCTmCgjyijK1R7PPmky2Hn6GTdg6/O+kf2MLu8TTFn0/g9hIaRdGjEmS1ySlyT0i8R
	 Tfk+n9WtT/2yvn/WcYUsBfk67YUY7Q3lmB7lQhpdGXczBFKRUvzachimW4cL7NpyYsMbh
	 8KxfRWYpWjLy33ADG78a7B4E1t7fBkJ01zY1pqWCXXUoHuRyKCyeeLZbBla1r9yUQ/Epx
	 zQorRp6X5LJPoCZAwumPeij3XvxUYZZGnkeoAwYxyiOwh5+REIl/6O8TWQxZ6MynBFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795105919;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
	b=ytFGOXVz9UQNNxMuTNsPIucLG9l8xYZY1xwU/dRSieCJRJrDovUhZ8RVRfeGxTcKvWox
	 861+CNZNluZLcBGcmK0RdWfzE7IPUgzJeSzYqWlyy8O4UPnjl5jhjvY8ZCDkLnkLmNiJV
	 fCGVW1/Y4CFzud7nTHq+cf4AZt2ULO08vcBMjjLJ1V9CSsZDobs1CQ2yJFHddbLjjZnV0
	 tdv3SublBxSFVvAHjDaDvhnL2dmZ+gZQHqaHd3XzLyeDiuV8R024fi6bxA0gh2ZwSNXzo
	 FFwAptDH/41QlM75pIPa0ZzLSbMFad1boV8yZx+TDB9PDQjcGVXUuJ7pBonyjhh2jMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UtXzSUPS;
	arc=none smtp.remote-ip=209.85.210.172
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49973606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 16:31:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49973606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UtXzSUPS
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-886e61fa30fso1197138b3a.1
        for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 08:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795105918; x=1795710718; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
        b=UtXzSUPSrATeWwjXPdzuvULA6KY0eOZWqD94NxUIqm/yTNdu41tnukr8blpQI0eZSZ
         jJT8FCWk/c+aBSUefF6zTUQXgH1TZFA2XX5ncvoNdbXSQ02is7vdDtkxI092cX38DVah
         h3DfLqE7W9e+ar1Tge01g3Boy6grHi3dISwOdlK+aofDj8aMyhM6pCtmajo2hkD6/pzB
         9pYWjPl8WmCi9MqMR07D8MyiVCzuYr9UJvqeTWG+vLBknCuhgIPaz8VqUtE8Y9a0Vksa
         Nwv8TEUF38y/FqO5y1BnV2+vMKGyypnXM3j1mrZu+Utt6lZFX6E0EF1DzY42WhMSZn10
         q0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795105918; x=1795710718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
        b=kk5Qt26CSu0UKxQ5xKInRfItUIcQPR+lUCck2Nmu9I9hurkFZDYCyH42a1OpZB54cy
         oypLJXLSYMIEAgr00mAGogUnacPJeHYHpt0kF4Ejyl2SbvcrHmfLK7Bw3hIFAcXsuNy2
         XPZwsB+bbWaVmzGh0RBMoSMHDRsFj+dqEGICWPrySCHvW/SOp2QeMMUHWRoE6RhH7sTd
         JM5l0F7A93aBHEEccDEFVazojLMpBWepXGBt+0MTx3BBOsstGMBscWoJA+SmLnFZGaIZ
         TeloZ070rzRneY+LZo0Vs3bGrBHSGKaNJOGlTr4qO2dkazoNePw/GZL1zaQN10Rx48I0
         C1YQ==
X-Forwarded-Encrypted: i=1; AL+hErHZA56jhxMXVolpEzo8baIq83a5N/e5fIn+StNkn6pVnityOoH2VZFJO3ThOMo3F/IbR5pO2ta6+g==@lists.linux.dev
X-Gm-Message-State: APuU4Z+YQBswr0r/sfnDYR+DxFE36qxOBUypkt81khk+k3bUCoDiU6xg
	yaGiNaYJ0mcf3vMV99kd9hXiUQGfTlRd9MaOR2ZnDzfEb8ImjtNzU92K
X-Gm-Gg: AYBFou08PIyxjbSJFY7UpJ64fv9XjzqBw/RbJNhdLNZmiSR3N5y8XdJNOwPPkseKLmv
	kDK0I8B12RFU9y5YmmFwfNnGIwFwAns/1X120vK66tqMMrKt75ajH9K/JnuxRvwXFoEa0bk+VTo
	iGlt3cks0cHCHGx4OIIc7Pzdh6YsLty7ej63uRZ7mNuYzCNwmvVv49uVLczYMvk1OnxyH5uyusN
	tSa+2eMqHSTuazv6AjJj43AKN2vazNSp9ZPhXnHeoNWJe1VHYPSpenyzrqwOqwnng9cwZc9ZEhu
	+gxOoVtx7WMxiBCKCAX71cmLoHRE/Fa4+LZXCetIsNyW1opsb7K0rrSRj9WPqygZm+NLPGvdHEE
	4gJ/cpjOmHXsjk17rWpc/OEolxV/3ARTVLnKad6wFCTTAoPxAVfsDPc0alD39CaJUw57DQuw6WI
	xhLhbrsZUdKgngNV0scO6w5gYJUMMn/2CTS/mJHvHLE0x2Ip/MlFwody3MXSW3IcBvjBPcQrhD3
	oJyxCezjNgow55XL/YFunjm3JVtgrbx1Wgr1L6bweSn4H1P0X5ekZfT2NAgw39Rklp+RJD3TNPa
	hIlUC3pyDR00qcCphfFHRt9E3zJOzEcDFpYc/OonWtUfBInrB+C1/wHO6GPnHZ0M9eVCNmzT8wr
	Y8ysSoQrP
X-Received: by 2002:a05:6a00:44c7:b0:8b5:b5cb:762b with SMTP id d2e1a72fcca58-8c87d5188ffmr134496b3a.53.1795105917528;
        Thu, 19 Nov 2026 08:31:57 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87420be40sm132589b3a.57.2026.11.19.08.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 08:31:57 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v3 3/4] dm-verity: add retain_bytes message to inspect and tune the cache floor
Date: Fri, 20 Nov 2026 00:31:11 +0800
Message-ID: <20261119163110.1630269-6-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119163110.1630269-2-yangyongpeng.storage@gmail.com>
References: <20261119163110.1630269-2-yangyongpeng.storage@gmail.com>
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

