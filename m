Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4CF2C41535
	for <dm-devel@archiver.kernel.org>; Tue, 20 Dec 2022 23:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671579697;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gfD2H/DaV0OloEA/0Ux3OwyYWOMVl4c8iTpgvciyYm4=;
	b=fsQNTRcm9gdRaagWNiYpNTUUUVpgD305jSuBSkCOO63MTisZxu3yfB+kGak/kpFIoOdA80
	Z03+/RGIlDrsB/gogm3I8S/m8bxPY3elXKZxiXzfFgdNFkfXTNhYdkj9716r05teCpVr0B
	NABvV9q5ST+SXEbExM364tbYQgqdJg0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-PCqaxNIkO66jBtlmPpXZyg-1; Tue, 20 Dec 2022 18:41:34 -0500
X-MC-Unique: PCqaxNIkO66jBtlmPpXZyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B03A85C6E6;
	Tue, 20 Dec 2022 23:41:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E867C16028;
	Tue, 20 Dec 2022 23:41:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4AE7F1946A6F;
	Tue, 20 Dec 2022 23:41:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E20B919465A0
 for <dm-devel@listman.corp.redhat.com>; Tue, 20 Dec 2022 23:41:20 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 48B292166B26; Tue, 20 Dec 2022 23:41:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 223462166B2B;
 Tue, 20 Dec 2022 23:41:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BKNfIF5023704;
 Tue, 20 Dec 2022 17:41:18 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BKNfIEC023703;
 Tue, 20 Dec 2022 17:41:18 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Tue, 20 Dec 2022 17:41:11 -0600
Message-Id: <1671579675-23658-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
References: <1671579675-23658-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 2/6] libmultipath: make prflag an enum
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

In preparation for a future patch, make prflag an enum, and change the
reply of cli_getprstatus() to a string.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmpathpersist/mpath_persist_int.c |  2 +-
 libmultipath/structs.h              |  8 +++++++-
 multipathd/cli_handlers.c           | 17 +++++++++--------
 multipathd/main.c                   | 14 +++++++-------
 4 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
index 6924b379..a84d9474 100644
--- a/libmpathpersist/mpath_persist_int.c
+++ b/libmpathpersist/mpath_persist_int.c
@@ -783,7 +783,7 @@ int update_map_pr(struct multipath *mpp)
 
 	if (isFound)
 	{
-		mpp->prflag = 1;
+		mpp->prflag = PRFLAG_SET;
 		condlog(2, "%s: prflag flag set.", mpp->alias );
 	}
 
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 9e2c1ab0..f2265300 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -375,6 +375,12 @@ struct path {
 
 typedef int (pgpolicyfn) (struct multipath *, vector);
 
+
+enum prflag_value {
+	PRFLAG_UNSET,
+	PRFLAG_SET,
+};
+
 struct multipath {
 	char wwid[WWID_SIZE];
 	char alias_old[WWID_SIZE];
@@ -449,7 +455,7 @@ struct multipath {
 	int prkey_source;
 	struct be64 reservation_key;
 	uint8_t sa_flags;
-	unsigned char prflag;
+	int prflag;
 	int all_tg_pt;
 	struct gen_multipath generic_mp;
 	bool fpin_must_reload;
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index e65fb75c..7ee2729f 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1277,6 +1277,10 @@ cli_shutdown (void * v, struct strbuf *reply, void * data)
 static int
 cli_getprstatus (void * v, struct strbuf *reply, void * data)
 {
+	static const char * const prflag_str[] = {
+		[PRFLAG_UNSET] = "unset\n",
+		[PRFLAG_SET] = "set\n",
+	};
 	struct multipath * mpp;
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, KEY_MAP);
@@ -1287,10 +1291,7 @@ cli_getprstatus (void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return 1;
 
-	condlog(3, "%s: prflag = %u", param, (unsigned int)mpp->prflag);
-
-	if (print_strbuf(reply, "%d", mpp->prflag) < 0)
-		return 1;
+	append_strbuf_str(reply, prflag_str[mpp->prflag]);
 
 	condlog(3, "%s: reply = %s", param, get_strbuf_str(reply));
 
@@ -1310,8 +1311,8 @@ cli_setprstatus(void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return 1;
 
-	if (!mpp->prflag) {
-		mpp->prflag = 1;
+	if (mpp->prflag != PRFLAG_SET) {
+		mpp->prflag = PRFLAG_SET;
 		condlog(2, "%s: prflag set", param);
 	}
 
@@ -1332,8 +1333,8 @@ cli_unsetprstatus(void * v, struct strbuf *reply, void * data)
 	if (!mpp)
 		return 1;
 
-	if (mpp->prflag) {
-		mpp->prflag = 0;
+	if (mpp->prflag != PRFLAG_UNSET) {
+		mpp->prflag = PRFLAG_UNSET;
 		condlog(2, "%s: prflag unset", param);
 	}
 
diff --git a/multipathd/main.c b/multipathd/main.c
index f7212d7b..722235c7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -647,9 +647,9 @@ fail:
 
 	sync_map_state(mpp);
 
-	if (!mpp->prflag)
+	if (mpp->prflag == PRFLAG_UNSET)
 		update_map_pr(mpp);
-	if (mpp->prflag)
+	if (mpp->prflag == PRFLAG_SET)
 		pr_register_active_paths(mpp);
 
 	if (retries < 0)
@@ -1200,7 +1200,7 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	int start_waiter = 0;
 	int ret;
 	int ro;
-	unsigned char prflag = 0;
+	unsigned char prflag = PRFLAG_UNSET;
 
 	/*
 	 * need path UID to go any further
@@ -1330,7 +1330,7 @@ rescan:
 	if (retries >= 0) {
 		if (start_waiter)
 			update_map_pr(mpp);
-		if (mpp->prflag && !prflag)
+		if (mpp->prflag == PRFLAG_SET && prflag == PRFLAG_UNSET)
 				pr_register_active_paths(mpp);
 		condlog(2, "%s [%s]: path added to devmap %s",
 			pp->dev, pp->dev_t, mpp->alias);
@@ -2492,7 +2492,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
 		}
 
 		if (newstate == PATH_UP || newstate == PATH_GHOST) {
-			if (pp->mpp->prflag) {
+			if (pp->mpp->prflag == PRFLAG_SET) {
 				/*
 				 * Check Persistent Reservation.
 				 */
@@ -2865,7 +2865,7 @@ configure (struct vectors * vecs, enum force_reload_types reload_type)
 		if (remember_wwid(mpp->wwid) == 1)
 			trigger_paths_udev_change(mpp, true);
 		update_map_pr(mpp);
-		if (mpp->prflag)
+		if (mpp->prflag == PRFLAG_SET)
 			pr_register_active_paths(mpp);
 	}
 
@@ -3840,7 +3840,7 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 	{
 		condlog(0,"%s: Reservation registration failed. Error: %d", pp->dev, ret);
 	}
-	mpp->prflag = 1;
+	mpp->prflag = PRFLAG_SET;
 
 	free(param);
 out:
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

