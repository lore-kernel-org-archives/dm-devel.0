Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAEF1DDA18
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571031; cv=none; b=i8bQJXVA7bznBu+T0REdS9fHUgTL7AMz+o0BFsZdrSP5B3GBnMs6QMd4pfkM6B9YV7rywFyvvgv4lF9cuNT7lKr01fU+8OSPwY5kr63WaBXQ+jBCWbk+8uQPc55FcFYbMrYnjjpuqhEV1Vbg0ZJaf7csAv/dKce3dGx1nKdDZZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571031; c=relaxed/simple;
	bh=02Q5vcC8yncjuH+7aUMbNJAgYmJovhwuyhHk5iLg0UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNWXH9WrMJb8yRdXQYPBC5Hvx6DQ8/EvLUqPXOUfMGGnVyrfjbhnX3l7Gq7mClQOiyb7XAsHq3NJGBYSeb9rXbveDrMi6haDeyhI765K9OqRd0tebzhp5tMi+AZ4+EJ4EcoOWuAkooPj3hH/Qv7vsXu//BbKlx+D9gtHtYsBfSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d49BsT+J; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d49BsT+J"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aba868c6e88so129335366b.2
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571028; x=1740175828; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9aMLz95gPZJZMD4V3ui2EqhPP7acemxgYeWutYWIT40=;
        b=d49BsT+JJpQauSFocI/X5/ZqORHb443Zh3/lijDFezFe7OqetZnVxmBZ8LkUv6MPKA
         /iJtZKsb133vBo6N5LrjklU6aBXxwNtIQgIDstEcxOcKDyxT+UrOAS0ILOQF/qKarnh7
         EbAIDanVJsqDQ5+qI+MDDgqKkiHHvRUvZOxsCq2AitMRw3gTRBDNRIJGYyFJkNFlsMqa
         GU+t/howniKN3Cz4jSvGoQ79Z9+du5l3nVPan9dgIxLYWrPPVl8qBb9e7gCDX4njdRry
         OhVGv5NcpPEgx2bKt71vb6YYlSodNoad3JSrvyPaJZ9B8cqXjGwR8SxT47nKjgvMIDJ4
         5PBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571028; x=1740175828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9aMLz95gPZJZMD4V3ui2EqhPP7acemxgYeWutYWIT40=;
        b=d3YPXlW4ueb8bdW9h56u5gesTmG5RUP0W4ZSiswzRbKJY/+D7PJq2p73ENiBkWbzIZ
         3XSoJy4AO+ML49IktHXqlrpGmni4cw03tG7YewdXS+XBBT+x8+eEcSB6xPHm3s/feDlD
         JI1Elvp1+cqmUkAfcPYORiAlvyf/pXRhHaXFGJXGY8kBAyeg5/jLfZIH+NvHw9KH7WGz
         +Jlm+A6CcRkepr0Nex1gdZftKVa2ViuurWclhMQZrVi1pCwfQyoPSU+A6crycFo1OQu2
         ZiwBs8SQYvtAVnGCFRcTzhRbXw8uQesCdDQX7/KUuyHG1O0c0+jWu09xf1tr83Dp9A6R
         qHtw==
X-Forwarded-Encrypted: i=1; AJvYcCWdaULZ45te0QISaGj5VmRJL4ZNCzglQYCxFHcW3xF98VoVMvUpiM88FA0AzXHLf0oTMAXW6oa4Iw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxSW8L4w7Wjd3wxnTHD14ZXf1Ns/5eX8Sn8zCc6eoQ44GFvIHXn
	J7OKBu1Ean2lGb7om/56UIGXFW9REU9VRtfqJmhAoNn9Oixo5wnrWZG3dAXaKPM=
