Return-Path: <SRS0=AZSO=II=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC929C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 21:15:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5791B64FCA
	for <dm-devel@archiver.kernel.org>; Wed, 10 Mar 2021 21:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5791B64FCA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1615410936;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=4nG3i+qbPI+1nRsC+51J0EJXJ6Akt8SZwiC0Bexwb34=;
	b=RUbjEkIfI18jQMyhTDeIwLKwCp1g2VXXxRV0OMFXBnhQOVfOZ4FTC8T/2MRk5F2C9fytN+
	ebw69OzpmI15DC4Wgb9SLIYs4yQqHcWj4UxVMbjccWfAYs7Tyd/pPZBmNLUWoQr3JpV0yp
	ag0J4fWDlPUG6AC6IId0xIKyEbCRggY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-RdBEn83zMR2SoV-SN0GwXQ-1; Wed, 10 Mar 2021 16:15:34 -0500
X-MC-Unique: RdBEn83zMR2SoV-SN0GwXQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B5D0192CC45;
	Wed, 10 Mar 2021 21:15:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A7AB60DAE;
	Wed, 10 Mar 2021 21:15:27 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8C2F81809C86;
	Wed, 10 Mar 2021 21:15:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12ALFOOL016627 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Mar 2021 16:15:24 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 15E1A60C6E; Wed, 10 Mar 2021 21:15:24 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 199D260C13;
	Wed, 10 Mar 2021 21:15:17 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 12ALFFoL012593; 
	Wed, 10 Mar 2021 15:15:15 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 12ALFFcb012592;
	Wed, 10 Mar 2021 15:15:15 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 10 Mar 2021 15:15:13 -0600
Message-Id: <1615410915-12555-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 0/2] libmutipath: only give out free
	user_friendly_names
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset fixes a bug that we're run into on installation. Right
now, multipath doesn't ever check that the user_friendly_name it
selected is actually not in-use.  Normally, this is fine, since it won't
pick a name without first adding it to the bindings file.  However, if
the device was created in the initramfs, the bindings file in the
regular filesystem won't be updated until multipathd processes those
paths when starting up after the switchroot. If new path devices are
discovered when multipath starts up after the switchroot, they could be
processed first, and pick the already in use user_friendly_name. In this
case multipath will fail back to using the WWID for the new device, and
renaming the old device.  Later, if multipathd is reconfigured, the new
device will get renamed to the previously in-use user_friendly_name it
added to the bindings file.  All this renaming of devices is messing
with the installer.

To deal with this, this patchset checks that the selected alias is not
in use by an existing dm device, before writing it to the bindings file.
If it is, multipath just steps through the free aliases in the bindings
file, checking until it finds a one that's not in use. I've updated the
lookup_binding() tests to test this functionality as well.

Benjamin Marzinski (2):
  libmultipath: check if user_friendly_name is in use
  tests: add tests for checking if alias is in use

 libmultipath/alias.c |  48 ++++-
 tests/alias.c        | 427 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 459 insertions(+), 16 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

