Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0610AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 11:17:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-PVjK7yMGMlCw5coMzrtgmQ-1; Thu, 14 Apr 2022 07:17:30 -0400
X-MC-Unique: PVjK7yMGMlCw5coMzrtgmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6B3D188498A;
	Thu, 14 Apr 2022 11:17:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C05C8C44CCF;
	Thu, 14 Apr 2022 11:17:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 15D2F194035F;
	Thu, 14 Apr 2022 11:17:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 163E61940340
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Apr 2022 15:01:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 00BC243271E; Wed, 13 Apr 2022 15:01:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F11C642B92F
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 15:01:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 24E6B8339A7
 for <dm-devel@redhat.com>; Wed, 13 Apr 2022 15:01:05 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
 [66.111.4.25]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-TEQZfYPlOQm7TCpoXxG5wg-1; Wed, 13 Apr 2022 11:01:02 -0400
X-MC-Unique: TEQZfYPlOQm7TCpoXxG5wg-1
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
 by mailout.nyi.internal (Postfix) with ESMTP id 8CA685C00FD;
 Wed, 13 Apr 2022 11:01:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
 by compute5.internal (MEProxy); Wed, 13 Apr 2022 11:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:content-type:date:date:from:from
 :in-reply-to:in-reply-to:message-id:mime-version:references
 :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
 :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1649862060; x=
 1649948460; bh=57fbp3KspvQ+m2FVaQ6PQ59I9Ox9HySonHIO8C9hy78=; b=E
 qbJdEGSSMieRhVuBIQmJLW2Ihd+4uKqh+uyBNDJ5L7SYe6DqZ4Lkpggo+WeN7wyq
 0iPj3x5ji3TYmAaasX66TgreVHIbb0j2WB2WBjpdWNsWIF97Wj7cAJ13ElncVM4s
 C46lwzkx2BayVPT7RlVrCAEjRRdVsG8TCUm/PZzRCzqBz0mdj3sadwFS/vcD/rFE
 26gNFiLu1/Qbobvptmw8gGTCobF419VTRGSSW5r+Q4ZuPAs1m2K7bQy9xsztjWpO
 S40oTlqnG66GusosnPCbki/nwHMIBX2cD+nRXG23v6+n5wxXFXPlTVyDlm8pSUmd
 PoTi2xkwZg1+WtlJhrLag==
X-ME-Sender: <xms:rOVWYv0qZaTRCXDIlRHlLJOl5bL_gENbW5KPGzQJuJEx1isyHsthqA>
 <xme:rOVWYuG35DLxgYm4qJmeE6uJm7t16C6sA3Oe4b8UW60OSU3vyv2losf7iNZiCrhVX
 fgfBdqVe2MfLps>
X-ME-Received: <xmr:rOVWYv7IYsGFu4RE2OLGoOjKft7aR7gmcFMdfgj94E0LxwIOISCulqU8Y7bK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeluddgheehucetufdoteggodetrfdotf
 fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
 uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
 cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghmihcu
 ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
 hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedttedtueeivdefiedugfejtdeutdel
 fedvueekledtudegjedviedukeefhfeuteenucevlhhushhtvghrufhiiigvpedtnecurf
 grrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhl
 rggsrdgtohhm
X-ME-Proxy: <xmx:rOVWYk00r-r2Kp97IKIhPeyk5286NGVFDOIjkF3vubZbGuSY1esfsg>
 <xmx:rOVWYiE31o5dfPFtvNKxZBsxo9Ndz7AHPuOtZBk9VWzctH2F6Xlqzw>
 <xmx:rOVWYl-7DzhDVYJdBQ_XR7K2Bs2LvEBphYl417R7dfdlkSn665gt8g>
 <xmx:rOVWYtyl-V8ChePFALoM9kONkEv-ZUaO4zDIoUAQiZpPiLPXsK1fNw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Apr 2022 11:00:59 -0400 (EDT)
Date: Wed, 13 Apr 2022 11:00:53 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, dm-devel@redhat.com
Message-ID: <YlblqqmQCdJ9jZWh@itl-email>
References: <YlNUhtXltj8vgvcZ@itl-email>
 <e65dbacc-f241-22ba-62a9-a6f522cce9dc@redhat.com>
 <YlRjvp7SH3To0pHe@itl-email>
 <cc43900d-35a3-14ae-73ef-919ab02e01ff@redhat.com>
 <YlSsMlcE5x2B58hc@itl-email>
 <6a6c09ad-73c9-2450-f1fb-0e3e4ba438e6@redhat.com>
 <20220412142905.GA26912@redhat.com>
 <cebf10ca-ccf6-0809-dcff-3634817d8a5e@gmail.com>
