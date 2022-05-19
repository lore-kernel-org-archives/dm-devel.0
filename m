Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B40C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 19 May 2022 12:36:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-Xl-A1X_KPvC2zTDXK9yBmA-1; Thu, 19 May 2022 08:36:11 -0400
X-MC-Unique: Xl-A1X_KPvC2zTDXK9yBmA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C77F8015BA;
	Thu, 19 May 2022 12:36:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE3F0492CA4;
	Thu, 19 May 2022 12:36:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 702E8194705A;
	Thu, 19 May 2022 12:36:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 76D01194705A
 for <dm-devel@listman.corp.redhat.com>; Thu, 19 May 2022 12:36:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 668BF1121314; Thu, 19 May 2022 12:36:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 62CD81121319
 for <dm-devel@redhat.com>; Thu, 19 May 2022 12:36:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B3D0811E81
 for <dm-devel@redhat.com>; Thu, 19 May 2022 12:36:06 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-TjMSjGLdOnSdUdrHRHNciw-1; Thu, 19 May 2022 08:36:01 -0400
X-MC-Unique: TjMSjGLdOnSdUdrHRHNciw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id BDE7F1FD38;
 Thu, 19 May 2022 12:35:59 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9099713456;
 Thu, 19 May 2022 12:35:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id yKWwIa85hmJ8DAAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 19 May 2022 12:35:59 +0000
Message-ID: <9d6d3fe4b52f5489e927b6a8c3be9b980fffd3b8.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Date: Thu, 19 May 2022 14:35:59 +0200
In-Reply-To: <d26e9d04-1f28-b784-16da-0fc0cd6e57e7@gmail.com>
References: <20220330194941.28470-1-xose.vazquez@gmail.com>
 <636faa5a57cca0b51d12d5e50968124d5b187280.camel@suse.com>
 <d26e9d04-1f28-b784-16da-0fc0cd6e57e7@gmail.com>
User-Agent: Evolution 3.44.1
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH RFC] multipath-tools: update "Generic NVMe"
 options in hwtable
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
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sun, 2022-05-15 at 15:16 +0200, Xose Vazquez Perez wrote:
> On 3/31/22 13:02, Martin Wilck wrote:
> > On Wed, 2022-03-30 at 21:49 +0200, Xose Vazquez Perez wrote:
> > > Removed values were default.
> >=20
> > This is wrong for uid_attribute. You can see it when you run "make
> > test", which fails with your patch. It's also wrong for
> > retain_hwhandler, but that entry should indeed be removed, because
> > keeping it there is misleading at best. hwhandlers have no meaning
> > for
> > NVMe, and retain_hwhandler is enforced to be true an all kernels
> > since
> > 4.3.
> >=20
> > Regards,
> > Martin
> >=20
> > > Check ANA, else fall back to CONST(multibus).
> > >=20
> > > Cc: Martin Wilck <mwilck@suse.com>
> > > Cc: Benjamin Marzinski <bmarzins@redhat.com>
> > > Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> > > Cc: DM-DEVEL ML <dm-devel@redhat.com>
> > > Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> > > ---
> > > =A0=A0libmultipath/hwtable.c | 6 +++---
> > > =A0=A01 file changed, 3 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> > > index 0e1c0a41..81dca0d5 100644
> > > --- a/libmultipath/hwtable.c
> > > +++ b/libmultipath/hwtable.c
> > > @@ -88,9 +88,9 @@ static struct hwentry default_hw[] =3D {
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Generic NVMe */
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=
=A0=A0=A0=A0 =3D "NVME",
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=
=A0=A0=A0 =3D ".*",
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.uid_attribute =3D DEFA=
ULT_NVME_UID_ATTRIBUTE,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.checker_name=A0 =3D NO=
NE,
> > > -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.retain_hwhandler =3D R=
ETAIN_HWHANDLER_OFF,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=
=A0 =3D GROUP_BY_PRIO,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =
=3D -FAILBACK_IMMEDIATE,
> > > +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D NO_P=
ATH_RETRY_QUEUE,
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0},
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> > > =A0=A0=A0=A0=A0=A0=A0=A0=A0 * Apple
> >=20
>=20
> as of this patch, what else do you want to add/remove ?
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 47ea5d3d..2f750adb 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -86,11 +86,10 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Generic NVMe */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "NVME",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "NVM[eE]",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=
=A0 =3D ".*",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.uid_attribute =3D DEFAUL=
T_NVME_UID_ATTRIBUTE,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.checker_name=A0 =3D NONE=
,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.retain_hwhandler =3D RETAI=
N_HWHANDLER_OFF,
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Apple
>=20

This looks ok to me.

Martin



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

