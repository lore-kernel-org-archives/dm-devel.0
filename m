Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B95EAEEAA4E
	for <dm-devel@archiver.kernel.org>; Thu, 14 Sep 2023 14:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694703232;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yhsJu3k9rBZ4WFmqbUhG9moC0n1mhUyTkCJqcNWOOU4=;
	b=RXNBUlQz+kpgnFfMQAFsQ+DY97mSsxibUzuZNNM6MpwGTnYBmlKmmFwWReF/czPVftm1FX
	rBG9p1bHaZjZKugm7PbO60MZ4ArskZXxzSnpTXQdtBGALvRVLd7KcnqFD/J7t7nQ3dKp3b
	KluO0qnDtSsWQ11KowQqEzpSmXMtdL8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-Z-_Rvn5eNOK4RUjyCoX0iQ-1; Thu, 14 Sep 2023 10:53:49 -0400
X-MC-Unique: Z-_Rvn5eNOK4RUjyCoX0iQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DA8B185A78E;
	Thu, 14 Sep 2023 14:53:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECA9E1678B;
	Thu, 14 Sep 2023 14:53:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4D81A19466F1;
	Thu, 14 Sep 2023 14:53:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8FFEE19466E7
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Sep 2023 14:53:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 78ADF28AC; Thu, 14 Sep 2023 14:53:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 711947B62
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 14:53:13 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5308A81D88E
 for <dm-devel@redhat.com>; Thu, 14 Sep 2023 14:53:13 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-186-83iudY09OtGOqYO-xqH5dg-1; Thu,
 14 Sep 2023 10:53:09 -0400
X-MC-Unique: 83iudY09OtGOqYO-xqH5dg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 2B3C721862;
 Thu, 14 Sep 2023 14:53:08 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E73F1139DB;
 Thu, 14 Sep 2023 14:53:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id gCa0NlMeA2UHAgAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 14 Sep 2023 14:53:07 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 14 Sep 2023 16:51:31 +0200
Message-ID: <20230914145131.15165-4-mwilck@suse.com>
In-Reply-To: <20230914145131.15165-1-mwilck@suse.com>
References: <20230914145131.15165-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH v3 38/38] libmultipath: avoid -Warray-bounds
 error in uatomic operations
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The use of uatomic_xchg() in alias.c causes a -Warray-bounds error
on distributions using gcc 12, such as Fedora 37. This is a similar
error to 2534c4f ("libmultipath: avoid -Warray-bounds error with gcc
12 and musl libc"). This happens only with liburcu 0.13 and earlier,
and only with certain gcc versions. See liburcu commit 835b9ab
("Fix: x86 and s390 uatomic: __hp() macro warning with gcc 11").

Enhance the fix for 2534c4f by a adding a workaround for uatomic_xchg(),
and introduce the macro URCU_VERSION (originally only used for multipathd)
globally.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile.inc         |  2 +-
 create-config.mk     |  5 +++++
 libmultipath/alias.c |  5 +++--
 libmultipath/lock.h  | 23 ++++++++++++++---------
 multipathd/Makefile  |  2 --
 5 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/Makefile.inc b/Makefile.inc
index 6e384e6..04bfa56 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -95,7 +95,7 @@ OPTFLAGS	:= -O2 -g $(STACKPROT) --param=ssp-buffer-size=4
 WARNFLAGS	:= -Werror -Wall -Wextra -Wformat=2 $(WFORMATOVERFLOW) -Werror=implicit-int \
 		  -Werror=implicit-function-declaration -Werror=format-security \
 		  $(WNOCLOBBERED) -Werror=cast-qual $(ERROR_DISCARDED_QUALIFIERS) $(W_URCU_TYPE_LIMITS)
-CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) \
+CPPFLAGS	:= $(FORTIFY_OPT) $(CPPFLAGS) $(D_URCU_VERSION) \
 		   -DBIN_DIR=\"$(bindir)\" -DMULTIPATH_DIR=\"$(plugindir)\" \
 		   -DRUNTIME_DIR=\"$(runtimedir)\" -DCONFIG_DIR=\"$(configdir)\" \
 		   -DDEFAULT_CONFIGFILE=\"$(configfile)\" -DSTATE_DIR=\"$(statedir)\" \
diff --git a/create-config.mk b/create-config.mk
index d125597..4d318b9 100644
--- a/create-config.mk
+++ b/create-config.mk
@@ -73,6 +73,10 @@ TEST_URCU_TYPE_LIMITS = $(shell \
 		$(CC) -c -Werror=type-limits -o /dev/null -xc - 2>/dev/null  \
 	|| echo -Wno-type-limits )
 
