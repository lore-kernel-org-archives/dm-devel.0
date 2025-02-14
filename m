Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6301DC198
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571038; cv=none; b=hGFrHlFCyFpdIp+jhCY7B2Ybe6RAaYRq7Wak0PF5Lex/oXRrnsnw2ezAkn5AxopOGiOCG4H7G9xffMEhSTahBIzblP4mdETzXefK4n11oxncjwUxRjrukyIZU+GRL4PTIMOLVPhBwui+1opz30coNnvGji6cf7uQlYGG2OUai2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571038; c=relaxed/simple;
	bh=Sgs7G2XbjhR17uH6if9QSsZzItfemXzPZt0IiWGNQWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o59wqnDUb40dllMGvs8t3VqIeErC5chYUUDDjXqpmUIBPpocMBP8F4sq0VtKX9ExVcV5CbdPaZcgg+Gfjw9nvB9mBTmyb4WN5Grn5uto7ytpO/1hTZI02RSl1us42Dxo/Qi522skNQtwReSjeeBU6ptOl9fQAtkmbH7oVz1fkmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YoN0Gick; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YoN0Gick"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5dedae49c63so2824002a12.0
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571034; x=1740175834; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTz2EEocUipq1j838IYHG+vuxnn0i4KvU6vOXOtzbBM=;
        b=YoN0Gickqo7XaWbe+iQdsBmwvZCMKpOkq+sR6+XoPuCiSLUn/BVbQb69bAnMb+ubrk
         qHmR+i/kyf2xM8bWa1agdgUnI6LgyVD2F+hBgde8zxQMxMKWKAIbMoBzJHgiXSu2VWcz
         06lvUkzaKHHyGGoXzD5bEiqIFhx2O5cACFCG7y2iEq/U3urCLLv87LDQKFrdyInu1LdL
         miWSIP0vXbjXZ311wGOBtXRqjyt5Eu0FlN2ZUZjmSA1r80HzUlUDJAMn+z/YkKmI6Bbt
         SGmuYiBGXW70G6DywmG4YTDdD8ntWcR+TMSuiTq/Jqaqk0b+E7LkdTMGgc+fQZCD7VWr
         UnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571034; x=1740175834;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dTz2EEocUipq1j838IYHG+vuxnn0i4KvU6vOXOtzbBM=;
        b=vLZKPIZ5JT3dRDafrF1zClmTi0KSIn7sivbLrhsqA9M+xElQ0PsIfzbvRt6FoKxI1i
         qWCSZWRXtX7ZFJ7IbrxTgRBoqVY5Z2Q+UF4NvFSW1pBuQK+0k+myz406IpBLaiAij0Gp
         yHXHO/ArSNoN5Vnohk2PKJEby3BhHc0J1UM8nh6gVtXxvzwePWlZQZyPI0H7W0V5ypHK
         aQP5fofz9J8k9xZunUy7x1ldKh+wU9vAJitJttwuJfZiL5B8xsiKFHFEQDKhPCrxHDza
         ZukFOqadzCpotmpCyxpZI/5PfEZ/XpPoNoLg/fmKXUfHaQUh1SUudCaYc/7LvaaqCUSi
         ERvA==
X-Forwarded-Encrypted: i=1; AJvYcCV71YxQXfp7+NZyTCnk3ZWUDCwAnFkmTUsCMEWKSi0QpxefLUidmx+JDJSsTaiKlYumytlYSIdnnw==@lists.linux.dev
X-Gm-Message-State: AOJu0YyINTVMFrozsT9nPt6QPvmmzQ/WuMazKevBIYJb8fX1we7ghUGH
	uTAKbnRmv6d0Ih1kprITTZX2B/F6tzPYnPqgEcuSnPHXENbR4pV5OMkSxF2DzL0=
X-Gm-Gg: ASbGncskNB2NcEcvQX9S3HKjXMQhzaj30pmnQEovmEG63yzce+poGvypUH1vVJtnBI2
	WbxUPNZ8oBxD5ATXr6+MjMLLU+VfBiKyWd2pp1SSgT+TxAnU1exYEgbwClPIy9O4PoVm918V8si
	E/7E6+td50KTW9kyiNmi/dpJgdcM9DwO2pExc1yR/MkcXx3wQdnFzHPtBmR2N3VBywM1Z3wp7TO
	yDv7+s1+kKGe9I+1Pz4/cUsSFCVJaOz04qFhLZlcEKGboP9Ncy34wcIVoxP5yOe7MvBJKdkzyHY
	y2attIOSb/uWDN2y1mQz3/uxqHNpPp75pnvKC0Ek+rHtoNaRnxpOdUgnmJrKzkEjtmITHAQwVsS
	Umg==
X-Google-Smtp-Source: AGHT+IGjL9y7SNiMgizSPC8SkyhY6UjgldTD8oCLSub80zJEiVdnB4CMIVgz8zsO71ce2WuulJ+2Pw==
X-Received: by 2002:a05:6402:51ca:b0:5de:d313:d059 with SMTP id 4fb4d7f45d1cf-5e036112946mr1218070a12.18.1739571034274;
        Fri, 14 Feb 2025 14:10:34 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5dece270affsm3451038a12.54.2025.02.14.14.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:33 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 08/10] libmpathcmd: try both abstract and pathname sockets
Date: Fri, 14 Feb 2025 23:10:09 +0100
Message-ID: <20250214221011.136762-9-mwilck@suse.com>
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

When connecting to the multipathd socket, try the pathname socket
first, then the abstract socket. Fail only if both connection attempts
fail.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/mpath_cmd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index c7cf954..ba5bb31 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -102,7 +102,10 @@ int mpath_connect__(int nonblocking)
 	size_t len;
 	struct sockaddr_un addr;
 	int flags = 0;
+	const char *names[2] = {PATHNAME_SOCKET, ABSTRACT_SOCKET};
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
+		if (err == ECONNREFUSED && ++name_idx == 1)
+			goto retry;
+		else {
+			errno = err;
+			return -1;
+		}
 	}
 
 	if (nonblocking && flags != -1)
-- 
2.48.1

