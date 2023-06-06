Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C660C77B7A
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 17:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686071188;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=YJth4bYgOONinLSPTpi0S13LUYY8CjeA/j+2zuy5GuY=;
	b=hb9A1qcurGyBj+hf0UprjnPZI//xHk3SMqc8MpvqekNLf9nOfuQgpfF9BVwJ3abI8uQCYx
	+sJK7FlMqEwNek0i3qivGBP1P5C6HLuxOjqG4iUUGWGWYfON+j1iEyxZBQPgpktzQLJKpE
	SbhMB9TY4Yvk2behMQhnk5IPTpv+ngc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-P_V3Np4JPn6rSkST1cJo0Q-1; Tue, 06 Jun 2023 13:06:25 -0400
X-MC-Unique: P_V3Np4JPn6rSkST1cJo0Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CD58185A793;
	Tue,  6 Jun 2023 17:06:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4670F9E8B;
	Tue,  6 Jun 2023 17:06:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E2A8B19465BC;
	Tue,  6 Jun 2023 17:06:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0706919465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 17:06:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6432F40336D; Tue,  6 Jun 2023 17:06:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BF6F477F61
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 17:06:09 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EFCF2814243
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 17:06:09 +0000 (UTC)
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-445-hF0OFoyoNeGg9MvLVQ7MFw-1; Tue,
 06 Jun 2023 13:06:07 -0400
X-MC-Unique: hF0OFoyoNeGg9MvLVQ7MFw-1
Received: from authenticated user by stravinsky.debian.org with esmtpsa
 (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
 (Exim 4.94.2) (envelope-from <zeha@debian.org>)
 id 1q6a8D-003eFO-Do; Tue, 06 Jun 2023 17:06:05 +0000
From: Chris Hofstaedtler <zeha@debian.org>
To: dm-devel@redhat.com
Date: Tue,  6 Jun 2023 19:05:32 +0200
Message-Id: <20230606170532.1345-1-zeha@debian.org>
MIME-Version: 1.0
X-Debian-User: zeha
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH] multipath-tools build: rename PKGCONFIG to
 PKG_CONFIG
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Chris Hofstaedtler <zeha@debian.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: debian.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Debian's build system helpers automatically set "PKG_CONFIG" correctly, so it
would be convenient for Debian to use this name instead of "PKGCONFIG".

The majority of projects also seem to call this makefile variable "PKG_CONFIG".

Signed-off-by: Chris Hofstaedtler <zeha@debian.org>
---
 Makefile.inc        | 8 ++++----
 create-config.mk    | 6 +++---
 libdmmp/Makefile    | 4 ++--
 multipathd/Makefile | 2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 2e25d2ea..502cd0f1 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -20,9 +20,9 @@ SCSI_DH_MODULES_PRELOAD :=
 
 EXTRAVERSION := $(shell rev=$$(git rev-parse --short=7 HEAD 2>/dev/null); echo $${rev:+-g$$rev})
 
-# PKGCONFIG must be read from the environment to enable compilation
+# PKG_CONFIG must be read from the environment to enable compilation
 # in Debian multiarch setups
-PKGCONFIG	?= pkg-config
+PKG_CONFIG	?= pkg-config
 
 ifeq ($(TOPDIR),)
 	TOPDIR	= ..
@@ -56,8 +56,8 @@ pkgconfdir	:= $(usrlibdir)/pkgconfig
 plugindir       := $(prefix)/$(LIB)/multipath
 configdir       := $(prefix)/etc/multipath/conf.d
 runtimedir      := $(if $(shell test -L /var/run -o ! -d /var/run && echo 1),/run,/var/run)
-devmapper_incdir := $(or $(shell $(PKGCONFIG) --variable=includedir devmapper),/usr/include)
-libudev_incdir	:= $(or $(shell $(PKGCONFIG) --variable=includedir libudev),/usr/include)
+devmapper_incdir := $(or $(shell $(PKG_CONFIG) --variable=includedir devmapper),/usr/include)
+libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr/include)
 kernel_incdir	:= /usr/include
 
 ifeq ($(V),)
diff --git a/create-config.mk b/create-config.mk
index f128375f..d1255971 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -104,7 +104,7 @@ ifneq ($(call check_var,ELS_DTAG_LNK_INTEGRITY,$(kernel_incdir)/scsi/fc/fc_els.h
 	FPIN_SUPPORT = 1
 endif
 
-libmount_h := $(shell $(PKGCONFIG) --variable=includedir mount)/libmount/libmount.h
+libmount_h := $(shell $(PKG_CONFIG) --variable=includedir mount)/libmount/libmount.h
 ifneq ($(call check_func,mnt_unref_cache,$(libmount_h)),0)
 	DEFINES += LIBMOUNT_HAS_MNT_UNREF_CACHE
 endif
@@ -117,13 +117,13 @@ ifneq ($(call check_file,$(kernel_incdir)/linux/nvme_ioctl.h),0)
 	ANA_SUPPORT := 1
 endif
 
-ENABLE_LIBDMMP := $(call check_cmd,$(PKGCONFIG) --exists json-c)
+ENABLE_LIBDMMP := $(call check_cmd,$(PKG_CONFIG) --exists json-c)
 
 ifeq ($(ENABLE_DMEVENTS_POLL),0)
 	DEFINES += -DNO_DMEVENTS_POLL
 endif
 
-SYSTEMD := $(strip $(or $(shell $(PKGCONFIG) --modversion libsystemd 2>/dev/null | awk '{print $$1}'), \
+SYSTEMD := $(strip $(or $(shell $(PKG_CONFIG) --modversion libsystemd 2>/dev/null | awk '{print $$1}'), \
 			$(shell systemctl --version 2>/dev/null | sed -n 's/systemd \([0-9]*\).*/\1/p')))
 
 
diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 6d28caf9..9ece9528 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -14,10 +14,10 @@ HEADERS := libdmmp/libdmmp.h
 
 OBJS := libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_misc.o
 
-CPPFLAGS += -I$(libdmmpdir) -I$(mpathcmddir) $(shell $(PKGCONFIG) --cflags json-c)
+CPPFLAGS += -I$(libdmmpdir) -I$(mpathcmddir) $(shell $(PKG_CONFIG) --cflags json-c)
 CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden
 
-LIBDEPS += $(shell $(PKGCONFIG) --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
+LIBDEPS += $(shell $(PKG_CONFIG) --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
 
 all: $(LIBS) doc
 .PHONY:	doc clean install uninstall check speed_test dep_clean
diff --git a/multipathd/Makefile b/multipathd/Makefile
index dca8e10b..0d0146c5 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -4,7 +4,7 @@ EXEC := multipathd
 CLI := multipathc
 
 CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathpersistdir) -I$(mpathcmddir) -I$(thirdpartydir) \
-	$(shell $(PKGCONFIG) --modversion liburcu 2>/dev/null | \
+	$(shell $(PKG_CONFIG) --modversion liburcu 2>/dev/null | \
 		awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }') \
 	-DBINDIR='"$(bindir)"' $(SYSTEMD_CPPFLAGS)
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

