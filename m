Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5A5C636CD
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 13:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675776796;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uYbCTbjKNfE3VDP6Foq6veCmeO4X8x7oeHMdLbUCGyU=;
	b=fY4+t60qMcd2q3ksrmqqBbojGyFBQ5lxmVWaOxCPgPMXM2AjbU9ZDgvGacNsppmvESLYdB
	lYUOyUlgWONuFyfalZRkraT4u6j5vkL1APZ2K1NfZbc9is6ixVQCrRM50SyYVsiEEf8SM6
	eXxs/h3R0IACM+uoQNnuffcT1QTTv5Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-Aeq9KK9FOUiwysrM9dHAJw-1; Tue, 07 Feb 2023 08:33:13 -0500
X-MC-Unique: Aeq9KK9FOUiwysrM9dHAJw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC234801779;
	Tue,  7 Feb 2023 13:33:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B328E492B23;
	Tue,  7 Feb 2023 13:33:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8108C194658C;
	Tue,  7 Feb 2023 13:33:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C3CCD1946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 13:33:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A7CF9C15E7F; Tue,  7 Feb 2023 13:33:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 95E99C15BA0;
 Tue,  7 Feb 2023 13:33:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 317DX7Lt011812; Tue, 7 Feb 2023 08:33:07 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 317DX61k011808; Tue, 7 Feb 2023 08:33:06 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 7 Feb 2023 08:33:06 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, 
 Steve Baker <sbaker@redhat.com>, Peter Rajnoha <prajnoha@redhat.com>
Message-ID: <alpine.LRH.2.21.2302070816420.10733@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH] dm: don't send uevents while the device is
 suspended
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Device mapper sends an uevent when the device is suspended, using the
function set_capacity_and_notify. However, this causes a race condition
with udev.

Udev skips scanning dm devices that are suspended. If we send an uevent
while we are suspended, udev will be racing with device mapper resume
code. If the device mapper resume code wins the race, udev will process
the uevent after the device is resumed and it will properly scan the
device.

However, if udev wins the race, it will receive the uevent, find out that
the dm device is suspended and skip scanning the device. This causes bugs
such as systemd unmounting the device - see
https://bugzilla.redhat.com/show_bug.cgi?id=2158628

This commit fixes this race.

We move the code that sends the uevents from __bind to dm_resume, so that
they are sent just before the dm-device is resumed. We hold
md->suspend_lock while sending the uevent. We change __dev_status so that
it grabs md->suspend_lock while querying the suspend state.

If udev responds too quickly after the uevent is generated, it will go to
__dev_status, call dm_suspended_md_locked and that function will block
until md->suspend_lock is released by the resume code - so, udev won't see
the device in the suspended state.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ioctl.c         |    6 ++---
 drivers/md/dm.c               |   44 +++++++++++++++++++++++++-----------------
 drivers/md/dm.h               |    1 
 include/linux/device-mapper.h |    2 -
 4 files changed, 32 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2023-01-20 13:22:38.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2023-02-06 19:54:32.000000000 +0100
@@ -2159,26 +2159,10 @@ static struct dm_table *__bind(struct ma
 			       struct queue_limits *limits)
 {
 	struct dm_table *old_map;
-	sector_t size;
 	int ret;
 
 	lockdep_assert_held(&md->suspend_lock);
 
-	size = dm_table_get_size(t);
-
-	/*
-	 * Wipe any geometry if the size of the table changed.
-	 */
-	if (size != dm_get_size(md))
-		memset(&md->geometry, 0, sizeof(md->geometry));
-
-	if (!get_capacity(md->disk))
-		set_capacity(md->disk, size);
-	else
-		set_capacity_and_notify(md->disk, size);
-
-	dm_table_event_callback(t, event_callback, md);
-
 	if (dm_table_request_based(t)) {
 		/*
 		 * Leverage the fact that request-based DM targets are
@@ -2824,7 +2808,7 @@ static int __dm_resume(struct mapped_dev
 	return 0;
 }
 
-int dm_resume(struct mapped_device *md)
+int dm_resume(struct mapped_device *md, bool table_swapped)
 {
 	int r;
 	struct dm_table *map = NULL;
@@ -2849,6 +2833,23 @@ retry:
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
+	if (table_swapped) {
+		sector_t size = dm_table_get_size(map);
+
+		/*
+		 * Wipe any geometry if the size of the table changed.
+		 */
+		if (size != dm_get_size(md))
+			memset(&md->geometry, 0, sizeof(md->geometry));
+
+		if (!get_capacity(md->disk))
+			set_capacity(md->disk, size);
+		else
+			set_capacity_and_notify(md->disk, size);
+
+		dm_table_event_callback(map, event_callback, md);
+	}
+
 	r = __dm_resume(md, map);
 	if (r)
 		goto out;
@@ -3054,6 +3055,15 @@ int dm_suspended_md(struct mapped_device
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_suspended_md_locked(struct mapped_device *md)
+{
+	int ret;
+	mutex_lock(&md->suspend_lock);
+	ret = test_bit(DMF_SUSPENDED, &md->flags);
+	mutex_unlock(&md->suspend_lock);
+	return ret;
+}
+
 static int dm_post_suspending_md(struct mapped_device *md)
 {
 	return test_bit(DMF_POST_SUSPENDING, &md->flags);
Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2023-02-06 19:36:42.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2023-02-06 19:56:13.000000000 +0100
@@ -806,7 +806,7 @@ static void __dev_status(struct mapped_d
 	param->flags &= ~(DM_SUSPEND_FLAG | DM_READONLY_FLAG |
 			  DM_ACTIVE_PRESENT_FLAG | DM_INTERNAL_SUSPEND_FLAG);
 
-	if (dm_suspended_md(md))
+	if (dm_suspended_md_locked(md))
 		param->flags |= DM_SUSPEND_FLAG;
 
 	if (dm_suspended_internally_md(md))
@@ -1172,7 +1172,7 @@ static int do_resume(struct dm_ioctl *pa
 	}
 
 	if (dm_suspended_md(md)) {
-		r = dm_resume(md);
+		r = dm_resume(md, new_map != NULL);
 		if (!r) {
 			dm_ima_measure_on_device_resume(md, new_map ? true : false);
 
@@ -2230,7 +2230,7 @@ int __init dm_early_create(struct dm_ioc
 	set_disk_ro(dm_disk(md), !!(dmi->flags & DM_READONLY_FLAG));
 
 	/* resume device */
-	r = dm_resume(md);
+	r = dm_resume(md, true);
 	if (r)
 		goto err_destroy_table;
 
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h	2022-10-03 14:36:40.000000000 +0200
+++ linux-2.6/drivers/md/dm.h	2023-02-06 19:51:12.000000000 +0100
@@ -140,6 +140,7 @@ int dm_deleting_md(struct mapped_device
  * Is this mapped_device suspended?
  */
 int dm_suspended_md(struct mapped_device *md);
+int dm_suspended_md_locked(struct mapped_device *md);
 
 /*
  * Internal suspend and resume methods.
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2023-02-06 19:36:42.000000000 +0100
+++ linux-2.6/include/linux/device-mapper.h	2023-02-06 19:54:59.000000000 +0100
@@ -462,7 +462,7 @@ void *dm_get_mdptr(struct mapped_device
  * A device can still be used while suspended, but I/O is deferred.
  */
 int dm_suspend(struct mapped_device *md, unsigned suspend_flags);
-int dm_resume(struct mapped_device *md);
+int dm_resume(struct mapped_device *md, bool table_swapped);
 
 /*
  * Event functions.
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

