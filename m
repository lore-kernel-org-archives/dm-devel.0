Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B78183070
	for <dm-devel@lists.linux.dev>; Wed, 17 Jul 2024 18:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721239877; cv=none; b=pKebZgVNNDdQptD6QjHltGw+qyQzLl2SAW9EGM/GLvekaoqOdo7SUeJBp+x5b82gH1lYI7w10buSb4FEJBeMtwSZLMmAlpJOxxq7ZUy9UV+OIA7Ot/DSHgqN7ZYODh8SkVPvRwMCyvDAuqYriNHvTN8ozKJTXEH3V4aV0uzYbZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721239877; c=relaxed/simple;
	bh=jqNJ4U+mchHDIhAaQtCSgefWhJ0i1ENkDMQrnjdz1zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e6ZSOIJ37q5bd8QmuVI4/vC5V49x7ZABIzVvA2X+fydv5k8z96fxxO+FNr+cookRLG1a+0XZalf9DXzFIGRgtjL1W5RlUnZ/zoTQnemv+LNMLxHscEDs7ed49k7xEylsov3JGncd8Jwgmn26EyIoZktP2FsUOvuE3lR2wjEYm2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CTqv/JHt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CTqv/JHt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721239874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wva9wNybVY9ylz8cbfE+NTS4AF8mdPbI+wjhMqW0LzA=;
	b=CTqv/JHtTiGmBAVFKLVQ+6aQ9BCn5muD0+N7+f3IqpQn7ix2D1GVL1IAhht1iAzXhCLexq
	pkuVI8w5lCOp8/3F/G+2sY6wlUKNqoBNAXnWCCpe0Utrb/jY38pDdeEri341EBhCw2dtuJ
	iRsDJAb5scPe6fdLsPwYWHbJTR1qlQE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-gcJRfNNJPHSn9dcBinx5oA-1; Wed,
 17 Jul 2024 14:11:12 -0400
X-MC-Unique: gcJRfNNJPHSn9dcBinx5oA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 923C31955F49;
	Wed, 17 Jul 2024 18:11:09 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03E7B19560B2;
	Wed, 17 Jul 2024 18:11:08 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46HIB7VJ2173568
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 17 Jul 2024 14:11:07 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46HIB7182173567;
	Wed, 17 Jul 2024 14:11:07 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 03/20] multipathd: remove checker restart optimization
Date: Wed, 17 Jul 2024 14:10:49 -0400
Message-ID: <20240717181106.2173527-4-bmarzins@redhat.com>
In-Reply-To: <20240717181106.2173527-1-bmarzins@redhat.com>
References: <20240717181106.2173527-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
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
index 13ed6d05..eaef505a 100644
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

