Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF917C433E0
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:19:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4134F64EAA
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4134F64EAA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612847984;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qwEfUozu3QPszTtx9nN45u0X/PGmH53wABJBJTiy3oc=;
	b=c3Kt0CIoB9SkFTmRzr2axoci6n4nBI1q6GX5ORUAEg+MpL//phsD1wa94XqR03e8gp8cnK
	Wo/FkZfx9R7oOIRVmi5WyxiMp297q5SGwVdDz8w6hymTChQhFIKapvZP3yUmXccKNT7bhd
	YBICzbvSmC04B+YgxibIAY4FKFF/840=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-BPA3QmMIOP6CTut7ubHtTA-1; Tue, 09 Feb 2021 00:19:41 -0500
X-MC-Unique: BPA3QmMIOP6CTut7ubHtTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C70586D4E3;
	Tue,  9 Feb 2021 05:19:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA1B86F97E;
	Tue,  9 Feb 2021 05:19:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5802918095CB;
	Tue,  9 Feb 2021 05:19:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1195JZsM029782 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 00:19:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 84BE019C71; Tue,  9 Feb 2021 05:19:35 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C4FF19C78;
	Tue,  9 Feb 2021 05:19:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1195JTgB008855; 
	Mon, 8 Feb 2021 23:19:29 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1195JT3t008854;
	Mon, 8 Feb 2021 23:19:29 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  8 Feb 2021 23:19:26 -0600
Message-Id: <1612847967-8813-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Chongyun Wu <wucy11@chinatelecom.cn>, Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 1/2] libmultipath: fix use-after-free in
	uev_add_path
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

if ev_remove_path() returns success the path has very likely been
deleted. However, if pathinfo() returned something besides PATHINFO_OK,
but ev_remove_path() succeeded, uev_add_path() was still accessing the
the path afterwards, which would likely cause a use-after-free error.
Insted, uev_add_path() should only continue to access the path if
ev_remove_path() didn't succeed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 425492a9..19679848 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -890,13 +890,7 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 				 */
 				pp->mpp = prev_mpp;
 				ret = ev_remove_path(pp, vecs, true);
-				if (r == PATHINFO_OK && !ret)
-					/*
-					 * Path successfully freed, move on to
-					 * "new path" code path below
-					 */
-					pp = NULL;
-				else {
+				if (ret != 0) {
 					/*
 					 * Failure in ev_remove_path will keep
 					 * path in pathvec in INIT_REMOVED state
@@ -907,7 +901,12 @@ uev_add_path (struct uevent *uev, struct vectors * vecs, int need_do_map)
 					dm_fail_path(pp->mpp->alias, pp->dev_t);
 					condlog(1, "%s: failed to re-add path still mapped in %s",
 						pp->dev, pp->mpp->alias);
-				}
+				} else if (r == PATHINFO_OK)
+					/*
+					 * Path successfully freed, move on to
+					 * "new path" code path below
+					 */
+					pp = NULL;
 			} else if (r == PATHINFO_SKIPPED) {
 				condlog(3, "%s: remove blacklisted path",
 					uev->kernel);
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

