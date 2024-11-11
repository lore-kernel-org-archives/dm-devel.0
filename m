Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31057219ED
	for <dm-devel@lists.linux.dev>; Mon, 11 Nov 2024 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731343766; cv=none; b=mZt2RMBKSfzHvL8auMG4AUAbiM2SDjg2hH29+RyvglGD3f5c/IyRfAdL0I/5JbTNBeKmC1grpsQaefPER854okJpScxeJ5+84IfQAD8VZJ93IpOtakJkkmUXlczoBBiGmpsmWFO0OnEbIzPP8ZmAprB7mxao3xDRYn0Tf8GfRck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731343766; c=relaxed/simple;
	bh=cYz2Fe8zODcJmhs6g5OiYPzRM0HsJj4cXz7z1N6fnHQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=seO/9Lp121tcfVMYm4xNo2MtWFANu3w4sibmgwdvas98oxHtzFhVGSWQkkWiXZWDq17TfVGtt9qapiNGUrcZiVdIThm3C6M5vkHdAdjGQMUmM+4sDq9JC81g0x8qUGu9AWu/fHt7OaAams/zlWA+CkeR5xeLSsVbtWepLs23FX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I+gDA9cr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I+gDA9cr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731343763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CSXVEA0rpomwVEqDS4htCNFm/a7L/Pue3FLDNrsCQFE=;
	b=I+gDA9crNoGM7KxZ1JK1CH6DJZZXQFn9bpIcn5AP2yHOrM8YKa+bFyYlu5Iaf/+idMcAij
	DItvYf4c0sPmps1GfAHWm0dXSl63fqMR+vLXsVqxYHjSt3vlp2X5pYp0uvQtpmUmvTC9PA
	UU+btAaqcC7rUZpREyJRsT/mWesJJOE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-bhRCz-7wNcyzAZgigaaGMw-1; Mon,
 11 Nov 2024 11:49:20 -0500
X-MC-Unique: bhRCz-7wNcyzAZgigaaGMw-1
X-Mimecast-MFC-AGG-ID: bhRCz-7wNcyzAZgigaaGMw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBAFB1955F57;
	Mon, 11 Nov 2024 16:49:18 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FE1C19560A3;
	Mon, 11 Nov 2024 16:49:16 +0000 (UTC)
Date: Mon, 11 Nov 2024 17:49:14 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Jooyung Han <jooyung@google.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    zkabelac@redhat.com, dm-devel@lists.linux.dev
Subject: [PATCH] dm: make it possible to open underlying devices in shareable
 mode
In-Reply-To: <CAO-8PLa3Qxhy1M1C_ZDTpOyXrhQ=UQKeKoDOmy-bbShb4rV03A@mail.gmail.com>
Message-ID: <dcaed20c-2132-d453-9c04-b22417ba4010@redhat.com>
References: <CAO-8PLb0azRAuu2yJ3=K1EwiSXASDJ8nVBttbuOUV77==Xd2ug@mail.gmail.com> <94c895e2-0a71-73b2-2692-af8bf62fb340@redhat.com> <CAO-8PLYMFd3YLvfue_an7mc-O19fixJY4ZKybvjehxcm2tRYvA@mail.gmail.com>
 <CAO-8PLa3Qxhy1M1C_ZDTpOyXrhQ=UQKeKoDOmy-bbShb4rV03A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GU92bI4SToRjDT2nnbN6dcGGGMYY0be52ARliC17UOg_1731343759
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; BOUNDARY="-1463811712-960038954-1731343215=:871346"
Content-ID: <c390a657-9d30-735f-c832-6a305f881207@redhat.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-960038954-1731343215=:871346
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <1cf96310-ab7f-eee8-8c18-fda593a53657@redhat.com>

Hi

On Fri, 8 Nov 2024, Jooyung Han wrote:

