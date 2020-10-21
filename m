Return-Path: <SRS0=YCRG=D4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFEAC4363A
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:42:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F381C2417D
	for <dm-devel@archiver.kernel.org>; Wed, 21 Oct 2020 21:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PH9epMnX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F381C2417D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603316519;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FGzlzb0Ed2YKbLJ/M7wPhceFbcVkX/sFkqVRWRRJx1I=;
	b=PH9epMnXwd9YjZXtQaTKe9wdiKhtK7HNl9kYUZpkFzZN5maUNF0nA7XDePtQiC7b5aSbcJ
	KGWezjOYLSotchsGZlh27rNO4dIEFBC1tWy6Z9P6nzU89B8CiS/0Gm+UtShjjUp5KzkoT0
	q/p4DyWwyupZ1liiJSWUZtU8sX8nhd8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-Dlddb1idPFyNgfIBkhD7Mg-1; Wed, 21 Oct 2020 17:41:57 -0400
X-MC-Unique: Dlddb1idPFyNgfIBkhD7Mg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CBE76107AFA5;
	Wed, 21 Oct 2020 21:41:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ADB5E1002C01;
	Wed, 21 Oct 2020 21:41:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8598F8C7DE;
	Wed, 21 Oct 2020 21:41:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09LLdXU7008765 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 21 Oct 2020 17:39:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 207A85B4A1; Wed, 21 Oct 2020 21:39:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 710615B4BC;
	Wed, 21 Oct 2020 21:39:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09LLdS3P028779; 
	Wed, 21 Oct 2020 16:39:28 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09LLdR1M028778;
	Wed, 21 Oct 2020 16:39:27 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 21 Oct 2020 16:39:23 -0500
Message-Id: <1603316366-28735-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
References: <1603316366-28735-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 1/4] multipath: add libmpathvalid library
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This library allows other programs to check if a path should be claimed
by multipath. It exports an init function, that needs to be called
before and after all other library calls, an exit function, that needs
to be called after all library calls, a function to reread the multipath
configuration files, and two more functions.

mpath_get_mode() get the configured find_multipaths mode.
mpath_is_path() returns whether the device is claimed by multipath, and
optionally returns the wwid.  This code works slightly different than
the multipath -c/u code for SMART mode.  Instead of checking all the
existing paths to see if another has the same wwid, it expects the
caller to pass in an array of the already known path wwids, and checks
if the current path matches any of those.

The library also doesn't set up the device-mapper library. It leaves
this up to the caller.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 Makefile                            |   3 +-
 libmpathvalid/Makefile              |  39 ++++++
 libmpathvalid/libmpathvalid.version |  10 ++
 libmpathvalid/mpath_valid.c         | 202 ++++++++++++++++++++++++++++
 libmpathvalid/mpath_valid.h         | 155 +++++++++++++++++++++
 libmultipath/libmultipath.version   |   6 +
 6 files changed, 414 insertions(+), 1 deletion(-)
 create mode 100644 libmpathvalid/Makefile
 create mode 100644 libmpathvalid/libmpathvalid.version
 create mode 100644 libmpathvalid/mpath_valid.c
 create mode 100644 libmpathvalid/mpath_valid.h

diff --git a/Makefile b/Makefile
index 4a3491da..f127ff91 100644
--- a/Makefile
+++ b/Makefile
@@ -9,6 +9,7 @@ BUILDDIRS := \
 	libmultipath/checkers \
 	libmultipath/foreign \
 	libmpathpersist \
+	libmpathvalid \
 	multipath \
 	multipathd \
 	mpathpersist \
@@ -29,7 +30,7 @@ $(BUILDDIRS):
 	$(MAKE) -C $@
 
 libmultipath libdmmp: libmpathcmd
-libmpathpersist multipath multipathd: libmultipath
+libmpathpersist libmpathvalid multipath multipathd: libmultipath
 mpathpersist multipathd:  libmpathpersist
 
 libmultipath/checkers.install \
