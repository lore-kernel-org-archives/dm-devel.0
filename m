Return-Path: <SRS0=YUkt=HE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB319C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 19:58:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 142EA64E41
	for <dm-devel@archiver.kernel.org>; Tue,  2 Feb 2021 19:58:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 142EA64E41
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-vYzHrDW1OtKrul0k6yvDwg-1; Tue, 02 Feb 2021 14:58:24 -0500
X-MC-Unique: vYzHrDW1OtKrul0k6yvDwg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4385880047D;
	Tue,  2 Feb 2021 19:58:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2775C5C22B;
	Tue,  2 Feb 2021 19:58:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 92DEE4E58E;
	Tue,  2 Feb 2021 19:58:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 112JwChm004174 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Feb 2021 14:58:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 93D302026D15; Tue,  2 Feb 2021 19:58:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E8102026D5D
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 19:58:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1892D858F0E
	for <dm-devel@redhat.com>; Tue,  2 Feb 2021 19:58:10 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-143-4CbbobU7Pde-UZ4i8kmLzQ-1;
	Tue, 02 Feb 2021 14:58:05 -0500
X-MC-Unique: 4CbbobU7Pde-UZ4i8kmLzQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 29879ACD4;
	Tue,  2 Feb 2021 19:58:04 +0000 (UTC)
From: mwilck@suse.com
To: lixiaokeng@huawei.com, Benjamin Marzinski <bmarzins@redhat.com>,
	Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue,  2 Feb 2021 20:57:44 +0100
Message-Id: <20210202195744.2384-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 112JwChm004174
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] libmultipath: check if adopt_path() really added
	current path
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

The description of 2d32d6f ("libmultipath: adopt_paths(): don't bail out on
single path failure") said "we need to check after successful call to
adopt_paths() if that specific path had been actually added, and fail in the
caller otherwise". But the commit failed to actually implement this check.
Instead, it just checked if the path was member of the pathvec, which will
almost always be the case.

Fix it by checking what actually needs to be checked, membership of the
path to be added in mpp->paths.

Fixes: 2d32d6f ("libmultipath: adopt_paths(): don't bail out on single path failure")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---

@lixiaokeng, I believe that this fixes the issue you mentioned in your
post "libmultipath: fix NULL dereference in get_be64".

---
 libmultipath/structs_vec.c | 4 ++--
 multipathd/main.c          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index f7f45f1..47b1d03 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -707,8 +707,8 @@ struct multipath *add_map_with_path(struct vectors *vecs, struct path *pp,
 		goto out;
 	mpp->size = pp->size;
 
-	if (adopt_paths(vecs->pathvec, mpp) ||
-	    find_slot(vecs->pathvec, pp) == -1)
+	if (adopt_paths(vecs->pathvec, mpp) || pp->mpp != mpp ||
+	    find_slot(mpp->paths, pp) == -1)
 		goto out;
 
 	if (add_vec) {
diff --git a/multipathd/main.c b/multipathd/main.c
index 134185f..425492a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1008,8 +1008,8 @@ rescan:
 	if (mpp) {
 		condlog(4,"%s: adopting all paths for path %s",
 			mpp->alias, pp->dev);
-		if (adopt_paths(vecs->pathvec, mpp) ||
-		    find_slot(vecs->pathvec, pp) == -1)
+		if (adopt_paths(vecs->pathvec, mpp) || pp->mpp != mpp ||
+		    find_slot(mpp->paths, pp) == -1)
 			goto fail; /* leave path added to pathvec */
 
 		verify_paths(mpp);
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

