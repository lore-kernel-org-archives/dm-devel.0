Return-Path: <SRS0=CL6l=HT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EEBC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:39:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3F76364D9F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Feb 2021 15:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F76364D9F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=inria.fr
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-3h_Z-AQbPOSGP0azMEEKIQ-1; Wed, 17 Feb 2021 10:39:34 -0500
X-MC-Unique: 3h_Z-AQbPOSGP0azMEEKIQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73FF4192D789;
	Wed, 17 Feb 2021 15:39:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 26AC710013D7;
	Wed, 17 Feb 2021 15:39:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E7F7318095CA;
	Wed, 17 Feb 2021 15:39:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AK7Wok009186 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 15:07:33 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A8F74ED174; Wed, 10 Feb 2021 20:07:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1E1EE5964
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 20:07:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 616CF185A78E
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 20:07:30 +0000 (UTC)
Received: from mail2-relais-roc.national.inria.fr
	(mail2-relais-roc.national.inria.fr [192.134.164.83]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-572-wOpA_bO7NGqp3s3jdxfxxQ-1;
	Wed, 10 Feb 2021 15:07:26 -0500
X-MC-Unique: wOpA_bO7NGqp3s3jdxfxxQ-1
X-IronPort-AV: E=Sophos;i="5.81,169,1610406000"; d="scan'208";a="492350923"
Received: from 173.121.68.85.rev.sfr.net (HELO hadrien) ([85.68.121.173])
	by mail2-relais-roc.national.inria.fr with
	ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 21:06:21 +0100
Date: Wed, 10 Feb 2021 21:06:15 +0100 (CET)
From: Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org
Message-ID: <alpine.DEB.2.22.394.2102102103560.2881@hadrien>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
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
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 17 Feb 2021 10:31:26 -0500
Cc: kbuild-all@lists.01.org, Denis Efremov <efremov@linux.com>
Subject: [dm-devel] [PATCH] dm writecache: fix flexible_array.cocci warnings
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Zero-length and one-element arrays are deprecated, see
Documentation/process/deprecated.rst
Flexible-array members should be used instead.

Generated by: scripts/coccinelle/misc/flexible_array.cocci

CC: Denis Efremov <efremov@linux.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
Signed-off-by: Julia Lawall <julia.lawall@inria.fr>
---

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   e0756cfc7d7cd08c98a53b6009c091a3f6a50be6
commit: 7b36c1398fb63f9c38cc83dc75f143d2e5995062 coccinelle: misc: add flexible_array.cocci script
:::::: branch date: 2 days ago
:::::: commit date: 4 months ago

 dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -73,7 +73,7 @@ struct wc_memory_superblock {
 		};
 		__le64 padding[8];
 	};
-	struct wc_memory_entry entries[0];
+	struct wc_memory_entry entries[];
 };

 struct wc_entry {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

