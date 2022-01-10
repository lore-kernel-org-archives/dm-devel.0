Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0375C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 10 Jan 2022 16:58:20 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-408-s4nnYUP9N8e0UkV-gzMnLA-1; Mon, 10 Jan 2022 11:58:16 -0500
X-MC-Unique: s4nnYUP9N8e0UkV-gzMnLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17DA783DD27;
	Mon, 10 Jan 2022 16:58:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BFB6798D9;
	Mon, 10 Jan 2022 16:58:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FB2C1809CB8;
	Mon, 10 Jan 2022 16:58:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20AGw4KN024401 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 10 Jan 2022 11:58:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DBDDF202660D; Mon, 10 Jan 2022 16:58:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D6EEA2026D2F
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 16:58:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D4B538011A5
	for <dm-devel@redhat.com>; Mon, 10 Jan 2022 16:58:01 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-122-69n5WoyjO4mlLVwHWgoGFg-1; Mon, 10 Jan 2022 11:58:00 -0500
X-MC-Unique: 69n5WoyjO4mlLVwHWgoGFg-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D77101F395;
	Mon, 10 Jan 2022 16:57:58 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A7B5E13DC2;
	Mon, 10 Jan 2022 16:57:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id clvRJpZl3GG6MQAAMHmgww
	(envelope-from <mwilck@suse.com>); Mon, 10 Jan 2022 16:57:58 +0000
Message-ID: <67f74477e9f64b7ef08f2c2039982cd5642efe8c.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Sergei Trofimovich <slyich@gmail.com>, dm-devel@redhat.com
Date: Mon, 10 Jan 2022 17:57:58 +0100
In-Reply-To: <20220109092814.1861416-1-slyich@gmail.com>
References: <c7b3fc9ddabf54cb7644b7bdaf7e9076ebbf34bb.camel@suse.com>
	<20220109092814.1861416-1-slyich@gmail.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20AGw4KN024401
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 1/2] kpartx/devmapper.c: fix
 unused-but-set variable error
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sun, 2022-01-09 at 09:28 +0000, Sergei Trofimovich wrote:
> On gcc-12 build failed as:
>=20
> =A0=A0=A0 devmapper.c: In function 'dm_simplecmd':
> =A0=A0=A0 devmapper.c:61:13: error: unused variable 'udev_wait_flag' [-
> Werror=3Dunused-variable]
> =A0=A0=A0=A0=A0=A0 61 |=A0=A0=A0=A0=A0=A0=A0=A0 int udev_wait_flag =3D (t=
ask =3D=3D DM_DEVICE_RESUME ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^~~~~~~=
~~~~~~~
>=20
> Fix error by hiding it's declaration under #ifdef that uses it.
>=20
> CC: Martin Wilck <mwilck@suse.com>
> CC: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Sergei Trofimovich <slyich@gmail.com>

For this series:
Reviewed-by: Martin Wilck <mwilck@suse.com>


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

