Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68E8BC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 17 Feb 2022 11:03:30 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-CGN30GvlPYiUurh-G20pnw-1; Thu, 17 Feb 2022 06:03:25 -0500
X-MC-Unique: CGN30GvlPYiUurh-G20pnw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CCB05801B26;
	Thu, 17 Feb 2022 11:03:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 92C446E188;
	Thu, 17 Feb 2022 11:03:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0AB7F4BB7C;
	Thu, 17 Feb 2022 11:03:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21HAx8vb022025 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 17 Feb 2022 05:59:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A57F61454538; Thu, 17 Feb 2022 10:59:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1CC81454535
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 10:59:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89A818BF640
	for <dm-devel@redhat.com>; Thu, 17 Feb 2022 10:59:08 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-274-WTjLnEgBNpemsfv8O68Igw-1; Thu, 17 Feb 2022 05:59:02 -0500
X-MC-Unique: WTjLnEgBNpemsfv8O68Igw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 26CC91F3A2;
	Thu, 17 Feb 2022 10:59:01 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B533613DD8;
	Thu, 17 Feb 2022 10:59:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id oxwfKnQqDmLWTgAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 17 Feb 2022 10:59:00 +0000
Message-ID: <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: NeilBrown <neilb@suse.de>
Date: Thu, 17 Feb 2022 11:58:55 +0100
In-Reply-To: <164504936873.10228.7361167610237544463@noble.neil.brown.name>
References: <20220216205914.7575-1-mwilck@suse.com>
	<164504936873.10228.7361167610237544463@noble.neil.brown.name>
User-Agent: Evolution 3.42.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21HAx8vb022025
X-loop: dm-devel@redhat.com
Cc: Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.com>,
	Peter Rajnoha <prajnoha@redhat.com>, lvm-devel@redhat.com,
	linux-raid@vger.kernel.org, dm-devel@redhat.com,
	Heming Zhao <heming.zhao@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-02-17 at 09:09 +1100, NeilBrown wrote:
> On Thu, 17 Feb 2022, mwilck@suse.com=A0wrote:
> > From: Martin Wilck <mwilck@suse.com>
> >=20
> > device-mapper sets the flag DM_UDEV_DISABLE_OTHER_RULES_FLAG to 1
> > for
> > devices which are unusable. They may be no set up yet, suspended,
> > or
> > otherwise unusable (e.g. multipath maps without usable path). This
> > flag does not necessarily imply SYSTEMD_READY=3D0 and must therefore
> > be tested separately.
>=20
> I really don't like this - looks like a hack.=A0 A Kludge.

These are strong words. You didn't go into detail, so I'm assuming that
your reasoning is that DM_UDEV_DISABLE_OTHER_RULES_FLAG is an internal
flag of the device-mapper subsystem. Still, you can see that is's used
both internally by dm, and by other subsystems:

https://github.com/lvmteam/lvm2/blob/8dccc2314e2482370bc6e5cf007eb210994abd=
ef/udev/13-dm-disk.rules.in#L15
https://github.com/g2p/bcache-tools/blob/a73679b22c333763597d39c72112ef5a53=
f55419/69-bcache.rules#L6
https://github.com/opensvc/multipath-tools/blob/d9d7ae9e2125116b465b4ff4d98=
ce65fe0eac3cc/kpartx/kpartx.rules#L10

Would you call these others "hacks", too?

> Can you provide a reference to a detailed discussion that explains
> why
> SYSTEMD_READY=3D0 cannot be used?

The main reason is that SYSTEMD_READY=3D0 is set too late, in 99-systemd-
rules, and only on "add" events:
https://github.com/systemd/systemd/blob/bfae960e53f6986f1c4d234ea82681d0aca=
d57df/rules.d/99-systemd.rules.in#L18

I guess the device-mapper rules themselves could be setting
SYSTEMD_READY=3D"0". @Peter Rajnoha, do you want to comment on that? My
concern wrt such a change would be possible side effects. Setting
SYSTEMD_READY=3D0 on "change" events could actually be wrong, see below.

I the case I was observing, there was a multipath device without valid
paths, which had switched to queueing mode [*]. If this happens for
whatever reason (and it could be something else, like a suspended DM
device), IO on such a device hangs. IO that may hang must not be
attempted from an udev rule. Therefore it makes sense that layers
stacked on top of DM try to avoid it, and checking udev properties set
by DM is a reasonable way to do that.

The core of the problem is that there is no well-defined "API"
specifying how different udev rule sets can communicate, iow which udev
properties are well-defined enough to be consumed outside of the
subsystem that defines them. SYSTEMD_READY is about the only "global"
property. IMO it's somewhat overloaded: The actual semantics of
SYSTEMD_READY=3D0 is "systemd shouldn't activate the associated device
unit". Various udev rule sets use it with similar but not 100%
identical semantics like "don't touch this" or "don't probe this".=A0

In the case I was looking at, the device had already been activated by
systemd. Later, the device had lost all active paths and thus became
unusable. We can't easily set SYSTEMD_READY=3D0 on such a device. Doing
so would actually be dangerous, because systemd might remove the
device. Moreover, while processing the udev rule, we just don't know if
the problem is temporary or permanent.=20

Other properties, like those set by the DM subsystem, are less well-
defined. There's no official spec defining their names and semantics,
and there are multiple flags which aren't easly differentiated
(DM_UDEV_DISABLE_DISK_RULES_FLAG, DM_UDEV_DISABLE_OTHER_RULES_FLAG,
DM_NOSCAN, DM_SUSPENDED, MPATH_DEVICE_READY). OTOH, most of these flags
have been around for many years without changing, and thus have
acquired the status of a semi-official API, which is actually used in
other rule sets. In particular DM_UDEV_DISABLE_OTHER_RULES_FLAG has a
few users, see above. I believe this is for good reason, and therefore
I don't consider my patch a "hack".

Regards
Martin

[*] How that came to pass is subtle by itself, and admittedly not fully
understood.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

