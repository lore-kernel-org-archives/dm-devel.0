Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F4BEC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:33:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7349964ED0
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:33:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7349964ED0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1614148424;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=/ku4Wd+7RcIi/M29G+EGJFkoA+Ec4ox5i+Ow88bgzkk=;
	b=B1+tmaEEKFVqa4FJje1URFhx7pRGvcgQ3WzOxs44//kjpEva6MAouz0A5ULSyVJg4E2LrS
	0bxh27fVNA7CdVdPSKUxhLlRIgy4ZOl8UlrUGuyuUBKptQ1u8OreYUs6C62RtOOWvcfWK1
	S1x/Wj93Bv0UkaYX9cyn1MKHFJ26plk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-284-G_4zT0mBPUGIrI76esim2g-1; Wed, 24 Feb 2021 01:33:41 -0500
X-MC-Unique: G_4zT0mBPUGIrI76esim2g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D371195D564;
	Wed, 24 Feb 2021 06:33:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 794011001281;
	Wed, 24 Feb 2021 06:33:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 470C08E03;
	Wed, 24 Feb 2021 06:33:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O6XWql029046 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 24 Feb 2021 01:33:32 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2ABC71001281; Wed, 24 Feb 2021 06:33:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AE6C10016DB;
	Wed, 24 Feb 2021 06:33:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 11O6XQBa019885; 
	Wed, 24 Feb 2021 00:33:27 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 11O6XMhn019884;
	Wed, 24 Feb 2021 00:33:22 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 24 Feb 2021 00:33:19 -0600
Message-Id: <1614148402-19847-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Chongyun Wu <wucy11@chinatelecom.cn>, Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 0/3] Handle remapped LUNs better
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patchset adds a new config option, recheck_wwid, to help deal with
devices getting remapped. It's based on Chongyun's patch. Unlike
Chongyun's patch, it doesn't issue a remove uevent. I'm not actually
sure what the purpose of the remove uevent was, since it doesn't cause
the path to be removed, and multipath already removed it.  Instead, it
works like Martin's uev_update_path code, and re-adds the path after it
removes it.  There is one issue I noticed here.  While udev will update
the WWID in the database when it gets a new uevent, sysfs will still
record the original WWID. To deal with this, the code also triggers a
rescan of the device.

Changes from v1:
  0001: New patch to cleanup trailing whitespace stripping, as suggested
	by Martin
  0002: New patch to simplify the uid_attribute checking code
  0003: Numerous changes based on Martin's review.
	- The option is now simply on or off instead of having a time
	  limit, since the overhead of checking the vpd page isn't too
	  high.
	- The option can now be set in the devices section as well.
	- handle_path_wwid_change() consistently uses a constant for
	  the strings.
	- handle_path_wwid_change() grabs a reference to the udev device
	  and then removes the path first, before triggering the uevent.
	- handle_path_wwid_change() and uev_update_path() now trigger a
	  rescan of the path device, when the wwid has changed, to
	  update the sysfs info.
	- the code now determines if it is safe to recheck the wwid the
	  same way it does for the uid fallback code.
	- When I was retesting I couldn't trigger add uevents on paths
	  being remapped.  I suspect I never could, and was accidentally
	  looking at the add uevents for the new LUN that was mapped
	  to the old LUN id, instead of seeing add event when the old
	  LUN was remapped to a new LUN id. This means that the
	  uev_add_path() code is unnecessary, as Martin suspected. It's
	  been removed.

Benjamin Marzinski (3):
  libmultipath: cleanup code to strip wwid trailing spaces
  libmultipath: cleanup uid_attribute checking code
  multipathd: add recheck_wwid option to verify the path wwid

 libmultipath/config.c             |  2 +
 libmultipath/config.h             |  2 +
 libmultipath/configure.c          |  4 +-
 libmultipath/configure.h          |  2 +
 libmultipath/defaults.h           |  1 +
 libmultipath/dict.c               | 11 +++++
 libmultipath/discovery.c          | 35 +++++++-------
 libmultipath/discovery.h          |  1 +
 libmultipath/libmultipath.version |  6 +++
 libmultipath/propsel.c            | 21 +++++++++
 libmultipath/propsel.h            |  1 +
 libmultipath/structs.h            |  7 +++
 multipath/multipath.conf.5        | 14 ++++++
 multipathd/cli_handlers.c         |  9 ++++
 multipathd/main.c                 | 78 +++++++++++++++++++++++++++++++
 multipathd/main.h                 |  2 +
 16 files changed, 176 insertions(+), 20 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

