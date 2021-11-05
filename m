Return-Path: <SRS0=mjIs=PY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4356BC433F5
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 21:49:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E14C261165
	for <dm-devel@archiver.kernel.org>; Fri,  5 Nov 2021 21:49:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E14C261165
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1636148995;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nTJKgjuxWLpfTKtQO035SCc8HykgDIK6wdCvnJIX1XQ=;
	b=Q4SNMYTdLEnjMy+XgxUtOKyO0NTk33JRT/ifMHKmf//x6CRG7Nia3WSz7R37Z6d1Tr0Sj0
	up6gkaSDMaswQSBs+WMIp5oV3PSiCWNRvB5AyL6rrHKO5h2kAHQ8kABOf1i+jsbJe6ZJkh
	NT+ePnrwIkcSMmQ1Tfofh/+kyVRC34s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-Sr1oeECiMUuRwhIA_tNQzA-1; Fri, 05 Nov 2021 17:49:51 -0400
X-MC-Unique: Sr1oeECiMUuRwhIA_tNQzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8842C1923761;
	Fri,  5 Nov 2021 21:49:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D541B5D740;
	Fri,  5 Nov 2021 21:49:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D84984A703;
	Fri,  5 Nov 2021 21:49:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
	[10.5.11.14])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A5LnioC028565 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 5 Nov 2021 17:49:44 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 955845DA60; Fri,  5 Nov 2021 21:49:44 +0000 (UTC)
Received: from octiron.msp.redhat.com (unknown [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D101D5D9DE;
	Fri,  5 Nov 2021 21:49:39 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 1A5LnbNl012812; 
	Fri, 5 Nov 2021 16:49:37 -0500
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 1A5LnaMi012811;
	Fri, 5 Nov 2021 16:49:36 -0500
Date: Fri, 5 Nov 2021 16:49:36 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Message-ID: <20211105214936.GO19591@octiron.msp.redhat.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-6-git-send-email-bmarzins@redhat.com>
	<2a319ae1e5eba66db17ab6372c95ac81f75a92e2.camel@suse.com>
	<33b4e4f8942ab340b4fba39e91c3d10e9c6aa402.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <33b4e4f8942ab340b4fba39e91c3d10e9c6aa402.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 05, 2021 at 10:55:11AM +0000, Martin Wilck wrote:
> Hi Ben,
>=20
> On Thu, 2021-11-04 at 23:10 +0100, Martin Wilck wrote:
> > On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> > > ...
> >=20
> > >=20
> > > Multipath now has a new state to deal with these devices,
> > > INIT_PARTIAL.
> > > Devices in this state are treated mostly like INIT_OK devices, but
> > > when "multipathd add path" is called or an add/change uevent
> > > happens
> > > on these devices, multipathd will finish initializing them, and
> > > remove
> > > them if necessary.
> > >=20
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> >=20
> > Nice. Somehow in my mind the issue always look much more complex.
> > I like this, but I want to give it some testing before I finally ack
> > it.
>=20
> I noted that running "multipathd add path $path" for a path in
> INIT_PARTIAL state changes this paths's init state to INIT_OK, even if
> the udev still has no information about it (*).

Ah. Didn't think about that.
=20
> The reason is that pp->wwid is set, and thus pathinfo() won't even try
> to retrieve the WWID, although for INIT_PARTIAL paths the origin of the
> WWID is not 100% trustworthy (being just copied from pp->mpp-
> >wwid).=A0pathinfo() will return PATHINFO_OK without having retrieved the
> WWID.=A0
>=20
> I suppose we could apply a similar logic as in uev_update_path() here,
> clearing pp->wwid before calling pathinfo().=A0If udev was still unaware
> of the path, this would mean a transition from INIT_PARTIAL to
> INIT_MISSING_UDEV. OTOH, we'd now need to be prepared to have to remove
> the path from the map if the WWID doesn't match after the call to
> pathinfo(). This means we'd basically need to reimplement the "changed
> WWID" logic from uev_update_path(), and thus we'd need to unify both
> code paths.
>=20
> In general, the difference between INIT_MISSING_UDEV and INIT_PARTIAL
> is subtle.=A0Correct me if I'm wrong, but INIT_PARTIAL means "udev has no
> information about this device" and INIT_MISSING_UDEV currently means
> "we weren't able to figure out a WWID for the path" (meaning that
> INIT_MISSING_UDEV is a misnomer - when fallback are allowed,
> INIT_MISSING_UDEV is actually independent of the device's state in the
> udev db. We should rename this to INIT_MISSING_WWID, perhaps).

Yeah. makes sense.

> The
> semantics of the two states are very different though:
> INIT_MISSING_UDEV will trigger an attempt to regenerate an uevent,
> whereas INIT_PARTIAL will just stick passively. IMO it'd make sense to
> trigger an uevent in the INIT_PARTIAL case, too, albeit perhaps not
> immediately (after the default uevent timeout - 180s?).=20

Sure. We do want to wait long enough to be fairly sure that udev isn't
just being a little bit slow.

This would also handle the case where multipathd simply wasn't
tracking the path for some reason. If the device doesn't exist in the
udev database at all, do with send an "add" event instead of a "change"
event?

> Also, we currently don't track the udev state of=A0devices cleanly. We
> set INIT_MISSING_UDEV if we can't obtain uid_attribute, which doesn't
> necessarily mean that udev is unaware of the device. I believe we
> should e.g. check the USEC_INITIALIZED property - it is non-NULL if and
> only if the device is present in the udev db. If uid_attribute isn't
> set regardless, we could conclude that the udev rules just don't set
> it. It might make sense to retrigger *one* uevent in that case, but no
> more.

IIRC, the initial reason why INIT_MISSING_UDEV was added was because
sometimes udev workers timed out, causing them to not run all the rules.
Do you know offhand if USEC_INITIALIZED is set in this case? If we could
differentiate between the following states:

1: udev hasn't gotten an event for a device
2: udev got an event but timed out or failed while processing it
3: udev successfully processed the event for the device, but multipath
   isn't seeing the attributes it was expecting.

We could react more sensibly.

-Ben

> IMO=A0we need a clear definition of the INIT_xyz states and their
> transitions. We won't get along with intuitive logic any more.
>=20
> Cheers,
> Martin
>=20
> (*) my test procedure is simply to delete the paths' files from
> /run/udev/data and to restart multipathd.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

