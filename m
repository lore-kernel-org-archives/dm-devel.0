Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09BBC4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:43:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4409B60FA0
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 15:43:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4409B60FA0
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-WI5TQ51YPRWrApS5yPpOew-1; Wed, 11 Aug 2021 11:43:34 -0400
X-MC-Unique: WI5TQ51YPRWrApS5yPpOew-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFAC1C73AF;
	Wed, 11 Aug 2021 15:43:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D1650100763B;
	Wed, 11 Aug 2021 15:43:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5E6D181A0F7;
	Wed, 11 Aug 2021 15:43:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BFgAic010069 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 11:42:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1992521F1B1A; Wed, 11 Aug 2021 15:42:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 141E421F1B15
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:42:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 143578CA95F
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 15:42:08 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-162-d_CT-QLwMEifu8tLaD5LhA-1; Wed, 11 Aug 2021 11:42:05 -0400
X-MC-Unique: d_CT-QLwMEifu8tLaD5LhA-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9122F2018B;
	Wed, 11 Aug 2021 15:42:04 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 5BDBD13969;
	Wed, 11 Aug 2021 15:42:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id oO1dFMzvE2H/XQAAGKfGzw
	(envelope-from <mwilck@suse.com>); Wed, 11 Aug 2021 15:42:04 +0000
From: mwilck@suse.com
To: Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 11 Aug 2021 17:41:47 +0200
Message-Id: <20210811154150.24714-7-mwilck@suse.com>
In-Reply-To: <20210811154150.24714-1-mwilck@suse.com>
References: <20210811154150.24714-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17BFgAic010069
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 6/9] libmultipath: print.c: fail hard if
	keywords are not found
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

A failure in find_keyword() means an internal error. Fail hard rather
than returning an empty string.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 101 +++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 66 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index dd04dea..507e675 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -10,6 +10,7 @@
 #include <unistd.h>
 #include <string.h>
 #include <errno.h>
+#include <assert.h>
 #include <libudev.h>
 
 #include "checkers.h"
@@ -1294,14 +1295,9 @@ snprint_hwentry (const struct config *conf,
 	size_t initial_len = get_strbuf_len(buff);
 
 	rootkw = find_keyword(conf->keywords, NULL, "devices");
-
-	if (!rootkw || !rootkw->sub)
-		return 0;
-
+	assert(rootkw && rootkw->sub);
 	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
-
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
 
 	if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
 		return rc;
@@ -1324,8 +1320,7 @@ static int snprint_hwtable(const struct config *conf, struct strbuf *buff,
 	size_t initial_len = get_strbuf_len(buff);
 
 	rootkw = find_keyword(conf->keywords, NULL, "devices");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
 
 	if ((rc = append_strbuf_str(buff, "devices {\n")) < 0)
 		return rc;
@@ -1355,8 +1350,7 @@ snprint_mpentry (const struct config *conf, struct strbuf *buff,
 		return 0;
 
 	rootkw = find_keyword(conf->keywords, NULL, "multipath");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
 
 	if ((rc = append_strbuf_str(buff, "\tmultipath {\n")) < 0)
 		return rc;
@@ -1387,8 +1381,7 @@ static int snprint_mptable(const struct config *conf, struct strbuf *buff,
 	size_t initial_len = get_strbuf_len(buff);
 
 	rootkw = find_keyword(conf->keywords, NULL, "multipaths");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
 
 	if ((rc = append_strbuf_str(buff, "multipaths {\n")) < 0)
 		return rc;
@@ -1435,8 +1428,7 @@ static int snprint_overrides(const struct config *conf, struct strbuf *buff,
 	size_t initial_len = get_strbuf_len(buff);
 
 	rootkw = find_keyword(conf->keywords, NULL, "overrides");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
 
 	if ((rc = append_strbuf_str(buff, "overrides {\n")) < 0)
 		return rc;
@@ -1461,8 +1453,7 @@ static int snprint_defaults(const struct config *conf, struct strbuf *buff)
 	size_t initial_len = get_strbuf_len(buff);
 
 	rootkw = find_keyword(conf->keywords, NULL, "defaults");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
 
 	if ((rc = append_strbuf_str(buff, "defaults {\n")) < 0)
 		return rc;
@@ -1584,63 +1575,52 @@ static int snprint_blacklist(const struct config *conf, struct strbuf *buff)
 	struct blentry * ble;
 	struct blentry_device * bled;
 	struct keyword *rootkw;
-	struct keyword *kw;
+	struct keyword *kw, *pkw;
 	size_t initial_len = get_strbuf_len(buff);
 
 	rootkw = find_keyword(conf->keywords, NULL, "blacklist");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
 
 	if ((rc = append_strbuf_str(buff, "blacklist {\n")) < 0)
 		return rc;
 
 	vector_foreach_slot (conf->blist_devnode, ble, i) {
 		kw = find_keyword(conf->keywords, rootkw->sub, "devnode");
-		if (!kw)
-			return 0;
+		assert(kw);
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
 			return rc;
 	}
 	vector_foreach_slot (conf->blist_wwid, ble, i) {
 		kw = find_keyword(conf->keywords, rootkw->sub, "wwid");
-		if (!kw)
-			return 0;
+		assert(kw);
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
 			return rc;
 	}
 	vector_foreach_slot (conf->blist_property, ble, i) {
 		kw = find_keyword(conf->keywords, rootkw->sub, "property");
-		if (!kw)
-			return 0;
+		assert(kw);
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
 			return rc;
 	}
 	vector_foreach_slot (conf->blist_protocol, ble, i) {
 		kw = find_keyword(conf->keywords, rootkw->sub, "protocol");
-		if (!kw)
-			return 0;
+		assert(kw);
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ble)) < 0)
 			return rc;
 	}
 
 	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
+	kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
+	pkw = find_keyword(conf->keywords, rootkw->sub, "product");
+	assert(kw && pkw);
 
 	vector_foreach_slot (conf->blist_device, bled, i) {
-		if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
-			return rc;
-
-		kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
-		if (!kw)
-			return 0;
-		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, bled)) < 0)
+		if ((rc = snprint_keyword(buff, "\tdevice {\n\t\t%k %v\n",
+					  kw, bled)) < 0)
 			return rc;
