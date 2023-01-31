Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD82C38142
	for <dm-devel@archiver.kernel.org>; Tue, 31 Jan 2023 19:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675194201;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pREKA1csCiSognxL7G2+/j7n/RIcxs703hXLwsYAozY=;
	b=VZlfJddvlbkE5XnNhkj31NoOrlxSqh6btU9WvxfUXMtdXQvg8wsgCZlbm1wsc69HmdTewX
	3dJkMYYNXYMi5vtgpuIboA8+1uuTitgT58f9JiWKpnQkqPAyL/UCs7EF/INvnZ99d1bkez
	hh76clcXnXJxTDeB33uqi2k4/OLyl6g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-500-O2acpM8_NXicg6eDnAeZ_A-1; Tue, 31 Jan 2023 14:43:17 -0500
X-MC-Unique: O2acpM8_NXicg6eDnAeZ_A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D75D1991C42;
	Tue, 31 Jan 2023 19:43:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EC24540C2064;
	Tue, 31 Jan 2023 19:43:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B11AA1946589;
	Tue, 31 Jan 2023 19:43:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 32AEB1946587
 for <dm-devel@listman.corp.redhat.com>; Tue, 31 Jan 2023 19:34:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 17A214010D2A; Tue, 31 Jan 2023 19:34:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0175B401531A;
 Tue, 31 Jan 2023 19:34:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 30VJYQX5001197;
 Tue, 31 Jan 2023 13:34:26 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 30VJYQAT001196;
 Tue, 31 Jan 2023 13:34:26 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 31 Jan 2023 13:34:20 -0600
Message-Id: <1675193661-1147-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
References: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 3/4] libmultipath: cleanup ACT_CREATE code in
 select_action
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Combine the two separate blocks that set ACT_CREATE into one.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/configure.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 6811e661..e870e0f6 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -686,33 +686,29 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
 	if (mpp->need_reload || (cmpp && cmpp->need_reload))
 		force_reload = 1;
 
-	if (!cmpp_by_name) {
-		if (cmpp) {
-			condlog(2, "%s: rename %s to %s", mpp->wwid,
-				cmpp->alias, mpp->alias);
-			strlcpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
-			mpp->action = ACT_RENAME;
-			if (force_reload) {
-				mpp->force_udev_reload = 1;
-				mpp->action = ACT_FORCERENAME;
-			}
-			return;
+	if (!cmpp) {
+		if (cmpp_by_name) {
+			condlog(1, "%s: can't use alias \"%s\" used by %s, falling back to WWID",
+				mpp->wwid, mpp->alias, cmpp_by_name->wwid);
+			/* We can do this because wwid wasn't found */
+			free(mpp->alias);
+			mpp->alias = strdup(mpp->wwid);
 		}
 		mpp->action = ACT_CREATE;
-		condlog(3, "%s: set ACT_CREATE (map does not exist)",
-			mpp->alias);
+		condlog(3, "%s: set ACT_CREATE (map does not exist%s)",
+			mpp->alias, cmpp_by_name ? ", name changed" : "");
 		return;
 	}
 
-	if (!cmpp) {
-		condlog(1, "%s: can't use alias \"%s\" used by %s, falling back to WWID",
-			mpp->wwid, mpp->alias, cmpp_by_name->wwid);
-		/* We can do this because wwid wasn't found */
-		free(mpp->alias);
-		mpp->alias = strdup(mpp->wwid);
-		mpp->action = ACT_CREATE;
-		condlog(3, "%s: set ACT_CREATE (map does not exist, name changed)",
+	if (!cmpp_by_name) {
+		condlog(2, "%s: rename %s to %s", mpp->wwid, cmpp->alias,
 			mpp->alias);
+		strlcpy(mpp->alias_old, cmpp->alias, WWID_SIZE);
+		mpp->action = ACT_RENAME;
+		if (force_reload) {
+			mpp->force_udev_reload = 1;
+			mpp->action = ACT_FORCERENAME;
+		}
 		return;
 	}
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

