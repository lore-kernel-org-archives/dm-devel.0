Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A8330F94C
	for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766006507; cv=none; b=A3bySyZ0qgyDtlKKTS2xm0QrGM7DElJ4eoWgVqcWOCBLHk4TrBUmRSvK0/yfoVTsVaBIhBrbBML4ForA7r9LDA/cFNqYYFE5ytilWrT8HYLED002xPoun072d6J1TQOMf40V4VNZ/ZxCLvOdTydcRM7bO1e+anFVmdFpJ5pvwO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766006507; c=relaxed/simple;
	bh=JLytmt5PJ3n043NVu/H1bd7kdL3rvPUewz2WfhvvvWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtUh/XTlrVdlyu9SmjQHigS9NOYS2y6xRU4IG5X5nPPH8Gc3R9mYzV1VpyLBQYALPF5sbItYMa6fqREV1Us7SO+x5vCulTXtNTSVY83ozNGPHiJ+fEJALm79OIM6UgVwh5QUH4/WgZVgvo2C3PLOvT8CHjI2O1H90+SVrbEbIgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=amOYP0EO; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="amOYP0EO"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-64b4b35c812so988194a12.0
        for <dm-devel@lists.linux.dev>; Wed, 17 Dec 2025 13:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766006503; x=1766611303; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbS0V+Tr4VNMYPWQMBdQIYP4nGhWwxMm4OZ6js2Fdk0=;
        b=amOYP0EOtqwjdZi77KgGhX/QLct490MRpOhEZmSrvZe1sSP8sT/ztgO0OlVP2x6IBk
         Qkd1u8WMkYbIfVNsKfY6kmrvEhd1BEPIiTRKY9wcAe/1kB3lxqvGYZUmtiFyDi09q5ZR
         H7GeHtFmPcHkHRYf18Gasb4Qfa2gu/Nq8miijeYQ1MfOXdvdQPrPgHm+1Kl3n/qUTHAC
         fHuQYOj5oDDcREji5bGnc99h62Z1KyEz5r8Wvy50Jsk5Wf2Z/13Yx5gtZBDnNaNkDMxy
         ugb5brXEkSJTOushxw+9v02G4Z0J7Om6+Rbdk6J8n1vzN+jhmdIpYYv0EE9ZjS6FhHtU
         rXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766006503; x=1766611303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HbS0V+Tr4VNMYPWQMBdQIYP4nGhWwxMm4OZ6js2Fdk0=;
        b=G18aqKhQHCRnYJ1SY7ezewb/Fn69mkobbUCyFQHnQPKV/R1zi6i5B8qeYFm1eupSrz
         /p/GFb03ENqOXPZ7ad3LpYiM2xMx9YQdSZsjH0izaPDJ7K42XqndA4OsZKEvfPK1PPCJ
         pGlHnClgT6ps7y3hZgGbtKSHnB0O3yIZBpLCoq5h2mfs4PdAZKhObwL3F5PE90YRnmnT
         LU+LuY5Vx/xMgTjPqRXR7cyJi/IcEXzYoBnJi5hPdt5PX1XOyRPRLAi5BvwTbtBQDT6v
         rZ4AyEZCAtYwtdLOLbfLfwjtPbmtZPdRqv52+dDYOfNEOSvgY/0xktAtTC4+lbBLbiQT
         Et8g==
X-Gm-Message-State: AOJu0YypH+L3LRq836Nd80qsA+DcP96SZX+eItm1r2zcLW9VYRvYqur7
	b/UB9oPDSF3RcSXBWIxnPwlLqL5S1NRIN6BAp5aiWEKG8clujFrwcFxBz0yL3UOjKcE=
X-Gm-Gg: AY/fxX5shnz79Gsy3YTCLE8ubHi3bL5Dz1Gr9eu00XIBZfZ9WRCjS8P05eiC+BaR7qc
	xPJ95X5mEPwdGaPl7fbVVwF5Cy3U9h3v+m6S6B6JmJcvk9H1hIEeBHKztfsYhOhS8dTClSA/sr8
	uPHx42j9HbyvB/Hxdh69KGfF/CpUUZDWIHEPOmVB0utIs42YAa/+GWMuEqsK1j0ZKky5/bvNOdJ
	lfYx7WeaTwjEfITciHQOstLKiu0kuThBhbm1wY2G6duQdHA/lRokBI9Hcca2h1HZM2EVWqbRXy2
	6St5Xb5EZbBCZq3/lcJhjw9xO7brhevlhyefwhz7m5z2mhLcWZ3fGlxtA+pjbhP48JezSDi2OON
	ybwWj3eEOkNLL3HkgCTJcd8msWJk/ByuagCqu+nGJ6RkrSnO+KqBgyV/nARIQSG3F5DwEMEQj/a
	lCD3ufJoL7OKIYjYvWSrxTRZRnkoIiOOGX0P7XvCedej86xjy+reQmAQ7Ntg//hPsMgd7QpYXMv
	A==
