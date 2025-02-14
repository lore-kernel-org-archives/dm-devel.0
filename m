Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8CA1FBEBF
	for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 22:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739571039; cv=none; b=Bm3c2kGMKhRXxYv+buoi2uEwuHeVm8F8Ko+hCB6XQrPtzVXGr25F46PDvDvVc+rNWfjVY9PTElKUlUQeG87gb1aHgSWXjCTeRH8+MT9SwxmZxgEdeCcGc4JN6Goctz7Foh/cCeSFYxTfyl7zyIFlWgjaCUkqIx0oGt2UAxfLzlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739571039; c=relaxed/simple;
	bh=2Y5F1cGXLU9v5N61M+fYZ4o7dw3NlqAfIAWeI03DRDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkyYxxYdlpJ9wIyISbzkOhZ/jsWeH6mqeBMeV5EWrWKFrwtR9+qT4TeUEYdki33kGIzA+pDjF+7gzxVk6Szk1527U6om49tcYHSOEpbWNRMZ8f8ZrqbaRMxWqkH87po3DvGh1mgKll+5w8+HH336brKA6J4gFWlMunz6NS4Brq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KDrNKWEq; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KDrNKWEq"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5de63846e56so4744415a12.1
        for <dm-devel@lists.linux.dev>; Fri, 14 Feb 2025 14:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739571036; x=1740175836; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CatvQEzHVoc8N6QoTtk8QoEkCaj+lbixe5m7NOS42o4=;
        b=KDrNKWEqfUr1bMuQidEw4CTiLbMgiJt2P2YDj01rveP+qyPkB8pbAGuJ/xVcFr5Pje
         IGOTO7wwNi+IvF8c769C3fatqiyikHzjvGJ+1lzjSkeAnVHKXao3aLRxWV4a1Gk+UQdv
         4EKXSclNMGzF5ElL3MFDtrZIt+41Ju0p0WYIOSSbMn2D1CJanXi3UTQVRVtwb34Ugta0
         YvhyQePt3bZ57dyObRckl2TTwcl5y/ARiJ1uVVp9SSQC2dKpjNmbqJnNftKDmHhgl4Tt
         aXEcwqnJNtxmYJttDlc82iacF3MLFnUaOfx6542M9sfd9JlV/Y4BwvPaLB6xHhSfyfwr
         WuSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739571036; x=1740175836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CatvQEzHVoc8N6QoTtk8QoEkCaj+lbixe5m7NOS42o4=;
        b=p3pPgklP1+jgu1IzxzSMe/nRaRDtrVSsftPDg+0nwv2yzJ2eAALTjuRVL2O5f5b1Af
         HufFg3wgBPwaPFHJ2LbqcDnrYRNnkUaKoBZw4i9y67vvUSr6cm7Kpr0o+V2ZBI7QHjw1
         V19r32lDtIqQ5CtdfThKs3O2K46DbVLxtZ+5ZfLsl9m466dXG5Ez2bG02JrB++CG4u+x
         mqUiz/9hR7gjbXdaDrB5kD1KRXYoiwpLbDnxfg7FkSPipeUaGfHEHbFw6J+BC5QG+vJ1
         YY8vo9hJBFOBtrFw5KG4ie4XKWB39vr6PaoKKfxLQVm+bH/8hXR9ulXEfcTZTDtIByRQ
         Rj+g==
X-Forwarded-Encrypted: i=1; AJvYcCUePk4OzjalXv7t7Q4wgTSOkDtcm1vqew/NOUxpFZjPtqbKbOxkpHz3z32Td/jb1hQFIcg1CqsIHQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4GERqKCnIk5QbRk75q3GJKiEwcrQHp0ToUtsyruYJnBRziIq3
	BNAtVHoslPQY3gZpVrZxsZXQxjyqOrJFUp9D3l/R24E23l5OlkZOPEb9q2hB/T0=
X-Gm-Gg: ASbGncvT+xUWXRaVBqrz/hzmiOD25m2Rdz1/urDKEXv/yvst8u8SX4ZgjaTO9GJSilM
	A2ZUSbn0dMb7QekEsD3U0jup4Aj7DlUoggje1jYn2k6fI2jRaH4LGg+8xGE87eIw8vMKJExXnJt
	bA2LSLQB7+T+8lb64tjRGmSWipAkOpw6RQW7bWx6O8o3ZsFeGzeZTxW/GJ5C0uQm9UHDum8U31k
	psjFNwJcjbwtlnVy7TzbS57QdFsdeWwUEJTife/2E2YsNtp6JRdqWbMFK/q00wR+YfLnJHellUc
	fFgiUAsVrRsjJvqefHiXfKUDyxiM6mdae5pDTlc/hVO22/l5C7spdT79Laoa/kQxsEAwgLREFuP
	DTA==
X-Google-Smtp-Source: AGHT+IFh4dR/V1DbrDmTE4vZgeiq41BniHpryRAOPlytwU2aeS5oO/t1Pgmt7k1VvrtCCUe6EJEF3w==
X-Received: by 2002:a05:6402:5246:b0:5db:f5e9:6745 with SMTP id 4fb4d7f45d1cf-5e035f4cbcemr1163795a12.0.1739571035762;
        Fri, 14 Feb 2025 14:10:35 -0800 (PST)
Received: from localhost (p200300de37464600ac00037825cc9f2c.dip0.t-ipconnect.de. [2003:de:3746:4600:ac00:378:25cc:9f2c])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-5dece1c4483sm3522515a12.25.2025.02.14.14.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:10:35 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Alice Frosi <afrosi@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v3 09/10] libmpathcmd: honor MULTIPATH_SOCKET_NAME environment variable
Date: Fri, 14 Feb 2025 23:10:10 +0100
Message-ID: <20250214221011.136762-10-mwilck@suse.com>
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

In systemd installments, users can already override the socket names
that systemd listens on. With this patch, clients using libmpathcmd
can be customized to use a non-standard socket by setting an environment
variable.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathcmd/mpath_cmd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/libmpathcmd/mpath_cmd.c b/libmpathcmd/mpath_cmd.c
index ba5bb31..405267f 100644
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
 	const char *names[2] = {PATHNAME_SOCKET, ABSTRACT_SOCKET};
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
-		if (err == ECONNREFUSED && ++name_idx == 1)
+		if (name != env_name && err == ECONNREFUSED && ++name_idx == 1)
 			goto retry;
 		else {
 			errno = err;
-- 
2.48.1

