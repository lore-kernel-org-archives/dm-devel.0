Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D1A0C32792
	for <dm-devel@archiver.kernel.org>; Mon, 22 Aug 2022 21:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661203394;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=UO5DRhQbsHMB6GcNhmujcyJaBcUBAcnI7B41E12lNA0=;
	b=EFU81iA31Glq8STF5eYBG7twUEfGkbR1foevGiaA75IcmswFO3OJqRs4y7sFo3byaBzvJF
	oxOlEmSdYuUMEdC3TpYxmMOJVPAT0az/fcrSwed+e9gz4tQ84vq6Jn6SH7aGk9J3FdLXxm
	49twDSgxBOviDLywRckh5RJp2tHkRsY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-Ybcaq5XaOPii7kuqO7OKug-1; Mon, 22 Aug 2022 17:23:11 -0400
X-MC-Unique: Ybcaq5XaOPii7kuqO7OKug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73F8F811767;
	Mon, 22 Aug 2022 21:23:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 148E09458A;
	Mon, 22 Aug 2022 21:23:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00C7C1946A47;
	Mon, 22 Aug 2022 21:23:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4C13C1946A40
 for <dm-devel@listman.corp.redhat.com>; Mon, 22 Aug 2022 21:23:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 29C1E403348; Mon, 22 Aug 2022 21:23:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2594C492C3B
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 21:23:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04E793C02B8E
 for <dm-devel@redhat.com>; Mon, 22 Aug 2022 21:23:07 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-609-CJxtY7tHP1y1hUMdBE848A-1; Mon,
 22 Aug 2022 17:23:05 -0400
X-MC-Unique: CJxtY7tHP1y1hUMdBE848A-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 334925CB3F;
 Mon, 22 Aug 2022 21:23:04 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D093613523;
 Mon, 22 Aug 2022 21:23:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 4Ec4MbfzA2N4DgAAMHmgww
 (envelope-from <mwilck@suse.com>); Mon, 22 Aug 2022 21:23:03 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 22 Aug 2022 23:22:51 +0200
Message-Id: <20220822212251.9230-3-mwilck@suse.com>
In-Reply-To: <20220822212251.9230-1-mwilck@suse.com>
References: <20220822212251.9230-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v3 08/11] libmultipath: split off libmpathutil
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Split libmultipath into two libraries: libmpathutil contains
generic utilities that don't relate to device-mapper or multipath
specifically. libmultipath retains multipath-specific code.

The reason for this change is that we'll create a small client program
that takes over the role of "multipath -k", the interactive client.
This way multipathd doesn't need to link against libreadline any more.
The client only needs functionality from libmpathutil, which doesn't
contain code that isn't compliant with GPL-3.0, and can thus be linked
to libreadline without conflicts.

The new library contains weak implementations of {get,put}_multipath_config,
which are meant to be superseded by libmultipath's implementation.
In the interactive client, these functions aren't needed.

As we now have an ABI between libmpathutil and libmultipath, the ABI
must be extended by adding functions from libmpathutil that are used
internally by libmultipath.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 Makefile                                     |   4 +-
 Makefile.inc                                 |   1 +
 libmpathpersist/Makefile                     |   6 +-
 libmpathutil/Makefile                        |  70 +++++++++++
 {libmultipath => libmpathutil}/debug.c       |   0
 {libmultipath => libmpathutil}/debug.h       |   0
 libmpathutil/globals.c                       |  12 ++
 libmpathutil/globals.h                       |  39 ++++++
 libmpathutil/libmpathutil.version            | 122 +++++++++++++++++++
 {libmultipath => libmpathutil}/log.c         |   0
 {libmultipath => libmpathutil}/log.h         |   0
 {libmultipath => libmpathutil}/log_pthread.c |   0
 {libmultipath => libmpathutil}/log_pthread.h |   0
 {libmultipath => libmpathutil}/parser.c      |   0
 {libmultipath => libmpathutil}/parser.h      |   2 +-
 {libmultipath => libmpathutil}/strbuf.c      |   0
 {libmultipath => libmpathutil}/strbuf.h      |   0
 {libmultipath => libmpathutil}/time-util.c   |   0
 {libmultipath => libmpathutil}/time-util.h   |   0
 {libmultipath => libmpathutil}/util.c        |   0
 {libmultipath => libmpathutil}/util.h        |   0
 {libmultipath => libmpathutil}/uxsock.c      |   0
 {libmultipath => libmpathutil}/uxsock.h      |   0
 {libmultipath => libmpathutil}/vector.c      |   0
 {libmultipath => libmpathutil}/vector.h      |   0
 libmpathvalid/Makefile                       |   6 +-
 libmultipath/Makefile                        |  15 ++-
 libmultipath/checkers/Makefile               |   6 +-
 libmultipath/config.h                        |   3 +-
 libmultipath/foreign/Makefile                |   6 +-
 libmultipath/libmultipath.version            |  41 -------
 libmultipath/prioritizers/Makefile           |   6 +-
 mpathpersist/Makefile                        |   4 +-
 multipath/Makefile                           |   6 +-
 multipathd/Makefile                          |  12 +-
 tests/Makefile                               |  12 +-
 36 files changed, 289 insertions(+), 84 deletions(-)
 create mode 100644 libmpathutil/Makefile
 rename {libmultipath => libmpathutil}/debug.c (100%)
 rename {libmultipath => libmpathutil}/debug.h (100%)
 create mode 100644 libmpathutil/globals.c
 create mode 100644 libmpathutil/globals.h
 create mode 100644 libmpathutil/libmpathutil.version
 rename {libmultipath => libmpathutil}/log.c (100%)
 rename {libmultipath => libmpathutil}/log.h (100%)
 rename {libmultipath => libmpathutil}/log_pthread.c (100%)
 rename {libmultipath => libmpathutil}/log_pthread.h (100%)
 rename {libmultipath => libmpathutil}/parser.c (100%)
 rename {libmultipath => libmpathutil}/parser.h (99%)
 rename {libmultipath => libmpathutil}/strbuf.c (100%)
 rename {libmultipath => libmpathutil}/strbuf.h (100%)
 rename {libmultipath => libmpathutil}/time-util.c (100%)
 rename {libmultipath => libmpathutil}/time-util.h (100%)
 rename {libmultipath => libmpathutil}/util.c (100%)
 rename {libmultipath => libmpathutil}/util.h (100%)
 rename {libmultipath => libmpathutil}/uxsock.c (100%)
 rename {libmultipath => libmpathutil}/uxsock.h (100%)
 rename {libmultipath => libmpathutil}/vector.c (100%)
 rename {libmultipath => libmpathutil}/vector.h (100%)

