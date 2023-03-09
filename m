Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA3AC6FD19
	for <dm-devel@archiver.kernel.org>; Thu,  9 Mar 2023 21:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678398617;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MYJGrmNxioVIPa3fzWKz+rgeZFLFnRhpLW9oxhn3fIQ=;
	b=eAGcjxsuAY4Dlqkb/Kfb4pRjDKYZ/2t0lGqOAT3brGLVd9zdWCZmw/vCG34MIVa9GGawCw
	pFGUAGBRhJr9GqzMnpNIXuwqlTwRcyiIWtcBr/5gQ6mlJmLvmgd7Mhe0buGjc02+dGQ378
	+3U81q+rC0hDVr2n43QVmh/bQNwhvaY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-z0MvWYwFPsO0HI2kH6Gwug-1; Thu, 09 Mar 2023 16:50:14 -0500
X-MC-Unique: z0MvWYwFPsO0HI2kH6Gwug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A63D830F4F;
	Thu,  9 Mar 2023 21:50:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4AD54492B05;
	Thu,  9 Mar 2023 21:50:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18FCB19465BC;
	Thu,  9 Mar 2023 21:50:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EE3631946597
 for <dm-devel@listman.corp.redhat.com>; Thu,  9 Mar 2023 21:50:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id AA2E9440DE; Thu,  9 Mar 2023 21:50:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A23D3440DD
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 21:50:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 829771C04B73
 for <dm-devel@redhat.com>; Thu,  9 Mar 2023 21:50:10 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-272-cAMhn8hPNYK2TgLQ8AJSPA-1; Thu,
 09 Mar 2023 16:50:06 -0500
X-MC-Unique: cAMhn8hPNYK2TgLQ8AJSPA-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id A2FFF20311;
 Thu,  9 Mar 2023 21:50:05 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7B51213A10;
 Thu,  9 Mar 2023 21:50:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id UwGDHI1UCmTYEgAAMHmgww
 (envelope-from <mwilck@suse.com>); Thu, 09 Mar 2023 21:50:05 +0000
Message-ID: <8569f8c6c9d16ecaf255056dd91cb46b5a813add.camel@suse.com>
From: Martin Wilck <mwilck@suse.com>
To: Brian Bunker <brian@purestorage.com>
Date: Thu, 09 Mar 2023 22:50:04 +0100
In-Reply-To: <A1AAA90F-3F7E-4C37-B23B-178022361884@purestorage.com>
References: <CAHZQxyJH1etLR5gHuWk4c6-ieioqA4GrJ173B60bnTppke58dw@mail.gmail.com>
 <4bc4be79c2d00cc959932ec935179a46be4b2fbc.camel@suse.com>
 <5A7BD289-0205-42FF-84CD-7C218511A280@purestorage.com>
 <fb99dac64dd41a6a44b3c7ce065608b45ff467c4.camel@suse.com>
 <C9BF0F84-BA7F-432C-A9A7-DC77DFE856CA@purestorage.com>
 <82cf76fe2b1949337064127eac3ca17c1082d0a7.camel@suse.com>
 <20230306190413.GL17327@octiron.msp.redhat.com>
 <eab31c43c11e5acfc750ee1d5e21df4e92641c31.camel@suse.com>
 <C4BBD0E1-F806-4EE8-8C4A-0EEA3E0C433A@purestorage.com>
 <555883fb00fa0769ef37a96e99095b2778ee8467.camel@suse.com>
 <A1AAA90F-3F7E-4C37-B23B-178022361884@purestorage.com>
User-Agent: Evolution 3.46.4
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH] [PATCH] libmultipath: return 'ghost' state
 when port is in transition
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Brian,

On Thu, 2023-03-09 at 13:40 -0800, Brian Bunker wrote:
>=20
> Martin,
>=20
> Sorry I bounce between kernel versions a lot since most of the
> problems which find their way to us are released Linux versions
> whose kernels are quite a bit older than upstream.I got a chance
> to try the proposed solutions. The PATH_GHOST above does what
> I am looking for which is not to have the path checker fail the path.
>=20
> This also works as your earlier comments suggest. This does seem
> clearer as to what is happening on the path:
>=20

I apologize for being slow, but I don't quite understand this response.
Have you tested Ben's patch set? Does it work for you? Is the patch
below meant to be applied on top of Ben's work?

