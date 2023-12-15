Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3015848CD9
	for <dm-devel@lists.linux.dev>; Fri, 15 Dec 2023 23:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkqNDY4q"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3364c9ff8e1so919279f8f.0
        for <dm-devel@lists.linux.dev>; Fri, 15 Dec 2023 15:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702683169; x=1703287969; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jQTxPszs4sFQZe8QwDixUbMnrrGYNJXEJcfcNRKzgIw=;
        b=GkqNDY4qrx2SSNYT6VuZbY1wEU8eHo4M5279PvXktLsBoYXCOlcvi4XoGGIpv4msGu
         4bzVmkao3kQUzByKjp/Fn40NGdl/odaOL7OViEN8ko4VLrtCubYjzt33UZuK+g9WruqE
         xk9vG/ZXJZwy+MlroN63SawOptn5uVD2YjTci5R6NT8xTJQBrMlSwi5pIuL0JFeJMIeQ
         j9fhUQOg/AFtky7sJJ+LrCfqPXizMJjCQMKgXB67ucyumcawtuNk61hkxEN81GfgTWkE
         n7+5D/f13DdrJqh1nxZZ5WtA2P440bjLlj2MmeMEallLMYcBlX0e7eOYovJAYtoZrsn8
         L6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702683169; x=1703287969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQTxPszs4sFQZe8QwDixUbMnrrGYNJXEJcfcNRKzgIw=;
        b=kpfgPTy7jXRJYGOpbMOpxiNg6Bms5K2vkkUis2YdbBC6p0tbnGAG0iHbrJwRnR7pte
         gYTwiuFr6o0/ptqV0Zmvk4QjQDJxfTlP+F40/bfhuNHBZFew5+riIrsR9VPhlVjdMItr
         h6ub8Immv1DwvdKMz1e3dX/vb8D767F9BmCgIJOqRzlTJLqe8MUvNRSlWtWp1A/aGM3c
         udPi/beHOTLNvPRC5Zb+xbRMkB4x05vuKsmMfT/sY+4nZry/ImLHWtNQ9HHagAkha4sz
         lDc/qatwixBWMxodjuRWemO1rP0m4376JuioxHX3qj2pHOm4RriuZui+ufVbXjqCXchV
         g3mA==
X-Gm-Message-State: AOJu0YwCBwiEUW4O+9tG/S7WOcSg1ZX/D8jL7i/sh4+m+/Uth8P+ApFb
	OJXpW72/m1VXxvQLe57nlg==
X-Google-Smtp-Source: AGHT+IFqpBxw5eVaZYfRB+M4F8T/d7BGu3mDM4xv6fbeG+/yDVhYqfBkD5z3Mj2Clv+MuNN59RAbWA==
X-Received: by 2002:a5d:60c3:0:b0:336:595d:d20a with SMTP id x3-20020a5d60c3000000b00336595dd20amr672343wrt.34.1702683169118;
        Fri, 15 Dec 2023 15:32:49 -0800 (PST)
Received: from localhost (166.red-81-44-143.dynamicip.rima-tde.net. [81.44.143.166])
        by smtp.gmail.com with ESMTPSA id q3-20020a5d5743000000b003365bd008a1sm1080778wrw.71.2023.12.15.15.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 15:32:48 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM-DEVEL ML <dm-devel@lists.linux.dev>
Subject: [PATCH] multipath-tools: update ml
Date: Sat, 16 Dec 2023 00:32:46 +0100
Message-ID: <20231215233247.48078-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libdmmp/docs/man/libdmmp.h.3 | 2 +-
 libmultipath/hwtable.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libdmmp/docs/man/libdmmp.h.3 b/libdmmp/docs/man/libdmmp.h.3
index 45d5be3e..7c57041d 100644
--- a/libdmmp/docs/man/libdmmp.h.3
+++ b/libdmmp/docs/man/libdmmp.h.3
@@ -110,4 +110,4 @@ below in case you want to create your own log handler.
 GPLv2+
 
 .SH "BUG"
-Please report bug to <dm-devel@redhat.com>
+Please report bug to <dm-devel@lists.linux.dev>
diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index ae6aac79..808af544 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -11,7 +11,7 @@
 
 /*
  * Tuning suggestions on these parameters should go to
- * dm-devel@redhat.com (subscribers-only, see README)
+ * <dm-devel@lists.linux.dev> (see README.md)
  *
  * You are welcome to claim maintainership over a controller
  * family. Please mail the currently enlisted maintainer and
-- 
2.43.0

