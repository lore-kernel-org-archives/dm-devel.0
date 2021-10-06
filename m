Return-Path: <SRS0=PPuu=O2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D5FC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:04:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E3B7C61186
	for <dm-devel@archiver.kernel.org>; Wed,  6 Oct 2021 20:04:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E3B7C61186
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1633550695;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wcBRdpEJQkzlKPhIb6W5M9lC7F+W0a4yHW1lMW2Ya5w=;
	b=AGqfXqCVs15tz5WbzgoGjUEtkVZCu9rrqmPG5WZvdjj/ewUbun4WQh98KOn+iYZj+XvNjO
	JwCusMJzj+MulN0rI30xHYtg0nleb9Syg02WWIE5+RO36QE1DfePRtGeiIhlj1jB/cRNOG
	+Z/zqFFQWamPN4K22SlwQwJ26bUzvFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-xnEYW05gNYqsJMQSCSSDeQ-1; Wed, 06 Oct 2021 16:04:53 -0400
X-MC-Unique: xnEYW05gNYqsJMQSCSSDeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA465835DE4;
	Wed,  6 Oct 2021 20:04:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8CCC05D9DE;
	Wed,  6 Oct 2021 20:04:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 64569180BAD1;
	Wed,  6 Oct 2021 20:04:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 196K4bow020097 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 6 Oct 2021 16:04:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 454539AA22; Wed,  6 Oct 2021 20:04:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A0085C1C5;
	Wed,  6 Oct 2021 20:04:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 196K4W0O025634; 
	Wed, 6 Oct 2021 15:04:33 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 196K4Wbp025633;
	Wed, 6 Oct 2021 15:04:32 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed,  6 Oct 2021 15:04:21 -0500
Message-Id: <1633550663-25571-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 6/8] libmultipath: improve checks for set_str
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

multipath always requires absolute pathnames, so make sure all file and
directory names start with a slash.  Also check that the directories
exist.  Finally, some strings, like the alias, will be used in paths.
These must not contain the slash character '/', since it is a forbidden
character in file/directory names. This patch adds seperate handlers for
these three cases. If a config line is invalid, these handlers retain
the existing config string, if any.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c | 88 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 10 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 1758bd26..91333068 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -5,6 +5,8 @@
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
  */
 #include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
 #include <pwd.h>
 #include <string.h>
 #include "checkers.h"
@@ -111,6 +113,72 @@ set_str(vector strvec, void *ptr, const char *file, int line_nr)
 	return 0;
 }
 
