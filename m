Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D5DEB64DA
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 19:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687463582;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=QahgvcdXlkA/WrW18KCGgbqXHw1Iv2rwR5ePwBThnqo=;
	b=YqEGvNYQJch97jx8LsLvTW8et27vPe0O0u5OdSH1S0gvvxDH0UeulPzaur1wKNO3eR+Jn1
	bh3LyG7hEAx2rL2bwoTDbIJcobBTvGXPwPMASTtDiOGOQ5nSOcRqpkC6vNj/bpX8n2o+3Y
	qga2pHApvlJl3TaDFldhOMT8xwEIL3U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-uKYs8TbPP0mSbg8XMszBvw-1; Thu, 22 Jun 2023 15:52:44 -0400
X-MC-Unique: uKYs8TbPP0mSbg8XMszBvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9698B8E44FF;
	Thu, 22 Jun 2023 19:52:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4DAE2207B2BD;
	Thu, 22 Jun 2023 19:52:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 070FC1946588;
	Thu, 22 Jun 2023 19:52:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id EF23B1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 19:52:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BF9EE492B03; Thu, 22 Jun 2023 19:52:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B756F492B01
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 19:52:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8981E3C1351B
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 19:52:22 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com
 (wout4-smtp.messagingengine.com [64.147.123.20]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-1HJ1pXRNPgKu74B_nDqJig-1; Thu, 22 Jun 2023 15:52:20 -0400
X-MC-Unique: 1HJ1pXRNPgKu74B_nDqJig-1
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
 by mailout.west.internal (Postfix) with ESMTP id 280AE3200921;
 Thu, 22 Jun 2023 15:52:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute6.internal (MEProxy); Thu, 22 Jun 2023 15:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:content-type:date
 :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
 :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
 1687463524; x=1687549924; bh=YyBjDWBRBBm9cIGRJGADyk3vUYbrQamK+ab
 F3MBizlE=; b=TFXTVTJwnbAGITjqhDM6iX2Ze+haXedHzjMWwzSbqK2o30Xb6p8
 6qqcqvTzY6p5TQT4yebCL8gdVRiApaYF7ccQ+Z4f5RwEnnbpllWna1DifyXTy01A
 3u7cvpBCb/KzKpqtbm/LoDHg7RfdzIYAY5z7XGXLApDyewNleQgY5K7WpYGBkWGd
 wNL7P/huCCPGRvRk4eX/mt0oH7DX3Hchn0rL/mVfCI51Hp7eT+m/r9CEMqCKdcJp
 RvvFoPD4c4TB9RsQ9gebnJzZZUF4NHIAC6GC5okS87NTZdEP0ozaQ0fujvi7M06e
 +sucj6KvfBxuU9XxGSAulhuwCxKaaJTK+uw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:content-type:date:date
 :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm2; t=1687463524; x=1687549924; bh=YyBjDWBRBBm9c
 IGRJGADyk3vUYbrQamK+abF3MBizlE=; b=RNvoky+6cOi8g89p7ekUuB51jw1Yh
 HOs7Gc3w2EHMSdz1LMDIyFqGGyg4hAMc0dS+XtzDqCJFIDTbAi7WN+xZtZpS1dc8
 9MoJI2NSLYhfHZkWlXL8O0SV6eEtDMWpzMniAiVzG75a+xqKD6LC9LPX7+pAV7mc
 nYofEemvB5sZHtee8eazCENk4/f8ljNb9bOzwYmHSR1oq0ea6xSSaH56Q4IAxJr3
 pkZ3GH9TFNfA1YEx/o3GMPI9yBNdOQQ5G5dfw2lPICq4zk7sORdyqToTOjWZJ5p5
 NhDLfwGFaTYAaIZ7UsJG2h83t5Zq1IaCYOqhp+HWe8rEvbsnekCWRG17g==
X-ME-Sender: <xms:ZKaUZEfw79jF8odBkyywafiESJfhWjH3BrvgMcx88_RYCRU2tRdlLg>
 <xme:ZKaUZGM0c0vT7LHsRXeYt_LmhXOJtfxXw8Kcyub--F6Ith1NYgQU66b6-fYl-2p2B
 evF3WoE2WbYZM8>
X-ME-Received: <xmr:ZKaUZFiYwr3OhWODovYiZREkRazdr7aTazDKz3WBMH1UEzgTitGjpOFxDPc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeeguddgudegvdcutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedvjeetgeekhfetudfhgfetffeg
 fffguddvgffhffeifeeikeektdehgeetheffleenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:ZKaUZJ9ZvaaoFNsoLzN5woXqOYi3tovGOaD_1Zo-xBFl4tfi7syzAA>
 <xmx:ZKaUZAvH-9lSvzDNVK-QERCU3IBY23HGbpd-DkIrPitbfjbRYYeB1w>
 <xmx:ZKaUZAE-Eo4Eavmaf1Fwa52cruOqLyAb5Ttvk0nlZr4CL01eBIXqdw>
 <xmx:ZKaUZJ6KdtCxZxDadj7LCUfjNzkZMoC_JW9eEfyW1f56R1oZzjR-pA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jun 2023 15:52:04 -0400 (EDT)
Date: Thu, 22 Jun 2023 15:51:59 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mike Snitzer <snitzer@kernel.org>, mpatocka@redhat.com
Message-ID: <ZJSmYgvwoSY6Gb4f@itl-email>
References: <20230601212456.1533-1-demi@invisiblethingslab.com>
 <20230603145244.1538-1-demi@invisiblethingslab.com>
 <20230603145244.1538-2-demi@invisiblethingslab.com>
 <ZJR2rGZw0Ddf3TFK@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ZJR2rGZw0Ddf3TFK@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 1/6] device-mapper: Check that target
 specs are sufficiently aligned
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Alasdair Kergon <agk@redhat.com>
Content-Type: multipart/mixed; boundary="===============0596627938345898666=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4


