Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3F93E3D8F
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 23:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773443696; cv=none; b=bad6abb6wA956WAsrPsRgMYu0SgA4xmRTTMLXdWy3eMeKIJwvpb23/2IzKkogLo443rvvhYdssVkW7ltTaMs8xaxLNU+gHMyQfpOyBOQ1/K+xUmsJkrRPRJq7HvvdICnPe5QTzjatW1G0FClFSxf92aU0tcJDGgwMWjrp0rKe88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773443696; c=relaxed/simple;
	bh=Uil74205CwaP20Za/WREdIBKWQZwXoUxTbFt71e1TwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R4LBr6VGQCOLAregE47njHmVBZBIrWCql2UjXsAQsV4isLu0cecOpYEIeIh6YrXxXPcaLhIGS29paKRpYP9l+BCKp7mm608b7A8HybZ9NLTlxbKcq7jQmEcMrbD9R24CNAmXtxBiFtlqM6dOCGJeyuEZPZ3S6nIlRwVMEsBv6Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dd/jbV5M; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dd/jbV5M"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-439b873a54bso252048f8f.2
        for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 16:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773443692; x=1774048492; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0PbbR/VlPL0wMP8uzQWIl825wGwm20CdLkHLtunXySk=;
        b=dd/jbV5MA7Cqc8ArGEvbGNVuM1S7JJJqV/CtmpXszN/XLSgkE6NaGF8H9KTgj4r1I1
         H0+lONa8xCEflm2rSDPxxIhYfSQXIX9yRgokz2l0z+b4QE2N9t/WidCmb99rd54BpViG
         QjS4kIhuwixozce5uwVhQLRsjUG/ZKX7I6sCYSxfnFtvhprGOueChRvR8k0C6eShHnos
         DZtakQRlD32lcQGMaQof9yCDPwa93zyF/zB4RXnhIkYjKrh6Y/tWeIs/E89Mhrw+sYpt
         Fqqmp4xpi8IuGJytmzIJaqz3wp925G5D/F19Im6uNnWFZbOty+lclraUZVAIKQdbWtSG
         q14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773443692; x=1774048492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0PbbR/VlPL0wMP8uzQWIl825wGwm20CdLkHLtunXySk=;
        b=fS1jr8NTdqOskiQHS6PtXa4f87VyccEOSNg4bkWjDGeZpkJFP3x/7C2O/AWCj0lzmg
         too+9ZTw6n3Aw6TWwdnSPKJJdRFkIFiukCl2ThdY7UK/0VwCpyGfqUHmhcufrboS5uOu
         EZxs/JQSSGyBqAjJrz4ka/t2yQjqB65dPr735qtaMuytLEp3Fsit/8K2rD5f8sTuvd5c
         mcID7K/XL+UZQVIZOUPWs6fQMHqdMtnLUy9dTtcE5bbGG12l9lSNL8gQqSturbafobqs
         iwccWYDSMrtQiMxEX9E4FPj0BOeJ55L/P0oGKRkYnWniprXhgfb2iCHIMPG7I2ifyO9D
         6duA==
X-Forwarded-Encrypted: i=1; AJvYcCVreHPqrsiwjQtabRzgxbNFbGi8BDaG1i7WR4I9J+5PwsuXbvavcrpfxjOSMjKZsrc2HiRT6glmog==@lists.linux.dev
X-Gm-Message-State: AOJu0YxyJeTpo33JEGZ3p7OfejRBgPWKFwBQ3jgl0DcG93V0pwGXMeRZ
	fOx+j5yukZN9mYN/CmqYLI1Mh2HRAght6vD5eCpkzb34IYz46yiUR0Y=
X-Gm-Gg: ATEYQzx3FeS2bLjCkDwifp0/vxFcyXBoX4+qnZcMROl/sCbfDDqB8IJ+l4qoUAiMJKE
	+tn0JE3zaDzTpjW1r00qoKmesBBa24FVdsU+u8ahy1dt8MIQkd/ng8BzptzUC9umYD9O8IGDivI
	7HhwKjH5dJcIQghCOsYqtDQdRzOfWEEXtwWjOwFyJXTmTuXFtzY0Z4Mn3HA8wDQ4GCSlxtnzXgA
	c5pIHUamWdc9l+o2u79yMa5aHvW7c8//maw75eUfwKS23BpPW5NLzKJ6ofmCVBzp6yiWF6HBJAN
	k6a+BYs1NoRaYbe/l0F9jbr5G4IjxYMTjFJMJW/kLcLwNnd6NHGaEH2pJHsEg/QgSPDnpAM5hh/
	MmIwWmvUq3UvlCMHilsGqKajQhtAhsFn0YNMJo5WievsfUTfd/SRl2ZGXB013tdjpCYYMlETTRA
	HeihDuYr9rhCjmNCDsOu5P2PFJOaQGEvV0tBTc+P4bbVKilHbh2feyt3Bbow42
X-Received: by 2002:a05:600c:4fcd:b0:485:3bc7:a224 with SMTP id 5b1f17b1804b1-48556715146mr41818095e9.6.1773443692367;
        Fri, 13 Mar 2026 16:14:52 -0700 (PDT)
Received: from localhost (99.red-80-39-36.staticip.rima-tde.net. [80.39.36.99])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe22e9ddsm18778497f8f.37.2026.03.13.16.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 16:14:51 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH 2/2] multipath-tools: move SPDX-License-Identifier to the top of create-config.mk and rules.mk
Date: Sat, 14 Mar 2026 00:14:48 +0100
Message-ID: <20260313231449.79972-2-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260313231449.79972-1-xose.vazquez@gmail.com>
References: <20260313231449.79972-1-xose.vazquez@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

It is not mandatory, but highly recommended for
better consistency and automated license scanning.

Cc: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM_DEVEL-ML <dm-devel@lists.linux.dev>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 create-config.mk | 2 +-
 rules.mk         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/create-config.mk b/create-config.mk
index 712cef05..3f6a2636 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -1,5 +1,5 @@
-# Copyright (c) SUSE LLC
 # SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) SUSE LLC
 
 TOPDIR := .
 CREATE_CONFIG := 1
diff --git a/rules.mk b/rules.mk
index c3a8e7ac..844f0bff 100644
--- a/rules.mk
+++ b/rules.mk
@@ -1,5 +1,5 @@
-# Copyright (c) SUSE LLC
 # SPDX-License-Identifier: GPL-2.0-or-later
+# Copyright (c) SUSE LLC
 
 $(DEVLIB): $(LIBS)
 	$(Q)$(LN) $(LIBS) $@
-- 
2.53.0

