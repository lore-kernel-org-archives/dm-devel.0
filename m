Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC99DC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 85B5861B62
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 85B5861B62
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637184115;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8aYsRqcjdn6/VfhUi18WTVaV33uacr5GDIgK9mFnMIc=;
	b=eTByVuHrI74bPwkFF3kGZO76v1fhmb6x90JF6z74xLTUh3q6qC9VnfUYEAIpjM+DttcMB8
	4sh/uidtceCjcD8BBH3QteXbv9vRk6nRzccec7HR1hDlyJdxwkrieZe9ORa9r7UBWeqUQy
	gNhGW0o1eCyOOC6qmo1RCf1OBiXn4m8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-dxKUmb9lNsyb-L8hPuSe3Q-1; Wed, 17 Nov 2021 16:21:52 -0500
X-MC-Unique: dxKUmb9lNsyb-L8hPuSe3Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A03E1006AA1;
	Wed, 17 Nov 2021 21:21:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EB78ADF9;
	Wed, 17 Nov 2021 21:21:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 08F1A4E58E;
	Wed, 17 Nov 2021 21:21:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHLLj12025333 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 16:21:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 86D3A17CEE; Wed, 17 Nov 2021 21:21:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D2735D9DE;
	Wed, 17 Nov 2021 21:21:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHLLbmi004955; 
	Wed, 17 Nov 2021 15:21:37 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHLLbDW004954;
	Wed, 17 Nov 2021 15:21:37 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 15:21:24 -0600
Message-Id: <1637184084-4882-10-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 9/9] libmultipath: add path wildcard "%I" for
	init state
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

From: Martin Wilck <mwilck@suse.com>

Enable printing pp->initialized with 'multipathd show paths format "%I"'.
This is supposed to go on top of Ben's "multipathd: remove udev settle
dependency" series, to simplify checking multipathd's state.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/print.c   | 21 +++++++++++++++++++++
 libmultipath/structs.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/libmultipath/print.c b/libmultipath/print.c
index d2ef0104..e61349f9 100644
--- a/libmultipath/print.c
+++ b/libmultipath/print.c
@@ -504,6 +504,26 @@ snprint_dm_path_state (struct strbuf *buff, const struct path * pp)
 	}
 }
 
+static int snprint_initialized(struct strbuf *buff, const struct path * pp)
+{
+	static const char *init_state_name[] = {
+		[INIT_NEW] = "new",
+		[INIT_FAILED] = "failed",
+		[INIT_MISSING_UDEV] = "udev-missing",
+		[INIT_REQUESTED_UDEV] = "udev-requested",
+		[INIT_OK] = "ok",
+		[INIT_REMOVED] = "removed",
+		[INIT_PARTIAL] = "partial",
+	};
+	const char *str;
+
+	if (pp->initialized < INIT_NEW || pp->initialized >= __INIT_LAST)
+		str = "undef";
+	else
+		str = init_state_name[pp->initialized];
+	return append_strbuf_str(buff, str);
+}
+
 static int
 snprint_vpr (struct strbuf *buff, const struct path * pp)
 {
@@ -804,6 +824,7 @@ struct path_data pd[] = {
 	{'g', "vpd page data", 0, snprint_path_vpd_data},
 	{'0', "failures",      0, snprint_path_failures},
 	{'P', "protocol",      0, snprint_path_protocol},
+	{'I', "init_st",       0, snprint_initialized},
 	{0, NULL, 0 , NULL}
 };
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c21d1eda..c0f8929c 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -206,6 +206,7 @@ enum initialized_states {
 	 * change uevent is received.
 	 */
 	INIT_PARTIAL,
+	__INIT_LAST,
 };
 
 enum prkey_sources {
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

