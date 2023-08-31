Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1504C83F2F
	for <dm-devel@archiver.kernel.org>; Thu, 31 Aug 2023 21:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693519052;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oMLaylnZqAsoefly35ByzdKcRhEzrwLZ8ItlFUYa3Ys=;
	b=RZektghr+XsGSEB4ktPKj8vw+wvPz5I+tyQ3PGjfknhaBZ+79/cVa7QP6kckd7nS9Pg6CL
	l79cfHn+wnDnWk4t/1/8BOhfpcK9STQduX2CshPV/+78KSpI9MuNYaz2oRdsIfqQox1Oqh
	mFZ/PJnB8IxTVsNMLwjCzrA2TRy5WlM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-N09FOkqTO1C2BSkorrTmQA-1; Thu, 31 Aug 2023 17:57:29 -0400
X-MC-Unique: N09FOkqTO1C2BSkorrTmQA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 588AD3C0E47A;
	Thu, 31 Aug 2023 21:57:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B44CF2026D3E;
	Thu, 31 Aug 2023 21:57:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 631E819465B2;
	Thu, 31 Aug 2023 21:57:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5F8621946A48
 for <dm-devel@listman.corp.redhat.com>; Thu, 31 Aug 2023 21:57:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 32524140E970; Thu, 31 Aug 2023 21:57:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 18DB8140E96F;
 Thu, 31 Aug 2023 21:57:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 37VLvGMm030159;
 Thu, 31 Aug 2023 16:57:16 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 37VLvFh4030158;
 Thu, 31 Aug 2023 16:57:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 31 Aug 2023 16:57:10 -0500
Message-Id: <1693519032-30111-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
References: <1693519032-30111-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v2 2/4] libmultipath: make checker_timeout a path
 variable
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
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Factor the code to get the checker_timeout out of select_checker() into
its own select_checker_timeout function, and use that to set a path
variable. This variable will be used by future patches.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 33 ++++++++++++++++++++-------------
 libmultipath/structs.c |  1 +
 libmultipath/structs.h |  1 +
 3 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index df10a68f..91a59880 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -628,6 +628,23 @@ out:
 	return 0;
 }
 
+
+int select_checker_timeout(struct config *conf, struct path *pp)
+{
+	const char *origin;
+
+	pp_set_conf(checker_timeout);
+	if (sysfs_get_timeout(pp, &pp->checker_timeout) > 0) {
+		origin = "(setting: kernel sysfs)";
+		goto out;
+	}
+	pp_set_default(checker_timeout, DEF_TIMEOUT);
+out:
+	condlog(3, "%s checker timeout = %u s %s", pp->dev, pp->checker_timeout,
+		origin);
+	return 0;
+}
+
 /*
  * Current RDAC (NetApp E/EF Series) firmware relies
  * on periodic REPORT TARGET PORT GROUPS for
@@ -664,6 +681,8 @@ int select_checker(struct config *conf, struct path *pp)
 	char *ckr_name;
 	struct checker * c = &pp->checker;
 
+	if (!pp->checker_timeout)
+		select_checker_timeout(conf, pp);
 	if (pp->detect_checker == DETECT_CHECKER_ON) {
 		origin = autodetect_origin;
 		if (check_rdac(pp)) {
@@ -684,19 +703,7 @@ out:
 	checker_get(c, ckr_name);
 	condlog(3, "%s: path_checker = %s %s", pp->dev,
 		checker_name(c), origin);
-	if (conf->checker_timeout) {
-		c->timeout = conf->checker_timeout;
-		condlog(3, "%s: checker timeout = %u s %s",
-			pp->dev, c->timeout, conf_origin);
-	}
-	else if (sysfs_get_timeout(pp, &c->timeout) > 0)
-		condlog(3, "%s: checker timeout = %u s (setting: kernel sysfs)",
-			pp->dev, c->timeout);
-	else {
-		c->timeout = DEF_TIMEOUT;
-		condlog(3, "%s: checker timeout = %u s %s",
-			pp->dev, c->timeout, default_origin);
-	}
+	c->timeout = pp->checker_timeout;
 	return 0;
 }
 
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 39504dca..1b305fd1 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -147,6 +147,7 @@ uninitialize_path(struct path *pp)
 
 	pp->dmstate = PSTATE_UNDEF;
 	pp->uid_attribute = NULL;
+	pp->checker_timeout = 0;
 
 	if (checker_selected(&pp->checker))
 		checker_put(&pp->checker);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 97f9de5a..17e13ee7 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -383,6 +383,7 @@ struct path {
 	int eh_deadline;
 	bool is_checked;
 	bool can_use_env_uid;
+	unsigned int checker_timeout;
 	/* configlet pointers */
 	vector hwe;
 	struct gen_path generic_path;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