X-Google-Smtp-Source: AGHT+IE+WHm+LDZaoE+SP4mCZcSRVgT12jZeCun9N03qEiAxu0WIPHdbKKhiveA63IuAio6CLrBlwg==
X-Received: by 2002:a05:6402:34d0:b0:64b:33da:5cc6 with SMTP id 4fb4d7f45d1cf-64b33da5dc2mr5825136a12.16.1766006503005;
        Wed, 17 Dec 2025 13:21:43 -0800 (PST)
Received: from localhost (p200300de373ad10007c9709feaeeb67f.dip0.t-ipconnect.de. [2003:de:373a:d100:7c9:709f:eaee:b67f])
        by smtp.gmail.com with UTF8SMTPSA id 4fb4d7f45d1cf-64b5886d427sm545712a12.20.2025.12.17.13.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 13:21:42 -0800 (PST)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH 19/21] multipath-tools: use the libudev wrapper functions
Date: Wed, 17 Dec 2025 22:21:11 +0100
Message-ID: <20251217212113.234959-20-mwilck@suse.com>
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

Replace all calls to libudev functions by their respective wrappers.
This is achieved by replacing <libudev.h> by "mt-udev-wrap.h".

Adapt the test code where necessary.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libdmmp/Makefile                      |  2 +-
 libdmmp/libdmmp.c                     |  2 +-
 libmpathpersist/mpath_persist_int.c   |  2 +-
 libmpathpersist/mpath_pr_ioctl.c      |  2 +-
 libmpathpersist/mpath_updatepr.c      |  2 +-
 libmpathutil/Makefile                 |  2 +-
 libmpathutil/globals.c                |  2 +-
 libmpathutil/util.c                   |  2 +-
 libmpathutil/util.h                   |  2 +-
 libmpathvalid/mpath_valid.c           |  2 +-
 libmultipath/blacklist.c              |  2 +-
 libmultipath/blacklist.h              |  2 +-
 libmultipath/config.c                 |  2 +-
 libmultipath/configure.c              |  2 +-
 libmultipath/dict.c                   |  2 +-
 libmultipath/discovery.c              |  4 +++-
 libmultipath/foreign.c                |  2 +-
 libmultipath/foreign.h                |  2 +-
 libmultipath/foreign/nvme.c           |  2 +-
 libmultipath/print.c                  |  2 +-
 libmultipath/prio.c                   |  2 +-
 libmultipath/prioritizers/alua_rtpg.c |  2 +-
 libmultipath/prioritizers/ana.c       |  2 +-
 libmultipath/prkey.c                  |  2 +-
 libmultipath/propsel.c                |  2 +-
 libmultipath/structs.c                |  2 +-
 libmultipath/structs_vec.c            |  2 +-
 libmultipath/sysfs.c                  |  2 +-
 libmultipath/uevent.c                 |  2 +-
 libmultipath/valid.c                  |  2 +-
 mpathpersist/main.c                   |  2 +-
 multipath/main.c                      |  2 +-
 multipathd/cli_handlers.c             |  2 +-
 multipathd/fpin_handlers.c            |  2 +-
 multipathd/main.c                     |  2 +-
 tests/Makefile                        | 22 +++++++++++++---------
 tests/devt.c                          |  2 +-
 tests/hwtable.c                       |  2 +-
 tests/mpathvalid.c                    |  2 +-
 tests/sysfs.c                         |  2 +-
 tests/test-lib.c                      |  2 +-
 41 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/libdmmp/Makefile b/libdmmp/Makefile
index 7e0e250..bd3b86b 100644
--- a/libdmmp/Makefile
+++ b/libdmmp/Makefile
@@ -14,7 +14,7 @@ HEADERS := libdmmp/libdmmp.h
 
 OBJS := libdmmp.o libdmmp_mp.o libdmmp_pg.o libdmmp_path.o libdmmp_misc.o
 
