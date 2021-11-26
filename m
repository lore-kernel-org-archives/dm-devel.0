Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052FBC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 26 Nov 2021 08:38:00 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-254-krKLM2kbOwyIR2h7Pj45qw-1; Fri, 26 Nov 2021 03:37:56 -0500
X-MC-Unique: krKLM2kbOwyIR2h7Pj45qw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D52F6409A;
	Fri, 26 Nov 2021 08:37:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 02ED01002039;
	Fri, 26 Nov 2021 08:37:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3E2231809C8A;
	Fri, 26 Nov 2021 08:37:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AQ8bc1E024122 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Nov 2021 03:37:39 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CBBDE1121319; Fri, 26 Nov 2021 08:37:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C65B81121315
	for <dm-devel@redhat.com>; Fri, 26 Nov 2021 08:37:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52CBC811E7F
	for <dm-devel@redhat.com>; Fri, 26 Nov 2021 08:37:35 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-464-wPXiGHfSOjKeSWk7WzOLGA-1; Fri, 26 Nov 2021 03:37:32 -0500
X-MC-Unique: wPXiGHfSOjKeSWk7WzOLGA-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J0p2h6mWrzZdGm;
	Fri, 26 Nov 2021 16:34:52 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Fri, 26 Nov 2021 16:37:26 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Fri, 26 Nov 2021 16:37:25 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
Message-ID: <e587e49b-1bb6-2943-b65e-85fb31fe936f@huawei.com>
Date: Fri, 26 Nov 2021 16:37:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
	kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH] remove unuseful MALLOC/REALLOC/STRDUP/FREE
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now there are tools such as valgrind and asan to detect memory leaks,
so it is unnecessary to use _DEBUG_. Remove _DEBUG_ code.

Signed-off-by: Lixiaokeng<lixiaokeng@huawei.com>
---
 libmpathpersist/mpath_persist.c          |   4 +-
 libmpathpersist/mpath_updatepr.c         |   1 -
 libmultipath/Makefile                    |   2 +-
 libmultipath/alias.c                     |   2 +-
 libmultipath/blacklist.c                 |  27 +-
 libmultipath/checkers.c                  |   4 +-
 libmultipath/checkers.h                  |   4 +-
 libmultipath/checkers/emc_clariion.c     |   3 +-
 libmultipath/config.c                    |  85 +++--
 libmultipath/configure.c                 |  21 +-
 libmultipath/defaults.c                  |   1 -
 libmultipath/defaults.h                  |   1 +
 libmultipath/devmapper.c                 |  15 +-
 libmultipath/dict.c                      |  49 ++-
 libmultipath/discovery.c                 |   1 -
 libmultipath/dmparser.c                  |  47 ++-
 libmultipath/io_err_stat.c               |  13 +-
 libmultipath/log.c                       |  22 +-
 libmultipath/log_pthread.c               |   2 -
 libmultipath/memory.c                    | 444 -----------------------
 libmultipath/memory.h                    |  66 ----
 libmultipath/parser.c                    |  25 +-
 libmultipath/pgpolicies.c                |   5 +-
 libmultipath/prio.c                      |   4 +-
 libmultipath/prio.h                      |   1 -
 libmultipath/prioritizers/path_latency.c |   6 +-
 libmultipath/prioritizers/weightedpath.c |   1 -
 libmultipath/propsel.c                   |  11 +-
 libmultipath/structs.c                   |  51 ++-
 libmultipath/sysfs.c                     |   2 +-
 libmultipath/uevent.c                    |  13 +-
 libmultipath/util.c                      |   7 +-
 libmultipath/util.h                      |   1 +
 libmultipath/uxsock.c                    |   5 +-
 libmultipath/vector.c                    |  15 +-
 multipath/main.c                         |  19 +-
 multipathd/cli.c                         |  23 +-
 multipathd/cli.h                         |   2 +-
 multipathd/cli_handlers.c                |   7 +-
 multipathd/main.c                        |  33 +-
 multipathd/uxclnt.c                      |   5 +-
 multipathd/uxlsnr.c                      |  17 +-
 multipathd/waiter.c                      |   5 +-
 tests/pgpolicy.c                         |   1 +
 tests/uevent.c                           |   8 +-
 45 files changed, 268 insertions(+), 813 deletions(-)
 delete mode 100644 libmultipath/memory.c
 delete mode 100644 libmultipath/memory.h

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 803a2a28..3097c813 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -239,7 +239,7 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
 		alias = NULL;
 	}
 out:
-	FREE(alias);
+	free(alias);
 	return ret;
 }

@@ -342,7 +342,7 @@ static int do_mpath_persistent_reserve_out(vector curmp, vector pathvec, int fd,
 		update_prkey(alias, 0);
 	}
 out1:
-	FREE(alias);
+	free(alias);
 	return ret;
 }

diff --git a/libmpathpersist/mpath_updatepr.c b/libmpathpersist/mpath_updatepr.c
index 0aca28eb..bdecaa05 100644
--- a/libmpathpersist/mpath_updatepr.c
+++ b/libmpathpersist/mpath_updatepr.c
@@ -14,7 +14,6 @@
 #include "debug.h"
 #include "mpath_cmd.h"
 #include "uxsock.h"
-#include "memory.h"
 #include "mpathpr.h"


diff --git a/libmultipath/Makefile b/libmultipath/Makefile
index 7f3921c5..fe24f387 100644
--- a/libmultipath/Makefile
+++ b/libmultipath/Makefile
@@ -45,7 +45,7 @@ ifneq ($(call check_func,dm_hold_control_dev,/usr/include/libdevmapper.h),0)
 	CFLAGS += -DLIBDM_API_HOLD_CONTROL
 endif

-OBJS = memory.o parser.o vector.o devmapper.o callout.o \
+OBJS = parser.o vector.o devmapper.o callout.o \
 	hwtable.o blacklist.o util.o dmparser.o config.o \
 	structs.o discovery.o propsel.o dict.o \
 	pgpolicies.o debug.o defaults.o uevent.o time-util.o \
diff --git a/libmultipath/alias.c b/libmultipath/alias.c
index ad7e512b..6ae512c2 100644
--- a/libmultipath/alias.c
+++ b/libmultipath/alias.c
@@ -356,7 +356,7 @@ use_existing_alias (const char *wwid, const char *file, const char *alias_old,
 		 * allocated correctly
 		 */
 		if (strcmp(buff, wwid) == 0)
-			alias = STRDUP(alias_old);
+			alias = strdup(alias_old);
 		else {
 			alias = NULL;
 			condlog(0, "alias %s already bound to wwid %s, cannot reuse",
diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 4e315c97..8d15d2ea 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -5,7 +5,6 @@
 #include <libudev.h>

 #include "checkers.h"
-#include "memory.h"
 #include "vector.h"
 #include "util.h"
 #include "debug.h"
@@ -46,7 +45,7 @@ int store_ble(vector blist, const char *str, int origin)
 	if (!blist)
 		goto out;

-	ble = MALLOC(sizeof(struct blentry));
+	ble = calloc(1, sizeof(struct blentry));

 	if (!ble)
 		goto out;
@@ -63,9 +62,9 @@ int store_ble(vector blist, const char *str, int origin)
 	vector_set_slot(blist, ble);
 	return 0;
 out1:
-	FREE(ble);
+	free(ble);
 out:
-	FREE(strdup_str);
+	free(strdup_str);
 	return 1;
 }

@@ -77,12 +76,12 @@ int alloc_ble_device(vector blist)
 	if (!blist)
 		return 1;

-	ble = MALLOC(sizeof(struct blentry_device));
+	ble = calloc(1, sizeof(struct blentry_device));
 	if (!ble)
 		return 1;

 	if (!vector_alloc_slot(blist)) {
-		FREE(ble);
+		free(ble);
 		return 1;
 	}
 	vector_set_slot(blist, ble);
@@ -105,7 +104,7 @@ int set_ble_device(vector blist, const char *vendor, const char *product, int or
 		return 1;

 	if (vendor) {
-		vendor_str = STRDUP(vendor);
+		vendor_str = strdup(vendor);
 		if (!vendor_str)
 			goto out;

@@ -116,7 +115,7 @@ int set_ble_device(vector blist, const char *vendor, const char *product, int or
 		ble->vendor = vendor_str;
 	}
 	if (product) {
-		product_str = STRDUP(product);
+		product_str = strdup(product);
 		if (!product_str)
 			goto out1;

@@ -216,7 +215,7 @@ setup_default_blist (struct config * conf)
 					  VECTOR_SIZE(conf->blist_device) - 1);
 			if (set_ble_device(conf->blist_device, hwe->vendor, hwe->bl_product,
 					   ORIGIN_DEFAULT)) {
-				FREE(ble);
+				free(ble);
 				vector_del_slot(conf->blist_device, VECTOR_SIZE(conf->blist_device) - 1);
 				return 1;
 			}
@@ -445,8 +444,8 @@ static void free_ble(struct blentry *ble)
 	if (!ble)
 		return;
 	regfree(&ble->regex);
-	FREE(ble->str);
-	FREE(ble);
+	free(ble->str);
+	free(ble);
 }

 void
@@ -488,13 +487,13 @@ static void free_ble_device(struct blentry_device *ble)
 	if (ble) {
 		if (ble->vendor) {
 			regfree(&ble->vendor_reg);
-			FREE(ble->vendor);
+			free(ble->vendor);
 		}
 		if (ble->product) {
 			regfree(&ble->product_reg);
-			FREE(ble->product);
+			free(ble->product);
 		}
-		FREE(ble);
+		free(ble);
 	}
 }

diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
index 8039c2bf..ef346d79 100644
--- a/libmultipath/checkers.c
+++ b/libmultipath/checkers.c
@@ -55,7 +55,7 @@ static struct checker_class *alloc_checker_class(void)
 {
 	struct checker_class *c;

-	c = MALLOC(sizeof(struct checker_class));
+	c = calloc(1, sizeof(struct checker_class));
 	if (c) {
 		INIT_LIST_HEAD(&c->node);
 		uatomic_set(&c->refcount, 1);
@@ -96,7 +96,7 @@ void free_checker_class(struct checker_class *c)
 				c->name, dlerror());
 		}
 	}
-	FREE(c);
+	free(c);
 }

 void cleanup_checkers (void)
diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
index 2fd1d1c6..f4600ed3 100644
--- a/libmultipath/checkers.h
+++ b/libmultipath/checkers.h
@@ -3,7 +3,6 @@

 #include <pthread.h>
 #include "list.h"
-#include "memory.h"
 #include "defaults.h"

 /*
@@ -127,8 +126,7 @@ struct checker {
 	short msgid;		             /* checker-internal extra status */
 	void * context;                      /* store for persistent data */
 	void ** mpcontext;                   /* store for persistent data shared
-						multipath-wide. Use MALLOC if
-						you want to stuff data in. */
+						multipath-wide. */
 };

 static inline int checker_selected(const struct checker *c)
diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 5cd63aca..aa636e7b 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -15,7 +15,6 @@
 #include "libsg.h"
 #include "checkers.h"
 #include "debug.h"
-#include "memory.h"

 #define INQUIRY_CMD     0x12
 #define INQUIRY_CMDLEN  6
@@ -102,7 +101,7 @@ int libcheck_init (struct checker * c)
 	/*
 	 * Allocate and initialize the path specific context.
 	 */
-	c->context = MALLOC(sizeof(struct emc_clariion_checker_path_context));
+	c->context = calloc(1, sizeof(struct emc_clariion_checker_path_context));
 	if (!c->context)
 		return 1;
 	((struct emc_clariion_checker_path_context *)c->context)->wwn_set = 0;
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 30046a17..c595e768 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -11,7 +11,6 @@
 #include <errno.h>

 #include "checkers.h"