diff --git a/Makefile b/Makefile
index ffca586..5851149 100644
--- a/Makefile
+++ b/Makefile
@@ -4,6 +4,7 @@
 
 LIB_BUILDDIRS := \
 	libmpathcmd \
+	libmpathutil \
 	libmultipath \
 	libmpathpersist \
 	libmpathvalid
@@ -72,7 +73,8 @@ compile_commands.json: Makefile Makefile.inc $(BUILDDIRS:=/Makefile)
 	$(MAKE) clean
 	bear -- $(MAKE)
 
-libmultipath libdmmp: libmpathcmd
+libmpathutil libdmmp: libmpathcmd
+libmultipath: libmpathutil
 libmpathpersist libmpathvalid multipath multipathd: libmultipath
 libmultipath/prioritizers libmultipath/checkers libmultipath/foreign: libmultipath
 mpathpersist multipathd:  libmpathpersist
diff --git a/Makefile.inc b/Makefile.inc
index 0653d21..58dcba9 100644
--- a/Makefile.inc
+++ b/Makefile.inc
@@ -86,6 +86,7 @@ libudevdir	= $(prefix)/$(SYSTEMDPATH)/udev
 udevrulesdir	= $(libudevdir)/rules.d
 modulesloaddir  = $(prefix)/$(SYSTEMDPATH)/modules-load.d
 multipathdir	= $(TOPDIR)/libmultipath
+mpathutildir	= $(TOPDIR)/libmpathutil
 man8dir		= $(prefix)/usr/share/man/man8
 man5dir		= $(prefix)/usr/share/man/man5
 man3dir		= $(prefix)/usr/share/man/man3
diff --git a/libmpathpersist/Makefile b/libmpathpersist/Makefile
index 9843d96..4e1717e 100644
--- a/libmpathpersist/Makefile
+++ b/libmpathpersist/Makefile
@@ -5,10 +5,10 @@ DEVLIB = libmpathpersist.so
 LIBS = $(DEVLIB).$(SONAME)
 VERSION_SCRIPT:= libmpathpersist.version
 
-CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir)
-LDFLAGS += -L$(multipathdir) -L$(mpathcmddir)
+CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathutildir) -I$(mpathpersistdir) -I$(mpathcmddir)
+LDFLAGS += -L$(multipathdir) -L$(mpathutildir) -L$(mpathcmddir)
 
-LIBDEPS += -lmultipath -lmpathcmd -ldevmapper -lpthread -ldl
+LIBDEPS += -lmultipath -lmpathutil -lmpathcmd -ldevmapper -lpthread -ldl
 
 OBJS = mpath_persist.o mpath_updatepr.o mpath_pr_ioctl.o mpath_persist_int.o
 
