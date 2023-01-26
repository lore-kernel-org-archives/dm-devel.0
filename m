Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C6DC54EED
	for <dm-devel@archiver.kernel.org>; Thu, 26 Jan 2023 08:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674720946;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FqEbwpSSpGhQJISWXLON1ahQHgvG+0cS6yxnZfA6nbs=;
	b=IEhtlQK3k2KeEe8JX9HUhao5Mv0jatl1NimTxPU7ev+Y5gp+Rlync0nkDGbolRpOMg/2mZ
	5hZadepukLGnfcXXx1wJZnsQHY/eufq0INjc3+Qg+E19hyYlONTwVPXkJlZtCmf2QIho9l
	GKRyUvHKq0CAyXAhKYVKgAwlNTqEke4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-0q_B7rQCN8-5dL4tSNlRGQ-1; Thu, 26 Jan 2023 03:15:43 -0500
X-MC-Unique: 0q_B7rQCN8-5dL4tSNlRGQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A9C1886C14B;
	Thu, 26 Jan 2023 08:15:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B0EA40C200C;
	Thu, 26 Jan 2023 08:15:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3121619465B5;
	Thu, 26 Jan 2023 08:15:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 13140194658C
 for <dm-devel@listman.corp.redhat.com>; Thu, 26 Jan 2023 03:41:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E840B492C18; Thu, 26 Jan 2023 03:41:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E04EA492C14
 for <dm-devel@redhat.com>; Thu, 26 Jan 2023 03:41:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C570B101A52E
 for <dm-devel@redhat.com>; Thu, 26 Jan 2023 03:41:02 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com
 [66.111.4.27]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-350-Fqnk6yJeOBKiwTmmMR6bWw-1; Wed, 25 Jan 2023 22:40:57 -0500
X-MC-Unique: Fqnk6yJeOBKiwTmmMR6bWw-1
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
 by mailout.nyi.internal (Postfix) with ESMTP id 443E25C05B6;
 Wed, 25 Jan 2023 22:34:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
 by compute5.internal (MEProxy); Wed, 25 Jan 2023 22:34:12 -0500
X-ME-Sender: <xms:tPTRYzwH5BuEHmVC0eMdTGBBHZMvxt9uWC_rqOGS_ycgsaVj53vQiQ>
 <xme:tPTRY7QY3bnvHhI3rshGztUECyV2lnxUGYKP3bTTB1P8CT0b0uLuAcpcxQKuARE_B
 AJKSl9rZB4DZCM>
X-ME-Received: <xmr:tPTRY9WUpZzy3Z8Ck8htOkPkbtAbgBnETUbKfLGw8gZ6vwGJ1SKYiq7n2texQZKLlDNbwtPj-NZx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvfedgheelucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
 ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
 hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepjeffjefggfeugeduvedvjeekgfeh
 gffhhfffjeetkeelueefffetfffhtdduheetnecuvehluhhsthgvrhfuihiivgeptdenuc
 frrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhs
 lhgrsgdrtghomh
X-ME-Proxy: <xmx:tPTRY9god6WZldkNb6zQxaW-zL3SwrJWz_pk8nteivz3n9Mg372ewQ>
 <xmx:tPTRY1A40rWLm24WxN8wSZLeSpKTRKkmbS2avRGDKXaJ1MessXz1jw>
 <xmx:tPTRY2J2wBOPbzFSk35mgosVTMij5PfJyCoi7AEB9vGO0sW2kh1BBQ>
 <xmx:tPTRY0OGKPUER8o2RS25jDcq9Ina-GirRmaBNRGjT7lspzBd9a80CA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Jan 2023 22:34:11 -0500 (EST)
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com
Date: Wed, 25 Jan 2023 22:33:54 -0500
Message-Id: <20230126033358.1880-3-demi@invisiblethingslab.com>
In-Reply-To: <20230126033358.1880-1-demi@invisiblethingslab.com>
References: <20230126033358.1880-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 26 Jan 2023 08:15:37 +0000
Subject: [dm-devel] [RFC PATCH 2/7] Allow userspace to get an FD to a
 newly-created DM device
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
 =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This allows creating a device-mapper device, opening it, and setting it
