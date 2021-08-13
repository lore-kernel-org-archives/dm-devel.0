Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23EEC4338F
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:39:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 370BB610CC
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:39:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 370BB610CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-DhtBksg4N5qVQo_2j5PQCQ-1; Fri, 13 Aug 2021 17:38:38 -0400
X-MC-Unique: DhtBksg4N5qVQo_2j5PQCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57F82802937;
	Fri, 13 Aug 2021 21:38:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FF781B472;
	Fri, 13 Aug 2021 21:38:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 161044A7CB;
	Fri, 13 Aug 2021 21:38:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17DLcIVI015512 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 17:38:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 635FC1054FCF; Fri, 13 Aug 2021 21:38:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F75A1054FCB
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37B5996B060
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:16 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-593-At62PLKbPae2yWb_NI5mMw-1;
	Fri, 13 Aug 2021 17:38:12 -0400
X-MC-Unique: At62PLKbPae2yWb_NI5mMw-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 12AAD20C28AD;
	Fri, 13 Aug 2021 14:38:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 12AAD20C28AD
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Fri, 13 Aug 2021 14:37:59 -0700
Message-Id: <20210813213801.297051-5-tusharsu@linux.microsoft.com>
In-Reply-To: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
References: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17DLcIVI015512
X-loop: dm-devel@redhat.com
Cc: sfr@canb.auug.org.au, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	public@thson.de, tusharsu@linux.microsoft.com,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 4/6] dm ima: add a warning in dm_init if
	duplicate ima events are not measured
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The end-users of DM devices/targets may remove and re-create the same
device multiple times.  IMA does not measure such duplicate events if the
configuration CONFIG_IMA_DISABLE_HTABLE is set to 'n'.
To avoid confusion, the end-users need some indication on the client
if that configuration option is disabled.

Add a one-time warning to dmesg during dm_init if
CONFIG_IMA_DISABLE_HTABLE is set to 'n', to notify the end-users that
duplicate events will not be measured in the ima log.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 drivers/md/dm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2e82757b4ab7..948cb0dc5fc4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -265,6 +265,12 @@ static int __init dm_init(void)
 
 	int r, i;
 
+#if (IS_ENABLED(CONFIG_BLK_DEV_DM) && IS_ENABLED(CONFIG_IMA) \
+	&& !IS_ENABLED(CONFIG_IMA_DISABLE_HTABLE))
+	DMWARN("CONFIG_IMA_DISABLE_HTABLE is disabled."
+	       " Duplicate IMA measurements will not be recorded in the IMA log.");
+#endif
+
 	for (i = 0; i < count; i++) {
 		r = _inits[i]();
 		if (r)
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

