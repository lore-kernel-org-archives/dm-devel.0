Return-Path: <SRS0=x48V=EB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA36DC4363A
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 09:41:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0E5CD223EA
	for <dm-devel@archiver.kernel.org>; Mon, 26 Oct 2020 09:41:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E5CD223EA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-RY9GKjUpOKm4Ka8llWlztQ-1; Mon, 26 Oct 2020 05:41:36 -0400
X-MC-Unique: RY9GKjUpOKm4Ka8llWlztQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0802D10060C1;
	Mon, 26 Oct 2020 09:41:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D5D195B4B3;
	Mon, 26 Oct 2020 09:41:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AB6B992F2B;
	Mon, 26 Oct 2020 09:41:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09Q9QGrt001803 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 05:26:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id DAD552166B28; Mon, 26 Oct 2020 09:26:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D4D482166B27
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 09:26:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C499858296
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 09:26:14 +0000 (UTC)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-510-ECtqsot3MFysy1T1_FO1hA-1; Mon, 26 Oct 2020 05:26:09 -0400
X-MC-Unique: ECtqsot3MFysy1T1_FO1hA-1
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CKTwg3w4kzhYtC;
	Mon, 26 Oct 2020 17:26:11 +0800 (CST)
Received: from [10.174.178.210] (10.174.178.210) by
	DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server
	id 14.3.487.0; Mon, 26 Oct 2020 17:26:00 +0800
From: lixiaokeng <lixiaokeng@huawei.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>, Benjamin Marzinski
	<bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>,
	dm-devel mailing list <dm-devel@redhat.com>
References: <2a95503c-da40-391c-ce76-bdde19636b51@huawei.com>
Message-ID: <47950e3d-33f8-c1eb-2ee1-a87edd693dee@huawei.com>
Date: Mon, 26 Oct 2020 17:25:59 +0800
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linfeilong <linfeilong@huawei.com>,
	"liuzhiqiang \(I\)" <liuzhiqiang26@huawei.com>
Subject: [dm-devel] [PATCH 3/6] check pgp to avoid NULL dereference in
	enable_group
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

If the pgp is NULL, this code will lead to coredump.
Here we check the pgp before dereference. And there
are some code enhance.

Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
---
 libmultipath/prioritizers/alua.c |  4 ++++
 libmultipath/prioritizers/emc.c  |  2 +-
 libmultipath/prioritizers/hds.c  | 19 +++++++++++--------
 libmultipath/structs_vec.c       |  4 +++-
 multipathd/main.c                |  5 +++++
 5 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/libmultipath/prioritizers/alua.c b/libmultipath/prioritizers/alua.c
index 0ab06e2b..a6307d69 100644
--- a/libmultipath/prioritizers/alua.c
+++ b/libmultipath/prioritizers/alua.c
@@ -131,15 +131,19 @@ int getprio (struct path * pp, char * args, unsigned int timeout)
 		switch(-rc) {
 		case ALUA_PRIO_NOT_SUPPORTED:
 			condlog(0, "%s: alua not supported", pp->dev);
+			rc = 0;
 			break;
 		case ALUA_PRIO_RTPG_FAILED:
 			condlog(0, "%s: couldn't get target port group", pp->dev);
+			rc = 0;
 			break;
 		case ALUA_PRIO_GETAAS_FAILED:
 			condlog(0, "%s: couldn't get asymmetric access state", pp->dev);
+			rc = 0;
 			break;
 		case ALUA_PRIO_TPGS_FAILED:
 			condlog(3, "%s: couldn't get supported alua states", pp->dev);
+			rc = 0;
 			break;
 		}
 	}
diff --git a/libmultipath/prioritizers/emc.c b/libmultipath/prioritizers/emc.c
index 3b63cca0..c40f88a0 100644
--- a/libmultipath/prioritizers/emc.c
+++ b/libmultipath/prioritizers/emc.c
@@ -19,7 +19,7 @@ int emc_clariion_prio(const char *dev, int fd, unsigned int timeout)
 	unsigned char inqCmdBlk[INQUIRY_CMDLEN] = {INQUIRY_CMD, 1, 0xC0, 0,
 						sizeof(sense_buffer), 0};
 	struct sg_io_hdr io_hdr;
