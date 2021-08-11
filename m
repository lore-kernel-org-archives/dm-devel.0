Return-Path: <SRS0=1CEe=NC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B65CC4338F
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 13:14:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0001660E52
	for <dm-devel@archiver.kernel.org>; Wed, 11 Aug 2021 13:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0001660E52
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-ac3u-ASwO0y8PIj7MY8yXw-1; Wed, 11 Aug 2021 09:14:18 -0400
X-MC-Unique: ac3u-ASwO0y8PIj7MY8yXw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B56B2DF8A6;
	Wed, 11 Aug 2021 13:14:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C61D5DF36;
	Wed, 11 Aug 2021 13:14:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B13FF181A2A6;
	Wed, 11 Aug 2021 13:14:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17BDBu5a023518 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Aug 2021 09:11:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 41F2F2021477; Wed, 11 Aug 2021 13:11:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D1D92028647
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 13:11:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A293D80122D
	for <dm-devel@redhat.com>; Wed, 11 Aug 2021 13:11:52 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-511-xS989FeCO1iiuNgmondngg-1; Wed, 11 Aug 2021 09:11:48 -0400
X-MC-Unique: xS989FeCO1iiuNgmondngg-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gl9FD651NzYmwf;
	Wed, 11 Aug 2021 21:11:28 +0800 (CST)
Received: from dggema759-chm.china.huawei.com (10.1.198.201) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
	15.1.2176.2; Wed, 11 Aug 2021 21:11:44 +0800
Received: from [10.174.176.230] (10.174.176.230) by
	dggema759-chm.china.huawei.com (10.1.198.201) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
	15.1.2176.2; Wed, 11 Aug 2021 21:11:43 +0800
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>, dm-devel mailing list
	<dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <30798fdf-a112-ff8c-73ac-a37a87b99bd0@huawei.com>
Date: Wed, 11 Aug 2021 21:11:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.176.230]
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH] libmultipath: fix compile error with glibc-2.34+
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

There is an error when complie with glibc-2.34:
comparison of integer expressions of different signedness:
'size_t' {aka 'long unsigned int'} and 'long int'
[-Werror=sign-compare]

The reason is that PTHREAD_STACK_MIN may be defined
long int which is  signed in glibc-2.34+. Explicitly assign
it to the size_t variable to  fix it.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 libmultipath/util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 0e37f3ff..5c2fd5c6 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -220,11 +220,12 @@ void
 setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
 {
 	int ret;
+	size_t pthread_stack_min = PTHREAD_STACK_MIN;

 	ret = pthread_attr_init(attr);
 	assert(ret == 0);
-	if (stacksize < PTHREAD_STACK_MIN)
-		stacksize = PTHREAD_STACK_MIN;
+	if (stacksize < pthread_stack_min)
+		stacksize = pthread_stack_min;
 	ret = pthread_attr_setstacksize(attr, stacksize);
 	assert(ret == 0);
 	if (detached) {
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

