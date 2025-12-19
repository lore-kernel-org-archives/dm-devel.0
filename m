Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BD278C9C
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 14:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766155307; cv=none; b=guR9M07k1YA1sqUOdZ2UMVC3kh0sUxGNkTa83TrbgOtWgRZ6I0c0mhvY0TdbmtpwkgWi/n1aZJ95dCys0VsB1XhwWpP35aCpMWVtDuiB4iFoycjd01psscq7TkpYosxSOslC4tlcYbx7FaKHAcmjIR/6STsAbMQuxuGTnpSvsgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766155307; c=relaxed/simple;
	bh=Qs/Coiy2FuRg8ljCnyPFY8H9gpO8uO2ARc/DNHwDJpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeCIVjkIAT5t5mbPWEXTXW0O73hMPv15kAeT/QI0l4DONjuwU9y09WBNiaAeR++iMzKKXwEEkfvxEOUNQo+WVjhFMLD3eeqKEoDG6U8opATcOmjorpVa0+RSquxfNHCwBN3jE0LIzlUGQmjqVVvAnnDtM8FKB7T1TiSdRfWUB2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AutfG+yf; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AutfG+yf"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b802d5e9f06so205785766b.1
        for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 06:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766155304; x=1766760104; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/Ou9AVL8ZJox+Bs4TRjwXUK7C/dYQY73Xd4bikqT4o=;
        b=AutfG+yfwjIsS0sNtDxQGaNKiG5zBaaTNM2FAIykyzzzD+JhxLazpAZU4olMPuUv1+
         oH9dQPY3j9MqSMfPm7/NIs7MqwaqIUwi/5t3kbZc+1K4AA90Cs2nU1S3HkUnR8NpJRVo
         1mMuWkdJd7wZOINsPYcOU+BmEDJNgFwc3wYdGIY7R0dHUGNADnPNeOwrz4JTkjvg8iwG
         4zm9syAbyBlpSgON4RcjFokoojLVdJQ4++WBkCi9bwOck4Uhkwit3d5Wi6ZpVd0YF3r+
         RW6ic7rDIJYyvF0Y5K8wKtovah2succ/nTiBJlO+yPvKzLfdnOpRpNl/D/c7t2jrERWy
         gpAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766155304; x=1766760104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P/Ou9AVL8ZJox+Bs4TRjwXUK7C/dYQY73Xd4bikqT4o=;
        b=KdCnknMWte6/CcKkfqtLRBYKOmIBTzlbYQd6lKRH7y7dmyo5mnySV6Ym9x92CLW63C
         w3QRN2SHsuGkwUgxGjQ0z+4npyaXi8VnZceYZyQ1++Zt6FZqrDe4FMQ/VHk6T/0NeIr7
         ugmbMEpciZKnKFsTgn8LQjtjWcCZCDzA+NkhZo1rKQyLi3xxVAHdNMGSQq9n31r69VPu
         DgFmqXUCkDrBwW2A7nIaRy+u5lyGPyTdR6+lIi99vqz3aV/AN5USJVIdkhmZeHmSePwR
         nIOTcZgvR7x8qpk+Ye2iPSIDXQSz3BFgkdxo8Pg+G/G41wBmL8Of5QaDc4BufqeL5Ogo
         zKEQ==
X-Gm-Message-State: AOJu0YxWc6aVnj2t5QfsEDOnTplEnIQnuyNxgqw39oG/MhEpTgKF2igz
	teO3XnI0ttEVQqGP82aiOOXqiFcidAYIFFGnNdS7qB+DdXc0tyNFrFwgB1FkyBnGzqo=
X-Gm-Gg: AY/fxX5VV8jllLIQ8T0mUKv4GUJgDfPZHZQ6jceItRBjbjFf69M+opOMK5O8U7CLx8m
	U+UqG+KyyR1+Esrz/296BF/34iyhiPsqu9mdEBg/1o2J9m59B2fmQ2+t1Ihl5gXESheL9YJ/UQg
	358lMA0hpN9n6ZjqrXNOKtHr7CSju6qk/4V7NisYjXzsT7IXSsnGsb9Ecmy+RlKyqZZ7ncifUft
	XqeD19U9qWTm8zLSayCmXY9cvjBhkwjzIWsEQpSUeeIAdp/NZ8N6im3LRrHNt69Mb01TyXaqcca
	NV6yGXvl1d2kHuxxfAgVeQ87DA/SaFXSqo6kk4Vh5GqTOl+GAkTjNenPr6uX94z2eS1rCdDAHSe
	QdhbQWgO4pRKigguLZkgQd0AMCKAHtZ5k1Ji2PaLDNYhg4nq4HlEgDrCLqC2nVxfzr7q42JD2KK
	9MvqtNS0MqhhPKkVT/mlZnunxEuIBkpyn5q+BrHNv8cjWLHRfz2PodNzWDt/71qlGqz2n6nA/5F
	w==
X-Google-Smtp-Source: AGHT+IH/+mJ+WUmmrvs9KuFui6IW6k/DyJe/D2DDL0bC8MMhNEVTl7QU+kkUXjAeq1ZDvUNjf29WlQ==
X-Received: by 2002:a17:907:86a8:b0:b73:544d:ba2e with SMTP id a640c23a62f3a-b8036f62606mr312046266b.25.1766155303932;
        Fri, 19 Dec 2025 06:41:43 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b8037f51144sm245955566b.69.2025.12.19.06.41.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 06:41:43 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 25/26] Makefile: add functionality to determine cmocka version
Date: Fri, 19 Dec 2025 15:41:07 +0100
Message-ID: <20251219144108.237928-26-mwilck@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251219144108.237928-1-mwilck@suse.com>
References: <20251219144108.237928-1-mwilck@suse.com>
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

