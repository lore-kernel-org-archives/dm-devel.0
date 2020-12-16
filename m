Return-Path: <SRS0=g9U1=FU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83FAC2BBCA
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 316B2251A9
	for <dm-devel@archiver.kernel.org>; Wed, 16 Dec 2020 18:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 316B2251A9
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-hvFnJ9J5NI2OBKFB3Rjzjg-1; Wed, 16 Dec 2020 13:19:13 -0500
X-MC-Unique: hvFnJ9J5NI2OBKFB3Rjzjg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4420B8144E5;
	Wed, 16 Dec 2020 18:19:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E3A51971D;
	Wed, 16 Dec 2020 18:19:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E5F191809CAA;
	Wed, 16 Dec 2020 18:19:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BGIIgLR018126 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 13:18:42 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 03100CF616; Wed, 16 Dec 2020 18:18:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2685C77F5
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E032C800B3B
	for <dm-devel@redhat.com>; Wed, 16 Dec 2020 18:18:41 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-185-of_NBgfeOXCnow8tfskhUw-1;
	Wed, 16 Dec 2020 13:18:37 -0500
X-MC-Unique: of_NBgfeOXCnow8tfskhUw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 78744B1C1;
	Wed, 16 Dec 2020 18:18:35 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Wed, 16 Dec 2020 19:17:06 +0100
Message-Id: <20201216181708.22224-28-mwilck@suse.com>
In-Reply-To: <20201216181708.22224-1-mwilck@suse.com>
References: <20201216181708.22224-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BGIIgLR018126
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 27/29] multipathd: common code for "-k" and
	command args
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

'multipathd -k"cmd"' and 'multipath cmd' are the same thing.
Treat it with common code.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 867f0f8..b6a5f5b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3301,6 +3301,8 @@ main (int argc, char *argv[])
 	int err;
 	int foreground = 0;
 	struct config *conf;
+	char *opt_k_arg = NULL;
+	bool opt_k = false;
 
 	ANNOTATE_BENIGN_RACE_SIZED(&multipath_conf, sizeof(multipath_conf),
 				   "Manipulated through RCU");
@@ -3348,16 +3350,9 @@ main (int argc, char *argv[])
 			logsink = LOGSINK_STDERR_WITHOUT_TIME;
 			break;
 		case 'k':
-			logsink = 0;
-			conf = load_config(DEFAULT_CONFIGFILE);
-			if (!conf)
-				exit(1);
-			if (verbosity)
-				libmp_verbosity = verbosity;
-			uxsock_timeout = conf->uxsock_timeout;
-			err = uxclnt(optarg, uxsock_timeout + 100);
-			free_config(conf);
-			return err;
+			opt_k = true;
+			opt_k_arg = optarg;
+			break;
 		case 'B':
 			bindings_read_only = 1;
 			break;
@@ -3373,7 +3368,7 @@ main (int argc, char *argv[])
 			exit(1);
 		}
 	}
-	if (optind < argc) {
+	if (opt_k || optind < argc) {
 		char cmd[CMDSIZE];
 		char * s = cmd;
 		char * c = s;
@@ -3388,14 +3383,20 @@ main (int argc, char *argv[])
 			libmp_verbosity = verbosity;
 		uxsock_timeout = conf->uxsock_timeout;
 		memset(cmd, 0x0, CMDSIZE);
-		while (optind < argc) {
-			if (strchr(argv[optind], ' '))
-				c += snprintf(c, s + CMDSIZE - c, "\"%s\" ", argv[optind]);
-			else
-				c += snprintf(c, s + CMDSIZE - c, "%s ", argv[optind]);
-			optind++;
+		if (opt_k)
+			s = opt_k_arg;
+		else {
+			while (optind < argc) {
+				if (strchr(argv[optind], ' '))
+					c += snprintf(c, s + CMDSIZE - c,
+						      "\"%s\" ", argv[optind]);
+				else
+					c += snprintf(c, s + CMDSIZE - c,
+						      "%s ", argv[optind]);
+				optind++;
+			}
+			c += snprintf(c, s + CMDSIZE - c, "\n");
 		}
-		c += snprintf(c, s + CMDSIZE - c, "\n");
 		err = uxclnt(s, uxsock_timeout + 100);
 		free_config(conf);
 		return err;
-- 
2.29.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