to be deleted when unused in a single atomic operation.

Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/md/dm-ioctl.c         | 67 +++++++++++++++++++++++++++++------
 include/uapi/linux/dm-ioctl.h | 16 ++++++++-
 2 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 36fc6ae4737a05ab53ab67a8ccee525cb5fda082..05438dedcd17b7cac470fcc5a9721d67daad4bfb 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -853,9 +853,21 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 
 static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_size)
 {
-	int r, m = DM_ANY_MINOR;
+	int r, m = DM_ANY_MINOR, fd;
 	struct mapped_device *md;
 
+	/* Do not allow unknown flags */
+	if (param->flags > (2 * DM_FILE_DESCRIPTOR_FLAG - 1))
+		return -EINVAL;
+
+	/*
+	 * Do not allow creating a device that would just be destroyed
+	 * before the ioctl returns.
+	 */
+	if ((param->flags & DM_DEFERRED_REMOVE) &&
+	    !(param->flags & DM_FILE_DESCRIPTOR_FLAG))
+		return -EINVAL;
+
 	r = check_name(param->name);
 	if (r)
 		return r;
@@ -867,20 +879,55 @@ static int dev_create(struct file *filp, struct dm_ioctl *param, size_t param_si
 	if (r)
 		return r;
 
-	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
-	if (r) {
-		dm_put(md);
-		dm_destroy(md);
-		return r;
-	}
-
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
+	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
+	if (r)
+		goto out_put;
+
+	if (param->flags & DM_FILE_DESCRIPTOR_FLAG) {
+		struct block_device *bdev = dm_disk(md)->part0;
+		struct file *file;
+
+		fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+		if (fd < 0) {
+			r = fd;
+			goto out_put;
+		}
+
+		file = blkdev_get_file(bdev, O_RDWR|O_CLOEXEC, NULL);
+		if (IS_ERR(file)) {
+			r = PTR_ERR(file);
+			goto out_put_fd;
+		}
+
+		/*
+		 * Simulate opening the device.  The other checks in
+		 * dm_blk_open() are not necessary becuase we have a reference
+		 * to the `struct md`.
+		 */
+		atomic_inc(&md->open_count);
+		fd_install(fd, file);
+		param->file_descriptor = fd;
+	}
+
+	/*
+	 * If userspace requests it, automatically delete the device
+	 * when it is no longer used
+	 */
+	if (param->flags & DM_DEFERRED_REMOVE)
+		set_bit(DMF_DEFERRED_REMOVE, &md->flags);
+
 	__dev_status(md, param);
-
 	dm_put(md);
-
 	return 0;
+
+out_put_fd:
+	put_unused_fd(fd);
+out_put:
+	dm_put(md);
+	dm_destroy(md);
+	return r;
 }
 
 /*
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 7edf335778bae1cb206f6dd4d44e9cf7fb9da35c..30a6260ed7e06ff71fad1675dd4e7f9325d752a6 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -136,7 +136,13 @@ struct dm_ioctl {
 	 * For output, the ioctls return the event number, not the cookie.
 	 */
 	__u32 event_nr;      	/* in/out */
-	__u32 padding;
+
+	union {
+		/* Padding for named devices */
+		__u32 padding;
+		/* For anonymous devices, this is a file descriptor. */
+		__u32 file_descriptor;
+	};
 
 	__u64 dev;		/* in/out */
 
@@ -382,4 +388,12 @@ enum {
  */
 #define DM_IMA_MEASUREMENT_FLAG	(1 << 19) /* In */
 
+/*
+ * If set in a DM_DEV_CREATE ioctl(), sets the file_descriptor field
+ * to a valid file descriptor.  This can be combined with DM_DEFERRED_REMOVE
+ * to cause the device to be destroyed when the file descriptor is closed
+ * and is otherwise unused.
+ */
+#define DM_FILE_DESCRIPTOR_FLAG		(1 << 20) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