X-Gm-Gg: ASbGncvl4uMS6X8NsoSPlOn7ObIce/pDvmH4eSRhBP2qSAzaIPukI5+xr/84qHJWvF4
	tDilfqtV0abi+vT3RDPKU4v1G/Z6jzcCiE1f2oDQgbuiegI8pTi+9hBd/a5xclDzMXeVpmmoqMW
	MRVzhybCmiprpgHJh9FBY8/5qM0vJiVPaPDu/Bcvf1Rzfp0qsz51s9hbkCXQcwd9XM6fhGyLvJN
	qPHkJwVPPl6thJj4zdfOl35DQJ9JYhRPFxoVDvx7iUBOPDzSU/lXBXqgT/ZvzXBx5sHt8Lrnm/p
	0FuFmyWO+I+xRVphO7rtcQWI+CObnbR7JmZaT7wlIq4eXXr6oI7fmdF9yunsQ4tiAiFElyxsC7S
	Z8g==
X-Google-Smtp-Source: AGHT+IHiZHM/leAXKrPNPQM2InkXXwkJkbj913Ij59l95Z0QajCicGoRspkQgECoWTKhLzVD7XcdiQ==
X-Received: by 2002:a17:907:7706:b0:ab2:bd0b:acdf with SMTP id a640c23a62f3a-abb70de286amr68737166b.36.1739571027797;
        Fri, 14 Feb 2025 14:10:27 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aba532322c4sm414479066b.34.2025.02.14.14.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:27 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 04/10] libmpathutil: move systemd_listen_fds() support into multipathd
Date: Fri, 14 Feb 2025 23:10:05 +0100
Message-ID: <20250214221011.136762-5-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250214221011.136762-1-mwilck@suse.com>
References: <20250214221011.136762-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This feature is only used by multipathd.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/uxsock.c | 15 ---------------
 multipathd/main.c     | 28 +++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
index 889d7a1..59c4717 100644
--- a/libmpathutil/uxsock.c
+++ b/libmpathutil/uxsock.c
@@ -46,23 +46,8 @@ int ux_socket_listen(const char *name)
 {
 	int fd;
 	size_t len;
-#ifdef USE_SYSTEMD
-	int num;
-#endif
 	struct sockaddr_un addr;
 
-#ifdef USE_SYSTEMD
-	num = sd_listen_fds(0);
-	if (num > 1) {
-		condlog(3, "sd_listen_fds returned %d fds", num);
-		return -1;
-	} else if (num == 1) {
-		fd = SD_LISTEN_FDS_START + 0;
-		condlog(3, "using fd %d from sd_listen_fds", fd);
-		return fd;
-	}
-#endif
-
 	/* This is after the PID check, so unlinking should be fine */
 	if (name[0] != '@' && unlink(name) == -1 && errno != ENOENT)
 		condlog(1, "Failed to unlink %s", name);
diff --git a/multipathd/main.c b/multipathd/main.c
index 52630f7..5455bdf 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1863,15 +1863,41 @@ uevqloop (void * ap)
 	pthread_cleanup_pop(1);
 	return NULL;
 }
+
+#ifdef USE_SYSTEMD
+static int get_systemd_sockets(long *ux_sock)
+{
+	int num = sd_listen_fds(0);
+
+	if (num > 1) {
+		condlog(3, "sd_listen_fds returned %d fds", num);
+		return -1;
+	} else if (num == 1) {
+		ux_sock[0] = SD_LISTEN_FDS_START + 0;
+		condlog(3, "using fd %ld from sd_listen_fds", ux_sock[0]);
+	}
+	return num;
+}
+#else
+static int get_systemd_sockets(long *ux_sock __attribute__((unused)))
+{
+	return 0;
+}
+#endif
+
+
 static void *
 uxlsnrloop (void * ap)
 {
 	long ux_sock;
+	int num;
 
 	pthread_cleanup_push(rcu_unregister, NULL);
 	rcu_register_thread();
 
-	ux_sock = ux_socket_listen(DEFAULT_SOCKET);
+	num = get_systemd_sockets(&ux_sock);
+	if (num < 1)
+		ux_sock = ux_socket_listen(DEFAULT_SOCKET);
 	if (ux_sock == -1) {
 		condlog(1, "could not create uxsock: %d", errno);
 		exit_daemon();
-- 
2.48.1

