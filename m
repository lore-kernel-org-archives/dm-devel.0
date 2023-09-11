Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A15EEB580
	for <dm-devel@archiver.kernel.org>; Mon, 11 Sep 2023 16:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694450398;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GDiUel+3E/JdsoqtQ7ZwjWSRQSJJeYXbOgrLMFN+sfU=;
	b=Cu0rCGLaK17EAOcAap8pmxCBXSUqkcnkB83CaELinT7gzAMtFpfui2GjsCXEE/yFtfRgGj
	DB3bGFmZx9k5sTWbyvPhnTVd3RGX9ZD5PmRm/PNFWjFNFD+qeamjmcmLRYEvbjNTxipcEL
	M7QlmhNSaJoy5O+qduGTd3bO4EUqSjE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-692-yaszy-QxNGexoDUQl0qpNA-1; Mon, 11 Sep 2023 12:39:55 -0400
X-MC-Unique: yaszy-QxNGexoDUQl0qpNA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4B2A381BE83;
	Mon, 11 Sep 2023 16:39:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C11F840C6ECA;
	Mon, 11 Sep 2023 16:39:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 863DA1946A45;
	Mon, 11 Sep 2023 16:39:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6957619465B7
 for <dm-devel@listman.corp.redhat.com>; Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 49D3144069; Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FBCF4407D
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2207A101FAC5
 for <dm-devel@redhat.com>; Mon, 11 Sep 2023 16:39:27 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-vfeLdAbbPVOqKq55UP8uHA-1; Mon,
 11 Sep 2023 12:39:23 -0400
X-MC-Unique: vfeLdAbbPVOqKq55UP8uHA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 6008B1F88C;
 Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 31DFD139CC;
 Mon, 11 Sep 2023 16:39:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id cDGQCrpC/2RzEAAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 11 Sep 2023 16:39:22 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 11 Sep 2023 18:38:39 +0200
Message-ID: <20230911163846.27197-31-mwilck@suse.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v2 30/37] multipath-tools: add compile time
 configuration for "/etc/multipath"
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Instead of hard-conding "/etc/multipath" as the path for the state
files "bindings", "prkeys", and "wwids", make this path configurable
via the "statedir" compile-time option. The default is currently still
/etc, it might change to /var/lib or similar in the future.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc            | 4 +++-
 libmultipath/defaults.h | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 39972d9..96206b2 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -58,6 +58,7 @@ pkgconfdir	:= $(usrlibdir)/pkgconfig
 plugindir       := $(prefix)/$(LIB)/multipath
 configdir       := $(etc_prefix)/etc/multipath/conf.d
 configfile      := $(etc_prefix)/etc/multipath.conf
+statedir        := $(etc_prefix)/etc/multipath
 runtimedir      := $(if $(shell test -L /var/run -o ! -d /var/run && echo 1),/run,/var/run)
 devmapper_incdir := $(or $(shell $(PKG_CONFIG) --variable=includedir devmapper),/usr/include)
 libudev_incdir	:= $(or $(shell $(PKG_CONFIG) --variable=includedir libudev),/usr/include)
@@ -88,7 +89,8 @@ WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implici
 CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
-		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
+		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DSTATE_DIR=\"$(statedir)\" \
+		   -DEXTRAVERSION=\"$(EXTRAVERSION)\" -MMD -MP
 CFLAGS		:= --std=gnu99 $(CFLAGS) $(OPTFLAGS) $(WARNFLAGS) -pipe
 BIN_CFLAGS	:= -fPIE -DPIE
 LIB_CFLAGS	:= -fPIC
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index bc2d638..d01f971 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -66,9 +66,9 @@
 #define MAX_DEV_LOSS_TMO	UINT_MAX
 #define DEFAULT_PIDFILE		RUNTIME_DIR "/multipathd.pid"
 #define DEFAULT_SOCKET		"/org/kernel/linux/storage/multipathd"
-#define DEFAULT_BINDINGS_FILE	"/etc/multipath/bindings"
-#define DEFAULT_WWIDS_FILE	"/etc/multipath/wwids"
-#define DEFAULT_PRKEYS_FILE    "/etc/multipath/prkeys"
+#define DEFAULT_BINDINGS_FILE	STATE_DIR "/bindings"
+#define DEFAULT_WWIDS_FILE	STATE_DIR "/wwids"
+#define DEFAULT_PRKEYS_FILE	STATE_DIR "/prkeys"
 #define MULTIPATH_SHM_BASE	RUNTIME_DIR "/multipath/"
 
 
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

