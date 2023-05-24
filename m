Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DFFEC7EE23
	for <dm-devel@archiver.kernel.org>; Wed, 24 May 2023 23:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684970484;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RY1Pf4IGpmABzgXt0XtEh9SbxINRG7Jgs4RDmOJ7k7U=;
	b=g1wFjr9qaTnr3szTcSqqhLsmxPqE4QFRZFYf1BW3f4ALBp9eHZPmoB6vJc44vA/q1oGm+r
	mShcQ8uhAWFxsxAAV2SXka3Ek/Kaer+jYVAAaCBB5lpiRjzvkAwIA0rk+mrTorQ6VxZ8ox
	FsHEozQvE6rISAAzJkPRFIoB3S4Ivx8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-LKN-DxaVPAyefPuAhdL8xA-1; Wed, 24 May 2023 19:21:21 -0400
X-MC-Unique: LKN-DxaVPAyefPuAhdL8xA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4715C1C05AFC;
	Wed, 24 May 2023 23:21:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 33F0EC090D9;
	Wed, 24 May 2023 23:21:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0754D19465A8;
	Wed, 24 May 2023 23:21:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0422A19465BC
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 May 2023 23:21:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D74F72166B26; Wed, 24 May 2023 23:21:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BACB52166B25;
 Wed, 24 May 2023 23:21:16 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 34ONLEOL028713;
 Wed, 24 May 2023 18:21:14 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 34ONLE06028712;
 Wed, 24 May 2023 18:21:14 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 May 2023 18:21:08 -0500
Message-Id: <1684970472-28669-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 1/5] libmultipath: don't count PRIO_UNDEF paths
 for pathgroup priority
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When multipath is not set to group_by_prio, different paths in a
pathgroup can have different priorities. If there is a problem getting
the priority of an active path, its priority will be set to PRIO_UNDEF.
This will change the priority of the whole pathgroup, even though it's
likely that this is simply a temporary error. Instead, do not count
PRIO_UNDEF paths towards to priority of the path group, unless there are
no paths that have an actual priority. This will not effect the priority
of multipath devices with group_by_prio, since all paths in a pathgroup
will have the same priority.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/switchgroup.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/libmultipath/switchgroup.c b/libmultipath/switchgroup.c
index 6fdfcfa7..b1e1f39b 100644
--- a/libmultipath/switchgroup.c
+++ b/libmultipath/switchgroup.c
@@ -12,6 +12,7 @@ void path_group_prio_update(struct pathgroup *pgp)
 	int i;
 	int priority = 0;
 	int marginal = 0;
+	int defined_prios = 0;
 	struct path * pp;
 
 	pgp->enabled_paths = 0;
@@ -24,12 +25,17 @@ void path_group_prio_update(struct pathgroup *pgp)
 			marginal++;
 		if (pp->state == PATH_UP ||
 		    pp->state == PATH_GHOST) {
-			priority += pp->priority;
+			if (pp->priority != PRIO_UNDEF) {
+				defined_prios++;
+				priority += pp->priority;
+			}
 			pgp->enabled_paths++;
 		}
 	}
-	if (pgp->enabled_paths)
-		pgp->priority = priority / pgp->enabled_paths;
+	if (defined_prios)
+		pgp->priority = priority / defined_prios;
+	else if (pgp->enabled_paths)
+		pgp->priority = PRIO_UNDEF;
 	else
 		pgp->priority = 0;
 	if (marginal && marginal == i)
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

