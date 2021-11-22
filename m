Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71500C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 22 Nov 2021 03:59:38 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-xyMcrm5NOdCwUWxOdGpaog-1; Sun, 21 Nov 2021 22:59:33 -0500
X-MC-Unique: xyMcrm5NOdCwUWxOdGpaog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 245AC18125C1;
	Mon, 22 Nov 2021 03:59:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C19015F93B;
	Mon, 22 Nov 2021 03:59:25 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B2C9D1832E7F;
	Mon, 22 Nov 2021 03:59:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AM3xHS1029102 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 21 Nov 2021 22:59:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CDB9D51E2; Mon, 22 Nov 2021 03:59:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C71C951E1
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 03:59:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00E57185A7B2
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 03:59:15 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-290-BY5Hl8MIOreftWyrzO6O9Q-1; Sun, 21 Nov 2021 22:59:11 -0500
X-MC-Unique: BY5Hl8MIOreftWyrzO6O9Q-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HyD0c4dv2zQj7M;
	Mon, 22 Nov 2021 11:54:08 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Mon, 22 Nov 2021 11:59:07 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Mon, 22 Nov 2021 11:59:06 +0800
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <860bf2b5-23b1-3a61-5a63-96fe5c2fe6d8@huawei.com>
Date: Mon, 22 Nov 2021 11:59:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] =?utf-8?q?=5BPATCH_v3_0/3=5D_multipath-tools_series?=
 =?utf-8?q?=EF=BC=9A_some_codeclean?=
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Changes for v2 to v3:

0001: remove condlog.

lixiaokeng (3):
  Fix potential null pointer dereference
  remove unnecessary memset
  remove unnecessary free

 libmultipath/discovery.c                 | 8 +++++---
 libmultipath/foreign/nvme.c              | 4 +++-
 libmultipath/log.c                       | 1 -
 libmultipath/prioritizers/weightedpath.c | 3 +--
 libmultipath/util.c                      | 9 ++++++++-
 multipathd/waiter.c                      | 1 -
 6 files changed, 17 insertions(+), 9 deletions(-)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

