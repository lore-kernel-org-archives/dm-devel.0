Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54712C6FA82
	for <dm-devel@archiver.kernel.org>; Sat,  3 Sep 2022 11:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662203511;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nashtLjXdraLLLxJnWgKnQNBXl4P7HA3i1fL6Z71gpQ=;
	b=E3twr5J95ftyek8LcVkfBZggJ57UJF54Y5/hEeMewpbR3fsP5msSuD5zZoF+yWm2zWVXZ2
	fRjM2B+O6EVZ5cI6hA47fLXbrcnRbKWr0hfcQEE1m6Dk6CoET2D/dqRPuzh6Hps495EM5B
	6Ur4HT1DwaL1er3O8IxNSKURnIsJZbg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-O3XtYURiPPacYVqqoEIvCA-1; Sat, 03 Sep 2022 07:11:47 -0400
X-MC-Unique: O3XtYURiPPacYVqqoEIvCA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 046B0101E9B1;
	Sat,  3 Sep 2022 11:11:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 59017422E3;
	Sat,  3 Sep 2022 11:11:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C645C1940362;
	Sat,  3 Sep 2022 11:11:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9713F1946A41
 for <dm-devel@listman.corp.redhat.com>; Sat,  3 Sep 2022 11:11:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 61D58945D0; Sat,  3 Sep 2022 11:11:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E95E18EA8
 for <dm-devel@redhat.com>; Sat,  3 Sep 2022 11:11:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 412DB3C0218A
 for <dm-devel@redhat.com>; Sat,  3 Sep 2022 11:11:42 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-344-xLJ5NvqDOIiR0X_UnBL-FQ-1; Sat,
 03 Sep 2022 07:11:40 -0400
X-MC-Unique: xLJ5NvqDOIiR0X_UnBL-FQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id 70A5F209DF;
 Sat,  3 Sep 2022 11:11:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3A59C139F9;
 Sat,  3 Sep 2022 11:11:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id gNqYDGs2E2OqGwAAMHmgww
 (envelope-from <mwilck@suse.com>); Sat, 03 Sep 2022 11:11:39 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat,  3 Sep 2022 13:11:27 +0200
Message-Id: <20220903111128.14367-3-mwilck@suse.com>
In-Reply-To: <20220903111128.14367-1-mwilck@suse.com>
References: <20220903111128.14367-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: [dm-devel] [PATCH 2/3] multipathd.8: remove misleading paragraph
 about multipath
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This has been wrong for a long time. Remove it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/multipathd.8 | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/multipathd/multipathd.8 b/multipathd/multipathd.8
index a828864..ad46a99 100644
--- a/multipathd/multipathd.8
+++ b/multipathd/multipathd.8
@@ -48,10 +48,6 @@ map regains its maximum performance and redundancy.
 With the \fB-k\fR option, \fBmultipathd\fR acts as a client utility that
 sends commands to a running instance of the multipathd daemon (see
 \fBCOMMANDS\fR below).
-
-This daemon executes the external \fBmultipath\fR tool when events occur.
-In turn, the multipath tool signals the multipathd daemon when it is done with
-devmap reconfiguration, so that it can refresh its failed path list.
 .
 .
 .\" ----------------------------------------------------------------------------
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

