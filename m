Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D772C636D6
	for <dm-devel@archiver.kernel.org>; Thu,  9 Feb 2023 15:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675955498;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oH/FwraknXEA6zLIz6O6sH9TkblfMe8yQntMe6lca9c=;
	b=dZJojO+SDUGvmhZQwnGTJSWtrT+f8lu2UPH1DrVYH35+O5FGhc4svt1m4BahBsHmMvXyCx
	XjcevkLI1dSWvelWRILmqhB4KGcDLI63Yfvg4bLoulP7IEHpwjw9scrqF3BWbPfZH5ld2Z
	40aRCfs/XtsUB2RYRAXJcjIYmaaotGI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-Gz4g_blRPy-Za8uO0vplZQ-1; Thu, 09 Feb 2023 10:11:36 -0500
X-MC-Unique: Gz4g_blRPy-Za8uO0vplZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EA281C08973;
	Thu,  9 Feb 2023 15:11:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B831040C10FA;
	Thu,  9 Feb 2023 15:11:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 399EA194658D;
	Thu,  9 Feb 2023 15:11:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E9BB91946589
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Feb 2023 15:11:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B54B71415139; Thu,  9 Feb 2023 15:11:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A3945140EBF6;
 Thu,  9 Feb 2023 15:11:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 319FBOrd009983; Thu, 9 Feb 2023 10:11:24 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 319FBO2R009978; Thu, 9 Feb 2023 10:11:24 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 9 Feb 2023 10:11:24 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, 
 Peter Rajnoha <prajnoha@redhat.com>, Steve Baker <sbaker@redhat.com>
Message-ID: <alpine.LRH.2.21.2302090948560.7238@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v2] dm: send just one event on resize, not two
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

I discussed this uevent thing with Zdenek and we concluded that it is 
sufficient to send just one uevent on resize, not two.

So, I made a second patch that fixes the uevent-while-suspended bug. It 
replaces set_capacity_and_notify with set_capacity (so that no uevent is 
set at this point) and it detects capacity change in do_resume - and if 
the capacity was changed, it adds "RESIZE=1" to an uevent that is being 
sent.

Zdenek and Peter, please test it.

Mikulas




From: Mikulas Patocka <mpatocka@redhat.com>

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

We replace the function set_capacity_and_notify with set_capacity, so that
the uevent is not sent at this point. In do_resume, we detect if the
capacity has changed and we pass a boolean variable need_resize_uevent to
dm_kobject_uevent. dm_kobject_uevent adds "RESIZE=1" to the uevent if
need_resize_uevent is set.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ioctl.c |   13 ++++++++++---
 drivers/md/dm.c       |   27 +++++++++++++--------------
 drivers/md/dm.h       |    2 +-
 3 files changed, 24 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c	2023-02-09 15:46:39.000000000 +0100
+++ linux-2.6/drivers/md/dm-ioctl.c	2023-02-09 15:46:39.000000000 +0100
@@ -482,7 +482,7 @@ static struct mapped_device *dm_hash_ren
 		dm_table_event(table);
 	dm_put_live_table(hc->md, srcu_idx);
 
-	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, param->event_nr))
+	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, param->event_nr, false))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	md = hc->md;
@@ -995,7 +995,7 @@ static int dev_remove(struct file *filp,
 
 	dm_ima_measure_on_device_remove(md, false);
 
-	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
+	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr, false))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(md);
@@ -1129,6 +1129,7 @@ static int do_resume(struct dm_ioctl *pa
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map, *old_map = NULL;
+	bool need_resize_uevent = false;
 
 	down_write(&_hash_lock);
 
@@ -1149,6 +1150,8 @@ static int do_resume(struct dm_ioctl *pa
 
 	/* Do we need to load a new map ? */
 	if (new_map) {
+		sector_t old_size, new_size;
+
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
@@ -1157,6 +1160,7 @@ static int do_resume(struct dm_ioctl *pa
 		if (!dm_suspended_md(md))
 			dm_suspend(md, suspend_flags);
 
+		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
 			dm_sync_table(md);
@@ -1164,6 +1168,9 @@ static int do_resume(struct dm_ioctl *pa
 			dm_put(md);
 			return PTR_ERR(old_map);
 		}
+		new_size = dm_get_size(md);
+		if (old_size && new_size && old_size != new_size)
+			need_resize_uevent = true;
 
 		if (dm_table_get_mode(new_map) & FMODE_WRITE)
 			set_disk_ro(dm_disk(md), 0);
@@ -1176,7 +1183,7 @@ static int do_resume(struct dm_ioctl *pa
 		if (!r) {
 			dm_ima_measure_on_device_resume(md, new_map ? true : false);
 
-			if (!dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
+			if (!dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr, need_resize_uevent))
 				param->flags |= DM_UEVENT_GENERATED_FLAG;
 		}
 	}
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2023-02-09 15:46:39.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2023-02-09 15:46:39.000000000 +0100
@@ -2172,10 +2172,7 @@ static struct dm_table *__bind(struct ma
 	if (size != dm_get_size(md))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	if (!get_capacity(md->disk))
-		set_capacity(md->disk, size);
-	else
-		set_capacity_and_notify(md->disk, size);
+	set_capacity(md->disk, size);
 
 	dm_table_event_callback(t, event_callback, md);
 
@@ -2968,23 +2965,25 @@ EXPORT_SYMBOL_GPL(dm_internal_resume_fas
  * Event notification.
  *---------------------------------------------------------------*/
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		       unsigned cookie)
+		      unsigned cookie, bool need_resize_uevent)
 {
 	int r;
 	unsigned noio_flag;
 	char udev_cookie[DM_COOKIE_LENGTH];
-	char *envp[] = { udev_cookie, NULL };
-
-	noio_flag = memalloc_noio_save();
-
-	if (!cookie)
-		r = kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
-	else {
+	char *envp[3] = { NULL, NULL, NULL };
+	char **envpp = envp;
+	if (cookie) {
 		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
 			 DM_COOKIE_ENV_VAR_NAME, cookie);
-		r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
-				       action, envp);
+		*envpp++ = udev_cookie;
 	}
+	if (need_resize_uevent) {
+		*envpp++ = "RESIZE=1";
+	}
+
+	noio_flag = memalloc_noio_save();
+
+	r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj, action, envp);
 
 	memalloc_noio_restore(noio_flag);
 
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h	2023-02-09 15:46:39.000000000 +0100
+++ linux-2.6/drivers/md/dm.h	2023-02-09 15:46:39.000000000 +0100
@@ -203,7 +203,7 @@ int dm_get_table_device(struct mapped_de
 void dm_put_table_device(struct mapped_device *md, struct dm_dev *d);
 
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		      unsigned cookie);
+		      unsigned cookie, bool need_resize_uevent);
 
 void dm_internal_suspend(struct mapped_device *md);
 void dm_internal_resume(struct mapped_device *md);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

