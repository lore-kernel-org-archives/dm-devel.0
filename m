Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D98500955
	for <dm-devel@lists.linux.dev>; Fri,  9 Jan 2026 18:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767983991; cv=none; b=a/gBqW0NIwMMzDqfIaYprRfAKsvMRBTYYtC0RIrz1W6mw2sQefiNrLJn2cXOqyZaqT4vgcrgZdG0M5CXOW7vmS5AwZ/YJRswvZx7QiZfNq6QhmWYyPbRn/jUvk3hRsOzFi1/JdDgMUxmgsMfm+A2OoIL5ImQJ8IE+CLx5WQJ7PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767983991; c=relaxed/simple;
	bh=cQUgG22Bjs2dQbHQ018bIeCEALBJ/7BqHtIRGPwQu+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W53JNEgQ9Eg2H0rUg55rN/kqRg3MHZtUqqQnhQlxgepBJIOpduvD6iUtzHlIfJ5IDO3BQzXAessqlRxNl/cDByr/ws9zDMcH9Sw1JK9iO9T8RUkwztKAHv/7N1jri9+vvd29J7z0R9+FXStDO55qpuyzJiYTeAyz79dE1UePttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O9L2OVCs; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O9L2OVCs"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47aa03d3326so38593175e9.3
        for <dm-devel@lists.linux.dev>; Fri, 09 Jan 2026 10:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767983977; x=1768588777; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2kPcsCa0+sTA2KITnHd4lPcP1bslLjKXUMb+D8RNoLQ=;
        b=O9L2OVCsnhyRMji17IkDKyyG1zK2QxtudIH/07bFVvH1tfs7wKarR2TTgOtn11HOp3
         QxtmOkgyf/UH/yf72k3LWZIo2VrKvrxIOc3J+k9LA7MqnuupE7M07TLxAssqQz8D7GgP
         WDySmpAWPB6AXangX/lYi5opwZ0q9HesQbRyqzrPoXHeqYnSkt1SEIkNLOrKBkFr2SCT
         FfG9qWJ4Pzn0SwvAK48lg8CL4gh+WQ96qGLjNgNRelVfyB4gEh4dalZRltGF6rnSLOxP
         PUjVsv6QP98bexTNeaI8OY0BucXDuhJE2kPPEWfho+KBSsaq7IVWLDFojBa+As3NtLO9
         87cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767983977; x=1768588777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2kPcsCa0+sTA2KITnHd4lPcP1bslLjKXUMb+D8RNoLQ=;
        b=s9jQoXndchauk4uE1qYxDAXlKL9B1n5XbKC2NskHvSgpR+36IHy/jXrSPb8OCDL2em
         72yNsSTSI7IYeoFBFForVAae0pWYHoU0DEnYicMLomiVMLNbwiI7aoKWx2QGISRd0pon
         0nQmwGOCQmQImcfibtWsX1Oc/6J4/XYeCIaQFz/o84lctJb6UyRHK4Q/ofaqYjivwGx2
         rEJUjwyw78KFcUdaBLYmJH3HIdRS5spJ7SevPcJ6VRNm0giGf3Rfe5wO5af/yOXsKDqn
         RXvBaMfYOhaIxw+bKv5Yr4Tw0wuW4rzlyBqYV+kN0mRO/jPl9F/ohLxEsPRCMGTj9bXG
         3Qiw==
X-Forwarded-Encrypted: i=1; AJvYcCWZh4pGTH8iNctYzKk0raSXd3OrEQaM1VaOkVe0KNKjFHhpsKQFApcjm33LBqVFkZxNwQ3L6/G86Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yws0Ikv08OeXlZJ5EDXECNHwCYtmkUsAE1HZotULa0Bf0nes8SW
	kf6rOX6G0YbeSjV2PQVumGUPWWCA9HmOmNSZ2gqB6Sq8nBse4jovWMy+QfMJuxLWBvI=
X-Gm-Gg: AY/fxX72vDGWCFGlUVS3+sqGO0xh7zmjYmuqyvYEmRpBCN4jDa3DRYDh+7DZxUQ/LLd
	xra/q1/9/+SWgIBA0f0Ur9+LEYNjrSULILcCkqi8uySXyC2F3D/L4b+cskAwsqRChli+HY6QyFh
	f0Rvcqi4ZwIqEVTJL9ZKt8rY/mFLYjJdnwaAdLF7Tnz66fOpJveXwMftuoL4iZ7lAX7lGNNF0sk
	kZjrCgvwE3lTFcCpLvC1Zlc60nOmV2MD9YVpYzienuGhAzNgdag2rokORk3Agexb+WMoQsM91t9
	f0x6fZnlep/HTLC7RdmRpLGAnAjQy7yidaUt1DH4KB8t2/C1e2BrPvxr5sjyE6rz0g3hYE2uge8
	hIgxN5qHFHB8Vp0u4TW3BQOTyjH9toKljDgHT8Sedje15C58jjznYN6k3b/U3epECYYuAJGGTxc
	g05QIibRmcZ5w9Mt/orK83weZGzSJOfxYPx/olrizpU75HimEud+/RaLJEfpp6z7YLQQ7O7du7n
	w==
X-Google-Smtp-Source: AGHT+IFhT0L9Yos/FkI4ypxCe5qVkD3DyBkBB6r3+dZBYdb9FG31rGl9rJh2bWRCEa5u32hBtjCnmQ==
X-Received: by 2002:a05:600c:4449:b0:477:aed0:f401 with SMTP id 5b1f17b1804b1-47d84b368f6mr123528825e9.23.1767983976877;
        Fri, 09 Jan 2026 10:39:36 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47d87167832sm72118585e9.7.2026.01.09.10.39.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 10:39:36 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 9/9] multipath-tools: compile with -fno-strict-aliasing
Date: Fri,  9 Jan 2026 19:39:07 +0100
Message-ID: <20260109183907.201250-10-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109183907.201250-1-mwilck@suse.com>
References: <20260109183907.201250-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

multipath-tools uses container_of() and similar macros, which imply
casts between different types, which isn't stricly compliant with
strict aliasing rules. The issue that lead to the previous commit
"libmpathutil: use union for bitfield" was one example where this
can fail. While that one could be fixed relatively easily, it shows
that surprises can happen any time when we compile our code with
strict aliasing enabled. This can be seen clearly when we compile
with "-fstrict-aliasing -Wstrict-aliasing=1" (note that the bitfield
problem is only reported by gcc with "-Wstrict-aliasing=1", other
levels of aliasing detection miss it with gcc 15).

Use -fno-strict-aliasing to disable it. The kernel does the same.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 3dbcdcf..539415d 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -122,7 +122,7 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) $(D_CMOCKA_VERSION) \
 		   -DWSTRINGOP_TRUNCATION=$(if $(WSTRINGOP_TRUNCATION),1,0) \
 		   -MMD -MP
 CFLAGS		:= -std=$(C_STD) $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
-		   -fexceptions
+		   -fexceptions -fno-strict-aliasing
 BIN_CFLAGS	:= -fPIE -DPIE
 LIB_CFLAGS	:= -fPIC
 SHARED_FLAGS	:= -shared
-- 
2.52.0

