Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDEFC433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 208DD619E5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 208DD619E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637184113;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lkuqnqEIlm5vMkNLAmZC+My27Luftfsvn6pADc9LFAc=;
	b=RrDXSnEcD5NC9cQeFVHHzADCYECRekqwny7F325DOD95NKdKl8S/gwVVtd+ySDPk/WePHg
	HwNa4C+tg39gPb7/hCTyMNMlT33kts2BLUEyv4LVFvYdXoEwgKgdbVRTt2iEzK1aUu7yOq
	V99Hx7FgEb9sH0mWfI612DEqkBf3/NI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-7rxX8KPcPsWRvz3eFwrpTg-1; Wed, 17 Nov 2021 16:21:51 -0500
X-MC-Unique: 7rxX8KPcPsWRvz3eFwrpTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 45C2E104ECFD;
	Wed, 17 Nov 2021 21:21:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 298715C22B;
	Wed, 17 Nov 2021 21:21:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 03CAC4A704;
	Wed, 17 Nov 2021 21:21:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHLLbRK025287 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 16:21:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DEE0960C4A; Wed, 17 Nov 2021 21:21:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AC24F60CC3;
	Wed, 17 Nov 2021 21:21:37 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHLLZhl004951; 
	Wed, 17 Nov 2021 15:21:36 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHLLZg2004950;
	Wed, 17 Nov 2021 15:21:35 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 15:21:23 -0600
Message-Id: <1637184084-4882-9-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
References: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 8/9] multipathd: Remove dependency on
	systemd-udev-settle.service
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

multipathd can now handle starting up with incompletely initialized
paths, so it no longer needs to wait for the device Coldplug to
complete. However multipathd may need to write to /etc (for the wwids
and bindings files), so in needs to wait for the root filesystem to
be remounted read/write before starting.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
---
 multipathd/multipathd.service | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/multipathd/multipathd.service b/multipathd/multipathd.service
index 0b2ac814..87cb5349 100644
--- a/multipathd/multipathd.service
+++ b/multipathd/multipathd.service
@@ -1,9 +1,8 @@
 [Unit]
 Description=Device-Mapper Multipath Device Controller
-Wants=systemd-udev-trigger.service systemd-udev-settle.service
 Before=iscsi.service iscsid.service lvm2-activation-early.service
 Before=local-fs-pre.target blk-availability.service shutdown.target
-After=multipathd.socket systemd-udev-trigger.service systemd-udev-settle.service
+After=multipathd.socket systemd-remount-fs.service
 DefaultDependencies=no
 Conflicts=shutdown.target
 ConditionKernelCommandLine=!nompath
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

