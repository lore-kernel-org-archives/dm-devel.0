Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C705C433F5
	for <dm-devel@archiver.kernel.org>; Thu,  6 Jan 2022 11:00:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-9jhf8jXRM_GTjNVyAWPiDw-1; Thu, 06 Jan 2022 06:00:23 -0500
X-MC-Unique: 9jhf8jXRM_GTjNVyAWPiDw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E526B801ADC;
	Thu,  6 Jan 2022 11:00:19 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B455D84631;
	Thu,  6 Jan 2022 11:00:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7CB661809CB8;
	Thu,  6 Jan 2022 11:00:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 206B0HW3012057 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 6 Jan 2022 06:00:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C327640357BA; Thu,  6 Jan 2022 11:00:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE96C40357B8
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 11:00:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A60D685A5A8
	for <dm-devel@redhat.com>; Thu,  6 Jan 2022 11:00:17 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-592-GhK-YcV3NjOCmLaRUsWNgQ-1; Thu, 06 Jan 2022 06:00:14 -0500
X-MC-Unique: GhK-YcV3NjOCmLaRUsWNgQ-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D77F421106;
	Thu,  6 Jan 2022 11:00:12 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange X25519 server-signature ECDSA (P-521) server-digest
	SHA512) (No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A8DC313C3E;
	Thu,  6 Jan 2022 11:00:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA id krRFJ7zL1mF5EAAAMHmgww
	(envelope-from <mwilck@suse.com>); Thu, 06 Jan 2022 11:00:12 +0000
Message-ID: <5b27fc3c0c45e85533bef4628db63474b17a4ec5.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Sergei Trofimovich <slyich@gmail.com>, dm-devel@redhat.com
Date: Thu, 06 Jan 2022 12:00:12 +0100
In-Reply-To: <20220105223006.162573-1-slyich@gmail.com>
References: <20220105223006.162573-1-slyich@gmail.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 206B0HW3012057
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

On Wed, 2022-01-05 at 22:30 +0000, Sergei Trofimovich wrote:
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
> CC: Martin Wilck <mwilck@suse.com>
> CC: Benjamin Marzinski <bmarzins@redhat.com>


Please add a Signed-off-by: line. Same for the other patch.
Apart from that, both patches are ok.

Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

