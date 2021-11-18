Return-Path: <SRS0=dXIA=QF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB017C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DEC861A7D
	for <dm-devel@archiver.kernel.org>; Thu, 18 Nov 2021 23:04:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4DEC861A7D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-1ov-E26LMUialc3iaNs78Q-1; Thu, 18 Nov 2021 18:04:35 -0500
X-MC-Unique: 1ov-E26LMUialc3iaNs78Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 656D6802C96;
	Thu, 18 Nov 2021 23:04:31 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F4885BAE5;
	Thu, 18 Nov 2021 23:04:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 29E1E4EA38;
	Thu, 18 Nov 2021 23:04:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AIMx6XJ002077 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 18 Nov 2021 17:59:06 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id ABFF32026D60; Thu, 18 Nov 2021 22:59:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A7C4C2026D46
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DF34811E7F
	for <dm-devel@redhat.com>; Thu, 18 Nov 2021 22:59:03 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-404-7_dmKXpHPHK-wwAtfDD_LA-1; Thu, 18 Nov 2021 17:58:59 -0500
X-MC-Unique: 7_dmKXpHPHK-wwAtfDD_LA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 87F05218CE;
	Thu, 18 Nov 2021 22:58:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4202B13B11;
	Thu, 18 Nov 2021 22:58:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id UJkwDrLalmGHPAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 18 Nov 2021 22:58:58 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Thu, 18 Nov 2021 23:57:57 +0100
Message-Id: <20211118225840.19810-6-mwilck@suse.com>
In-Reply-To: <20211118225840.19810-1-mwilck@suse.com>
References: <20211118225840.19810-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AIMx6XJ002077
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v2 05/48] libmultipath: improve cleanup of uevent
	queues on exit
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

uevents listed on merge_node must be cleaned up, too. uevents
cancelled while being serviced and temporary queues, likewise.
The global uevq must be cleaned out in the uevent listener thread,
because it might have added events after the dispatcher thread
had already finished.

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 libmultipath/uevent.c | 49 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/libmultipath/uevent.c b/libmultipath/uevent.c
index 4265904..082e891 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -91,16 +91,25 @@ struct uevent * alloc_uevent (void)
 	return uev;
 }
 
+static void uevq_cleanup(struct list_head *tmpq);
+
+static void cleanup_uev(void *arg)
+{
+	struct uevent *uev = arg;
+
+	uevq_cleanup(&uev->merge_node);
+	if (uev->udev)
+		udev_device_unref(uev->udev);
+	FREE(uev);
+}
+
 static void uevq_cleanup(struct list_head *tmpq)
 {
 	struct uevent *uev, *tmp;
 
 	list_for_each_entry_safe(uev, tmp, tmpq, node) {
 		list_del_init(&uev->node);
-
-		if (uev->udev)
-			udev_device_unref(uev->udev);
-		FREE(uev);
+		cleanup_uev(uev);
 	}
 }
 
@@ -384,14 +393,10 @@ service_uevq(struct list_head *tmpq)
 	list_for_each_entry_safe(uev, tmp, tmpq, node) {
 		list_del_init(&uev->node);
 
+		pthread_cleanup_push(cleanup_uev, uev);
 		if (my_uev_trigger && my_uev_trigger(uev, my_trigger_data))
 			condlog(0, "uevent trigger error");
-
-		uevq_cleanup(&uev->merge_node);
-
-		if (uev->udev)
-			udev_device_unref(uev->udev);
-		FREE(uev);
+		pthread_cleanup_pop(1);
 	}
 }
 
@@ -411,6 +416,18 @@ static void monitor_cleanup(void *arg)
 	udev_monitor_unref(monitor);
 }
 
+static void cleanup_uevq(void *arg)
+{
+	uevq_cleanup(arg);
+}
+
+static void cleanup_global_uevq(void *arg __attribute__((unused)))
+{
+	pthread_mutex_lock(uevq_lockp);
+	uevq_cleanup(&uevq);
+	pthread_mutex_unlock(uevq_lockp);
+}
+
 /*
  * Service the uevent queue.
  */
@@ -425,6 +442,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 	while (1) {
 		LIST_HEAD(uevq_tmp);
 
+		pthread_cleanup_push(cleanup_mutex, uevq_lockp);
 		pthread_mutex_lock(uevq_lockp);
 		servicing_uev = 0;
 		/*
@@ -436,14 +454,17 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 		}
 		servicing_uev = 1;
 		list_splice_init(&uevq, &uevq_tmp);
-		pthread_mutex_unlock(uevq_lockp);
+		pthread_cleanup_pop(1);
+
 		if (!my_uev_trigger)
 			break;
+
+		pthread_cleanup_push(cleanup_uevq, &uevq_tmp);
 		merge_uevq(&uevq_tmp);
 		service_uevq(&uevq_tmp);
+		pthread_cleanup_pop(1);
 	}
 	condlog(3, "Terminating uev service queue");
-	uevq_cleanup(&uevq);
 	return 0;
 }
 
@@ -600,6 +621,8 @@ int uevent_listen(struct udev *udev)
 
 	events = 0;
 	gettimeofday(&start_time, NULL);
+	pthread_cleanup_push(cleanup_global_uevq, NULL);
+	pthread_cleanup_push(cleanup_uevq, &uevlisten_tmp);
 	while (1) {
 		struct uevent *uev;
 		struct udev_device *dev;
@@ -650,6 +673,8 @@ int uevent_listen(struct udev *udev)
 		gettimeofday(&start_time, NULL);
 		timeout = 30;
 	}
+	pthread_cleanup_pop(1);
+	pthread_cleanup_pop(1);
 out:
 	pthread_cleanup_pop(1);
 out_udev:
-- 
2.33.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

