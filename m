Return-Path: <SRS0=cnJz=DX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E3AC43457
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DED6E2084C
	for <dm-devel@archiver.kernel.org>; Fri, 16 Oct 2020 10:44:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DED6E2084C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-R3j5bHHbMleJHRvZQ3ETzQ-1; Fri, 16 Oct 2020 06:44:01 -0400
X-MC-Unique: R3j5bHHbMleJHRvZQ3ETzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E385186DD2E;
	Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 419836FEE6;
	Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 167B45810D;
	Fri, 16 Oct 2020 10:43:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09GAhqSf020145 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Oct 2020 06:43:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9A94F11DBD71; Fri, 16 Oct 2020 10:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 961E311DBD70
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F651800969
	for <dm-devel@redhat.com>; Fri, 16 Oct 2020 10:43:52 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-460-073mTBqVN4G4UAh1mZSY2Q-1;
	Fri, 16 Oct 2020 06:43:49 -0400
X-MC-Unique: 073mTBqVN4G4UAh1mZSY2Q-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id BD994AF38;
	Fri, 16 Oct 2020 10:43:46 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri, 16 Oct 2020 12:43:16 +0200
Message-Id: <20201016104329.8337-9-mwilck@suse.com>
In-Reply-To: <20201016104329.8337-1-mwilck@suse.com>
References: <20201016104329.8337-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09GAhqSf020145
X-loop: dm-devel@redhat.com
Cc: Chongyun Wu <wu.chongyun@h3c.com>, dm-devel@redhat.com,
	Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH v3 08/21] multipathd: cancel threads early during
	shutdown
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Cancel the other threads before taking vecs->lock. This avoids
delays during shutdown caused e.g. by the checker thread holding
the vecs lock.

Note: this makes it possible that cancelled threads leak memory,
because they can now be cancelled before having released the vecs
lock. I believe this is acceptable, as only threads are affected
that are cancelled during multipathd shutdown.

Cc: Chongyun Wu <wu.chongyun@h3c.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 39aea4a..d1f8cc1 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -3073,23 +3073,24 @@ child (__attribute__((unused)) void *param)
 		}
 	}
 
-	lock(&vecs->lock);
+	pthread_cancel(check_thr);
+	pthread_cancel(uevent_thr);
+	pthread_cancel(uxlsnr_thr);
+	pthread_cancel(uevq_thr);
+	if (poll_dmevents)
+		pthread_cancel(dmevent_thr);
+
 	conf = get_multipath_config();
 	queue_without_daemon = conf->queue_without_daemon;
 	put_multipath_config(conf);
+
+	lock(&vecs->lock);
 	if (queue_without_daemon == QUE_NO_DAEMON_OFF)
 		vector_foreach_slot(vecs->mpvec, mpp, i)
 			dm_queue_if_no_path(mpp->alias, 0);
 	remove_maps_and_stop_waiters(vecs);
 	unlock(&vecs->lock);
 
-	pthread_cancel(check_thr);
-	pthread_cancel(uevent_thr);
-	pthread_cancel(uxlsnr_thr);
-	pthread_cancel(uevq_thr);
-	if (poll_dmevents)
-		pthread_cancel(dmevent_thr);
-
 	pthread_join(check_thr, NULL);
 	pthread_join(uevent_thr, NULL);
 	pthread_join(uxlsnr_thr, NULL);
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