+URCU_VERSION = $(shell \
+	$(PKG_CONFIG) --modversion liburcu 2>/dev/null | \
+			awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }')
+
 DEFINES :=
 
 ifneq ($(call check_func,dm_task_no_flush,$(devmapper_incdir)/libdevmapper.h),0)
@@ -168,6 +172,7 @@ $(TOPDIR)/config.mk:	$(multipathdir)/autoconfig.h
 	@echo creating $@
 	@echo "FPIN_SUPPORT := $(FPIN_SUPPORT)" >$@
 	@echo "FORTIFY_OPT := $(FORTIFY_OPT)" >>$@
+	@echo "D_URCU_VERSION := $(call URCU_VERSION)" >>$@
 	@echo "SYSTEMD := $(SYSTEMD)" >>$@
 	@echo "ANA_SUPPORT := $(ANA_SUPPORT)" >>$@
 	@echo "STACKPROT := $(call TEST_CC_OPTION,-fstack-protector-strong,-fstack-protector)" >>$@
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index e5d3f15..74431f3 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -24,6 +24,7 @@
 #include "devmapper.h"
 #include "strbuf.h"
 #include "time-util.h"
+#include "lock.h"
 
 /*
  * significant parts of this file were taken from iscsi-bindings.c of the
@@ -300,7 +301,7 @@ void handle_bindings_file_inotify(const struct inotify_event *event)
 	pthread_mutex_unlock(&timestamp_mutex);
 
 	if (changed) {
-		uatomic_xchg(&bindings_file_changed, 1);
+		uatomic_xchg_int(&bindings_file_changed, 1);
 		condlog(3, "%s: bindings file must be re-read, new timestamp: %ld.%06ld",
 			__func__, (long)ts.tv_sec, (long)ts.tv_nsec / 1000);
 	} else
@@ -775,7 +776,7 @@ static int _read_bindings_file(const struct config *conf, Bindings *bindings,
 	int rc = 0, ret, fd;
 	FILE *file;
 	struct stat st;
-	int has_changed = uatomic_xchg(&bindings_file_changed, 0);
+	int has_changed = uatomic_xchg_int(&bindings_file_changed, 0);
 
 	if (!force) {
 		if (!has_changed) {
diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index 9814be7..ac80d1d 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -13,17 +13,22 @@ struct mutex_lock {
 	int waiters; /* uatomic access only */
 };
 
-#if !defined(__GLIBC__) && defined(__GNUC__) && __GNUC__ == 12
-#pragma GCC diagnostic push
-#pragma GCC diagnostic ignored "-Warray-bounds"
-#endif
-
 static inline void init_lock(struct mutex_lock *a)
 {
 	pthread_mutex_init(&a->mutex, NULL);
 	uatomic_set(&a->waiters, 0);
 }
 
+#if defined(__GNUC__) && __GNUC__ == 12 && URCU_VERSION < 0xe00
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Warray-bounds"
+#endif
+
+static inline int uatomic_xchg_int(int *ptr, int val)
+{
+	return uatomic_xchg(ptr, val);
+}
+
 static inline void lock(struct mutex_lock *a)
 {
 	uatomic_inc(&a->waiters);
@@ -31,6 +36,10 @@ static inline void lock(struct mutex_lock *a)
 	uatomic_dec(&a->waiters);
 }
 
+#if defined(__GNUC__) && __GNUC__ == 12 && URCU_VERSION < 0xe00
+#pragma GCC diagnostic pop
+#endif
+
 static inline int trylock(struct mutex_lock *a)
 {
 	return pthread_mutex_trylock(&a->mutex);
@@ -51,10 +60,6 @@ static inline bool lock_has_waiters(struct mutex_lock *a)
 	return (uatomic_read(&a->waiters) > 0);
 }
 
-#if !defined(__GLIBC__) && defined(__GNUC__) && __GNUC__ == 12
-#pragma GCC diagnostic pop
-#endif
-
 #define lock_cleanup_pop(a) pthread_cleanup_pop(1)
 
 void cleanup_lock (void * data);
diff --git a/multipathd/Makefile b/multipathd/Makefile
index cdba3db..0ba6ecb 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -5,8 +5,6 @@ CLI      := multipathc
 MANPAGES := multipathd.8
 
 CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathpersistdir) -I$(mpathcmddir) -I$(thirdpartydir) \
-	$(shell $(PKG_CONFIG) --modversion liburcu 2>/dev/null | \
-		awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }') \
 	-DBINDIR='"$(bindir)"' $(SYSTEMD_CPPFLAGS)
 
 #
-- 
2.42.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

