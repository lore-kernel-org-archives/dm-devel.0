Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157A7C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:04:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 979F7610A5
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:04:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 979F7610A5
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633550694;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=tyZHgAwuC8A4Dhxys2qLyL9IfbTS/kXNVxUrFXwUsJY=;
	b=ScJurAendYuvVrFX9A2dE9xcxEuLIzI7x+6DuvlOAqu2aHbO6Mndj91WZRsIkR/BLgR3Sm
	0o/fI4m5BDUm5/oU7j/KXqC+G7p/b/GuFUKmvxbFaFg7lIpL88Zyg344Vvcdn1cZV5HFbr
	kMh/opV/2dnAcLObNGyMJimXfImG39M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-JeGriejwOY-mxFi_mNnV7Q-1; Wed, 06 Oct 2021 16:04:53 -0400
X-MC-Unique: JeGriejwOY-mxFi_mNnV7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BD0F835DE7;
	Wed,  6 Oct 2021 20:04:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 202955D9C6;
	Wed,  6 Oct 2021 20:04:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED0A74EA37;
	Wed,  6 Oct 2021 20:04:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196K4Y3r020082 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 16:04:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A6EA018A8F; Wed,  6 Oct 2021 20:04:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC886179B3;
	Wed,  6 Oct 2021 20:04:31 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 196K4UAN025626; 
	Wed, 6 Oct 2021 15:04:30 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 196K4TDc025625;
	Wed, 6 Oct 2021 15:04:29 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  6 Oct 2021 15:04:19 -0500
Message-Id: <1633550663-25571-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 4/8] libmultipath: pass file and line number to
	keyword handlers
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This will make it possible for the keyword handlers to print more useful
warning messages. It will be used by future patches.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c   | 143 +++++++++++++++++++++++++-----------------
 libmultipath/parser.c |   3 +-
 libmultipath/parser.h |   2 +-
 3 files changed, 90 insertions(+), 58 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 7a727389..eb2c44c0 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -29,7 +29,7 @@
 #include "strbuf.h"
 
 static int
-set_int(vector strvec, void *ptr)
+set_int(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	int *int_ptr = (int *)ptr;
 	char *buff, *eptr;
@@ -58,7 +58,7 @@ set_int(vector strvec, void *ptr)
 }
 
 static int
-set_uint(vector strvec, void *ptr)
+set_uint(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	unsigned int *uint_ptr = (unsigned int *)ptr;
 	char *buff, *eptr, *p;
@@ -90,7 +90,7 @@ set_uint(vector strvec, void *ptr)
 }
 
 static int
-set_str(vector strvec, void *ptr)
+set_str(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	char **str_ptr = (char **)ptr;
 
@@ -105,7 +105,7 @@ set_str(vector strvec, void *ptr)
 }
 
 static int
-set_yes_no(vector strvec, void *ptr)
+set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	char * buff;
 	int *int_ptr = (int *)ptr;
@@ -124,7 +124,7 @@ set_yes_no(vector strvec, void *ptr)
 }
 
 static int
-set_yes_no_undef(vector strvec, void *ptr)
+set_yes_no_undef(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	char * buff;
 	int *int_ptr = (int *)ptr;
@@ -187,9 +187,10 @@ static int print_yes_no_undef(struct strbuf *buff, long v)
 
 #define declare_def_handler(option, function)				\
 static int								\
-def_ ## option ## _handler (struct config *conf, vector strvec)		\
+def_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
 {									\
-	return function (strvec, &conf->option);			\
+	return function (strvec, &conf->option, file, line_nr);		\
 }
 
 #define declare_def_snprint(option, function)				\
@@ -224,12 +225,13 @@ snprint_def_ ## option (struct config *conf, struct strbuf *buff,	\
 
 #define declare_hw_handler(option, function)				\
 static int								\
-hw_ ## option ## _handler (struct config *conf, vector strvec)		\
+hw_ ## option ## _handler (struct config *conf, vector strvec,		\
+			   const char *file, int line_nr)		\
 {									\
 	struct hwentry * hwe = VECTOR_LAST_SLOT(conf->hwtable);		\
 	if (!hwe)							\
 		return 1;						\
-	return function (strvec, &hwe->option);				\
+	return function (strvec, &hwe->option, file, line_nr);		\
 }
 
 #define declare_hw_snprint(option, function)				\
