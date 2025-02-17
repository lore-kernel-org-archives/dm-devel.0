Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F157C227BAA
	for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 20:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739822712; cv=none; b=GMe6GfVmSADOKNA8qrIPk30FLj12e2hTOQow0sl3eAMZjYeNZ+HuqDv6dFpgEerW2qIFSdw4k3lfIfIMKwee+8vnmuRXYrxZ7EVW/FR68kWhUdJKS3+wi1xk1kTR6DDb3CTM39LHUFhDN2zHf8/RVEn7e5hQXDTTwjBaKQ2YdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739822712; c=relaxed/simple;
	bh=+Qkry+oK6OIkbsQ5GdK7pFOYbNkZvqDC+QYzATjY2pU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U3FLVr7ImDAlZWqzGHU24lL8m5yir9uPMoJ8aUUWGOS4nqRdnCl1sZ7VjGyoggvop8vYz52cGf1JL0WSBVxQqXQaVpRI56Qilw9L/AzoeqRdXKZ5qrW0g/AYT9bAEpqTgODcolvbLk0mxIcEmmUPl6PWvA0wA/Kj4otJcQGLPwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RDdkBSIa; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RDdkBSIa"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22114b800f7so31143305ad.2
        for <dm-devel@lists.linux.dev>; Mon, 17 Feb 2025 12:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739822710; x=1740427510; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Qkry+oK6OIkbsQ5GdK7pFOYbNkZvqDC+QYzATjY2pU=;
        b=RDdkBSIa6hvTwbODZeMeDUbUQRBYTEi4cz7GBATgms+yFZfuWnZZw5t/8Bj4o+b0MM
         nJogkEPT4ouf5hFnaQsUA3LqaunfrdUhnRnLs2/MCCtRLGAQPgfeoW+watvpJp6QSgSt
         zEGJ4T9S/AmTUzVLdjW2ywdLkeXctKBBPGIoVAD1Zlpsj+QvsPY2vGRISgUBdlt1jMiy
         7H3oq9Re9M/jUpc2HvbzG48C32cUENsvgifRtwwvWgKSL9eDFXCWY900XYExqwOhVTl3
         zPrYl9uMjgRJ9uzwIfezq8WK3J5D3IoR6pOalFnn8JdWF2BJcVmVToi5ksmMM/dGusAv
         g1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739822710; x=1740427510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Qkry+oK6OIkbsQ5GdK7pFOYbNkZvqDC+QYzATjY2pU=;
        b=O4vBvc4UAOlfnAkitgaC4xWx4S0y/34N9jrhW8ECLAfvcZcrgS3uT+7KvE5NRIsTod
         cuofnLuaeJXVRBLopg/0ywa1nAwlIq38nRPPk/Ikv9ivwTOpFwE1sYCq9D2pGGr51b72
         jyWP+OLZ3M681v/qJzMJn04c2WbZoIcAf/2X3bbaLB0d41kslg729NAxb1f3zYhoYf34
         3RmrgrpfPa0yYRD8zR6g3AeOySUKNtdYuB+MIsFBhgkpVNvBzPAaqRPz05gZbdzKywLN
         c72+W7kxlVopUp8ZagtVPXIlGeX2xinfKvxLuJyNK8i05umAhcFTw7G7tYyL3jq4rq2T
         t5fg==
X-Gm-Message-State: AOJu0YxRKaKgAJEnjPrf6FoAuasZ/A3xMp1yZErbSXNYRAZ06zku4RPO
	vPMJk7Gv1uHfvEddEnbvxTZO6kB8JLMmjPGdsnzFVerKtucmjIlXrVn3U+Pp
X-Gm-Gg: ASbGncvolb5R8rUefJPO5r5usjqVI8o/EUAPFyRJHR2QtXSUfI1Jud0R7i0dGfwZ9UP
	M6wP7U6ounY4ecdYDypbxR3LUisYCv9jGkXQ9hJ/c8uqw4OCWucodJ87o134P3PZ9ZnAgG2GzI9
	0pVgoAgWTda3OCoyZU+yky1S/crN9pGvggQ7s1N/M7AdUpwzzBD2RZlTkh1a+5Y39RA8qlK2w9u
	UNdjui5uZCPACaovwgTjeyxQ92ZuIGwOYtFw9uRoJ3UvTLieoyfB3vSdzj8PCsb3Jhk9+aOhWGF
	5ngnVlY=
X-Google-Smtp-Source: AGHT+IHdD8r6da8XQRRmbFU40t3qfhN/IZGvmZOwpehNK3AC9sbXA2v6NSqVcc98qq0RLTKOQ7+eTg==
X-Received: by 2002:a05:6a00:18a4:b0:730:9567:c3d4 with SMTP id d2e1a72fcca58-7326177fc46mr22354556b3a.3.1739822708375;
        Mon, 17 Feb 2025 12:05:08 -0800 (PST)
Received: from apollo.localdomain ([2601:646:8201:fd20::dd76])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7324f22fd95sm7196236b3a.11.2025.02.17.12.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 12:05:07 -0800 (PST)
From: Khem Raj <raj.khem@gmail.com>
To: dm-devel@lists.linux.dev
Cc: Khem Raj <raj.khem@gmail.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] libmpathutils/uxsock.c: Include string.h for memcpy
Date: Mon, 17 Feb 2025 12:05:03 -0800
Message-ID: <20250217200503.4166910-1-raj.khem@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes
uxsock.c:72:2: error: call to undeclared library function 'memcpy' with type 'void *(void *, const void *, unsigned long)'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

Signed-off-by: Khem Raj <raj.khem@gmail.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/uxsock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libmpathutil/uxsock.c b/libmpathutil/uxsock.c
index 2135476d..a474874e 100644
--- a/libmpathutil/uxsock.c
+++ b/libmpathutil/uxsock.c
@@ -8,6 +8,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdarg.h>
+#include <string.h>
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
