Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF729C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8F886619E5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8F886619E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637184107;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Ltwmh17rKlxiXYiGiEkK7/hNhiD9NYwRxMOSCt1ameQ=;
	b=W74RxbeURFHlk5OmWzZRmmUjKSxQdeH1hFvZse3rJ4fnAvlSo8VGE9kS+2yaJOtz0U5Bx6
	e2hkWfozYMHFp03bx/r5UPxIhE7/5QoXpSjKUcaxqBTvHFSejm90POb9dr/uJTD8tFePne
	lkV6+t4kF7ziZR6j/ZCCSkyyL0mdswg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-N5iKsld2NbCbnmjcs5UkgA-1; Wed, 17 Nov 2021 16:21:42 -0500
X-MC-Unique: N5iKsld2NbCbnmjcs5UkgA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D37C7104ED1A;
	Wed, 17 Nov 2021 21:21:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B69151F46F;
	Wed, 17 Nov 2021 21:21:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 918D7181A1CF;
	Wed, 17 Nov 2021 21:21:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHLLa84025270 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 16:21:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 60D645C22B; Wed, 17 Nov 2021 21:21:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C01A5C1BB;
	Wed, 17 Nov 2021 21:21:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHLLYFw004947; 
	Wed, 17 Nov 2021 15:21:34 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHLLYLV004946;
	Wed, 17 Nov 2021 15:21:34 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 15:21:22 -0600
Message-Id: <1637184084-4882-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 7/9] multipathd: remove INIT_PARTIAL paths
	that aren't in a multipath device
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/structs_vec.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 9b6407bd..df5709a0 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -308,9 +308,12 @@ void orphan_paths(vector pathvec, struct multipath *mpp, const char *reason)
 
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
@@ -469,11 +472,14 @@ static void check_removed_paths(const struct multipath *mpp, vector pathvec)
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

