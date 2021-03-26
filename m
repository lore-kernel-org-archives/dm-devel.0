Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050E9C433C1
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 00:57:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 91CDE61A21
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 00:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91CDE61A21
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1616720223;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xFClh4Ri1ZgnoEED/o2A3ra70oC4EAG4N2Rq54YNuhg=;
	b=T/mbsYtdtNmTuwzcrHE6cOXG0hB2Z1IjJxkZTZ8b6WNbJMPDRmUExafoKE1RlEiOCraQwB
	EpW2oJpKuMQFJgvoeQwSh/PHRbfLEHVi1y4HQzdiommy6ERuiS0r6zx9+CIfgXNmld/WGr
	/XzMC3TcukPioJdyfx4Bx7mSwy0DgxQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-oLScMAFAPxGC6vn1yTOFKQ-1; Thu, 25 Mar 2021 20:57:01 -0400
X-MC-Unique: oLScMAFAPxGC6vn1yTOFKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C107710AF389;
	Fri, 26 Mar 2021 00:56:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 989191A863;
	Fri, 26 Mar 2021 00:56:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 680B21809C83;
	Fri, 26 Mar 2021 00:56:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12Q0qt3S019171 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 25 Mar 2021 20:52:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7044519705; Fri, 26 Mar 2021 00:52:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FB191972B;
	Fri, 26 Mar 2021 00:52:52 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12Q0qow1010275; 
	Thu, 25 Mar 2021 19:52:50 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12Q0qo2W010274;
	Thu, 25 Mar 2021 19:52:50 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Thu, 25 Mar 2021 19:52:46 -0500
Message-Id: <1616719966-10221-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 4/4] multipathd: don't trigger uevent for
	partitions on wwid change
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If the wwid changed, the device is no longer the same, so sending add
events to the devices partitions doesn't make any sense.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index bc747d0e..3579bad7 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -845,7 +845,6 @@ handle_path_wwid_change(struct path *pp, struct vectors *vecs)
 	}
 	rescan_path(udd);
 	sysfs_attr_set_value(udd, "uevent", "add", strlen("add"));
-	trigger_partitions_udev_change(udd, "add", strlen("add"));
 	udev_device_unref(udd);
 }
 
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

