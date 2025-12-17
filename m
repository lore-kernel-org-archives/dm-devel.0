Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C992ED853
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006508; cv=none; b=MH0FAqSQXp84w0jDuYZQkGjZXw4UBG1MwIzKZgyFbx7aiYGWUqahQUqbr2eenhRA6WnIa13eybIyAtacglOfb44PYxXfv6C5LGP9WVO+RrAoD60+2BN3YDTKMcb9q0aeD0V5CzTMJyJYzwnI3H98Bade355cKxbp/fOuGoi3tyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006508; c=relaxed/simple;
	bh=QeYj7jcTxKdw7TUm5dvHQ0zVYNhDFSbt/VAmQopC66o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKMuaxNuPK3tR8Ufm4h3rhZRYtpFXR0Nz9PNY2Z5l91ffYlcO5WnFQqOOXtNBriY+jW8taeSOaqjEsPgNtTjRJLiG8DgjU5zFnBbEETCPthbnbFSjIDc7VaDUDShzNx0OlDfJ4a63l2t80zcIZZ6FiwBab9IEgojalX5LLBrxcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V3Mp/CiD; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V3Mp/CiD"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b736ffc531fso1199729966b.1
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006504; x=1766611304; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=In5Pk2g0CKXOE9IcPR47So+p74S4udsXY8aw/HILXn8=;
        b=V3Mp/CiDtaAZOlKUbg0qg8NX/WG61P32jfKxjNdtbW6uCuanuSNbKNZ43njGYUyoCS
         nf73ahkq8EumGSU9W3RRtJ6ohtystor1LO2PYwlDrLoJiD7UYcn987fo9e6Op5jYWRvD
         KXcDaTDG6Yvj/UAp7QIv7gjAeWigv48jb1Qr9mFiyEluG14KYVsRjqXE1gPRDFWc/hZH
         LXCd+ieOgBsLeC0BpiLioxGrHpd0NCClUyCe0sIhSGOghU0bpQjLr/vUf6Bato/rJ1/U
         s1kCcr7CZjRUHGWQE7ZtV5e3GUDSUMH7z4BrxtdonqR3R+cIhWvoAiyEX8Qr0H5w/OVo
         tJeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006504; x=1766611304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=In5Pk2g0CKXOE9IcPR47So+p74S4udsXY8aw/HILXn8=;
        b=XKQHs2cwNl8FP0N7SGYKAtOBwnDhH9SSlWUMlhPccT9KGVOJcYc2efBlPjIzw+q1J0
         SL8NqjRUcHE+hyrT7v+fW02R05mxnTLNjS+7UOcFT+Sv6Gtgh2/g4ughdZYiPJVV+TWp
         ETubNKMXyfCUqnHsl2ZWozt2bpnZwshrBq9MDZR5raAFaY8zWqTDDUrgEsyQC3lnXq5D
         brXEKOPdmx58b/zxLiWIMBv0mgOFlKUcPPYoRGpWkfgTDOa5goI1ybpapsZIdgkVUZCD
         8UZqk7xpuY/z2ZGqwVgWIy/Fkpd8W+fgTBFIzE3jf2gCPZz4CuoL5t/gBf5/F/a9q6ij
         7/TQ==
X-Gm-Message-State: AOJu0Yz3Okr9jH8p7b40l/Qg8PZQQq1b52T9Hyz71G/e20KcB+soTsWn
	8zPm7mVWCcQkh0dEoIHriD2WXspPq9lZWNF1Eay7yqDU6uA/nH8fXMdTBErOklHb2vI=
X-Gm-Gg: AY/fxX4c1Jqb6TmaKJNoFa6EfeKAq/55pSv3bHnB+vlQ5Qe3ye9yZKaI0s0E62qXT1a
	WapQ9mU+7wdI4hbhrteyaXc27QvPSr8D1maqG85Zql9wyT/Dulmg4maIEUqE6IHVyJ+PfsTBxwG
	w2xQevMOUOvLVaomD2Lv6bsU66kuIci/WeJscmhNbCGOI2HwKqveDMgYtjvQegAOIK0HYHqsQyp
	WExqkiC+Tr7nOV+vhZ0uGHNpKXdg7oDfdNeF8QXIIHSlNryO/U4lmMS8Rd7Xe1w0Q5Yd1SN+lJE
	01YnoKKoi5T3x3QyUcGUFitJVbbgIMUWh7+rEtsra8h2OCI52vJKGff1/frbyVnhADa2dsl+ino
	kDAsoRhE1tscnOXg42RVGkBDuHND9mefCWyoFoKBgS/36qxN7OgHzI4Wqr0OwZkh8Us/hPzG0pI
	+VB89w6uKoq53UwWPc31q+HM26+YY2dMZelb2GzOfe4uGPdkDOcLrznPHL91OyAzneTE8NgRWv4
	g==
X-Google-Smtp-Source: AGHT+IG1coqdgwM9CvL7IFZQHXbbIo06wTu9G4xaWv97tdppUiOBCj3VfBJuU7+ZKBu4Hs3r41Sl5Q==
X-Received: by 2002:a17:907:d29:b0:b79:f753:6910 with SMTP id a640c23a62f3a-b7d238beb30mr2245008066b.40.1766006504133;
        Wed, 17 Dec 2025 13:21:44 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b80234a2fa2sm27880166b.55.2025.12.17.13.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:43 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 20/21] Makefile: add functionality to determine cmocka version
Date: Wed, 17 Dec 2025 22:21:12 +0100
Message-ID: <20251217212113.234959-21-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251217212113.234959-1-mwilck@suse.com>
References: <20251217212113.234959-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cmocka 2.0.0 introduces a couple of changes that require version-dependent
code to be used. Add macros to determine the cmocka version. If the version
can't be determined, assume 1.1.0.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc     | 2 +-
 create-config.mk | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 9e3dc46..3dbcdcf 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -112,7 +112,7 @@ WARNFLAGS	:= $(WERROR) -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -W$(ERROR)imp
 		  -W$(ERROR)implicit-function-declaration -W$(ERROR)format-security \
 		  $(WNOCLOBBERED) -W$(ERROR)cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
 
-CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
+CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) $(D_CMOCKA_VERSION) \
 		   -D_FILE_OFFSET_BITS=64 \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(TGTDIR)$(plugindir)\" \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
diff --git a/create-config.mk b/create-config.mk
index 3c3ba06..712cef0 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -77,6 +77,10 @@ URCU_VERSION = $(shell \
 	$(PKG_CONFIG) --modversion liburcu 2>/dev/null | \
 			awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }')
 
+CMOCKA_VERSION = $(shell \
+	($(PKG_CONFIG) --modversion cmocka 2>/dev/null || echo "1.1.0" ) | \
+			awk -F. '{ printf("-DCMOCKA_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }')
+
 DEFINES :=
 
 ifneq ($(call check_func,dm_task_no_flush,$(devmapper_incdir)/libdevmapper.h),0)
@@ -185,6 +189,7 @@ $(TOPDIR)/config.mk:	$(multipathdir)/autoconfig.h
 	@echo "FPIN_SUPPORT := $(FPIN_SUPPORT)" >$@
 	@echo "FORTIFY_OPT := $(FORTIFY_OPT)" >>$@
 	@echo "D_URCU_VERSION := $(call URCU_VERSION)" >>$@
+	@echo "D_CMOCKA_VERSION := $(call CMOCKA_VERSION)" >>$@
 	@echo "SYSTEMD := $(SYSTEMD)" >>$@
 	@echo "ANA_SUPPORT := $(ANA_SUPPORT)" >>$@
 	@echo "STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)" >>$@
-- 
2.52.0

