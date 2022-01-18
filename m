Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E88A1C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 03:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642476494;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=q0hcDVNYIzylWeJkEz6qbpBOC2EJZMx/6SUnRELTbpo=;
	b=Src9ZHxLDweW9cuLSi14jd/5Ww0aoxseg6Py+8wVFYVQACSxnccTzoCBthJwp+rkLnKW06
	TqlMmgFdWDfYmMOTXnd1+yY2dBwsgzKUgRQeWluslT32gX1lBG5//twAWf4sU4iI94KQU2
	Jzb/lSPh2zHmamXxXXq8CWEr5gpSz7U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-nkLF1BqPOy-aGyywbm2cHQ-1; Mon, 17 Jan 2022 22:28:11 -0500
X-MC-Unique: nkLF1BqPOy-aGyywbm2cHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5282B1006AA6;
	Tue, 18 Jan 2022 03:28:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 389675E24E;
	Tue, 18 Jan 2022 03:28:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 10D521809CBF;
	Tue, 18 Jan 2022 03:28:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I3RwgC028873 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 Jan 2022 22:27:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 91C1C56F7C; Tue, 18 Jan 2022 03:27:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 679915DB86;
	Tue, 18 Jan 2022 03:27:41 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 20I3RcPk006024; 
	Mon, 17 Jan 2022 21:27:38 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 20I3Rcbx006023;
	Mon, 17 Jan 2022 21:27:38 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 17 Jan 2022 21:27:33 -0600
Message-Id: <1642476453-5974-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1642476453-5974-1-git-send-email-bmarzins@redhat.com>
References: <1642476453-5974-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 3/3] multipathd: trigger udev change on path
	addition
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

When a multipath device is created for the first time, there is a window
where some path devices way be added to the multipath device, but never
claimed in udev. This can allow other device owners, like lvm, to think
they can use the device.

When a multipath device is first created, all the existing paths that
are not claimed by multipath have a uevent triggered so that they can
get claimed. After that, multipath assumes all future paths added to the
multipath device will have been claimed by multipath, since the device's
WWID is now in the wwids file.  This doesn't work for any paths that
have already been processed by the multipath.rules udev rules before
the multipath device was created.

To close this window, when path device is added, and a matching
multipath device already exists, multipathd now checks if the device is
claimed by multipath, and if not, triggers a uevent to claim it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/libmultipath.version | 1 +
 multipathd/main.c                 | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
index d8cee0c3..b663cb29 100644
--- a/libmultipath/libmultipath.version
+++ b/libmultipath/libmultipath.version
@@ -210,6 +210,7 @@ global:
 	sysfs_is_multipathed;
 	timespeccmp;
 	timespecsub;
+	trigger_path_udev_change;
 	trigger_paths_udev_change;
 	truncate_strbuf;
 	udev;
diff --git a/multipathd/main.c b/multipathd/main.c
index c241dad5..44ca5b12 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -1157,6 +1157,8 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
 		free_path(pp);
 		return 1;
 	}
+	if (mpp)
+		trigger_path_udev_change(pp, true);
 	if (mpp && mpp->wait_for_udev &&
 	    (pathcount(mpp, PATH_UP) > 0 ||
 	     (pathcount(mpp, PATH_GHOST) > 0 &&
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

