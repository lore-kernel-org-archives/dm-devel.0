Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBFCC43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119383;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=jWLeC2Qu3CMft/+JAuelZhncMllg5ui+7LR1M7sXRxw=;
	b=WvEzdLLWb6Fgw+x9OZj0QBAfYGl+Ce3kfZmjVHnQMPoNoMOdNIo6HdmDjqao+RY8rnRSJe
	3hT4OQdoSeYQfm75TC7V4VjVNNJBMtYlggExKdxX+DCwOEnl2LO/aI1c8kunJTo89uzwIh
	O1MES6a/QeD/dsJBwFDPc6u/jmdfU7Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-Mo7qkM_5PjefOJJWXjB6mA-1; Wed, 06 Jul 2022 10:56:20 -0400
X-MC-Unique: Mo7qkM_5PjefOJJWXjB6mA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28A779693BC;
	Wed,  6 Jul 2022 14:56:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 11F44C04482;
	Wed,  6 Jul 2022 14:56:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7CEE119452D8;
	Wed,  6 Jul 2022 14:56:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7FBBA1947041
 for <dm-devel@listman.corp.redhat.com>; Mon,  4 Jul 2022 00:02:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4E07A1415130; Mon,  4 Jul 2022 00:02:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 49829141510F
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 00:02:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F61185A581
 for <dm-devel@redhat.com>; Mon,  4 Jul 2022 00:02:41 +0000 (UTC)
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com
 [209.85.210.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132--ZrvMPlMOGeCLWlAHRgZvQ-1; Sun, 03 Jul 2022 20:02:37 -0400
X-MC-Unique: -ZrvMPlMOGeCLWlAHRgZvQ-1
Received: by mail-pf1-f181.google.com with SMTP id n12so7576178pfq.0
 for <dm-devel@redhat.com>; Sun, 03 Jul 2022 17:02:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=pAgE+V0rSALvg9inKDX9+//WkKD5ATI4AmKS7cWLY8k=;
 b=OAGwXbwyD8XPHBMmj4OUpAOKSeHPF9YxfWpBTQrP7sixRfYAz2aNWSlUq1MumzrrTp
 Y1ocAc5bjddnQWlzYoh3HV4KxrKVoP/E6tldcs8bx61JSWwnCwR3qExbbMqDV6jWmR+L
 MWKlUPmkcVr5GHdQIVRTczPShs/u4dUo0HuqCdVwPuPUYmInZ/RPa91Tj1H0TfzXMsY/
 d/SDtZ6E1JEFwrM+QQKZR/MC6b8dSGG+ZTfmaREWUGOJtvhBGjoOzAiPwNcA2gTJh8yr
 hvfb6mzpH1/cdQovsxe7H4phY3uYit04GdpiZ3dn0xs8DDACjK+QRcrZeXPOVQruF9bk
 9chA==
X-Gm-Message-State: AJIora9h7uZiV93GcGzDAxpSnhUycHoHsNhSyv+bG46poPSTFzAbuRyU
 sQ/dz/lRAK207f0rIVJifVnvVw==
X-Google-Smtp-Source: AGRyM1vj/Wf+i2Kyez01+sGyo2tEE30kwi1fEOFVr33/MMC24hHpmX+psc0s+r9nx5gkX/GOay9gaA==
X-Received: by 2002:a05:6a00:2356:b0:525:4e88:f792 with SMTP id
 j22-20020a056a00235600b005254e88f792mr33544382pfj.34.1656892956289; 
 Sun, 03 Jul 2022 17:02:36 -0700 (PDT)
Received: from dlunevwfh.roam.corp.google.com
 (n122-107-196-14.sbr2.nsw.optusnet.com.au. [122.107.196.14])
 by smtp.gmail.com with ESMTPSA id
 63-20020a621542000000b00525204224afsm20014171pfv.94.2022.07.03.17.02.33
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 03 Jul 2022 17:02:36 -0700 (PDT)
From: Daniil Lunev <dlunev@chromium.org>
To: Alasdair Kergon <agk@redhat.com>
Date: Mon,  4 Jul 2022 10:02:25 +1000
Message-Id: <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
In-Reply-To: <20220704000225.345536-1-dlunev@chromium.org>
References: <20220704000225.345536-1-dlunev@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: [dm-devel] [PATCH 1/1] dm: add message command to disallow device
 open
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
Cc: dm-devel@redhat.com, Daniil Lunev <dlunev@chromium.org>,
 Mike Snitzer <snitzer@kernel.org>, Brian Geffon <bgeffon@google.com>,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A message can be passed to device mapper to prohibit open on a certain
mapped device. This makes possible to disallow userspace access to
raw swapped data if the system uses device mapper to encrypt it at rest.

Signed-off-by: Daniil Lunev <dlunev@chromium.org>
---

 drivers/md/dm-core.h          |  1 +
 drivers/md/dm-ioctl.c         | 10 ++++++++++
 drivers/md/dm.c               | 12 ++++++++++++
 drivers/md/dm.h               | 10 ++++++++++
 include/uapi/linux/dm-ioctl.h |  5 +++++
 5 files changed, 38 insertions(+)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 4277853c75351..37529b605b7c4 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -140,6 +140,7 @@ struct mapped_device {
 #define DMF_SUSPENDED_INTERNALLY 7
 #define DMF_POST_SUSPENDING 8
 #define DMF_EMULATE_ZONE_APPEND 9
+#define DMF_DISALLOW_OPEN 10
 
 void disable_discard(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 87310fceb0d86..e35d560aa2ff3 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -815,6 +815,9 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 	if (dm_test_deferred_remove_flag(md))
 		param->flags |= DM_DEFERRED_REMOVE;
 
+	if (dm_test_disallow_open_flag(md))
+		param->flags |= DM_DISALLOWED_OPEN;
+
 	param->dev = huge_encode_dev(disk_devt(disk));
 
 	/*
@@ -1656,6 +1659,13 @@ static int message_for_md(struct mapped_device *md, unsigned argc, char **argv,
 		}
 		return dm_cancel_deferred_remove(md);
 	}
+	if (!strcasecmp(argv[0], "@disallow_open")) {
+		if (argc != 1) {
+			DMERR("Invalid arguments for @disallow_open");
+			return -EINVAL;
+		}
+		return dm_disallow_open(md);
+	}
 
 	r = dm_stats_message(md, argc, argv, result, maxlen);
 	if (r < 2)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 82957bd460e89..3e53d1bd40f0c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -327,6 +327,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 
 	if (test_bit(DMF_FREEING, &md->flags) ||
+	    test_bit(DMF_DISALLOW_OPEN, &md->flags) ||
 	    dm_deleting_md(md)) {
 		md = NULL;
 		goto out;
@@ -403,6 +404,12 @@ int dm_cancel_deferred_remove(struct mapped_device *md)
 	return r;
 }
 
+int dm_disallow_open(struct mapped_device *md)
+{
+	set_bit(DMF_DISALLOW_OPEN, &md->flags);
+	return 0;
+}
+
 static void do_deferred_remove(struct work_struct *w)
 {
 	dm_deferred_remove();
@@ -2883,6 +2890,11 @@ int dm_test_deferred_remove_flag(struct mapped_device *md)
 	return test_bit(DMF_DEFERRED_REMOVE, &md->flags);
 }
 
+int dm_test_disallow_open_flag(struct mapped_device *md)
+{
+	return test_bit(DMF_DISALLOW_OPEN, &md->flags);
+}
+
 int dm_suspended(struct dm_target *ti)
 {
 	return dm_suspended_md(ti->table->md);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 9013dc1a7b002..da27f9dfe1413 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -163,6 +163,16 @@ int dm_test_deferred_remove_flag(struct mapped_device *md);
  */
 void dm_deferred_remove(void);
 
+/*
+ * Test if the device is openable.
+ */
+int dm_test_disallow_open_flag(struct mapped_device *md);
+
+/*
+ * Prevent new open request on the device.
+ */
+int dm_disallow_open(struct mapped_device *md);
+
 /*
  * The device-mapper can be driven through one of two interfaces;
  * ioctl or filesystem, depending which patch you have applied.
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 2e9550fef90fa..3b4d12d09c005 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -382,4 +382,9 @@ enum {
  */
 #define DM_IMA_MEASUREMENT_FLAG	(1 << 19) /* In */
 
+/*
+ * If set, the device can not be opened.
+ */
+#define DM_DISALLOWED_OPEN	(1 << 20) /* Out */
+
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
2.31.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

