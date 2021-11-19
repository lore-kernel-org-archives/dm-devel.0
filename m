Return-Path: <SRS0=IN2R=QG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E383C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 08:56:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B981661AFB
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 08:56:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B981661AFB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-61-kJK1MGGSNQq8C3gjqUCiJw-1; Fri, 19 Nov 2021 03:56:30 -0500
X-MC-Unique: kJK1MGGSNQq8C3gjqUCiJw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6D1C87D543;
	Fri, 19 Nov 2021 08:56:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FAE160BF1;
	Fri, 19 Nov 2021 08:56:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D37C94E58F;
	Fri, 19 Nov 2021 08:56:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJ8uH6u017267 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 03:56:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 764F31121315; Fri, 19 Nov 2021 08:56:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 717171121314
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 08:56:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8575218A6580
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 08:56:14 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-428-NKe9zvVuOuW8i_icDfwZbA-1; Fri, 19 Nov 2021 03:56:10 -0500
X-MC-Unique: NKe9zvVuOuW8i_icDfwZbA-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HwVnb44cDzZd93;
	Fri, 19 Nov 2021 16:53:39 +0800 (CST)
Received: from kwepemm600010.china.huawei.com (7.193.23.86) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.20; Fri, 19 Nov 2021 16:56:05 +0800
Received: from [10.174.179.176] (10.174.179.176) by
	kwepemm600010.china.huawei.com (7.193.23.86) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.15; Fri, 19 Nov 2021 16:56:04 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <4b37e359-4e75-55bb-c55e-c73dde4c9fd2@huawei.com>
Message-ID: <062b605f-e4c1-8832-d18f-05d403b070b1@huawei.com>
Date: Fri, 19 Nov 2021 16:56:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
	Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <4b37e359-4e75-55bb-c55e-c73dde4c9fd2@huawei.com>
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
Subject: [dm-devel] [PATCH v2 1/3] Fix potential null pointer dereference
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
 libmultipath/discovery.c    |  8 +++++---
 libmultipath/foreign/nvme.c |  4 +++-
 libmultipath/util.c         | 10 +++++++++-
 3 files changed, 17 insertions(+), 5 deletions(-)

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
index ea858409..3d036e19 100644
--- a/libmultipath/util.c
+++ b/libmultipath/util.c
@@ -168,6 +168,7 @@ size_t strlcat(char * restrict dst, const char * restrict src, size_t size)
 int devt2devname(char *devname, int devname_len, const char *devt)
 {
 	struct udev_device *u_dev;
+	const char * dev_name;
 	int r;

 	if (!devname || !devname_len || !devt)
@@ -178,7 +179,14 @@ int devt2devname(char *devname, int devname_len, const char *devt)
 		condlog(0, "\"%s\": invalid major/minor numbers, not found in sysfs", devt);
 		return 1;
 	}
-	r = strlcpy(devname, udev_device_get_sysname(u_dev), devname_len);
+
+	dev_name = udev_device_get_sysname(u_dev);
+	if (!dev_name) {
+		condlog(2, "\"%s\": fail to get sysname\n", devt);
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