diff --git a/libmpathvalid/Makefile b/libmpathvalid/Makefile
new file mode 100644
index 00000000..6bea4bcd
--- /dev/null
+++ b/libmpathvalid/Makefile
@@ -0,0 +1,39 @@
+include ../Makefile.inc
+
+SONAME = 0
+DEVLIB = libmpathvalid.so
+LIBS = $(DEVLIB).$(SONAME)
+VERSION_SCRIPT := libmpathvalid.version
+
+CFLAGS += $(LIB_CFLAGS) -I$(multipathdir) -I$(mpathcmddir)
+
+LIBDEPS += -lpthread -ldevmapper -ldl -L$(multipathdir) \
+	   -lmultipath -L$(mpathcmddir) -lmpathcmd -ludev
+
+OBJS = mpath_valid.o
+
+all: $(LIBS)
+
+$(LIBS): $(OBJS) $(VERSION_SCRIPT)
+	$(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ -o $@ $(OBJS) $(LIBDEPS) -Wl,--version-script=libmpathvalid.version
+	$(LN) $(LIBS) $(DEVLIB)
+
+install: $(LIBS)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(syslibdir)
+	$(INSTALL_PROGRAM) -m 755 $(LIBS) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(LN) $(LIBS) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(INSTALL_PROGRAM) -m 755 -d $(DESTDIR)$(includedir)
+	$(INSTALL_PROGRAM) -m 644 mpath_valid.h $(DESTDIR)$(includedir)
+
+uninstall:
+	$(RM) $(DESTDIR)$(syslibdir)/$(LIBS)
+	$(RM) $(DESTDIR)$(syslibdir)/$(DEVLIB)
+	$(RM) $(DESTDIR)$(includedir)/mpath_valid.h
+
+clean: dep_clean
+	$(RM) core *.a *.o *.so *.so.* *.gz
+
+include $(wildcard $(OBJS:.o=.d))
+
+dep_clean:
+	$(RM) $(OBJS:.o=.d)
diff --git a/libmpathvalid/libmpathvalid.version b/libmpathvalid/libmpathvalid.version
new file mode 100644
index 00000000..3bd0d3c5
--- /dev/null
+++ b/libmpathvalid/libmpathvalid.version
@@ -0,0 +1,10 @@
+MPATH_1.0 {
+	global:
+		mpathvalid_init;
+		mpathvalid_reload_config;
+		mpathvalid_exit;
+		mpathvalid_is_path;
+		mpathvalid_get_mode;
+	local:
+		*;
+};
diff --git a/libmpathvalid/mpath_valid.c b/libmpathvalid/mpath_valid.c
new file mode 100644
index 00000000..7073d17d
--- /dev/null
+++ b/libmpathvalid/mpath_valid.c
@@ -0,0 +1,202 @@
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <libdevmapper.h>
+#include <libudev.h>
+#include <errno.h>
+
+#include "devmapper.h"
+#include "structs.h"
+#include "util.h"
+#include "config.h"
+#include "discovery.h"
+#include "wwids.h"
+#include "sysfs.h"
+#include "mpath_cmd.h"
+#include "valid.h"
+#include "mpath_valid.h"
+#include "debug.h"
+
+static unsigned int
+get_conf_mode(struct config *conf)
+{
+	if (conf->find_multipaths == FIND_MULTIPATHS_SMART)
+		return MPATH_SMART;
+	if (conf->find_multipaths == FIND_MULTIPATHS_GREEDY)
+		return MPATH_GREEDY;
+	return MPATH_STRICT;
+}
+
+static void
+set_conf_mode(struct config *conf, unsigned int mode)
+{
+	if (mode == MPATH_SMART)
+		conf->find_multipaths = FIND_MULTIPATHS_SMART;
+	else if (mode == MPATH_GREEDY)
+		conf->find_multipaths = FIND_MULTIPATHS_GREEDY;
+	else
+		conf->find_multipaths = FIND_MULTIPATHS_STRICT;
+}
+
+unsigned int
+mpathvalid_get_mode(void)
+{
+	int mode;
+	struct config *conf;
+
+	conf = get_multipath_config();
+	if (!conf)
+		mode = MPATH_MODE_ERROR;
+	else
+		mode = get_conf_mode(conf);
+	put_multipath_config(conf);
+	return mode;
+}
+
+static int
+convert_result(int result) {
+	switch (result) {
+	case PATH_IS_ERROR:
+		return MPATH_IS_ERROR;
+	case PATH_IS_NOT_VALID:
+		return MPATH_IS_NOT_VALID;
+	case PATH_IS_VALID:
+		return MPATH_IS_VALID;
+	case PATH_IS_VALID_NO_CHECK:
+		return MPATH_IS_VALID_NO_CHECK;
+	case PATH_IS_MAYBE_VALID:
+		return MPATH_IS_MAYBE_VALID;
+	}
+	return MPATH_IS_ERROR;
+}
+
+static void
+set_log_style(int log_style)
+{
+	/*
+	 * convert MPATH_LOG_* to LOGSINK_*
+	 * currently there is no work to do here.
+	 */
+	logsink = log_style;
+}
+
+static int
+load_default_config(int verbosity)
+{
+	/* need to set verbosity here to control logging during init_config() */
+	libmp_verbosity = verbosity;
+	if (init_config(DEFAULT_CONFIGFILE))
+		return -1;
+	/* Need to override verbosity from init_config() */
+	libmp_verbosity = verbosity;
+
+	return 0;
+}
+
+int
+mpathvalid_init(int verbosity, int log_style)
+{
+	unsigned int version[3];
+
+	set_log_style(log_style);
+	if (libmultipath_init())
+		return -1;
+
+	skip_libmp_dm_init();
+	if (load_default_config(verbosity))
+		goto fail;
+
+	if (dm_prereq(version))
+		goto fail_config;
+
+	return 0;
+
+fail_config:
+	uninit_config();
+fail:
+	libmultipath_exit();
+	return -1;
+}
+
+int
+mpathvalid_reload_config(void)
+{
+	uninit_config();
+	return load_default_config(libmp_verbosity);
+}
+
+int
+mpathvalid_exit(void)
+{
+	uninit_config();
+	libmultipath_exit();
+	return 0;
+}
+
+/*
+ * name: name of path to check
+ * mode: mode to use for determination. MPATH_DEFAULT uses configured mode
+ * info: on success, contains the path wwid
+ * paths: array of the returned mpath_info from other claimed paths
+ * nr_paths: the size of the paths array
+ */
+int
+mpathvalid_is_path(const char *name, unsigned int mode, char **wwid,
+	           const char **path_wwids, unsigned int nr_paths)
+{
+	struct config *conf;
+	int find_multipaths_saved, r = MPATH_IS_ERROR;
+	unsigned int i;
+	struct path *pp;
+
+	if (!name || mode >= MPATH_MODE_ERROR)
+		return r;
+	if (nr_paths > 0 && !path_wwids)
+		return r;
+	if (!udev)
+		return r;
+
+	pp = alloc_path();
+	if (!pp)
+		return r;
+
+	if (wwid) {
+		*wwid = (char *)malloc(WWID_SIZE);
+		if (!*wwid)
+			goto out;
+	}
+
+	conf = get_multipath_config();
+	if (!conf)
+		goto out_wwid;
+	find_multipaths_saved = conf->find_multipaths;
+	if (mode != MPATH_DEFAULT)
+		set_conf_mode(conf, mode);
+	r = convert_result(is_path_valid(name, conf, pp, true));
+	conf->find_multipaths = find_multipaths_saved;
+	put_multipath_config(conf);
+
+	if (r == MPATH_IS_MAYBE_VALID) {
+		for (i = 0; i < nr_paths; i++) {
+			if (path_wwids[i] &&
+			    strncmp(path_wwids[i], pp->wwid, WWID_SIZE) == 0) {
+				r = MPATH_IS_VALID;
+				break;
+			}
+		}
+	}
+
+out_wwid:
+	if (wwid) {
+		if (r == MPATH_IS_VALID || r == MPATH_IS_VALID_NO_CHECK ||
+		    r == MPATH_IS_MAYBE_VALID)
+			strlcpy(*wwid, pp->wwid, WWID_SIZE);
+		else {
+			free(*wwid);
+			*wwid = NULL;
+		}
+	}
+out:
+	free_path(pp);
+	return r;
+}
diff --git a/libmpathvalid/mpath_valid.h b/libmpathvalid/mpath_valid.h
new file mode 100644
index 00000000..63de4e1c
--- /dev/null
+++ b/libmpathvalid/mpath_valid.h
@@ -0,0 +1,155 @@
+/*
+ * Copyright (C) 2015 Red Hat, Inc.
+ *
+ * This file is part of the device-mapper multipath userspace tools.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef LIB_MPATH_VALID_H
+#define LIB_MPATH_VALID_H
+
+#ifdef __cpluscplus
+extern "C" {
+#endif
+
+enum mpath_valid_mode {
+	MPATH_DEFAULT,
+	MPATH_STRICT,
+	MPATH_SMART,
+	MPATH_GREEDY,
+	MPATH_MODE_ERROR,
+};
+
+/*
+ * MPATH_IS_VALID_NO_CHECK is used to indicate that it is safe to skip
+ * checks to see if the device has already been released to the system
+ * for use by things other that multipath.
+ * MPATH_IS_MAYBE_VALID is used to indicate that this device would
+ * be a valid multipath path device if another device with the same
+ * wwid existed */
+enum mpath_valid_result {
+	MPATH_IS_ERROR = -1,
+	MPATH_IS_NOT_VALID,
+	MPATH_IS_VALID,
+	MPATH_IS_VALID_NO_CHECK,
+	MPATH_IS_MAYBE_VALID,
+};
+
+enum mpath_valid_log_style {
+	MPATH_LOG_STDERR = -1,		/* log to STDERR */
+	MPATH_LOG_STDERR_TIMESTAMP,	/* log to STDERR, with timestamps */
+	MPATH_LOG_SYSLOG,		/* log to system log */
+};
+
+enum mpath_valid_verbosity {
+	MPATH_LOG_PRIO_NOLOG = -1,	/* log nothing */
+	MPATH_LOG_PRIO_ERR,
+	MPATH_LOG_PRIO_WARN,
+	MPATH_LOG_PRIO_NOTICE,
+	MPATH_LOG_PRIO_INFO,
+	MPATH_LOG_PRIO_DEBUG,
+};
+
+/* Function declarations */
+
+/*
+ * DESCRIPTION:
+ * 	Initialize the device mapper multipath configuration. This
+ * 	function must be invoked before calling any other
+ * 	libmpathvalid functions. Call mpathvalid_exit() to cleanup.
+ * @verbosity: the logging level (mpath_valid_verbosity)
+ * @log_style: the logging style (mpath_valid_log_style)
+ *
+ * RESTRICTIONS:
+ * 	Calling mpathvalid_init() after calling mpathvalid_exit() has no
+ * 	effect.
+ *
+ * RETURNS: 0 = Success, -1 = Failure
+ */
+int mpathvalid_init(int verbosity, int log_style);
+
+
+/*
+ * DESCRIPTION:
+ * 	Reread the multipath configuration files and reinitalize
+ * 	the device mapper multipath configuration. This function can
+ * 	be called as many times as necessary.
+ *
+ * RETURNS: 0 = Success, -1 = Failure
+ */
+int mpathvalid_reload_config(void);
+
+
+/*
+ * DESCRIPTION:
+ * 	Release the device mapper multipath configuration. This
+ * 	function must be called to cleanup resoures allocated by
+ * 	mpathvalid_init(). After calling this function, no futher
+ * 	libmpathvalid functions may be called.
+ *
+ * RETURNS: 0 = Success, -1 = Failure
+ */
+int mpathvalid_exit(void);
+
+/*
+ * DESCRIPTION:
+ * 	Return the configured find_multipaths claim mode, using the
+ * 	configuration from either mpathvalid_init() or
+ * 	mpathvalid_reload_config()
+ *
+ * RETURNS:
+ * 	MPATH_STRICT, MPATH_SMART, MPATH_GREEDY, or MPATH_MODE_ERROR
+ *
+ * 	MPATH_STRICT     = find_multiapths (yes|on|no|off)
+ * 	MPATH_SMART      = find_multipaths smart
+ * 	MPATH_GREEDY     = find_multipaths greedy
+ * 	MPATH_MODE_ERROR = multipath configuration not initialized
+ */
+unsigned int mpathvalid_get_mode(void);
+/*
+ * DESCRIPTION:
+ * 	Return whether device-mapper multipath claims a path device,
+ * 	using the configuration read from either mpathvalid_init() or
+ * 	mpathvalid_reload_config(). If the device is either claimed or
+ * 	potentially claimed (MPATH_IS_VALID, MPATH_IS_VALID_NO_CHECK,
+ * 	or MPATH_IS_MAYBE_VALID) and wwid is not NULL, then *wiid will
+ * 	be set to point to the wwid of device. If set, *wwid must be
+ * 	freed by the caller. path_wwids is an obptional parameter that
+ * 	points to an array of wwids, that were returned from previous
+ * 	calls to mpathvalid_is_path(). These are wwids of existing
+ * 	devices that are or potentially are claimed by device-mapper
+ * 	multipath. path_wwids is used with the MPATH_SMART claim mode,
+ *	to claim devices when another device with the same wwid exists.
+ * 	nr_paths must either be set to the number of elements of
+ * 	path_wwids, or 0, if path_wwids is NULL.
+ * @name: The kernel name of the device. input argument
+ * @mode: the find_multipaths claim mode (mpath_valid_mode). input argument
+ * @wwid: address of a pointer to the path wwid, or NULL. Output argument.
+ * 	  Set if path is/may be claimed. If set, must be freed by caller
+ * @path_wwids: Array of pointers to path wwids, or NULL. input argument
+ * @nr_paths: number of elements in path_wwids array. input argument.
+ *
+ * RETURNS: device claim result (mpath_valid_result)
+ * 	    Also sets *wwid if wwid is not NULL, and the claim result is
+ * 	    MPATH_IS_VALID, MPATH_IS_VALID_NO_CHECK, or
+ * 	    MPATH_IS_MAYBE_VALID
+ */
+int mpathvalid_is_path(const char *name, unsigned int mode, char **wwid,
+		       const char **path_wwids, unsigned int nr_paths);
+
+#ifdef __cplusplus
+}
+#endif
+#endif /* LIB_PATH_VALID_H */
diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index 67a7379f..2e3583f5 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -264,3 +264,9 @@ LIBMULTIPATH_4.1.0 {
 global:
 	libmp_verbosity;
 } LIBMULTIPATH_4.0.0;
+
+LIBMULTIPATH_4.2.0 {
+global:
+	dm_prereq;
+	skip_libmp_dm_init;
+} LIBMULTIPATH_4.1.0;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

