Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB2B1E0B9C
	for <dm-devel@lists.linux.dev>; Mon,  3 Feb 2025 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738619031; cv=none; b=a8H8SyAKXEMbiTj+dF/IKRBL7LvFOfP+SJCCpVdnBFgr+z4H6iSAA28fNABIo+csBnbeG2lcyqd9WUTDAj6O2yYjWpFDNyfjkaraZTC9PY3YXBuRY6xMK3Wle+fCzaqku5nY2mIaeaCvuPyGFzaUR4ikvCVOR/ZiMTbx2eONkuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738619031; c=relaxed/simple;
	bh=eOu7bC4QacoY9duaR6xquuWQhLa4yHbhRzP31FCvzB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=rpqTbUB6OxCKkWfjFq23efGYFDZ5qbfGisfTDxOFFLMg4DoDmcPlG4GDUVatliFVuLxagcFZsBmU09uYwwZiGj23x2wM8Yvs08IsNAzZh4CN/GAO3k81+sRLe1t6FNgdUFXtT+AkmkoAIPdXmBQq6X3AFKRuawR42viNp7HQvWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SnIwdXIF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SnIwdXIF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738619028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yQKUMW8io9pjkp1I3/ijKnk1Y6oKn6QQpDt9gm7DWbc=;
	b=SnIwdXIFamwV6PBZUxD2fAPTISQnWB/O/7So1I7VtSLpd0srmWCh2r6avJT5eqSgE3lkuv
	Aq47Vr0qqjCZVNWo1xGsuWJ9jKWSrnAfgKO6FyS77ZKZCclbbTpMiK9qgEI1d/ut3df65d
	UAcxxsGb5qCguVaLcu/D16D6AZWg/QM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-JftbYN8lNC-l0RlyqB6C8A-1; Mon,
 03 Feb 2025 16:43:45 -0500
X-MC-Unique: JftbYN8lNC-l0RlyqB6C8A-1
X-Mimecast-MFC-AGG-ID: JftbYN8lNC-l0RlyqB6C8A
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DB99195608A;
	Mon,  3 Feb 2025 21:43:44 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CE02F30001BE;
	Mon,  3 Feb 2025 21:43:43 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 513Lhgsw503992
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 3 Feb 2025 16:43:42 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 513LhgDY503991;
	Mon, 3 Feb 2025 16:43:42 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>,
        Yaakov Selkowitz <yselkowi@redhat.com>
Subject: [PATCH] multipath-tools: fix compilation with latest userspace-rcu code
Date: Mon,  3 Feb 2025 16:43:42 -0500
Message-ID: <20250203214342.503983-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xKBLxtSwLwQsUEX6q4kP7rS_qwCn9cHolcGT2hJkTps_1738619024
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

starting with version 0.15, userspace-rcu can be compiled with
CONFIG_RCU_USE_ATOMIC_BUILTINS. If it is, then any programs using it
must be compiled with at least the C11 standard. See:
https://github.com/urcu/userspace-rcu/commit/89280d020bf064d1055c360fb9974f128051043f

To deal with this, check if compiling with gnu99 fails, and if so,
switch to using gnu11.

Based-on-patch-by: Yaakov Selkowitz <yselkowi@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile.inc     |  2 +-
 create-config.mk | 13 +++++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/Makefile.inc b/Makefile.inc
index 729618bd..65f6efc8 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -115,7 +115,7 @@ CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(TGTDIR)$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(TGTDIR)$(configfile)\" -DSTATE_DIR=\"$(TGTDIR)$(statedir)\" \
 		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
-CFLAGS		:= -std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
+CFLAGS		:= -std=$(C_STD) $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe \
 		   -fexceptions
 BIN_CFLAGS	:= -fPIE -DPIE
 LIB_CFLAGS	:= -fPIC
diff --git a/create-config.mk b/create-config.mk
index 8bd2c20c..ab163ed1 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -157,6 +157,18 @@ FORTIFY_OPT := $(shell \
 		echo "-D_FORTIFY_SOURCE=2"; \
 	fi)
 
+# Check is you can compile with the urcu.h header, using the C99 standard.
+# If urcu/config-<arch>.h defines CONFIG_RCU_USE_ATOMIC_BUILTINS, then anything
+# including urcu.h must be compiled with at least the C11 standard. See:
+# https://github.com/urcu/userspace-rcu/commit/89280d020bf064d1055c360fb9974f128051043f
+C_STD := $(shell \
+	if printf '$(__HASH__)include <urcu.h>\nint main(void) { return 0; }\n' | $(CC) -o /dev/null -c -xc --std=gnu99 - 2>/dev/null; \
+	then \
+		echo "gnu99"; \
+	else \
+		echo "gnu11"; \
+	fi)
+
 STACKPROT :=
 
 all:	$(TOPDIR)/config.mk
@@ -182,3 +194,4 @@ $(TOPDIR)/config.mk:	$(multipathdir)/autoconfig.h
 	@echo "W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)" >>$@
 	@echo "W_URCU_TYPE_LIMITS := $(call TEST_URCU_TYPE_LIMITS)" >>$@
 	@echo "ENABLE_LIBDMMP := $(ENABLE_LIBDMMP)" >>$@
+	@echo "C_STD := $(C_STD)" >>$@
-- 
2.48.1

