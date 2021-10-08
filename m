Return-Path: <SRS0=qbPE=O7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E344EC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Oct 2021 05:52:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3144560238
	for <dm-devel@archiver.kernel.org>; Mon, 11 Oct 2021 05:52:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3144560238
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-MkrJkUA2PfylaunctzywBA-1; Mon, 11 Oct 2021 01:52:28 -0400
X-MC-Unique: MkrJkUA2PfylaunctzywBA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75C5810B3940;
	Mon, 11 Oct 2021 05:52:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E82BA26E43;
	Mon, 11 Oct 2021 05:52:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7B9274E58F;
	Mon, 11 Oct 2021 05:52:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 198COv2u019480 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Oct 2021 08:24:57 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 756412166B2F; Fri,  8 Oct 2021 12:24:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6EBC02166B26
	for <dm-devel@redhat.com>; Fri,  8 Oct 2021 12:24:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5656081161D
	for <dm-devel@redhat.com>; Fri,  8 Oct 2021 12:24:57 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
	[45.249.212.255]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-570-NVYOOCzxOpGKzEh8tayD5g-1; Fri, 08 Oct 2021 08:24:54 -0400
X-MC-Unique: NVYOOCzxOpGKzEh8tayD5g-1
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HQnQv66d2z1DHXc;
	Fri,  8 Oct 2021 20:23:19 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
	dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2308.8; Fri, 8 Oct 2021 20:24:50 +0800
Received: from huawei.com (10.169.63.14) by dggpeml500006.china.huawei.com
	(7.185.36.76) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8;
	Fri, 8 Oct 2021 20:24:50 +0800
From: chengjike <chengjike.cheng@huawei.com>
To: <dm-devel@redhat.com>, <christophe.varoqui@opensvc.com>, <mwilck@suse.com>,
	<xose.vazquez@gmail.com>
Date: Fri, 8 Oct 2021 20:24:49 +0800
Message-ID: <20211008122449.1328-1-chengjike.cheng@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.169.63.14]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 198COv2u019480
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 11 Oct 2021 01:52:12 -0400
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
So when multipath-tools aggregates disks, use "nvme_ns_head->instance" for matching.
such as ,Use "b" in "nvmeanb" string to match "z" in "nvmexcynz"(a,b,x,y,z can be any number),
and if "b" and "z" are the same, they are related.

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