-		kw = find_keyword(conf->keywords, rootkw->sub, "product");
-		if (!kw)
-			return 0;
-		if ((rc = snprint_keyword(buff,
-					  "\t\t%k %v\n\t}\n", kw, bled)) < 0)
+		if ((rc = snprint_keyword(buff, "\t\t%k %v\n\t}\n",
+					  pkw, bled)) < 0)
 			return rc;
 	}
 
@@ -1656,63 +1636,52 @@ static int snprint_blacklist_except(const struct config *conf,
 	struct blentry * ele;
 	struct blentry_device * eled;
 	struct keyword *rootkw;
-	struct keyword *kw;
+	struct keyword *kw, *pkw;
 	size_t initial_len = get_strbuf_len(buff);
 
 	rootkw = find_keyword(conf->keywords, NULL, "blacklist_exceptions");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
 
 	if ((rc = append_strbuf_str(buff, "blacklist_exceptions {\n")) < 0)
 		return rc;
 
 	vector_foreach_slot (conf->elist_devnode, ele, i) {
 		kw = find_keyword(conf->keywords, rootkw->sub, "devnode");
-		if (!kw)
-			return 0;
+		assert(kw);
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
 			return rc;
 	}
 	vector_foreach_slot (conf->elist_wwid, ele, i) {
 		kw = find_keyword(conf->keywords, rootkw->sub, "wwid");
-		if (!kw)
-			return 0;
+		assert(kw);
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
 			return rc;
 	}
 	vector_foreach_slot (conf->elist_property, ele, i) {
 		kw = find_keyword(conf->keywords, rootkw->sub, "property");
-		if (!kw)
-			return 0;
+		assert(kw);
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
 			return rc;
 	}
 	vector_foreach_slot (conf->elist_protocol, ele, i) {
 		kw = find_keyword(conf->keywords, rootkw->sub, "protocol");
-		if (!kw)
-			return 0;
+		assert(kw);
 		if ((rc = snprint_keyword(buff, "\t%k %v\n", kw, ele)) < 0)
 			return rc;
 	}
 
 	rootkw = find_keyword(conf->keywords, rootkw->sub, "device");
-	if (!rootkw)
-		return 0;
+	assert(rootkw);
+	kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
+	pkw = find_keyword(conf->keywords, rootkw->sub, "product");
+	assert(kw && pkw);
 
 	vector_foreach_slot (conf->elist_device, eled, i) {
-		if ((rc = append_strbuf_str(buff, "\tdevice {\n")) < 0)
-			return rc;
-
-		kw = find_keyword(conf->keywords, rootkw->sub, "vendor");
-		if (!kw)
-			return 0;
-		if ((rc = snprint_keyword(buff, "\t\t%k %v\n", kw, eled)) < 0)
+		if ((rc = snprint_keyword(buff, "\tdevice {\n\t\t%k %v\n",
+					  kw, eled)) < 0)
 			return rc;
-		kw = find_keyword(conf->keywords, rootkw->sub, "product");
-		if (!kw)
-			return 0;
 		if ((rc = snprint_keyword(buff, "\t\t%k %v\n\t}\n",
-					  kw, eled)) < 0)
+					  pkw, eled)) < 0)
 			return rc;
 	}
 
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

