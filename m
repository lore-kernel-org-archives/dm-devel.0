Return-Path: <SRS0=YJnZ=IS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D10C433C1
	for <dm-devel@archiver.kernel.org>; Sat, 20 Mar 2021 07:41:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2716E61997
	for <dm-devel@archiver.kernel.org>; Sat, 20 Mar 2021 07:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2716E61997
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-2OIVi-7_ODiIN6pvpcprJA-1; Sat, 20 Mar 2021 03:41:50 -0400
X-MC-Unique: 2OIVi-7_ODiIN6pvpcprJA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED6B187A826;
	Sat, 20 Mar 2021 07:41:44 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8472E5D9F2;
	Sat, 20 Mar 2021 07:41:43 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B45EC4BB7C;
	Sat, 20 Mar 2021 07:41:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12K7fc6Q016158 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 20 Mar 2021 03:41:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id AF0E32166BA3; Sat, 20 Mar 2021 07:41:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7B522166B44
	for <dm-devel@redhat.com>; Sat, 20 Mar 2021 07:41:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 92998101A531
	for <dm-devel@redhat.com>; Sat, 20 Mar 2021 07:41:35 +0000 (UTC)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com
	[45.249.212.190]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-474-TPUF1A3pMhuSaSnJo1t5TQ-1; Sat, 20 Mar 2021 03:41:29 -0400
X-MC-Unique: TPUF1A3pMhuSaSnJo1t5TQ-1
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F2XCS2qQyz16H17;
	Sat, 20 Mar 2021 15:17:40 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS408-HUB.china.huawei.com
	(10.3.19.208) with Microsoft SMTP Server id 14.3.498.0;
	Sat, 20 Mar 2021 15:19:26 +0800
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>, "martin.petersen@oracle.com"
	<martin.petersen@oracle.com>
From: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Message-ID: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
Date: Sat, 20 Mar 2021 15:19:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
	Thunderbird/68.2.2
MIME-Version: 1.0
X-Originating-IP: [10.174.176.117]
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
Cc: lixiaokeng <lixiaokeng@huawei.com>, "wubo \(T\)" <wubo40@huawei.com>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linfeilong <linfeilong@huawei.com>, liuzhiqiang26@huawei.com
Subject: [dm-devel] [PATCH] md/dm-mpath: check whether all pgpaths have same
 uuid in multipath_ctr()
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

When we make IO stress test on multipath device, there will
be a metadata err because of wrong path. In the test, we
concurrent execute 'iscsi device login|logout' and
'multipath -r' command with IO stress on multipath device.
In some case, systemd-udevd may have not time to process
uevents of iscsi device logout|login, and then 'multipath -r'
command triggers multipathd daemon calls ioctl to load table
with incorrect old device info from systemd-udevd.
Then, one iscsi path may be incorrectly attached to another
multipath which has different uuid. Finally, the metadata err
occurs when umounting filesystem to down write metadata on
the iscsi device which is actually not owned by the multipath
device.

So we need to check whether all pgpaths of one multipath have
the same uuid, if not, we should throw a error.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: linfeilong <linfeilong@huawei.com>
Signed-off-by: Wubo <wubo40@huawei.com>
---
 drivers/md/dm-mpath.c   | 52 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c |  1 +
 2 files changed, 53 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f082b0..f0b995784b53 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -24,6 +24,7 @@
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <scsi/scsi_dh.h>
+#include <linux/dm-ioctl.h>
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>

@@ -1169,6 +1170,45 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	return r;
 }

+#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
+#define MPATH_UUID_PREFIX_LEN 7
+static int check_pg_uuid(struct priority_group *pg, char *md_uuid)
+{
+	char pgpath_uuid[DM_UUID_LEN] = {0};
+	struct request_queue *q;
+	struct pgpath *pgpath;
+	struct scsi_device *sdev;
+	ssize_t count;
+	int r = 0;
+
+	list_for_each_entry(pgpath, &pg->pgpaths, list) {
+		q = bdev_get_queue(pgpath->path.dev->bdev);
+		sdev = scsi_device_from_queue(q);
+		if (!sdev) {
+			r = -EINVAL;
+			goto out;
+		}
+
+		count = scsi_vpd_lun_id(sdev, pgpath_uuid, DM_UUID_LEN);
+		if (count <= SCSI_VPD_LUN_ID_PREFIX_LEN) {
+			r = -EINVAL;
+			put_device(&sdev->sdev_gendev);
+			goto out;
+		}
+
+		if (strcmp(md_uuid + MPATH_UUID_PREFIX_LEN,
+			   pgpath_uuid + SCSI_VPD_LUN_ID_PREFIX_LEN)) {
+			r = -EINVAL;
+			put_device(&sdev->sdev_gendev);
+			goto out;
+		}
+		put_device(&sdev->sdev_gendev);
+	}
+
+out:
+	return r;
+}
+
 static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
 	/* target arguments */
@@ -1183,6 +1223,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	unsigned pg_count = 0;
 	unsigned next_pg_num;
 	unsigned long flags;
+	char md_uuid[DM_UUID_LEN] = {0};

 	as.argc = argc;
 	as.argv = argv;
@@ -1220,6 +1261,11 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}

+	if (dm_copy_name_and_uuid(dm_table_get_md(ti->table), NULL, md_uuid)) {
+		r = -ENXIO;
+		goto bad;
+	}
+
 	/* parse the priority groups */
 	while (as.argc) {
 		struct priority_group *pg;
@@ -1231,6 +1277,12 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			goto bad;
 		}

+		if (check_pg_uuid(pg, md_uuid)) {
+			ti->error = "uuid of pgpaths mismatch";
+			r = -EINVAL;
+			goto bad;
+		}
+
 		nr_valid_paths += pg->nr_pgpaths;
 		atomic_set(&m->nr_valid_paths, nr_valid_paths);

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d52a11e1b61..fee82262a227 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1953,6 +1953,7 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)

 	return sdev;
 }
+EXPORT_SYMBOL(scsi_device_from_queue);

 /**
  * scsi_block_requests - Utility function used by low-level drivers to prevent
-- 
2.19.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

