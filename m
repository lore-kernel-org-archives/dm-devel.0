Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3ACBC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 03:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642476477;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=0fmkcsQDNTZx8Ep+RjWZIv10T5iU4CX5s27kbeR1LvA=;
	b=QGyY6jsnLEXnfnJEQZ5BaKKVR81dlb6eKDH7/awstGuy+EbJPOpyxPx+gkKBRzkxcwaGgM
	LPKmQs+/plK1bqeeXSdEvtWtDG8wvkNg98CXF6D9qnGlMS1l6bsDx1Vp9BPre0cIWj/2lO
	e7ZrK91ri8R2Up2iNHHgUb9IBpxa1ZM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-252-Kkp8CN9yNb6fwW2dJT3gfA-1; Mon, 17 Jan 2022 22:27:54 -0500
X-MC-Unique: Kkp8CN9yNb6fwW2dJT3gfA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 822E41083F67;
	Tue, 18 Jan 2022 03:27:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 65E326ABA1;
	Tue, 18 Jan 2022 03:27:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C2E0F1809CB8;
	Tue, 18 Jan 2022 03:27:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I3Rj9n028832 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 17 Jan 2022 22:27:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C9C405E27A; Tue, 18 Jan 2022 03:27:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CB535E275;
	Tue, 18 Jan 2022 03:27:36 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 20I3RY4B006012; 
	Mon, 17 Jan 2022 21:27:34 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 20I3RXWh006011;
	Mon, 17 Jan 2022 21:27:33 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon, 17 Jan 2022 21:27:30 -0600
Message-Id: <1642476453-5974-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 0/3] Misc Multipath fixes
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

This patchset fixes two issues. First is that disassemble_status()
was failing for the historical-service-time path selector, because it
uses pathgroup status arguments, which were not handled correctly.
Second is an issue with multipath not claiming paths that are added to
multipath devices in a window right after the WWID has been added to
the WWIDs file, if multipath is using a find_multipaths setting that
relies on the wwid being in the WWIDs file (all settings but greedy
or smart).

Benjamin Marzinski (3):
  libmultipath: fix disassemble status for historical-service-time PS
  libmultipath: make helper function to trigger path uevents
  multipathd: trigger udev change on path addition

 libmultipath/configure.c          | 79 ++++++++++++++++---------------
 libmultipath/configure.h          |  1 +
 libmultipath/dmparser.c           | 14 +++++-
 libmultipath/libmultipath.version |  1 +
 multipathd/main.c                 |  2 +
 5 files changed, 58 insertions(+), 39 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

