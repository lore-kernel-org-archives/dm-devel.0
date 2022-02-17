Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E7AAC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645103403;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fwegztzdJYUKR0nmu/jwzCCaMIY7v2+bz2ESvJOF8As=;
	b=BBGM8PcaCoTyjuX62dqnXGb9jhojOZPUyrfcV1g4USDKOSFxlPqAeWGFsLO3scHw1qbbz+
	LoDslYJqZIIZ1czh3jX8mOHakC4iF53D8ILWW9J5XqqJJyiPtpKyrs4LBpMo2Dj18MmTwP
	mIhEet0ZxO2Xeu2PqOHWoCG2BAGJHQE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-5iOEcld3POiohZvEuPCaOQ-1; Thu, 17 Feb 2022 08:10:00 -0500
X-MC-Unique: 5iOEcld3POiohZvEuPCaOQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D789D1091DA0;
	Thu, 17 Feb 2022 13:09:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79FC92B3D5;
	Thu, 17 Feb 2022 13:09:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A60E1832DA0;
	Thu, 17 Feb 2022 13:09:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HD9i8Q001130 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 08:09:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4B6462166B14; Thu, 17 Feb 2022 13:09:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 475962166B17
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 13:09:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 29E553806648
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 13:09:41 +0000 (UTC)
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
	[209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-79-GcKe_2lcOQiC4ANAXC_kGw-1; Thu, 17 Feb 2022 08:09:39 -0500
X-MC-Unique: GcKe_2lcOQiC4ANAXC_kGw-1
Received: by mail-ej1-f69.google.com with SMTP id
	m12-20020a1709062acc00b006cfc98179e2so1509124eje.6
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 05:09:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:content-transfer-encoding
	:in-reply-to;
	bh=8lDd+d0+b5xK8fo8ENNAgO2m2RDI+tkbli47DWuk46o=;
	b=tKLYyjBpxhm22CO6NgUG1p/Td/Y73gLHmLfLmEFChg8NKbyJk/wqw5knlU0fgsIC+b
	gVbjCqR2agv67W4e3TaQjAwuWt5sSGvEfQUbxb8v+9xI/5cxusJc1CwSpRgh+/4Uv6SN
	XRrqHnJyUTtDvI2ms48IEw2m/7AJbqHmJLCM4F/q9GfkDMwEaqBy+weBJ4Z0a/9I09NN
	ETUm2xuzuKv5uJ8k9z1OE0sx47uPu7lm+/1AIWIwxxP5N9fZ84ACchxfwPzHu5lq9KkP
	iFG9JTlHtjfPTKI4aAGiavuHVfIk3kip84rvsrdYW590zLz1MY2w/PzNXJZ1bPRDzQkK
	i1Rg==
X-Gm-Message-State: AOAM532qelNrPNPmuBMte9tFU7aeXv8hZ2lG4z3vUiLaoxzppAlLYslj
	54umnmW+hjpKORzZTbXc4FyJEEym0UiW+6ZoU60WlRFfbvg7qhQ5/RbCa4cLHBa6YJbp6Jd83aA
	DP5sMCQ5IVaM4hHA=
X-Received: by 2002:a17:906:c0c:b0:6ce:e59c:c38a with SMTP id
	s12-20020a1709060c0c00b006cee59cc38amr2244943ejf.483.1645103378582;
	Thu, 17 Feb 2022 05:09:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy5/z/iiObCZMgwVxFkb04RLg9rkx7e1/Ff9ghNhkaOd+XT62fzOC6h6f1Hb4XPww5EtgvPBw==
X-Received: by 2002:a17:906:c0c:b0:6ce:e59c:c38a with SMTP id
	s12-20020a1709060c0c00b006cee59cc38amr2244922ejf.483.1645103378270;
	Thu, 17 Feb 2022 05:09:38 -0800 (PST)
Received: from alatyr-rpi.brq.redhat.com (nat-pool-brq-t.redhat.com.
	[213.175.37.10]) by smtp.gmail.com with ESMTPSA id
	r11sm1154152ejc.212.2022.02.17.05.09.37
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 17 Feb 2022 05:09:37 -0800 (PST)
Date: Thu, 17 Feb 2022 14:09:34 +0100
From: Peter Rajnoha <prajnoha@redhat.com>
To: Martin Wilck <mwilck@suse.com>
Message-ID: <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
References: <20220216205914.7575-1-mwilck@suse.com>
	<164504936873.10228.7361167610237544463@noble.neil.brown.name>
	<e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
MIME-Version: 1.0
In-Reply-To: <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Jes Sorensen <jsorensen@fb.com>, lvm-devel@redhat.com,
	linux-raid@vger.kernel.org, Coly Li <colyli@suse.com>,
	dm-devel@redhat.com, Heming Zhao <heming.zhao@suse.com>
Subject: Re: [dm-devel] [PATCH] udev-md-raid-assembly.rules: skip if
 DM_UDEV_DISABLE_OTHER_RULES_FLAG
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

On Thu 17 Feb 2022 11:58, Martin Wilck wrote:
> On Thu, 2022-02-17 at 09:09 +1100, NeilBrown wrote:
> > On Thu, 17 Feb 2022, mwilck@suse.com=A0wrote:
> > > From: Martin Wilck <mwilck@suse.com>
> > >=20
> > > device-mapper sets the flag DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1
> > > for
> > > devices which are unusable. They may be no set up yet, suspended,
> > > or
> > > otherwise unusable (e.g. multipath maps without usable path). This
> > > flag does not necessarily imply SYSTEMD_READY=3D0 and must therefore
> > > be tested separately.
> >=20
> > I really don't like this - looks like a hack.=A0 A Kludge.
>=20
> These are strong words. You didn't go into detail, so I'm assuming that
> your reasoning is that DM_UDEV_DISABLE_OTHER_RULES_FLAG is an internal
> flag of the device-mapper subsystem. Still, you can see that is's used
> both internally by dm, and by other subsystems:
>=20
> https://github.com/lvmteam/lvm2/blob/8dccc2314e2482370bc6e5cf007eb210994a=
bdef/udev/13-dm-disk.rules.in#L15
> https://github.com/g2p/bcache-tools/blob/a73679b22c333763597d39c72112ef5a=
53f55419/69-bcache.rules#L6
> https://github.com/opensvc/multipath-tools/blob/d9d7ae9e2125116b465b4ff4d=
98ce65fe0eac3cc/kpartx/kpartx.rules#L10
>=20

The flags that DM use for udev were introduced before systemd project
even existed. We needed to introduce the DM_UDEV_DISABLE_OTHER_RULES_FLAG
to have a possibility for all the "other" (non-dm) udev rules to check
for if there's another subsystem stacking its own devices on top of DM ones=
.

The flag is used to communicate the other rules a condition when a DM
device underneath is either not yet set up completely or it's not ready
to be read/scanned for a reason (e.g. the device is suspended, not yet
loaded with a table...).

The reason we needed to introduce such a flag is simple - there's
limited amount of event types and DM devices are not ready on the usual
ADD event. It's after the CHANGE event that originates from the DM
device having a table loaded and resumed. At the same time, a CHANGE
event can be generated for various different reasons. So checking a
single flag that we set based in out own udev rules based on our best
knowledge and let other other rules to check for this single flag
seemed to be the best option to solve this.

> Would you call these others "hacks", too?
>=20
> > Can you provide a reference to a detailed discussion that explains
> > why
> > SYSTEMD_READY=3D0 cannot be used?
>=20
> The main reason is that SYSTEMD_READY=3D0 is set too late, in 99-systemd-
> rules, and only on "add" events:
> https://github.com/systemd/systemd/blob/bfae960e53f6986f1c4d234ea82681d0a=
cad57df/rules.d/99-systemd.rules.in#L18
>=20
> I guess the device-mapper rules themselves could be setting
> SYSTEMD_READY=3D"0". @Peter Rajnoha, do you want to comment on that? My
> concern wrt such a change would be possible side effects. Setting
> SYSTEMD_READY=3D0 on "change" events could actually be wrong, see below.
>=20

First of all, as already mentioned, DM udev rules with all the flags
pre-date the systemd project itself.

When systemd was introduced, we communicated the flag use with systemd
right away and so this line was added to 99-systemd.rules:

  SUBSYSTEM=3D=3D"block", ACTION=3D=3D"add", ENV{DM_UDEV_DISABLE_OTHER_RULE=
S_FLAG}=3D=3D"1", ENV{SYSTEMD_READY}=3D"0"

At that early time, the SYSTEMD_READY flag was used solely for systemd
purpose of setting its own device units properly. Just later, other subsyst=
ems
started (mis)using this flag for notifying about device readiness and so
the very original intention of the SYSTEMD_READY flag has diverted this
way a little bit.

Last but not the least, systemd is just one of the init systems/service
managers around so it's not any standard for block devices to set the
SYSTEMD_READY flag to notify about device readiness. Yes, it's true
that systemd is widespread now, but still not a single standard...

> I the case I was observing, there was a multipath device without valid
> paths, which had switched to queueing mode [*]. If this happens for
> whatever reason (and it could be something else, like a suspended DM
> device), IO on such a device hangs. IO that may hang must not be
> attempted from an udev rule. Therefore it makes sense that layers
> stacked on top of DM try to avoid it, and checking udev properties set
> by DM is a reasonable way to do that.
>=20
> The core of the problem is that there is no well-defined "API"
> specifying how different udev rule sets can communicate, iow which udev
> properties are well-defined enough to be consumed outside of the
> subsystem that defines them. SYSTEMD_READY is about the only "global"
> property. IMO it's somewhat overloaded: The actual semantics of
> SYSTEMD_READY=3D0 is "systemd shouldn't activate the associated device
> unit". Various udev rule sets use it with similar but not 100%
> identical semantics like "don't touch this" or "don't probe this".=A0
>=20

Exactly!

The SID - Storage Instantiation Daemon, which is still in development,
is trying to cover exactly this part, among other things.

> In the case I was looking at, the device had already been activated by
> systemd. Later, the device had lost all active paths and thus became
> unusable. We can't easily set SYSTEMD_READY=3D0 on such a device. Doing
> so would actually be dangerous, because systemd might remove the
> device. Moreover, while processing the udev rule, we just don't know if
> the problem is temporary or permanent.=20
>=20
> Other properties, like those set by the DM subsystem, are less well-
> defined. There's no official spec defining their names and semantics,
> and there are multiple flags which aren't easly differentiated
> (DM_UDEV_DISABLE_DISK_RULES_FLAG, DM_UDEV_DISABLE_OTHER_RULES_FLAG,
> DM_NOSCAN, DM_SUSPENDED, MPATH_DEVICE_READY). OTOH, most of these flags
> have been around for many years without changing, and thus have
> acquired the status of a semi-official API, which is actually used in
> other rule sets. In particular DM_UDEV_DISABLE_OTHER_RULES_FLAG has a
> few users, see above. I believe this is for good reason, and therefore
> I don't consider my patch a "hack".
>=20

Maybe we (DM) should have documented this better, more clearly, but the
DM_UDEV_DISABLE_OTHER_RULES_FLAG is really designed to be checked by
"other" foreign subsystems to notify them whether they can process their
udev rules on such a DM device.

Full documentation for the generic DM udev flags is here:

https://sourceware.org/git/?p=3Dlvm2.git;a=3Dblob;f=3Dlibdm/libdevmapper.h;=
=3De9412da7d33fc7534cd1eccd88c21b75c6c221b1;hb=3DHEAD#l3644

In summary, the meaning of the flags:

  DM_UDEV_DISABLE_DISK_RULES_FLAG is controlling 13-dm-disk.rules (where
blkid is called for DM devices and /dev/disk/by-* symlinks are set)

  DM_UDEV_DISABLE_DM_RULES_FLAG is controlling 10-dm.rules

  DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG is controlling DM subsystem (LVM,
multipath, crypt, ...)

  DM_NOSCAN is just a helper DM-internal flag in udev to help inside
DM's own rules and/or its subsystem rules

  DM_SUSPENDED is something that is set and can be checked, but foreign
(non-DM) udev rules don't need to bother about this at all. DM udev
rules already set DM_UDEV_DISABLE_OTHER_RULES_FLAG to notify other rules
if the DM device becomes unreadable.

  DM_NAME, DM_UUID - normally, other rules don't need to bother about
DM name or UUID - they're set mainly to hook custom permission rules on
(for which DM has a template 12-dm-permissions.rules).

So the only flag a non-DM rule should be concerned about is exactly the
single DM_UDEV_DISABLE_OTHER_RULES_FLAG. That's its exact purpose it
was designed for within DM block devices and uevent processing.

Definitely not a hack!

(I'm just a bit surprised that we haven't sent a patch to MD yet.
Wasn't there a check for this flag anytime before? I thought all
major block subsystems have already been covered.)

--=20
Peter

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

