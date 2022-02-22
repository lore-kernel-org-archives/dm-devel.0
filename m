Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3723C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 22 Feb 2022 13:54:57 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-HHRYOOVONcOHEXCmpdCzug-1; Tue, 22 Feb 2022 08:54:53 -0500
X-MC-Unique: HHRYOOVONcOHEXCmpdCzug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DCDF193578B;
	Tue, 22 Feb 2022 13:54:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57421797E8;
	Tue, 22 Feb 2022 13:54:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CC73F4EA37;
	Tue, 22 Feb 2022 13:54:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21MDseFd032553 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 08:54:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2ADD4400C849; Tue, 22 Feb 2022 13:54:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2603640D1B9F
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 13:54:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E6391C10FE3
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 13:54:40 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-418-0pxsHifyOnW9DbwAHCufcQ-1; Tue, 22 Feb 2022 08:54:36 -0500
X-MC-Unique: 0pxsHifyOnW9DbwAHCufcQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6C7E621124;
	Tue, 22 Feb 2022 13:54:34 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1225313B98;
	Tue, 22 Feb 2022 13:54:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id 7116AhrrFGJrbwAAMHmgww
	(envelope-from <mwilck@suse.com>); Tue, 22 Feb 2022 13:54:34 +0000
Message-ID: <4b61ca1eafb35e3fdfbc9bb260dc89d56d181499.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: NeilBrown <neilb@suse.de>, Peter Rajnoha <prajnoha@redhat.com>
Date: Tue, 22 Feb 2022 14:54:33 +0100
In-Reply-To: <164548656531.8827.3365536065813085321@noble.neil.brown.name>
References: <20220216205914.7575-1-mwilck@suse.com>
	, <164504936873.10228.7361167610237544463@noble.neil.brown.name>
	, <e8720e3f8734cbad1af34d5e54afc47ba3ef1b8f.camel@suse.com>
	, <20220217130934.lh2b33255kyx2pax@alatyr-rpi.brq.redhat.com>
	<164548656531.8827.3365536065813085321@noble.neil.brown.name>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21MDseFd032553
X-loop: dm-devel@redhat.com
Cc: Jes Sorensen <jsorensen@fb.com>, Coly Li <colyli@suse.com>,
	lvm-devel@redhat.com, linux-raid@vger.kernel.org,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Neil,

On Tue, 2022-02-22 at 10:36 +1100, NeilBrown wrote:
>=20
> > The flags that DM use for udev were introduced before systemd
> > project
> > even existed. We needed to introduce the
> > DM_UDEV_DISABLE_OTHER_RULES_FLAG
> > to have a possibility for all the "other" (non-dm) udev rules to
> > check
> > for if there's another subsystem stacking its own devices on top of
> > DM
> > ones.
>=20
> If this is an established API that DM uses, then presumably it is
> documented somewhere.=A0 If a link to that documentation were provided,
> it
> would look a a whole lot less like a hack.

Peter has provided a link to libdevmapper.h in his previous post in
this thread. Is this a request for me to include that link in the patch
description?

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

