Return-Path: <SRS0=Y5I9=I3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0179C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 20:43:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3085C61996
	for <dm-devel@archiver.kernel.org>; Mon, 29 Mar 2021 20:43:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3085C61996
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-MsgoWFI5PUCoK9rg7GTKHg-1; Mon, 29 Mar 2021 16:43:10 -0400
X-MC-Unique: MsgoWFI5PUCoK9rg7GTKHg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 324C01922960;
	Mon, 29 Mar 2021 20:43:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BE115B4A6;
	Mon, 29 Mar 2021 20:43:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E91074BB7C;
	Mon, 29 Mar 2021 20:43:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12TKdoTd018732 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 29 Mar 2021 16:39:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id C729E4411E; Mon, 29 Mar 2021 20:39:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFF8B47CDC
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 20:39:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1424085A5AA
	for <dm-devel@redhat.com>; Mon, 29 Mar 2021 20:39:48 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-556-4G7rZjfaO4-oFxdk3fzzpw-1;
	Mon, 29 Mar 2021 16:39:43 -0400
X-MC-Unique: 4G7rZjfaO4-oFxdk3fzzpw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 10587B08C;
	Mon, 29 Mar 2021 20:39:42 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Mon, 29 Mar 2021 22:39:35 +0200
Message-Id: <20210329203935.19691-1-mwilck@suse.com>
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12TKdoTd018732
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH] multipathd: give up "add missing path" after
	multiple failures
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

After b7aae60 ("multipathd: improve "add missing path" handling"),
a path that failed to initialize after multiple udev retriggers
would still be checked in check_path(). However, if a path is up,
has been checked more than once, the failback WWID methods have
been tried, and still there is no usable WWID, we may conclude
that something is fishy and we shouldn't keep trying.

Without this patch, totally WWID-less devices (seen e.g. on ESXi)
will cause a "add missing path" message in every checker iteration.

Fixes: b7aae60 ("multipathd: improve "add missing path" handling")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 16 ++++++++++++++++
 multipathd/main.c        |  6 ++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f804414..ec99a7a 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -2370,6 +2370,22 @@ int pathinfo(struct path *pp, struct config *conf, int mask)
 			if (pp->initialized != INIT_FAILED) {
 				pp->initialized = INIT_MISSING_UDEV;
 				pp->tick = conf->retrigger_delay;
+			} else if (pp->retriggers >= conf->retrigger_tries &&
+				   (pp->state == PATH_UP || pp->state == PATH_GHOST)) {
+				/*
+				 * We have failed to read udev info for this path
+				 * repeatedly. We used the fallback in get_uid()
+				 * if there was any, and still got no WWID,
+				 * although the path is allegedly up.
+				 * It's likely that this path is not fit for
+				 * multipath use.
+				 */
+				char buf[16];
+
+				snprint_path(buf, sizeof(buf), "%T", pp, 0);
+				condlog(1, "%s: no WWID in state \"%s\", giving up",
+					pp->dev, buf);
+				return PATHINFO_SKIPPED;
 			}
 			return PATHINFO_OK;
 		}
diff --git a/multipathd/main.c b/multipathd/main.c
index 3579bad..102946b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2218,13 +2218,13 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 				ev_add_path(pp, vecs, 1);
 				pp->tick = 1;
 			} else {
+				if (ret == PATHINFO_SKIPPED)
+					return -1;
 				/*
 				 * We failed multiple times to initialize this
 				 * path properly. Don't re-check too often.
 				 */
 				pp->checkint = max_checkint;
-				if (ret == PATHINFO_SKIPPED)
-					return -1;
 			}
 		}
 		return 0;
@@ -2504,6 +2504,8 @@ checkerloop (void *ap)
 		vector_foreach_slot (vecs->pathvec, pp, i) {
 			rc = check_path(vecs, pp, ticks);
 			if (rc < 0) {
+				condlog(1, "%s: check_path() failed, removing",
+					pp->dev);
 				vector_del_slot(vecs->pathvec, i);
 				free_path(pp);
 				i--;
-- 
2.30.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