-	int ret = PRIO_UNDEF;
+	int ret = 0;

 	memset(&io_hdr, 0, sizeof (struct sg_io_hdr));
 	memset(&sense_buffer, 0, 128);
diff --git a/libmultipath/prioritizers/hds.c b/libmultipath/prioritizers/hds.c
index 88cac5f0..634ae73a 100644
--- a/libmultipath/prioritizers/hds.c
+++ b/libmultipath/prioritizers/hds.c
@@ -98,10 +98,11 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 	unsigned char *inqBuffp = inqBuff;
 	unsigned char sense_buffer[32];
 	sg_io_hdr_t io_hdr;
+        int ret = 0;

 	if ((ioctl (fd, SG_GET_VERSION_NUM, &k) < 0) || (k < 30000)) {
 		pp_hds_log(0, "can't use SG ioctl interface");
-		return -1;
+		goto out;
 	}

 	memset (&io_hdr, 0, sizeof (sg_io_hdr_t));
@@ -118,11 +119,11 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)

 	if (ioctl (fd, SG_IO, &io_hdr) < 0) {
 		pp_hds_log(0, "SG_IO error");
-		return -1;
+		goto out;
 	}
 	if ((io_hdr.info & SG_INFO_OK_MASK) != SG_INFO_OK) {
 		pp_hds_log(0, "SCSI error");
-		return -1;
+		goto out;
 	}

 	snprintf (vendor, 9, "%.8s", inqBuffp + 8);
@@ -144,11 +145,11 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 		switch (ldev[3]) {
 		case '0': case '2': case '4': case '6': case '8': case 'A': case 'C': case 'E':
 			pp_hds_log(4, "CTRL EVEN, LDEV EVEN, PRIO 1");
-			return 1;
+			ret = 1;
 			break;
 		case '1': case '3': case '5': case '7': case '9': case 'B': case 'D': case 'F':
 			pp_hds_log(4, "CTRL EVEN, LDEV ODD, PRIO 0");
-			return 0;
+			ret = 0;
 			break;
 		}
 		break;
@@ -156,16 +157,18 @@ int hds_modular_prio (const char *dev, int fd, unsigned int timeout)
 		switch (ldev[3]) {
 		case '0': case '2': case '4': case '6': case '8': case 'A': case 'C': case 'E':
 			pp_hds_log(4, "CTRL ODD, LDEV EVEN, PRIO 0");
-			return 0;
+			ret = 0;
 			break;
 		case '1': case '3': case '5': case '7': case '9': case 'B': case 'D': case 'F':
 			pp_hds_log(4, "CTRL ODD, LDEV ODD, PRIO 1");
-			return 1;
+			ret = 1;
 			break;
 		}
 		break;
 	}
-	return -1;
+
+out:
+	return ret;
 }

 int getprio (struct path * pp, __attribute__((unused)) char *args,
diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
index 5a73d4ce..51696e36 100644
--- a/libmultipath/structs_vec.c
+++ b/libmultipath/structs_vec.c
@@ -35,8 +35,10 @@ int update_mpp_paths(struct multipath *mpp, vector pathvec)
 		return 0;

 	if (!mpp->paths &&
-	    !(mpp->paths = vector_alloc()))
+	    !(mpp->paths = vector_alloc())) {
+		condlog(2, "mpp->paths alloc failed");
 		return 1;
+	}

 	vector_foreach_slot (mpp->pg, pgp, i) {
 		vector_foreach_slot (pgp->paths, pp, j) {
diff --git a/multipathd/main.c b/multipathd/main.c
index a4abbb27..13cb4dec 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1725,6 +1725,11 @@ enable_group(struct path * pp)

 	pgp = VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);

+	if (!pgp) {
+		condlog(2, "%s: pgp is NULL", pp->mpp->alias);
+		return;
+	}
+
 	if (pgp->status == PGSTATE_DISABLED) {
 		condlog(2, "%s: enable group #%i", pp->mpp->alias, pp->pgindex);
 		dm_enablegroup(pp->mpp->alias, pp->pgindex);
-- 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

