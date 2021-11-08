Return-Path: <SRS0=u3eZ=P3=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31CDCC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 16:30:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D8AD9613B3
	for <dm-devel@archiver.kernel.org>; Mon,  8 Nov 2021 16:30:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D8AD9613B3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636389027;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QKaaZtMtRGMmoAKeHHOZUCDuFTfsrT7JVRQ7xEXpvXA=;
	b=dtAy2EqKXA0SbxQLvfkEnG41YXz0+cKv1azB2UjwjTc1CRTwVtGiDZnXSwqO6hDTt5z6Hg
	cPsATWT/fEIWWUDL8sq+ZzB0H3nj9waN+A4Yb8ky6iGUQOh3giZXR0WTWCOiClNFJKAmmb
	dI6mN+arfYG+g1eH19BXAOimV6e9qu4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-6yAHe00XOFqHKluoRv4DMQ-1; Mon, 08 Nov 2021 11:30:26 -0500
X-MC-Unique: 6yAHe00XOFqHKluoRv4DMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C8231842165;
	Mon,  8 Nov 2021 16:30:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFE9677C15;
	Mon,  8 Nov 2021 16:30:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 66F7D4E9F5;
	Mon,  8 Nov 2021 16:30:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
	[10.5.11.22])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A8GUBDX003864 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Nov 2021 11:30:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 92B831042AAF; Mon,  8 Nov 2021 16:30:11 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67B71100239F;
	Mon,  8 Nov 2021 16:29:58 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1A8GTuPN030540; 
	Mon, 8 Nov 2021 10:29:56 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1A8GTti1030539;
	Mon, 8 Nov 2021 10:29:55 -0600
