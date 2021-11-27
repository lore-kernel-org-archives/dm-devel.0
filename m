Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46779C433EF
	for <dm-devel@archiver.kernel.org>; Sat, 27 Nov 2021 15:20:12 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-jznpmZPbNqq2wl8LTbwj8Q-1; Sat, 27 Nov 2021 10:20:07 -0500
X-MC-Unique: jznpmZPbNqq2wl8LTbwj8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 796FF39385;
	Sat, 27 Nov 2021 15:20:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 369E160BF1;
	Sat, 27 Nov 2021 15:20:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8AD011809C8A;
	Sat, 27 Nov 2021 15:20:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ARFJl51032657 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 27 Nov 2021 10:19:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 07F1E404727A; Sat, 27 Nov 2021 15:19:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 03C3C4047272
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE560185A7B2
	for <dm-devel@redhat.com>; Sat, 27 Nov 2021 15:19:46 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-169-FtGvHSNgMnaNbV4BkOedOg-1; Sat, 27 Nov 2021 10:19:44 -0500
X-MC-Unique: FtGvHSNgMnaNbV4BkOedOg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 75834212CC;
	Sat, 27 Nov 2021 15:19:43 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2963113AAD;
	Sat, 27 Nov 2021 15:19:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id UIUECI9MomErFgAAMHmgww
	(envelope-from <mwilck@suse.com>); Sat, 27 Nov 2021 15:19:43 +0000
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Sat, 27 Nov 2021 16:18:58 +0100
Message-Id: <20211127151929.7727-6-mwilck@suse.com>
In-Reply-To: <20211127151929.7727-1-mwilck@suse.com>
References: <20211127151929.7727-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1ARFJl51032657
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, Chongyun Wu <wu.chongyun@h3c.com>,
	dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 05/35] libmultipath: improve cleanup of uevent
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index fd4556c..70ad217 100644
--- a/libmultipath/uevent.c
+++ b/libmultipath/uevent.c
@@ -90,16 +90,25 @@ struct uevent * alloc_uevent (void)
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
+	free(uev);
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
-		free(uev);
+		cleanup_uev(uev);
 	}
 }
 
@@ -383,14 +392,10 @@ service_uevq(struct list_head *tmpq)
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
-		free(uev);
+		pthread_cleanup_pop(1);
 	}
 }
 
@@ -410,6 +415,18 @@ static void monitor_cleanup(void *arg)
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
@@ -424,6 +441,7 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
 	while (1) {
 		LIST_HEAD(uevq_tmp);
 
+		pthread_cleanup_push(cleanup_mutex, uevq_lockp);
 		pthread_mutex_lock(uevq_lockp);
 		servicing_uev = 0;
 		/*
@@ -435,14 +453,17 @@ int uevent_dispatch(int (*uev_trigger)(struct uevent *, void * trigger_data),
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
 
@@ -599,6 +620,8 @@ int uevent_listen(struct udev *udev)
 
 	events = 0;
 	gettimeofday(&start_time, NULL);
+	pthread_cleanup_push(cleanup_global_uevq, NULL);
+	pthread_cleanup_push(cleanup_uevq, &uevlisten_tmp);
 	while (1) {
 		struct uevent *uev;
 		struct udev_device *dev;
@@ -649,6 +672,8 @@ int uevent_listen(struct udev *udev)
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

