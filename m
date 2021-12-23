Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B372C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 23 Dec 2021 01:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1640223205;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nrvym706WgFHafod+lkkMS5Xh17F72WGTi0yp8ejR98=;
	b=edYAYfXxwyD577Qq2WjvmhbYvNlTBFuzDf/C9qR5ozBDPD6aNshA/WtyFyZtWNXjaSGiwo
	AeW1aAwr+HNBKpJa4IzctmGjfsq7EpdeIptO2BlYuisPoTaJkkuF+KYWnXPUZ87uYCBJtF
	oA8W08jLA0zc8WMFcYSMpVAf26B/kuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-327-C6u2YeYrP_2EiClGrmZWdw-1; Wed, 22 Dec 2021 20:33:21 -0500
X-MC-Unique: C6u2YeYrP_2EiClGrmZWdw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F17E100E326;
	Thu, 23 Dec 2021 01:33:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 373977FB99;
	Thu, 23 Dec 2021 01:33:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 12B774CA93;
	Thu, 23 Dec 2021 01:33:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BN1WiPW009272 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 22 Dec 2021 20:32:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4998E10911B4; Thu, 23 Dec 2021 01:32:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32489104253B;
	Thu, 23 Dec 2021 01:32:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1BN1WggJ001731; 
	Wed, 22 Dec 2021 19:32:42 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1BN1Wfq9001730;
	Wed, 22 Dec 2021 19:32:41 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 22 Dec 2021 19:32:35 -0600
Message-Id: <1640223155-1678-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1640223155-1678-1-git-send-email-bmarzins@redhat.com>
References: <1640223155-1678-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 3/3] libmultipath: don't enter recovery mode with
	pending paths
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

set_no_path_retry() could make a multipath device enter recovery mode
simply because its paths were still in the PATH_PENDING state.  This is
possible when a multipath device is first created. After commit 2e61b8fb
[libmultipath (coverity): Revert "setup_map: wait for pending path
checkers to finish"] it has become much more likely.

To avoid this, don't enter recovery mode as long as there are some paths
in PATH_PENDING.  Since path's can only be in this state if they've
never had their state checker finish, this change will only effect
recently created devices, whose checker hasn't completed yet.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f1031f61..6c23df86 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -616,7 +616,7 @@ void set_no_path_retry(struct multipath *mpp)
 			    !mpp->in_recovery)
 				dm_queue_if_no_path(mpp->alias, 1);
 			leave_recovery_mode(mpp);
-		} else
+		} else if (pathcount(mpp, PATH_PENDING) == 0)
 			enter_recovery_mode(mpp);
 		break;
 	}
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

