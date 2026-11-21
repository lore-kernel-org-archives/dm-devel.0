Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795281616;
	b=QMueUXSU2Z4B3unBVNrHN8zTCV5YEXheEQ051yrnIbl0RG72UQzvkeUNupspFuqrGo1w
	 70vwhe4f8RuIQ3bR13ueKVr4Nxw56KK4TyZMK7f9JKOcTB3P0ApLpmK7yaALNbpMwT1sG
	 iCXxp5dDn2ND/RSiJw3EusOWvRMHga5xavs8Oe+P2hmJUoBKOkbqTulESCkS1uVKQL5Jw
	 dytS3kXlh4t0FhmSmgQL3as9fAm9+mo5FLp0ci6g4mnIQWi348kK6/ERyTmJTtC+ZWHJj
	 iaf0ZL58SKvjnJOOSiTKkAryDErHWxhT+axhklDtKZIMMSyW+8OeYOwTNXyzp6ikc5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795281616;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
	b=heYn0FnhnhqXpkfvxXTVWAvFgaadOOm5dedhSLAOiYvcJjOf2EKlmB1VbvOj5/5bAn86
	 3JkPwrLWqZu4MIS6yB+jVFPgMyATf+atyBwoqSfNOLpSiD+OpcJHOxgRs7cOoyyhS4n/M
	 T7kc+Om7CXfxH2cOgR3AYC+hd7izcy7dS1Y7j3SOI+DCi4wYB4ToNpzNqahAckKXeYsmC
	 S37oQvPx0aUkM+bry7TlAGAC9Mk/MoDes0D0SxA17y1AgvHwLPYsQdf4aDJlSPMPF7JDI
	 hMYpDz9T/GiOF8/lbrQMq2NedKOumB8ven4QpZtTiBoqW3FkxS7pHZjr29TjKOHwr8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LRhs38hn;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C21606A33A
	for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 17:20:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19C21606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LRhs38hn
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so1079265a91.0
        for <dm-devel@lists.linux.dev>; Sat, 21 Nov 2026 09:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795281615; x=1795886415; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
        b=LRhs38hnVo1N7UNqGoY38+Z6qcONhVdj6mgJMu+D2lTstYPr47FBigWz5L5/d1uENm
         SHLb5rIIFqUcnG40UYQLhydGAQJXhnfTpCMUmbMpHMmv6PLS4Fwh9RG613vzfxB2a8qN
         whSKRTmhn66xVwSSotzNm6KDKsRIAv7aMwhUcqutYug6Yx/7LUfAv5DC86XBRe2MkZqk
         ZrKhXOBvoNyPmSSCVS7axKAYpaRIFMY9f1xhx4aN13PYwN3XDhQN/WjULaZJTpvcMbBI
         Rh/hQPn0ayQJ0SuuPyJFnu45zNjSF3s4jiMlh9Q6Ha6Z+ryC7L+Zed2nNbgywkqBwvJ1
         Mmhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795281615; x=1795886415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zay5NM38LdRSXjjzGLm1APSNiwliv7IJpZUmOyP3DMs=;
        b=so6xmR4e84ok79tXkYVx5yB9UWP7p6giaPK7lvgDHctcV9ydbwlc7whVzqWGAWBJQo
         EhMVya8gsHj9D6RDOs7dnLhBaWCIoquMAqQmJokiATHIbs62uZptTC/f7iEjJHxVt5lS
         bvwC5r0Uy5Mi9B2Y/LlB4rCOw9AD9b9FXSyhld3VZMtKFWZk8IPfkD2SbfPeMnz5pJX5
         W/sn/oaf2KuDtdAA/9h8Q+fyc00qd45GHqx2Lx3Gtosg6jB5MQe4kMktDczF//8KGbx1
         dWanSk0ZY626hAxeKKqS5MpGHK76PA3HmlwqPwUNY9HPty0fNMin4o4bhGXD/Y7C40ez
         Zu+Q==
X-Forwarded-Encrypted: i=1; AL+hErEo4Gp0pErtQ4oLBC7+OTEm3q9cv880iVNvA10n7bYiSO1cl8yAAdecYPrLrGTOTpr+1xn5HUPr4A==@lists.linux.dev
X-Gm-Message-State: APuU4Z+KIXHBpKaTG1f/uSd5859eN8BszHGgnUADOfQcT4SPSVb7IZ9c
	b9VMsiP/5aB75hds76xCrQGjr6Rwl5shx015XrjSbsOzfynwwxuxYbOJ
X-Gm-Gg: AZFdTZebqsIKbkHguaFky4WpPUt7zJKXmyYHG08yp4RQ5eKQ3wqsWxZW9KXgPV73eZR
	lsdErjmG/JwXuztnomXXAxJE4JQMshlGnfqp43uYOi3c1G0qXbSpJJnFrPLCSybxCg8cm0dJ4dn
	TvdbBGexeH1UhImqFkMo8BQMOEEqXrRqJLwo33JyWZsL2vYuyAFoJxUecObwbzKWqAOlth8RcqO
	IlDFsmnpQM6d+SITbjHnP96ImdHbqA03kq1jYDuPm8gFJHq0pVwtlPUnGvQ5V50bLsKQ0M+i3x2
	Uz+9JLBwHSvyxd5UyTOgiky3YsA9gsn0YaYpMnJDjOH0fsYKz8SfqgfyYIn/0nR6wmhYDsPeD1Y
	oGxqXfLkkfj3I/5CJC+/9AOGUP5kYID2hSsgIM1pKg7Mq5ZnJSTvzdtsvWCfWqG/CzRzkezoHTO
	Cu/EynOHwcux2ib0YWJxOvbhNrhvR2r8sUMyKp8ylEMZ6i08XmlV9cBm6NOb5GmadH2z3mlpchW
	efzFGJZULD3BqIaasjCp0L6eCUWd+cuas+mBhogvkKTXiyiO2Y/HkGi5LT8XG3LAlSuNnYW1GFU
	ZIRNZHlhne8bGk686y40kSp/pMC7eAAeq4h5SZqneC2QMX9ExWnX/FkN7j2V5FMaEwgHt9Icff4
	Zk7bMU+b0
X-Received: by 2002:a17:90b:50:b0:3b0:9e2c:9b5f with SMTP id 98e67ed59e1d1-3b41c7b6044mr6307623a91.2.1795281615214;
        Sat, 21 Nov 2026 09:20:15 -0800 (PST)
Received: from bj-kjy-standalone-yangyongpeng.mioffice.cn ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d028a54sm2585657a12.18.2026.11.21.09.20.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 09:20:14 -0800 (PST)
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
To: agk@redhat.com,
	bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	okozina@redhat.com,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev
Cc: yangyongpeng@xiaomi.com
Subject: [PATCH v5 4/5] dm-verity: add retain_bytes message to inspect and tune the cache floor
Date: Sun, 22 Nov 2026 01:19:34 +0800
Message-ID: <20261121171934.3847617-6-yangyongpeng.storage@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261121171934.3847617-2-yangyongpeng.storage@gmail.com>
References: <20261121171934.3847617-2-yangyongpeng.storage@gmail.com>
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

