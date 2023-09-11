Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC72FEEB58F
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450395;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2Kd2HuqH76UMYRQH2gn84U4jhVE6Z7VCmB7FHrynx2k=;
	b=DbwefPnaF0GrZR9nKXKZ61cmRVDZxCsJrXvfAmDynH4uTS9POsB2Ryfnghbn+ybSW5PKKg
	LfwldDZIXnH5AbazEH3sJ/7yNx2h4eLMCVT0anfMwiQ2mGgaZxFUfa05cAsebF8R2s0L6o
	p/HPhLISxYqHaZbpU/Y7qhL/GfS0YBU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-17-rA3XJyLDNfayeAIZ78ZuxA-1; Mon, 11 Sep 2023 12:39:51 -0400
X-MC-Unique: rA3XJyLDNfayeAIZ78ZuxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78226101FACF;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 60B7E40C200B;
	Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA42D1946A44;
	Mon, 11 Sep 2023 16:39:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5DCAC19465A3
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4CE362024CD5; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4512820268C8
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2788929DD993
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:25 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-a1BVh0ySPoqUvSl69uusIQ-1; Mon,
 11 Sep 2023 12:39:23 -0400
X-MC-Unique: a1BVh0ySPoqUvSl69uusIQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 26EBA21882;
 Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ECCCD139CC;
 Mon, 11 Sep 2023 16:39:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id cGsZOLlC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:21 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:38 +0200
Message-ID: <20230911163846.27197-30-mwilck@suse.com>
In-Reply-To: <20230911163846.27197-1-mwilck@suse.com>
References: <20230911163846.27197-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 29/37] multipath-tools Makefile: sanitize
 paths for configuration files
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
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Make the path to multipath.conf configurable, and use the same prefix
by default for multipath.conf and multipath/conf.d. For "usr-merged"
distributions with immutable /usr, we'll want to have the configuration
under a different prefix. This can be achieved by using e.g.

    make prefix=/usr etc_prefix=""

Note that with prefix=/usr, before this patch the code would use
/usr/etc/multipath/conf.d, but /etc/multipath.conf. If this (rather
inconsistent) behavior is desired, use the following command line:

    make prefix=/usr configfile=/etc/multipath.conf
---
 Makefile.inc            | 9 ++++++---
 libmultipath/defaults.h | 1 -
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 502cd0f..39972d9 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -37,6 +37,8 @@ prefix		:=
 exec_prefix	:= $(prefix)
 # Prefix for non-essential libraries (libdmmp)
 usr_prefix	:= $(prefix)
+# Prefix for configfuration files (multipath.conf)
+etc_prefix	:= $(prefix)
 # Where to install systemd-related files. systemd is usually installed under /usr
 # Note: some systemd installations use separate "prefix" and "rootprefix".
 # In this case, override only unitdir to use systemd's "rootprefix" instead of $(systemd_prefix)
@@ -54,7 +56,8 @@ usrlibdir	:= $(usr_prefix)/$(LIB)
 includedir	:= $(usr_prefix)/include
 pkgconfdir	:= $(usrlibdir)/pkgconfig
 plugindir       := $(prefix)/$(LIB)/multipath
-configdir       := $(prefix)/etc/multipath/conf.d
+configdir       := $(etc_prefix)/etc/multipath/conf.d
+configfile      := $(etc_prefix)/etc/multipath.conf
 runtimedir      := $(if $(shell test -L /var/run -o ! -d /var/run && echo 1),/run,/var/run)
 devmapper_incdir := $(or $(shell $(PKG_CONFIG) --variable=includedir devmapper),/usr/include)
 libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr/include)
@@ -84,8 +87,8 @@ WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implici
 		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
 CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" \
-		   -DRUNTIME_DIR=\"$(runtimedir)\" \
-		   -DCONFIG_DIR=\"$(configdir)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
+		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
+		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
 CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
 BIN_CFLAGS	:= -fPIE -DPIE
 LIB_CFLAGS	:= -fPIC
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index b3f11d4..bc2d638 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -66,7 +66,6 @@
 #define MAX_DEV_LOSS_TMO	UINT_MAX
 #define DEFAULT_PIDFILE		RUNTIME_DIR "/multipathd.pid"
 #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
-#define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
 #define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
 #define DEFAULT_PRKEYS_FILE    "/etc/multipath/prkeys"
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