-#include "memory.h"
 #include "util.h"
 #include "debug.h"
 #include "parser.h"
@@ -245,45 +244,45 @@ free_hwe (struct hwentry * hwe)
 		return;

 	if (hwe->vendor)
-		FREE(hwe->vendor);
+		free(hwe->vendor);

 	if (hwe->product)
-		FREE(hwe->product);
+		free(hwe->product);

 	if (hwe->revision)
-		FREE(hwe->revision);
+		free(hwe->revision);

 	if (hwe->getuid)
-		FREE(hwe->getuid);
+		free(hwe->getuid);

 	if (hwe->uid_attribute)
-		FREE(hwe->uid_attribute);
+		free(hwe->uid_attribute);

 	if (hwe->features)
-		FREE(hwe->features);
+		free(hwe->features);

 	if (hwe->hwhandler)
-		FREE(hwe->hwhandler);
+		free(hwe->hwhandler);

 	if (hwe->selector)
-		FREE(hwe->selector);
+		free(hwe->selector);

 	if (hwe->checker_name)
-		FREE(hwe->checker_name);
+		free(hwe->checker_name);

 	if (hwe->prio_name)
-		FREE(hwe->prio_name);
+		free(hwe->prio_name);

 	if (hwe->prio_args)
-		FREE(hwe->prio_args);
+		free(hwe->prio_args);

 	if (hwe->alias_prefix)
-		FREE(hwe->alias_prefix);
+		free(hwe->alias_prefix);

 	if (hwe->bl_product)
-		FREE(hwe->bl_product);
+		free(hwe->bl_product);

-	FREE(hwe);
+	free(hwe);
 }

 void
@@ -308,27 +307,27 @@ free_mpe (struct mpentry * mpe)
 		return;

 	if (mpe->wwid)
-		FREE(mpe->wwid);
+		free(mpe->wwid);

 	if (mpe->selector)
-		FREE(mpe->selector);
+		free(mpe->selector);

 	if (mpe->getuid)
-		FREE(mpe->getuid);
+		free(mpe->getuid);

 	if (mpe->uid_attribute)
-		FREE(mpe->uid_attribute);
+		free(mpe->uid_attribute);

 	if (mpe->alias)
-		FREE(mpe->alias);
+		free(mpe->alias);

 	if (mpe->prio_name)
-		FREE(mpe->prio_name);
+		free(mpe->prio_name);

 	if (mpe->prio_args)
-		FREE(mpe->prio_args);
+		free(mpe->prio_args);

-	FREE(mpe);
+	free(mpe);
 }

 void
@@ -350,7 +349,7 @@ struct mpentry *
 alloc_mpe (void)
 {
 	struct mpentry * mpe = (struct mpentry *)
-				MALLOC(sizeof(struct mpentry));
+				calloc(1, sizeof(struct mpentry));

 	return mpe;
 }
@@ -359,7 +358,7 @@ struct hwentry *
 alloc_hwe (void)
 {
 	struct hwentry * hwe = (struct hwentry *)
-				MALLOC(sizeof(struct hwentry));
+				calloc(1, sizeof(struct hwentry));

 	return hwe;
 }
@@ -378,7 +377,7 @@ set_param_str(const char * str)
 	if (!len)
 		return NULL;

-	dst = (char *)MALLOC(len + 1);
+	dst = (char *)calloc(1, len + 1);

 	if (!dst)
 		return NULL;
@@ -652,7 +651,7 @@ restart:

 static struct config *alloc_config (void)
 {
-	return (struct config *)MALLOC(sizeof(struct config));
+	return (struct config *)calloc(1, sizeof(struct config));
 }

 static void _uninit_config(struct config *conf)
@@ -661,52 +660,52 @@ static void _uninit_config(struct config *conf)
 		conf = &__internal_config;

 	if (conf->multipath_dir)
-		FREE(conf->multipath_dir);
+		free(conf->multipath_dir);

 	if (conf->selector)
-		FREE(conf->selector);
+		free(conf->selector);

 	if (conf->uid_attribute)
-		FREE(conf->uid_attribute);
+		free(conf->uid_attribute);

 	vector_reset(&conf->uid_attrs);

 	if (conf->getuid)
-		FREE(conf->getuid);
+		free(conf->getuid);

 	if (conf->features)
-		FREE(conf->features);
+		free(conf->features);

 	if (conf->hwhandler)
-		FREE(conf->hwhandler);
+		free(conf->hwhandler);

 	if (conf->bindings_file)
-		FREE(conf->bindings_file);
+		free(conf->bindings_file);

 	if (conf->wwids_file)
-		FREE(conf->wwids_file);
+		free(conf->wwids_file);

 	if (conf->prkeys_file)
-		FREE(conf->prkeys_file);
+		free(conf->prkeys_file);

 	if (conf->prio_name)
-		FREE(conf->prio_name);
+		free(conf->prio_name);

 	if (conf->alias_prefix)
-		FREE(conf->alias_prefix);
+		free(conf->alias_prefix);
 	if (conf->partition_delim)
-		FREE(conf->partition_delim);
+		free(conf->partition_delim);

 	if (conf->prio_args)
-		FREE(conf->prio_args);
+		free(conf->prio_args);

 	if (conf->checker_name)
-		FREE(conf->checker_name);
+		free(conf->checker_name);

 	if (conf->config_dir)
-		FREE(conf->config_dir);
+		free(conf->config_dir);
 	if (conf->enable_foreign)
-		FREE(conf->enable_foreign);
+		free(conf->enable_foreign);

 	free_blacklist(conf->blist_devnode);
 	free_blacklist(conf->blist_wwid);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7edb355b..dfd232d9 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -19,7 +19,6 @@

 #include "checkers.h"
 #include "vector.h"
-#include "memory.h"
 #include "devmapper.h"
 #include "defaults.h"
 #include "structs.h"
@@ -751,8 +750,8 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 			mpp->wwid, cmpp->alias, mpp->alias,
 			mpp->alias, cmpp_by_name->wwid);
 		/* reset alias to existing alias */
-		FREE(mpp->alias);
-		mpp->alias = STRDUP(cmpp->alias);
+		free(mpp->alias);
+		mpp->alias = strdup(cmpp->alias);
 		mpp->action = ACT_IMPOSSIBLE;
 		return;
 	}
@@ -803,8 +802,8 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		return;
 	}

-	cmpp_feat = STRDUP(cmpp->features);
-	mpp_feat = STRDUP(mpp->features);
+	cmpp_feat = strdup(cmpp->features);
+	mpp_feat = strdup(mpp->features);
 	if (cmpp_feat && mpp_feat) {
 		remove_feature(&mpp_feat, "queue_if_no_path");
 		remove_feature(&mpp_feat, "retain_attached_hw_handler");
@@ -812,13 +811,13 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		remove_feature(&cmpp_feat, "retain_attached_hw_handler");
 		if (strcmp(mpp_feat, cmpp_feat)) {
 			select_reload_action(mpp, "features change");
-			FREE(cmpp_feat);
-			FREE(mpp_feat);
+			free(cmpp_feat);
+			free(mpp_feat);
 			return;
 		}
 	}
-	FREE(cmpp_feat);
-	FREE(mpp_feat);
+	free(cmpp_feat);
+	free(mpp_feat);

 	if (!cmpp->selector || strncmp(cmpp->selector, mpp->selector,
 		    strlen(mpp->selector))) {
@@ -1087,7 +1086,7 @@ check_daemon(void)
 	ret = 1;

 out_free:
-	FREE(reply);
+	free(reply);
 out:
 	mpath_disconnect(fd);
 	return ret;
@@ -1430,7 +1429,7 @@ static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
 	}

 	if (refwwid && strlen(refwwid)) {
-		*wwid = STRDUP(refwwid);
+		*wwid = strdup(refwwid);
 		return PATHINFO_OK;
 	}

diff --git a/libmultipath/defaults.c b/libmultipath/defaults.c
index 082640d3..aad8357a 100644
--- a/libmultipath/defaults.c
+++ b/libmultipath/defaults.c
@@ -4,6 +4,5 @@
 #include <string.h>

 #include "defaults.h"
-#include "memory.h"

 const char * const default_partition_delim = DEFAULT_PARTITION_DELIM;
diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
index c27946c7..7d95413d 100644
--- a/libmultipath/defaults.h
+++ b/libmultipath/defaults.h
@@ -1,6 +1,7 @@
 #ifndef _DEFAULTS_H
 #define _DEFAULTS_H
 #include <limits.h>
