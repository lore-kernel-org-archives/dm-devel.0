Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0037945945
	for <dm-devel@lists.linux.dev>; Sat, 13 Jul 2024 06:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720850721; cv=none; b=hRjj5b7E0QZnXnTR+lrfcJMK0ar5g053j1XIktLNOFihfHl4FxmjMCXee2y/46keMmYNEAoyplFsnWo4rRtnKQDbg8sRkKf8dcQsb0uWiYw45Tsmiaok0Nff3U4ejFnKNUpSlMdzDHJarmCS2+4ef0ergv99CfAt/a3unub9Flo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720850721; c=relaxed/simple;
	bh=7epjJtBUShVaffUzRsDkazIF9K+mFPwcq2Wr4b1uVXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fgzlOCyQDRYwgX3+busxozN+IqHSy1ozsnOOmAvPcAeE4f3lVnAfTEy0skNwNGcXHGbyFOqG1imZQJL5KRWuABlSoZ64zt9YNpWUXZjS1KHwrs7kJhf8UVut3oyzR+/y0GICWH6g/i1ZFtffgJiba9wz+0rDdsRpkQOhT/ysoos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KlDrHebD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KlDrHebD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720850718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0fKWvczRjCAgmWvZLc2pqQL4H2plMr0QhKZd8PUPjc=;
	b=KlDrHebD1UecTSwbV1ljzsZU6HpZEJe+ty1tLGvT1zLkMNVkrcbPPE0uLm2j9bg9Kbi+xG
	nak7yDENWBH+7/IIU0sURSXL7x/U2JRzs2z1qsmF/vHpJV8ylZLzShatrqnbszwHMMVXeE
	X5OdqudRRAoJ8L8EXb5yIehgiOryi7w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-683-sLa-s2UWNCufTHu4fADtPw-1; Sat,
 13 Jul 2024 02:05:10 -0400
X-MC-Unique: sLa-s2UWNCufTHu4fADtPw-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAAE8196CDEF;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32C8C1956066;
	Sat, 13 Jul 2024 06:05:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46D6574q2015506
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 13 Jul 2024 02:05:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46D657Vd2015505;
	Sat, 13 Jul 2024 02:05:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH 03/22] multipathd: remove checker restart optimization
Date: Sat, 13 Jul 2024 02:04:47 -0400
Message-ID: <20240713060506.2015463-4-bmarzins@redhat.com>
In-Reply-To: <20240713060506.2015463-1-bmarzins@redhat.com>
References: <20240713060506.2015463-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Future commits will make this optimization unusable.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 386cd076..0b0ebc8a 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2704,7 +2704,7 @@ checkerloop (void *ap)
 
 	while (1) {
 		struct timespec diff_time, start_time, end_time;
-		int num_paths = 0, strict_timing, rc = 0, i = 0;
+		int num_paths = 0, strict_timing, rc = 0;
 		unsigned int ticks = 0;
 		enum checker_state checker_state = CHECKER_STARTING;
 
@@ -2723,7 +2723,7 @@ checkerloop (void *ap)
 			sd_notify(0, "WATCHDOG=1");
 #endif
 		while (checker_state != CHECKER_FINISHED) {
-			unsigned int paths_checked = 0;
+			unsigned int paths_checked = 0, i;
 			struct timespec chk_start_time;
 
 			pthread_cleanup_push(cleanup_lock, &vecs->lock);
@@ -2733,28 +2733,11 @@ checkerloop (void *ap)
 			if (checker_state == CHECKER_STARTING) {
 				vector_foreach_slot(vecs->pathvec, pp, i)
 					pp->is_checked = false;
-				i = 0;
 				checker_state = CHECKER_RUNNING;
-			} else {
-				/*
-				 * Paths could have been removed since we
-				 * dropped the lock. Find the path to continue
-				 * checking at. Since paths can be removed from
-				 * anywhere in the vector, but can only be added
-				 * at the end, the last checked path must be
-				 * between its old location, and the start or
-				 * the vector.
-				 */
-				if (i >= VECTOR_SIZE(vecs->pathvec))
-					i = VECTOR_SIZE(vecs->pathvec) - 1;
-				while ((pp = VECTOR_SLOT(vecs->pathvec, i))) {
-					if (pp->is_checked == true)
-						break;
-					i--;
-				}
-				i++;
 			}
-			vector_foreach_slot_after (vecs->pathvec, pp, i) {
+			vector_foreach_slot(vecs->pathvec, pp, i) {
+				if (pp->is_checked)
+					continue;
 				pp->is_checked = true;
 				rc = check_path(vecs, pp, ticks);
 				if (rc < 0) {
-- 
2.45.0