-CPPFLAGS += -I$(libdmmpdir) -I$(mpathcmddir) $(shell $(PKG_CONFIG) --cflags json-c)
+CPPFLAGS += -I$(libdmmpdir) -I$(mpathutildir) -I$(mpathcmddir) $(shell $(PKG_CONFIG) --cflags json-c)
 CFLAGS += $(LIB_CFLAGS) -fvisibility=hidden
 
 LIBDEPS += $(shell $(PKG_CONFIG) --libs json-c) -L$(mpathcmddir) -lmpathcmd -lpthread
diff --git a/libdmmp/libdmmp.c b/libdmmp/libdmmp.c
index 79550f5..badd5e7 100644
--- a/libdmmp/libdmmp.c
+++ b/libdmmp/libdmmp.c
@@ -11,7 +11,7 @@
 #include <string.h>
 #include <sys/time.h>
 #include <sys/resource.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <errno.h>
 #include <libdevmapper.h>
 #include <unistd.h>
diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 14f7ba8..3091c5c 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -2,7 +2,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <fcntl.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <unistd.h>
 #include <pthread.h>
 #include <stdio.h>
diff --git a/libmpathpersist/mpath_pr_ioctl.c b/libmpathpersist/mpath_pr_ioctl.c
index 6eaec7c..41e5f56 100644
--- a/libmpathpersist/mpath_pr_ioctl.c
+++ b/libmpathpersist/mpath_pr_ioctl.c
@@ -10,7 +10,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <sys/ioctl.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include "mpath_pr_ioctl.h"
 #include "mpath_persist.h"
 #include "unaligned.h"
diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index c925dce..514000d 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -10,7 +10,7 @@
 #include <sys/un.h>
 #include <poll.h>
 #include <errno.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <mpath_persist.h>
 #include "debug.h"
 #include "mpath_cmd.h"
diff --git a/libmpathutil/Makefile b/libmpathutil/Makefile
index aebd8cc..e1cc2c6 100644
--- a/libmpathutil/Makefile
+++ b/libmpathutil/Makefile
@@ -12,7 +12,7 @@ LIBDEPS += -lpthread -ldl -ludev -L$(mpathcmddir) -lmpathcmd $(SYSTEMD_LIBDEPS)
 # they need to be recompiled for unit tests
 
 # other object files
-OBJS := parser.o vector.o util.o debug.o time-util.o \
+OBJS := mt-libudev.o parser.o vector.o util.o debug.o time-util.o \
 	uxsock.o log_pthread.o log.o strbuf.o globals.o msort.o
 
 all:	$(DEVLIB)
diff --git a/libmpathutil/globals.c b/libmpathutil/globals.c
index 4d91349..2596701 100644
--- a/libmpathutil/globals.c
+++ b/libmpathutil/globals.c
@@ -1,5 +1,5 @@
 #include <stddef.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include "globals.h"
 
 __attribute__((weak)) struct config *get_multipath_config(void)
diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 5e45750..23a9797 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -12,7 +12,7 @@
 #include <dirent.h>
 #include <unistd.h>
 #include <errno.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 
 #include "util.h"
 #include "debug.h"
diff --git a/libmpathutil/util.h b/libmpathutil/util.h
index 1ec6a46..1227bbc 100644
--- a/libmpathutil/util.h
+++ b/libmpathutil/util.h
@@ -10,12 +10,12 @@
 #include <inttypes.h>
 #include <stdbool.h>
 #include <stdio.h>
-#include <libudev.h>
 
 #ifndef __GLIBC_PREREQ
 #define __GLIBC_PREREQ(x, y) 0
 #endif
 
+struct udev_device;
 size_t strchop(char *);
 
 const char *libmp_basename(const char *filename);
diff --git a/libmpathvalid/mpath_valid.c b/libmpathvalid/mpath_valid.c
index 7073d17..132578d 100644
--- a/libmpathvalid/mpath_valid.c
+++ b/libmpathvalid/mpath_valid.c
@@ -2,7 +2,7 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <libdevmapper.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <errno.h>
 
 #include "devmapper.h"
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 17e1b54..bdade4c 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -4,7 +4,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <fcntl.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 
 #include "checkers.h"
 #include "vector.h"
