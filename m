Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052E2C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 10:58:37 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-uKXDrGiYPYSEMpiH8Dca3g-1; Thu, 06 Jan 2022 05:58:33 -0500
X-MC-Unique: uKXDrGiYPYSEMpiH8Dca3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1D208015CD;
	Thu,  6 Jan 2022 10:58:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAE1B8464E;
	Thu,  6 Jan 2022 10:58:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7456A4A7C8;
	Thu,  6 Jan 2022 10:58:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206AwRVv011896 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 05:58:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B564D2028CE7; Thu,  6 Jan 2022 10:58:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B0A76200AE78
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 10:58:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BCEF80029D
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 10:58:24 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-124-3QucZz9kMUeW2jh-HL_cWg-1; Thu, 06 Jan 2022 05:58:21 -0500
X-MC-Unique: 3QucZz9kMUeW2jh-HL_cWg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 13FA21F37D;
	Thu,  6 Jan 2022 10:58:20 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDDD513C24;
	Thu,  6 Jan 2022 10:58:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id lAt7NEvL1mGgDwAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 06 Jan 2022 10:58:19 +0000
Message-ID: <c7b3fc9ddabf54cb7644b7bdaf7e9076ebbf34bb.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Sergei Trofimovich <slyich@gmail.com>, dm-devel@redhat.com
Date: Thu, 06 Jan 2022 11:58:19 +0100
In-Reply-To: <0919522c013ec8fcd5310b45cdcd41a530045d75.camel@suse.com>
References: <20220105223006.162573-1-slyich@gmail.com>
	<0919522c013ec8fcd5310b45cdcd41a530045d75.camel@suse.com>
User-Agent: Evolution 3.42.2
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 206AwRVv011896
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH] kpartx/devmapper.c: fix unused-but-set
	variable error
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

On Thu, 2022-01-06 at 11:55 +0100, Martin Wilck wrote:
> On Wed, 2022-01-05 at 22:30 +0000, Sergei Trofimovich wrote:
> > On gcc-12 build failed as:
> >=20
> > =A0=A0=A0 devmapper.c: In function 'dm_simplecmd':
> > =A0=A0=A0 devmapper.c:61:13: error: unused variable 'udev_wait_flag' [-
> > Werror=3Dunused-variable]
> > =A0=A0=A0=A0=A0=A0 61 |=A0=A0=A0=A0=A0=A0=A0=A0 int udev_wait_flag =3D =
(task =3D=3D DM_DEVICE_RESUME
> > ||
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^~~~~=
~~~~~~~~~
> >=20
> > Fix error by hiding it's declaration under #ifdef that uses it.
> > CC: Martin Wilck <mwilck@suse.com>
> > CC: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> > =A0kpartx/devmapper.c | 2 +-
> > =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Under https://github.com/opensvc/multipath-tools/pull/23/files
> you posted a different patch, containing additional changes.
>=20
> Are you saying this alone fixes your issue?

Sorry, I overlooked your second patch.
Next time, please send a series.

Regards
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

