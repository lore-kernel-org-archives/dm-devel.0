Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CFBC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 02:43:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4266261004
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 02:43:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4266261004
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-kztlB9p5OAOG1aVoC5kMEg-1; Sun, 12 Sep 2021 22:43:34 -0400
X-MC-Unique: kztlB9p5OAOG1aVoC5kMEg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C6901808306;
	Mon, 13 Sep 2021 02:43:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D49CF6A901;
	Mon, 13 Sep 2021 02:43:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 437CD180142F;
	Mon, 13 Sep 2021 02:43:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18D2hOri009111 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Sep 2021 22:43:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CE4811002050; Mon, 13 Sep 2021 02:43:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CA4961121325
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 02:43:20 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9849C18A0161
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 02:43:20 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-140-k9PLF9lHMRCMQ1yWpoqerg-1; Sun, 12 Sep 2021 22:43:18 -0400
X-MC-Unique: k9PLF9lHMRCMQ1yWpoqerg-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H79k11XlyzVfmS;
	Mon, 13 Sep 2021 10:42:17 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2308.8; Mon, 13 Sep 2021 10:43:14 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2308.8; Mon, 13 Sep 2021 10:43:14 +0800
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <c0ee4284-c2af-e7d4-29c0-fc800a8d2c94@huawei.com>
Date: Mon, 13 Sep 2021 10:43:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
	dggema759-chm.china.huawei.com (10.1.198.201)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH v2] multipathd: fix missing persistent
 reseravtion for active path
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There are two paths(sucu as sda and adb) for one LUN. The two
paths log in, but before the two uevents have been processed
(for example there are many uevent), users use multipathd add
path /dev/sda to cause mpatha and use mpathpersist -o -I to
register prkey for mpatha. The add map uevent is after add path
uevent, the the uevent(add sdb) will delay and missing persistent
reseravtion check.

Here, we add persistent reseravtion check in update_map() which
is called ev_add_map().

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 multipathd/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3aff241d..1defeaf1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -490,6 +490,8 @@ update_map (struct multipath *mpp, struct vectors *vecs, int new_map)
 {
 	int retries = 3;
 	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
+	struct path *pp;
+	int i;

 retry:
 	condlog(4, "%s: updating new map", mpp->alias);
@@ -502,6 +504,15 @@ retry:
 	verify_paths(mpp);
 	mpp->action = ACT_RELOAD;

+	if (mpp->prflag) {
+		vector_foreach_slot(mpp->paths, pp, i) {
+			if ((pp->state == PATH_UP)  || (pp->state == PATH_GHOST)) {
+				/* persistent reseravtion check*/
+				mpath_pr_event_handle(pp);
+			}
+		}
+	}
+
 	if (setup_map(mpp, &params, vecs)) {
 		condlog(0, "%s: failed to setup new map in update", mpp->alias);
 		retries = -1;
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

