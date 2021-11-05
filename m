Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7212CC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 20:49:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1D19760E94
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 20:49:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1D19760E94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636145382;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=COBt/7CJK2G3AhHWQH1ycuKxwVeqrpJxeDMn5nczHn0=;
	b=bdodjYeQEQu08U2IwSyD4a5r7pP4ENgrx0TFUQ2yISzrDmRx4LxbZytkiLjlifopNXqzvC
	5U4tCAD+qpxrqOX7FRmOY+pbPNPP0zxAM2QLPY84F5AR/ZFyFmgm2dU/BrsxICcLRhy5ya
	3H39cyRONQhHES0/kaqg2xgzNcDk00k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-xkBsuPCNP-KUek20Lv3qRg-1; Fri, 05 Nov 2021 16:49:39 -0400
X-MC-Unique: xkBsuPCNP-KUek20Lv3qRg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72E3C80A5CC;
	Fri,  5 Nov 2021 20:49:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C83CB2A60;
	Fri,  5 Nov 2021 20:49:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7DA331806D03;
	Fri,  5 Nov 2021 20:49:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5KnWe1023807 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 16:49:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B2331101E693; Fri,  5 Nov 2021 20:49:32 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDD8710016F5;
	Fri,  5 Nov 2021 20:49:28 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1A5KnQQh012553; 
	Fri, 5 Nov 2021 15:49:26 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1A5KnPXV012552;
	Fri, 5 Nov 2021 15:49:25 -0500
Date: Fri, 5 Nov 2021 15:49:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211105204925.GM19591@octiron.msp.redhat.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<340a1d0da9921f1d7f334395b4986be904a2517e.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <340a1d0da9921f1d7f334395b4986be904a2517e.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/7] multipathd: remove udev settle dependency
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
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 04, 2021 at 10:00:11PM +0000, Martin Wilck wrote:
> On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> > So, it turns out that commit 4ef67017 "libmultipath: add
> > update_pathvec_from_dm()" already does most of the hard work of making
> > multipath handle the uninitialized paths that exist during boot, after
> > the switch root, but before the all the coldplug uevents have been
> > processed. The only problem is that this code leaves the paths in a
> > partially initialized state, which doesn't completely get corrected
> > until
> > a reconfigure happens.=20
> >=20
> > This patchset makes multipath track these partially initailized paths,
> > and makes sure that they get fully initialized, or removed, as
> > necessary.
> >=20
> > The first patch is a tangentially related bug I found when trying
> > (unsuccessfully) to recreate multipathd's problem with dropping
> > uninitialized paths. Multipathd was not removing completely missing
> > paths from maps that it found while starting up. The solution I chose
> > was just to make sure that a full reload will happen on these maps,
> > even
> > if a weak reconfigure was requested. However, this means that multipath
> > still completely ignores these missing paths. A side effect of this is
> > that "multipath -l" does not show these paths, even though they exist
> > as
> > part of the multipath table. The full reloads are necessary, to take
> > care of issues that update_pathvec_from_dm() can run into, but we might
> > also want to think about marking these missing paths as INIT_REMOVED,
> > instead of not adding them at all. This would make "multipath -l" still
> > show them, until they actually get removed from the table.
>=20
> Yes, that might be a good thing. Completely missing paths (not existing
> in sysfs) in a map represent a dangerous condition; it would be good if
> multipath -l was able to tell the user about it.

Sure, but I can do that as a separate patch?
=20
> >=20
> > Patch 0005 makes sure to fully initialize the paths when their coldplug
> > event occurs, but if the path is already fully initialized in udev, but
> > multipathd finds out about it from update_pathvec_from_dm(), multipath
> > doesn't do anything to finish initializing the path and moving it to
> > INIT_OK, besides waiting for a uevent or a reconfigure. This is
> > probably
> > fine, since the only way I can see for a path to be in this state is
> > for
> > someone to manually remove the path from multipathd monitoring. But if
> > I'm missing some other way that paths could end up in this state, we
> > could try proactively finishing the initalization of INIT_PARTIAL paths
> > that have all their udev information.
>=20
> One option would be to try finishing the initialization in the path
> checker.

Yep. Something like that is what I was thinking.  But I'm still trying
to come up with a way that paths could get into this state without
someone running something like:

# multipathd del path sda
# mutipath

And I'm not sure how much code we want to add just to handle something
contrived like this.

> What about the checker, in general?  Should we take some care that
> partially initialized paths aren't mistakenly set as failed? I'm not
> sure if libudev is able to return a proper fd from
> udev_device_get_devnode() if the device isn't yet initialized in the
> udev db. Without a proper fd, the checker is doomed to fail. And other
> failure modes are possible too without proper udev initialization, I
> suppose?
>=20

Since this is a case where the device nodes do exist, since they were
already made into multipath devices, I didn't run into any problems with
checking INIT_PARTIAL paths.

-Ben

> >=20
> > I'm also kind of on the fence about patch 0006. There is no reason
> > why
> > we have to remove INIT_PARTIAL paths if the multipath device goes
> > away.
> > But if a path is in INIT_PARTIAL for long enough that the multipath
> > device gets removed, then it's likely not a path we want to be
> > monitoring, and if a uevent occurs, we'll add it back, anyway. Also,
> > knowing that INIT_PARTIAL paths are always part of multipath devices
> > does make the code simpler.
> >=20
> > I've tested these patches both by rebooting with necessary and
> > unnecessary multipath devices in the initramfs and multipathd.service
> > set to make multipathd start up at various points after the switch
> > root,
> > and by manually sending remove uevents to unintialize some paths, and
> > then starting multipathd to test specific combinations of path
> > states.
> > But more testing is always welcome.
>=20
> I'll try to give this code a test shortly.
>=20
> Cheers,
> Martin
>=20
>=20
> >=20
> > Benjamin Marzinski (7):
> > =A0 multipathd: remove missing paths on startup
> > =A0 libmultipath: skip unneeded steps to get path name
> > =A0 libmultipath: don't use fallback wwid in update_pathvec_from_dm
> > =A0 libmultipath: always set INIT_REMOVED in set_path_removed
> > =A0 multipathd: fully initialize paths added by update_pathvec_from_dm
> > =A0 multipathd: remove INIT_PARTIAL paths that aren't in a multipath
> > =A0=A0=A0 device
> > =A0 multipathd: Remove dependency on systemd-udev-settle.service
> >=20
> > =A0libmultipath/configure.c=A0=A0=A0=A0=A0 |=A0 2 ++
> > =A0libmultipath/devmapper.c=A0=A0=A0=A0=A0 |=A0 2 ++
> > =A0libmultipath/discovery.c=A0=A0=A0=A0=A0 |=A0 7 ++---
> > =A0libmultipath/discovery.h=A0=A0=A0=A0=A0 |=A0 2 ++
> > =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0 |=A0 7 +++++
> > =A0libmultipath/structs_vec.c=A0=A0=A0 | 40 ++++++++++++++++-----------=
--
> > =A0multipathd/cli_handlers.c=A0=A0=A0=A0 |=A0 4 +++
> > =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 48 +++++++++=
+++++++++++++++++++++++-
> > --
> > =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> > =A0multipathd/multipathd.service |=A0 3 +--
> > =A010 files changed, 90 insertions(+), 26 deletions(-)
> >=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

