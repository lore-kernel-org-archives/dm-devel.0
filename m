Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848BCC7EE23
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 20:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685480083;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=L5T/Xpt858LWzbYCxlpWSTAOgKf1/JdFwvR59Fkk2C0=;
	b=MnFTIC+bo0/Fg47rJ2RN9Bd5dP3LXe2qXBCFvhb0bVCqFsl6KfDwqdAvTkB4vH7Et/yUdN
	MXrPPfJVVRci5gtOe1TGXj2TnWf+Gv4a30lVaTBHHVBsJj0XE49n6LreWfAJbvd8SdQAUM
	D0bFDFm+SrjL0G0C/inCI/gZRIm4apA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-16vTtG9CPma8tcW9luq7Ug-1; Tue, 30 May 2023 16:54:39 -0400
X-MC-Unique: 16vTtG9CPma8tcW9luq7Ug-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F239E85828A;
	Tue, 30 May 2023 20:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E02EB492B0B;
	Tue, 30 May 2023 20:54:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1515F19452C7;
	Tue, 30 May 2023 20:54:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CC0691946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D97F2166B27; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 94B1B2166B26
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7834938107F6
 for <dm-devel@redhat.com>; Tue, 30 May 2023 20:40:55 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-fIteULKKMmSIl_aKLRfOSw-1; Tue, 30 May 2023 16:40:53 -0400
X-MC-Unique: fIteULKKMmSIl_aKLRfOSw-1
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
 by mailout.west.internal (Postfix) with ESMTP id 723F63200943;
 Tue, 30 May 2023 16:32:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute3.internal (MEProxy); Tue, 30 May 2023 16:32:10 -0400
X-ME-Sender: <xms:SF12ZBfctJ2d2A3-iQ6vuwFvKc-UzF9BWiLn3tPIBEP1uqJV2EZD2Q>
 <xme:SF12ZPN76MIg5Z3ePhg_4ZPlgtRhapc1-gsYCO9FC46owA3180B5iHdYrNAPo62vN
 oWvwplncvHil8w>
X-ME-Received: <xmr:SF12ZKhwvdGkK2LUyW4IwEmdeVTIPWynVGVi5FIQTnBHOzVXFjkt47FA_H9DtJrKuR6TbZ-by4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeekjedgudeglecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeejffejgffgueegudevvdejkefg
 hefghffhffejteekleeufeffteffhfdtudehteenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:SF12ZK9To1BBIlpSkbrdLxqawBipD57OWmcgw7ISpIx8hEI3IQzMnw>
 <xmx:SF12ZNufUTatZ7nDNjzUx7u7Yl5dj5WRNOF-DD4z9BYxoBkagB6b1w>
 <xmx:SF12ZJFuKj8OnPlsEzvYl9HNQDX1s7aNCelS_9YCw0_fh0PGW-LdEQ>
 <xmx:SV12ZO_ohIr6Yj_olom9PICipQajdyzC4FPnRS3TPpiafB-36ZwAww>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 May 2023 16:32:08 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Jens Axboe <axboe@kernel.dk>,
 =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Tue, 30 May 2023 16:31:12 -0400
Message-Id: <20230530203116.2008-13-demi@invisiblethingslab.com>
In-Reply-To: <20230530203116.2008-1-demi@invisiblethingslab.com>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 30 May 2023 20:54:23 +0000
Subject: [dm-devel] [PATCH v2 12/16] device-mapper: inform caller about
 already-existing device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>,
 linux-block@vger.kernel.org, xen-devel@lists.xenproject.org,
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: invisiblethingslab.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Not only is this helpful for debugging, it also saves the caller an
ioctl in the case where a device should be used if it exists or created
otherwise.  To ensure existing userspace is not broken, this feature is
only enabled in strict mode.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-ioctl.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 17ece816d490b6c40d019da131ade44c9a201dab..44425093d3b908abf80e05e1fc99a26b17e18a42 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -256,11 +256,13 @@ static void free_cell(struct hash_cell *hc)
 	}
 }
 
+static void __dev_status(struct mapped_device *md, struct dm_ioctl *param);
+
 /*
  * The kdev_t and uuid of a device can never change once it is
  * initially inserted.
  */
-static int dm_hash_insert(const char *name, const char *uuid, struct mapped_device *md)
+static int dm_hash_insert(const char *name, const char *uuid, struct mapped_device *md, struct dm_ioctl *param)
 {
 	struct hash_cell *cell, *hc;
 
@@ -277,6 +279,8 @@ static int dm_hash_insert(const char *name, const char *uuid, struct mapped_devi
 	down_write(&_hash_lock);
 	hc = __get_name_cell(name);
 	if (hc) {
+		if (param)
+			__dev_status(hc->md, param);
 		dm_put(hc->md);
 		goto bad;
 	}
@@ -287,6 +291,8 @@ static int dm_hash_insert(const char *name, const char *uuid, struct mapped_devi
 		hc = __get_uuid_cell(uuid);
 		if (hc) {
 			__unlink_name(cell);
+			if (param)
+				__dev_status(hc->md, param);
 			dm_put(hc->md);
 			goto bad;
 		}
@@ -901,12 +907,14 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 		m = MINOR(huge_decode_dev(param->dev));
 
 	r = dm_create(m, &md, param->flags & DM_DISABLE_UEVENTS_FLAG);
-	if (r)
+	if (r) {
+		DMERR("Could not create device-mapper device");
 		return r;
+	}
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
-	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
+	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md, param);
 	if (r) {
 		dm_put(md);
 		dm_destroy(md);
@@ -2269,7 +2277,6 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 		goto out;
 	/* This XOR keeps only the flags validate_params has changed. */
 	old_flags ^= param->flags;
-
 	param->data_size = sloppy_checks(param) ? offsetof(struct dm_ioctl, data) : sizeof(struct dm_ioctl);
 	r = fn(file, param, input_param_size);
 
@@ -2284,9 +2291,14 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 	param->flags |= old_flags;
 
 	/*
-	 * Copy the results back to userland.
+	 * Copy the results back to userland if either:
+	 *
+	 * - The ioctl succeeded.
+	 * - The ioctl is DM_DEV_CREATE, the return value is -EBUSY,
+	 *   and strict parameter checking is enabled.
 	 */
-	if (!r && copy_to_user(user, param, param->data_size))
+	if ((!r || (!sloppy_checks(param) && cmd == DM_DEV_CREATE_CMD && r == -EBUSY)) &&
+	    copy_to_user(user, param, param->data_size))
 		r = -EFAULT;
 
 out:
@@ -2465,7 +2477,7 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 		return r;
 
 	/* hash insert */
-	r = dm_hash_insert(dmi->name, *dmi->uuid ? dmi->uuid : NULL, md);
+	r = dm_hash_insert(dmi->name, *dmi->uuid ? dmi->uuid : NULL, md, NULL);
 	if (r)
 		goto err_destroy_dm;
 
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

