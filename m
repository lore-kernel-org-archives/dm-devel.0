Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A7EC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 20:35:18 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-4-pPAW6VOVW2i7oCaayC8g-1; Thu, 06 Jan 2022 15:35:10 -0500
X-MC-Unique: 4-pPAW6VOVW2i7oCaayC8g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 580B71006AA5;
	Thu,  6 Jan 2022 20:35:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20B8318512;
	Thu,  6 Jan 2022 20:35:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A6D5B4BB7C;
	Thu,  6 Jan 2022 20:34:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206KYvp4023476 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 15:34:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 19882C202CB; Thu,  6 Jan 2022 20:34:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1530EC07F43
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 20:34:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE84C108C1C8
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 20:34:56 +0000 (UTC)
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de
	[81.169.146.161]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-475--zyEkwvpOxixHdcQXQlZIg-1; Thu, 06 Jan 2022 15:34:54 -0500
X-MC-Unique: -zyEkwvpOxixHdcQXQlZIg-1
X-RZG-AUTH: ":PHkGeUmrW+uCZmxs998QJRUX30nOwJd7nOD9sw/xoauycprg5uef7cgCEpy7sPc="
X-RZG-CLASS-ID: mo00
Received: from USER-PC.fritz.box by smtp.strato.de (RZmta 47.37.6 DYNA|AUTH)
	with ESMTPSA id k3f463y06KYl05e
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
	(Client did not present a certificate);
	Thu, 6 Jan 2022 21:34:47 +0100 (CET)
From: Thore Sommer <public@thson.de>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Thu,  6 Jan 2022 21:34:33 +0100
Message-Id: <20220106203436.281629-1-public@thson.de>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, linux-integrity@vger.kernel.org,
	Thore Sommer <public@thson.de>
Subject: [dm-devel] [RFC PATCH 0/3] dm ima: allow targets to remeasure their
	state
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The current DM IMA events do not cover the case where a device changes
their attributes to indicate a state change. This adds a new event 
(dm_target_update) which allows targets to remeasure their table entries.
The event includes the dm version, device metadata and the target data.

Currently only verity supports this event to ensure that device corruption
can be detected using IMA which is useful for remote attestation.

The current implementation does not update the active table hash because
it would require to rehash the entire table on every target change.

Thore Sommer (3):
  dm ima: allow targets to remeasure their table entry
  dm verity: add support for IMA target update event
  dm ima: add documentation target update event

 .../admin-guide/device-mapper/dm-ima.rst      | 33 ++++++++
 drivers/md/dm-ima.c                           | 76 +++++++++++++++++++
 drivers/md/dm-ima.h                           |  2 +
 drivers/md/dm-verity-target.c                 |  6 ++
 4 files changed, 117 insertions(+)

-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

