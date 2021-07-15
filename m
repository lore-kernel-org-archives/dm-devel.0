Return-Path: <SRS0=U3zJ=MH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870AFC07E96
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jul 2021 10:56:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 052136120A
	for <dm-devel@archiver.kernel.org>; Thu, 15 Jul 2021 10:56:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 052136120A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-rD0bSVKdMZi-Zyp13il57w-1; Thu, 15 Jul 2021 06:54:50 -0400
X-MC-Unique: rD0bSVKdMZi-Zyp13il57w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B325250750;
	Thu, 15 Jul 2021 10:54:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 994F02C175;
	Thu, 15 Jul 2021 10:54:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 67A611809CAC;
	Thu, 15 Jul 2021 10:54:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16FAqjGo015580 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 15 Jul 2021 06:52:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DE44D208BDE5; Thu, 15 Jul 2021 10:52:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6423208BDF2
	for <dm-devel@redhat.com>; Thu, 15 Jul 2021 10:52:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 217C980D099
	for <dm-devel@redhat.com>; Thu, 15 Jul 2021 10:52:43 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-425-3nlOGNJDPwygESHvXelNTw-1; Thu, 15 Jul 2021 06:52:40 -0400
X-MC-Unique: 3nlOGNJDPwygESHvXelNTw-1
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 419B41FE00;
	Thu, 15 Jul 2021 10:52:39 +0000 (UTC)
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0FED313AB7;
	Thu, 15 Jul 2021 10:52:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap1.suse-dmz.suse.de with ESMTPSA id 8Do3AncT8GDQIAAAGKfGzw
	(envelope-from <mwilck@suse.com>); Thu, 15 Jul 2021 10:52:39 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 15 Jul 2021 12:52:21 +0200
Message-Id: <20210715105223.30463-8-mwilck@suse.com>
In-Reply-To: <20210715105223.30463-1-mwilck@suse.com>
References: <20210715105223.30463-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16FAqjGo015580
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 7/9] libmultipath: print.h: move macros to print.c
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Move all macros to print.c that aren't used in other source files.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/print.c | 66 +++++++++++++++++++++++++++++++++++++++++
 libmultipath/print.h | 70 +-------------------------------------------
 2 files changed, 67 insertions(+), 69 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 5b86483..6a5c465 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -34,6 +34,72 @@
 #include "foreign.h"
 #include "strbuf.h"
 