+#include <string.h>

 /*
  * If you add or modify a value also update multipath/multipath.conf.5
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index c05dc201..ef06d3d8 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -21,7 +21,6 @@
 #include "vector.h"
 #include "structs.h"
 #include "debug.h"
-#include "memory.h"
 #include "devmapper.h"
 #include "sysfs.h"
 #include "config.h"
@@ -474,7 +473,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 		dm_task_set_ro(dmt);

 	if (task == DM_DEVICE_CREATE) {
-		prefixed_uuid = MALLOC(UUID_PREFIX_LEN +
+		prefixed_uuid = calloc(1, UUID_PREFIX_LEN +
 				       strlen(mpp->wwid) + 1);
 		if (!prefixed_uuid) {
 			condlog(0, "cannot create prefixed uuid : %s",
@@ -517,7 +516,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 			libmp_udev_wait(cookie);
 freeout:
 	if (prefixed_uuid)
-		FREE(prefixed_uuid);
+		free(prefixed_uuid);

 addout:
 	dm_task_destroy (dmt);
@@ -1285,7 +1284,7 @@ struct multipath *dm_get_multipath(const char *name)
 	if (!mpp)
 		return NULL;

-	mpp->alias = STRDUP(name);
+	mpp->alias = strdup(name);

 	if (!mpp->alias)
 		goto out;
@@ -1420,7 +1419,7 @@ dm_mapname(int major, int minor)

 	map = dm_task_get_name(dmt);
 	if (map && strlen(map))
-		response = STRDUP((const char *)map);
+		response = strdup((const char *)map);

 	dm_task_destroy(dmt);
 	return response;
@@ -1598,7 +1597,7 @@ dm_cancel_deferred_remove (struct multipath *mpp __attribute__((unused)))
 static struct dm_info *
 alloc_dminfo (void)
 {
-	return MALLOC(sizeof(struct dm_info));
+	return calloc(1, sizeof(struct dm_info));
 }

 int
@@ -1614,7 +1613,7 @@ dm_get_info (const char * mapname, struct dm_info ** dmi)
 		return 1;

 	if (do_get_info(mapname, *dmi) != 0) {
-		FREE(*dmi);
+		free(*dmi);
 		*dmi = NULL;
 		return 1;
 	}
@@ -1715,7 +1714,7 @@ void dm_reassign_deps(char *table, const char *dep, const char *newdep)
 	n += strlen(newdep);
 	p += strlen(dep);
 	strcat(n, p);
-	FREE(newtable);
+	free(newtable);
 }

 int dm_reassign_table(const char *name, char *old, char *new)
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 1b75be47..7ad9f6e2 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -16,7 +16,6 @@
 #include "parser.h"
 #include "config.h"
 #include "debug.h"
-#include "memory.h"
 #include "pgpolicies.h"
 #include "blacklist.h"
 #include "defaults.h"
@@ -69,7 +68,7 @@ set_int(vector strvec, void *ptr, int min, int max, const char *file,

 	do_set_int(strvec, ptr, min, max, file, line_nr, buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -97,7 +96,7 @@ set_uint(vector strvec, void *ptr, const char *file, int line_nr)
 	else
 		*uint_ptr = res;

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -107,7 +106,7 @@ set_str(vector strvec, void *ptr, const char *file, int line_nr)
 	char **str_ptr = (char **)ptr;

 	if (*str_ptr)
-		FREE(*str_ptr);
+		free(*str_ptr);
 	*str_ptr = set_value(strvec);

 	if (!*str_ptr)
@@ -200,7 +199,7 @@ set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
 		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
 			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -222,7 +221,7 @@ set_yes_no_undef(vector strvec, void *ptr, const char *file, int line_nr)
 		condlog(1, "%s line %d, invalid value for %s: \"%s\"",
 			file, line_nr, (char*)VECTOR_SLOT(strvec, 0), buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -449,7 +448,7 @@ static int def_partition_delim_handler(struct config *conf, vector strvec,
 		return rc;

 	if (!strcmp(conf->partition_delim, UNSET_PARTITION_DELIM)) {
-		FREE(conf->partition_delim);
+		free(conf->partition_delim);
 		conf->partition_delim = NULL;
 	}
 	return 0;
@@ -501,7 +500,7 @@ def_find_multipaths_handler(struct config *conf, vector strvec,
 				file, line_nr, buff);
 	}

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -551,7 +550,7 @@ static int uid_attrs_handler(struct config *conf, vector strvec,
 			line_nr, val);
 	else
 		condlog(4, "parsed %d uid_attrs", VECTOR_SIZE(&conf->uid_attrs));
-	FREE(val);
+	free(val);
 	return 0;
 }

@@ -846,7 +845,7 @@ set_mode(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 		condlog(1, "%s line %d, invalid value for mode: \"%s\"",
 			file, line_nr, buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -873,7 +872,7 @@ set_uid(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 		condlog(1, "%s line %d, invalid value for uid: \"%s\"",
 			file, line_nr, buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -900,7 +899,7 @@ set_gid(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 	} else
 		condlog(1, "%s line %d, invalid value for gid: \"%s\"",
 			file, line_nr, buff);
-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -963,7 +962,7 @@ set_undef_off_zero(vector strvec, void *ptr, const char *file, int line_nr)
 	else
 		do_set_int(strvec, int_ptr, 1, INT_MAX, file, line_nr, buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -1002,7 +1001,7 @@ set_dev_loss(vector strvec, void *ptr, const char *file, int line_nr)
 		condlog(1, "%s line %d, invalid value for dev_loss_tmo: \"%s\"",
 			file, line_nr, buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -1047,7 +1046,7 @@ set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
 	else
 		condlog(1, "%s line %d, invalid value for path_grouping_policy: \"%s\"",
 			file, line_nr, buff);
-	FREE(buff);
+	free(buff);

 	return 0;
 }
@@ -1122,7 +1121,7 @@ max_fds_handler(struct config *conf, vector strvec, const char *file,
 		do_set_int(strvec, &conf->max_fds, 0, max_fds, file, line_nr,
 			   buff);

-	FREE(buff);
+	free(buff);

 	return 0;
 }
@@ -1160,7 +1159,7 @@ set_rr_weight(vector strvec, void *ptr, const char *file, int line_nr)
 	else
 		condlog(1, "%s line %d, invalid value for rr_weight: \"%s\"",
 			file, line_nr, buff);
-	FREE(buff);
+	free(buff);

 	return 0;
 }
@@ -1206,7 +1205,7 @@ set_pgfailback(vector strvec, void *ptr, const char *file, int line_nr)
 	else
 		do_set_int(strvec, ptr, 0, INT_MAX, file, line_nr, buff);

-	FREE(buff);
+	free(buff);

 	return 0;
 }
@@ -1254,7 +1253,7 @@ no_path_retry_helper(vector strvec, void *ptr, const char *file, int line_nr)
 	else
 		do_set_int(strvec, ptr, 1, INT_MAX, file, line_nr, buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -1330,18 +1329,18 @@ set_reservation_key(vector strvec, struct be64 *be64_ptr, uint8_t *flags_ptr,
 		*source_ptr = PRKEY_SOURCE_FILE;
 		*flags_ptr = 0;
 		put_be64(*be64_ptr, 0);
-		FREE(buff);
+		free(buff);
 		return 0;
 	}

 	if (parse_prkey_flags(buff, &prkey, &sa_flags) != 0) {
-		FREE(buff);
+		free(buff);
 		return 1;
 	}
 	*source_ptr = PRKEY_SOURCE_CONF;
 	*flags_ptr = sa_flags;
 	put_be64(*be64_ptr, prkey);
-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -1412,7 +1411,7 @@ set_off_int_undef(vector strvec, void *ptr, const char *file, int line_nr)
 	else
 		do_set_int(strvec, ptr, 1, INT_MAX, file, line_nr, buff);

-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -1562,7 +1561,7 @@ hw_vpd_vendor_handler(struct config *conf, vector strvec, const char *file,
 	condlog(1, "%s line %d, invalid value for vpd_vendor: \"%s\"",
 		file, line_nr, buff);
 out:
-	FREE(buff);
+	free(buff);
 	return 0;
 }

@@ -1854,7 +1853,7 @@ deprecated_handler(struct config *conf, vector strvec, const char *file,
 	if (!buff)
 		return 1;

-	FREE(buff);
+	free(buff);
 	return 0;
 }

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index 07ebe7d5..417f38b1 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -17,7 +17,6 @@

 #include "checkers.h"
 #include "vector.h"
-#include "memory.h"
 #include "util.h"
 #include "structs.h"
 #include "config.h"
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 4ba7f339..74c92155 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -10,7 +10,6 @@

 #include "checkers.h"
 #include "vector.h"
-#include "memory.h"
 #include "structs.h"
 #include "util.h"
 #include "debug.h"
@@ -27,7 +26,7 @@ merge_words(char **dst, const char *word)

 	dstlen = strlen(*dst);
 	len = dstlen + strlen(word) + 2;
-	*dst = REALLOC(*dst, len);
+	*dst = realloc(*dst, len);

 	if (!*dst) {
 		free(p);
@@ -146,11 +145,11 @@ int disassemble_map(const struct _vector *pathvec,
 			return 1;

 		if (merge_words(&mpp->features, word)) {
-			FREE(word);
+			free(word);
 			return 1;
 		}

-		FREE(word);
+		free(word);
 	}

 	/*
@@ -170,10 +169,10 @@ int disassemble_map(const struct _vector *pathvec,
 			return 1;

 		if (merge_words(&mpp->hwhandler, word)) {
-			FREE(word);
+			free(word);
 			return 1;
 		}
-		FREE(word);
+		free(word);
 	}

 	/*
@@ -185,7 +184,7 @@ int disassemble_map(const struct _vector *pathvec,
 		return 1;

 	num_pg = atoi(word);
-	FREE(word);
+	free(word);

 	if (num_pg > 0) {
 		if (!mpp->pg) {
@@ -207,7 +206,7 @@ int disassemble_map(const struct _vector *pathvec,
 		goto out;

 	mpp->nextpg = atoi(word);
-	FREE(word);
+	free(word);

 	for (i = 0; i < num_pg; i++) {
 		/*
@@ -232,7 +231,7 @@ int disassemble_map(const struct _vector *pathvec,

 			if (merge_words(&mpp->selector, word))
 				goto out1;
-			FREE(word);
+			free(word);
 		} else {
 			p += get_word(p, NULL);
 			p += get_word(p, NULL);
@@ -260,7 +259,7 @@ int disassemble_map(const struct _vector *pathvec,
 			goto out;

 		num_paths = atoi(word);
-		FREE(word);
+		free(word);

 		p += get_word(p, &word);

@@ -268,7 +267,7 @@ int disassemble_map(const struct _vector *pathvec,
 			goto out;

 		num_paths_args = atoi(word);
-		FREE(word);
+		free(word);

 		for (j = 0; j < num_paths; j++) {
 			pp = NULL;
@@ -294,7 +293,7 @@ int disassemble_map(const struct _vector *pathvec,
 			} else if (store_path(pgp->paths, pp))
 				goto out1;

-			FREE(word);
+			free(word);

 			pgp->id ^= (long)pp;
 			pp->pgindex = i + 1;
@@ -303,7 +302,7 @@ int disassemble_map(const struct _vector *pathvec,
 				if (k == 0) {
 					p += get_word(p, &word);
 					def_minio = atoi(word);
-					FREE(word);
+					free(word);

 					if (!strncmp(mpp->selector,
 						     "round-robin", 11)) {
@@ -324,7 +323,7 @@ int disassemble_map(const struct _vector *pathvec,
 	}
 	return 0;
 out1:
-	FREE(word);
+	free(word);
 out:
 	free_pgvec(mpp->pg, KEEP_PATHS);
 	mpp->pg = NULL;
@@ -358,7 +357,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 		return 1;

 	num_feature_args = atoi(word);
-	FREE(word);
+	free(word);

 	for (i = 0; i < num_feature_args; i++) {
 		if (i == 1) {
@@ -368,7 +367,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 				return 1;

 			mpp->queuedio = atoi(word);
-			FREE(word);
+			free(word);
 			continue;
 		}
 		/* unknown */
@@ -383,7 +382,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 		return 1;

 	num_hwhandler_args = atoi(word);
-	FREE(word);
+	free(word);

 	for (i = 0; i < num_hwhandler_args; i++)
 		p += get_word(p, NULL);
@@ -397,7 +396,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 		return 1;

 	num_pg = atoi(word);
-	FREE(word);
+	free(word);

 	if (num_pg == 0)
 		return 0;
@@ -434,7 +433,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 			pgp->status = PGSTATE_UNDEF;
 			break;
 		}
-		FREE(word);
+		free(word);

 		/*
 		 * PG Status (discarded, would be '0' anyway)
@@ -447,7 +446,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 			return 1;

 		num_paths = atoi(word);
-		FREE(word);
+		free(word);

 		p += get_word(p, &word);

@@ -455,7 +454,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 			return 1;

 		num_pg_args = atoi(word);
-		FREE(word);
+		free(word);

 		if (VECTOR_SIZE(pgp->paths) < num_paths)
 			return 1;
@@ -485,7 +484,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 			default:
 				break;
 			}
-			FREE(word);
+			free(word);
 			/*
 			 * fail count
 			 */
@@ -495,7 +494,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 				return 1;

 			pp->failcount = atoi(word);
