Return-Path: <SRS0=hwRu=LS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65072C49EA5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Jun 2021 09:05:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D37CF613BE
	for <dm-devel@archiver.kernel.org>; Thu, 24 Jun 2021 09:05:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D37CF613BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-u_tw2i32MXC5CI3majaAqQ-1; Thu, 24 Jun 2021 05:05:50 -0400
X-MC-Unique: u_tw2i32MXC5CI3majaAqQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3D4480431A;
	Thu, 24 Jun 2021 09:05:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C6185C1BB;
	Thu, 24 Jun 2021 09:05:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 167B94EA2A;
	Thu, 24 Jun 2021 09:05:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15O95Grp024945 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 24 Jun 2021 05:05:16 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 37ECDF97E3; Thu, 24 Jun 2021 09:05:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 32592F97D4
	for <dm-devel@redhat.com>; Thu, 24 Jun 2021 09:05:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 61FFD89B848
	for <dm-devel@redhat.com>; Thu, 24 Jun 2021 09:05:08 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-352-0vsRQnfHM-6S1KfwUr8whg-1; Thu, 24 Jun 2021 05:05:06 -0400
X-MC-Unique: 0vsRQnfHM-6S1KfwUr8whg-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G9YZv6QvKzZm0W;
	Thu, 24 Jun 2021 16:44:07 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2176.2; Thu, 24 Jun 2021 16:47:09 +0800
Received: from [10.174.179.68] (10.174.179.68) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2176.2; Thu, 24 Jun 2021 16:47:08 +0800
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Martin Wilck
	<mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, "dm-devel
	mailing list" <dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <74753cee-a5c9-7655-2779-baad5786b66a@huawei.com>
Date: Thu, 24 Jun 2021 16:47:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.179.68]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH] multipathd: fix no checking persistent
 reservation registration
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If one multipath device has two paths, the first is down (network
failure) and the second is up, then we register a prkey to the
device. The first path will register successfully but the second
won't. Then fix the network. The uev_update_path will race with
check_path. If uev_update_path -> pathinfo is called before
check_path, the state of the first path will be set PATH_UP
without checking persistent reservation registration.

Here we add checking in uev_update_path.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 multipathd/main.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/multipathd/main.c b/multipathd/main.c
index 2251e02c..0948bf81 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1316,6 +1316,7 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 	struct path * pp;
 	struct config *conf;
 	int needs_reinit = 0;
+	int oldstate;

 	switch ((rc = change_foreign(uev->udev))) {
 	case FOREIGN_OK:
@@ -1366,9 +1367,22 @@ uev_update_path (struct uevent *uev, struct vectors * vecs)
 			pp->udev = udev_device_ref(uev->udev);
 			conf = get_multipath_config();
 			pthread_cleanup_push(put_multipath_config, conf);
+			oldstate = pp->state;
+
 			if (pathinfo(pp, conf, DI_SYSFS|DI_NOIO) != PATHINFO_OK)
 				condlog(1, "%s: pathinfo failed after change uevent",
 					uev->kernel);
+
+			if (pp->state != oldstate && (pp->state == PATH_UP || pp->state == PATH_GHOST)) {
+				if (pp->mpp && pp->mpp->prflag) {
+					/*
+					 * Check Persistent Reservation.
+					 */
+					condlog(2, "%s: checking persistent reservation "
+						"registration when update path", pp->dev);
+					mpath_pr_event_handle(pp);
+				}
+			}
 			pthread_cleanup_pop(1);
 		}

-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

