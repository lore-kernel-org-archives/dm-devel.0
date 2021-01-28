Return-Path: <SRS0=XDEt=G7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A89C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 20:52:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1857F64DE9
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jan 2021 20:52:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1857F64DE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-39ICh44NN1Szw4O23Q84Yg-1; Thu, 28 Jan 2021 15:52:12 -0500
X-MC-Unique: 39ICh44NN1Szw4O23Q84Yg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3D4419251AB;
	Thu, 28 Jan 2021 20:52:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9762960C13;
	Thu, 28 Jan 2021 20:52:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 68E261809CA2;
	Thu, 28 Jan 2021 20:52:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10SKlB5U015111 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 28 Jan 2021 15:47:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D4BFCF49D1; Thu, 28 Jan 2021 20:47:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD130F9AD6
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 20:47:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99C2282A692
	for <dm-devel@redhat.com>; Thu, 28 Jan 2021 20:47:09 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-399-2UTip7_APp23wr35-1segw-1;
	Thu, 28 Jan 2021 15:46:00 -0500
X-MC-Unique: 2UTip7_APp23wr35-1segw-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id F08C9AF78;
	Thu, 28 Jan 2021 20:45:58 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 28 Jan 2021 21:45:43 +0100
Message-Id: <20210128204544.18563-3-mwilck@suse.com>
In-Reply-To: <20210128204544.18563-1-mwilck@suse.com>
References: <20210128204544.18563-1-mwilck@suse.com>
MIME-Version: 1.0
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10SKlB5U015111
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 2/3] libmultipath: sysfs_set_nexus_loss_tmo():
	support SAS expanders
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

With SAS expanders, SAS node names have 3 digits. libmultipath
would fail to discover the sas_end_device matching a given SCSI
target in this case. Fix it.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/discovery.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
index f3ce3f8..7878454 100644
--- a/libmultipath/discovery.c
+++ b/libmultipath/discovery.c
@@ -789,14 +789,28 @@ sysfs_set_session_tmo(struct multipath *mpp, struct path *pp)
 static void
 sysfs_set_nexus_loss_tmo(struct multipath *mpp, struct path *pp)
 {
-	struct udev_device *sas_dev = NULL;
-	char end_dev_id[64];
+	struct udev_device *parent, *sas_dev = NULL;
+	const char *end_dev_id = NULL;
 	char value[11];
+	static const char ed_str[] = "end_device-";
 
-	if (mpp->dev_loss == DEV_LOSS_TMO_UNSET)
+	if (!pp->udev || mpp->dev_loss == DEV_LOSS_TMO_UNSET)
 		return;
-	sprintf(end_dev_id, "end_device-%d:%d",
-		pp->sg_id.host_no, pp->sg_id.transport_id);
+
+	for (parent = udev_device_get_parent(pp->udev);
+	     parent;
+	     parent = udev_device_get_parent(parent)) {
+		const char *ed = udev_device_get_sysname(parent);
+
+		if (!strncmp(ed, ed_str, sizeof(ed_str) - 1)) {
+			end_dev_id = ed;
+			break;
+		}
+	}
+	if (!end_dev_id) {
+		condlog(1, "%s: No SAS end device", pp->dev);
+		return;
+	}
 	sas_dev = udev_device_new_from_subsystem_sysname(udev,
 				"sas_end_device", end_dev_id);
 	if (!sas_dev) {
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