> Hi Mikulas,
>
> Would it be reasonable to allow this? Or, to reduce the risk or impact 
> on other users, how about introducing a flag for dm-linear constructor 
> to open a table device without setting the holder. I don't know how to 
> describe this, not-exclusive? The dm-linear constructor would look like 
> "<dev_path> <offset> [no_exclusive]", when "no_exclusive" is set, it 
> will open a table device without setting a holder.
> 
> I'd like to get your opinion about this idea. Especially if there's any 
> risks about not setting the holder when opening a DM table device. 
> 
> Besides, there's one more question about dm-verity. Even though there's 
> a field named "data_start" (comment saying it's "data offset in 512-byte 
> sectors"): https://elixir.bootlin.com/linux/v6.11.4/source/drivers/md/dm-verity.h#L49, 
> it's not set in its constructor and always zero after initialization. I 
> think it's reasonable for the constructor to set it with an argument 
> passed. What do you think?

Yes, we could set it in the constructor.

> Thanks.

I've created this (totally untested) patch that makes it possible to add a 
flag DM_OPEN_SHARED to the flags in the create ioctl - when the flag is 
used, all devices open by the specified device are open in a shared mode. 
Does the patch work for you?

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

This commit adds a new flag DM_OPEN_SHARED. The flag may be used on the
create ioctl. When it is used, the underlying devices that are opened
will be open in a shareable mode, so that the user can mount filesystems
on them or perform other activity.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h          |    1 +
 drivers/md/dm-ioctl.c         |    4 ++--
 drivers/md/dm.c               |    9 +++++++--
 include/linux/device-mapper.h |    2 +-
 include/uapi/linux/dm-ioctl.h |    6 ++++++
 5 files changed, 17 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2024-07-30 14:06:48.000000000 +0200
+++ linux-2.6/drivers/md/dm-core.h	2024-11-11 17:34:13.000000000 +0100
@@ -161,6 +161,7 @@ struct mapped_device {
 #define DMF_SUSPENDED_INTERNALLY 7
 #define DMF_POST_SUSPENDING 8
 #define DMF_EMULATE_ZONE_APPEND 9
+#define DMF_OPEN_SHARED 10
 
 void disable_discard(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2024-09-02 17:35:39.000000000 +0200
+++ linux-2.6/drivers/md/dm-ioctl.c	2024-11-11 17:35:51.000000000 +0100
@@ -888,7 +888,7 @@ static int dev_create(struct file *filp,
 	if (param->flags & DM_PERSISTENT_DEV_FLAG)
 		m = MINOR(huge_decode_dev(param->dev));
 
-	r = dm_create(m, &md);
+	r = dm_create(m, param->flags, &md);
 	if (r)
 		return r;
 
@@ -2283,7 +2283,7 @@ int __init dm_early_create(struct dm_ioc
 		m = MINOR(huge_decode_dev(dmi->dev));
 
 	/* alloc dm device */
-	r = dm_create(m, &md);
+	r = dm_create(m, 0, &md);
 	if (r)
 		return r;
 
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2024-11-07 12:49:13.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2024-11-11 17:35:05.000000000 +0100
@@ -737,7 +737,9 @@ static struct table_device *open_table_d
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&td->count, 1);
 
-	bdev_file = bdev_file_open_by_dev(dev, mode, _dm_claim_ptr, NULL);
+	bdev_file = bdev_file_open_by_dev(dev, mode,
+		test_bit(DMF_OPEN_SHARED, &md->flags) ? NULL :_dm_claim_ptr,
+		NULL);
 	if (IS_ERR(bdev_file)) {
 		r = PTR_ERR(bdev_file);
 		goto out_free_td;
@@ -2489,7 +2491,7 @@ static struct dm_table *__unbind(struct
 /*
  * Constructor for a new device.
  */
-int dm_create(int minor, struct mapped_device **result)
+int dm_create(int minor, uint32_t flags, struct mapped_device **result)
 {
 	struct mapped_device *md;
 
@@ -2497,6 +2499,9 @@ int dm_create(int minor, struct mapped_d
 	if (!md)
 		return -ENXIO;
 
+	if (flags & DM_OPEN_SHARED)
+		set_bit(DMF_OPEN_SHARED, &md->flags);
+
 	dm_ima_reset_data(md);
 
 	*result = md;
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2024-10-16 16:41:33.000000000 +0200
+++ linux-2.6/include/linux/device-mapper.h	2024-11-11 17:31:32.000000000 +0100
@@ -483,7 +483,7 @@ void dm_consume_args(struct dm_arg_set *
  * DM_ANY_MINOR chooses the next available minor number.
  */
 #define DM_ANY_MINOR (-1)
-int dm_create(int minor, struct mapped_device **md);
+int dm_create(int minor, uint32_t flags, struct mapped_device **md);
 
 /*
  * Reference counting for md.
Index: linux-2.6/include/uapi/linux/dm-ioctl.h
===================================================================
--- linux-2.6.orig/include/uapi/linux/dm-ioctl.h	2023-09-05 14:46:02.000000000 +0200
+++ linux-2.6/include/uapi/linux/dm-ioctl.h	2024-11-11 17:33:33.000000000 +0100
@@ -382,4 +382,10 @@ enum {
  */
 #define DM_IMA_MEASUREMENT_FLAG	(1 << 19) /* In */
 
+/*
+ * Open underlying devices in the shareable mode, so that the user can mount
+ * filesystems on them.
+ */
+#define DM_OPEN_SHARED		(1 << 20) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */

---1463811712-960038954-1731343215=:871346--