diff --git a/libmpathutil/Makefile b/libmpathutil/Makefile
new file mode 100644
index 0000000..fac7276
--- /dev/null
+++ b/libmpathutil/Makefile
@@ -0,0 +1,70 @@
+#
+# Copyright (C) 2003 Christophe Varoqui, <christophe.varoqui@opensvc.com>
+#
+include ../Makefile.inc
+
+SONAME = 0
+DEVLIB = libmpathutil.so
+LIBS = $(DEVLIB).$(SONAME)
+VERSION_SCRIPT := libmpathutil.version
+
+CPPFLAGS += -I. -I$(multipathdir) -I$(mpathcmddir)
+CFLAGS += $(LIB_CFLAGS) -D_GNU_SOURCE
+
+LIBDEPS += -lpthread -ldl -ludev -L$(mpathcmddir) -lmpathcmd
+
+ifdef SYSTEMD
+	CPPFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
+	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
+		LIBDEPS += -lsystemd
+	else
+		LIBDEPS += -lsystemd-daemon
+	endif
+endif
+
+# object files referencing MULTIPATH_DIR or CONFIG_DIR
+# they need to be recompiled for unit tests
+
+# other object files
+OBJS := parser.o vector.o util.o debug.o time-util.o \
+	uxsock.o log_pthread.o log.o strbuf.o globals.o
+
+all:	$(DEVLIB)
+
+make_static = $(shell sed '/^static/!s/^\([a-z]\{1,\} \)/static \1/' <$1 >$2)
+
+$(LIBS): $(OBJS) $(VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
+
+$(DEVLIB): $(LIBS)
+	$(LN) $(LIBS) $@
+
+$(NV_VERSION_SCRIPT):	$(VERSION_SCRIPT)
+	@printf 'NOVERSION {\nglobal:\n' >$@
+	@grep -P '^[ \t]+[a-zA-Z_][a-zA-Z0-9_]*;' $< >>$@
+	@printf 'local:\n\t*;\n};\n' >>$@
+
+$(LIBS:%.so.$(SONAME)=%-nv.so):	$(OBJS) $(NV_VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ \
+		-Wl,--version-script=$(NV_VERSION_SCRIPT) -o $@ $(OBJS) $(LIBDEPS)
+
+abi:    $(LIBS:%.so.$(SONAME)=%-nv.abi)
+
+install: all
+	$(INSTALL_PROGRAM) -d $(DESTDIR)$(syslibdir)
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(libdir)
+	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+
+uninstall:
+	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+
+clean: dep_clean
+	$(RM) core *.a *.o *.so *.so.* *.abi nvme-ioctl.c nvme-ioctl.h $(NV_VERSION_SCRIPT)
+
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmultipath/debug.c b/libmpathutil/debug.c
similarity index 100%
rename from libmultipath/debug.c
rename to libmpathutil/debug.c
diff --git a/libmultipath/debug.h b/libmpathutil/debug.h
similarity index 100%
rename from libmultipath/debug.h
rename to libmpathutil/debug.h
diff --git a/libmpathutil/globals.c b/libmpathutil/globals.c
new file mode 100644
index 0000000..0c9a5ba
--- /dev/null
+++ b/libmpathutil/globals.c
@@ -0,0 +1,12 @@
+#include <stddef.h>
+#include <libudev.h>
+#include "globals.h"
+
+struct udev __attribute__((weak)) *udev;
+struct config __attribute__((weak)) *get_multipath_config(void)
+{
+	return NULL;
+}
+
+void __attribute__((weak)) put_multipath_config(void *p __attribute__((unused)))
+{}
diff --git a/libmpathutil/globals.h b/libmpathutil/globals.h
new file mode 100644
index 0000000..fab507e
--- /dev/null
+++ b/libmpathutil/globals.h
@@ -0,0 +1,39 @@
+#ifndef _GLOBALS_H
+#define _GLOBALS_H
+
+struct config;
+
+/**
+ * extern variable: udev
+ *
+ * A &struct udev instance used by libmultipath. libmultipath expects
+ * a valid, initialized &struct udev in this variable.
+ * An application can define this variable itself, in which case
+ * the applications's instance will take precedence.
+ * The application can initialize and destroy this variable by
+ * calling libmultipath_init() and libmultipath_exit(), respectively,
+ * whether or not it defines the variable itself.
+ * An application can initialize udev with udev_new() before calling
+ * libmultipath_init(), e.g. if it has to make libudev calls before
+ * libmultipath calls. If an application wants to keep using the
+ * udev variable after calling libmultipath_exit(), it should have taken
+ * an additional reference on it beforehand. This is the case e.g.
+ * after initializing udev with udev_new().
+ */
+extern struct udev *udev;
+
+/*
+ * libmultipath provides default implementations of
+ * get_multipath_config() and put_multipath_config().
+ * Applications using these should use init_config(file, NULL)
+ * to load the configuration, rather than load_config(file).
+ * Likewise, uninit_config() should be used for teardown, but
+ * using free_config() for that is supported, too.
+ * Applications can define their own {get,put}_multipath_config()
+ * functions, which override the library-internal ones, but
+ * could still call libmp_{get,put}_multipath_config().
+ */
+void put_multipath_config(void *);
+struct config *get_multipath_config(void);
+
+#endif
diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
new file mode 100644
index 0000000..badeb35
--- /dev/null
+++ b/libmpathutil/libmpathutil.version
@@ -0,0 +1,122 @@
+/*
+ * Copyright (c) 2020 SUSE LLC
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * libmultipath ABI (libmpathutil part)
+ *
+ * libmultipath doesn't have a stable ABI in the usual sense. In particular,
+ * the library does not attempt to ship different versions of the same symbol
+ * for backward compatibility.
+ *
+ * The ABI versioning only serves to avoid linking with a non-matching ABI, to
+ * cut down the set of exported symbols, and to describe it.
+ * The version string is LIBMULTIPATH_$MAJOR.$MINOR.$REL.
+ *
+ * Policy:
+ *
+ * * Bump $MAJOR for incompatible changes, like:
+ *   - symbols removed
+ *   - parameter list or return values changed for existing functions
+ *   - externally visible data structures changed in incompatible ways
+ *     (like offsets of previously existing struct members)
+ *   In this case, the new version doesn't inherit the previous versions,
+ *   because the new library doesn't provide the full previous ABI any more.
+ *   All predecessors are merged into the new version.
+ *
+ * * Bump $MINOR for compatible changes, like adding symbols.
+ *   The new version inherits the previous ones.
+ *
+ * * Bump $REL to describe deviations from upstream, e.g. in
+ *   multipath-tools packages shipped by distributions.
+ *   The new version inherits the previous ones.
+ */
+
+/* symbols referenced by multipath and multipathd */
+LIBMULTIPATH_15.0.0 {
+global:
+	alloc_strvec;
+	append_strbuf_str;
+	cleanup_charp;
+	cleanup_mutex;
+	cleanup_ucharp;
+	close_fd;
+	convert_dev;
+	dlog;
+	fill_strbuf;
+	find_slot;
+	free_scandir_result;
+	free_strvec;
+	get_monotonic_time;
+	get_multipath_config;
+	get_next_string;
+	get_strbuf_len;
+	get_strbuf_str;
+	is_quote;
+	log_thread_reset;
+	log_thread_start;
+	log_thread_stop;
+	logsink;
+	normalize_timespec;
+	print_strbuf;
+	pthread_cond_init_mono;
+	put_multipath_config;
+	recv_packet;
+	reset_strbuf;
+	send_packet;
+	set_max_fds;
+	setup_thread_attr;
+	strchop;
+	strlcpy;
+	timespeccmp;
+	timespecsub;
+	truncate_strbuf;
+	udev;
+	ux_socket_listen;
+	vector_alloc;
+	vector_alloc_slot;
+	vector_del_slot;
+	vector_free;
+	vector_reset;
+	vector_set_slot;
+
+local:
+	*;
+};
+
+/* symbols referenced internally by libmultipath */
+LIBMPATHUTIL_1.0 {
+	alloc_bitfield;
+	__append_strbuf_str;
+	append_strbuf_quoted;
+	basenamecpy;
+	cleanup_free_ptr;
+	devt2devname;
+	filepresent;
+	find_keyword;
+	free_keywords;
+	get_linux_version_code;
+	__get_strbuf_buf;
+	get_word;
+	_install_keyword;
+	install_sublevel;
+	install_sublevel_end;
+	keyword_alloc;
+	libmp_verbosity;
+	_log_bitfield_overflow;
+	log_safe;
+	parse_devt;
+	parse_prkey;
+	process_file;
+	safe_write;
+	set_value;
+	should_exit;
+	snprint_keyword;
+	steal_strbuf_str;
+	strlcat;
+	systemd_service_enabled;
+	validate_config_strvec;
+	vector_find_or_add_slot;
+	vector_insert_slot;
+	vector_move_up;
+	vector_sort;
+};
diff --git a/libmultipath/log.c b/libmpathutil/log.c
similarity index 100%
rename from libmultipath/log.c
rename to libmpathutil/log.c
diff --git a/libmultipath/log.h b/libmpathutil/log.h
similarity index 100%
rename from libmultipath/log.h
rename to libmpathutil/log.h
diff --git a/libmultipath/log_pthread.c b/libmpathutil/log_pthread.c
similarity index 100%
rename from libmultipath/log_pthread.c
rename to libmpathutil/log_pthread.c
diff --git a/libmultipath/log_pthread.h b/libmpathutil/log_pthread.h
similarity index 100%
rename from libmultipath/log_pthread.h
rename to libmpathutil/log_pthread.h
diff --git a/libmultipath/parser.c b/libmpathutil/parser.c
similarity index 100%
rename from libmultipath/parser.c
rename to libmpathutil/parser.c
diff --git a/libmultipath/parser.h b/libmpathutil/parser.h
similarity index 99%
rename from libmultipath/parser.h
rename to libmpathutil/parser.h
index 11ea227..9d9d948 100644
--- a/libmultipath/parser.h
+++ b/libmpathutil/parser.h
@@ -33,8 +33,8 @@
 
 /* local includes */
 #include "vector.h"
-#include "config.h"
 struct strbuf;
+struct config;
 
 /* Global definitions */
 #define EOB  "}"
diff --git a/libmultipath/strbuf.c b/libmpathutil/strbuf.c
similarity index 100%
rename from libmultipath/strbuf.c
rename to libmpathutil/strbuf.c
diff --git a/libmultipath/strbuf.h b/libmpathutil/strbuf.h
similarity index 100%
rename from libmultipath/strbuf.h
rename to libmpathutil/strbuf.h
diff --git a/libmultipath/time-util.c b/libmpathutil/time-util.c
similarity index 100%
rename from libmultipath/time-util.c
rename to libmpathutil/time-util.c
diff --git a/libmultipath/time-util.h b/libmpathutil/time-util.h
similarity index 100%
rename from libmultipath/time-util.h
rename to libmpathutil/time-util.h
diff --git a/libmultipath/util.c b/libmpathutil/util.c
similarity index 100%
rename from libmultipath/util.c
rename to libmpathutil/util.c
diff --git a/libmultipath/util.h b/libmpathutil/util.h
similarity index 100%
rename from libmultipath/util.h
rename to libmpathutil/util.h
diff --git a/libmultipath/uxsock.c b/libmpathutil/uxsock.c
similarity index 100%
rename from libmultipath/uxsock.c
rename to libmpathutil/uxsock.c
diff --git a/libmultipath/uxsock.h b/libmpathutil/uxsock.h
similarity index 100%
rename from libmultipath/uxsock.h
rename to libmpathutil/uxsock.h
diff --git a/libmultipath/vector.c b/libmpathutil/vector.c
similarity index 100%
rename from libmultipath/vector.c
rename to libmpathutil/vector.c
diff --git a/libmultipath/vector.h b/libmpathutil/vector.h
similarity index 100%
rename from libmultipath/vector.h
rename to libmpathutil/vector.h
diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
index 0a51925..5dbfb92 100644
--- a/libmpathvalid/Makefile
+++ b/libmpathvalid/Makefile
@@ -5,11 +5,11 @@ DEVLIB = libmpathvalid.so
 LIBS = $(DEVLIB).$(SONAME)
 VERSION_SCRIPT := libmpathvalid.version
 
-CPPFLAGS += -I$(multipathdir) -I$(mpathcmddir)
+CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathcmddir)
 CFLAGS += $(LIB_CFLAGS)
 
-LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) \
-	   -lmultipath -L$(mpathcmddir) -lmpathcmd -ludev
+LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
+	   -L$(mpathutildir) -lmpathutil -L$(mpathcmddir) -lmpathcmd -ludev
 
 OBJS = mpath_valid.o
 
diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 348af3f..3b60a52 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -8,10 +8,10 @@ DEVLIB = libmultipath.so
 LIBS = $(DEVLIB).$(SONAME)
 VERSION_SCRIPT := libmultipath.version
 
-CPPFLAGS += -I$(mpathcmddir) -I$(nvmedir) -D_GNU_SOURCE
+CPPFLAGS += -I$(mpathutildir) -I$(mpathcmddir) -I$(nvmedir) -D_GNU_SOURCE
 CFLAGS += $(LIB_CFLAGS)
 
-LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathcmddir) -lmpathcmd -lurcu -laio
+LIBDEPS += -lpthread -ldl -ldevmapper -ludev -L$(mpathutildir) -lmpathutil -L$(mpathcmddir) -lmpathcmd -lurcu -laio
 
 ifdef SYSTEMD
 	CPPFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
@@ -56,15 +56,14 @@ OBJS-U := prio.o checkers.o foreign.o config.o
 OBJS-T := $(patsubst %.o,%-test.o,$(OBJS-U))
 
 # other object files
-OBJS-O := parser.o vector.o devmapper.o \
-	hwtable.o blacklist.o util.o dmparser.o \
+OBJS-O := devmapper.o hwtable.o blacklist.o dmparser.o \
 	structs.o discovery.o propsel.o dict.o \
