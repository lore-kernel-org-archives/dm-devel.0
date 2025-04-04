Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749211DB363
	for <dm-devel@lists.linux.dev>; Fri,  4 Apr 2025 12:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743769778; cv=none; b=bktED53JlXopoJSLKJQtgKehQ7mV8pMziXr+FVRwHwr3d67ZfxIvm6B1eUEFJ3tKNfFUTsIR5+OfCfH1r7I9alt2ROY5OGe7PLTKngujXr+ejjQxhdrCyFv7IBHjZ+muv6byCfL6QdugR9MvTUuWbcGLzpbD2+sde75M0M7D3cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743769778; c=relaxed/simple;
	bh=dxrbthKFHIPl6/54Rh1y0qtM5j/cxxBh+DVW2hE43Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ehAyiXuTKEr44KDxoAOlaNiHtKpdXXMYPdRR+VzTb8uJJDn3eVuYuFNw7VNEzdyMLdaOofF+EPYeeJsi6xrNy4lG0IyKV+rA3nAJiN3H+s0rn1r17tKkdDNBRK2rzxz8UDESKqteyCuCcYhx+Ud+xivLx5dfYGfUOjp1A4jf+/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr; spf=pass smtp.mailfrom=smile.fr; dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b=r7/d584j; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smile.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smile.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smile.fr header.i=@smile.fr header.b="r7/d584j"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43d07ca6a80so10370895e9.1
        for <dm-devel@lists.linux.dev>; Fri, 04 Apr 2025 05:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smile.fr; s=google; t=1743769774; x=1744374574; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxdFazCQVF3favcHUJKzFeRYVWbRNZvb9t6SsFnpvfM=;
        b=r7/d584jWE+XyBoG6coAkrYr05/3UgenGaM+Tu9dPeCPrtptjKWL8fxjbIi3iCqsgm
         Cmv3R8A/lBrcdY4q7mdFLNhPG/olvr2YDXzBF7x5El3y7nd1uW1leYcsk3ZX8shLxBXv
         hBvfj3WS/nXPeIJ6b4VbWFZPqHSnUPzfGvO6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743769774; x=1744374574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gxdFazCQVF3favcHUJKzFeRYVWbRNZvb9t6SsFnpvfM=;
        b=lMWy2r42kWs1Isj/tAXmaGs9TUlqPF7XcKNX6SPdyEfr/DI1aTQ49+uumHd+73p3jN
         dc6gWZcAXkFV5pnsEaXJklW9DPQnewUwL1jCwU4KGGbf5zVaLWaJhoHUPT7oQKhXRZv8
         gjMbf4JVPHpFY41Ps7cbLMJwq27vHCpEN2TOIBuHjuvms6qQWejigvTQQZwEJfCcfAzU
         p90S2L+LTit4gtDBh4AnIY7lxiEV6DPFgvL7wmXe9aftu0ahd2hXkjJEiKn7EjB0RHdb
         bdYl3iPd8bUa3FTl44yUddr7Q7fJ533rM4Vb47+Y+jlSAQdSC+/zYkdhBwFOpgvnAAXt
         1Dxw==
X-Gm-Message-State: AOJu0YzjVIQY/E2mdc+fP4cDs+6S8hfva62ybCCb6lF0nwJwMVFmx7uK
	Td4bWANaEauNyyprKiUBFhQpbLT6ti1FIRzNcXaOl8x4mAsf14OIMcQAbVyXkskn5jX2/vRkVA4
	P
X-Gm-Gg: ASbGncvpl8/amRJ7y+B2JyLxgLcG2hYR43CWmPJrzsViHy+vH89uy7YKsFNxYX9pDaf
	WVnNnY9Jx7WWX7mS0i8YFeH5NAfiLQIEBpj5qiHIhBscS6WmFhMJNrQ58DzDjvVXbD/YzgGB7Pe
	KwPdw+RzRWDnR1XAvzn3QmkpjFIqdqZLmtlhPJCb6AiuNXRnK/mnsEKjCCc+3FmxCsQFhFKFmPC
	iDQEuOvBKei+XZcBbulRxGhpuJh9lkqTUx2Hk7x8vOCAGuvrFJp7pcUbPtPlOl8Uiot2GtpUwx/
	kbjw/v1zC4UzK6SwObsPjGRkjiazY6gKzlzmKBLzcrcy7UiIGkhv4ScfppLMN++KFbB/SiFw7nm
	nJYcojqwUFYqTZqwU1wHX
X-Google-Smtp-Source: AGHT+IGJUM2qhJxJoNe0fm801ImlZxPNv5Y9+OtxKuMLIYwkm1jxprccvTCF5/nG4qRD/oE//Ta+FA==
X-Received: by 2002:a05:600c:4503:b0:43c:fded:9654 with SMTP id 5b1f17b1804b1-43ecf8d2813mr27623765e9.19.1743769774355;
        Fri, 04 Apr 2025 05:29:34 -0700 (PDT)
Received: from FRSMI25-BPYTOP.. (205.226.7.93.rev.sfr.net. [93.7.226.205])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b6a1esm4280356f8f.45.2025.04.04.05.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 05:29:34 -0700 (PDT)
From: Sofiane HAMAM <sofiane.hamam@smile.fr>
To: dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mwilck@suse.com,
	=?UTF-8?q?K=C3=A9l=C3=A9fa=20San=C3=A9?= <kelefa.sane@smile.fr>,
	Yoann Congal <yoann.congal@smile.fr>,
	Sofiane HAMAM <sofiane.hamam@smile.fr>
Subject: [PATCH 2/2] libdmmp/Makefile: Add target docs/man/dmmp_strerror.3 to .PHONY list
Date: Fri,  4 Apr 2025 14:29:02 +0200
Message-ID: <20250404122902.2750036-2-sofiane.hamam@smile.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
References: <20250404122902.2750036-1-sofiane.hamam@smile.fr>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kéléfa Sané <kelefa.sane@smile.fr>

When checking out the git repos, sometimes, target
docs/man/dmmp_strerror.3 is newer that the prerequisite
libdmmp/libdmmp.h this leads to a non reproducible behavior:
Sometimes, the timestamps are updated in the manpages, sometimes not.

Signed-off-by: Yoann Congal <yoann.congal@smile.fr>
Signed-off-by: Sofiane HAMAM <sofiane.hamam@smile.fr>
Signed-off-by: Kelefa Sane <kelefa.sane@smile.fr>
---
 libdmmp/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 7e0e2509..187bcb8c 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -20,7 +20,7 @@ CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden
 LIBDEPS += $(shell $(PKG_CONFIG) --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
 
 all: $(LIBS) doc
-.PHONY:	doc clean install uninstall check speed_test dep_clean
+.PHONY:	doc clean install uninstall check speed_test dep_clean docs/man/dmmp_strerror.3
 
 $(LIBS): $(OBJS)
 	$(Q)$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS)