@@ -243,11 +245,12 @@ snprint_hw_ ## option (struct config *conf, struct strbuf *buff,	\
 
 #define declare_ovr_handler(option, function)				\
 static int								\
-ovr_ ## option ## _handler (struct config *conf, vector strvec)		\
+ovr_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
 {									\
 	if (!conf->overrides)						\
 		return 1;						\
-	return function (strvec, &conf->overrides->option);		\
+	return function (strvec, &conf->overrides->option, file, line_nr); \
 }
 
 #define declare_ovr_snprint(option, function)				\
@@ -260,12 +263,13 @@ snprint_ovr_ ## option (struct config *conf, struct strbuf *buff,	\
 
 #define declare_mp_handler(option, function)				\
 static int								\
-mp_ ## option ## _handler (struct config *conf, vector strvec)		\
+mp_ ## option ## _handler (struct config *conf, vector strvec,		\
+			   const char *file, int line_nr)		\
 {									\
 	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);		\
 	if (!mpe)							\
 		return 1;						\
-	return function (strvec, &mpe->option);				\
+	return function (strvec, &mpe->option, file, line_nr);		\
 }
 
 #define declare_mp_snprint(option, function)				\
@@ -277,9 +281,10 @@ snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
 	return function(buff, mpe->option);				\
 }
 