diff --git a/libmultipath/blacklist.h b/libmultipath/blacklist.h
index f32b582..3a30d56 100644
--- a/libmultipath/blacklist.h
+++ b/libmultipath/blacklist.h
@@ -1,7 +1,7 @@
 #ifndef BLACKLIST_H_INCLUDED
 #define BLACKLIST_H_INCLUDED
 
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <regex.h>
 
 #define MATCH_NOTHING        0
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 8b424d1..0717c83 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -5,7 +5,7 @@
  */
 #include <stdio.h>
 #include <string.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <dirent.h>
 #include <limits.h>
 #include <errno.h>
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 41b6a9f..c4bfdf3 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -14,7 +14,7 @@
 #include <errno.h>
 #include <ctype.h>
 #include <libdevmapper.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include "mpath_cmd.h"
 
 #include "checkers.h"
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index a06a613..cb11465 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -23,7 +23,7 @@
 #include "util.h"
 #include <errno.h>
 #include <inttypes.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include "autoconfig.h"
 #include "mpath_cmd.h"
 #include "dict.h"
diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 607fb3b..f17893f 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -8,13 +8,15 @@
 #include <unistd.h>
 #include <limits.h>
 #include <fcntl.h>
+#include <sys/types.h>
+#include <sys/sysmacros.h>
 #include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <dirent.h>
 #include <errno.h>
 #include <libgen.h>
-#include <libudev.h>
 
+#include "mt-udev-wrap.h"
 #include "checkers.h"
 #include "vector.h"
 #include "util.h"
diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
index 6f7ccb4..ad063ea 100644
--- a/libmultipath/foreign.c
+++ b/libmultipath/foreign.c
@@ -13,7 +13,7 @@
 #include <dirent.h>
 #include <fnmatch.h>
 #include <dlfcn.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <regex.h>
 #include "vector.h"
 #include "debug.h"
diff --git a/libmultipath/foreign.h b/libmultipath/foreign.h
index 97c1f8a..db545e3 100644
--- a/libmultipath/foreign.h
+++ b/libmultipath/foreign.h
@@ -6,7 +6,7 @@
 #define FOREIGN_H_INCLUDED
 
 #include <stdbool.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #define LIBMP_FOREIGN_API ((1 << 8) | 2)
 
 struct strbuf;
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index 4cbdf60..04fa1e0 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -6,7 +6,7 @@
 #include "nvme-lib.h"
 #include <sys/types.h>
 #include <sys/sysmacros.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/libmultipath/print.c b/libmultipath/print.c
index 0d44a5a..054f06f 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -10,7 +10,7 @@
 #include <unistd.h>
 #include <errno.h>
 #include <assert.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 
 #include "checkers.h"
 #include "vector.h"
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index a54487f..24f825b 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -3,7 +3,7 @@
 #include <stddef.h>
 #include <dlfcn.h>
 #include <sys/stat.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 
 #include "debug.h"
 #include "util.h"
diff --git a/libmultipath/prioritizers/alua_rtpg.c b/libmultipath/prioritizers/alua_rtpg.c
index e53f447..053cccb 100644
--- a/libmultipath/prioritizers/alua_rtpg.c
+++ b/libmultipath/prioritizers/alua_rtpg.c
@@ -18,7 +18,7 @@
 #include <limits.h>
 #include <sys/ioctl.h>
 #include <inttypes.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <errno.h>
 
 #include <scsi/sg.h>
diff --git a/libmultipath/prioritizers/ana.c b/libmultipath/prioritizers/ana.c
index 34527b2..ac2090d 100644
--- a/libmultipath/prioritizers/ana.c
+++ b/libmultipath/prioritizers/ana.c
@@ -16,7 +16,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <stdbool.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 
 #include "debug.h"
 #include "nvme-lib.h"