-	pgpolicies.o debug.o defaults.o uevent.o time-util.o \
-	switchgroup.o uxsock.o print.o alias.o log_pthread.o \
-	log.o configure.o structs_vec.o sysfs.o \
+	pgpolicies.o defaults.o uevent.o \
+	switchgroup.o print.o alias.o \
+	configure.o structs_vec.o sysfs.o \
 	lock.o file.o wwids.o prioritizers/alua_rtpg.o prkey.o \
 	io_err_stat.o dm-generic.o generic.o nvme-lib.o \
-	libsg.o valid.o strbuf.o
+	libsg.o valid.o
 
 OBJS := $(OBJS-O) $(OBJS-U)
 
diff --git a/libmultipath/checkers/Makefile b/libmultipath/checkers/Makefile
index 69de1ed..c9a2c4c 100644
--- a/libmultipath/checkers/Makefile
+++ b/libmultipath/checkers/Makefile
@@ -4,10 +4,10 @@
 TOPDIR = ../..
 include ../../Makefile.inc
 
-CPPFLAGS += -I$(multipathdir)
+CPPFLAGS +=  -I$(multipathdir) -I$(mpathutildir)
 CFLAGS += $(LIB_CFLAGS)
-LDFLAGS += -L$(multipathdir)
-LIBDEPS = -lmultipath -laio -lpthread -lrt
+LDFLAGS += -L$(multipathdir) -L$(mpathutildir)
+LIBDEPS = -lmultipath -lmpathutil -laio -lpthread -lrt
 
 # If you add or remove a checker also update multipath/multipath.conf.5
 LIBS= \
