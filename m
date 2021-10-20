Return-Path: <SRS0=0/yZ=PI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AAF5C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 19:19:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BE0CF61212
	for <dm-devel@archiver.kernel.org>; Wed, 20 Oct 2021 19:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BE0CF61212
Authentication-Results: mail.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1634757557;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zZBQZ9oI7fXQLzPJTEF3uchXL77BFRE1O0iJi6Gwbpc=;
	b=SW3BlLMsizZbRjeGDKHZY9MaFNgVfYt31Bw5K84RsHM2lK0YUWk7r+lO9XBubOmBXEXZaf
	Cnbr1ICTrsurLuA5uz1aFE2bwMu4T2daUIEuBfd6K8OQx0PNe6imrtt2HkbJM7HNKDBYeP
	j78qjjB10b3RsXn6SFtBu0YbG7ix640=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-U3x2Edo5Pc6jyMV7JgYWRg-1; Wed, 20 Oct 2021 15:19:14 -0400
X-MC-Unique: U3x2Edo5Pc6jyMV7JgYWRg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0A3D1927800;
	Wed, 20 Oct 2021 19:19:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C42195FC23;
	Wed, 20 Oct 2021 19:19:08 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 998C51818480;
	Wed, 20 Oct 2021 19:19:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19KJFXDC000612 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 20 Oct 2021 15:15:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 06ED560C5F; Wed, 20 Oct 2021 19:15:33 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E644660C0F;
	Wed, 20 Oct 2021 19:15:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 19KJFVga006077; 
	Wed, 20 Oct 2021 14:15:31 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 19KJFUoT006076;
	Wed, 20 Oct 2021 14:15:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 20 Oct 2021 14:15:21 -0500
Message-Id: <1634757322-6015-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 6/7] multipathd: remove INIT_PARTIAL paths that
	aren't in a multipath device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The only reason multipath is monitoring an INIT_PARTIAL path is because
it was discovered in a multipath device table. If it stops being part
of a multipath device before it gets fully initialized, drop it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/structs_vec.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 1de9175e..3f60f3d5 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -307,9 +307,12 @@ void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 
 	vector_foreach_slot (pathvec, pp, i) {
 		if (pp->mpp == mpp) {
-			if (pp->initialized == INIT_REMOVED) {
-				condlog(3, "%s: freeing path in removed state",
-					pp->dev);
+			if (pp->initialized == INIT_REMOVED ||
+			    pp->initialized == INIT_PARTIAL) {
+				condlog(3, "%s: freeing path in %s state",
+					pp->dev,
+					pp->initialized == INIT_REMOVED ?
+					"removed" : "partial");
 				vector_del_slot(pathvec, i--);
 				free_path(pp);
 			} else
@@ -468,11 +471,14 @@ static void check_removed_paths(const struct multipath *mpp, vector pathvec)
 	int i;
 
 	vector_foreach_slot(pathvec, pp, i) {
-		if (pp->initialized != INIT_REMOVED || pp->mpp != mpp)
-			continue;
-		if (!find_devt_in_pathgroups(mpp, pp->dev_t)) {
-			condlog(2, "%s: %s: freeing path in removed state",
-				__func__, pp->dev);
+		if (pp->mpp == mpp &&
+		    (pp->initialized == INIT_REMOVED ||
+		     pp->initialized == INIT_PARTIAL) &&
+		    !find_devt_in_pathgroups(mpp, pp->dev_t)) {
+			condlog(2, "%s: %s: freeing path in %s state",
+				__func__, pp->dev,
+				pp->initialized == INIT_REMOVED ?
+				"removed" : "partial");
 			vector_del_slot(pathvec, i--);
 			free_path(pp);
 		}
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

