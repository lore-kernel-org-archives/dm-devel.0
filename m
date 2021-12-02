Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BB7C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  2 Dec 2021 14:30:39 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-HQdPgN2vMoSI4IhYi0WC-Q-1; Thu, 02 Dec 2021 09:30:37 -0500
X-MC-Unique: HQdPgN2vMoSI4IhYi0WC-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90B0C1006AA0;
	Thu,  2 Dec 2021 14:30:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88E6B5FC22;
	Thu,  2 Dec 2021 14:30:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 881611806D2B;
	Thu,  2 Dec 2021 14:30:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B2EULMZ028722 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 2 Dec 2021 09:30:21 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 673B540CFD0C; Thu,  2 Dec 2021 14:30:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 61B8D40CFD11
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 14:30:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 469C8858EFE
	for <dm-devel@redhat.com>; Thu,  2 Dec 2021 14:30:21 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-353-Vx6IVqZOPoWN-W8IJ3VoAQ-1; Thu, 02 Dec 2021 09:30:16 -0500
X-MC-Unique: Vx6IVqZOPoWN-W8IJ3VoAQ-1
Received: from kwepemi100007.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J4ddG3rDYz91Zv;
	Thu,  2 Dec 2021 22:29:38 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	kwepemi100007.china.huawei.com (7.221.188.115) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Thu, 2 Dec 2021 22:30:12 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Thu, 2 Dec 2021 22:30:11 +0800
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
From: lixiaokeng <lixiaokeng@huawei.com>
Message-ID: <c2834c6e-3030-8df4-efd9-fbc50f9b558c@huawei.com>
Date: Thu, 2 Dec 2021 22:30:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH] libmultipath: sync before reboot
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

If reboot within 5s of registering prkey, there will some zero
be added to /etc/multipath/prkeys. The reason is that cache is
not flushed to the disk.

Here fsync(fd) to fix it.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: Jianbing Jiao <jiangjianbiang@huawei.com>
---
 libmultipath/util.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/libmultipath/util.c b/libmultipath/util.c
index ea858409..f7e9c783 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -368,6 +368,11 @@ int safe_write(int fd, const void *buf, size_t count)
 		count -= r;
 		buf = (const char *)buf + r;
 	}
+
+	if (fsync(fd) < 0) {
+		condlog(0, "failed to fsync fd :%d", fd);
+		return -errno;
+	}
 	return 0;
 }

-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

