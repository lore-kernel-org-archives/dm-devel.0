Return-Path: <SRS0=rSqa=QD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDEDC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 14:05:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3686D61BE6
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 14:05:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3686D61BE6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-_eNeV5RpMPW_KGYrKYQO1Q-1; Tue, 16 Nov 2021 09:05:00 -0500
X-MC-Unique: _eNeV5RpMPW_KGYrKYQO1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62D7319200C3;
	Tue, 16 Nov 2021 14:04:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D420E101E592;
	Tue, 16 Nov 2021 14:04:54 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6934A4EA30;
	Tue, 16 Nov 2021 14:04:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AGE17LC002386 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Nov 2021 09:01:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A00EE2166B25; Tue, 16 Nov 2021 14:01:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 98ECD2166B2F
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 14:01:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90C9481DA1A
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 14:01:02 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
	[45.249.212.255]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-432-196FdXkePWC3CVhT2vzxoA-1; Tue, 16 Nov 2021 09:01:00 -0500
X-MC-Unique: 196FdXkePWC3CVhT2vzxoA-1
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Htnhm6mN5z1DJSh;
	Tue, 16 Nov 2021 21:58:32 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Tue, 16 Nov 2021 22:00:54 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Tue, 16 Nov 2021 22:00:54 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
Message-ID: <483a6cc1-10f1-a702-2e44-42ab7cb8e3cd@huawei.com>
Date: Tue, 16 Nov 2021 22:00:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH 4/5] Match FREE and MALLOC/STRDUP/REALLOC
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

In _DEBUG_ mode, MALLOC/STRDUP/REALLOC and FREE will record
the memory usage. Match them.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 kpartx/dasd.c                        | 5 +++--
 kpartx/kpartx.c                      | 7 ++++---
 libmultipath/blacklist.c             | 6 +++---
 libmultipath/checkers/emc_clariion.c | 2 +-
 libmultipath/config.c                | 4 ++--
 libmultipath/configure.c             | 4 ++--
 libmultipath/dmparser.c              | 2 +-
 libmultipath/parser.c                | 2 +-
 libmultipath/structs.c               | 2 +-
 multipathd/main.c                    | 2 +-
 10 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/kpartx/dasd.c b/kpartx/dasd.c
index f0398645..14744048 100644
--- a/kpartx/dasd.c
+++ b/kpartx/dasd.c
@@ -40,6 +40,7 @@
 #include "kpartx.h"
 #include "byteorder.h"
 #include "dasd.h"
+#include "memory.h"

 unsigned long long sectors512(unsigned long long sectors, int blocksize)
 {
@@ -100,10 +101,10 @@ read_dasd_pt(int fd, __attribute__((unused)) struct slice all,
 		 * Get the first target and operate on that instead.
 		 */
 		if (!(dev = dm_get_first_dep(devname))) {
-			free(devname);
+			FREE(devname);
 			return -1;
 		}
-		free(devname);
+		FREE(devname);

 		if ((unsigned int)major(dev) != 94) {
 			/* Not a DASD */
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 7bc64543..5e59063d 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -39,6 +39,7 @@
 #include "lopart.h"
 #include "kpartx.h"
 #include "version.h"
+#include "memory.h"

 #define SIZE(a) (sizeof(a)/sizeof((a)[0]))

@@ -177,7 +178,7 @@ get_hotplug_device(void)

 	/* Dirname + mapname + \0 */
 	if (!(device = (char *)malloc(sizeof(char) * (off + len + 1)))) {
-		free(mapname);
+		FREE(mapname);
 		return NULL;
 	}

@@ -187,10 +188,10 @@ get_hotplug_device(void)

 	if (strlen(device) != (off + len)) {
 		free(device);
-		free(mapname);
+		FREE(mapname);
 		return NULL;
 	}
-	free(mapname);
+	FREE(mapname);
 	return device;
 }

diff --git a/libmultipath/blacklist.c b/libmultipath/blacklist.c
index 4e315c97..573df152 100644
--- a/libmultipath/blacklist.c
+++ b/libmultipath/blacklist.c
@@ -39,7 +39,7 @@ int store_ble(vector blist, const char *str, int origin)
 	if (!str)
 		return 0;

-	strdup_str = strdup(str);
+	strdup_str = STRDUP(str);
 	if (!strdup_str)
 		return 1;

@@ -134,8 +134,8 @@ out1:
 		ble->vendor = NULL;
 	}
 out:
-	free(vendor_str);
-	free(product_str);
+	FREE(vendor_str);
+	FREE(product_str);
 	return 1;
 }