Date: Mon, 8 Nov 2021 10:29:55 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211108162955.GR19591@octiron.msp.redhat.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-6-git-send-email-bmarzins@redhat.com>
	<2a319ae1e5eba66db17ab6372c95ac81f75a92e2.camel@suse.com>
	<33b4e4f8942ab340b4fba39e91c3d10e9c6aa402.camel@suse.com>
	<20211105214936.GO19591@octiron.msp.redhat.com>
	<c137193a6dbc7ea9ce25d06766874012de2f8ed0.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <c137193a6dbc7ea9ce25d06766874012de2f8ed0.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/7] multipathd: fully initialize paths added
 by update_pathvec_from_dm
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 05, 2021 at 11:20:01PM +0000, Martin Wilck wrote:
> On Fri, 2021-11-05 at 16:49 -0500, Benjamin Marzinski wrote:
> > On Fri, Nov 05, 2021 at 10:55:11AM +0000, Martin Wilck wrote:
> > > Hi Ben,
> > >=20
> > > On Thu, 2021-11-04 at 23:10 +0100, Martin Wilck wrote:
> > > > On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> > > > > ...
> > > >=20
> > > > >=20
> > > > > Multipath now has a new state to deal with these devices,
> > > > > INIT_PARTIAL.
> > > > > Devices in this state are treated mostly like INIT_OK devices,
> > > > > but
> > > > > when "multipathd add path" is called or an add/change uevent
> > > > > happens
> > > > > on these devices, multipathd will finish initializing them, and
> > > > > remove
> > > > > them if necessary.
> > > > >=20
> > > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > >=20
> > > > Nice. Somehow in my mind the issue always look much more complex.
> > > > I like this, but I want to give it some testing before I finally
> > > > ack
> > > > it.
> > >=20
> > > I noted that running "multipathd add path $path" for a path in
> > > INIT_PARTIAL state changes this paths's init state to INIT_OK, even
> > > if
> > > the udev still has no information about it (*).
> >=20
> > Ah. Didn't think about that.
> > =A0
> > > The reason is that pp->wwid is set, and thus pathinfo() won't even
> > > try
> > > to retrieve the WWID, although for INIT_PARTIAL paths the origin of
> > > the
> > > WWID is not 100% trustworthy (being just copied from pp->mpp-
> > > > wwid).=A0pathinfo() will return PATHINFO_OK without having retrieve=
d
> > > > the
> > > WWID.=A0
> > >=20
> > > I suppose we could apply a similar logic as in uev_update_path()
> > > here,
> > > clearing pp->wwid before calling pathinfo().=A0If udev was still
> > > unaware
> > > of the path, this would mean a transition from INIT_PARTIAL to
> > > INIT_MISSING_UDEV. OTOH, we'd now need to be prepared to have to
> > > remove
> > > the path from the map if the WWID doesn't match after the call to
> > > pathinfo(). This means we'd basically need to reimplement the
> > > "changed
> > > WWID" logic from uev_update_path(), and thus we'd need to unify both
> > > code paths.
> > >=20
> > > In general, the difference between INIT_MISSING_UDEV and INIT_PARTIAL
> > > is subtle.=A0Correct me if I'm wrong, but INIT_PARTIAL means "udev ha=
s
> > > no
> > > information about this device" and INIT_MISSING_UDEV currently means
> > > "we weren't able to figure out a WWID for the path" (meaning that
> > > INIT_MISSING_UDEV is a misnomer - when fallback are allowed,
> > > INIT_MISSING_UDEV is actually independent of the device's state in
> > > the
> > > udev db. We should rename this to INIT_MISSING_WWID, perhaps).
> >=20
> > Yeah. makes sense.
> >=20
> > > The
> > > semantics of the two states are very different though:
> > > INIT_MISSING_UDEV will trigger an attempt to regenerate an uevent,
> > > whereas INIT_PARTIAL will just stick passively. IMO it'd make sense
> > > to
> > > trigger an uevent in the INIT_PARTIAL case, too, albeit perhaps not
> > > immediately (after the default uevent timeout - 180s?).=20
> >=20
> > Sure. We do want to wait long enough to be fairly sure that udev isn't
> > just being a little bit slow.
> >=20
> > This would also handle the case where multipathd simply wasn't
> > tracking the path for some reason. If the device doesn't exist in the
> > udev database at all, do with send an "add" event instead of a "change"
> > event?
>=20
> I don't think it matters. If no database file exists, udev can still
> deliver some information:
>=20
> # udevadm info /dev/sde
> P: /devices/pci0000:00/0000:00:01.0/0000:01:00.7/host3/rport-3:0-
> 0/target3:0:0/3:0:0:4/block/sde
> N: sde
> L: 0
> E: DEVPATH=3D/devices/pci0000:00/0000:00:01.0/0000:01:00.7/host3/rport-
> 3:0-0/target3:0:0/3:0:0:4/block/sde
> E: DEVNAME=3D/dev/sde
> E: DEVTYPE=3Ddisk
> E: MAJOR=3D8
> E: MINOR=3D64
> E: SUBSYSTEM=3Dblock
>=20
> (note USEC_INITIALIZED is not in the set)
>=20
> If I run "udevadm trigger -c change /dev/sde" in this situation, I'll
> get the full info, as if I had run "add" before (some rules may differ
> between "add" and "change", but that's quite unusual).
>

udev rules may not change much, but, for instance, multipathd reacts
differently to add and change events.  So there may be other consumers
of uevents that care about the difference between add and change events.
=20
> >=20
> > > Also, we currently don't track the udev state of=A0devices cleanly.
> > > We
> > > set INIT_MISSING_UDEV if we can't obtain uid_attribute, which
> > > doesn't
> > > necessarily mean that udev is unaware of the device. I believe we
> > > should e.g. check the USEC_INITIALIZED property - it is non-NULL if
> > > and
> > > only if the device is present in the udev db. If uid_attribute
> > > isn't
> > > set regardless, we could conclude that the udev rules just don't
> > > set
> > > it. It might make sense to retrigger *one* uevent in that case, but
> > > no
> > > more.
> >=20
> > IIRC, the initial reason why INIT_MISSING_UDEV was added was because
> > sometimes udev workers timed out, causing them to not run all the
> > rules.
> > Do you know offhand if USEC_INITIALIZED is set in this case? If we
> > could
> > differentiate between the following states:
>=20
> udevd sets this property very early, when it first receives an uevent.
> But libudev calls won't return it until the database file is written,
> which happens last, after all rules and RUN statements have been
> processed, _in the worker_. Thus if the worker is killed, the file
> won't be written.
>=20
>=20
> 0. the device doesn't exist in sysfs=20

We simply delete devices that don't exist in sysfs, right? If we get a
non-remove uevent for a device, but it doesn't exist in sysfs, then I
would assume that a remove uevent will be shortly incomming.
=20
> > 1: udev hasn't gotten an event for a device
>=20
> I don't think we can detect this without listening for kernel uevents.
> And even if we listen to them, we could have missed some. udevd doesn't
> have an API for it, either, AFAIK.

Isn't this the most common INIT_PARTIAL case, where we are waiting for
the coldplug uevent? If there is no database file when we are processing
the device, we are in this state. Correct?=20

> > 2: udev got an event but timed out or failed while processing it
>=20
> This would be the USEC_INITIALIZED case, IMO

If udev has, in the past, successfully processed an event for a device,
but fails while processing a later uevent, it doesn't keep th data from
the previous event. So it could lose the uid_attribute. But the
database file should still exist. Correct?


-Ben

> > 3: udev successfully processed the event for the device, but
> > multipath
> > =A0=A0 isn't seeing the attributes it was expecting.
> >=20
> > We could react more sensibly.
>=20
> Yes.
>=20
> Regards
> Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

