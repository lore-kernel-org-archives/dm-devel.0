Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DA4C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Mar 2022 07:45:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-rnpWuSruOpuAcV32zhcs-g-1; Thu, 10 Mar 2022 02:45:52 -0500
X-MC-Unique: rnpWuSruOpuAcV32zhcs-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1940D3C01C19;
	Thu, 10 Mar 2022 07:45:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AAECC40D2826;
	Thu, 10 Mar 2022 07:45:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C691195356D;
	Thu, 10 Mar 2022 07:45:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1DE0F194F4AE
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Mar 2022 20:05:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 037B92166B1A; Wed,  9 Mar 2022 20:05:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F2E4F2166B18
 for <dm-devel@redhat.com>; Wed,  9 Mar 2022 20:05:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 815F6801597
 for <dm-devel@redhat.com>; Wed,  9 Mar 2022 20:05:18 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
 [209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-zfcyZoKIMX2ItDpMMncbVw-1; Wed, 09 Mar 2022 15:05:16 -0500
X-MC-Unique: zfcyZoKIMX2ItDpMMncbVw-1
Received: by mail-pj1-f54.google.com with SMTP id
 z12-20020a17090ad78c00b001bf022b69d6so3297170pju.2
 for <dm-devel@redhat.com>; Wed, 09 Mar 2022 12:05:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Jtr6rIRnxHbzi3VJ3Oyn6ExX2hwkj3VI+ZG5y4DU6Fo=;
 b=ChEnuqv1Pl7r1k/I/ECkXXcEr7TaHn3lnHp6Pn/0xWbClYgh8kPWLDBRfyJtIkSb23
 l3ZeKeuYsfvsNNDef+LMNqcRF7EB0O3GcLvQXyT8sND1TjeJEIMW/245l33la4hWEOSU
 cw348/Sk3+MUdvUPTb+5m3m33Nm0Oif6FmFOivXJj8ZfMLQ0O1CXmEzW90QK32BNI+DR
 tXvSZ1vZ0vbBBmWfVO2ahlBmmNWc/8CcvpVtEdm8sIWFLSFMQgPa8KN99hFnxWG6g6YT
 hD1odBk/H/Dgr2/6sW/0oe2EAWtsVTI73cIaQ/DE4oJOpJamZuRFuHdtx5evPNXAqNlw
 o3QQ==
X-Gm-Message-State: AOAM530FXhYqxssUjKIDkXllVX5eJBgSt1DIxI3oUgFF/T5838qSGmkS
 SMIzKBA3dsOJTpONJA4aDlSNqnNOIC0pTREUtgnZMpKI4U5VY/KCVUwyY2QqUaRvaEj2vpiK7fV
 ekc8r2F3yUhkuwO7G1m3SfJCWOf/OxvH7j8qc0eq1Y0ikbaX53KxUqXz3/xgWll5ADKkQ6B4=
X-Google-Smtp-Source: ABdhPJx5a6LFVgdr3N2K35m3n/XdPGnemJyVN9nxHxJk39umjZCfEbpnVzyJF0AnyGIfbbKJUMH1Tg==
X-Received: by 2002:a17:903:41c9:b0:151:a545:2d5f with SMTP id
 u9-20020a17090341c900b00151a5452d5fmr1211086ple.114.1646856314581; 
 Wed, 09 Mar 2022 12:05:14 -0800 (PST)
Received: from localhost ([208.88.159.128]) by smtp.gmail.com with ESMTPSA id
 z192-20020a6333c9000000b0037c7a6f1798sm3116906pgz.7.2022.03.09.12.05.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 09 Mar 2022 12:05:13 -0800 (PST)
From: Uday Shankar <ushankar@purestorage.com>
To: dm-devel@redhat.com
Date: Wed,  9 Mar 2022 13:03:26 -0700
Message-Id: <20220309200325.2490463-1-ushankar@purestorage.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Thu, 10 Mar 2022 07:45:45 +0000
Subject: [dm-devel] [PATCH] multipath-tools: update mpp->force_readonly in
 ev_add_path
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
Cc: Uday Shankar <ushankar@purestorage.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When NVMe disks are added to the system, no uevent containing the
DISK_RO property is generated. As a result, dm-* nodes backed by
readonly NVMe disks will not have their RO state set properly. The
result looks like this:

$ multipath -l
eui.00c92c091fd6564424a9376600011bd1 dm-3 NVME,Pure Storage FlashArray
size=1.0T features='0' hwhandler='0' wp=rw
|-+- policy='service-time 0' prio=0 status=active
| `- 0:2:2:72657 nvme0n2 259:4 active undef running
`-+- policy='service-time 0' prio=0 status=enabled
  `- 1:0:2:72657 nvme1n2 259:1 active undef running
$ cat /sys/block/dm-3/ro
0
$ cat /sys/block/nvme*n2/ro
1
1

This is not a problem for SCSI disks, since the kernel will emit change
uevents containing the DISK_RO property when the disk is added to the
system. See the following thread for my initial attempt to fix this
issue at the kernel level:
https://lore.kernel.org/linux-block/Yib8GqCA5e3SQYty@infradead.org/T/#t

Fix the issue by picking up the path ro state from sysfs in ev_add_path,
setting the mpp->force_readonly accordingly, and changing
dm_addmap_create to be aware of mpp->force_readonly.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
---
 libmultipath/devmapper.c |  2 +-
 multipathd/main.c        | 50 ++++++++++++++++++++++------------------
 2 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 2507f77f..9819e29b 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -540,7 +540,7 @@ int dm_addmap_create (struct multipath *mpp, char * params)
 	int ro;
 	uint16_t udev_flags = build_udev_flags(mpp, 0);
 
-	for (ro = 0; ro <= 1; ro++) {
+	for (ro = mpp->force_readonly ? 1 : 0; ro <= 1; ro++) {
 		int err;
 
 		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
diff --git a/multipathd/main.c b/multipathd/main.c
index f2c0b280..a67865df 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1130,6 +1130,28 @@ out:
 	return ret;
 }
 
+static int
+sysfs_get_ro (struct path *pp)
+{
+	int ro;
+	char buff[3]; /* Either "0\n\0" or "1\n\0" */
+
+	if (!pp->udev)
+		return -1;
+
+	if (sysfs_attr_get_value(pp->udev, "ro", buff, sizeof(buff)) <= 0) {
+		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
+		return -1;
+	}
+
+	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
+		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
+		return -1;
+	}
+
+	return ro;
+}
+
 /*
  * returns:
  * 0: added
@@ -1143,6 +1165,7 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 	int retries = 3;
 	int start_waiter = 0;
 	int ret;
+	int ro;
 
 	/*
 	 * need path UID to go any further
@@ -1207,6 +1230,11 @@ rescan:
 	/* persistent reservation check*/
 	mpath_pr_event_handle(pp);
 
+	/* ro check - if new path is ro, force map to be ro as well */
+	ro = sysfs_get_ro(pp);
+	if (ro == 1)
+		mpp->force_readonly = 1;
+
 	if (!need_do_map)
 		return 0;
 
@@ -1446,28 +1474,6 @@ finish_path_init(struct path *pp, struct vectors * vecs)
 	return -1;
 }
 
-static int
-sysfs_get_ro (struct path *pp)
-{
-	int ro;
-	char buff[3]; /* Either "0\n\0" or "1\n\0" */
-
-	if (!pp->udev)
-		return -1;
-
-	if (sysfs_attr_get_value(pp->udev, "ro", buff, sizeof(buff)) <= 0) {
-		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
-		return -1;
-	}
-
-	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
-		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
-		return -1;
-	}
-
-	return ro;
-}
-
 static bool
 needs_ro_update(struct multipath *mpp, int ro)
 {
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