MIME-Version: 1.0
In-Reply-To: <cebf10ca-ccf6-0809-dcff-3634817d8a5e@gmail.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Thu, 14 Apr 2022 11:17:24 +0000
Subject: Re: [dm-devel] Potential enhancements to dm-thin v2
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
Content-Type: multipart/mixed; boundary="===============3645198189452590683=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8


--===============3645198189452590683==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1v7FTPIZIIn90/Gr"
Content-Disposition: inline


--1v7FTPIZIIn90/Gr
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 13 Apr 2022 11:00:53 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>, dm-devel@redhat.com
Subject: Re: Potential enhancements to dm-thin v2

On Wed, Apr 13, 2022 at 09:55:00AM +0200, Zdenek Kabelac wrote:
> Dne 12. 04. 22 v 16:29 David Teigland napsal(a):
> > Dne 11. 04. 22 v 0:03 Demi Marie Obenour napsal(a):
> > > For quite a while, I have wanted to write a tool to manage thin volum=
es
> > > that is not based on LVM.
> >=20
> > On Tue, Apr 12, 2022 at 11:32:09AM +0200, Zdenek Kabelac wrote:
> > > Here is actually the fundamental problem with your proposal - our des=
ign was
> > > about careful split between user-space and kernel 'who is the owner/h=
older
> > > of information'=C2=A0 - your proposal unfortunately does not fit the =
model where
> > > lvm2 is the authoritative owner of info about devices
> >=20
> > The proposal is a new tool to manage dm-thin devices, not to rewrite lv=
m.
> > I would hope the tool is nothing at all like lvm, but rather "thinsetup"
> > in the tradition of dmsetup, cryptsetup.  I think it's a great idea and
> > have wanted such a tool for years.  I have a feeling that many have
> > already written ad hoc thinsetup-like tools, and there would be fairly
> > broad interest in it (especially if it has a proper lib api.)
> >=20
>=20
>=20
> The problem with these 'ad-hoc' tools is their 'support - aka how to proc=
eed
> in case of any failure.
>=20
> So while there will be no problem to generate many device in very fast wa=
y -
> the recoverability from failure will then be always individual based on t=
he
> surrounding environment.

That=E2=80=99s why I want to stick a name and UUID in each thin device=E2=
=80=99s
metadata.  That makes creating a thin device and associating it with a
name an atomic operation, and means that if there is a failure, the
sysadmin or management toolstack knows what it needs to do to clean up.

--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--1v7FTPIZIIn90/Gr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJW5agACgkQsoi1X/+c
IsGr6BAA3vBsGMqT3sSdL8jQZf0FQdvUofXFlwwuOnVNKq1qTHV/cUTKfw082R1t
Bu5w4hgEZT8YXviQgSBSTGvnWlP+j6sIaUU/tjZeJVbK5vgFH/esrNGGlG1K8HwI
sYXvH1uSxfLwwTpf1kV+gJ9YIc8zedhtHeKqLtb3WESnsD5JzulvqKOfb3mSIu5q
+YH3F+L+gCDLjYMqV8nA4LJlePO0qx7tV6iKqzq+DdtQ/+I+pE1aRBQLn29ZXfS7
aOl+0lDccJ6i6/St8rY3OufA4m9zN6a7VxeN9o9FJ4Ato9M9p4LONTa1IfCD9xZr
2hr4lBNfsNWnBN4d9XeCQvI+5lch2Ny/oMDPPuHNfL4f1KZzfz0hXAyJJbdvm2Kh
jib3w9viXbDWanVSW48cMMMxRZb7ODx8bG02RvnyHoNt0b6oP5R7ZKY9dAfxmNXG
Q1PpqpObXZ1UBIFGk0uzxhCDHyqWm3q3l99pHpYZRPDtGoqu6zLFRMAeJEzS4I86
aGSX930hzVwuBevXaI0GEqh7l55s0qkxarEnlSdOp5IX1ZZNOnr3XTQnvZTUv9c6
YLoJz2O0EMNWSeIo4EH4qCUROhjXpmFEVGGDmclMpQSu9L6NKqaSznlyN20r10J3
5NYuxum5eepDX5h/Z3+R7d0XwkcXBrgj7LGkthD2TwgoOr9d9qU=
=sTNg
-----END PGP SIGNATURE-----

--1v7FTPIZIIn90/Gr--


--===============3645198189452590683==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============3645198189452590683==--

