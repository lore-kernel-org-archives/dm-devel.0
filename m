Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C170C2D0A3
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 09:28:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3534320874
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 09:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3534320874
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-XxnO2X2kPkKIfnUyZj1WRQ-1; Mon, 26 Oct 2020 05:28:51 -0400
X-MC-Unique: XxnO2X2kPkKIfnUyZj1WRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BDEE1084C85;
	Mon, 26 Oct 2020 09:28:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 804665B4B2;
	Mon, 26 Oct 2020 09:28:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 531BE92F22;
	Mon, 26 Oct 2020 09:28:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09Q9SjC6002065 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 05:28:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 67DC21111A72; Mon, 26 Oct 2020 09:28:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 63FC71111A71
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 09:28:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 345E6858296
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 09:28:43 +0000 (UTC)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com
	[45.249.212.190]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-324-uDMjOVy0MRuXX3bEgLH1-g-1; Mon, 26 Oct 2020 05:28:38 -0400
X-MC-Unique: uDMjOVy0MRuXX3bEgLH1-g-1
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CKTzW6W4Zz15Ldb;
	Mon, 26 Oct 2020 17:28:39 +0800 (CST)
Received: from [10.174.178.210] (10.174.178.210) by
	DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server
	id 14.3.487.0; Mon, 26 Oct 2020 17:28:28 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <2a95503c-da40-391c-ce76-bdde19636b51@huawei.com>
Message-ID: <f7ad009f-3ba6-a50d-2b69-b17552c02dbf@huawei.com>
Date: Mon, 26 Oct 2020 17:28:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2a95503c-da40-391c-ce76-bdde19636b51@huawei.com>
X-Originating-IP: [10.174.178.210]
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
Subject: [dm-devel] [PATCH 6/6] flush and sync before reboot
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Write to /etc/multipath/prkeys, for example
0x0000000000000001 3620f17c1007609293677bb210000058e.
Power-off and restart in 5 seconds. There will
be some 0 byte in /etc/multipath/prkeys.
Here we flush and sync before reboot.

Signed-off-by: Jianbing Jiao <jiangjianbiang@huawei.com>
Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/util.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index 1dad90f2..11d4a398 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -355,6 +355,13 @@ int safe_write(int fd, const void *buf, size_t count)
 		count -= r;
 		buf = (const char *)buf + r;
 	}
+
+	/* sync->disk */
+	if (fsync(fd) < 0) {
+		condlog(0, "failed to fsync fd :%d", fd);
+		return -errno;
+	}
+
 	return 0;
 }

-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