-			FREE(word);
+			free(word);

 			/*
 			 * selector args
@@ -508,7 +507,7 @@ int disassemble_status(const char *params, struct multipath *mpp)
 						   &def_minio) == 1 &&
 					    def_minio != mpp->minio)
 							mpp->minio = def_minio;
-					FREE(word);
+					free(word);
 				} else
 					p += get_word(p, NULL);
 			}
diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
index d8d91f64..b74a9131 100644
--- a/libmultipath/io_err_stat.c
+++ b/libmultipath/io_err_stat.c
@@ -22,9 +22,9 @@
 #include <errno.h>
 #include <sys/mman.h>
 #include <sys/select.h>
+#include <stdio.h>

 #include "vector.h"
-#include "memory.h"
 #include "checkers.h"
 #include "config.h"
 #include "structs.h"
@@ -132,7 +132,7 @@ static int setup_directio_ctx(struct io_err_stat_path *p)
 	if (p->fd < 0)
 		return 1;

-	p->dio_ctx_array = MALLOC(sizeof(struct dio_ctx) * CONCUR_NR_EVENT);
+	p->dio_ctx_array = calloc(1, sizeof(struct dio_ctx) * CONCUR_NR_EVENT);
 	if (!p->dio_ctx_array)
 		goto fail_close;

@@ -154,7 +154,8 @@ deinit:
 	for (i = 0; i < CONCUR_NR_EVENT; i++)
 		deinit_each_dio_ctx(p->dio_ctx_array + i);
 free_pdctx:
-	FREE(p->dio_ctx_array);
+	free(p->dio_ctx_array);
+	p->dio_ctx_array = NULL;
 fail_close:
 	close(p->fd);

@@ -174,19 +175,19 @@ static void free_io_err_stat_path(struct io_err_stat_path *p)

 	for (i = 0; i < CONCUR_NR_EVENT; i++)
 		deinit_each_dio_ctx(p->dio_ctx_array + i);
-	FREE(p->dio_ctx_array);
+	free(p->dio_ctx_array);

 	if (p->fd > 0)
 		close(p->fd);
 free_path:
-	FREE(p);
+	free(p);
 }

 static struct io_err_stat_path *alloc_io_err_stat_path(void)
 {
 	struct io_err_stat_path *p;

-	p = (struct io_err_stat_path *)MALLOC(sizeof(*p));
+	p = (struct io_err_stat_path *)calloc(1, sizeof(*p));
 	if (!p)
 		return NULL;

diff --git a/libmultipath/log.c b/libmultipath/log.c
index f41efb5b..45b3ed88 100644
--- a/libmultipath/log.c
+++ b/libmultipath/log.c
@@ -11,7 +11,6 @@
 #include <time.h>
 #include <pthread.h>

-#include "memory.h"
 #include "log.h"
 #include "util.h"

@@ -44,7 +43,7 @@ static void dump_logarea (void)
 static int logarea_init (int size)
 {
 	logdbg(stderr,"enter logarea_init\n");
-	la = (struct logarea *)MALLOC(sizeof(struct logarea));
+	la = (struct logarea *)calloc(1, sizeof(struct logarea));

 	if (!la)
 		return 1;
@@ -52,9 +51,10 @@ static int logarea_init (int size)
 	if (size < MAX_MSG_SIZE)
 		size = DEFAULT_AREA_SIZE;

-	la->start = MALLOC(size);
+	la->start = calloc(1, size);
 	if (!la->start) {
-		FREE(la);
+		free(la);
+		la = NULL;
 		return 1;
 	}

@@ -63,11 +63,12 @@ static int logarea_init (int size)
 	la->head = la->start;
 	la->tail = la->start;

-	la->buff = MALLOC(MAX_MSG_SIZE + sizeof(struct logmsg));
+	la->buff = calloc(1, MAX_MSG_SIZE + sizeof(struct logmsg));

 	if (!la->buff) {
-		FREE(la->start);
-		FREE(la);
+		free(la->start);
+		free(la);
+		la = NULL;
 		return 1;
 	}
 	return 0;
@@ -94,9 +95,10 @@ int log_init(char *program_name, int size)

 static void free_logarea (void)
 {
-	FREE(la->start);
-	FREE(la->buff);
-	FREE(la);
+	free(la->start);
+	free(la->buff);
+	free(la);
+	la = NULL;
 	return;
 }

diff --git a/libmultipath/log_pthread.c b/libmultipath/log_pthread.c
index 65992101..69b441bf 100644
--- a/libmultipath/log_pthread.c
+++ b/libmultipath/log_pthread.c
@@ -8,8 +8,6 @@
 #include <pthread.h>
 #include <sys/mman.h>

-#include "memory.h"
-
 #include "log_pthread.h"
 #include "log.h"
 #include "lock.h"
diff --git a/libmultipath/memory.c b/libmultipath/memory.c
deleted file mode 100644
index 75146428..00000000
--- a/libmultipath/memory.c
+++ /dev/null
@@ -1,444 +0,0 @@
-/*
- * Part:        Memory management framework. This framework is used to
- *              find any memory leak.
- *
- * Version:     $Id: memory.c,v 1.1.11 2005/03/01 01:22:13 acassen Exp $
- *
- * Authors:     Alexandre Cassen, <acassen@linux-vs.org>
- *              Jan Holmberg, <jan@artech.net>
- *
- *              This program is distributed in the hope that it will be useful,
- *              but WITHOUT ANY WARRANTY; without even the implied warranty of
- *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *              See the GNU General Public License for more details.
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
- * Copyright (C) 2001-2005 Alexandre Cassen, <acassen@linux-vs.org>
- */
-
-#include <assert.h>
-#include "memory.h"
-
-/*
- * Memory management. in debug mode,
- * help finding eventual memory leak.
- * Allocation memory types manipulated are :
- *
- * +type+--------meaning--------+
- * ! 0  ! Free slot             !
- * ! 1  ! Overrun               !
- * ! 2  ! free null             !
- * ! 3  ! realloc null          !
- * ! 4  ! Not previus allocated !
- * ! 8  ! Last free list        !
- * ! 9  ! Allocated             !
- * +----+-----------------------+
- *
- * global variable debug bit 9 ( 512 ) used to
- * flag some memory error.
- *
- */
-
-#ifdef _DEBUG_
-
-typedef struct {
-	int type;
-	int line;
-	char *func;
-	char *file;
-	void *ptr;
-	unsigned long size;
-	long csum;
-} MEMCHECK;
-
-/* Last free pointers */
-static MEMCHECK free_list[256];
-
-static MEMCHECK alloc_list[MAX_ALLOC_LIST];
-static int number_alloc_list = 0;
-static int n = 0;		/* Alloc list pointer */
-static int f = 0;		/* Free list pointer */
-
-void *
-dbg_malloc(unsigned long size, char *file, char *function, int line)
-{
-	void *buf;
-	int i = 0;
-	long check;
-
-	buf = zalloc(size + sizeof (long));
-
-	check = 0xa5a5 + size;
-	*(long *) ((char *) buf + size) = check;
-
-	while (i < number_alloc_list) {
-		if (alloc_list[i].type == 0)
-			break;
-		i++;
-	}
-
-	if (i == number_alloc_list)
-		number_alloc_list++;
-
-	assert(number_alloc_list < MAX_ALLOC_LIST);
-
-	alloc_list[i].ptr = buf;
-	alloc_list[i].size = size;
-	alloc_list[i].file = file;
-	alloc_list[i].func = function;
-	alloc_list[i].line = line;
-	alloc_list[i].csum = check;
-	alloc_list[i].type = 9;
-
-	if (debug & 1)
-		printf("zalloc[%3d:%3d], %p, %4ld at %s, %3d, %s\n",
-		       i, number_alloc_list, buf, size, file, line,
-		       function);
-
-	n++;
-	return buf;
-}
-
-char *
-dbg_strdup(char *str, char *file, char *function, int line)
-{
-	void *buf;
-	int i = 0;
-	long check;
-	long size;
-
-	size = strlen(str) + 1;
-	buf = zalloc(size + sizeof (long));
-	strcat(buf, str);
-
-	check = 0xa5a5 + size;
-	*(long *) ((char *) buf + size) = check;
-
-	while (i < number_alloc_list) {
-		if (alloc_list[i].type == 0)
-			break;
-		i++;
-	}
-
-	if (i == number_alloc_list)
-		number_alloc_list++;
-
-	assert(number_alloc_list < MAX_ALLOC_LIST);
-
-	alloc_list[i].ptr = buf;
-	alloc_list[i].size = size;
-	alloc_list[i].file = file;
-	alloc_list[i].func = function;
-	alloc_list[i].line = line;
-	alloc_list[i].csum = check;
-	alloc_list[i].type = 9;
-
-	if (debug & 1)
-		printf("strdup[%3d:%3d], %p, %4ld at %s, %3d, %s\n",
-		       i, number_alloc_list, buf, size, file, line,
-		       function);
-
-	n++;
-	return buf;
-}
-
-
-
-/* Display a buffer into a HEXA formatted output */
-static void
-dump_buffer(char *buff, int count)
-{
-	int i, j, c;
-	int printnext = 1;
-
-	if (count % 16)
-		c = count + (16 - count % 16);
-	else
-		c = count;
-
-	for (i = 0; i < c; i++) {
-		if (printnext) {
-			printnext--;
-			printf("%.4x ", i & 0xffff);
-		}
-		if (i < count)
-			printf("%3.2x", buff[i] & 0xff);
-		else
-			printf("   ");
-		if (!((i + 1) % 8)) {
-			if ((i + 1) % 16)
-				printf(" -");
-			else {
-				printf("   ");
-				for (j = i - 15; j <= i; j++)
-					if (j < count) {
-						if ((buff[j] & 0xff) >= 0x20
-						    && (buff[j] & 0xff) <= 0x7e)
-							printf("%c",
-							       buff[j] & 0xff);
-						else
-							printf(".");
-					} else
-						printf(" ");
-				printf("\n");
-				printnext = 1;
-			}
-		}
-	}
-}
-
-int
-dbg_free(void *buffer, char *file, char *function, int line)
-{
-	int i = 0;
-	void *buf;
-
-	/* If nullpointer remember */
-	if (buffer == NULL) {
-		i = number_alloc_list++;
-
-		assert(number_alloc_list < MAX_ALLOC_LIST);
-
-		alloc_list[i].ptr = buffer;
-		alloc_list[i].size = 0;
-		alloc_list[i].file = file;
-		alloc_list[i].func = function;
-		alloc_list[i].line = line;
-		alloc_list[i].type = 2;
-		if (debug & 1)
-			printf("free NULL in %s, %3d, %s\n", file,
-			       line, function);
-
-		debug |= 512;	/* Memory Error detect */
-
-		return n;
-	} else
-		buf = buffer;
-
-	while (i < number_alloc_list) {
-		if (alloc_list[i].type == 9 && alloc_list[i].ptr == buf) {
-			if (*
-			    ((long *) ((char *) alloc_list[i].ptr +
-				       alloc_list[i].size)) ==
-			    alloc_list[i].csum)
-				alloc_list[i].type = 0;	/* Release */
-			else {
-				alloc_list[i].type = 1;	/* Overrun */
-				if (debug & 1) {
-					printf("free corrupt, buffer overrun [%3d:%3d], %p, %4ld at %s, %3d, %s\n",
-					       i, number_alloc_list,
-					       buf, alloc_list[i].size, file,
-					       line, function);
-					dump_buffer(alloc_list[i].ptr,
-						    alloc_list[i].size + sizeof (long));
-					printf("Check_sum\n");
-					dump_buffer((char *) &alloc_list[i].csum,
-						    sizeof(long));
-
-					debug |= 512;	/* Memory Error detect */
-				}
-			}
-			break;
-		}
-		i++;
-	}
-
-	/*  Not found */
-	if (i == number_alloc_list) {
-		printf("Free ERROR %p\n", buffer);
-		number_alloc_list++;
-
-		assert(number_alloc_list < MAX_ALLOC_LIST);
-
-		alloc_list[i].ptr = buf;
-		alloc_list[i].size = 0;
-		alloc_list[i].file = file;
-		alloc_list[i].func = function;
-		alloc_list[i].line = line;
-		alloc_list[i].type = 4;
-		debug |= 512;
-
-		return n;
-	}
-
-	if (buffer != NULL)
-		xfree(buffer);
-
-	if (debug & 1)
-		printf("free  [%3d:%3d], %p, %4ld at %s, %3d, %s\n",
-		       i, number_alloc_list, buf,
-		       alloc_list[i].size, file, line, function);
-
-	free_list[f].file = file;
-	free_list[f].line = line;
-	free_list[f].func = function;
-	free_list[f].ptr = buffer;
-	free_list[f].type = 8;
-	free_list[f].csum = i;	/* Using this field for row id */
-
-	f++;
-	f &= 255;
-	n--;
-
-	return n;
-}
-
-void
-dbg_free_final(char *banner)
-{
-	unsigned int sum = 0, overrun = 0, badptr = 0;
-	int i, j;
-	i = 0;
-
-	printf("\n---[ Memory dump for (%s)]---\n\n", banner);
-
-	while (i < number_alloc_list) {
-		switch (alloc_list[i].type) {
-		case 3:
-			badptr++;
-			printf
-			    ("null pointer to realloc(nil,%ld)! at %s, %3d, %s\n",
-			     alloc_list[i].size, alloc_list[i].file,
-			     alloc_list[i].line, alloc_list[i].func);
-			break;
-		case 4:
-			badptr++;
-			printf
-			    ("pointer not found in table to free(%p) [%3d:%3d], at %s, %3d, %s\n",
-			     alloc_list[i].ptr, i, number_alloc_list,
-			     alloc_list[i].file, alloc_list[i].line,
-			     alloc_list[i].func);
-			for (j = 0; j < 256; j++)
-				if (free_list[j].ptr == alloc_list[i].ptr)
-					if (free_list[j].type == 8)
-						printf
-						    ("  -> pointer already released at [%3d:%3d], at %s, %3d, %s\n",
-						     (int) free_list[j].csum,
-						     number_alloc_list,
-						     free_list[j].file,
-						     free_list[j].line,
-						     free_list[j].func);
-			break;
-		case 2:
-			badptr++;
-			printf("null pointer to free(nil)! at %s, %3d, %s\n",
-			       alloc_list[i].file, alloc_list[i].line,
-			       alloc_list[i].func);
-			break;
-		case 1:
-			overrun++;
-			printf("%p [%3d:%3d], %4ld buffer overrun!:\n",
-			       alloc_list[i].ptr, i, number_alloc_list,
-			       alloc_list[i].size);
-			printf(" --> source of malloc: %s, %3d, %s\n",
-			       alloc_list[i].file, alloc_list[i].line,
-			       alloc_list[i].func);
-			break;
-		case 9:
-			sum += alloc_list[i].size;
-			printf("%p [%3d:%3d], %4ld not released!:\n",
-			       alloc_list[i].ptr, i, number_alloc_list,
-			       alloc_list[i].size);
-			printf(" --> source of malloc: %s, %3d, %s\n",
-			       alloc_list[i].file, alloc_list[i].line,
-			       alloc_list[i].func);
-			break;
-		}
-		i++;
-	}
-
-	printf("\n\n---[ Memory dump summary for (%s) ]---\n", banner);
-	printf("Total number of bytes not freed...: %d\n", sum);
-	printf("Number of entries not freed.......: %d\n", n);
-	printf("Maximum allocated entries.........: %d\n", number_alloc_list);
-	printf("Number of bad entries.............: %d\n", badptr);
-	printf("Number of buffer overrun..........: %d\n\n", overrun);
-
-	if (sum || n || badptr || overrun)
-		printf("=> Program seems to have some memory problem !!!\n\n");
-	else
-		printf("=> Program seems to be memory allocation safe...\n\n");
-}
-
-void *
-dbg_realloc(void *buffer, unsigned long size, char *file, char *function,
-		   int line)
-{
-	int i = 0;
-	void *buf, *buf2;
-	long check;
-
-	if (buffer == NULL) {
-		printf("realloc %p %s, %3d %s\n", buffer, file, line, function);
-		i = number_alloc_list++;
-
-		assert(number_alloc_list < MAX_ALLOC_LIST);
-
-		alloc_list[i].ptr = NULL;
-		alloc_list[i].size = 0;
-		alloc_list[i].file = file;
-		alloc_list[i].func = function;
-		alloc_list[i].line = line;
-		alloc_list[i].type = 3;
-		return dbg_malloc(size, file, function, line);
-	}
-
-	buf = buffer;
-
-	while (i < number_alloc_list) {
-		if (alloc_list[i].ptr == buf) {
-			buf = alloc_list[i].ptr;
-			break;
-		}
-		i++;
-	}
-
-	/* not found */
-	if (i == number_alloc_list) {
-		printf("realloc ERROR no matching zalloc %p \n", buffer);
-		number_alloc_list++;
-
-		assert(number_alloc_list < MAX_ALLOC_LIST);
-
-		alloc_list[i].ptr = buf;
-		alloc_list[i].size = 0;
-		alloc_list[i].file = file;
-		alloc_list[i].func = function;
-		alloc_list[i].line = line;
-		alloc_list[i].type = 9;
-		debug |= 512;	/* Memory Error detect */
-		return NULL;
-	}
-
-	buf2 = ((char *) buf) + alloc_list[i].size;
-
-	if (*(long *) (buf2) != alloc_list[i].csum) {
-		alloc_list[i].type = 1;
-		debug |= 512;	/* Memory Error detect */
-	}
-	buf = realloc(buffer, size + sizeof (long));
-
-	check = 0xa5a5 + size;
-	*(long *) ((char *) buf + size) = check;
-	alloc_list[i].csum = check;
-
-	if (debug & 1)
-		printf("realloc [%3d:%3d] %p, %4ld %s %d %s -> %p %4ld %s %d %s\n",
-		       i, number_alloc_list, alloc_list[i].ptr,
-		       alloc_list[i].size, alloc_list[i].file, alloc_list[i].line, alloc_list[i].func,
-		       buf, size, file, line, function);
-
-	alloc_list[i].ptr = buf;
-	alloc_list[i].size = size;
-	alloc_list[i].file = file;
-	alloc_list[i].line = line;
-	alloc_list[i].func = function;
-
-	return buf;
-}
-
-#endif
diff --git a/libmultipath/memory.h b/libmultipath/memory.h
deleted file mode 100644
index a3c478e2..00000000
--- a/libmultipath/memory.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/*
- * Part:        memory.c include file.
- *
- * Version:     $Id: memory.h,v 1.1.11 2005/03/01 01:22:13 acassen Exp $
- *
- * Authors:     Alexandre Cassen, <acassen@linux-vs.org>
- *              Jan Holmberg, <jan@artech.net>
- *
- *              This program is distributed in the hope that it will be useful,
- *              but WITHOUT ANY WARRANTY; without even the implied warranty of
- *              MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *              See the GNU General Public License for more details.
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
- * Copyright (C) 2001-2005 Alexandre Cassen, <acassen@linux-vs.org>
- */
-
-#ifndef _MEMORY_H
-#define _MEMORY_H
-
-/* system includes */
-#include <stdio.h>
-#include <stdint.h>
-#include <stdlib.h>
-#include <string.h>
-
-/* Local defines */
-#ifdef _DEBUG_
-
-int debug;
-
-#define MAX_ALLOC_LIST 2048
-
-#define MALLOC(n)    ( dbg_malloc((n), \
-		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
-#define FREE(b)      ( dbg_free((b), \
-		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
-#define REALLOC(b,n) ( dbg_realloc((b), (n), \
-		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
-#define STRDUP(n)    ( dbg_strdup((n), \
-		      (__FILE__), (char *)(__FUNCTION__), (__LINE__)) )
-
-/* Memory debug prototypes defs */
-extern void *dbg_malloc(unsigned long, char *, char *, int);
-extern int dbg_free(void *, char *, char *, int);
-extern void *dbg_realloc(void *, unsigned long, char *, char *, int);
-extern char *dbg_strdup(char *, char *, char *, int);
-extern void dbg_free_final(char *);
-
-#else
-
-#define MALLOC(n)    (calloc(1,(n)))
-#define FREE(p)      do { free(p); p = NULL; } while(0)
-#define REALLOC(p,n) (realloc((p),(n)))
-#define STRDUP(n)    (strdup(n))
-
-#endif
-
-/* Common defines */
-#define FREE_PTR(P) if((P)) FREE((P));
-
-#endif
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 68262d0e..014d9b83 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -23,7 +23,6 @@
 #include "vector.h"
 #include "config.h"
 #include "parser.h"