Martin

> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index fdb91e17..50f0773e 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -343,6 +343,7 @@ static const char
> *generic_msg[CHECKER_GENERIC_MSGTABLE_SIZE] =3D {
> =A0=A0=A0=A0=A0=A0=A0 [CHECKER_MSGID_UP] =3D " reports path is up",
> =A0=A0=A0=A0=A0=A0=A0 [CHECKER_MSGID_DOWN] =3D " reports path is down",
> =A0=A0=A0=A0=A0=A0=A0 [CHECKER_MSGID_GHOST] =3D " reports path is ghost",
> +=A0=A0=A0=A0=A0=A0 [CHECKER_MSGID_PENDING] =3D " reports path is transit=
ioning",
> =A0=A0=A0=A0=A0=A0=A0 [CHECKER_MSGID_UNSUPPORTED] =3D " doesn't support t=
his device",
> =A0};
>=20
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index ea1e8af6..4fbad621 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -111,6 +111,7 @@ enum {
> =A0=A0=A0=A0=A0=A0=A0 CHECKER_MSGID_UP,
> =A0=A0=A0=A0=A0=A0=A0 CHECKER_MSGID_DOWN,
> =A0=A0=A0=A0=A0=A0=A0 CHECKER_MSGID_GHOST,
> +=A0=A0=A0=A0=A0=A0 CHECKER_MSGID_PENDING,
> =A0=A0=A0=A0=A0=A0=A0 CHECKER_MSGID_UNSUPPORTED,
> =A0=A0=A0=A0=A0=A0=A0 CHECKER_GENERIC_MSGTABLE_SIZE,
> =A0=A0=A0=A0=A0=A0=A0 CHECKER_FIRST_MSGID =3D 100,=A0=A0=A0=A0=A0 /* lowe=
st msgid for checkers
> */
>=20
> diff --git a/libmultipath/checkers/tur.c
> b/libmultipath/checkers/tur.c
> index 551dc4f0..e1742c2b 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -179,7 +179,7 @@ retry:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 else if (key =3D=3D 0x2) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
Not Ready */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 /* =
Note: Other ALUA states are either UP or
> DOWN */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if( a=
sc =3D=3D 0x04 && ascq =3D=3D 0x0b){
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (a=
sc =3D=3D 0x04 && ascq =3D=3D 0x0b) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 /*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * LOGICAL UNIT NOT ACCESSIBLE,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * TARGET PORT IN STANDBY STATE
> @@ -187,6 +187,14 @@ retry:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 *msgid =3D CHECKER_MSGID_GHOST;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 return PATH_GHOST;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (a=
sc =3D=3D 0x04 && ascq =3D=3D 0x0a) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 /*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * LOGICAL UNIT NOT ACCESSIBLE,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 * TARGET PORT IN TRANSITION STATE
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 *msgid =3D CHECKER_MSGID_PENDING;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 return PATH_PENDING;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 *msgid =3D CHECKER_MSGID_DO=
WN;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return PATH_DOWN;
>=20
> This change also keeps the path from being failed by the checker.
> It seems to go into and out of transitioning from other states.
>=20
> Thanks,
> Brian=20
> >=20
> > > >=20
> > > > The default transitioning timeout is 60s, and in my experience,
> > > > even if
> > > > the hardware overrides it, it's rarely more than a few minutes.
> > > > After
> > > > that, the kernel will set the state to STANDBY.
> > > Yes. The case of a target keeping a path in the transitioning
> > > state
> > > Indefinitely is handled by the device handler.
> > > >=20
> > > > Unless we're both overlooking something, I agree with you that
> > > > PATH_PENDING is the right thing to do for TRANSITIONING. When a
> > > > device
> > > > is in transition between states, we _want_ to check it often to
> > > > make
> > > > sure we notice when the target state is reached.
> > > >=20
> > > > We must then be careful not to overload PATH_PENDING with too
> > > > many
> > > > different meanings. But I don't see this as a big issue
> > > > currently.
> > > >=20
> > > > Regards
> > > > Martin
> > > >=20
> > > > > Thoughts?
> > > > >=20
> > > > > -Ben
> > > > >=20
> > > > > >=20
> > > > > > Regards
> > > > > > Martin
>=20
>=20

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

