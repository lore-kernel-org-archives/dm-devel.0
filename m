Return-Path: <SRS0=rSqa=QD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8F8C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 14:02:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B702263212
	for <dm-devel@archiver.kernel.org>; Tue, 16 Nov 2021 14:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B702263212
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-EmkqX_cUPPmtc4qEokhFyw-1; Tue, 16 Nov 2021 09:02:14 -0500
X-MC-Unique: EmkqX_cUPPmtc4qEokhFyw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 517F01093E43;
	Tue, 16 Nov 2021 14:01:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BE1510016F2;
	Tue, 16 Nov 2021 14:01:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ADF03181A1D0;
	Tue, 16 Nov 2021 14:01:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AGE1Rpa002444 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 16 Nov 2021 09:01:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5992B2166B25; Tue, 16 Nov 2021 14:01:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C4C72166B3F
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 14:01:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C6FD868910
	for <dm-devel@redhat.com>; Tue, 16 Nov 2021 14:01:24 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com
	[45.249.212.189]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-583-UAwNUT5GP4apqPcwMLyJwA-1; Tue, 16 Nov 2021 09:01:20 -0500
X-MC-Unique: UAwNUT5GP4apqPcwMLyJwA-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Htnjx6KVwz8vRS;
	Tue, 16 Nov 2021 21:59:33 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Tue, 16 Nov 2021 22:01:16 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Tue, 16 Nov 2021 22:01:15 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
References: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
Message-ID: <adf675e0-1ed6-f395-e428-548fe145ea64@huawei.com>
Date: Tue, 16 Nov 2021 22:01:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <78637f61-851d-cf9d-d308-9c22396d2071@huawei.com>
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
	kwepemm600010.china.huawei.com (7.193.23.86)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH 5/5] add prflag to path
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The update_map will frequently be called and there will be
unnecessary checks of reseravtion. We add prflag to path
to avoid this.

The pp->state changes from others to up or ghost, the
mpath_pr_event_handle should be called. The
mpath_pr_event_handle in ev_add_path may not be called,
so set pp->prkey PRKEY_NO when path is removed.

Fix: 4db4fa
Signed-off-by: Lixiaokeng <lixiaokeng>
---
 libmpathpersist/mpath_persist.c |  2 +-
 libmultipath/structs.c          |  1 +
 libmultipath/structs.h          | 12 ++++++++++++
 multipathd/cli_handlers.c       | 15 ++++++++++-----
 multipathd/main.c               |  5 +++--
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
index 803a2a28..f88a2e89 100644
--- a/libmpathpersist/mpath_persist.c
+++ b/libmpathpersist/mpath_persist.c
@@ -924,7 +924,7 @@ int update_map_pr(struct multipath *mpp)

 	if (isFound)
 	{
-		mpp->prflag = 1;
+		mpp->prflag = PRFLAG_OK;
 		condlog(2, "%s: prflag flag set.", mpp->alias );
 	}

diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index e8cacb4b..82dbd565 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -122,6 +122,7 @@ uninitialize_path(struct path *pp)
 	pp->dmstate = PSTATE_UNDEF;
 	pp->uid_attribute = NULL;
 	pp->getuid = NULL;
+	pp->prflag = PRFLAG_NO;

 	if (checker_selected(&pp->checker))
 		checker_put(&pp->checker);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index 399540e7..5b77218b 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -249,6 +249,17 @@ enum recheck_wwid_states {
 	RECHECK_WWID_ON = YNU_YES,
 };

+/*
+ * PRFLAG_NO for path, it means reservation should be checked.
+ * PRFLAG_NO for multipath, it means mpp has no prkey.
+ * PRFLAG_OK for path, it means reservation has been checked.
+ * PRFLAG_OK for multipath, it means mpp has prkey.
+ */
+enum prflag_states {
+	PRFLAG_NO = 0,
+	PRFLAG_OK = 1,
+};
+
 struct vpd_vendor_page {
 	int pg;
 	const char *name;
@@ -327,6 +338,7 @@ struct path {
 	/* configlet pointers */
 	vector hwe;
 	struct gen_path generic_path;
+	int prflag;
 };

 typedef int (pgpolicyfn) (struct multipath *, vector);
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 6d3a0ae2..8662fad7 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -1341,7 +1341,7 @@ cli_setprstatus(void * v, char ** reply, int * len, void * data)
 		return 1;

 	if (!mpp->prflag) {
-		mpp->prflag = 1;
+		mpp->prflag = PRFLAG_OK;
 		condlog(2, "%s: prflag set", param);
 	}

@@ -1352,9 +1352,11 @@ cli_setprstatus(void * v, char ** reply, int * len, void * data)
 int
 cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
 {
-	struct multipath * mpp;
-	struct vectors * vecs = (struct vectors *)data;
-	char * param = get_keyparam(v, MAP);
+	int i;
+	struct multipath *mpp;
+	struct path *pp;
+	struct vectors *vecs = (struct vectors *)data;
+	char *param = get_keyparam(v, MAP);

 	param = convert_dev(param, 0);
 	get_path_layout(vecs->pathvec, 0);
@@ -1364,7 +1366,10 @@ cli_unsetprstatus(void * v, char ** reply, int * len, void * data)
 		return 1;

 	if (mpp->prflag) {
-		mpp->prflag = 0;
+		mpp->prflag = PRFLAG_NO;
+		vector_foreach_slot(mpp->paths, pp, i) {
+			pp->prflag = PRFLAG_NO;
+		}
 		condlog(2, "%s: prflag unset", param);
 	}

diff --git a/multipathd/main.c b/multipathd/main.c
index 82ab3ed1..6ef6495b 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -506,7 +506,7 @@ retry:

 	if (mpp->prflag) {
 		vector_foreach_slot(mpp->paths, pp, i) {
-			if ((pp->state == PATH_UP)  || (pp->state == PATH_GHOST)) {
+			if (!pp->prflag && ((pp->state == PATH_UP) || (pp->state == PATH_GHOST))) {
 				/* persistent reseravtion check*/
 				mpath_pr_event_handle(pp);
 			}
@@ -3570,7 +3570,8 @@ void *  mpath_pr_event_handler_fn (void * pathp )
 	{
 		condlog(0,"%s: Reservation registration failed. Error: %d", pp->dev, ret);
 	}
-	mpp->prflag = 1;
+	mpp->prflag = PRFLAG_OK;
+	pp->prflag = PRFLAG_OK;

 	free(param);
 out:
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

