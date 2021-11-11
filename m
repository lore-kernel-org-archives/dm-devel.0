Return-Path: <SRS0=8dGD=P6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC3AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:54:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91C6961247
	for <dm-devel@archiver.kernel.org>; Thu, 11 Nov 2021 18:54:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 91C6961247
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636656862;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=1lxafRR7ucOTbpR+n0ycrfpUwb3a3/gv1/+5tRuAn2A=;
	b=MUJYaTIZH7enq8BbDOCvKUzBruF6FqmACNWIfZPf8RN6nYGMG1qAoHYonFX/ki5GMSjw2H
	7p7KlJjU7Q97a+46dB9PWaT+xnd4qINPQHIYWzP8rDoQ+uWwP5RGhkPJnVopSUuh491qNk
	NdVBPP8HLtYoGjoEbD2Fvu8pY/TzoRI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-sKcNeqjQMy2ZSh7S1NeN_w-1; Thu, 11 Nov 2021 13:54:19 -0500
X-MC-Unique: sKcNeqjQMy2ZSh7S1NeN_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A2C7107AD64;
	Thu, 11 Nov 2021 18:54:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E75FC19724;
	Thu, 11 Nov 2021 18:54:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B47954E590;
	Thu, 11 Nov 2021 18:54:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ABIsC3V027792 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Nov 2021 13:54:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 268C879451; Thu, 11 Nov 2021 18:54:12 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0366B79450;
	Thu, 11 Nov 2021 18:54:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1ABIs9Sb026130; 
	Thu, 11 Nov 2021 12:54:09 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1ABIs8bZ026129;
	Thu, 11 Nov 2021 12:54:09 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 11 Nov 2021 12:53:50 -0600
Message-Id: <1636656832-26062-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
References: <1636656832-26062-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v3 7/9] libmultipath: deprecate file and
	directory config options
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Having multipath able to select pathnames for the files and directories
it needs causes unnecessary maintainer headaches. Mark these as
deprecated, but still support them for now.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/dict.c        | 19 +++++++++++++++----
 multipath/multipath.conf.5 |  5 +++++
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 149d3348..d14be340 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -268,6 +268,15 @@ def_ ## option ## _handler (struct config *conf, vector strvec,		\
 	return function (strvec, &conf->option, file, line_nr);		\
 }
 
+#define declare_def_warn_handler(option, function)			\
+static int								\
+def_ ## option ## _handler (struct config *conf, vector strvec,		\
+			    const char *file, int line_nr)		\
+{									\
+	condlog(2, "%s line %d, \"" #option "\" is deprecated and will be disabled in a future release", file, line_nr);				\
+	return function (strvec, &conf->option, file, line_nr);		\
+}
+
 #define declare_def_range_handler(option, minval, maxval)			\
 static int								\
 def_ ## option ## _handler (struct config *conf, vector strvec,         \
@@ -421,7 +430,7 @@ declare_def_snprint(verbosity, print_int)
 declare_def_handler(reassign_maps, set_yes_no)
 declare_def_snprint(reassign_maps, print_yes_no)
 
-declare_def_handler(multipath_dir, set_dir)
+declare_def_warn_handler(multipath_dir, set_dir)
 declare_def_snprint(multipath_dir, print_str)
 
 static int def_partition_delim_handler(struct config *conf, vector strvec,
@@ -654,13 +663,13 @@ declare_hw_snprint(user_friendly_names, print_yes_no_undef)
 declare_mp_handler(user_friendly_names, set_yes_no_undef)
 declare_mp_snprint(user_friendly_names, print_yes_no_undef)
 
-declare_def_handler(bindings_file, set_path)
+declare_def_warn_handler(bindings_file, set_path)
 declare_def_snprint(bindings_file, print_str)
 
-declare_def_handler(wwids_file, set_path)
+declare_def_warn_handler(wwids_file, set_path)
 declare_def_snprint(wwids_file, print_str)
 
-declare_def_handler(prkeys_file, set_path)
+declare_def_warn_handler(prkeys_file, set_path)
 declare_def_snprint(prkeys_file, print_str)
 
 declare_def_handler(retain_hwhandler, set_yes_no_undef)
@@ -760,6 +769,8 @@ def_config_dir_handler(struct config *conf, vector strvec, const char *file,
 	/* this is only valid in the main config file */
 	if (conf->processed_main_config)
 		return 0;
+	condlog(2, "%s line %d, \"config_dir\" is deprecated and will be disabled in a future release",
+		file, line_nr);
 	return set_path(strvec, &conf->config_dir, file, line_nr);
 }
 declare_def_snprint(config_dir, print_str)
diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
index 42a15ffd..17771e27 100644
--- a/multipath/multipath.conf.5
+++ b/multipath/multipath.conf.5
@@ -178,6 +178,7 @@ The default is: \fBno\fR
 .
 .TP
 .B multipath_dir
+This option is deprecated, and will be removed in a future release.
 Directory where the dynamic shared objects are stored. Defined at compile time,
 commonly \fI/lib64/multipath/\fR or \fI/lib/multipath/\fR.
 .RS
@@ -742,6 +743,7 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B bindings_file
+This option is deprecated, and will be removed in a future release.
 The full pathname of the binding file to be used when the user_friendly_names
 option is set.
 .RS
@@ -752,6 +754,7 @@ The default is: \fB/etc/multipath/bindings\fR
 .
 .TP
 .B wwids_file
+This option is deprecated, and will be removed in a future release.
 The full pathname of the WWIDs file, which is used by multipath to keep track
 of the WWIDs for LUNs it has created multipath devices on in the past.
 .RS
@@ -762,6 +765,7 @@ The default is: \fB/etc/multipath/wwids\fR
 .
 .TP
 .B prkeys_file
+This option is deprecated, and will be removed in a future release.
 The full pathname of the prkeys file, which is used by multipathd to keep
 track of the persistent reservation key used for a specific WWID, when
 \fIreservation_key\fR is set to \fBfile\fR.
@@ -933,6 +937,7 @@ The default is: \fB<unset>\fR
 .
 .TP
 .B config_dir
+This option is deprecated, and will be removed in a future release.
 If set to anything other than "", multipath will search this directory
 alphabetically for file ending in ".conf" and it will read configuration
 information from them, just as if it was in \fI/etc/multipath.conf\fR.
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