-#include "memory.h"
 #include "debug.h"
 #include "strbuf.h"

@@ -39,13 +38,13 @@ keyword_alloc(vector keywords, char *string,
 {
 	struct keyword *keyword;

-	keyword = (struct keyword *) MALLOC(sizeof (struct keyword));
+	keyword = (struct keyword *)calloc(1, sizeof (struct keyword));

 	if (!keyword)
 		return 1;

 	if (!vector_alloc_slot(keywords)) {
-		FREE(keyword);
+		free(keyword);
 		return 1;
 	}
 	keyword->string = string;
@@ -115,7 +114,7 @@ free_keywords(vector keywords)
 		keyword = VECTOR_SLOT(keywords, i);
 		if (keyword->sub)
 			free_keywords(keyword->sub);
-		FREE(keyword);
+		free(keyword);
 	}
 	vector_free(keywords);
 }
@@ -245,7 +244,7 @@ alloc_strvec(char *string)
 		start = cp;
 		if (*cp == '"' && !(in_string && *(cp + 1) == '"')) {
 			cp++;
-			token = MALLOC(sizeof(quote_marker));
+			token = calloc(1, sizeof(quote_marker));

 			if (!token)
 				goto out;
@@ -256,7 +255,7 @@ alloc_strvec(char *string)
 			else
 				in_string = 1;
 		} else if (!in_string && (*cp == '{' || *cp == '}')) {
-			token = MALLOC(2);
+			token = malloc(2);

 			if (!token)
 				goto out;
@@ -283,7 +282,7 @@ alloc_strvec(char *string)
 			}

 			strlen = cp - start;
-			token = MALLOC(strlen + 1);
+			token = calloc(1, strlen + 1);

 			if (!token)
 				goto out;
@@ -350,7 +349,7 @@ set_value(vector strvec)
 				(char *)VECTOR_SLOT(strvec, 0));
 			return NULL;
 		}
-		alloc = MALLOC(sizeof (char) * (size + 1));
+		alloc = calloc(1, sizeof (char) * (size + 1));
 		if (alloc)
 			memcpy(alloc, str, size);
 		else
@@ -358,7 +357,7 @@ set_value(vector strvec)
 		return alloc;
 	}
 	/* Even empty quotes counts as a value (An empty string) */
-	alloc = (char *) MALLOC(sizeof (char));
+	alloc = (char *)calloc(1, sizeof (char));
 	if (!alloc)
 		goto oom;
 	for (i = 2; i < VECTOR_SIZE(strvec); i++) {
@@ -375,9 +374,9 @@ set_value(vector strvec)
 		/* The first +1 is for the NULL byte. The rest are for the
 		 * spaces between words */
 		len += strlen(str) + 1;
-		alloc = REALLOC(alloc, sizeof (char) * len);
+		alloc = realloc(alloc, sizeof (char) * len);
 		if (!alloc) {
-			FREE(tmp);
+			free(tmp);
 			goto oom;
 		}
 		if (*alloc != '\0')
@@ -518,7 +517,7 @@ process_stream(struct config *conf, FILE *stream, vector keywords,
 	if (!uniques)
 		return 1;

-	buf = MALLOC(MAXBUF);
+	buf = calloc(1, MAXBUF);

 	if (!buf) {
 		vector_free(uniques);
@@ -590,7 +589,7 @@ process_stream(struct config *conf, FILE *stream, vector keywords,
 	if (kw_level == 1)
 		condlog(1, "missing '%s' at end of %s", EOB, file);
 out:
-	FREE(buf);
+	free(buf);
 	free_uniques(uniques);
 	return r;
 }
diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
index 0e551098..10b44d37 100644
--- a/libmultipath/pgpolicies.c
+++ b/libmultipath/pgpolicies.c
@@ -8,7 +8,6 @@

 #include "checkers.h"
 #include "util.h"
-#include "memory.h"
 #include "vector.h"
 #include "structs.h"
 #include "pgpolicies.h"
@@ -244,12 +243,12 @@ int group_by_match(struct multipath * mp, vector paths,
 			}
 		}
 	}
-	FREE(bitmap);
+	free(bitmap);
 	return 0;
 out2:
 	free_pathgroup(pgp, KEEP_PATHS);
 out1:
-	FREE(bitmap);
+	free(bitmap);
 out:
 	free_pgvec(mp->pg, KEEP_PATHS);
 	mp->pg = NULL;
diff --git a/libmultipath/prio.c b/libmultipath/prio.c
index c92bde7f..ef68cd03 100644
--- a/libmultipath/prio.c
+++ b/libmultipath/prio.c
@@ -51,7 +51,7 @@ static struct prio * alloc_prio (void)
 {
 	struct prio *p;

-	p = MALLOC(sizeof(struct prio));
+	p = calloc(1, sizeof(struct prio));
 	if (p) {
 		INIT_LIST_HEAD(&p->node);
 		p->refcount = 1;
@@ -77,7 +77,7 @@ void free_prio (struct prio * p)
 				p->name, dlerror());
 		}
 	}
