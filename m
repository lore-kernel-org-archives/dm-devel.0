Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 329FEC433E6
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 17:01:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9F99922E02
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 17:01:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F99922E02
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-fji_a114NPGOc_uwezvmSg-1; Fri, 08 Jan 2021 12:01:31 -0500
X-MC-Unique: fji_a114NPGOc_uwezvmSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAFC8C7404;
	Fri,  8 Jan 2021 17:01:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6922018811;
	Fri,  8 Jan 2021 17:01:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3FC654E58E;
	Fri,  8 Jan 2021 17:01:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 108H1Neu022583 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Jan 2021 12:01:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A222B2166B2E; Fri,  8 Jan 2021 17:01:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D7412166B28
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 17:01:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 720AD858280
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 17:01:21 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-338-KOlJUU1TP1KenYD-m9-71g-1;
	Fri, 08 Jan 2021 12:01:16 -0500
X-MC-Unique: KOlJUU1TP1KenYD-m9-71g-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 00DE7AD87;
	Fri,  8 Jan 2021 17:01:15 +0000 (UTC)
From: mwilck@suse.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Date: Fri,  8 Jan 2021 18:00:44 +0100
Message-Id: <20210108170044.7883-4-mwilck@suse.com>
In-Reply-To: <20210108170044.7883-1-mwilck@suse.com>
References: <20210108170044.7883-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 108H1Neu022583
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Subject: [dm-devel] [PATCH 3/3] Revert "multipathd: uev_trigger(): handle
	incomplete ADD events"
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

cb10d38 ("multipathd: uev_trigger(): handle incomplete ADD events") was an
attempt to fix issues with incompletely initialized multipath maps observed
in various scenarious. However, that patch was wrong. Spurious "change" events
as this patch would generate have no effect, because they are ignored by
the device-mapper udev rules. The correct fix for the problem we were
facing is 0d66e03 ("libmultipath: force map reload if udev incomplete"),
which forces a full map reload.

Reverts: cb10d38 ("multipathd: uev_trigger(): handle incomplete ADD events")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/main.c | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 7612430..92c45d4 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1499,31 +1499,6 @@ uev_trigger (struct uevent * uev, void * trigger_data)
 			uev_pathfail_check(uev, vecs);
 		} else if (!strncmp(uev->action, "remove", 6)) {
 			r = uev_remove_map(uev, vecs);
-		} else if (!strncmp(uev->action, "add", 3)) {
-			const char *ev_name;
-			char *dm_name;
-			int major = -1, minor = -1;
-
-			/*
-			 * If DM_NAME is not set for a valid map, trigger a
-			 * change event. This can happen during coldplug
-			 * if udev was killed between handling the 'add' and
-			 * 'change' events before.
-			 */
-			ev_name = uevent_get_dm_name(uev);
-			if (!ev_name) {
-				major = uevent_get_major(uev);
-				minor = uevent_get_minor(uev);
-				dm_name = dm_mapname(major, minor);
-				if (dm_name && *dm_name) {
-					condlog(2, "%s: received incomplete 'add' uevent, triggering change",
-						dm_name);
-					udev_device_set_sysattr_value(uev->udev,
-								      "uevent",
-								      "change");
-					free(dm_name);
-				}
-			}
 		}
 		goto out;
 	}
-- 
2.29.2


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

