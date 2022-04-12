Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B49ABC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 02:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649728864;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=T2AqUfWJVhozQhpajO/ccDhlwKYb5XAgyZ1NDfRYjkM=;
	b=bHa2LY0itilNfHiLX5hfx+RynCAhoF6agMdwm6N5xyz2bdzV3BpX0HrpKfXGsu2a5Sxyi6
	Rbvmzp196kN8+/jDp6NSI1fFnPosQCZCdxESkyZ0JVFTLvlMbixtFCW53KV6suahFLTrKY
	XL/m47uvpy7n7YFx8xdHqBzt5CfCcMU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-5BBmXYnJORKIAf0JHPKYKQ-1; Mon, 11 Apr 2022 22:00:13 -0400
X-MC-Unique: 5BBmXYnJORKIAf0JHPKYKQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A528386B8AF;
	Tue, 12 Apr 2022 02:00:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9194740CFD13;
	Tue, 12 Apr 2022 02:00:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 499691949762;
	Tue, 12 Apr 2022 02:00:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 22AA91940369
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 02:00:09 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0688740E80F3; Tue, 12 Apr 2022 02:00:09 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ECEE440E80F0;
 Tue, 12 Apr 2022 02:00:08 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 23C207xq011852;
 Mon, 11 Apr 2022 21:00:07 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 23C207Lk011851;
 Mon, 11 Apr 2022 21:00:07 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 11 Apr 2022 20:59:56 -0500
Message-Id: <1649728799-11790-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
References: <1649728799-11790-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 6/9] libmultipath: make snprint_pctable indent a
 variable amount
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

Instead of always indenting two tabs, which is what is needed in for
the protocol subsection of the device subsection, indent a variable
amount. This will be needed in a future patch.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index 46d231ed..093e43aa 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -1407,28 +1407,42 @@ int snprint_multipath_topology_json (struct strbuf *buff,
 }
 
 static int
-snprint_pcentry (struct strbuf *buff, const struct pcentry *pce,
+snprint_pcentry (struct strbuf *buff, int indent, const struct pcentry *pce,
 		 const struct keyword *rootkw)
 {
 	int i, rc;
 	struct keyword *kw;
 	size_t initial_len = get_strbuf_len(buff);
+	STRBUF_ON_STACK(fmt);
 
-	if ((rc = append_strbuf_str(buff, "\t\tprotocol {\n")) < 0)
+	for (i = 0; i < indent; i++)
+		if ((rc = append_strbuf_str(&fmt, "\t")) < 0)
+			return rc;
+	if ((rc = append_strbuf_str(&fmt, "\t%k %v\n")) < 0)
+			return rc;
+
+	for (i = 0; i < indent; i++)
+		if ((rc = append_strbuf_str(buff, "\t")) < 0)
+			return rc;
+	if ((rc = append_strbuf_str(buff, "protocol {\n")) < 0)
 		return rc;
 
 	iterate_sub_keywords(rootkw, kw, i) {
-		if ((rc = snprint_keyword(buff, "\t\t\t%k %v\n", kw, pce)) < 0)
+		if ((rc = snprint_keyword(buff, get_strbuf_str(&fmt), kw,
+					  pce)) < 0)
 			return rc;
 	}
 
-	if ((rc = append_strbuf_str(buff, "\t\t}\n")) < 0)
+	for (i = 0; i < indent; i++)
+		if ((rc = append_strbuf_str(buff, "\t")) < 0)
+			return rc;
+	if ((rc = append_strbuf_str(buff, "}\n")) < 0)
 		return rc;
 	return get_strbuf_len(buff) - initial_len;
 }
 
 static int
-snprint_pctable (const struct config *conf, struct strbuf *buff,
+snprint_pctable (const struct config *conf, struct strbuf *buff, int indent,
 		 const struct _vector *pctable, const struct keyword *rootkw)
 {
 	int i, rc;
@@ -1439,7 +1453,7 @@ snprint_pctable (const struct config *conf, struct strbuf *buff,
 	assert(rootkw);
 
 	vector_foreach_slot(pctable, pce, i) {
-		if ((rc = snprint_pcentry(buff, pce, rootkw)) < 0)
+		if ((rc = snprint_pcentry(buff, indent, pce, rootkw)) < 0)
 			return rc;
 	}
 	return get_strbuf_len(buff) - initial_len;
@@ -1468,7 +1482,7 @@ snprint_hwentry (const struct config *conf,
 	}
 
 	if (hwe->pctable &&
-	    (rc = snprint_pctable(conf, buff, hwe->pctable, rootkw)) < 0)
+	    (rc = snprint_pctable(conf, buff, 2, hwe->pctable, rootkw)) < 0)
 		return rc;
 
 	if ((rc = append_strbuf_str(buff, "\t}\n")) < 0)
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