diff --git a/libmultipath/config.h b/libmultipath/config.h
index 2d00ad2..8794746 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -6,6 +6,7 @@
 #include <urcu.h>
 #include <inttypes.h>
 #include "byteorder.h"
+#include "globals.h"
 
 #define ORIGIN_DEFAULT 0
 #define ORIGIN_CONFIG  1
@@ -304,9 +305,7 @@ int init_config(const char *file);
 void uninit_config(void);
 
 struct config *libmp_get_multipath_config(void);
-struct config *get_multipath_config(void);
 void libmp_put_multipath_config(void *);
-void put_multipath_config(void *);
 
 int parse_uid_attrs(char *uid_attrs, struct config *conf);
 const char *get_uid_attribute_by_attrs(const struct config *conf,
diff --git a/libmultipath/foreign/Makefile b/libmultipath/foreign/Makefile
index 3d4491a..d0232f2 100644
--- a/libmultipath/foreign/Makefile
+++ b/libmultipath/foreign/Makefile
@@ -4,10 +4,10 @@
 TOPDIR=../..
 include ../../Makefile.inc
 
-CPPFLAGS += -I$(multipathdir) -I$(nvmedir)
+CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(nvmedir)
 CFLAGS += $(LIB_CFLAGS)
-LDFLAGS += -L$(multipathdir)
-LIBDEPS = -lmultipath -ludev -lpthread -lrt
+LDFLAGS += -L$(multipathdir) -L$(mpathutildir)
+LIBDEPS = -lmultipath -lmpathutil -ludev -lpthread -lrt
 
 LIBS = libforeign-nvme.so
 
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index c1d9b15..1cda40b 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -42,8 +42,6 @@ global:
 	alloc_path;
 	alloc_path_layout;
 	alloc_path_with_pathinfo;
-	alloc_strvec;
-	append_strbuf_str;
 	change_foreign;
 	check_alias_settings;
 	check_daemon;
@@ -54,17 +52,11 @@ global:
 	checker_name;
 	checker_state_name;
 	check_foreign;
-	cleanup_charp;
 	cleanup_lock;
-	cleanup_mutex;
-	cleanup_ucharp;
-	close_fd;
 	coalesce_paths;
-	convert_dev;
 	count_active_paths;
 	delete_all_foreign;
 	delete_foreign;
-	dlog;
 	dm_cancel_deferred_remove;
 	dm_enablegroup;
 	dm_fail_path;
@@ -99,7 +91,6 @@ global:
 	find_mpe;
 	find_path_by_dev;
 	find_path_by_devt;
-	find_slot;
 	foreign_multipath_layout;
 	foreign_path_layout;
 	free_config;
@@ -107,16 +98,12 @@ global:
 	free_multipathvec;
 	free_path;
 	free_pathvec;
-	free_strvec;
-	get_monotonic_time;
 	get_multipath_config;
 	get_multipath_layout;
 	get_path_layout;
 	get_pgpolicy_id;
 	get_refwwid;
 	get_state;
-	get_strbuf_len;
-	get_strbuf_str;
 	get_udev_device;
 	get_uid;
 	get_used_hwes;
@@ -129,7 +116,6 @@ global:
 	init_prio;
 	io_err_stat_handle_pathfail;
 	is_path_valid;
-	is_quote;
 	libmp_dm_task_create;
 	libmp_get_version;
 	libmp_get_multipath_config;
@@ -140,12 +126,7 @@ global:
 	libmultipath_exit;
 	libmultipath_init;
 	load_config;
-	log_thread_reset;
-	log_thread_start;
-	log_thread_stop;
-	logsink;
 	need_io_err_check;
-	normalize_timespec;
 	orphan_path;
 	parse_prkey_flags;
 	pathcount;
@@ -156,10 +137,7 @@ global:
 	print_all_paths;
 	print_foreign_topology;
 	_print_multipath_topology;
-	print_strbuf;
-	pthread_cond_init_mono;
 	put_multipath_config;
-	recv_packet;
 	reinstate_paths;
 	remember_wwid;
 	remove_map;
@@ -169,20 +147,16 @@ global:
 	remove_wwid;
 	replace_wwids;
 	reset_checker_classes;
-	reset_strbuf;
 	select_all_tg_pt;
 	select_action;
 	select_find_multipaths_timeout;
 	select_no_path_retry;
 	select_path_group;
 	select_reservation_key;
-	send_packet;
-	set_max_fds;
 	set_no_path_retry;
 	set_path_removed;
 	set_prkey;
 	setup_map;
-	setup_thread_attr;
 	should_multipath;
 	skip_libmp_dm_init;
 	snprint_blacklist_report;
@@ -204,16 +178,11 @@ global:
 	stop_io_err_stat_thread;
 	store_path;
 	store_pathinfo;
-	strchop;
-	strlcpy;
 	sync_map_state;
 	sysfs_get_size;
 	sysfs_is_multipathed;
-	timespeccmp;
-	timespecsub;
 	trigger_path_udev_change;
 	trigger_paths_udev_change;
-	truncate_strbuf;
 	udev;
 	uevent_dispatch;
 	uevent_get_dm_str;
@@ -226,14 +195,7 @@ global:
 	update_multipath_table;
 	update_queue_mode_add_path;
 	update_queue_mode_del_path;
-	ux_socket_listen;
 	valid_alias;
-	vector_alloc;
-	vector_alloc_slot;
-	vector_del_slot;
-	vector_free;
-	vector_reset;
-	vector_set_slot;
 	verify_paths;
 
 	/* checkers */
@@ -242,9 +204,7 @@ global:
 	start_checker_thread;
 
 	/* prioritizers */
-	fill_strbuf;
 	get_asymmetric_access_state;
-	get_next_string;
 	get_prio_timeout;
 	get_target_port_group;
 	get_target_port_group_support;
@@ -262,7 +222,6 @@ global:
 	sysfs_get_asymmetric_access_state;
 
 	/* foreign */
-	free_scandir_result;
 
 local:
 	*;
diff --git a/libmultipath/prioritizers/Makefile b/libmultipath/prioritizers/Makefile
index eb6f03b..400f773 100644
--- a/libmultipath/prioritizers/Makefile
+++ b/libmultipath/prioritizers/Makefile
@@ -5,10 +5,10 @@ TOPDIR=../..
 
 include ../../Makefile.inc
 
-CPPFLAGS += -I$(multipathdir)
+CPPFLAGS += -I$(multipathdir) -I$(mpathutildir)
 CFLAGS += $(LIB_CFLAGS)
-LDFLAGS += -L$(multipathdir)
-LIBDEPS = -lmultipath -lm -lpthread -lrt
+LDFLAGS += -L$(multipathdir) -L$(mpathutildir)
+LIBDEPS = -lmultipath -lmpathutil -lm -lpthread -lrt
 
 # If you add or remove a prioritizer also update multipath/multipath.conf.5
 LIBS = \
diff --git a/mpathpersist/Makefile b/mpathpersist/Makefile
index 2e4d483..2219c86 100644
--- a/mpathpersist/Makefile
+++ b/mpathpersist/Makefile
@@ -1,11 +1,11 @@
 include ../Makefile.inc
 
-CPPFLAGS += -I$(multipathdir) -I$(mpathpersistdir)
+CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathpersistdir)
 CFLAGS += $(BIN_CFLAGS)
 LDFLAGS += $(BIN_LDFLAGS)
 
 LIBDEPS += -L$(mpathpersistdir) -lmpathpersist -L$(multipathdir) -lmultipath \
