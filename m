Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA5418E1F
	for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 07:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750662321; cv=none; b=FJZXe4RIIvb3Uv54L779pP2NpO1a5a+CWqDZKRsrTyhkDUhVmXH3jwKIhryLWirmJe8UDGPxc5udGiEVTt/zq7U+kCQUESnp20srDo/r0yzBx2vSWQv5WHc7NbAvMQm2f/j923/p+1NgK9vmNgjJgC+4wceuko1AMh/sCQ0pbxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750662321; c=relaxed/simple;
	bh=e1ldcIKo1apHxo7jJkiK0AcZmf7DoR8TKTvvx9iqCgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rutto7kI8qLP0MRQhikTx7UWf/N07Qqht6m6rYx1yIMu1V1MOYdLdu3ySQDjyVVLhFd9niAjm6fA2u98L/mDR7wTLnd/TwrX0npA8atmrvYCI48Zde2n71/sIqkUGmtGzogrMuIB1ym4bS1ShXiVd0SlLtf0XFv6XYXNjs0ijic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gPNAdvl9; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gPNAdvl9"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3a4eb4dfd8eso562888f8f.2
        for <dm-devel@lists.linux.dev>; Mon, 23 Jun 2025 00:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750662316; x=1751267116; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3kXN7+iAJzl6N6agLvxtv2MPw+VWbD+mDFPoBqiNJOg=;
        b=gPNAdvl9ksJ8zSAsbYPGduqv3t/XCjaP63Y9v0imwHGy3Rl/lc0HOYneGvalyjQnu+
         9BbuJGZR8TziqfzAMKikJ1gXwXzR8qNzG6BzkmizaatKTtI+C115jBxTmxTICySKTPlH
         04Zr08WHPXmFmojqK5xXgh89i/kvVC1gnlpkbXuL2Q3Ye3vjwXD94nphQJikOKbgTUfQ
         9mdUehSX5V1+iqJ9l8ujIaIs8qVVIpr7tbs3bh7MoQU0fiaKFsdNce2IxDyjwZ0ez0Ek
         dWLbNFqH5y1Burt3T/IHwSYjmSrBy8/fzWnHc6XCii5h7mApnghiNOwwdWS/RDTrIt3f
         Rusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750662316; x=1751267116;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3kXN7+iAJzl6N6agLvxtv2MPw+VWbD+mDFPoBqiNJOg=;
        b=SeBg0rUv6Ue9X4auO6iJcOuW4TFw121REDYh2Xq2HSRuwg2zEbmE4010QDxjiH+9cO
         bwZ9jDE0goH7iFOToAx091oeVXAhWuVf1Nz+8rON5CnYdtFin5H0CChLi+bjjFltdIof
         MF0Zh+dJ/yqG6yzsRh+XZ5igC4En/B+LevPTHja+Es6aW5Qc0+IIVXTPjQa6oFwMaaKo
         LLvmTaLZ2q/E6MPX0m3Fo9rAHVCchV7GU7VCs779yvAaF7oeZv1Q/FIgncu5/KN2AgZa
         DDJMw3sU/fCTErTvWfVrZu95An/6++Kh9bDbRHUWmI5MIvMwBVgR5TdPPzw9wzbqkPZt
         4q3A==
X-Forwarded-Encrypted: i=1; AJvYcCWjw0rpcS5zPnWLG5/tAq3Ph/mTYbR/Cb8xSG7sq3Bdj96ykZbajONb+91q9lIvfe4pBjM3gXcYnQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwvuYdzS2rE03OSq5CYcSsxmXHiDVuRigpYaNSdTmOBTJYqpBFM
	lymPDQQJQuRE0ZE6iAjexQ7ZDmLfHJTU6ef+cliRlV0GuX3TRuuMMS4=
X-Gm-Gg: ASbGncuRkUrGcuvuf81Aca4/305umMJDV+tpJscux+dh85XaxVMtcANnFha8avX7Fqj
	4bHDZvN7IfosbOoVt1SaH01Ha/aLZmNW9QnTynMdEjimcNPZkiUP9iqbNxKgjgWawzltVVkHF1t
	c5cG6t8SaAHoDpDcmBiVdL+lssC5hDT53AG9USQvjuQVH3pmz6YmkHe8rmpDUQPwdTxaDUkqcoC
	qDT6dYpbpZ2fvhFtTMaaxElYL8fWuWEPsg9+LscTl4QAOjEpf6Gke8SZG/O9ObCQmcT6pip7SdG
	Kk1sbnUoM+IEJv/QkBI6wkCL/FkbJ2zoA9+WM3USyX9arjcI3s/TqQQWUz0akmV5WSFzYYc3lY4
	0lygB6uUytlMVsZqeI8Nf
X-Google-Smtp-Source: AGHT+IEsxIJF/gbBa4LYBbWFVbhE7PJ2+9mala1VnEuY7F4oahyxhKrFuJ/+h+zHhd3gj048gh1tiA==
X-Received: by 2002:a05:6000:2384:b0:3a3:7bbc:d938 with SMTP id ffacd0b85a97d-3a6d12a14b6mr3386023f8f.4.1750662315767;
        Mon, 23 Jun 2025 00:05:15 -0700 (PDT)
Received: from localhost (8.red-80-39-33.staticip.rima-tde.net. [80.39.33.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d11881basm8545807f8f.72.2025.06.23.00.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jun 2025 00:05:15 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: remove extra hyphen from GCC std option
Date: Mon, 23 Jun 2025 09:05:13 +0200
Message-ID: <20250623070514.203888-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html#index-std-1

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 create-config.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/create-config.mk b/create-config.mk
index f05fdabe..3c3ba069 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -162,7 +162,7 @@ FORTIFY_OPT := $(shell \
 # including urcu.h must be compiled with at least the C11 standard. See:
 # https://github.com/urcu/userspace-rcu/commit/89280d020bf064d1055c360fb9974f128051043f
 C_STD := $(shell \
-	if printf '$(__HASH__)include <urcu.h>\nint main(void) { return 0; }\n' | $(CC) -o /dev/null -c -xc --std=gnu99 - 2>/dev/null; \
+	if printf '$(__HASH__)include <urcu.h>\nint main(void) { return 0; }\n' | $(CC) -o /dev/null -c -xc -std=gnu99 - 2>/dev/null; \
 	then \
 		echo "gnu99"; \
 	else \
-- 
2.49.0