diff --git a/libmultipath/checkers/emc_clariion.c b/libmultipath/checkers/emc_clariion.c
index 5cd63aca..b3f0aded 100644
--- a/libmultipath/checkers/emc_clariion.c
+++ b/libmultipath/checkers/emc_clariion.c
@@ -128,7 +128,7 @@ int libcheck_mp_init (struct checker * c)

 void libcheck_free (struct checker * c)
 {
-	free(c->context);
+	FREE(c->context);
 }

 int libcheck_check (struct checker * c)
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 30046a17..667b500b 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -1051,10 +1051,10 @@ int parse_uid_attrs(char *uid_attrs, struct config *conf)
 		if (!tmp) {
 			condlog(2, "invalid record in uid_attrs: %s",
 				uid_attr_record);
-			free(uid_attr_record);
+			FREE(uid_attr_record);
 			ret = 1;
 		} else if (!vector_alloc_slot(attrs)) {
-			free(uid_attr_record);
+			FREE(uid_attr_record);
 			ret = 1;
 		} else
 			vector_set_slot(attrs, uid_attr_record);
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 7edb355b..9545854b 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -738,8 +738,8 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 		condlog(1, "%s: can't use alias \"%s\" used by %s, falling back to WWID",
 			mpp->wwid, mpp->alias, cmpp_by_name->wwid);
 		/* We can do this because wwid wasn't found */
-		free(mpp->alias);
-		mpp->alias = strdup(mpp->wwid);
+		FREE(mpp->alias);
+		mpp->alias = STRDUP(mpp->wwid);
 		mpp->action = ACT_CREATE;
 		condlog(3, "%s: set ACT_CREATE (map does not exist, name changed)",
 			mpp->alias);
diff --git a/libmultipath/dmparser.c b/libmultipath/dmparser.c
index 4ba7f339..96beeb6d 100644
--- a/libmultipath/dmparser.c
+++ b/libmultipath/dmparser.c
@@ -30,7 +30,7 @@ merge_words(char **dst, const char *word)
 	*dst = REALLOC(*dst, len);

 	if (!*dst) {
-		free(p);
+		FREE(p);
 		return 1;
 	}

diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index 68262d0e..f0047c4d 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -364,7 +364,7 @@ set_value(vector strvec)
 	for (i = 2; i < VECTOR_SIZE(strvec); i++) {
 		str = VECTOR_SLOT(strvec, i);
 		if (!str) {
-			free(alloc);
+			FREE(alloc);
 			condlog(0, "parse error for option '%s'",
 				(char *)VECTOR_SLOT(strvec, 0));
 			return NULL;
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 6e5a1038..e8cacb4b 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -106,7 +106,7 @@ alloc_path (void)
 		dm_path_to_gen(pp)->ops = &dm_gen_path_ops;
 		pp->hwe = vector_alloc();
 		if (pp->hwe == NULL) {
-			free(pp);
+			FREE(pp);
 			return NULL;
 		}
 	}
diff --git a/multipathd/main.c b/multipathd/main.c
index 1defeaf1..82ab3ed1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3555,7 +3555,7 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 		goto out;
 	}

-	param = (struct prout_param_descriptor *)MALLOC(sizeof(struct prout_param_descriptor));
+	param = (struct prout_param_descriptor *)calloc(1, sizeof(struct prout_param_descriptor));
 	if (!param)
 		goto out;

-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

