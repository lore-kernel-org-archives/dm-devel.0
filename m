Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065E5C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 23 Feb 2022 09:48:13 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-KFD_U33IPxauPg-HZaoAtQ-1; Wed, 23 Feb 2022 04:48:09 -0500
X-MC-Unique: KFD_U33IPxauPg-HZaoAtQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B81EF1006AA5;
	Wed, 23 Feb 2022 09:48:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40EC776C23;
	Wed, 23 Feb 2022 09:48:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A71F01809C98;
	Wed, 23 Feb 2022 09:47:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21N9ltOP001476 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 23 Feb 2022 04:47:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9090B53B3; Wed, 23 Feb 2022 09:47:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8C1CE79DC
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 09:47:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BA9685A5BC
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 09:47:45 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-627-YiK8ZVw1PGGsymn1gdVXkQ-1; Wed, 23 Feb 2022 04:47:41 -0500
X-MC-Unique: YiK8ZVw1PGGsymn1gdVXkQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E063921110;
	Wed, 23 Feb 2022 09:47:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7C1BB13C6E;
	Wed, 23 Feb 2022 09:47:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id kAwZHLsCFmK2NAAAMHmgww
	(envelope-from <mwilck@suse.com>); Wed, 23 Feb 2022 09:47:39 +0000
Message-ID: <d3aab8f2318f1438a1f0085eddf9713217d52391.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: NeilBrown <neilb@suse.de>
Date: Wed, 23 Feb 2022 10:47:38 +0100
In-Reply-To: <164557016782.28944.17731814770525408828@noble.neil.brown.name>
References: <20220216205914.7575-1-mwilck@suse.com>
	, <164504936873.10228.7361167610237544463@noble.neil.brown.name>
	, <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
	, <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
	, <164548656531.8827.3365536065813085321@noble.neil.brown.name>
	, <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
	<164557016782.28944.17731814770525408828@noble.neil.brown.name>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21N9ltOP001476
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello Neil,

On Wed, 2022-02-23 at 09:49 +1100, NeilBrown wrote:
> >=20
> > Peter has provided a link to libdevmapper.h in his previous post in
> > this thread. Is this a request for me to include that link in the
> > patch
> > description?
>=20
> If libdevmapper.h is the best documentation there is for this
> variable,
> then hopefully you can see why it feels to an outsider like a hack.
>=20

There's also some documentation in the form of comments in the device-
mapper rules files themselves:

https://github.com/lvmteam/lvm2/blob/8dccc2314e2482370bc6e5cf007eb210994abd=
ef/udev/10-dm.rules.in#L137

In general, 10-dm.rules is one of the most extensively commented rule
files. I've always found these comments quite helpful.

> It isn't even immediately clear that the text there is talking about
> environment variables visible in udev.
> If there is an expectation that tools outside of lvm2 will use these,
> then they really should be documented properly.=A0 SYSTEMD_READY is
> documented in "man systemd.device".=A0 How hard would it be to write a
> "dm-udev" man page which explains all this.

I agree that the documentation could be improved. OTOH, the text in
systemd.device(5) only explains how systemd itself interprets
SYSTEMD_READY. It doesn't say a word about how other udev rules are
supposed to deal with the device. IOW, SYSTEMD_READY is part of an API
between udev rules and systemd, and not between different udev rule
sets.

In particular the "don't probe this iff SYSTEMD_READY=3D=3D0" semantics
that are frequently used in rules files can't be inferred from this
documentation. It makes sense most of the time, but there are some
cases where it doesn't. Here, we have a case where probing should be
skipped, even though SYSTEMD_READY is not 0.

Regards,
Martin

PS: The big issue remains that there is no "official" API in which udev
rule sets can transport information between each other. I guess the
original idea was that every rule set would be self-contained, which
isn't the case any more. If anyone makes an effort redesign udev, they
should consider creating such an API somehow.


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

