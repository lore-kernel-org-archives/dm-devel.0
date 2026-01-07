Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FEE1A3179
	for <dm-devel@lists.linux.dev>; Wed,  7 Jan 2026 20:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767817153; cv=none; b=GfUMgB9RdWMAGoAeAxSBrDcu2JaX8R3S9PIuehFe0SjWFNQZCjIl9ts83e6NlBV9Efc4kOa+WrQofDaNNuQLLmprgrv7hh7nQcTzcgh5d3SBQBJY83QYtBF38DSPk9c7kpG1YxSj3EttaGGSJTm98J8/bzrv0W+VU1ipZEgn9OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767817153; c=relaxed/simple;
	bh=Qs/Coiy2FuRg8ljCnyPFY8H9gpO8uO2ARc/DNHwDJpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdeNZYmndLueeDKRsB3ycUTKt5rMLR8yvgFxvThs6Cqr21FXD0FI1nKhMA9G23euKnl2pWffKizNPL9JZtzSFXxlc9JJHrGpr2sOidFBuyxq+azo5X3iwQjI+TqWOeqfiP7uuXw7V0DryKMj/A5f/HzZPnknL9C3+Sd5Urc4k7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L3VT0ms3; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L3VT0ms3"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so500176566b.2
        for <dm-devel@lists.linux.dev>; Wed, 07 Jan 2026 12:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767817147; x=1768421947; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/Ou9AVL8ZJox+Bs4TRjwXUK7C/dYQY73Xd4bikqT4o=;
        b=L3VT0ms3uDlyUkFO1E02Bz1hWr0Eap/Y9lqWZGhD8aY81IzqNJWESz2pC4Sl0Rsmf6
         0R7+Hq3Kar87Q1AUx1noDmYhKe+N75PGaqd3p4q5BWEJjqldluC2WAQFrecPQ/i1s1TO
         3UjXMcrnRpapr1X+6FTnkw3PzR3watT+ZXjQUa4uK2KzCub+S6Gr4CUlYFOW3YLd6SB3
         JeAq+5ZQvQJcmc549whDbGsu/5TNtdpifxrUT5jVGhCvJ0aEbhWFuuDJ/mvxjgY7axfn
         fxmvDmnZILb5e1oz5xqQjlhgoOc7sJYV/xNIU+o+52BJLPFv19rN5BrutjRhuvnxlK7d
         djbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767817147; x=1768421947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P/Ou9AVL8ZJox+Bs4TRjwXUK7C/dYQY73Xd4bikqT4o=;
        b=tS48Ru/tRcTm7vdHlm5YQ4uRz9Vcqp6jH/ypyINfZ9SlSYOzICIZNPemq0sY/qc+wL
         5LP1/JsdH/qJzkCFPu2z5Y1FdfWc86L+7XIsdEyJeLREQKwfOvxmeyqBOKi4YdKPTmJR
         z+9u5gaC/oNVmZ5gHUSY3LwkryBs/SeSdAhXdmAJTg5riV/OXKzFTugHdZ+VZwtPJUp8
         iQs5lfXkFctihqLqSqZtzwGmBUlVZNOOrDmBFGqqkWPNPs2RyrVnDyOVSzS7s+K8HorC
         w1GWB4pU7vK0kMoVmi2XP0aWOsebv+JPkHNUp26u3NsC+2R/P9tHlQ+QbWOAUUqdyJLN
         2XiQ==
X-Gm-Message-State: AOJu0YxbKWcsOqgVxQVteKutYJtRl3EVuWNMHXpY6tTNqPL6p0qnoabW
	/6kx+oaSY7TihbjOGWtpr+Tx4dQd+rCydfsW4qpn1iVNumSSBZAqC+csmUgwG0ysuNbsvU8OjaD
	Y/j4B
X-Gm-Gg: AY/fxX4LHHSNG30Wpy6Bz7IyRiP2cnrh7/BTk1V+2roRszXn2dYpMOOU0gNTZGfjPmz
	wTMiOHCuLSSmuPyBZ08ID/wRzUJvJpZS+ffn895hgWV7mhgMLr27Sh9Vw1kdvfkz4MP1YjROkF4
	nVEMsWaPNYVb6baU6eh1MSJMFeuAJcSxbgu8yZcGDse/NZN7MzIe7Bbkp9JblozkaE61P9TSs/D
	NtvEMNBa/iFE/CSDLcdWprVksFNDrgvVdPdojJ3sTrQVkTcB91BqToqPMs3FzodIFhdU4vSFsTS
	9c7eXhrk+/DlMWg0SuU+Eg+dL2q11HySirs+GyEffnQFVqQ/SXN/IrexL7OL01frzrjb3NhjIjY
	kBKgMMoDQA+E4pJt+/jcp8YozXmFIwDewNtEfmqj0qdLjzTGSVuaObCauQxyNadSEEzH+WcZh2X
	CXy/sLa29WwJPAIq8lc2V+SClYCIGJh7d1zNQmWFdihYNT4Ve2zqB/VzgTKsUblTZYz/WR+/fJb
	tMMo76aZy18
X-Google-Smtp-Source: AGHT+IHGoCf84ffAUxI30T2J/vz7doe4CIPL1twmBZxuU4orbrw5qCW4CRsyVBRLagQFQW3dYCmFSA==
X-Received: by 2002:a17:907:2daa:b0:b83:972a:cb85 with SMTP id a640c23a62f3a-b8444c99d69mr385416566b.21.1767817146750;
        Wed, 07 Jan 2026 12:19:06 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b842a56c552sm616651566b.68.2026.01.07.12.19.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jan 2026 12:19:06 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: [PATCH v3 25/26] Makefile: add functionality to determine cmocka version
Date: Wed,  7 Jan 2026 21:18:25 +0100
Message-ID: <20260107201826.323977-26-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260107201826.323977-1-mwilck@suse.com>
References: <20260107201826.323977-1-mwilck@suse.com>
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
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
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

