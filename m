Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1155DC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 13 Dec 2022 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1670953860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kES15EeNLN7ORSV3D6B8ELWWzfQPekw9gWXVFRbijY4=;
	b=aRyZo0Prz1yoxzTUHlX8PLSYvxj8W85WhZtd87lZt4f0eUTFcvHRosiGZ6lFpODFeuGr++
	7m8kSKZJaWbzUBir8fYd+/WeeRncZqt25lafNLMiZj22kMKJWhVGNaQyE/tExS4Fm3GTlC
	Tbb1U/L4Fw+lZ57EgL0XYqGFgaCQfTI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-aVhAB8TtN3CYuGf2SQ7tcA-1; Tue, 13 Dec 2022 12:50:57 -0500
X-MC-Unique: aVhAB8TtN3CYuGf2SQ7tcA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67AA7185A7AD;
	Tue, 13 Dec 2022 17:50:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA90B2026D68;
	Tue, 13 Dec 2022 17:50:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F05E194658D;
	Tue, 13 Dec 2022 17:50:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 740DC1946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 17:50:51 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6574F4039F60; Tue, 13 Dec 2022 17:50:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 429CC4039F64;
 Tue, 13 Dec 2022 17:50:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 2BDHonsj006239;
 Tue, 13 Dec 2022 11:50:50 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 2BDHonrw006238;
 Tue, 13 Dec 2022 11:50:49 -0600
