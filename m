Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D375DC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 04:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649910476;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RRyyamKpAYGxuDcpKKIUPenqRgwWyBowG/bC+YcBFU0=;
	b=dh3Er/UjX/1I5ZW6ma7F0Vwgd2p2trtiPtztr2egfnV63zr95Y6Lb0tETI7GnFudewmv35
	+i7oXDCBHtU5UaemklnE39uHXXDF88aqA7JinbyZBYcb8L3/KLhvUMS7k2GBNjRJvOuv2l
	3JlHGJHKgdB+aTLEU6WQFdTakPnEdrE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-uhEszmzBP7CF_xH90t0T4Q-1; Thu, 14 Apr 2022 00:27:53 -0400
X-MC-Unique: uhEszmzBP7CF_xH90t0T4Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2104802803;
	Thu, 14 Apr 2022 04:27:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CDB45580935;
	Thu, 14 Apr 2022 04:27:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 735381940347;
	Thu, 14 Apr 2022 04:27:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 25C231940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 04:27:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 185CAC08087; Thu, 14 Apr 2022 04:27:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 08401C28114;
 Thu, 14 Apr 2022 04:27:49 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23E4RmBi025321;
 Wed, 13 Apr 2022 23:27:48 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23E4RmSU025320;
 Wed, 13 Apr 2022 23:27:48 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 13 Apr 2022 23:27:39 -0500
Message-Id: <1649910461-25263-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH v2 5/7] libmultipath: check the overrides pctable
 for path variables
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Paths will now also check the pctable when checking for attribtes that
exists in both the overrides section and the protocol subsection. Values
in a matching pcentry will be used in preference to values in the
overrides hwentry.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/propsel.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index d2d70090..72b42991 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -79,6 +79,8 @@ static const char conf_origin[] =
 	"(setting: multipath.conf defaults/devices section)";
 static const char overrides_origin[] =
 	"(setting: multipath.conf overrides section)";
+static const char overrides_pce_origin[] =
+	"(setting: multipath.conf overrides protocol section)";
 static const char cmdline_origin[] =
 	"(setting: multipath command line [-p] flag)";
 static const char autodetect_origin[] =
@@ -146,6 +148,27 @@ do {									\
 	}								\
 } while (0)
 
+#define pp_set_ovr_pce(var)						\
+do {									\
+	struct pcentry *_pce;						\
+	int _i;								\
+									\
+	if (conf->overrides) {						\
+		vector_foreach_slot(conf->overrides->pctable, _pce, _i) {	\
+			if (_pce->type == (int)bus_protocol_id(pp) && _pce->var) {	\
+				pp->var = _pce->var;			\
+				origin = overrides_pce_origin;		\
+				goto out;				\
+			}						\
+		}							\
+		if (conf->overrides->var) {				\
+			pp->var = conf->overrides->var;			\
+			origin = overrides_origin;			\
+			goto out;					\
+		}							\
+	}								\
+} while (0)
+
 int select_mode(struct config *conf, struct multipath *mp)
 {
 	const char *origin;
@@ -774,7 +797,7 @@ int select_fast_io_fail(struct config *conf, struct path *pp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	pp_set_ovr(fast_io_fail);
+	pp_set_ovr_pce(fast_io_fail);
 	pp_set_hwe(fast_io_fail);
 	pp_set_conf(fast_io_fail);
 	pp_set_default(fast_io_fail, DEFAULT_FAST_IO_FAIL);
@@ -790,7 +813,7 @@ int select_dev_loss(struct config *conf, struct path *pp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	pp_set_ovr(dev_loss);
+	pp_set_ovr_pce(dev_loss);
 	pp_set_hwe(dev_loss);
 	pp_set_conf(dev_loss);
 	pp->dev_loss = DEV_LOSS_TMO_UNSET;
@@ -807,7 +830,7 @@ int select_eh_deadline(struct config *conf, struct path *pp)
 	const char *origin;
 	STRBUF_ON_STACK(buff);
 
-	pp_set_ovr(eh_deadline);
+	pp_set_ovr_pce(eh_deadline);
 	pp_set_hwe(eh_deadline);
 	pp_set_conf(eh_deadline);
 	pp->eh_deadline = EH_DEADLINE_UNSET;
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

