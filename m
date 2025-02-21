Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45257204581
	for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 20:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740170485; cv=none; b=V3iXFLtaB8XZWvgmnZ6bKNHtr5nS1L4GQZs4zWHwEbsYXs74XBzz0zdaaxpNAD7uCFGAJzomiQnPkxxoydOM3aOLdxevq/q8v3mPZ9yXVEdsmDTg/h4jitQyMEppREfR1kphRYQJpQr+jdGcjCcNoBwgOnVtasbQUbRG8SfvJEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740170485; c=relaxed/simple;
	bh=jALSHQRwY6WENsfkHN10Mtxm3FZvRYuhlxUwSRJ3G+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=risHcx26twgeG+VhVaNFtYnRPGe5mI/etMPOamTlQs4YWmAZcqmcH2CpR2WFWSDjff25wR7t0h8xJQFC2LhQCkgwNTG6sQz0WJNuAJbeLP1JjA5kSrN/WgE2X2+fdyxAyzqF8RS9fia2zWdhqnMNQNRVCFQm4YgfFxPxqksCOfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X7FdUD3x; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X7FdUD3x"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e050b1491eso6332179a12.0
        for <dm-devel@lists.linux.dev>; Fri, 21 Feb 2025 12:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740170481; x=1740775281; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nADAy1jfNjFH9+8Gvf9EzcQJTHlmsRJNM1NW/VbbtYY=;
        b=X7FdUD3xx7QWJa3AGcnMTrRZUssKOUT51O6kfG2tBsguaAnsLcvfDYo1AEMCRB76mp
         pJBouQF3ix0HWeivsVuHXvjq7uUFS4l4o0mig3qQxHV/QKkch/eiGDDWaLL4aSVgJ8L8
         PWkjvhvaDQD5NADpWRNX0INEw7nVZssPf8WQ2Es4EE4JhciQGyFoTNtncg0Ll2T/faFK
         t/WxhDVACVjcu16VPyHO+YVu3h/NS1/9ubAfAnSm41avECtuugCH78DniRXPQ6mUT2KJ
         zEGRyH+rtmCPMbY2ZSe9fWXBd92juonhqmNWBlGWxBbhNTzH8weDFdksnc1mbpuTyGHK
         A1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740170481; x=1740775281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nADAy1jfNjFH9+8Gvf9EzcQJTHlmsRJNM1NW/VbbtYY=;
        b=gKUQDTSMUKK5zFOZavhWLbTvLrWCoTKUO92CFkxUKbfiu1X9Uw1u7L6mqQWFyY7XJO
         ZRsENvcB5b0dCLsty9sL43FTaS6NAlWr9qju3Ile5XdCkPZNTBXYfBr1pNSX7Yn9olUx
         t6T0JeNOEXeDVCifS3uOFLzZW+2lYlgOlQjA8XijfMwQehKVG6nisRSUHiOuI+/uXOvX
         AQp4ql5hcKinr8twy9aN3aw9r7GbcimEFKcO5zPPLbeNM2122UgzhY8msDUo1zbTqxzA
         eM84xoPVZMQeKQlTcu0K45zGhff3mI+eGTI0PuIJP98+2gcaRIAZNLNvSU134SuNETGx
         QfnQ==
X-Gm-Message-State: AOJu0YxDqLubozg2UkwLWSzGQEz7w17hBnz9cW2fPso/H94kU8Im0G4F
	enxPKDdzyqcDbad6hqAKYazACtxIGN3fDwJah7aPqXuSTBljUvg/uERVJqy1JmI=
X-Gm-Gg: ASbGncvpH7zEXQ+1Oq8SBUYyWjHnatE6QENzl4O7CM9OMehVIS8ItrxQ5QTm9JYF7wX
	caGU0dSHwTH4zbLLvCzkX8vtzmTkfc1uhVb3+WQhaHliZkeZCCGyOhCpjUjb+H+/JBFZsIqCmcn
	v5KRo/lS4ZG+/Mz08IRJtNZFiiifenvxZQiRUZMZrpwbfg17+X2NYl265egNWIhZCQiA2YcOOtX
	Gk1OsLHF2UO8Q2gO2YHysKtO98U1ef6EblsRzVVSpOwqT70P/4DGbLGc9c6gksxhYU/bCR+StSg
	GYg38z29rZcnbeaC5nOsBlfPt3Msw8FIH2ti8HL/eNsajVCofuy9BhFeHREdE9j2sJGMwnb1Dwe
	+n89X4soyfUsl
X-Google-Smtp-Source: AGHT+IEdsCgja35Qo6suabESYJs4hqNvOM5QCY5vsmZSU/moysPFCjYkjRg25lbnyWGmifDS9g+Xzg==
X-Received: by 2002:a05:6402:2103:b0:5de:5939:6c34 with SMTP id 4fb4d7f45d1cf-5e0a12d7bf1mr8765210a12.15.1740170481195;
        Fri, 21 Feb 2025 12:41:21 -0800 (PST)
Received: from localhost (p200300de374627004d16a5f447740583.dip0.t-ipconnect.de. [2003:de:3746:2700:4d16:a5f4:4774:583])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5dece1d3624sm14478969a12.40.2025.02.21.12.41.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 12:41:20 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 09/10] libmpathcmd: honor MULTIPATH_SOCKET_NAME environment variable
Date: Fri, 21 Feb 2025 21:41:08 +0100
Message-ID: <20250221204108.70631-3-mwilck@suse.com>
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

In systemd installments, users can already override the socket names
that systemd listens on. With this patch, clients using libmpathcmd
can be customized to use a non-standard socket by setting an environment
variable.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathcmd/mpath_cmd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index 83cb6ad..5a23236 100644
--- a/libmpathcmd/mpath_cmd.c
+++ b/libmpathcmd/mpath_cmd.c
@@ -20,6 +20,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/un.h>
@@ -104,6 +105,7 @@ int mpath_connect__(int nonblocking)
 	int flags = 0;
 	const char *const names[2] = {PATHNAME_SOCKET, ABSTRACT_SOCKET};
 	int name_idx = 0;
+	const char *env_name = getenv("MULTIPATH_SOCKET_NAME"), *name;
 
 retry:
 	fd = socket(AF_LOCAL, SOCK_STREAM, 0);
@@ -116,12 +118,13 @@ retry:
 			(void)fcntl(fd, F_SETFL, flags|O_NONBLOCK);
 	}
 
-	len = mpath_fill_sockaddr__(&addr, names[name_idx]);
+	name = env_name ? env_name : names[name_idx];
+	len = mpath_fill_sockaddr__(&addr, name);
 	if (connect(fd, (struct sockaddr *)&addr, len) == -1) {
 		int err = errno;
 
 		close(fd);
-		if (++name_idx == 1)
+		if (name != env_name && +name_idx == 1)
 			goto retry;
 		else {
 			errno = err;
-- 
2.48.1

