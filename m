Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574592;
	b=vm1xCNOf6sAIC2Bh/FnjzEqkUYl/eiVNKL0o9ayhJ9uH7FcVNfd6/CxtZYTMJc5ojhc/
	 s5N+tUceAZsv+HNFEdjMHbp+VrNZ4JGomYzAospgXJxCxZzORQF+j5cFNUlabGkjtWSeC
	 gbITvDvUisW+oPhdEEzlcFP5i+EtNwsmW8d+gVY91yFCfiJzxg/6CCJpejLdYHIWxaOT6
	 KsCPZyV0TYO1lCJoq7Q+60+TmifUog8zLkCXN9mhyd/ghWomg8gkks+pQWGpE+sexOxw5
	 ki7k9GpaKaF3ua/Qj9gQ+ji6d8wA9ttxUfmCcseJ6WfDosHh6OQMiQJIwpQqQeHyoLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574592;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=yLxuAzYHnXNmYthXPgYm6Hl5b7kQFNHwTdF1Fu/UjhM=;
	b=Bu9ytIvvlXWvtMdjn4ItEheZJ+LGXwbARnnD8n65L2UhZDGHSe8FuszgUPQ7T4ralCA6
	 q392pD6T6vOX1bCbzctSL2ykJNqhiAYTnmWTEBpyIBCtS4c9UNIqyjivPIntK2REFhnNN
	 hy8As8PP/dGlULma9MOCMXm59vXx/pd/HzMa2Y7ak6rweU3w2Kg+NU7049Y2GhaudLHrM
	 yLHAmIjDGPnl3Wfb/CF6Y4D3D/37epAnCdjLYk68D9pYyC4pbgL6gVBnO89hWC3VQi1hF
	 g+8pADS/siswS2G2AW02H5S/dISkqmvh47X3JVjNDUdT4Q8LUmWiZqvxqYL8k8S9FIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VKDbGfZI;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5D8606A335
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A5D8606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VKDbGfZI
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a1bc97805eso1409505e9.2
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574590; x=1795179390; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yLxuAzYHnXNmYthXPgYm6Hl5b7kQFNHwTdF1Fu/UjhM=;
        b=VKDbGfZIufBxsroR1fPkM5yKgvYmbRAG/KXhyr+LGjL+zB3STaZPIBuI1lOBLinDyI
         YaE5b6M+/fT/ITt3fLLgGnFSqQo6e2SAs1xAW6Jx6aFrbyhQ8L32j89OI7AMsWQIE3uz
         Q8m0p8ox0hg3QeBJvwvI4E0DT135nmWgPheE0T2n8m8bs2c+bxcgjJWujQ724DiPuHIt
         nL5kezDpdm87+CpNMLrOe+EqMzJUFkjb6VDhlqhueFvALQMxGUtD5FsAbUM6ljh+XfGt
         FNxjjFf89ETeP7O/iWjojUyqddSR1kCsr62aIGL2fCwYRQqOgtb0n/BOFXt+A5DYkpzy
         dRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574590; x=1795179390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yLxuAzYHnXNmYthXPgYm6Hl5b7kQFNHwTdF1Fu/UjhM=;
        b=Id+fzEeYHKLBoJ7eF9swUDH4NaHLNgqDBopu38a87Sm6fzG9vR7VN5kZ736NF+Gr18
         rivcxydA4pkz+cnS2tSIE3Zq8hekbBq+myF8dubtyvIdTPZ9timLrmvdZeQ8vKxAV+wn
         XPqKLBd7czv3blYgSeuWhivkCTZDWZtSNqHMnrFCimhbcFNA0D3lTH2993Df/fFoHSU0
         5UHmKI76IoUKTey3YFic1X2WeujUj4z25jE9igM/8ELAm/JRfL+0GH0Wk4DOAdOhmfbP
         hAbQXQLPq1Fs2MKfbMMRdT8X7Kzto12OzLQhlL9e2g2/HglUweMb7UcZWVRWg9C0iSjl
         WzZw==
X-Forwarded-Encrypted: i=1; AL+hErGd5M6fkwCGPgp7ZCCKdylQVF/d1iwSZvon9F/k6ZQdm4LJ2Xvwiddn0gyvZJdxKBnzLqbPXnkLhA==@lists.linux.dev
X-Gm-Message-State: APuU4Z+dy/k2ZQWNNsKbSa5egZ+M2wGW0y6OG3IU1uKX64+S9CxL+p8X
	I8t0CAYo7l4bTB1BKHBCZd+SimUGXa9oEnrRP1TS8uEeR9fO7VoTfZQ=
X-Gm-Gg: AYBFou2c9pW6EGnv6aF26rJo1pxd+eP6vq8SLI8tLO7Sx9g77fUfQiawRInXO+4MBnq
	CMCR1S/wETGkFe25MTbssSx1kWWdatNEKOir07GO2mIFK6e5ew0LXSTV9QxibQANfrwoCKe52Qr
	+K+uMIzJ+RojUppjDgImwlxIKPV7Za2qzjGLEsuadTs5Z0F25KHhbC9OoB65YIO/DoWIt/I1eid
	JkHqdkb6pXRBUENbg73XhHM+Rq0aM9YXc7a7gnAnRfAsO4pC67cHme6fE9i26UJA/Nj+g69+8fJ
	lR2gOYBvSyWJ+XyD46+R6fBHJYC4f9a5CXvBbK79sATzeIrlCtYVYmhbFX+kce/qNFnwpYQb1zW
	6WJSkWc5tx5PKZdT7tWyjUhFQ8h6JWbTQ+XUvPcV/mOjXPoKZSAOriJzYDr3xDxsse6UE5i1zSr
	lsopnyuPAY5vC5IO+t/16PiEQxG0coYHc8eviG75B648CrOYtNTYYzlph7qLviN6wqTQ4Vj+H1q
	GqJNJk+BftpJahfFWgplAMFOf+wvfZL5vU+M2WZtFxlbhhkqEJJhYIjydFcgELm4bFtxWlRhT9o
	wzzbuQ9c6504LhWwelT33QHFtOTHnzYUVsTMGddaXS6JLJyL9B1KDF6A3JOEIaz3dQ==
X-Received: by 2002:a05:600d:864b:10b0:4a1:e774:370d with SMTP id 5b1f17b1804b1-4bb55a34a55mr38114135e9.1.1794574590510;
        Fri, 13 Nov 2026 04:56:30 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55a68c5asm59134375e9.1.2026.11.13.04.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:30 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 11/13] multipath-tools: hwtable: add Western Digital OpenFlex NVMe
Date: Fri, 13 Nov 2026 13:55:43 +0100
Message-ID: <20261113125549.504780-12-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Info from, page 9:
https://documents.westerndigital.com/content/dam/doc-library/en_us/assets/public/western-digital/collateral/reference-arch/reference-architecture-high-performance-beegfs-filesystem.pdf

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ea21bc44..a37fa7d8 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -1452,6 +1452,15 @@ static struct hwentry default_hw[] = {
 		.product       = "VASTData",
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 	},
+	/*
+	 * Western Digital
+	 */
+	{
+		// OpenFlex NVMe
+		.vendor        = "NVME",
+		.product       = "OpenFlex",
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+	},
 	/*
 	 * EOL
 	 */
-- 
2.56.1

