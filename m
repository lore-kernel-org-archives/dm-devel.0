Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D810481A3
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 03:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709265192; cv=none; b=H7XX58QU01DWcqL+sifLGLTaoD89YDHmXQHuoUtqvNU2R//rPDmdZZqKvBYAZLhNxPWWqKNFumDq3A3nXgjMMVKGVycwb5NRv0TQbOAdctoDFSw3HS/qpWtlPEzbXev4+3ier75pev6IX8Thz92DnKV9GVUL0h++h0SgZiiYZjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709265192; c=relaxed/simple;
	bh=I6sLRz+JShDdQtNC5SNFExgchdDv0DxHckhft4EKjNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NbaeeuYas0HDkHg/GmvTAN418upvckqUDQBLdhdZDOglBZ4OTYjJHwD3fV75q4Rfr88giF9sa0w3ABFTfYI8oHUSYBjYfi8GGBw83mPaNphLt82vTm3WW6tHUBPWyjh2iUyeUW7dYFFUbUVxcww6gBIfrP+vCFjjZtaBan3mgqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FJFtSCUE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FJFtSCUE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709265189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o+p7dpwvOyAT+yBXkioMly+56vzikfKXcioObUL386E=;
	b=FJFtSCUEFMaUYnfqrAP3EvreqxEZzFidVVo44XbchxnuBKxi7qiXvyYHqscAjNOCljAmK5
	CCIrXde2bRGLnTcXVEyZpfVxXaXThwcrlUxmXpbi+0qkZjfqCTi/ngMvsc5Y3LT4Ekz7a/
	Gw9Ex2N9PmgqrfPIco16QKCJXlNoGyU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-645-b0wwqHvmMyCWmxhesK5-RQ-1; Thu,
 29 Feb 2024 22:53:05 -0500
X-MC-Unique: b0wwqHvmMyCWmxhesK5-RQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 941173C0C4A2;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BEA61C060AF;
	Fri,  1 Mar 2024 03:53:05 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 88E6C9EB44; Thu, 29 Feb 2024 22:53:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 13/13] dm vdo thread-device: rename all methods to reflect vdo-only use
Date: Thu, 29 Feb 2024 22:53:05 -0500
Message-ID: <bb1aaff339ebf031223e8d4cfa7951f3954de496.1709264539.git.msakai@redhat.com>
In-Reply-To: <cover.1709264538.git.msakai@redhat.com>
References: <cover.1709264538.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Also moved vdo_init()'s call to vdo_initialize_thread_device_registry
next to other registry initialization.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dm-vdo-target.c | 30 +++++++++++++++---------------
 drivers/md/dm-vdo/logger.c        |  2 +-
 drivers/md/dm-vdo/thread-device.c | 10 ++++------
 drivers/md/dm-vdo/thread-device.h | 14 +++++++-------
 4 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/drivers/md/dm-vdo/dm-vdo-target.c b/drivers/md/dm-vdo/dm-vdo-target.c
