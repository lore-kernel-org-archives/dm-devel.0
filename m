Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10656C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 22 Nov 2021 04:02:32 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-293-Sg3TYPhTPF28K3VO0HqMEg-1; Sun, 21 Nov 2021 23:02:28 -0500
X-MC-Unique: Sg3TYPhTPF28K3VO0HqMEg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE02F8799EC;
	Mon, 22 Nov 2021 04:02:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ADAB71F44F;
	Mon, 22 Nov 2021 04:02:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 208C94EA2F;
	Mon, 22 Nov 2021 04:02:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AM42LBH029354 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 21 Nov 2021 23:02:22 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C1B8B112131B; Mon, 22 Nov 2021 04:02:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BCE7F1121318
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 04:02:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC81B1066559
	for <dm-devel@redhat.com>; Mon, 22 Nov 2021 04:02:18 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-9-LYy1bz1aOOKo0fm9BAwB2Q-1; Sun, 21 Nov 2021 23:02:14 -0500
X-MC-Unique: LYy1bz1aOOKo0fm9BAwB2Q-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HyD6h2J3ZzZd3B;
	Mon, 22 Nov 2021 11:59:24 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Mon, 22 Nov 2021 12:01:53 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Mon, 22 Nov 2021 12:01:52 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <860bf2b5-23b1-3a61-5a63-96fe5c2fe6d8@huawei.com>
Message-ID: <46cc16b7-6901-3ba0-8499-090015aa156d@huawei.com>
Date: Mon, 22 Nov 2021 12:01:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <860bf2b5-23b1-3a61-5a63-96fe5c2fe6d8@huawei.com>
X-Originating-IP: [10.174.179.176]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH v3 1/3] Fix potential null pointer dereference
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

udev_device_* may return NULL, check it.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/discovery.c    | 8 +++++---
 libmultipath/foreign/nvme.c | 4 +++-
 libmultipath/util.c         | 9 ++++++++-
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f25fe9e3..07ebe7d5 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -388,8 +388,10 @@ sysfs_get_tgt_nodename(struct path *pp, char *node)
 		if (value && !strcmp(value, "usb")) {
 			pp->sg_id.proto_id = SCSI_PROTOCOL_USB;
 			tgtname = udev_device_get_sysname(tgtdev);
-			strlcpy(node, tgtname, NODE_NAME_SIZE);
-			return 0;
+			if (tgtname) {
+				strlcpy(node, tgtname, NODE_NAME_SIZE);
+				return 0;
+			}
 		}
 		tgtdev = udev_device_get_parent(tgtdev);
 	}
@@ -803,7 +805,7 @@ sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 	     parent = udev_device_get_parent(parent)) {
 		const char *ed = udev_device_get_sysname(parent);

-		if (!strncmp(ed, ed_str, sizeof(ed_str) - 1)) {
+		if (ed && !strncmp(ed, ed_str, sizeof(ed_str) - 1)) {
 			end_dev_id = ed;
 			break;
 		}
diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index d40c0869..499b881d 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -184,7 +184,9 @@ static int snprint_nvme_map(const struct gen_multipath *gmp,
 							      "firmware_rev"));
 	case 'r':
 		val = udev_device_get_sysattr_value(nvm->udev, "ro");
-		if (val[0] == 1)
+		if (!val)
+			return append_strbuf_str(buff, "undef");
+		else if (val[0] == 1)
 			return append_strbuf_str(buff, "ro");
 		else
 			return append_strbuf_str(buff, "rw");
diff --git a/libmultipath/util.c b/libmultipath/util.c
index ea858409..b3ed5ff9 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -168,6 +168,7 @@ size_t strlcat(char * restrict dst, const char * restrict src, size_t size)
 int devt2devname(char *devname, int devname_len, const char *devt)
 {
 	struct udev_device *u_dev;
+	const char * dev_name;
 	int r;

 	if (!devname || !devname_len || !devt)
@@ -178,7 +179,13 @@ int devt2devname(char *devname, int devname_len, const char *devt)
 		condlog(0, "\"%s\": invalid major/minor numbers, not found in sysfs", devt);
 		return 1;
 	}
-	r = strlcpy(devname, udev_device_get_sysname(u_dev), devname_len);
+
+	dev_name = udev_device_get_sysname(u_dev);
+	if (!dev_name) {
+		udev_device_unref(u_dev);
+		return 1;
+	}
+	r = strlcpy(devname, dev_name, devname_len);
 	udev_device_unref(u_dev);

 	return !(r < devname_len);
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

