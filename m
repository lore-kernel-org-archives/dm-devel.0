Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794574595;
	b=omeH9s7U/xO1+vnzTEnpIWCaqaQfVnXAQmghEccO6lTgSxVAZtS9reOsOana7eEXPr2r
	 rUW3ovo6jKt4U2w40ZavyPMcV8j23j/srW1SzYGzy3t3DfgV8sKuwcM5PiRGKcYDb8QJ5
	 vjn1AbOi+FPa2Oo6D8bQI58MODj7hCZ4gesJBL2JOgC217Asq97QpbiS6y5k0A+Fwuk/Z
	 B5WRnKJZZmWmKTbzY879qr1DWMEj1ozzOO2UWLSjHR3ZBFX8ZdcfYMr7ty5n1Luu01L5f
	 memXTkbl5a2n135ftRrXgu+rHVDEk8HGX+19XtkvP/LPo+nTMPe40rw8DK/QJ7kLRVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794574595;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:X-Patchwork-Bot:Content-Transfer-Encoding;
	bh=qL0x1g6Zh7dZI9DZ72NDtHvjlYsVg0oWUrUG+FeyaIE=;
	b=I0k+2A0fNWb4bqnIDpPZG05gKXqmkoVJcxVuJCmCArm+ud/NleTJDzEo4MTbAAPZaoRD
	 spwl4nvI3mXYEE71E7CBW8X46tRsFaMqAygmpvUU5B5wNYkl8Dygej8NzJIdbGX1+obas
	 aLKdvhxiDPinwKEqFVHl4AMvLcYvYVPAQjvsrfSVMvBiewqxOpgTRvAk92Vf4PCT+p7TP
	 10fMtpwibb+1GY9JvHhliRWxlv0fXho6F3dREjo/YRpcklDnIf3iFCUEX9nrlSg6qzX+w
	 d44otUUmeUVTQ3sg3VThQnnzL8d76WbLHLvSPSXIAve1p+4FTN67RyCrjLhw5e0AwzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PJtCCw9s;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB26606A32D
	for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 12:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFB26606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PJtCCw9s
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-49061a82da0so89912f8f.3
        for <dm-devel@lists.linux.dev>; Fri, 13 Nov 2026 04:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794574593; x=1795179393; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qL0x1g6Zh7dZI9DZ72NDtHvjlYsVg0oWUrUG+FeyaIE=;
        b=PJtCCw9sIsfC6/H2x6v/dZJ5FbpHp1K4EfCChSpZ3bTjHy7E9LM0myHu2LFmKY8Pvk
         zGO1GmDV1j/gki9ZmFf8fr7RLEwYjs9JbXApIaClC9lxlk5TC7sfglIXAW2+TVyDVy3O
         eUxx/XItz6xbJTVqifXEYWrEarnfd9XR7kDpzUNmi3+qxXPy8eoiPSe5MZ3yI8YAaMZK
         20Fl/dZFh3LrO9/1GsDl2/TH8Gu8AeEldGfDnmxRsHPyFoGuF1DWBxpm+LdGq/Z0gyaH
         FFM4d0BfZT6ttEl4+81oV8Us0KtUBvn1jISkf3uW+nbXZvt8hK0dyvPofehxtEXWAc9I
         mJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794574593; x=1795179393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qL0x1g6Zh7dZI9DZ72NDtHvjlYsVg0oWUrUG+FeyaIE=;
        b=wJ9WMscKWlA8XoB+QZmgy4k8ZrbkMThL5tFiCczfn4fkeD7osom5cI8F7Q8crd7dyd
         2ImF0q4Rrk/O/NXBSkUmPKQ4AYwoA2NdxrDZazUImrTVfs1J7VgxYLlyDCu3OfSW8Umj
         VQ9uK78ty98ZEn5YVCpOanMAAtWIxypyW3fEH4D9CHIQgFnee6Cnf1Nm550GmBfRD/UK
         Dd6GzbLOd7xNwX99N+YyxXvcRvH+S1pXQN6bnNkUOZ86C67GdXGT8PuzutH36Wdsn/DK
         d+B0qHehQRpNDxzqZTRU/DstmtF67ZxBV9YQVep3v/OVZzdIOuHHbfYHc61QtpSKoFa9
         9xkg==
X-Forwarded-Encrypted: i=1; AL+hErFYLdfYc/Gi4ikOJY/1OXfjnqMMHAFTtY3o47MHtGI//BK71Med7pCCgMTSVSLgCnG1TH2xSgLicg==@lists.linux.dev
X-Gm-Message-State: APuU4Z/fJ+pKzvUi36DiEg8Ktapb7omUDnOLpMnhudvgRSqaU7oXWeDO
	jv2wEXTsh9xitbfRr1tj0WpzkBZoOW/Hm1R1IpUc7EdaOx7O2KJ7x5s=
X-Gm-Gg: AYBFou0+LlDU1r/drg4KvtJbFEyLr8pTniFajqZIunKs9l1ElPqnZuTOjs2ydTN0EyT
	Y0aDdc69KyI1ZVyUEs3wYHdcImK01xiv9/U8jMwQngo6wHX5vckequ9miCdMtMhQJmE7b9qZ6AK
	aDvnlQiHQ+OewJToN3cotSLwQRN14SfkKNDvIlgnNehYOU1uRu+UXepgCNL59I9gO8nlnEzuoSc
	s0i70Xjy1cVTCMYbGu+IE4AG+P9VBO7FK+4CsxrlgJHz8EUw6pC0Pl8PmbEpAA6ottiCN2wRoBB
	G/52TcT2RxT+4RxsIfftKTqCZme7L1/0kkTym43EqTHhSeatrBvQrjOnmZoAoos+PuAHX7+Ri5m
	PlsIITBrhqVW/vuraaPXaegXNSM1di0SFf46nc3RIwPLCOM+1uJaOX7IeW3lNRN7BMsW/BNxLzf
	vuSA62p9ZYrUXVyQGdASZUrjTjKlyHxeFJYqSCJbTvozE0oViyRrYMQ9P80RNUWMoyB2QGKyTe3
	2fsEsIK8SPALmJthG2mxLqlxFiGX9NmiOWr6ql9joIxTD5Ft8JGWatTTaTOQ83vzN/Bb2A4jrOX
	pWJ5L9vBkQzaDQ4x52jxRgKExtOwuolBq3ZaU51/QLdkPaHZt6pe49V/k9BSTbz+lg==
X-Received: by 2002:a5d:5e03:0:b0:48f:bb47:3d68 with SMTP id ffacd0b85a97d-49c6ec4d9e3mr5718673f8f.1.1794574593273;
        Fri, 13 Nov 2026 04:56:33 -0800 (PST)
Received: from localhost (69.red-80-39-28.staticip.rima-tde.net. [80.39.28.69])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608c5debsm4986027f8f.42.2026.11.13.04.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:56:32 -0800 (PST)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Martin Wilck <mwilck@suse.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>,
	DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: [PATCH RESEND 13/13] multipath-tools: move SPDX-License-Identifier to the top of create-config.mk and rules.mk
Date: Fri, 13 Nov 2026 13:55:45 +0100
Message-ID: <20261113125549.504780-14-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113125549.504780-1-xose.vazquez@gmail.com>
References: <20261113125549.504780-1-xose.vazquez@gmail.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

It is not mandatory, but highly recommended for better consistency
and automated license scanning.

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
index 8a8b01fe..fb665648 100644
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
2.56.1

