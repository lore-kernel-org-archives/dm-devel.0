Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061001E5B81
	for <dm-devel@lists.linux.dev>; Fri,  4 Apr 2025 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743769777; cv=none; b=bgCiKxBo+3GA4oelbl47QdsOIWp7JiMD0au192o5nf4ueJjPkgozGkXa9W8sXMQrr+5pyt6aqFLArD/IIfi21AC+ucAEmKcSoKdjeDrlZ5XXUlMf6yZgvPMJ8JTJ2Yb0+WmN6PnBLfpOM8pk/rBlaRyhnW7dc2/kyw8/7tHEb0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743769777; c=relaxed/simple;
	bh=U9XmSc/eT4rJKrUvcQ2uZMzXZIKpmFQ/wHB8ylJl7+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UUmey4LqpNdMw3WbP6454tVmGtuB8cJcWXWXoFdeFUYv9NqCYxtp2uLQ34xmw/D+Tx63JoCmuQtfs/nzCwPXy5Oqel4SvdANUiHraf8xfLGGPIdxOFWJMqjLDMXJeqlpSxd2FzyGaV84XRa8nE6wzMovMRiBgOz3tlPKEu5EKFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr; spf=pass smtp.mailfrom=smile.fr; dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b=zlpaeiy1; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smile.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b="zlpaeiy1"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso2381920f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 04 Apr 2025 05:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile.fr; s=google; t=1743769772; x=1744374572; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nbMFBBBLzGPEYonCbdF9oPpFUvM9Slk2+xMQflsByvw=;
        b=zlpaeiy1Q9KwJ+jPks8gvW8ZF4ALtJFn+g/y+n5k2or44lmskcwp/R/kWCeKBrypHf
         Y+6EYMROb68mPFUtIYvLhr172I0TSeNKVk7UVcnHZ64wYce2q40hNEe7xJ1rtszSAcRK
         znHeJRLFDnQ8fymvacq+EI1hOSQTXMbex/RrI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743769772; x=1744374572;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nbMFBBBLzGPEYonCbdF9oPpFUvM9Slk2+xMQflsByvw=;
        b=IuXOQQbBa8lAtPwoIuuIWmmX2ssxEk+W3FDd3pU2xMbzuyfow+YLEBZdfMozqIdJ1M
         SkA4o1nLeiYtjBBdq5+3sH70441Q3XAewOWC/p/5q7iA93jNhbMIZqYHVnjVO6SusDa3
         xbkxg8V1v1tkAk/i3W8Sa2dwehPyyQgImrk152oY12fZ3JJGsThoSSVoVHug8nnWIskn
         +8Z5W2Vgjot1MBwd7wf4BoiNb3AWu+sJOppclFDCUi4wd5c5l3FkezPQURXx6TmqAlub
         czPzisuzfsyDmAlYCcHk2RilKKdSDy2UNQmWoLv3ePGy9AXP/mWa2ckfEcWrjczO6m98
         YDxg==
X-Gm-Message-State: AOJu0YzWV6gj4gxq/ckIZ8c+FjJvbFoIleXKQiHJ9R5H/+YM4kIcEkVC
	Qw2y67yZSAt311HzU9PooNK9scTaC1otNWM+B2SkdBn9dAI8QMq5G5xAN0QT5+As66B11Whfzvc
	PKPo=
X-Gm-Gg: ASbGncupCE9lYy/Awc1Z1SFH0AcEchGlBWTrW+AsMPSsAKixQuAZyxaBbH4pV5PVzEu
	XmeNqFcQ020wZdgcyPYtw8ct7PDc+U55bVulHQG2MrPi61MsmQrtMWM1PZtb5ZZ+QavxjLXcZ6D
	1MNSNG7mdb14N7+4y8H/iFfIFLtC+b5xW1REgkhLgShiDxNpdVwFKKPmYVZqWXuE3hnpitiE8Uv
	UDEUw3P6emiDlMGuv6QkQyiHNj/Yb1m0VS7p8XDZ9pLUBRbIIRuWM71yUO5BDN2fu8yiYmewjYH
	Jn7zrX7tcEpIiu2uUvN7vZndWrMcxNMrNUdGcP+IVLpj4rXQzeoeuUK7sd+2uUShNIljOjwz8As
	++fDUpDOWADIF+P1j/Lre
X-Google-Smtp-Source: AGHT+IFpPPXN/jHMJqcKAV1OEqTHocIICVynh7U7kxobG28Ga1RvD4plMGDVOzkPE/TLGIqxnPSWBQ==
X-Received: by 2002:a05:6000:420e:b0:39a:ca59:a626 with SMTP id ffacd0b85a97d-39cb35ac7c7mr2693460f8f.28.1743769772112;
        Fri, 04 Apr 2025 05:29:32 -0700 (PDT)
Received: from FRSMI25-BPYTOP.. (205.226.7.93.rev.sfr.net. [93.7.226.205])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b6a1esm4280356f8f.45.2025.04.04.05.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 05:29:31 -0700 (PDT)
From: Sofiane HAMAM <sofiane.hamam@smile.fr>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	=?UTF-8?q?K=C3=A9l=C3=A9fa=20San=C3=A9?= <kelefa.sane@smile.fr>,
	Yoann Congal <yoann.congal@smile.fr>,
	Sofiane HAMAM <sofiane.hamam@smile.fr>
Subject: [PATCH 1/2] libdmmp/Makefile: Fix KBUILD_BUILD_TIMESTAMP usage
Date: Fri,  4 Apr 2025 14:29:01 +0200
Message-ID: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kéléfa Sané <kelefa.sane@smile.fr>

Add missing $ (Makefile need to escape '$' as '$$')

Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
---
 libdmmp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 172ba045..7e0e2509 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -74,7 +74,7 @@ doc: docs/man/dmmp_strerror.3
 docs/man/dmmp_strerror.3:	$(HEADERS)
 	$(Q)TEMPFILE=$(shell mktemp); \
 	cat $^ | perl docs/doc-preclean.pl >$$TEMPFILE; \
-	[ "$KBUILD_BUILD_TIMESTAMP" ] || \
+	[ "$$KBUILD_BUILD_TIMESTAMP" ] || \
 	    KBUILD_BUILD_TIMESTAMP=`git log -n1 --pretty=%cd --date=iso -- $^`; \
 	export KBUILD_BUILD_TIMESTAMP; \
 	LC_ALL=C \
