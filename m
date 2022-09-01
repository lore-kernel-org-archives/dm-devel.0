Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC16EECAAD1
	for <dm-devel@archiver.kernel.org>; Thu,  1 Sep 2022 16:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662048670;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Jl8kEOWPuu7JZRgGulwVMsOgy9KNkevBMt4J4PyPobw=;
	b=ZbuguzUwJLrky3mthRykWTFKRpE1SZQ9oOtHyahIuqJrgpupcIm7qahHYcLoBLEWAeULGM
	fnNXvg44VNhuwEgRpI44TNDlQynw36tDCIOQc5ZpBYIel3pVzkov0r2ulJBgyf5gmBPlAa
	vXMox0SW0mB0FEYiwn1IVxDt4bWbMHo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-HcELLncoOQKs0ks7mFApDw-1; Thu, 01 Sep 2022 12:11:07 -0400
X-MC-Unique: HcELLncoOQKs0ks7mFApDw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BE1985A589;
	Thu,  1 Sep 2022 16:11:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 295FB945D0;
	Thu,  1 Sep 2022 16:11:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 058A61943214;
	Thu,  1 Sep 2022 16:11:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D621194B945
 for <dm-devel@listman.corp.redhat.com>; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0FF37403162; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C705492C3B
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D11DB85A58F
 for <dm-devel@redhat.com>; Thu,  1 Sep 2022 16:10:13 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_128_GCM_SHA256) id us-mta-452-gabTdKEYOtCMdglu6TS01g-1; Thu,
 01 Sep 2022 12:10:12 -0400
X-MC-Unique: gabTdKEYOtCMdglu6TS01g-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out1.suse.de (Postfix) with ESMTPS id 4398B22B2B;
 Thu,  1 Sep 2022 16:10:09 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0FADA13A79;
 Thu,  1 Sep 2022 16:10:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id 4HFRAmHZEGMPDQAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 01 Sep 2022 16:10:09 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu,  1 Sep 2022 18:09:48 +0200
Message-Id: <20220901160952.2167-13-mwilck@suse.com>
In-Reply-To: <20220901160952.2167-1-mwilck@suse.com>
References: <20220901160952.2167-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 12/16] libmultipath: cleanup_free_ptr(): avoid
 double free
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

... by nullifying the passed pointer after freeing it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmpathutil/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libmpathutil/util.c b/libmpathutil/util.c
index 1539738..6692ac2 100644
--- a/libmpathutil/util.c
+++ b/libmpathutil/util.c
@@ -391,8 +391,10 @@ void cleanup_free_ptr(void *arg)
 {
 	void **p = arg;
 
-	if (p && *p)
+	if (p && *p) {
 		free(*p);
+		*p = NULL;
+	}
 }
 
 void cleanup_fd_ptr(void *arg)
-- 
2.37.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