--===============0596627938345898666==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YQ5Jmkqp6Z3iRGa0"
Content-Disposition: inline


--YQ5Jmkqp6Z3iRGa0
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Jun 2023 15:51:59 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mike Snitzer <snitzer@kernel.org>, mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/6] device-mapper: Check that target specs are
 sufficiently aligned

On Thu, Jun 22, 2023 at 12:28:28PM -0400, Mike Snitzer wrote:
> On Sat, Jun 03 2023 at 10:52P -0400,
> Demi Marie Obenour <demi@invisiblethingslab.com> wrote:
>=20
> > Otherwise subsequent code will dereference a misaligned
> > `struct dm_target_spec *`, which is undefined behavior.
> >=20
> > Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/md/dm-ioctl.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >=20
> > diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> > index cc77cf3d410921432eb0c62cdede7d55b9aa674a..34fa74c6a70db8aa67aaba3=
f6a2fc4f38ef736bc 100644
> > --- a/drivers/md/dm-ioctl.c
> > +++ b/drivers/md/dm-ioctl.c
> > @@ -1394,6 +1394,13 @@ static inline fmode_t get_mode(struct dm_ioctl *=
param)
> >  static int next_target(struct dm_target_spec *last, uint32_t next, voi=
d *end,
> >  		       struct dm_target_spec **spec, char **target_params)
> >  {
> > +	static_assert(_Alignof(struct dm_target_spec) <=3D 8,
> > +		      "struct dm_target_spec has excessive alignment requirements");
>=20
> Really not sure what you mean by "has excessive alignment requirements"...

This patch checks that struct dm_target_spec is 8-byte aligned.  That is
okay if its alignment is 8 or less, but not if is 16 or more, so I added
a static assert to check that struct dm_target_spec indeed requires at
most 8-byte alignment.  That said, =E2=80=9Cexcessive alignment requirement=
s=E2=80=9D is
(as shown by you having to ask this question) a bad error message.
Would =E2=80=9Cmust not require more than 8-byte alignment=E2=80=9D be bett=
er?

> > +	if (next % 8) {
> > +		DMERR("Next target spec (offset %u) is not 8-byte aligned", next);
> > +		return -EINVAL;
> > +	}
> > +
> >  	*spec =3D (struct dm_target_spec *) ((unsigned char *) last + next);
> >  	*target_params =3D (char *) (*spec + 1);
> > =20
>=20
> But this patch and patches 2 and 3 need more review. I'd like Mikulas to =
review.
>=20
> I did pick up patches 4-6 for the upcoming 6.5 merge window.

Thanks!

> Note, please prefix with "dm ioctl" instead of "device-mapper".

Good to know, thanks!  I have several additional patches written that
require patch 4.  Should I send patches 1 through 3 in the same series
as well?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--YQ5Jmkqp6Z3iRGa0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmSUpmIACgkQsoi1X/+c
IsGx1Q//Ydm7G9PCVgmVGbDeKxdO3GmtNGYNtOcV5It8IRFK8eO2JRQLJ8Bpji+t
IrRgCesejh3uZ+qu98BcYkUAnivmJuEK/ZOAVXgmO2qsehY45BZY32ZrNQy+2ruS
+JQAwDmIVRY7srRUom1ZetReo+ysDmuY56eaNG5D1DWfgUMOiqzCRoMdljyM+L55
Tm9PmAWYHYBcfeXgDKua/LYt+K3A0iX2GgnG0Wt9Mg9VzBNvH7GLosMSCKnx0pTF
uQi4jVK3u/aL/ItPZynt6Jh8nqlM+ZrX2pO2AmTiKSQU6bNNNgfhTjHPYXP2dM+w
thNB/84reRF9YoQqOIo3RNX2y0mIL9zuNKiLCbYLMDnPXtRGrK77uUvzSBlCHoYM
+04q9IwFRnWDpW1hgv9TgwOLJWQAKMvXgx+9l3uunDXM27tssUSJ3tgiwOjyG328
pql6iAdMWY263n4smC0OOw85q51EgmBWanF208lM4KMRPPgwtQrH97psbf1RAdwF
EMgHlF9En/VCBB2ELvFl4UgNNlaVKowF9fa4ORe+p0JaVWiA3694xhf+mnhCRoNv
KS2AaW4Uix+vZ1Cr4rfr6HprFGcM4yr6yfEpV/KVNOrfXVN4s9eEB9J/vU/zX8jB
SBSDNOcsi1OCIqIRRlZUTgxPW1inau6wlF3qr11A8JimGBL0nhA=
=a9VT
-----END PGP SIGNATURE-----

--YQ5Jmkqp6Z3iRGa0--


--===============0596627938345898666==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0596627938345898666==--

