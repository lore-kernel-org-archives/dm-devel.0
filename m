Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5356C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649728814;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=rb7GtDs/9/B7qelGyrpgE7dCcuyEOZiMGe4s2V6AAtE=;
	b=gsphJLL154u86ObzwPQfvZU7fXdIeM/j2L8sLtUKXRcu+DINwZQDrQ3nlIHTTA6GZ3yGG3
	5MDCMGBrZuUpsnNJxEa/jZjpNVg2p6jLyEw0QlbFtCxsCBYlySMNfH40yftEk0P+xAFBu0
	j1ui2GnD8eHRwr4pruQM+srLemXDARs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-udAm6nkiPsWDMomnBlnPnQ-1; Mon, 11 Apr 2022 22:00:11 -0400
X-MC-Unique: udAm6nkiPsWDMomnBlnPnQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64CDF805F67;
	Tue, 12 Apr 2022 02:00:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 504FF407F77F;
	Tue, 12 Apr 2022 02:00:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 168FC1940365;
	Tue, 12 Apr 2022 02:00:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D98EE194037A
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 02:00:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C56A740E80E0; Tue, 12 Apr 2022 02:00:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B733740E80F0;
 Tue, 12 Apr 2022 02:00:07 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23C2065u011848;
 Mon, 11 Apr 2022 21:00:06 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23C206di011847;
 Mon, 11 Apr 2022 21:00:06 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 11 Apr 2022 20:59:55 -0500
Message-Id: <1649728799-11790-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 5/9] libmultipath: check the hwentry pctable for
 path variables
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For the config values that exist in the proctol subsection of the device
configs, paths will now also check the pctable when checking a hwentry
for a value. Values in a matching pcentry will be used in preference to
values in that hwentry.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d2d70090..762b7fcb 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -73,6 +73,8 @@ do {									\
 static const char default_origin[] = "(setting: multipath internal)";
 static const char hwe_origin[] =
 	"(setting: storage device configuration)";
+static const char hwe_pce_origin[] =
+	"(setting: storage device procotol section)";
 static const char multipaths_origin[] =
 	"(setting: multipath.conf multipaths section)";
 static const char conf_origin[] =
@@ -146,6 +148,28 @@ do {									\
 	}								\
 } while (0)
 
+#define pp_set_hwe_pce(var)						\
+do {									\
+	struct hwentry *_hwe;						\
+	struct pcentry *_pce;						\
+	int _i, _j;							\
+									\
+	vector_foreach_slot(pp->hwe, _hwe, _i) {			\
+		vector_foreach_slot(_hwe->pctable, _pce, _j) {		\
+			if (_pce->type == (int)bus_protocol_id(pp) && _pce->var) {	\
+				pp->var = _pce->var;			\
+				origin = hwe_pce_origin;		\
+				goto out;				\
+			}						\
+		}							\
+		if (_hwe->var) {					\
+			pp->var = _hwe->var;				\
+			origin = hwe_origin;				\
+			goto out;					\
+		}							\
+	}								\
+} while (0)
+
 int select_mode(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
@@ -775,7 +799,7 @@ int select_fast_io_fail(struct config *conf, struct path *pp)
 	STRBUF_ON_STACK(buff);
 
 	pp_set_ovr(fast_io_fail);
-	pp_set_hwe(fast_io_fail);
+	pp_set_hwe_pce(fast_io_fail);
 	pp_set_conf(fast_io_fail);
 	pp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
 out:
@@ -791,7 +815,7 @@ int select_dev_loss(struct config *conf, struct path *pp)
 	STRBUF_ON_STACK(buff);
 
 	pp_set_ovr(dev_loss);
-	pp_set_hwe(dev_loss);
+	pp_set_hwe_pce(dev_loss);
 	pp_set_conf(dev_loss);
 	pp->dev_loss = DEV_LOSS_TMO_UNSET;
 	return 0;
@@ -808,7 +832,7 @@ int select_eh_deadline(struct config *conf, struct path *pp)
 	STRBUF_ON_STACK(buff);
 
 	pp_set_ovr(eh_deadline);
-	pp_set_hwe(eh_deadline);
+	pp_set_hwe_pce(eh_deadline);
 	pp_set_conf(eh_deadline);
 	pp->eh_deadline = EH_DEADLINE_UNSET;
 	/* not changing sysfs in default cause, so don't print anything */
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

