Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA3C3624BD
	for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 11:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768563185; cv=none; b=ixQpvz/zp4VqbkVG6Tdve7g0WKR/R1JwUxCreP6Pw9EOauGG6SAt0HHzAMpqAFZws8rHEKrlA4WZmMNTsLVCf7GzOgyccjvpMnSMD6JfAX0PhCXQ7RpNqTMiMRi/Fe7ciBr+pg5uXNa+CH8jqhZUsa5ArNv/RgXZmAdptt/rrc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768563185; c=relaxed/simple;
	bh=Gyu4zD648BLIPxRo3FVDtCtEoSbqwAbjoP/1wjiF0f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdbeP+22I1QfK8S71lCGlt7inzFp3Zet4r/PnQJV0YeR/ra/zV+O2+/5x5ZX/ctLpZzcwgPhFJ9goPhDgh/4ZeB6/8TNzUGtfAyb8gaz3SzLyjBy2lLtLKzcUNf1BIhenwFvf1XI1lL7s4po2P4bWg38eRhdJUbLPDDYfbiN9A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WQhAi1kO; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WQhAi1kO"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42fb2314f52so993403f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 16 Jan 2026 03:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768563182; x=1769167982; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P8wNt3bCspIJh9eshyqqNBY+45LkNfDF+KUR9SQeEDY=;
        b=WQhAi1kOjGYg0aBPr4IknX3JeI03jZuldUk112dUX2TDQi1D+51tKOJkl+5eHW5ezo
         e8/ftlBWuhzSDg9Or6q9uWmnX213dUETmx2XK99x0GcehidvYdF6sSRKUFR2hNEQOpf0
         uHtIQAQTLYLgj0ri3A3xFHrhmluawB4WepLpycSweKo4XSKlEz70fXcOye+A9VN3GOkC
         BMuSfHbygD5Nuv2oXaeCqZEIa1G5OOWG88WgMOlaugppCzNyLAvM+rccBfkve4+lCDKr
         nhibfDCgHrk2sgfF6E6n+YXPz61jlQAg5Ow3FFED8wXmA2flM8TlVC5p4fw3lH+rXBfd
         O2Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768563182; x=1769167982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P8wNt3bCspIJh9eshyqqNBY+45LkNfDF+KUR9SQeEDY=;
        b=ppK+f8O0tbe6KnZaUj2LZ1OCdHHscI18bZTNWHOvXab1Mu5COeFfgA1NrWuCRp6B8R
         bDqapEsA3wXip34cTC4vxfOpaqfQ0WPF6WKAWnqh7KiQxjQ7xispE7TD7o+Vkp+FJJkT
         356oxf8p+yd4TUeVLSDIzlFC7Gew5MPAOLM0oIQi4u45hvnCj1hobTOa+E1CCms+EQZp
         WK1s2kNabsh2ludeKkiB6eU9D4rxLy+uCey4huU0SEnGk77kVth53uEu8zMSiu1QjT2X
         txsu1wBH8D41TohA8UW7A2yWczeOttH8rO1iK2+fxamEvCWYWgz/CO98v74mRwyWx6+z
         ZGXw==
X-Forwarded-Encrypted: i=1; AJvYcCWaoLe6+Uiw9KywQpsLHpIZiDqVhf2fBAnC8elqrc89SSby8msnKp2rEWsj3W9NxJRdTue4df/sIQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwvoRDhTvJ/hipH/JHKe67FgMisyPKvLiXg8aRXLmPskXYiOppI
	n2v9yFF/oeomC+Z3MNxNA+vrG41AsBRhDJ25O34V0A5Cgs5FyFOCPvdhIgP+iHQPWdc=
X-Gm-Gg: AY/fxX7jvhtoO7PalzjiJNFSoXtB2rjBl4WVFc0h4B6S+jpTagWU3S0n+LnDRUMxw6+
	KgKsG9tLkREiJnJ0rAElAy1Z69sxGYXTQUrEDxkHbp0Kp15nxsfh+SXCtB+Bcqv1LKdQpZ6chR0
	gydpwxOZmfOVqtl8iA5SHuwONvgwdl716wWmfLv8wBUXKpvy7ssXxZUXOmEJR2IKX6eCdTww7Aw
	+1yWJYlwUcwzlo/3GGFJwSQjFaketTvAkzVHFPqrGiqUNjZNXi4oCA11uK01uiHvWikYvSr04Bh
	n9ylGTicnz8fuAtY+Sj+0qJJb1b3RHteI+6qE0hd8jcLtS4chcYfLmLOPLcFdKWYjBAyKsx8yuN
	9iuVSz/fIFHnwL8hez9bmLsKLsr0alywBWkiJzSpvVJWu4oYiepT/xKebKKkvSrsYvsbOFE3res
	+aUyAWDhW1aU/nfoYQmG6DT2wQhqC0DQEyJpE/eDVU3KR2MDTFql7TQ0mWrapuPKgexwvB3ywiX
	A==
X-Received: by 2002:a05:6000:2313:b0:432:5bf9:cf2e with SMTP id ffacd0b85a97d-43569972fa7mr3375649f8f.13.1768563182531;
        Fri, 16 Jan 2026 03:33:02 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4356997e664sm4271433f8f.30.2026.01.16.03.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 03:33:02 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH 3/5] multipathd: fix an uninitialized variable warning
Date: Fri, 16 Jan 2026 12:30:40 +0100
Message-ID: <20260116113042.140719-4-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260116113042.140719-1-mwilck@suse.com>
References: <20260116113042.140719-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This isn't necessary in practice, but it fixes a compile warning.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 356091e..61e0ea3 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3905,7 +3905,7 @@ child (__attribute__((unused)) void *param)
 	int rc;
 	struct config *conf;
 	char *envp;
-	enum daemon_status state;
+	enum daemon_status state = DAEMON_INIT;
 	int exit_code = 1;
 	int fpin_marginal_paths = 0;
 
-- 
2.52.0

