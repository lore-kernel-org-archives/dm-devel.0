Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3A91FECA0
	for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 20:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740170483; cv=none; b=c1isd318SjwL53luuPYyD/D2zWjxltHg0W1Sqes7xAqB8rJp58fngmClOQxwyaZBtD0HWCCfJqVPDrA5bx2eGQOzCrFPUCsjrAkNM+TsngE5K6dtY5hmYSxvB2fMZoL4Tq8jnITZN1Y1bBavaqmXujIGY6bmnnUWs+VhZUXA568=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740170483; c=relaxed/simple;
	bh=5Gjo4svCdjD+vRTtErEHaPC5eZ0PqQDtzAUw8E40lQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdo40AVlztcycKSPzuJdZnPA9is+XdzMb07NfzUimSarT7aD+vJsluLGa+EOS15DdrYZyrRwnrT0gLv1oM3UgpYhygWZdlbaJ9GI3cH5hhz6X9hM2eKE9oD27SXTx60XWRFfFeU6XiDX2X5MjcQJT7XQHSc7I0NzJPQloKGpzik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aGn8MC7V; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aGn8MC7V"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e04861e7a6so4770510a12.1
        for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 12:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740170480; x=1740775280; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGZN9p0rTvcJqZHB5KLAfK0CC9Ej71ELDaK3aqWOBvw=;
        b=aGn8MC7V0MYqkbYtJj7dxMUs+a1cHaKUiNUPjv/LUasRyi2NHSrFC4e72fKpkGo9U+
         iNUpUSdBINjE+BktiarLwpyNlH6538NnShial+9O4vpSLPXmjQhWGdTl2sG6deuxA7FA
         p3ImRa9DnqZg5qHX6oJ6bRvROee+VWC0WOHQbSjkhQKGmpcBCSLq7rKz3oyuM/TzW26Y
         XwsV2QK8Cc6Us3KIBMcZmQgoOFZncc3vX0tvagZnQxW4Ir4ga10R9E5NAFqilHaVxvlz
         UejUmGvsgJSosH0/VqY4kOrV/HVvMN9GxRRHRD4Jx99UFDobUC1HzZwzYIZ/lDlouwK+
         7dzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740170480; x=1740775280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OGZN9p0rTvcJqZHB5KLAfK0CC9Ej71ELDaK3aqWOBvw=;
        b=dW4P+pR6veDJ9iYHina7ipevqMSCIj6aNm2064SJP59UMz/AKjnKvIRjpGnLTH1EiV
         o3ZGvx4xTzFdOfULYXoaFZOh2jYhL+W2Z+hiywcLUudOjome6EwHiT1IqYHrOebGuPIp
         MaTGlhhKFIttya3h/RY/+wt8QQMvSLGq1c3detQ8uvEqh9rn2eNg/yseRhKZmHukVaP4
         417fZVEWXJAANnQMJUls7tz3blQPZ59DS279ojdhiECxCKtt3omlbwxed99C3QO41nVR
         tsWtpeQS6Bsg3T+DUKihMf15tdmMH4zpWyAZMc0ZdiXSxEmtdEvsG7lGvOtD6EhKvbM+
         hB5A==
X-Gm-Message-State: AOJu0YydHCTg4feWW1gPTPmIRhCLZcaggXprPZL8yl4/iV69ejB299d1
	8kBEmG8EpVuAGEQZ6veGMrm0a0paRFhcDTOd2tu/3vb7YTtY3Fi9GNOp2Cp5aQk=
X-Gm-Gg: ASbGnctoKjId02hcBKAygYdA+GBtDwkmIanLoV8cZWWvZa2HVVmfI9k/riQlsg6DnDj
	BWzThJ7WT3CXULuq3zC3zP/cSIEPjAW6AZxrTMjPgAkUrGU3eA6QgEJOrFwlkXji7wF7rwy5vga
	nq9HDf5JHCCnysMMxBaUd7thKOKI5Ci1PANmsUFuu4rldIF0ORuqhHCsniGFYs1m8xz2E8oTwBb
	IrcjOCq4VHyVb6f40/oFmKqayMesNCD8eSVNt4B75ghrhWv9oKxZ9w3Ccq6dT70e+zjjFKiEcK0
	cjD5MavhbZLjDqx2elOdBYShfV1mxNDHNfKEaRvW3xtQzuev+uHSUNUS1JK1H0RInTVDbZSKID1
	7OPT1mMGfKIow
X-Google-Smtp-Source: AGHT+IHI+MZpPFXvlwyXs0006rG4w6/x3fbLukuUQZnsJru+LhhU4MZ0nsZUpuBn/77p5Qi/YtWDIg==
X-Received: by 2002:a05:6402:34c6:b0:5dc:74f1:8a32 with SMTP id 4fb4d7f45d1cf-5e0b7257af9mr4195955a12.28.1740170479846;
        Fri, 21 Feb 2025 12:41:19 -0800 (PST)
Received: from localhost (p200300de374627004d16a5f447740583.dip0.t-ipconnect.de. [2003:de:3746:2700:4d16:a5f4:4774:583])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5dece270cbcsm14855774a12.49.2025.02.21.12.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 12:41:19 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 08/10] libmpathcmd: try both abstract and pathname sockets
Date: Fri, 21 Feb 2025 21:41:07 +0100
Message-ID: <20250221204108.70631-2-mwilck@suse.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250221204108.70631-1-mwilck@suse.com>
References: <20250221204108.70631-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When connecting to the multipathd socket, try the pathname socket
first, then the abstract socket. Fail only if both connection attempts
fail.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/mpath_cmd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index c7cf954..83cb6ad 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -102,7 +102,10 @@ int mpath_connect__(int nonblocking)
 	size_t len;
 	struct sockaddr_un addr;
 	int flags = 0;
+	const char *const names[2] = {PATHNAME_SOCKET, ABSTRACT_SOCKET};
+	int name_idx = 0;
 
+retry:
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
 	if (fd == -1)
 		return -1;
@@ -113,13 +116,17 @@ int mpath_connect__(int nonblocking)
 			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
 	}
 
-	len = mpath_fill_sockaddr__(&addr, ABSTRACT_SOCKET);
+	len = mpath_fill_sockaddr__(&addr, names[name_idx]);
 	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
 		int err = errno;
 
 		close(fd);
-		errno = err;
-		return -1;
+		if (++name_idx == 1)
+			goto retry;
+		else {
+			errno = err;
+			return -1;
+		}
 	}
 
 	if (nonblocking && flags != -1)
-- 
2.48.1

