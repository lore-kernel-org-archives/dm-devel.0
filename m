Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD80C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 18 Mar 2022 22:34:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-qMulnOHrMFOUoc4uz_41gA-1; Fri, 18 Mar 2022 18:34:02 -0400
X-MC-Unique: qMulnOHrMFOUoc4uz_41gA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F194A1044561;
	Fri, 18 Mar 2022 22:34:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DE7E340FF417;
	Fri, 18 Mar 2022 22:34:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 67F33194E109;
	Fri, 18 Mar 2022 22:33:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 14719194E109
 for <dm-devel@listman.corp.redhat.com>; Fri, 18 Mar 2022 22:33:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E6A824087D94; Fri, 18 Mar 2022 22:33:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E25894087D82
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8949101A54C
 for <dm-devel@redhat.com>; Fri, 18 Mar 2022 22:33:55 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-yzE3V43MNaaLBW2PAaAtRA-1; Fri, 18 Mar 2022 18:33:52 -0400
X-MC-Unique: yzE3V43MNaaLBW2PAaAtRA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id DBCCE21109;
 Fri, 18 Mar 2022 22:33:50 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D506132D4;
 Fri, 18 Mar 2022 22:33:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id ENWCJM4INWLSdwAAMHmgww
 (envelope-from <mwilck@suse.com>); Fri, 18 Mar 2022 22:33:50 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Guozhonghua <guozh88@chinatelecom.cn>
Date: Fri, 18 Mar 2022 23:33:36 +0100
Message-Id: <20220318223339.4226-9-mwilck@suse.com>
In-Reply-To: <20220318223339.4226-1-mwilck@suse.com>
References: <20220318223339.4226-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Subject: [dm-devel] [PATCH v2 08/11] libmultipath: warn only once about
 deprecated options
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/dict.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index 2af9764..26cbe78 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -279,7 +279,11 @@ static int								\
 def_ ## option ## _handler (struct config *conf, vector strvec,		\
 			    const char *file, int line_nr)		\
 {									\
-	condlog(2, "%s line %d, \"" #option "\" is deprecated and will be disabled in a future release", file, line_nr);				\
+	static bool warned;						\
+	if (!warned) {							\
+		condlog(2, "%s line %d, \"" #option "\" is deprecated and will be disabled in a future release", file, line_nr); \
+		warned = true;						\
+	}								\
 	return function (strvec, &conf->option, file, line_nr);		\
 }
 
@@ -829,14 +833,19 @@ static int
 def_config_dir_handler(struct config *conf, vector strvec, const char *file,
 		       int line_nr)
 {
+	static bool warned;
+
 	/* this is only valid in the main config file */
 	if (conf->processed_main_config) {
 		condlog(1, "%s line %d, config_dir option only valid in /etc/multipath.conf",
 			file, line_nr);
 		return 0;
 	}
-	condlog(2, "%s line %d, \"config_dir\" is deprecated and will be disabled in a future release",
-		file, line_nr);
+	if (!warned) {
+		condlog(2, "%s line %d, \"config_dir\" is deprecated and will be disabled in a future release",
+			file, line_nr);
+		warned = true;
+	}
 	return set_path(strvec, &conf->config_dir, file, line_nr);
 }
 declare_def_snprint(config_dir, print_str)
-- 
2.35.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