-	-L$(mpathcmddir) -lmpathcmd -lpthread -ldevmapper -ludev
+	-L$(mpathutildir) -lmpathutil -L$(mpathcmddir) -lmpathcmd -lpthread -ldevmapper -ludev
 
 EXEC = mpathpersist
 
diff --git a/multipath/Makefile b/multipath/Makefile
index bcb0453..46b7553 100644
--- a/multipath/Makefile
+++ b/multipath/Makefile
@@ -3,11 +3,11 @@
 #
 include ../Makefile.inc
 
-CPPFLAGS += -I$(multipathdir) -I$(mpathcmddir)
+CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathcmddir)
 CFLAGS += $(BIN_CFLAGS)
 LDFLAGS += $(BIN_LDFLAGS)
-LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathcmddir) -lmpathcmd \
-	-lpthread -ldevmapper -ldl -ludev
+LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathutildir) -lmpathutil \
+	-L$(mpathcmddir) -lmpathcmd -lpthread -ldevmapper -ldl -ludev
 
 EXEC = multipath
 
diff --git a/multipathd/Makefile b/multipathd/Makefile
index 95acd88..7128510 100644
--- a/multipathd/Makefile
+++ b/multipathd/Makefile
@@ -15,14 +15,16 @@ endif
 #CPPFLAGS += -D_DEBUG_
 #CPPFLAGS += -DLOGDBG
 
