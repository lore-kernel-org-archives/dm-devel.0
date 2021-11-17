Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4F7C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 46785619BB
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 21:21:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 46785619BB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637184101;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xx+s6Z5VUayiwfn+3aqSBVpCDsVBPXITV11kXWnhqxU=;
	b=C/JuT75DPio/x72RdQRXTLvnHyumqYKT1XHs+x7xIkT+MvV889NcXOGGkZ/bCgUmbD8FZK
	U5pU8BVkCPRQ5LpDN3nyY8t77RlfjWbavCy4mJOLSDK5eTlPoy2Fau8lrjHrZ2Vdo6wR1K
	Kk+jIKqr9flFzm4l5mNNkhbg/2uimN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-FkY2R3O3O_Oic110AzpWag-1; Wed, 17 Nov 2021 16:21:38 -0500
X-MC-Unique: FkY2R3O3O_Oic110AzpWag-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61488106B804;
	Wed, 17 Nov 2021 21:21:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 002625F4EF;
	Wed, 17 Nov 2021 21:21:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 31273180BAD2;
	Wed, 17 Nov 2021 21:21:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHLLUTf025228 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 16:21:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3C2883AEF; Wed, 17 Nov 2021 21:21:30 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A83D26370;
	Wed, 17 Nov 2021 21:21:27 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1AHLLPKC004919; 
	Wed, 17 Nov 2021 15:21:25 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1AHLLPoS004918;
	Wed, 17 Nov 2021 15:21:25 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Wed, 17 Nov 2021 15:21:15 -0600
Message-Id: <1637184084-4882-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
Subject: [dm-devel] [PATCH v2 0/9] multipathd: remove udev settle dependency
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

So, it turns out that commit 4ef67017 "libmultipath: add
update_pathvec_from_dm()" already does most of the hard work of making
multipath handle the uninitialized paths that exist during boot, after
the switch root, but before the all the coldplug uevents have been
processed. The only problem is that this code leaves the paths in a
partially initialized state, which doesn't completely get corrected
until a reconfigure happens.

This patchset makes multipath track these partially initailized paths,
and makes sure that they get fully initialized, or removed, as
necessary.

The first patch is a tangentially related bug I found when trying
(unsuccessfully) to recreate multipathd's problem with dropping
uninitialized paths. Multipathd was not removing completely missing
paths from maps that it found while starting up. The solution I chose
was just to make sure that a full reload will happen on these maps, even
if a weak reconfigure was requested. However, this means that multipath
still completely ignores these missing paths. A side effect of this is
that "multipath -l" does not show these paths, even though they exist as
part of the multipath table. The full reloads are necessary, to take
care of issues that update_pathvec_from_dm() can run into, but we might
also want to think about marking these missing paths as INIT_REMOVED,
instead of not adding them at all. This would make "multipath -l" still
show them, until they actually get removed from the table.

Patch 0005 makes sure to fully initialize the paths when their coldplug
event occurs, but if the path is already fully initialized in udev, but
multipathd finds out about it from update_pathvec_from_dm(), multipath
doesn't do anything to finish initializing the path and moving it to
INIT_OK, besides waiting for a uevent or a reconfigure. Patch 0006
handles this by triggering a uevent if the path has been in partial
for more than 3 minutes.

I've tested these patches both by rebooting with necessary and
unnecessary multipath devices in the initramfs and multipathd.service
set to make multipathd start up at various points after the switch root,
and by manually sending remove uevents to unintialize some paths, and
then starting multipathd to test specific combinations of path states.
But more testing is always welcome.

Notes on v2:

After playing around with the initialization states a bit, I decided
that cleaning them up is a bigger task than I want to do in this
patchset. This set just concentrates on cleaning up our handling of
paths that get added in update_pathvec_from_dm() to allow us to
drop the systemd-udev-settle dependency.

Changes from v1, base on suggestions by Martin Wilck.

0005: Made cli_add_path() verify the wwid can be gotten, and hasn't
changed, before attempting to finish initalizing the path. Also don't
intialize a path that relies on udev if the udev device isn't
initalized.

0006: New patch. If a patch is in INIT_PARTIAL for over 3 minutes,
trigger a uevent on it.  This is kind of a long waiting period, but I
want to avoid firing off another uevent in cases where the problem is
that udev is in the middle of a uevent storm, and the expected event
is delayed.

0009: Repost of Martin's new init state wildcard patch

Benjamin Marzinski (8):
  multipathd: remove missing paths on startup
  libmultipath: skip unneeded steps to get path name
  libmultipath: don't use fallback wwid in update_pathvec_from_dm
  libmultipath: always set INIT_REMOVED in set_path_removed
  multipathd: fully initialize paths added by update_pathvec_from_dm
  multipathd: retrigger uevent for partial paths
  multipathd: remove INIT_PARTIAL paths that aren't in a multipath
    device
  multipathd: Remove dependency on systemd-udev-settle.service

Martin Wilck (1):
  libmultipath: add path wildcard "%I" for init state

 libmultipath/configure.c          |  2 +
 libmultipath/devmapper.c          |  2 +
 libmultipath/discovery.c          |  7 +--
 libmultipath/discovery.h          |  2 +
 libmultipath/libmultipath.version |  2 +-
 libmultipath/print.c              | 21 +++++++++
 libmultipath/structs.h            |  9 ++++
 libmultipath/structs_vec.c        | 41 ++++++++++--------
 multipathd/cli_handlers.c         | 35 ++++++++++++++-
 multipathd/main.c                 | 71 +++++++++++++++++++++++++++++--
 multipathd/main.h                 |  1 +
 multipathd/multipathd.service     |  3 +-
 12 files changed, 167 insertions(+), 29 deletions(-)

-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