+#define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
+#define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
+#define PRINT_MAP_PROPS      "size=%S features='%f' hwhandler='%h' wp=%r"
+#define PRINT_PG_INDENT      "policy='%s' prio=%p status=%t"
+
+#define PRINT_JSON_MULTIPLIER     5
+#define PRINT_JSON_MAJOR_VERSION  0
+#define PRINT_JSON_MINOR_VERSION  1
+#define PRINT_JSON_START_VERSION  "   \"major_version\": %d,\n" \
+				  "   \"minor_version\": %d,\n"
+#define PRINT_JSON_START_ELEM     "{\n"
+#define PRINT_JSON_START_MAP      "   \"map\":"
+#define PRINT_JSON_START_MAPS     "\"maps\": ["
+#define PRINT_JSON_START_PATHS    "\"paths\": ["
+#define PRINT_JSON_START_GROUPS   "\"path_groups\": ["
+#define PRINT_JSON_END_ELEM       "},"
+#define PRINT_JSON_END_LAST_ELEM  "}"
+#define PRINT_JSON_END_LAST       "}\n"
+#define PRINT_JSON_END_ARRAY      "]\n"
+#define PRINT_JSON_INDENT_N    3
+#define PRINT_JSON_MAP       "{\n" \
+			     "      \"name\" : \"%n\",\n" \
+			     "      \"uuid\" : \"%w\",\n" \
+			     "      \"sysfs\" : \"%d\",\n" \
+			     "      \"failback\" : \"%F\",\n" \
+			     "      \"queueing\" : \"%Q\",\n" \
+			     "      \"paths\" : %N,\n" \
+			     "      \"write_prot\" : \"%r\",\n" \
+			     "      \"dm_st\" : \"%t\",\n" \
+			     "      \"features\" : \"%f\",\n" \
+			     "      \"hwhandler\" : \"%h\",\n" \
+			     "      \"action\" : \"%A\",\n" \
+			     "      \"path_faults\" : %0,\n" \
+			     "      \"vend\" : \"%v\",\n" \
+			     "      \"prod\" : \"%p\",\n" \
+			     "      \"rev\" : \"%e\",\n" \
+			     "      \"switch_grp\" : %1,\n" \
+			     "      \"map_loads\" : %2,\n" \
+			     "      \"total_q_time\" : %3,\n" \
+			     "      \"q_timeouts\" : %4,"
+
+#define PRINT_JSON_GROUP     "{\n" \
+			     "         \"selector\" : \"%s\",\n" \
+			     "         \"pri\" : %p,\n" \
+			     "         \"dm_st\" : \"%t\",\n" \
+			     "         \"marginal_st\" : \"%M\","
+
+#define PRINT_JSON_GROUP_NUM "         \"group\" : %d,\n"
+
+#define PRINT_JSON_PATH      "{\n" \
+			     "            \"dev\" : \"%d\",\n"\
+			     "            \"dev_t\" : \"%D\",\n" \
+			     "            \"dm_st\" : \"%t\",\n" \
+			     "            \"dev_st\" : \"%o\",\n" \
+			     "            \"chk_st\" : \"%T\",\n" \
+			     "            \"checker\" : \"%c\",\n" \
+			     "            \"pri\" : %p,\n" \
+			     "            \"host_wwnn\" : \"%N\",\n" \
+			     "            \"target_wwnn\" : \"%n\",\n" \
+			     "            \"host_wwpn\" : \"%R\",\n" \
+			     "            \"target_wwpn\" : \"%r\",\n" \
+			     "            \"host_adapter\" : \"%a\",\n" \
+			     "            \"marginal_st\" : \"%M\""
+
+#define PROGRESS_LEN  10
+
 #define MAX(x,y) (((x) > (y)) ? (x) : (y))
 #define MIN(x,y) (((x) > (y)) ? (y) : (x))
 /*
diff --git a/libmultipath/print.h b/libmultipath/print.h
index b922812..c6674a5 100644
--- a/libmultipath/print.h
+++ b/libmultipath/print.h
@@ -2,80 +2,12 @@
 #define _PRINT_H
 #include "dm-generic.h"
 
-struct strbuf;
-
-#define PRINT_PATH_LONG      "%w %i %d %D %p %t %T %s %o"
-#define PRINT_PATH_INDENT    "%i %d %D %t %T %o"
 #define PRINT_PATH_CHECKER   "%i %d %D %p %t %T %o %C"
 #define PRINT_MAP_STATUS     "%n %F %Q %N %t %r"
 #define PRINT_MAP_STATS      "%n %0 %1 %2 %3 %4"
 #define PRINT_MAP_NAMES      "%n %d %w"
-#define PRINT_MAP_PROPS      "size=%S features='%f' hwhandler='%h' wp=%r"
-#define PRINT_PG_INDENT      "policy='%s' prio=%p status=%t"
-
-#define PRINT_JSON_MULTIPLIER     5
-#define PRINT_JSON_MAJOR_VERSION  0
-#define PRINT_JSON_MINOR_VERSION  1
-#define PRINT_JSON_START_VERSION  "   \"major_version\": %d,\n" \
-				  "   \"minor_version\": %d,\n"
-#define PRINT_JSON_START_ELEM     "{\n"
-#define PRINT_JSON_START_MAP      "   \"map\":"
-#define PRINT_JSON_START_MAPS     "\"maps\": ["
-#define PRINT_JSON_START_PATHS    "\"paths\": ["
-#define PRINT_JSON_START_GROUPS   "\"path_groups\": ["
-#define PRINT_JSON_END_ELEM       "},"
-#define PRINT_JSON_END_LAST_ELEM  "}"
-#define PRINT_JSON_END_LAST       "}\n"
-#define PRINT_JSON_END_ARRAY      "]\n"
-#define PRINT_JSON_INDENT_N    3
-#define PRINT_JSON_MAP       "{\n" \
-			     "      \"name\" : \"%n\",\n" \
-			     "      \"uuid\" : \"%w\",\n" \
-			     "      \"sysfs\" : \"%d\",\n" \
-			     "      \"failback\" : \"%F\",\n" \
-			     "      \"queueing\" : \"%Q\",\n" \
-			     "      \"paths\" : %N,\n" \
-			     "      \"write_prot\" : \"%r\",\n" \
-			     "      \"dm_st\" : \"%t\",\n" \
-			     "      \"features\" : \"%f\",\n" \
-			     "      \"hwhandler\" : \"%h\",\n" \
-			     "      \"action\" : \"%A\",\n" \
-			     "      \"path_faults\" : %0,\n" \
-			     "      \"vend\" : \"%v\",\n" \
-			     "      \"prod\" : \"%p\",\n" \
-			     "      \"rev\" : \"%e\",\n" \
-			     "      \"switch_grp\" : %1,\n" \
-			     "      \"map_loads\" : %2,\n" \
-			     "      \"total_q_time\" : %3,\n" \
-			     "      \"q_timeouts\" : %4,"
-
-#define PRINT_JSON_GROUP     "{\n" \
-			     "         \"selector\" : \"%s\",\n" \
-			     "         \"pri\" : %p,\n" \
-			     "         \"dm_st\" : \"%t\",\n" \
-			     "         \"marginal_st\" : \"%M\","
 
-#define PRINT_JSON_GROUP_NUM "         \"group\" : %d,\n"
-
-#define PRINT_JSON_PATH      "{\n" \
-			     "            \"dev\" : \"%d\",\n"\
-			     "            \"dev_t\" : \"%D\",\n" \
-			     "            \"dm_st\" : \"%t\",\n" \
-			     "            \"dev_st\" : \"%o\",\n" \
-			     "            \"chk_st\" : \"%T\",\n" \
-			     "            \"checker\" : \"%c\",\n" \
-			     "            \"pri\" : %p,\n" \
-			     "            \"host_wwnn\" : \"%N\",\n" \
-			     "            \"target_wwnn\" : \"%n\",\n" \
-			     "            \"host_wwpn\" : \"%R\",\n" \
-			     "            \"target_wwpn\" : \"%r\",\n" \
-			     "            \"host_adapter\" : \"%a\",\n" \
-			     "            \"marginal_st\" : \"%M\""
-
-#define MAX_LINE_LEN  80
-#define MAX_LINES     64
-#define MAX_FIELD_LEN 128
-#define PROGRESS_LEN  10
+struct strbuf;
 
 struct path_data {
 	char wildcard;
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