diff --git a/libmultipath/prkey.c b/libmultipath/prkey.c
index ebed0d0..b84746c 100644
--- a/libmultipath/prkey.c
+++ b/libmultipath/prkey.c
@@ -12,7 +12,7 @@
 #include <string.h>
 #include <inttypes.h>
 #include <errno.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 /* MPATH_F_APTPL_MASK is publicly defined in mpath_persist.h */
 #include <../libmpathpersist/mpath_persist.h>
 
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index 4c0fbcf..0f79d88 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -26,7 +26,7 @@
 #include "propsel.h"
 #include "strbuf.h"
 #include <inttypes.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <ctype.h>
 
 pgpolicyfn *pgpolicies[] = {
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 29b62e4..d6a67e0 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -5,7 +5,7 @@
 #include <stdio.h>
 #include <unistd.h>
 #include <libdevmapper.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <ctype.h>
 
 #include "checkers.h"
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index c23e754..aba041e 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -1,7 +1,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 
 #include "util.h"
 #include "checkers.h"
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index af27d10..2426981 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -14,7 +14,7 @@
 #include <sys/stat.h>
 #include <string.h>
 #include <dirent.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <fnmatch.h>
 #include <limits.h>
 
diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 63cf2fb..be199af 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -28,7 +28,7 @@
 #include <pthread.h>
 #include <sys/mman.h>
 #include <sys/time.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 
 #include "autoconfig.h"
 #include "debug.h"
diff --git a/libmultipath/valid.c b/libmultipath/valid.c
index 7bf8616..1bf1936 100644
--- a/libmultipath/valid.c
+++ b/libmultipath/valid.c
@@ -4,7 +4,7 @@
  */
 #include <stddef.h>
 #include <errno.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <dirent.h>
 #include <libmount/libmount.h>
 
diff --git a/mpathpersist/main.c b/mpathpersist/main.c
index fea5a9c..f8c5f8e 100644
--- a/mpathpersist/main.c
+++ b/mpathpersist/main.c
@@ -8,7 +8,7 @@
 #include "config.h"
 #include "structs.h"
 #include <getopt.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include "mpath_persist.h"
 #include "mpath_persist_int.h"
 #include "main.h"
diff --git a/multipath/main.c b/multipath/main.c
index 4b8d7dd..ddbe908 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -19,7 +19,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <ctype.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <syslog.h>
 #include <fcntl.h>
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 53be68d..f5a13c4 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -19,7 +19,7 @@
 #include "print.h"
 #include "sysfs.h"
 #include <errno.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <mpath_persist.h>
 #include "util.h"
 #include "prkey.h"
diff --git a/multipathd/fpin_handlers.c b/multipathd/fpin_handlers.c
index 2920469..92a61bb 100644
--- a/multipathd/fpin_handlers.c
+++ b/multipathd/fpin_handlers.c
@@ -3,7 +3,7 @@
 #include <stdint.h>
 #include <sys/types.h>
 #include <sys/socket.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <scsi/scsi_netlink_fc.h>
 #include <scsi/fc/fc_els.h>
 
diff --git a/multipathd/main.c b/multipathd/main.c
index 2043ff3..7f7c86d 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -15,7 +15,7 @@
 #include <errno.h>
 #include <limits.h>
 #include <linux/oom.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <urcu.h>
 #include "fpin.h"
 #ifdef USE_SYSTEMD
diff --git a/tests/Makefile b/tests/Makefile
index 28c00ad..9f1b950 100644
--- a/tests/Makefile
+++ b/tests/Makefile
@@ -5,7 +5,7 @@ TESTDIR := $(CURDIR)
 
 CPPFLAGS += -I$(multipathdir) -I$(mpathutildir) -I$(mpathcmddir) -I$(daemondir) \
 	-DTESTCONFDIR=\"$(TESTDIR)/conf.d\"
-CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter $(W_MISSING_INITIALIZERS)
+CFLAGS += $(BIN_CFLAGS) -Wno-unused-parameter -Wno-unused-function $(W_MISSING_INITIALIZERS)
 LIBDEPS += -L. -L $(mpathutildir) -L$(mpathcmddir) -lmultipath -lmpathutil -lmpathcmd -lcmocka
 
 TESTS := uevent parser util dmevents hwtable blacklist unaligned vpd pgpolicy \
@@ -39,26 +39,30 @@ dmevents-test_OBJDEPS = $(multipathdir)/devmapper.o
 dmevents-test_LIBDEPS = -lpthread -ldevmapper -lurcu
 hwtable-test_TESTDEPS := test-lib.o
 hwtable-test_OBJDEPS := $(multipathdir)/discovery.o $(multipathdir)/blacklist.o \
-	$(multipathdir)/structs_vec.o $(multipathdir)/structs.o $(multipathdir)/propsel.o
+	$(multipathdir)/structs_vec.o $(multipathdir)/structs.o $(multipathdir)/propsel.o \
+	$(mpathutildir)/mt-libudev.o
 hwtable-test_LIBDEPS := -ludev -lpthread -ldl
 blacklist-test_TESTDEPS := test-log.o
-blacklist-test_LIBDEPS := -ludev
-vpd-test_OBJDEPS :=  $(multipathdir)/discovery.o
+blacklist-test_OBJDEPS := $(mpathutildir)/mt-libudev.o
+blacklist-test_LIBDEPS := -ludev -lpthread -ldl
+vpd-test_OBJDEPS :=  $(multipathdir)/discovery.o $(mpathutildir)/mt-libudev.o
 vpd-test_LIBDEPS := -ludev -lpthread -ldl
 alias-test_TESTDEPS := test-log.o
-alias-test_OBJDEPS := $(mpathutildir)/util.o
+alias-test_OBJDEPS := $(mpathutildir)/util.o $(mpathutildir)/mt-libudev.o
 alias-test_LIBDEPS := -ludev -lpthread -ldl
-valid-test_OBJDEPS := $(multipathdir)/valid.o $(multipathdir)/discovery.o
+valid-test_OBJDEPS := $(multipathdir)/valid.o $(multipathdir)/discovery.o $(mpathutildir)/mt-libudev.o
 valid-test_LIBDEPS := -lmount -ludev -lpthread -ldl
-devt-test_LIBDEPS := -ludev
+devt-test_LIBDEPS := -ludev -lpthread -ldl
+devt-test_OBJDEPS := $(mpathutildir)/mt-libudev.o
 mpathvalid-test_LIBDEPS := -ludev -lpthread -ldl
-mpathvalid-test_OBJDEPS := $(mpathvaliddir)/mpath_valid.o
+mpathvalid-test_OBJDEPS := $(mpathvaliddir)/mpath_valid.o $(mpathutildir)/mt-libudev.o
 directio-test_LIBDEPS := -laio
 strbuf-test_OBJDEPS := $(mpathutildir)/strbuf.o
 sysfs-test_TESTDEPS := test-log.o
-sysfs-test_OBJDEPS := $(multipathdir)/sysfs.o $(mpathutildir)/util.o
+sysfs-test_OBJDEPS := $(multipathdir)/sysfs.o $(mpathutildir)/util.o $(mpathutildir)/mt-libudev.o
 sysfs-test_LIBDEPS := -ludev -lpthread -ldl
 features-test_LIBDEPS := -ludev -lpthread
+features-test_OBJDEPS := $(mpathutildir)/mt-libudev.o
 cli-test_OBJDEPS := $(daemondir)/cli.o
 mapinfo-test_LIBDEPS = -lpthread -ldevmapper
 
diff --git a/tests/devt.c b/tests/devt.c
index aafee38..32edf51 100644
--- a/tests/devt.c
+++ b/tests/devt.c
@@ -9,7 +9,7 @@
 #include <setjmp.h>
 #include <stdlib.h>
 #include <cmocka.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <sys/sysmacros.h>
 #include <fcntl.h>
 #include <sys/stat.h>
diff --git a/tests/hwtable.c b/tests/hwtable.c
index 334b75e..631b882 100644
--- a/tests/hwtable.c
+++ b/tests/hwtable.c
@@ -8,7 +8,7 @@
 #include <setjmp.h>
 #include <stdlib.h>
 #include <cmocka.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
diff --git a/tests/mpathvalid.c b/tests/mpathvalid.c
index 134dfc9..699dce5 100644
--- a/tests/mpathvalid.c
+++ b/tests/mpathvalid.c
@@ -9,7 +9,7 @@
 #include <setjmp.h>
 #include <stdlib.h>
 #include <unistd.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <cmocka.h>
 #include "structs.h"
 #include "config.h"
diff --git a/tests/sysfs.c b/tests/sysfs.c
index 6dfa9f3..13f985f 100644
--- a/tests/sysfs.c
+++ b/tests/sysfs.c
@@ -10,7 +10,7 @@
 #include <setjmp.h>
 #include <stdlib.h>
 #include <cmocka.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <fcntl.h>
 #include <errno.h>
 #include "debug.h"
diff --git a/tests/test-lib.c b/tests/test-lib.c
index 963e289..3f07567 100644
--- a/tests/test-lib.c
+++ b/tests/test-lib.c
@@ -2,7 +2,7 @@
 #include <setjmp.h>
 #include <stdarg.h>
 #include <cmocka.h>
-#include <libudev.h>
+#include "mt-udev-wrap.h"
 #include <sys/sysmacros.h>
 #include <linux/hdreg.h>
 #include <scsi/sg.h>
-- 
2.52.0