-	FREE(p);
+	free(p);
 }

 void cleanup_prio(void)
diff --git a/libmultipath/prio.h b/libmultipath/prio.h
index 26754f78..66c7936e 100644
--- a/libmultipath/prio.h
+++ b/libmultipath/prio.h
@@ -11,7 +11,6 @@
 struct path;

 #include "list.h"
-#include "memory.h"
 #include "defaults.h"

 /*
diff --git a/libmultipath/prioritizers/path_latency.c b/libmultipath/prioritizers/path_latency.c
index eeee01e1..078226df 100644
--- a/libmultipath/prioritizers/path_latency.c
+++ b/libmultipath/prioritizers/path_latency.c
@@ -158,7 +158,7 @@ static int get_ionum_and_basenum(char *args, int *ionum, double *basenum)
 		return 0;
 	}

-	arg = temp = STRDUP(args);
+	arg = temp = strdup(args);
 	if (!arg)
 		return 0;

@@ -185,10 +185,10 @@ static int get_ionum_and_basenum(char *args, int *ionum, double *basenum)
 	if (check_args_valid(*ionum, *basenum) == 0)
 		goto out;

-	FREE(arg);
+	free(arg);
 	return 1;
 out:
-	FREE(arg);
+	free(arg);
 	return 0;
 }

diff --git a/libmultipath/prioritizers/weightedpath.c b/libmultipath/prioritizers/weightedpath.c
index 32d1cf0c..6f20e8f0 100644
--- a/libmultipath/prioritizers/weightedpath.c
+++ b/libmultipath/prioritizers/weightedpath.c
@@ -29,7 +29,6 @@
 #include "weightedpath.h"
 #include "config.h"
 #include "structs.h"
-#include "memory.h"
 #include "debug.h"
 #include <regex.h>
 #include "structs_vec.h"
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index b2876670..f7b8119f 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -7,7 +7,6 @@

 #include "nvme-lib.h"
 #include "checkers.h"
-#include "memory.h"
 #include "vector.h"
 #include "structs.h"
 #include "config.h"
@@ -255,7 +254,7 @@ int select_selector(struct config *conf, struct multipath * mp)
 	mp_set_conf(selector);
 	mp_set_default(selector, DEFAULT_SELECTOR);
 out:
-	mp->selector = STRDUP(mp->selector);
+	mp->selector = strdup(mp->selector);
 	condlog(3, "%s: path_selector = \"%s\" %s", mp->alias, mp->selector,
 		origin);
 	return 0;
@@ -303,7 +302,7 @@ int select_alias(struct config *conf, struct multipath * mp)
 	const char *origin = NULL;

 	if (mp->mpe && mp->mpe->alias) {
-		mp->alias = STRDUP(mp->mpe->alias);
+		mp->alias = strdup(mp->mpe->alias);
 		origin = multipaths_origin;
 		goto out;
 	}
@@ -329,7 +328,7 @@ int select_alias(struct config *conf, struct multipath * mp)
 	}
 out:
 	if (mp->alias == NULL) {
-		mp->alias = STRDUP(mp->wwid);
+		mp->alias = strdup(mp->wwid);
 		origin = "(setting: default to WWID)";
 	}
 	if (mp->alias)
@@ -399,7 +398,7 @@ int select_features(struct config *conf, struct multipath *mp)
 	mp_set_conf(features);
 	mp_set_default(features, DEFAULT_FEATURES);
 out:
-	mp->features = STRDUP(mp->features);
+	mp->features = strdup(mp->features);

 	reconcile_features_with_options(mp->alias, &mp->features,
 					&mp->no_path_retry,
@@ -477,7 +476,7 @@ out:
 		mp->hwhandler = DEFAULT_HWHANDLER;
 		origin = tpgs_origin;
 	}
-	mp->hwhandler = STRDUP(mp->hwhandler);
+	mp->hwhandler = strdup(mp->hwhandler);
 	condlog(3, "%s: hardware_handler = \"%s\" %s", mp->alias, mp->hwhandler,
 		origin);
 	return 0;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 6e5a1038..d1b8aa33 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -8,7 +8,6 @@
 #include <libudev.h>

 #include "checkers.h"
-#include "memory.h"
 #include "vector.h"
 #include "util.h"
 #include "structs.h"
@@ -25,14 +24,14 @@ alloc_adaptergroup(void)
 {
 	struct adapter_group *agp;

-	agp = (struct adapter_group *)MALLOC(sizeof(struct adapter_group));
+	agp = (struct adapter_group *)calloc(1, sizeof(struct adapter_group));

 	if (!agp)
 		return NULL;

 	agp->host_groups = vector_alloc();
 	if (!agp->host_groups) {
-		FREE(agp);
+		free(agp);
 		agp = NULL;
 	}
 	return agp;
@@ -45,7 +44,7 @@ void free_adaptergroup(vector adapters)

 	vector_foreach_slot(adapters, agp, i) {
 		free_hostgroup(agp->host_groups);
-		FREE(agp);
+		free(agp);
 	}
 	vector_free(adapters);
 }
@@ -60,7 +59,7 @@ void free_hostgroup(vector hostgroups)

 	vector_foreach_slot(hostgroups, hgp, i) {
 		vector_free(hgp->paths);
-		FREE(hgp);
+		free(hgp);
 	}
 	vector_free(hostgroups);
 }
@@ -70,7 +69,7 @@ alloc_hostgroup(void)
 {
 	struct host_group *hgp;

-	hgp = (struct host_group *)MALLOC(sizeof(struct host_group));
+	hgp = (struct host_group *)calloc(1, sizeof(struct host_group));

 	if (!hgp)
 		return NULL;
@@ -78,7 +77,7 @@ alloc_hostgroup(void)
 	hgp->paths = vector_alloc();

 	if (!hgp->paths) {
-		FREE(hgp);
+		free(hgp);
 		hgp = NULL;
 	}
 	return hgp;
@@ -89,7 +88,7 @@ alloc_path (void)
 {
 	struct path * pp;

-	pp = (struct path *)MALLOC(sizeof(struct path));
+	pp = (struct path *)calloc(1, sizeof(struct path));

 	if (pp) {
 		pp->initialized = INIT_NEW;
@@ -152,7 +151,7 @@ free_path (struct path * pp)

 	vector_free(pp->hwe);

-	FREE(pp);
+	free(pp);
 }

 void
@@ -176,7 +175,7 @@ alloc_pathgroup (void)
 {
 	struct pathgroup * pgp;

-	pgp = (struct pathgroup *)MALLOC(sizeof(struct pathgroup));
+	pgp = (struct pathgroup *)calloc(1, sizeof(struct pathgroup));

 	if (!pgp)
 		return NULL;
@@ -184,7 +183,7 @@ alloc_pathgroup (void)
 	pgp->paths = vector_alloc();

 	if (!pgp->paths) {
-		FREE(pgp);
+		free(pgp);
 		return NULL;
 	}

@@ -199,7 +198,7 @@ free_pathgroup (struct pathgroup * pgp, enum free_path_mode free_paths)
 		return;

 	free_pathvec(pgp->paths, free_paths);
-	FREE(pgp);
+	free(pgp);
 }

 void
@@ -222,7 +221,7 @@ alloc_multipath (void)
 {
 	struct multipath * mpp;

-	mpp = (struct multipath *)MALLOC(sizeof(struct multipath));
+	mpp = (struct multipath *)calloc(1, sizeof(struct multipath));

 	if (mpp) {
 		mpp->bestpg = 1;
@@ -251,17 +250,17 @@ void free_multipath_attributes(struct multipath *mpp)
 		return;

 	if (mpp->selector) {
-		FREE(mpp->selector);
+		free(mpp->selector);
 		mpp->selector = NULL;
 	}

 	if (mpp->features) {
-		FREE(mpp->features);
+		free(mpp->features);
 		mpp->features = NULL;
 	}

 	if (mpp->hwhandler) {
-		FREE(mpp->hwhandler);
+		free(mpp->hwhandler);
 		mpp->hwhandler = NULL;
 	}
 }
@@ -275,12 +274,12 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 	free_multipath_attributes(mpp);

 	if (mpp->alias) {
-		FREE(mpp->alias);
+		free(mpp->alias);
 		mpp->alias = NULL;
 	}

 	if (mpp->dmi) {
-		FREE(mpp->dmi);
+		free(mpp->dmi);
 		mpp->dmi = NULL;
 	}

@@ -305,8 +304,8 @@ free_multipath (struct multipath * mpp, enum free_path_mode free_paths)
 		vector_free(mpp->hwe);
 		mpp->hwe = NULL;
 	}
-	FREE_PTR(mpp->mpcontext);
-	FREE(mpp);
+	free(mpp->mpcontext);
+	free(mpp);
 }

 void
@@ -633,7 +632,7 @@ int add_feature(char **f, const char *n)
 	for (d = c; d >= 10; d /= 10)
 		l++;

-	t = MALLOC(l + 1);
+	t = calloc(1, l + 1);
 	if (!t)
 		return 1;

@@ -644,7 +643,7 @@ int add_feature(char **f, const char *n)

 	snprintf(t, l + 1, "%0d%s %s", c, e, n);

-	FREE(*f);
+	free(*f);
 	*f = t;

 	return 0;
@@ -696,7 +695,7 @@ int remove_feature(char **f, const char *o)

 	/* Quick exit if all features have been removed */
 	if (c == 0) {
-		n = MALLOC(2);
+		n = malloc(2);
 		if (!n)
 			return 1;
 		strcpy(n, "0");
@@ -711,7 +710,7 @@ int remove_feature(char **f, const char *o)

 	/* Update feature count space */
 	l = strlen(*f) - d;
-	n =  MALLOC(l + 1);
+	n =  malloc(l + 1);
 	if (!n)
 		return 1;

@@ -724,7 +723,7 @@ int remove_feature(char **f, const char *o)
 	p = strchr(*f, ' ');
 	if (!p) {
 		/* Internal error, feature string inconsistent */
-		FREE(n);
+		free(n);
 		return 1;
 	}
 	while (*p == ' ')
@@ -753,7 +752,7 @@ int remove_feature(char **f, const char *o)
 	}

 out:
-	FREE(*f);
+	free(*f);
 	*f = n;

 	return 0;
diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 9ff145f2..f45dbee1 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -287,7 +287,7 @@ int sysfs_check_holders(char * check_devt, char * new_devt)
 			table_name, check_devt, new_devt);

 		dm_reassign_table(table_name, check_devt, new_devt);
-		FREE(table_name);
+		free(table_name);
 	}
 	closedir(dirfd);

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 4265904b..fd4556ca 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -43,7 +43,6 @@
 #include <libudev.h>
 #include <errno.h>

-#include "memory.h"
 #include "debug.h"
 #include "list.h"
 #include "uevent.h"
@@ -81,7 +80,7 @@ int is_uevent_busy(void)

 struct uevent * alloc_uevent (void)
 {
-	struct uevent *uev = MALLOC(sizeof(struct uevent));
+	struct uevent *uev = calloc(1, sizeof(struct uevent));

 	if (uev) {
 		INIT_LIST_HEAD(&uev->node);
@@ -100,7 +99,7 @@ static void uevq_cleanup(struct list_head *tmpq)

 		if (uev->udev)
 			udev_device_unref(uev->udev);
-		FREE(uev);
+		free(uev);
 	}
 }

@@ -309,7 +308,7 @@ uevent_prepare(struct list_head *tmpq)
 			list_del_init(&uev->node);
 			if (uev->udev)
 				udev_device_unref(uev->udev);
-			FREE(uev);
+			free(uev);
 			continue;
 		}

@@ -337,7 +336,7 @@ uevent_filter(struct uevent *later, struct list_head *tmpq)
 			list_del_init(&earlier->node);
 			if (earlier->udev)
 				udev_device_unref(earlier->udev);
-			FREE(earlier);
+			free(earlier);
 		}
 	}
 }
@@ -391,7 +390,7 @@ service_uevq(struct list_head *tmpq)

 		if (uev->udev)
 			udev_device_unref(uev->udev);
-		FREE(uev);
+		free(uev);
 	}
 }

@@ -492,7 +491,7 @@ static struct uevent *uevent_from_udev_device(struct udev_device *dev)
 	if (!uev->devpath || ! uev->action) {
 		udev_device_unref(dev);
 		condlog(1, "uevent missing necessary fields");
-		FREE(uev);
+		free(uev);
 		return NULL;
 	}
 	uev->udev = dev;
diff --git a/libmultipath/util.c b/libmultipath/util.c
index b3ed5ff9..b7952a53 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -17,7 +17,6 @@

 #include "util.h"
 #include "debug.h"
-#include "memory.h"
 #include "checkers.h"
 #include "vector.h"
 #include "structs.h"
@@ -110,7 +109,7 @@ get_word (const char *sentence, char **word)
 	if (!word)
 		return skip + len;

-	*word = MALLOC(len + 1);
+	*word = calloc(1, len + 1);

 	if (!*word) {
 		condlog(0, "get_word : oom");
@@ -414,8 +413,8 @@ void free_scandir_result(struct scandir_result *res)
 	int i;

 	for (i = 0; i < res->n; i++)
-		FREE(res->di[i]);
-	FREE(res->di);
+		free(res->di[i]);
+	free(res->di);
 }

 void close_fd(void *arg)
diff --git a/libmultipath/util.h b/libmultipath/util.h
index 89027f80..421842a9 100644
--- a/libmultipath/util.h
+++ b/libmultipath/util.h
@@ -9,6 +9,7 @@
 #include <sys/resource.h>
 #include <inttypes.h>
 #include <stdbool.h>
+#include <stdio.h>

 size_t strchop(char *);
 int basenamecpy (const char *src, char *dst, size_t size);
diff --git a/libmultipath/uxsock.c b/libmultipath/uxsock.c
index 6adeedfc..0ccd1fab 100644
--- a/libmultipath/uxsock.c
+++ b/libmultipath/uxsock.c
@@ -21,7 +21,6 @@
 #endif
 #include "mpath_cmd.h"

-#include "memory.h"
 #include "uxsock.h"
 #include "debug.h"

@@ -110,12 +109,12 @@ static int _recv_packet(int fd, char **buf, unsigned int timeout, ssize_t limit)
 		return -errno;
 	if ((limit > 0) && (len > limit))
 		return -EINVAL;
-	(*buf) = MALLOC(len);
+	(*buf) = calloc(1, len);
 	if (!*buf)
 		return -ENOMEM;
 	err = mpath_recv_reply_data(fd, *buf, len, timeout);
 	if (err != 0) {
-		FREE(*buf);
+		free(*buf);
 		(*buf) = NULL;
 		return -errno;
 	}
diff --git a/libmultipath/vector.c b/libmultipath/vector.c
index 6605eb2d..e2d1ec93 100644
--- a/libmultipath/vector.c
+++ b/libmultipath/vector.c
@@ -19,7 +19,6 @@
  * Copyright (c) 2005 Christophe Varoqui
  */

-#include "memory.h"
 #include <stdlib.h>
 #include "vector.h"

@@ -30,7 +29,7 @@
 vector
 vector_alloc(void)
 {
-	vector v = (vector) MALLOC(sizeof (struct _vector));
+	vector v = (vector) calloc(1, sizeof (struct _vector));
 	return v;
 }

@@ -46,7 +45,7 @@ vector_alloc_slot(vector v)
 		return false;

 	new_allocated = v->allocated + VECTOR_DEFAULT_SIZE;
-	new_slot = REALLOC(v->slot, sizeof (void *) * new_allocated);
+	new_slot = realloc(v->slot, sizeof (void *) * new_allocated);
 	if (!new_slot)
 		return false;

@@ -119,13 +118,13 @@ vector_del_slot(vector v, int slot)
 	v->allocated -= VECTOR_DEFAULT_SIZE;

 	if (v->allocated <= 0) {
-		FREE(v->slot);
+		free(v->slot);
 		v->slot = NULL;
 		v->allocated = 0;
 	} else {
 		void *new_slot;

-		new_slot = REALLOC(v->slot, sizeof (void *) * v->allocated);
+		new_slot = realloc(v->slot, sizeof (void *) * v->allocated);
 		if (!new_slot)
 			v->allocated += VECTOR_DEFAULT_SIZE;
 		else
@@ -153,7 +152,7 @@ vector_reset(vector v)
 		return NULL;

 	if (v->slot)
-		FREE(v->slot);
+		free(v->slot);

 	v->allocated = 0;
 	v->slot = NULL;
@@ -166,7 +165,7 @@ vector_free(vector v)
 {
 	if (!vector_reset(v))
 		return;
-	FREE(v);
+	free(v);
 }

 void
@@ -180,7 +179,7 @@ free_strvec(vector strvec)

 	vector_foreach_slot (strvec, str, i)
 		if (str)
-			FREE(str);
+			free(str);

 	vector_free(strvec);
 }
diff --git a/multipath/main.c b/multipath/main.c
index b2d300e5..d7ab4026 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -35,7 +35,6 @@
 #include "checkers.h"
 #include "prio.h"
 #include "vector.h"
-#include "memory.h"
 #include <libdevmapper.h>
 #include "devmapper.h"
 #include "util.h"
@@ -82,7 +81,7 @@ dump_config (struct config *conf, vector hwes, vector mpvec)

 	if (reply != NULL) {
 		printf("%s", reply);
-		FREE(reply);
+		free(reply);
 		return 0;
 	} else
 		return 1;
@@ -286,7 +285,7 @@ found:
 	condlog(r == 0 ? 3 : 2, "%s:%s usable paths found",
 		devpath, r == 0 ? "" : " no");
 free:
-	FREE(mapname);
+	free(mapname);
 	free_multipath(mpp, FREE_PATHS);
 	vector_free(pathvec);
 out:
@@ -585,7 +584,7 @@ out:
 		condlog(2, "Warning: multipath devices exist, but multipathd service is not running");

 	if (refwwid)
-		FREE(refwwid);
+		free(refwwid);

 	free_multipathvec(curmp, KEEP_PATHS);
 	vecs.mpvec = NULL;
@@ -808,7 +807,7 @@ int delegate_to_multipathd(enum mpath_cmds cmd,
 	}

 out:
-	FREE(reply);
+	free(reply);
 	close(fd);
 	return r;
 }
@@ -888,9 +887,6 @@ main (int argc, char *argv[])

 			break;
 		case 'M':
-#if _DEBUG_
-			debug = atoi(optarg);
-#endif
 			break;
 		case 'p':
 			conf->pgpolicy_flag = get_pgpolicy_id(optarg);
@@ -964,7 +960,7 @@ main (int argc, char *argv[])
 	check_alias_settings(conf);

 	if (optind < argc) {
-		dev = MALLOC(FILE_NAME_SIZE);
+		dev = calloc(1, FILE_NAME_SIZE);

 		if (!dev)
 			goto out;
@@ -1075,13 +1071,10 @@ main (int argc, char *argv[])
 out:
 	put_multipath_config(conf);
 	if (dev)
-		FREE(dev);
+		free(dev);

 	if (dev_type == DEV_UEVENT)
 		closelog();

-#ifdef _DEBUG_
-	dbg_free_final(NULL);
-#endif
 	return r;
 }
diff --git a/multipathd/cli.c b/multipathd/cli.c
index 4d6c37c9..bddf1725 100644
--- a/multipathd/cli.c
+++ b/multipathd/cli.c
@@ -4,7 +4,6 @@
 #include <sys/time.h>
 #include <errno.h>
 #include <pthread.h>
-#include "memory.h"
 #include "vector.h"
 #include "structs.h"
 #include "structs_vec.h"
@@ -24,13 +23,13 @@ static vector handlers;
 static struct key *
 alloc_key (void)
 {
-	return (struct key *)MALLOC(sizeof(struct key));
+	return (struct key *)calloc(1, sizeof(struct key));
 }

 static struct handler *
 alloc_handler (void)
 {
-	return (struct handler *)MALLOC(sizeof(struct handler));
+	return (struct handler *)calloc(1, sizeof(struct handler));
 }

 static int
@@ -45,7 +44,7 @@ add_key (vector vec, char * str, uint64_t code, int has_param)

 	kw->code = code;
 	kw->has_param = has_param;
-	kw->str = STRDUP(str);
+	kw->str = strdup(str);

 	if (!kw->str)
 		goto out;
@@ -58,9 +57,9 @@ add_key (vector vec, char * str, uint64_t code, int has_param)
 	return 0;

 out1:
-	FREE(kw->str);
+	free(kw->str);
 out:
-	FREE(kw);
+	free(kw);
 	return 1;
 }

@@ -75,7 +74,7 @@ add_handler (uint64_t fp, int (*fn)(void *, char **, int *, void *))
 		return 1;

 	if (!vector_alloc_slot(handlers)) {
-		FREE(h);
+		free(h);
 		return 1;
 	}

@@ -127,12 +126,12 @@ static void
 free_key (struct key * kw)
 {
 	if (kw->str)
-		FREE(kw->str);
+		free(kw->str);

 	if (kw->param)
-		FREE(kw->param);
+		free(kw->param);

-	FREE(kw);
+	free(kw);
 }

 void
@@ -154,7 +153,7 @@ free_handlers (void)
 	struct handler * h;

 	vector_foreach_slot (handlers, h, i)
-		FREE(h);
+		free(h);

 	vector_free(handlers);
 	handlers = NULL;
@@ -303,7 +302,7 @@ get_cmdvec (char * cmd, vector *v)
 			goto out;
 		}
 		if (!vector_alloc_slot(cmdvec)) {
-			FREE(cmdkw);
+			free(cmdkw);
 			r = ENOMEM;
 			goto out;
 		}