Date: Tue, 13 Dec 2022 11:50:49 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20221213175048.GG19568@octiron.msp.redhat.com>
References: <20221202234338.2960-1-mwilck@suse.com>
 <20221207003730.GC19568@octiron.msp.redhat.com>
 <3cddb507361a3c582a11a2c752bfbae43c92aa37.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <3cddb507361a3c582a11a2c752bfbae43c92aa37.camel@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v2] libmultipath: is_path_valid(): check if
 device is in use
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2022 at 08:46:28AM +0100, Martin Wilck wrote:
> On Tue, 2022-12-06 at 18:37 -0600, Benjamin Marzinski wrote:
> > On Sat, Dec 03, 2022 at 12:43:38AM +0100, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > To check whether we will be able to add a given device can be part
> > > of a multipath map, we have two tests in check_path_valid():
> > > released_to_systemd() and the O_EXCL test. The former isn't helpful
> > > if "multipath -u" is called for the first time for a given device,
> > > and the latter is only used in the "find_multipaths smart" case,
> > > because
> > > actively opening the device with O_EXCL, even for a very short
> > > time, is prone
> > > to races with other processes.
> > >=20
> > > It turns out that this may cause issues in some scenarios. We saw
> > > problems in
> > > once case where "find_multipaths greedy" was used with a single
> > > non-multipahted root disk and a very large number of multipath
> > > LUNs.
> > > The root disk would first be classified as multipath device.
> > > multipathd
> > > would try to create a map, fail (because the disk was mounted) and
> > > trigger another uevent. But because of the very large number of
> > > multipath
> > > devices, this event was queued up behind thousands of other events,
> > > and
> > > the root device timed out eventually.
> > >=20
> > > While a simple workaround for the given problem would be proper
> > > blacklisting
> > > or using a different find_multipaths mode, I am proposing a
> > > different
> > > solution here. An additional test is added in is_path_valid() which
> > > checks whether the given device is currently in use by 1. sysfs
> > > holders,
> > > 2. mounts (from /proc/self/mountinfo) or 3. swaps (from
> > > /proc/swaps). 2.
> > > and 3. are similar to systemd's device detection after switching
> > > root.
> > > This must not only be done for the device itself, but also for all
> > > its
> > > partitions. For mountinfo and swaps, libmount is utilized.
> > >=20
> > > With this patch, "multipath -u" will make devices with mounted or
> > > otherwise
> > > used partitions available to systemd early, without waiting for
> > > multipathd
> > > to fail setting up the map and re-triggering an uevent. This should
> > > avoid
> > > the issue described above even without blacklisting. The downside
> > > of it
> > > is a longer runtime of "multipath -u" for almost all devices, in
> > > particular
> > > for real multipath devices. The runtime required for the new checks
> > > was in the
> > > order of 0.1ms-1ms in my tests. Moreover, there is a certain risk
> > > that devices may
> > > wrongly classified as non-multipath because of transient mounts or
> > > holders
> > > created by other processes.
> > >=20
> > > To make this code compile on older distributions, we need some
> > > additional
> > > checks in create-config.mk.
> > >=20
> > Two small issues below.
> >=20
> > > Signed-off-by: Martin Wilck <mwilck@suse.com>
> > > ---
> > > =A0.github/workflows/build-and-unittest.yaml |=A0=A0 2 +-
> > > =A0create-config.mk=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 11 +-
> > > =A0libmpathutil/libmpathutil.version=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 =
6 +
> > > =A0libmpathutil/util.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0 12 +
> > > =A0libmpathutil/util.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +
> > > =A0libmultipath/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |=A0=A0 2 +-
> > > =A0libmultipath/alias.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 |=A0 11 -
> > > =A0libmultipath/valid.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 | 267
> > > ++++++++++++++++++++++
> > > =A0tests/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 2 +-
> > > =A0tests/valid.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 48 ++++
> > > =A010 files changed, 348 insertions(+), 15 deletions(-)
> > >=20
> > >=20
> > > +static int read_partitions(const char *syspath, vector parts)
> > > +{
> > > +=A0=A0=A0=A0=A0=A0=A0struct scandir_result sr =3D { .n =3D 0 };
> > > +=A0=A0=A0=A0=A0=A0=A0char path[PATH_MAX], *last;
> > > +=A0=A0=A0=A0=A0=A0=A0char *prop;
> > > +=A0=A0=A0=A0=A0=A0=A0int i;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0strlcpy(path, syspath, sizeof(path));
> > > +=A0=A0=A0=A0=A0=A0=A0sr.n =3D scandir(path, &sr.di, subdir_filter, N=
ULL);
> > > +=A0=A0=A0=A0=A0=A0=A0if (sr.n =3D=3D -1)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -errno;
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push_cast(free_scandir_result, =
&sr);
> > > +
> > > +=A0=A0=A0=A0=A0=A0=A0/* parts[0] is the whole disk */
> > > +=A0=A0=A0=A0=A0=A0=A0if (vector_alloc_slot(parts) &&
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (prop =3D strdup(strrchr(path, '/') +=
 1)) !=3D NULL)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_set_slot(parts, =
prop);
> >=20
> > We should add the whole disk like we do for the partitions below,
> > where
> > we strdup() the name first, and free it if we can't allocate a slot.
> > Otherwise, if the strdup failed, we could leave an empty slot in the
> > vector, which would cause vector_foreach_slot() to stop early
>=20
> Sure.
>=20
>=20
> > > =A0int
> > > =A0is_path_valid(const char *name, struct config *conf, struct path
> > > *pp,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool check_multipathd)
> > > =A0{
> > > =A0=A0=A0=A0=A0=A0=A0=A0int r;
> > > =A0=A0=A0=A0=A0=A0=A0=A0int fd;
> > > +=A0=A0=A0=A0=A0=A0=A0const char *prop;
> > > =A0
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (!pp || !name || !conf)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_ERROR;
> > > @@ -80,6 +338,10 @@ is_path_valid(const char *name, struct config
> > > *conf, struct path *pp,
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (!pp->udev)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_ERROR;
> > > =A0
> > > +=A0=A0=A0=A0=A0=A0=A0prop =3D udev_device_get_property_value(pp->ude=
v, "DEVTYPE");
> > > +=A0=A0=A0=A0=A0=A0=A0if (prop =3D=3D NULL || strcmp(prop, "disk"))
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_NOT_VALI=
D;
> > > +
> > > =A0=A0=A0=A0=A0=A0=A0=A0r =3D pathinfo(pp, conf, DI_SYSFS | DI_WWID |=
 DI_BLACKLIST);
> > > =A0=A0=A0=A0=A0=A0=A0=A0if (r =3D=3D PATHINFO_SKIPPED)
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_NOT_VA=
LID;
> > > @@ -96,6 +358,11 @@ is_path_valid(const char *name, struct config
> > > *conf, struct path *pp,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_ERROR;
> > > =A0=A0=A0=A0=A0=A0=A0=A0}
> > > =A0
> > > +=A0=A0=A0=A0=A0=A0=A0if ((conf->find_multipaths =3D=3D FIND_MULTIPAT=
HS_GREEDY ||
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 conf->find_multipaths =3D=3D FIND_=
MULTIPATHS_SMART) &&
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 is_device_in_use(pp->udev) > 0)
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return PATH_IS_NOT_VALI=
D;
> > > +
> >=20
> > Even if multipath is set to "smart", the common case will still be
> > that
> > the device is in the wwids file, so we know that it's valid. I don't
> > see
> > a reason to do this check in that case.=A0 I was thinking that for the
> > "smart" case, this check should go at the end of the function, before
> > we
> > return PATH_IS_MAYBE_VALID. Or do you have a reason why we should do
> > it
> > here that I'm missing?
>=20
> I'd argue the other way around: if the device is in use, it doesn't
> matter any more whether or not it's listed in the WWIDs file. This
> situation can only occur if something went wrong beforehand (most
> probably, an inconsistent WWIDs file in the initrd, or some other
> component misbehaving). If we tag such a device VALID although it's
> mounted, we'll almost certainly fall into emergency mode, regardless of
> the find_multipaths mode we're in. The reason is that multipathd will
> fail to map the mounted device, and systemd will consider the path
> device unusable, leading to the device being inaccessible either way.

Sure. We can leave it like this. I don't have strong opinions one way or
the other.

-Ben
=20
> I agree that the device being in use while listed in the WWIDs file is
> an error and should probably be logged more prominently.
>=20
> Martin
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

