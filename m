Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB098C28CF5
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 05:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643175345;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=j4xHpnVkBdm2PMoSvoRPqYtFdzrw6p5guJiHPP86Ahs=;
	b=WZhiL3Y0Y7OpPD07FgpU3/zovRJmwI4/KMDxI5YteEhJn52mXTWUnYM9IEHTKEYjQRZiAH
	RDCXwRwH4UY7PHiKW6kfZFk6vRfRs+XJ4bFaAizyT+aDcppQCZL+f4kUDkYh8ALgNB3rxC
	o1pK4pbbepnqAGGAJNdLcO3L8zV6AJs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-R114uM72NP21QGKupn0oTw-1; Wed, 26 Jan 2022 00:35:41 -0500
X-MC-Unique: R114uM72NP21QGKupn0oTw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2912C1006AA5;
	Wed, 26 Jan 2022 05:35:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFB80103BAAF;
	Wed, 26 Jan 2022 05:35:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 03D841809CB8;
	Wed, 26 Jan 2022 05:35:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20Q5ZYO5003088 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 00:35:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1B126104253C; Wed, 26 Jan 2022 05:35:34 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 01F40103BAAF;
	Wed, 26 Jan 2022 05:35:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 20Q5ZQ9C031084; 
	Tue, 25 Jan 2022 23:35:26 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 20Q5ZPLB031083;
	Tue, 25 Jan 2022 23:35:25 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 25 Jan 2022 23:35:25 -0600
Message-Id: <1643175325-31046-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH] libmultipath: use asprintf() to allocate
	prefixed_uuid
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

gcc 12.0.1 failed building libmultipath due to a format-overflow false
positive on 32-bit architectures.  This isn't so surprising as
format-overflow=2 is very aggressive in the assumptions it makes about
the arguments.  Here, it assumes that mpp->wwid could take up all the
space that a pointer could point to, even if I add code to this function
to explicitly null terminate mpp->wwid to fit in WWID_SIZE.

To avoid this and simplify the function, switch from using calloc() and
sprintf() to just using asprintf().

For reference, the gcc build error that this fixes is:

devmapper.c: In function 'dm_addmap.constprop.0':
devmapper.h:27:21: error: '%s' directive writing up to 2147483644 bytes into a region of size 2147483641 [-Werror=format-overflow=]
   27 | #define UUID_PREFIX "mpath-"
      |                     ^~~~~~~~
devmapper.c:484:53: note: format string is defined here
  484 |                 sprintf(prefixed_uuid, UUID_PREFIX "%s", mpp->wwid);
      |                                                     ^~

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/devmapper.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 36038150..2507f77f 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -473,14 +473,11 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
 		dm_task_set_ro(dmt);
 
 	if (task == DM_DEVICE_CREATE) {
-		prefixed_uuid = calloc(1, UUID_PREFIX_LEN +
-				       strlen(mpp->wwid) + 1);
-		if (!prefixed_uuid) {
+		if (asprintf(&prefixed_uuid, UUID_PREFIX "%s", mpp->wwid) < 0) {
 			condlog(0, "cannot create prefixed uuid : %s",
 				strerror(errno));
 			goto addout;
 		}
-		sprintf(prefixed_uuid, UUID_PREFIX "%s", mpp->wwid);
 		if (!dm_task_set_uuid(dmt, prefixed_uuid))
 			goto freeout;
 		dm_task_skip_lockfs(dmt);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

