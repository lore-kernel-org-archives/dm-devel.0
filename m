Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C024EB64DC
	for <dm-devel@archiver.kernel.org>; Sat, 24 Jun 2023 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687648219;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=5+WuJJmxHnkgpfh0WJKFe9ks3ryjgcTl17aBEudutcg=;
	b=PI5UFkwlDNG7w3sMe2COwUWrvGieM1FzwukSV98VMfoZX5rN687geJmMzXRkPe5cDCrRAT
	YuYowh3nljNJce9wVeR8LfEEowgSErDGTUgUeqK4A3Tsoy2Ri07oiXD7Jrg/YVJgvIIBv8
	IQgUY+tI0zTUtF7ywGPAQREeSpRtCbE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-CQWMTp-KOVO2eGYLSGus6g-1; Sat, 24 Jun 2023 19:10:15 -0400
X-MC-Unique: CQWMTp-KOVO2eGYLSGus6g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 040BB1C04320;
	Sat, 24 Jun 2023 23:10:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E5C80492B01;
	Sat, 24 Jun 2023 23:10:13 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D91D31946588;
	Sat, 24 Jun 2023 23:10:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFEB81946587
 for <dm-devel@listman.corp.redhat.com>; Sat, 24 Jun 2023 23:10:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C02C34087C6F; Sat, 24 Jun 2023 23:10:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B89FD4087C6D
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 23:10:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96C7D104458A
 for <dm-devel@redhat.com>; Sat, 24 Jun 2023 23:10:12 +0000 (UTC)
Received: from wout1-smtp.messagingengine.com
 (wout1-smtp.messagingengine.com [64.147.123.24]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-V3bfZ7_dPRanpVp1FOwKBA-1; Sat, 24 Jun 2023 19:10:08 -0400
X-MC-Unique: V3bfZ7_dPRanpVp1FOwKBA-1
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
 by mailout.west.internal (Postfix) with ESMTP id 84A5A320030E;
 Sat, 24 Jun 2023 19:10:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute6.internal (MEProxy); Sat, 24 Jun 2023 19:10:06 -0400
X-ME-Sender: <xms:zneXZMgjvPO9N1C3GG9O5RBN7PE_LXoGfhgPihNyuS9_83-v0VkUow>
 <xme:zneXZFAIl4Mr7GTqwNFAXO5QqzA1lGw6piATQtXWuVD2L_pbr1OeF6AgvausJelIU
 g5Np40RYBcEjRo>
X-ME-Received: <xmr:zneXZEHC5rlPsNiLyNNCQhRF5M3ZyrHi6jFcMkJQejHYuIK2KfoNT7ydRthazFGo6d8xT6CMKnM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeegkedgudekucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgepudenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:zneXZNSHljC4vZs-FTCYagGITIoFIchc5m_Gjq4VwAMgPZMUN6-CsQ>
 <xmx:zneXZJwR1DldrekA5ZxilQVcjZjJ1FqcnCxjSz2vLmzYpSPwyrlajw>
 <xmx:zneXZL5D1CtcrvVdqsTxmZd63larBrRLukyKPLEsLVsUcM_je-tQvA>
 <xmx:zneXZE82nVdiYLHrvFM4grcyVcYJsc51JkbEFjbMCTSujJgBr3siwg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 24 Jun 2023 19:10:05 -0400 (EDT)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Sat, 24 Jun 2023 19:09:47 -0400
Message-ID: <20230624230950.2272-5-demi@invisiblethingslab.com>
In-Reply-To: <20230624230950.2272-1-demi@invisiblethingslab.com>
References: <20230624230950.2272-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH v2 4/4] dm ioctl: inform caller about
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
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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
 drivers/md/dm-ioctl.c         | 31 +++++++++++++++++++++++++------
 include/uapi/linux/dm-ioctl.h |  4 ++--
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 7eab9a8c77ff3286346a1c44581d3b6370a731eb..4eb3eda2fe169f64259458dd678833f444d76ce0 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -259,11 +259,14 @@ static void free_cell(struct hash_cell *hc)
 	}
 }
 
+static void __dev_status(struct mapped_device *md, struct dm_ioctl *param);
+
 /*
  * The kdev_t and uuid of a device can never change once it is
  * initially inserted.
  */
-static int dm_hash_insert(const char *name, const char *uuid, struct mapped_device *md)
+static int dm_hash_insert(const char *name, const char *uuid, struct mapped_device *md,
+			  struct dm_ioctl *param)
 {
 	struct hash_cell *cell, *hc;
 
@@ -280,6 +283,8 @@ static int dm_hash_insert(const char *name, const char *uuid, struct mapped_devi
 	down_write(&_hash_lock);
 	hc = __get_name_cell(name);
 	if (hc) {
+		if (param)
+			__dev_status(hc->md, param);
 		dm_put(hc->md);
 		goto bad;
 	}
@@ -290,6 +295,8 @@ static int dm_hash_insert(const char *name, const char *uuid, struct mapped_devi
 		hc = __get_uuid_cell(uuid);
 		if (hc) {
 			__unlink_name(cell);
+			if (param)
+				__dev_status(hc->md, param);
 			dm_put(hc->md);
 			goto bad;
 		}
@@ -901,10 +908,12 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 		m = MINOR(huge_decode_dev(param->dev));
 
 	r = dm_create(m, &md, param->flags & DM_DISABLE_UEVENTS_FLAG);
-	if (r)
+	if (r) {
+		DMERR("Could not create device-mapper device");
 		return r;
+	}
 
-	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
+	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md, param);
 	if (r) {
 		dm_put(md);
 		dm_destroy(md);
@@ -2234,6 +2243,7 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
 	int ioctl_flags;
 	int param_flags;
 	unsigned int cmd;
+	bool do_copy;
 	struct dm_ioctl *param;
 	ioctl_fn fn = NULL;
 	size_t input_param_size;
@@ -2307,9 +2317,18 @@ static int ctl_ioctl(struct file *file, uint command, struct dm_ioctl __user *us
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
+	do_copy = r == 0;
+	if (r == -EBUSY && !sloppy_checks(param) && cmd == DM_DEV_CREATE_CMD) {
+		param->flags |= DM_EXISTS_FLAG;
+		do_copy = true;
+	}
+	if (do_copy && copy_to_user(user, param, param->data_size))
 		r = -EFAULT;
 
 out:
@@ -2488,7 +2507,7 @@ int __init dm_early_create(struct dm_ioctl *dmi,
 		return r;
 
 	/* hash insert */
-	r = dm_hash_insert(dmi->name, *dmi->uuid ? dmi->uuid : NULL, md);
+	r = dm_hash_insert(dmi->name, *dmi->uuid ? dmi->uuid : NULL, md, NULL);
 	if (r)
 		goto err_destroy_dm;
 
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index b338a4f9a299acda9430995d63fbb490e70c8cd8..195d60be4aba4f20b7220b900c87d6d3a86014a2 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -344,8 +344,8 @@ enum {
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
 #define DM_SUSPEND_FLAG		(1 << 1) /* In/Out */
-#define DM_EXISTS_FLAG		(1 << 2) /* Not used by kernel, reserved for
-					  * libdevmapper in userland
+#define DM_EXISTS_FLAG		(1 << 2) /* Set when trying to create a
+					  * device that already exists
 					  */
 #define DM_PERSISTENT_DEV_FLAG	(1 << 3) /* In */
 
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