-CPPFLAGS += -I$(multipathdir) -I$(mpathpersistdir) -I$(mpathcmddir) -I$(thirdpartydir) \
+CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathpersistdir) -I$(mpathcmddir) -I$(thirdpartydir) \
 	$(shell $(PKGCONFIG) --modversion liburcu 2>/dev/null | \
 		awk -F. '{ printf("-DURCU_VERSION=0x%06x", 256 * ( 256 * $$1 + $$2) + $$3); }')
 CFLAGS += $(BIN_CFLAGS)
 LDFLAGS += $(BIN_LDFLAGS)
+
+CLI_LIBDEPS :=  -L$(mpathutildir) -lmpathutil -L$(mpathcmddir) -lmpathcmd -ludev -ldl -lurcu -lpthread
 LIBDEPS += -L$(multipathdir) -lmultipath -L$(mpathpersistdir) -lmpathpersist \
-	   -L$(mpathcmddir) -lmpathcmd -ludev -ldl -lurcu -lpthread \
-	   -ldevmapper
+	   -ldevmapper $(CLI_LIBDEPS)
+
 
 ifeq ($(READLINE),libedit)
 CPPFLAGS += -DUSE_LIBEDIT
@@ -36,9 +38,9 @@ endif
 ifdef SYSTEMD
 	CPPFLAGS += -DUSE_SYSTEMD=$(SYSTEMD)
 	ifeq ($(shell test $(SYSTEMD) -gt 209 && echo 1), 1)
-		LIBDEPS += -lsystemd
+		CLI_LIBDEPS += -lsystemd
 	else
-		LIBDEPS += -lsystemd-daemon
+		CLI_LIBDEPS += -lsystemd-daemon
 	endif
 endif
 ifeq ($(ENABLE_DMEVENTS_POLL),0)
diff --git a/tests/Makefile b/tests/Makefile
index 95a9990..9866962 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -11,9 +11,9 @@ TEST_MISSING_INITIALIZERS = $(shell \
 	|| echo -Wno-missing-field-initializers)
 W_MISSING_INITIALIZERS := $(call TEST_MISSING_INITIALIZERS)
 
-CPPFLAGS += -I$(multipathdir) -I$(mpathcmddir) -DTESTCONFDIR=\"$(TESTDIR)/conf.d\"
+CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathcmddir) -DTESTCONFDIR=\"$(TESTDIR)/conf.d\"
 CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter $(W_MISSING_INITIALIZERS)
-LIBDEPS += -L. -L$(mpathcmddir) -lmultipath -lmpathcmd -lcmocka
+LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
 	 alias directio valid devt mpathvalid strbuf sysfs
@@ -69,9 +69,9 @@ mpathvalid-test_OBJDEPS := ../libmpathvalid/mpath_valid.o
 ifneq ($(DIO_TEST_DEV),)
 directio-test_LIBDEPS := -laio
 endif
-strbuf-test_OBJDEPS := ../libmultipath/strbuf.o
+strbuf-test_OBJDEPS := ../libmpathutil/strbuf.o
 sysfs-test_TESTDEPS := test-log.o
-sysfs-test_OBJDEPS := ../libmultipath/sysfs.o ../libmultipath/util.o
+sysfs-test_OBJDEPS := ../libmultipath/sysfs.o ../libmpathutil/util.o
 sysfs-test_LIBDEPS := -ludev -lpthread -ldl
 
 %.o: %.c
@@ -83,11 +83,11 @@ lib/libchecktur.so:
 
 %.out:	%-test lib/libchecktur.so
 	@echo == running $< ==
-	@LD_LIBRARY_PATH=.:$(mpathcmddir) ./$< >$@
+	@LD_LIBRARY_PATH=.:$(mpathutildir):$(mpathcmddir) ./$< >$@
 
 %.vgr:  %-test lib/libchecktur.so
 	@echo == running valgrind for $< ==
-	@LD_LIBRARY_PATH=.:$(mpathcmddir) \
+	@LD_LIBRARY_PATH=.:$(mpathutildir):$(mpathcmddir) \
 		valgrind --leak-check=full --error-exitcode=128 ./$< >$@ 2>&1
 
 OBJS = $(TESTS:%=%.o) $(HELPERS)
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

