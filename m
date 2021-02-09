Return-Path: <SRS0=bAPj=HL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A664C433DB
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:19:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7D9DE64EAC
	for <dm-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:19:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D9DE64EAC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612847983;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QPXqzKYAV2DF+rrzP7aT67oNX/3ow0Zm3vzjSJCdwIs=;
	b=W8FCoeCElyfxoNTNf3pCb1DQJKw4/BRzdseYjrybOrvhlNxIIicDGFraro44rVrChmHojG
	e7mCG+cW6J3SDKB4uYQe994nkNTmTfctNB0FPCFRHl03B66GXUphCOT5orDRAVwc7q7XBU
	WmVuI7roODOF7+8HSvY6HgRqHYfTDik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-DVciGVOOMOSMQqk7VNaYnw-1; Tue, 09 Feb 2021 00:19:40 -0500
X-MC-Unique: DVciGVOOMOSMQqk7VNaYnw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5D2F80402C;
	Tue,  9 Feb 2021 05:19:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97B8310016F6;
	Tue,  9 Feb 2021 05:19:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 28A904E58E;
	Tue,  9 Feb 2021 05:19:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1195JWFF029768 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 9 Feb 2021 00:19:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C85D519D9C; Tue,  9 Feb 2021 05:19:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D851219C71;
	Tue,  9 Feb 2021 05:19:29 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1195JSHI008851; 
	Mon, 8 Feb 2021 23:19:28 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1195JRnv008850;
	Mon, 8 Feb 2021 23:19:27 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Mon,  8 Feb 2021 23:19:25 -0600
Message-Id: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Chongyun Wu <wucy11@chinatelecom.cn>, Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH 0/2] Handle remapped LUNs better
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset adds a new config option, recheck_wwid_time, to help deal
with devices getting remapped. It's based on Chongyun's patch, but
instead of always checking if the LUN is remapped, users can set how
many seconds the LUN must be down before it gets rechecked, or disable
this checking entirely, since it is simply there to keep users from
shooting themselves in the foot.  Setting the value to 0 makes this
always recheck when a path is restored.

Unlike Chongyun's patch, it doesn't issue a remove uevent. I'm not
actually sure what the purpose of the remove uevent was, since it
doesn't cause the path to be removed, and multipath already removed it.
Instead, it works like Martin's uev_update_path code, and re-adds the
path after it removes it.  There is one issue I noticed here.  While
udev will update the WWID in the database when it gets a new uevent,
sysfs will still record the original WWID, so if multipathd ever fails
back to using sysfs for the WWID, it will see the wrong value.

Another possible check that I didn't include is this patchset is to have
multipath look at the LUN number whenever it adds a new path to a
multipath device. If the LUN number doesn't match the existing LUN
numbers, all the old paths should have their wwids checked as soon as
possible (immediately, if the path is up), since mismatching LUN numbers
is a red flag that something has gone wrong.

Benjamin Marzinski (2):
  libmultipath: fix use-after-free in uev_add_path
  multipathd: add recheck_wwid_time option to verify the path wwid

 libmultipath/config.c             |   1 +
 libmultipath/config.h             |   1 +
 libmultipath/configure.c          |   4 +-
 libmultipath/configure.h          |   2 +
 libmultipath/defaults.h           |   1 +
 libmultipath/dict.c               |  36 ++++++++++
 libmultipath/libmultipath.version |   6 ++
 libmultipath/structs.h            |  10 +++
 multipath/multipath.conf.5        |  18 +++++
 multipathd/cli_handlers.c         |   9 +++
 multipathd/main.c                 | 107 +++++++++++++++++++++++++++---
 multipathd/main.h                 |   2 +
 12 files changed, 187 insertions(+), 10 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

