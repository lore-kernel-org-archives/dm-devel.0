Return-Path: <SRS0=coXp=OR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA196C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 05:36:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6532161154
	for <dm-devel@archiver.kernel.org>; Mon, 27 Sep 2021 05:36:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6532161154
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-lT9EsK3GPAW_y2ovvM7riw-1; Mon, 27 Sep 2021 01:36:28 -0400
X-MC-Unique: lT9EsK3GPAW_y2ovvM7riw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28DBA1922966;
	Mon, 27 Sep 2021 05:36:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F19CD1A7E9;
	Mon, 27 Sep 2021 05:36:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9FA59180598A;
	Mon, 27 Sep 2021 05:36:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18R22WrJ020527 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 26 Sep 2021 22:02:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0A03A568E3; Mon, 27 Sep 2021 02:02:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04EC4568DD
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 02:02:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E1588185A79C
	for <dm-devel@redhat.com>; Mon, 27 Sep 2021 02:02:31 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
	[45.249.212.187]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-48-ilZPvgJ0Ooi5fGmgbU4i_A-1; Sun, 26 Sep 2021 22:02:29 -0400
X-MC-Unique: ilZPvgJ0Ooi5fGmgbU4i_A-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HHlf00vzNzbmbx;
	Mon, 27 Sep 2021 09:38:32 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.8; Mon, 27 Sep 2021 09:42:47 +0800
Received: from huawei.com (10.169.63.14) by dggpeml500006.china.huawei.com
	(7.185.36.76) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8;
	Mon, 27 Sep 2021 09:42:46 +0800
From: chengjike <chengjike.cheng@huawei.com>
To: <dm-devel@redhat.com>, <christophe.varoqui@opensvc.com>
Date: Mon, 27 Sep 2021 09:42:46 +0800
Message-ID: <20210927014246.3835-1-chengjike.cheng@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.169.63.14]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
	dggpeml500006.china.huawei.com (7.185.36.76)
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
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18R22WrJ020527
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 27 Sep 2021 01:35:40 -0400
Cc: sunao.sun@huawei.com, jiangtao62@huawei.com, chengjike.cheng@huawei.com
Subject: [dm-devel] [PATCH]multipath-tools: fix "multipath -ll" bug for
	Native NVME Multipath devices
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

After "Native NVME Multipath" is configured,
the content displayed is incorrect when you run "multipath -ll" command.
Each NVME devices have the same path name. For example:

[root@localhost home]# multipath -ll
eui.710032e8fb22a86c24a52c1000000db8 [nvme]:nvme1n1 NVMe,Huawei-XSG1,1000001
size=10485760 features='n/a' hwhandler='ANA' wp=rw
|-+- policy='n/a' prio=50 status=optimized
| `- 1:4:1   nvme1c4n1 0:0 n/a   optimized live
`-+- policy='n/a' prio=50 status=optimized
  `- 1:9:1   nvme1c9n1 0:0 n/a   optimized live
eui.710032e8fb22a86b24a52c7c00000db7 [nvme]:nvme1n2 NVMe,Huawei-XSG1,1000001
size=10485760 features='n/a' hwhandler='ANA' wp=rw
|-+- policy='n/a' prio=50 status=optimized
| `- 1:4:1   nvme1c4n1 0:0 n/a   optimized live
`-+- policy='n/a' prio=50 status=optimized
  `- 1:9:1   nvme1c9n1 0:0 n/a   optimized live
[root@localhost home]#

The logical paths of "nvme1n1" and "nvme1n2" are both "nvme1c4n1" and "nvme1c9n1".
So when filtering logical paths, use "nvme_ns_head->instance" for matching.

Signed-off-by: chengjike <chengjike.cheng@huawei.com>
---
 libmultipath/foreign/nvme.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/libmultipath/foreign/nvme.c b/libmultipath/foreign/nvme.c
index d40c0869..38580880 100644
--- a/libmultipath/foreign/nvme.c
+++ b/libmultipath/foreign/nvme.c
@@ -530,14 +530,18 @@ static int _dirent_controller(const struct dirent *di)
 
 /* Find the block device for a given nvme controller */
 struct udev_device *get_ctrl_blkdev(const struct context *ctx,
-				    struct udev_device *ctrl)
+				    struct udev_device *ctrl, const char *ctrl_name)
 {
+	int ctrl_num, ns_num; 
 	struct udev_list_entry *item;
 	struct udev_device *blkdev = NULL;
 	struct udev_enumerate *enm = udev_enumerate_new(ctx->udev);
 	const char *devtype;
 
-	if (enm == NULL)
+	if (enm == NULL || ctrl_name == NULL)
+		return NULL;
+
+	if (sscanf(ctrl_name, "nvme%dn%d", &ctrl_num, &ns_num) != 2)
 		return NULL;
 
 	pthread_cleanup_push(_udev_enumerate_unref, enm);
@@ -555,6 +559,8 @@ struct udev_device *get_ctrl_blkdev(const struct context *ctx,
 	     item != NULL;
 	     item = udev_list_entry_get_next(item)) {
 		struct udev_device *tmp;
+		const char *name = NULL ;
+		int m, n, l;
 
 		tmp = udev_device_new_from_syspath(ctx->udev,
 					   udev_list_entry_get_name(item));
@@ -562,11 +568,19 @@ struct udev_device *get_ctrl_blkdev(const struct context *ctx,
 			continue;
 
 		devtype = udev_device_get_devtype(tmp);
-		if (devtype && !strcmp(devtype, "disk")) {
+		if (devtype == NULL || strcmp(devtype, "disk")) {
+			udev_device_unref(tmp);
+			continue;
+		}
+
+		name = udev_device_get_sysname(tmp);
+		if (name != NULL && 
+			sscanf(name, "nvme%dc%dn%d", &m, &n, &l) == 3 &&
+			l == ns_num) {
 			blkdev = tmp;
 			break;
-		} else
-			udev_device_unref(tmp);
+		}
+		udev_device_unref(tmp);
 	}
 
 	if (blkdev == NULL)
@@ -679,7 +693,7 @@ static void _find_controllers(struct context *ctx, struct nvme_map *map)
 		}
 
 		pthread_cleanup_push(_udev_device_unref, ctrl);
-		udev = get_ctrl_blkdev(ctx, ctrl);
+		udev = get_ctrl_blkdev(ctx, ctrl, udev_device_get_sysname(map->udev));
 		/*
 		 * We give up the reference to the nvme device here and get
 		 * it back from the child below.
-- 
2.21.0.windows.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