diff --git a/multipathd/cli.h b/multipathd/cli.h
index fdfb9aed..d224a2da 100644
--- a/multipathd/cli.h
+++ b/multipathd/cli.h
@@ -106,7 +106,7 @@ enum {
 				free(tmp);			\
 				(r) = NULL;			\
 			} else {				\
-				(r) = REALLOC((r), (m) * 2);	\
+				(r) = realloc((r), (m) * 2);	\
 				if ((r)) {			\
 					memset((r) + (m), 0, (m)); \
 					(m) *= 2;		\
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 6d3a0ae2..b674a14a 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -5,7 +5,6 @@
 #define _GNU_SOURCE

 #include "checkers.h"
-#include "memory.h"
 #include "vector.h"
 #include "structs.h"
 #include "structs_vec.h"
@@ -746,7 +745,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 				    != CP_OK)
 					condlog(2, "%s: coalesce_paths failed",
 									param);
-				FREE(refwwid);
+				free(refwwid);
 			}
 		} /*we attempt to create device only once*/
 		count++;
@@ -757,7 +756,7 @@ cli_add_map (void * v, char ** reply, int * len, void * data)
 		return 1;
 	}
 	rc = ev_add_map(dev_path, alias, vecs);
-	FREE(alias);
+	free(alias);
 	return rc;
 }

@@ -783,7 +782,7 @@ cli_del_map (void * v, char ** reply, int * len, void * data)
 		return 1;
 	}
 	rc = ev_remove_map(param, alias, minor, vecs);
-	FREE(alias);
+	free(alias);
 	return rc;
 }

diff --git a/multipathd/main.c b/multipathd/main.c
index 1defeaf1..ea2af833 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -38,7 +38,6 @@
  */
 #include "parser.h"
 #include "vector.h"
-#include "memory.h"
 #include "config.h"
 #include "util.h"
 #include "hwtable.h"
@@ -552,11 +551,11 @@ add_map_without_path (struct vectors *vecs, const char *alias)
 	if (!mpp)
 		return NULL;
 	if (!alias) {
-		FREE(mpp);
+		free(mpp);
 		return NULL;
 	}

-	mpp->alias = STRDUP(alias);
+	mpp->alias = strdup(alias);

 	if (dm_get_info(mpp->alias, &mpp->dmi)) {
 		condlog(3, "%s: cannot access table", mpp->alias);
@@ -702,7 +701,7 @@ uev_add_map (struct uevent * uev, struct vectors * vecs)
 	pthread_testcancel();
 	rc = ev_add_map(uev->kernel, alias, vecs);
 	lock_cleanup_pop(vecs->lock);
-	FREE(alias);
+	free(alias);
 	return rc;
 }

@@ -808,7 +807,7 @@ uev_remove_map (struct uevent * uev, struct vectors * vecs)
 	remove_map_and_stop_waiter(mpp, vecs);
 out:
 	lock_cleanup_pop(vecs->lock);
-	FREE(alias);
+	free(alias);
 	return 0;
 }

@@ -1461,11 +1460,11 @@ uev_pathfail_check(struct uevent *uev, struct vectors *vecs)
 				pp->dev);
 out_lock:
 	lock_cleanup_pop(vecs->lock);
-	FREE(devt);
-	FREE(action);
+	free(devt);
+	free(action);
 	return r;
 out:
-	FREE(action);
+	free(action);
 	return 1;
 }

@@ -1501,7 +1500,7 @@ uxsock_trigger (char * str, char ** reply, int * len, bool is_root,
 	if ((str != NULL) && (is_root == false) &&
 	    (strncmp(str, "list", strlen("list")) != 0) &&
 	    (strncmp(str, "show", strlen("show")) != 0)) {
-		*reply = STRDUP("permission deny: need to be root");
+		*reply = strdup("permission deny: need to be root");
 		if (*reply)
 			*len = strlen(*reply) + 1;
 		return 1;
@@ -1511,15 +1510,15 @@ uxsock_trigger (char * str, char ** reply, int * len, bool is_root,

 	if (r > 0) {
 		if (r == ETIMEDOUT)
-			*reply = STRDUP("timeout\n");
+			*reply = strdup("timeout\n");
 		else
-			*reply = STRDUP("fail\n");
+			*reply = strdup("fail\n");
 		if (*reply)
 			*len = strlen(*reply) + 1;
 		r = 1;
 	}
 	else if (!r && *len == 0) {
-		*reply = STRDUP("ok\n");
+		*reply = strdup("ok\n");
 		if (*reply)
 			*len = strlen(*reply) + 1;
 		r = 0;
@@ -2800,7 +2799,7 @@ init_vecs (void)
 {
 	struct vectors * vecs;

-	vecs = (struct vectors *)MALLOC(sizeof(struct vectors));
+	vecs = (struct vectors *)calloc(1, sizeof(struct vectors));

 	if (!vecs)
 		return NULL;
@@ -3012,7 +3011,7 @@ static void cleanup_vecs(void)
 	cleanup_maps(gvecs);
 	cleanup_paths(gvecs);
 	pthread_mutex_destroy(&gvecs->lock.mutex);
-	FREE(gvecs);
+	free(gvecs);
 }

 static void cleanup_threads(void)
@@ -3110,10 +3109,6 @@ static void cleanup_child(void)
 		log_thread_stop();

 	cleanup_conf();
-
-#ifdef _DEBUG_
-	dbg_free_final(NULL);
-#endif
 }

 static int sd_notify_exit(int err)
@@ -3555,7 +3550,7 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 		goto out;
 	}

-	param = (struct prout_param_descriptor *)MALLOC(sizeof(struct prout_param_descriptor));
+	param = (struct prout_param_descriptor *)calloc(1, sizeof(struct prout_param_descriptor));
 	if (!param)
 		goto out;

diff --git a/multipathd/uxclnt.c b/multipathd/uxclnt.c
index a76f8e29..b1b058bd 100644
--- a/multipathd/uxclnt.c
+++ b/multipathd/uxclnt.c
@@ -20,7 +20,6 @@

 #include "mpath_cmd.h"
 #include "uxsock.h"
-#include "memory.h"
 #include "defaults.h"

 #include "vector.h"
@@ -99,7 +98,7 @@ static void process(int fd, unsigned int timeout)
 			add_history(line);

 		free(line);
-		FREE(reply);
+		free(reply);
 	}
 }

@@ -122,7 +121,7 @@ static int process_req(int fd, char * inbuf, unsigned int timeout)
 	} else {
 		printf("%s", reply);
 		ret = (strcmp(reply, "fail\n") == 0);
-		FREE(reply);
+		free(reply);
 		return ret;
 	}
 }
diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
index dbee0d6f..912c35b0 100644
--- a/multipathd/uxlsnr.c
+++ b/multipathd/uxlsnr.c
@@ -25,7 +25,6 @@
 #include <stdbool.h>
 #include <sys/inotify.h>
 #include "checkers.h"
-#include "memory.h"
 #include "debug.h"
 #include "vector.h"
 #include "structs.h"
@@ -99,12 +98,11 @@ static void new_client(int ux_sock)
 	if (fd == -1)
 		return;

-	c = (struct client *)MALLOC(sizeof(*c));
+	c = (struct client *)calloc(1, sizeof(*c));
 	if (!c) {
 		close(fd);
 		return;
 	}
-	memset(c, 0, sizeof(*c));
 	INIT_LIST_HEAD(&c->node);
 	c->fd = fd;

@@ -122,7 +120,7 @@ static void _dead_client(struct client *c)
 	int fd = c->fd;
 	list_del_init(&c->node);
 	c->fd = -1;
-	FREE(c);
+	free(c);
 	close(fd);
 }

@@ -137,7 +135,8 @@ static void dead_client(struct client *c)
 static void free_polls (void)
 {
 	if (polls)
-		FREE(polls);
+		free(polls);
+	polls = NULL;
 }

 static void check_timeout(struct timespec start_time, char *inbuf,
@@ -299,7 +298,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 	struct watch_descriptors wds = { .conf_wd = -1, .dir_wd = -1 };

 	condlog(3, "uxsock: startup listener");
-	polls = MALLOC(max_pfds * sizeof(*polls));
+	polls = calloc(1, max_pfds * sizeof(*polls));
 	if (!polls) {
 		condlog(0, "uxsock: failed to allocate poll fds");
 		exit_daemon();
@@ -327,7 +326,7 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 			struct pollfd *new;
 			int n_new = max_pfds + POLLFD_CHUNK;

-			new = REALLOC(polls, n_new * sizeof(*polls));
+			new = realloc(polls, n_new * sizeof(*polls));
 			if (new) {
 				max_pfds = n_new;
 				polls = new;
@@ -448,12 +447,12 @@ void * uxsock_listen(uxsock_trigger_fn uxsock_trigger, long ux_sock,
 							"Reply [%d bytes]",
 							i, rlen);
 					}
-					FREE(reply);
+					free(reply);
 					reply = NULL;
 				}
 				check_timeout(start_time, inbuf,
 					      uxsock_timeout);
-				FREE(inbuf);
+				free(inbuf);
 			}
 		}
 		/* see if we got a non-fatal signal */
diff --git a/multipathd/waiter.c b/multipathd/waiter.c
index f74b395a..2a221465 100644
--- a/multipathd/waiter.c
+++ b/multipathd/waiter.c
@@ -13,7 +13,6 @@

 #include "util.h"
 #include "vector.h"
-#include "memory.h"
 #include "checkers.h"
 #include "config.h"
 #include "structs.h"
@@ -32,7 +31,7 @@ static struct event_thread *alloc_waiter (void)

 	struct event_thread *wp;

-	wp = (struct event_thread *)MALLOC(sizeof(struct event_thread));
+	wp = (struct event_thread *)calloc(1, sizeof(struct event_thread));

 	return wp;
 }
@@ -45,7 +44,7 @@ static void free_waiter (void *data)
 		dm_task_destroy(wp->dmt);

 	rcu_unregister_thread();
-	FREE(wp);
+	free(wp);
 }

 void stop_waiter_thread (struct multipath *mpp)
diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
index 57ad3381..f116d12c 100644
--- a/tests/pgpolicy.c
+++ b/tests/pgpolicy.c
@@ -23,6 +23,7 @@
 #include <setjmp.h>
 #include <stdlib.h>
 #include <cmocka.h>
+#include <stdio.h>

 #include "globals.c"
 #include "pgpolicies.h"
diff --git a/tests/uevent.c b/tests/uevent.c
index 648ff268..7523fec7 100644
--- a/tests/uevent.c
+++ b/tests/uevent.c
@@ -194,7 +194,7 @@ static void test_dm_name_good(void **state)
 	char *name = uevent_get_dm_name(uev);

 	assert_string_equal(name, DM_NAME);
-	FREE(name);
+	free(name);
 }

 static void test_dm_name_bad_0(void **state)
@@ -205,7 +205,7 @@ static void test_dm_name_bad_0(void **state)
 	uev->envp[3] = "DM_NAME" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_ptr_equal(name, NULL);
-	FREE(name);
+	free(name);
 }

 static void test_dm_name_bad_1(void **state)
@@ -216,7 +216,7 @@ static void test_dm_name_bad_1(void **state)
 	uev->envp[3] = "DM_NAMES=" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_ptr_equal(name, NULL);
-	FREE(name);
+	free(name);
 }

 static void test_dm_name_good_1(void **state)
@@ -228,7 +228,7 @@ static void test_dm_name_good_1(void **state)
 	uev->envp[2] = "DM_NAME=" DM_NAME;
 	name = uevent_get_dm_name(uev);
 	assert_string_equal(name, DM_NAME);
-	FREE(name);
+	free(name);
 }

 static void test_dm_uuid_false_0(void **state)
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