+static int
+set_dir(vector strvec, void *ptr, const char *file, int line_nr)
+{
+	char **str_ptr = (char **)ptr;
+	char *old_str = *str_ptr;
+	struct stat sb;
+
+	*str_ptr = set_value(strvec);
+	if (!*str_ptr) {
+		free(old_str);
+		return 1;
+	}
+	if ((*str_ptr)[0] != '/'){
+		condlog(1, "%s line %d, %s is not an absolute directory path. Ignoring", file, line_nr, *str_ptr);
+		*str_ptr = old_str;
+	} else {
+		if (stat(*str_ptr, &sb) == 0 && S_ISDIR(sb.st_mode))
+			free(old_str);
+		else {
+			condlog(1, "%s line %d, %s is not an existing directory. Ignoring", file, line_nr, *str_ptr);
+			*str_ptr = old_str;
+		}
+	}
+	return 0;
+}
+
+static int
+set_path(vector strvec, void *ptr, const char *file, int line_nr)
+{
+	char **str_ptr = (char **)ptr;
+	char *old_str = *str_ptr;
+
+	*str_ptr = set_value(strvec);
+	if (!*str_ptr) {
+		free(old_str);
+		return 1;
+	}
+	if ((*str_ptr)[0] != '/'){
+		condlog(1, "%s line %d, %s is not an absolute path. Ignoring",
+			file, line_nr, *str_ptr);
+		*str_ptr = old_str;
+	} else
+		free(old_str);
+	return 0;
+}
+
+static int
+set_str_noslash(vector strvec, void *ptr, const char *file, int line_nr)
+{
+	char **str_ptr = (char **)ptr;
+	char *old_str = *str_ptr;
+
+	*str_ptr = set_value(strvec);
+	if (!*str_ptr) {
+		free(old_str);
+		return 1;
+	}
+	if (strchr(*str_ptr, '/')) {
+		condlog(1, "%s line %d, %s cannot contain a slash. Ignoring",
+			file, line_nr, *str_ptr);
+		*str_ptr = old_str;
+	} else
+		free(old_str);
+	return 0;
+}
+
 static int
 set_yes_no(vector strvec, void *ptr, const char *file, int line_nr)
 {
@@ -353,13 +421,13 @@ declare_def_snprint(verbosity, print_int)
 declare_def_handler(reassign_maps, set_yes_no)
 declare_def_snprint(reassign_maps, print_yes_no)
 
-declare_def_handler(multipath_dir, set_str)
+declare_def_handler(multipath_dir, set_dir)
 declare_def_snprint(multipath_dir, print_str)
 
 static int def_partition_delim_handler(struct config *conf, vector strvec,
 				       const char *file, int line_nr)
 {
-	int rc = set_str(strvec, &conf->partition_delim, file, line_nr);
+	int rc = set_str_noslash(strvec, &conf->partition_delim, file, line_nr);
 
 	if (rc != 0)
 		return rc;
@@ -490,11 +558,11 @@ declare_hw_snprint(prio_name, print_str)
 declare_mp_handler(prio_name, set_str)
 declare_mp_snprint(prio_name, print_str)
 
-declare_def_handler(alias_prefix, set_str)
+declare_def_handler(alias_prefix, set_str_noslash)
 declare_def_snprint_defstr(alias_prefix, print_str, DEFAULT_ALIAS_PREFIX)
-declare_ovr_handler(alias_prefix, set_str)
+declare_ovr_handler(alias_prefix, set_str_noslash)
 declare_ovr_snprint(alias_prefix, print_str)
-declare_hw_handler(alias_prefix, set_str)
+declare_hw_handler(alias_prefix, set_str_noslash)
 declare_hw_snprint(alias_prefix, print_str)
 
 declare_def_handler(prio_args, set_str)
@@ -586,13 +654,13 @@ declare_hw_snprint(user_friendly_names, print_yes_no_undef)
 declare_mp_handler(user_friendly_names, set_yes_no_undef)
 declare_mp_snprint(user_friendly_names, print_yes_no_undef)
 
-declare_def_handler(bindings_file, set_str)
+declare_def_handler(bindings_file, set_path)
 declare_def_snprint(bindings_file, print_str)
 
-declare_def_handler(wwids_file, set_str)
+declare_def_handler(wwids_file, set_path)
 declare_def_snprint(wwids_file, print_str)
 
-declare_def_handler(prkeys_file, set_str)
+declare_def_handler(prkeys_file, set_path)
 declare_def_snprint(prkeys_file, print_str)
 
 declare_def_handler(retain_hwhandler, set_yes_no_undef)
@@ -692,7 +760,7 @@ def_config_dir_handler(struct config *conf, vector strvec, const char *file,
 	/* this is only valid in the main config file */
 	if (conf->processed_main_config)
 		return 0;
-	return set_str(strvec, &conf->config_dir, file, line_nr);
+	return set_path(strvec, &conf->config_dir, file, line_nr);
 }
 declare_def_snprint(config_dir, print_str)
 
@@ -1732,7 +1800,7 @@ multipath_handler(struct config *conf, vector strvec, const char *file,
 declare_mp_handler(wwid, set_str)
 declare_mp_snprint(wwid, print_str)
 
-declare_mp_handler(alias, set_str)
+declare_mp_handler(alias, set_str_noslash)
 declare_mp_snprint(alias, print_str)
 
 /*
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