-static int checkint_handler(struct config *conf, vector strvec)
+static int checkint_handler(struct config *conf, vector strvec,
+			    const char *file, int line_nr)
 {
-	int rc = set_uint(strvec, &conf->checkint);
+	int rc = set_uint(strvec, &conf->checkint, file, line_nr);
 
 	if (rc)
 		return rc;
@@ -302,9 +307,10 @@ declare_def_snprint(reassign_maps, print_yes_no)
 declare_def_handler(multipath_dir, set_str)
 declare_def_snprint(multipath_dir, print_str)
 
-static int def_partition_delim_handler(struct config *conf, vector strvec)
+static int def_partition_delim_handler(struct config *conf, vector strvec,
+				       const char *file, int line_nr)
 {
-	int rc = set_str(strvec, &conf->partition_delim);
+	int rc = set_str(strvec, &conf->partition_delim, file, line_nr);
 
 	if (rc != 0)
 		return rc;
@@ -334,13 +340,13 @@ static const char * const find_multipaths_optvals[] = {
 };
 
 static int
-def_find_multipaths_handler(struct config *conf, vector strvec)
+def_find_multipaths_handler(struct config *conf, vector strvec,
+			    const char *file, int line_nr)
 {
 	char *buff;
 	int i;
 
-	if (set_yes_no_undef(strvec, &conf->find_multipaths) == 0 &&
-	    conf->find_multipaths != FIND_MULTIPATHS_UNDEF)
+	if (set_yes_no_undef(strvec, &conf->find_multipaths, file, line_nr) == 0 && conf->find_multipaths != FIND_MULTIPATHS_UNDEF)
 		return 0;
 
 	buff = set_value(strvec);
@@ -396,7 +402,8 @@ static int snprint_uid_attrs(struct config *conf, struct strbuf *buff,
 	return total;
 }
 
-static int uid_attrs_handler(struct config *conf, vector strvec)
+static int uid_attrs_handler(struct config *conf, vector strvec,
+			     const char *file, int line_nr)
 {
 	char *val;
 
@@ -597,7 +604,8 @@ declare_hw_handler(skip_kpartx, set_yes_no_undef)
 declare_hw_snprint(skip_kpartx, print_yes_no_undef)
 declare_mp_handler(skip_kpartx, set_yes_no_undef)
 declare_mp_snprint(skip_kpartx, print_yes_no_undef)
-static int def_disable_changed_wwids_handler(struct config *conf, vector strvec)
+static int def_disable_changed_wwids_handler(struct config *conf, vector strvec,
+					     const char *file, int line_nr)
 {
 	return 0;
 }
@@ -629,20 +637,23 @@ declare_def_snprint_defstr(enable_foreign, print_str,
 			   DEFAULT_ENABLE_FOREIGN)
 
 static int
-def_config_dir_handler(struct config *conf, vector strvec)
+def_config_dir_handler(struct config *conf, vector strvec, const char *file,
+		       int line_nr)
 {
 	/* this is only valid in the main config file */
 	if (conf->processed_main_config)
 		return 0;
-	return set_str(strvec, &conf->config_dir);
+	return set_str(strvec, &conf->config_dir, file, line_nr);
 }
 declare_def_snprint(config_dir, print_str)
 
 #define declare_def_attr_handler(option, function)			\
 static int								\
-def_ ## option ## _handler (struct config *conf, vector strvec)		\
+def_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
 {									\
-	return function (strvec, &conf->option, &conf->attribute_flags);\
+	return function (strvec, &conf->option, &conf->attribute_flags, \
+			 file, line_nr);				\
 }
 
 #define declare_def_attr_snprint(option, function)			\
@@ -655,12 +666,14 @@ snprint_def_ ## option (struct config *conf, struct strbuf *buff,	\
 
 #define declare_mp_attr_handler(option, function)			\
 static int								\
-mp_ ## option ## _handler (struct config *conf, vector strvec)		\
+mp_ ## option ## _handler (struct config *conf, vector strvec,		\
+			   const char *file, int line_nr)		\
 {									\
 	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);		\
 	if (!mpe)							\
 		return 1;						\
-	return function (strvec, &mpe->option, &mpe->attribute_flags);	\
+	return function (strvec, &mpe->option, &mpe->attribute_flags,	\
+			 file, line_nr);				\
 }
 
 #define declare_mp_attr_snprint(option, function)			\
@@ -673,7 +686,7 @@ snprint_mp_ ## option (struct config *conf, struct strbuf *buff,	\
 }
 
 static int
-set_mode(vector strvec, void *ptr, int *flags)
+set_mode(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 {
 	mode_t mode;
 	mode_t *mode_ptr = (mode_t *)ptr;
@@ -694,7 +707,7 @@ set_mode(vector strvec, void *ptr, int *flags)
 }
 
 static int
-set_uid(vector strvec, void *ptr, int *flags)
+set_uid(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 {
 	uid_t uid;
 	uid_t *uid_ptr = (uid_t *)ptr;
@@ -719,7 +732,7 @@ set_uid(vector strvec, void *ptr, int *flags)
 }
 
 static int
-set_gid(vector strvec, void *ptr, int *flags)
+set_gid(vector strvec, void *ptr, int *flags, const char *file, int line_nr)
 {
 	gid_t gid;
 	gid_t *gid_ptr = (gid_t *)ptr;
@@ -786,7 +799,7 @@ declare_mp_attr_handler(gid, set_gid)
 declare_mp_attr_snprint(gid, print_gid)
 
 static int
-set_undef_off_zero(vector strvec, void *ptr)
+set_undef_off_zero(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	char * buff;
 	int *int_ptr = (int *)ptr;
@@ -827,7 +840,7 @@ declare_hw_handler(fast_io_fail, set_undef_off_zero)
 declare_hw_snprint(fast_io_fail, print_undef_off_zero)
 
 static int
-set_dev_loss(vector strvec, void *ptr)
+set_dev_loss(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	char * buff;
 	unsigned int *uint_ptr = (unsigned int *)ptr;
@@ -870,7 +883,7 @@ declare_hw_handler(eh_deadline, set_undef_off_zero)
 declare_hw_snprint(eh_deadline, print_undef_off_zero)
 
 static int
-set_pgpolicy(vector strvec, void *ptr)
+set_pgpolicy(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	char * buff;
 	int *int_ptr = (int *)ptr;
@@ -936,7 +949,8 @@ get_sys_max_fds(int *max_fds)
 
 
 static int
-max_fds_handler(struct config *conf, vector strvec)
+max_fds_handler(struct config *conf, vector strvec, const char *file,
+		int line_nr)
 {
 	char * buff;
 	int r = 0, max_fds;
@@ -981,7 +995,7 @@ snprint_max_fds (struct config *conf, struct strbuf *buff, const void *data)
 }
 
 static int
-set_rr_weight(vector strvec, void *ptr)
+set_rr_weight(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	int *int_ptr = (int *)ptr;
 	char * buff;
@@ -1025,7 +1039,7 @@ declare_mp_handler(rr_weight, set_rr_weight)
 declare_mp_snprint(rr_weight, print_rr_weight)
 
 static int
-set_pgfailback(vector strvec, void *ptr)
+set_pgfailback(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	int *int_ptr = (int *)ptr;
 	char * buff;
@@ -1075,7 +1089,7 @@ declare_mp_handler(pgfailback, set_pgfailback)
 declare_mp_snprint(pgfailback, print_pgfailback)
 
 static int
-no_path_retry_helper(vector strvec, void *ptr)
+no_path_retry_helper(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	int *int_ptr = (int *)ptr;
 	char * buff;
@@ -1120,7 +1134,8 @@ declare_mp_handler(no_path_retry, no_path_retry_helper)
 declare_mp_snprint(no_path_retry, print_no_path_retry)
 
 static int
-def_log_checker_err_handler(struct config *conf, vector strvec)
+def_log_checker_err_handler(struct config *conf, vector strvec,
+			    const char *file, int line_nr)
 {
 	char * buff;
 
@@ -1193,7 +1208,8 @@ print_reservation_key(struct strbuf *buff,
 }
 
 static int
-def_reservation_key_handler(struct config *conf, vector strvec)
+def_reservation_key_handler(struct config *conf, vector strvec,
+			    const char *file, int line_nr)
 {
 	return set_reservation_key(strvec, &conf->reservation_key,
 				   &conf->sa_flags,
@@ -1209,7 +1225,8 @@ snprint_def_reservation_key (struct config *conf, struct strbuf *buff,
 }
 
 static int
-mp_reservation_key_handler(struct config *conf, vector strvec)
+mp_reservation_key_handler(struct config *conf, vector strvec, const char *file,
+			   int line_nr)
 {
 	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
 	if (!mpe)
@@ -1229,7 +1246,7 @@ snprint_mp_reservation_key (struct config *conf, struct strbuf *buff,
 }
 
 static int
-set_off_int_undef(vector strvec, void *ptr)
+set_off_int_undef(vector strvec, void *ptr, const char *file, int line_nr)
 {
 	int *int_ptr = (int *)ptr;
 	char * buff;
@@ -1370,7 +1387,8 @@ declare_hw_snprint(recheck_wwid, print_yes_no_undef)
 
 
 static int
-def_uxsock_timeout_handler(struct config *conf, vector strvec)
+def_uxsock_timeout_handler(struct config *conf, vector strvec, const char *file,
+			   int line_nr)
 {
 	unsigned int uxsock_timeout;
 	char *buff;
@@ -1390,7 +1408,8 @@ def_uxsock_timeout_handler(struct config *conf, vector strvec)
 }
 
 static int
-hw_vpd_vendor_handler(struct config *conf, vector strvec)
+hw_vpd_vendor_handler(struct config *conf, vector strvec, const char *file,
+		      int line_nr)
 {
 	int i;
 	char *buff;
@@ -1430,7 +1449,8 @@ snprint_hw_vpd_vendor(struct config *conf, struct strbuf *buff,
  * blacklist block handlers
  */
 static int
-blacklist_handler(struct config *conf, vector strvec)
+blacklist_handler(struct config *conf, vector strvec, const char*file,
+		  int line_nr)
 {
 	if (!conf->blist_devnode)
 		conf->blist_devnode = vector_alloc();
@@ -1452,7 +1472,8 @@ blacklist_handler(struct config *conf, vector strvec)
 }
 
 static int
-blacklist_exceptions_handler(struct config *conf, vector strvec)
+blacklist_exceptions_handler(struct config *conf, vector strvec,
+			     const char *file, int line_nr)
 {
 	if (!conf->elist_devnode)
 		conf->elist_devnode = vector_alloc();
@@ -1475,7 +1496,8 @@ blacklist_exceptions_handler(struct config *conf, vector strvec)
 
 #define declare_ble_handler(option)					\
 static int								\
-ble_ ## option ## _handler (struct config *conf, vector strvec)		\
+ble_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
 {									\
 	char *buff;							\
 	int rc;								\
@@ -1494,7 +1516,8 @@ ble_ ## option ## _handler (struct config *conf, vector strvec)		\
 
 #define declare_ble_device_handler(name, option, vend, prod)		\
 static int								\
-ble_ ## option ## _ ## name ## _handler (struct config *conf, vector strvec) \
+ble_ ## option ## _ ## name ## _handler (struct config *conf, vector strvec, \
+					 const char *file, int line_nr)	\
 {									\
 	char * buff;							\
 	int rc;								\
@@ -1536,13 +1559,15 @@ snprint_ble_simple (struct config *conf, struct strbuf *buff, const void *data)
 }
 
 static int
-ble_device_handler(struct config *conf, vector strvec)
+ble_device_handler(struct config *conf, vector strvec, const char *file,
+		   int line_nr)
 {
 	return alloc_ble_device(conf->blist_device);
 }
 
 static int
-ble_except_device_handler(struct config *conf, vector strvec)
+ble_except_device_handler(struct config *conf, vector strvec, const char *file,
+			  int line_nr)
 {
 	return alloc_ble_device(conf->elist_device);
 }
@@ -1574,7 +1599,8 @@ static int snprint_bled_product(struct config *conf, struct strbuf *buff,
  * devices block handlers
  */
 static int
-devices_handler(struct config *conf, vector strvec)
+devices_handler(struct config *conf, vector strvec, const char *file,
+		int line_nr)
 {
 	if (!conf->hwtable)
 		conf->hwtable = vector_alloc();
@@ -1586,7 +1612,8 @@ devices_handler(struct config *conf, vector strvec)
 }
 
 static int
-device_handler(struct config *conf, vector strvec)
+device_handler(struct config *conf, vector strvec, const char *file,
+	       int line_nr)
 {
 	struct hwentry * hwe;
 
@@ -1623,7 +1650,8 @@ declare_hw_snprint(hwhandler, print_str)
  * overrides handlers
  */
 static int
-overrides_handler(struct config *conf, vector strvec)
+overrides_handler(struct config *conf, vector strvec, const char *file,
+		  int line_nr)
 {
 	if (!conf->overrides)
 		conf->overrides = alloc_hwe();
@@ -1640,7 +1668,8 @@ overrides_handler(struct config *conf, vector strvec)
  * multipaths block handlers
  */
 static int
-multipaths_handler(struct config *conf, vector strvec)
+multipaths_handler(struct config *conf, vector strvec, const char *file,
+		   int line_nr)
 {
 	if (!conf->mptable)
 		conf->mptable = vector_alloc();
@@ -1652,7 +1681,8 @@ multipaths_handler(struct config *conf, vector strvec)
 }
 
 static int
-multipath_handler(struct config *conf, vector strvec)
+multipath_handler(struct config *conf, vector strvec, const char *file,
+		  int line_nr)
 {
 	struct mpentry * mpe;
 
@@ -1681,7 +1711,8 @@ declare_mp_snprint(alias, print_str)
  */
 
 static int
-deprecated_handler(struct config *conf, vector strvec)
+deprecated_handler(struct config *conf, vector strvec, const char *file,
+		   int line_nr)
 {
 	char * buff;
 
diff --git a/libmultipath/parser.c b/libmultipath/parser.c
index d5595fb0..68262d0e 100644
--- a/libmultipath/parser.c
+++ b/libmultipath/parser.c
@@ -558,7 +558,8 @@ process_stream(struct config *conf, FILE *stream, vector keywords,
 						goto out;
 				}
 				if (keyword->handler) {
-				    t = keyword->handler(conf, strvec);
+				    t = keyword->handler(conf, strvec, file,
+							 line_nr);
 					r += t;
 					if (t)
 						condlog(1, "%s line %d, parsing failed: %s",
diff --git a/libmultipath/parser.h b/libmultipath/parser.h
index 3452bde1..11ea2278 100644
--- a/libmultipath/parser.h
+++ b/libmultipath/parser.h
@@ -43,7 +43,7 @@ struct strbuf;
 
 /* keyword definition */
 typedef int print_fn(struct config *, struct strbuf *, const void *);
-typedef int handler_fn(struct config *, vector);
+typedef int handler_fn(struct config *, vector, const char *file, int line_nr);
 
 struct keyword {
 	char *string;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