index e754b9e30cab..7afd1dfec649 100644
--- a/drivers/md/dm-vdo/dm-vdo-target.c
+++ b/drivers/md/dm-vdo/dm-vdo-target.c
@@ -1107,7 +1107,7 @@ static int vdo_message(struct dm_target *ti, unsigned int argc, char **argv,
 
 	vdo = get_vdo_for_target(ti);
 	uds_register_allocating_thread(&allocating_thread, NULL);
-	uds_register_thread_device_id(&instance_thread, &vdo->instance);
+	vdo_register_thread_device_id(&instance_thread, &vdo->instance);
 
 	/*
 	 * Must be done here so we don't map return codes. The code in dm-ioctl expects a 1 for a
@@ -1120,7 +1120,7 @@ static int vdo_message(struct dm_target *ti, unsigned int argc, char **argv,
 		result = vdo_status_to_errno(process_vdo_message(vdo, argc, argv));
 	}
 
-	uds_unregister_thread_device_id();
+	vdo_unregister_thread_device_id();
 	uds_unregister_allocating_thread();
 	return result;
 }
@@ -1632,9 +1632,9 @@ static int construct_new_vdo(struct dm_target *ti, unsigned int argc, char **arg
 	if (result != VDO_SUCCESS)
 		return -ENOMEM;
 
-	uds_register_thread_device_id(&instance_thread, &instance);
+	vdo_register_thread_device_id(&instance_thread, &instance);
 	result = construct_new_vdo_registered(ti, argc, argv, instance);
-	uds_unregister_thread_device_id();
+	vdo_unregister_thread_device_id();
 	return result;
 }
 
@@ -1913,9 +1913,9 @@ static int vdo_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (vdo == NULL) {
 		result = construct_new_vdo(ti, argc, argv);
 	} else {
-		uds_register_thread_device_id(&instance_thread, &vdo->instance);
+		vdo_register_thread_device_id(&instance_thread, &vdo->instance);
 		result = update_existing_vdo(device_name, ti, argc, argv, vdo);
-		uds_unregister_thread_device_id();
+		vdo_unregister_thread_device_id();
 	}
 
 	uds_unregister_allocating_thread();
@@ -1935,7 +1935,7 @@ static void vdo_dtr(struct dm_target *ti)
 		unsigned int instance = vdo->instance;
 		struct registered_thread allocating_thread, instance_thread;
 
-		uds_register_thread_device_id(&instance_thread, &instance);
+		vdo_register_thread_device_id(&instance_thread, &instance);
 		uds_register_allocating_thread(&allocating_thread, NULL);
 
 		device_name = vdo_get_device_name(ti);
@@ -1945,7 +1945,7 @@ static void vdo_dtr(struct dm_target *ti)
 
 		vdo_destroy(uds_forget(vdo));
 		uds_log_info("device '%s' stopped", device_name);
-		uds_unregister_thread_device_id();
+		vdo_unregister_thread_device_id();
 		uds_unregister_allocating_thread();
 		release_instance(instance);
 	} else if (config == vdo->device_config) {
@@ -2104,7 +2104,7 @@ static void vdo_postsuspend(struct dm_target *ti)
 	const char *device_name;
 	int result;
 
-	uds_register_thread_device_id(&instance_thread, &vdo->instance);
+	vdo_register_thread_device_id(&instance_thread, &vdo->instance);
 	device_name = vdo_get_device_name(vdo->device_config->owning_target);
 	uds_log_info("suspending device '%s'", device_name);
 
@@ -2129,7 +2129,7 @@ static void vdo_postsuspend(struct dm_target *ti)
 				       device_name);
 	}
 
-	uds_unregister_thread_device_id();
+	vdo_unregister_thread_device_id();
 }
 
 /**
@@ -2846,11 +2846,11 @@ static int vdo_preresume(struct dm_target *ti)
 	struct vdo *vdo = get_vdo_for_target(ti);
 	int result;
 
-	uds_register_thread_device_id(&instance_thread, &vdo->instance);
+	vdo_register_thread_device_id(&instance_thread, &vdo->instance);
 	result = vdo_preresume_registered(ti, vdo);
 	if ((result == VDO_PARAMETER_MISMATCH) || (result == VDO_INVALID_ADMIN_STATE))
 		result = -EINVAL;
-	uds_unregister_thread_device_id();
+	vdo_unregister_thread_device_id();
 	return vdo_status_to_errno(result);
 }
 
@@ -2858,10 +2858,10 @@ static void vdo_resume(struct dm_target *ti)
 {
 	struct registered_thread instance_thread;
 
-	uds_register_thread_device_id(&instance_thread,
+	vdo_register_thread_device_id(&instance_thread,
 				      &get_vdo_for_target(ti)->instance);
 	uds_log_info("device '%s' resumed", vdo_get_device_name(ti));
-	uds_unregister_thread_device_id();
+	vdo_unregister_thread_device_id();
 }
 
 /*
@@ -2912,10 +2912,10 @@ static int __init vdo_init(void)
 	/*
 	 * UDS module level initialization must be done first, as VDO initialization depends on it
 	 */
-	uds_initialize_thread_device_registry();
 	uds_memory_init();
 	uds_init_sysfs();
 
+	vdo_initialize_thread_device_registry();
 	vdo_initialize_device_registry_once();
 	uds_log_info("loaded version %s", CURRENT_VERSION);
 
diff --git a/drivers/md/dm-vdo/logger.c b/drivers/md/dm-vdo/logger.c
index 969f10771ada..6ba7e99ee8f9 100644
--- a/drivers/md/dm-vdo/logger.c
+++ b/drivers/md/dm-vdo/logger.c
@@ -176,7 +176,7 @@ static void emit_log_message(int priority, const char *module, const char *prefi
 	}
 
 	/* Not at interrupt level; we have a process we can look at, and might have a device ID. */
-	device_instance = uds_get_thread_device_id();
+	device_instance = vdo_get_thread_device_id();
 	if (device_instance >= 0) {
 		emit_log_message_to_kernel(priority, "%s%u:%s: %s%pV%pV\n", module,
 					   device_instance, current->comm, prefix, vaf1,
diff --git a/drivers/md/dm-vdo/thread-device.c b/drivers/md/dm-vdo/thread-device.c
index 2bf14b9f67f8..df13ca914db8 100644
--- a/drivers/md/dm-vdo/thread-device.c
+++ b/drivers/md/dm-vdo/thread-device.c
@@ -5,24 +5,22 @@
 
 #include "thread-device.h"
 
-#include "thread-registry.h"
-
 /* A registry of threads associated with device id numbers. */
 static struct thread_registry device_id_thread_registry;
 
 /* Any registered thread must be unregistered. */
-void uds_register_thread_device_id(struct registered_thread *new_thread,
+void vdo_register_thread_device_id(struct registered_thread *new_thread,
 				   unsigned int *id_ptr)
 {
 	vdo_register_thread(&device_id_thread_registry, new_thread, id_ptr);
 }
 
-void uds_unregister_thread_device_id(void)
+void vdo_unregister_thread_device_id(void)
 {
 	vdo_unregister_thread(&device_id_thread_registry);
 }
 
-int uds_get_thread_device_id(void)
+int vdo_get_thread_device_id(void)
 {
 	const unsigned int *pointer;
 
@@ -30,7 +28,7 @@ int uds_get_thread_device_id(void)
 	return (pointer != NULL) ? *pointer : -1;
 }
 
-void uds_initialize_thread_device_registry(void)
+void vdo_initialize_thread_device_registry(void)
 {
 	vdo_initialize_thread_registry(&device_id_thread_registry);
 }
diff --git a/drivers/md/dm-vdo/thread-device.h b/drivers/md/dm-vdo/thread-device.h
index 428b2908541d..494d9c9ef3f6 100644
--- a/drivers/md/dm-vdo/thread-device.h
+++ b/drivers/md/dm-vdo/thread-device.h
@@ -3,18 +3,18 @@
  * Copyright 2023 Red Hat
  */
 
-#ifndef UDS_THREAD_DEVICE_H
-#define UDS_THREAD_DEVICE_H
+#ifndef VDO_THREAD_DEVICE_H
+#define VDO_THREAD_DEVICE_H
 
 #include "thread-registry.h"
 
-void uds_register_thread_device_id(struct registered_thread *new_thread,
+void vdo_register_thread_device_id(struct registered_thread *new_thread,
 				   unsigned int *id_ptr);
 
-void uds_unregister_thread_device_id(void);
+void vdo_unregister_thread_device_id(void);
 
-int uds_get_thread_device_id(void);
+int vdo_get_thread_device_id(void);
 
-void uds_initialize_thread_device_registry(void);
+void vdo_initialize_thread_device_registry(void);
 
-#endif /* UDS_THREAD_DEVICE_H */
+#endif /* VDO_THREAD_DEVICE_H */
-- 
2.42.0

