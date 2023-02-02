Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A29FC61DA4
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 07:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675669145;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=9+vdIubMbYKBQMT0D6rhexu07pDfzR42+g8faurEk24=;
	b=HogB1ttJ0Ku49ONz2S2+fzv89Fm9TZnPtt6/T4lEfHLPFtbYHjgpCDYdBo1rqVy+Jq/pgS
	ru7DWAPKhOekWspgOz+9+qiRIW8Jdb4how/CYcGdAT0Js9gWor6r9hcDajEdfVvFe30XOQ
	ey9OHj5DUsDCTTJC+50Jl3y3fptEjlE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-o1YFAUNhPzmEf4BPjXVcrg-1; Mon, 06 Feb 2023 02:38:38 -0500
X-MC-Unique: o1YFAUNhPzmEf4BPjXVcrg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EC40100F914;
	Mon,  6 Feb 2023 07:38:36 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BEF72166B29;
	Mon,  6 Feb 2023 07:38:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DA2871946A54;
	Mon,  6 Feb 2023 07:38:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A4DB61946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 20:58:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85270404BEC2; Thu,  2 Feb 2023 20:58:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D43B404BEC0
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 20:58:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 606451C05AC2
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 20:58:08 +0000 (UTC)
Received: from wout2-smtp.messagingengine.com
 (wout2-smtp.messagingengine.com [64.147.123.25]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-66-OLkdWwa4NtGO4dfq_MtcOw-1; Thu, 02 Feb 2023 15:58:06 -0500
X-MC-Unique: OLkdWwa4NtGO4dfq_MtcOw-1
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
 by mailout.west.internal (Postfix) with ESMTP id DA6AD320092B;
 Thu,  2 Feb 2023 15:58:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
 by compute1.internal (MEProxy); Thu, 02 Feb 2023 15:58:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:date:date:from:from
 :in-reply-to:in-reply-to:message-id:mime-version:references
 :reply-to:sender:subject:subject:to:to; s=fm3; t=1675371483; x=
 1675457883; bh=dzgq76cYFXWqr386VYF7ubjMYy/4D3tzRP84ABBYvhg=; b=s
 yCLlVbTqQbtyOeBRMnG9EpqbCx6GzKG4Hg76/luZQ/eT+Nq9KviKBIiPk+EkLyHN
 wY8o1LK4fkCBtVnIJpyFq/3uMePbmk18mOBTu1FtZlnea8hsTT+V0ADGIDWRhH0Y
 HmaXYjlOubsbx0jyYW+w6UkKGWiAPzRLX01mPJLTxzP3CbDw+xuj6CZsMzdaJHwy
 zz7n0TZRUFqXaB+xy6f9WcjAeq2n1OrDxGcXKRnyc5jxfA50PCEqMf1Dv4h+Ilys
 +0pQMVtNOlgCmknLyqvAUXce5gpbqq8qhAlozlmsIsTboWSZ0IaKavHetQepNQ+N
 Vf4qnei6SmJnjdUl3+Y8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
 :feedback-id:from:from:in-reply-to:in-reply-to:message-id
 :mime-version:references:reply-to:sender:subject:subject:to:to
 :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
 fm3; t=1675371483; x=1675457883; bh=dzgq76cYFXWqr386VYF7ubjMYy/4
 D3tzRP84ABBYvhg=; b=d478ZEMjTvlRbXKOPtpHsd8vraJQZ8JvpW/VI0IyDbKa
 ub8yalBozVWUnGc6bPbOpDNSOTg8Lm0AVtkKHHYIBiEZB4EQsN/G6zRvWYh/SO77
 oqaoIBNpljYZmw0CZVXXQPbpSe7AT/+1VmKYR2NkuJyf5+DLFBJG7RDslYanVOWi
 xDu6yLmqiurqTapj3VST8SSDjPqEIvq3uDPEHgeQB1moyddyusGd+OZGX/EaVbmr
 qJd5lvChm0484XwC1n1MJ0Pb6H2CISyZtIB2oCMiRoBfs7hjL3BCjlrH/zHRCN/O
 swy3q63rmHwpD4B13y5JUcNG3YJJTV7ZSCiIo5S80g==
X-ME-Sender: <xms:2yPcY7tcw21RPig7naYjpZ6H6dwpquQnrG9dyYCCsC_SO_OrElL9tw>
 <xme:2yPcY8eZ2C_sdhpFPhKUBAGGjp7cEYKEExpHOBXe12q6JcbAonrRs4vlap4ncRPyE
 rzOyfPCyxHOsp8>
X-ME-Received: <xmr:2yPcY-ybNkb6KIwG6AijR8J_KlnElmfdmJgF3stTvxmSv21P77BvI7VYu1I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudefkedgudegtdcutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedvjeetgeekhfetudfhgfetffeg
 fffguddvgffhffeifeeikeektdehgeetheffleenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:2yPcY6PXyZ-XxC3SkpbI8K-CuaRtc4uGfh6p8bDVxakleZoHXx3h5w>
 <xmx:2yPcY78GNcH9dYC5p5jT_OkOQJUe0tG5IGP3yjLdVptSBUrOtLpdMw>
 <xmx:2yPcY6UVnkK9xEhPiWHjp90EY8gUVooRfy67Mbs9Q-MqOueT7KlUnA>
 <xmx:2yPcY8MjyBeI6TP0-uGTzOPpMY64H6ftI7SGGQ-hEU3jV0fGd_QJVA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Feb 2023 15:58:02 -0500 (EST)
Date: Thu, 2 Feb 2023 15:57:55 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mike Snitzer <snitzer@kernel.org>
Message-ID: <Y9wj2MpEXI/P2/6/@itl-email>
References: <20230126033358.1880-1-demi@invisiblethingslab.com>
 <Y9vp3XDEQAl7TLND@redhat.com> <Y9wEF3rWfpiCKc2i@itl-email>
 <Y9wVcskXyOk3bbzC@redhat.com>
MIME-Version: 1.0
In-Reply-To: <Y9wVcskXyOk3bbzC@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Mon, 06 Feb 2023 07:38:31 +0000
Subject: Re: [dm-devel] [RFC PATCH 0/7] Allow race-free block device handling
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
Cc: Jens Axboe <axboe@kernel.dk>, Juergen Gross <jgross@suse.com>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>,
 Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Content-Type: multipart/mixed; boundary="===============5335809600894783210=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6


--===============5335809600894783210==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cgmN2P5oJuiMWNP7"
Content-Disposition: inline


--cgmN2P5oJuiMWNP7
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 2 Feb 2023 15:57:55 -0500
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>,
	Alasdair Kergon <agk@redhat.com>,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Juergen Gross <jgross@suse.com>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
	dm-devel@redhat.com
Subject: Re: [RFC PATCH 0/7] Allow race-free block device handling

On Thu, Feb 02, 2023 at 02:56:34PM -0500, Mike Snitzer wrote:
> On Thu, Feb 02 2023 at  1:41P -0500,
> Demi Marie Obenour <demi@invisiblethingslab.com> wrote:
>=20
> > On Thu, Feb 02, 2023 at 11:50:37AM -0500, Mike Snitzer wrote:
> > > On Wed, Jan 25 2023 at 10:33P -0500,
> > > Demi Marie Obenour <demi@invisiblethingslab.com> wrote:
> > >=20
> > > > This work aims to allow userspace to create and destroy block devic=
es
> > > > in a race-free and leak-free way,
> > >=20
> > > "race-free and leak-free way" implies there both races and leaks in
> > > existing code. You're making claims that are likely very specific to
> > > your Xen use-case.  Please explain more carefully.
> >=20
> > Will do in v2.
> >=20
> > > > and to allow them to be exposed to
> > > > other Xen VMs via blkback without leaks or races.  It=E2=80=99s mar=
ked as RFC
> > > > for a few reasons:
> > > >=20
> > > > - The code has been only lightly tested.  It might be unstable or
> > > >   insecure.
> > > >=20
> > > > - The DM_DEV_CREATE ioctl gains a new flag.  Unknown flags were
> > > >   previously ignored, so this could theoretically break buggy users=
pace
> > > >   tools.
> > >=20
> > > Not seeing a reason that type of DM change is needed. If you feel
> > > strongly about it send a separate patch and we can discuss it.
> >=20
> > Patch 2/7 is the diskseq change.  v2 will contain a revised and tested
> > version with a greatly expanded commit message.
>=20
> I'm aware that 2/7 is where you make the DM change to disallow unknown
> flags, what I'm saying is I don't see a reason for that change.

Thanks for the clarification.

> Certainly doesn't look to be a requirement for everything else in that
> patch.

Indeed it is not.  I will make it a separate patch.

> So send a separate patch, but I'm inclined to _not_ accept it because
> it does potentially break some userspace.

Is it okay to add DM_FILE_DESCRIPTOR_FLAG (with the same meaning as in
2/7) _without_ rejecting unknown flags?  The same patch would bump the
minor version number, so userspace would still be able to tell if the
kernel supported DM_FILE_DESCRIPTOR_FLAG.  If you wanted, I could ignore
DM_FILE_DESCRIPTOR_FLAG unless the minor number passed by userspace is
sufficiently recent.

Another option would be to make userspace opt-in to strict parameter
checking by passing 5 as the major version instead of 4.  Userspace
programs that passed 4 would get the old behavior, while userspace
programs that passed 5 would get strict parameter checking and be able
to use new features such as DM_FILE_DESCRIPTOR_FLAG.

> > > > - I have no idea if I got the block device reference counting and
> > > >   locking correct.
> > >=20
> > > Your headers and justifcation for this line of work are really way too
> > > terse. Please take the time to clearly make the case for your changes
> > > in both the patch headers and code.
> >=20
> > I will expand the commit message in v2, but I am not sure what you want
> > me to add to the code comments.  Would you mind explaining?
>=20
> Nothing specific about code, was just a general reminder (based on how
> terse the 2/7 header was).
>=20
> Mike

Thanks for the feedback!
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--cgmN2P5oJuiMWNP7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmPcI9YACgkQsoi1X/+c
IsF28hAAhImjjtlWhG/0QL5ADEU4goFI++sArqOlA2RYmyVjye52flwl4Fzd+px3
qEsA6mLllD0x2SxfycOirT3D5d0Gsa8BVPs+WiaWed5Rc+LececX+YGQ6HgEUZBM
Ig69iNxrCcA5CARoNWd/RsHZSuxSE9ltgzo00ghW+LNRKVyYAn0nuAWddWLqYrvr
wVdonaDhI5IC15GPQ4CK4T21JTO16NsUjld1A03pgr0ubzV+UpwWGNycwjSpz2KB
WzHAq5NTLvda6dLUmt1o/z7dJR04gPA8ICyF/zKXzkjuOgeTvQOTY25iv5O3xQYv
1WHAJJqxb8twWMw+bU92sjoUJy4jdqr5DQ7n+ga5eEG0YAPBkRwcPuKdJdotbUFF
8VP90nUdWDGlmc+w20GlNzziVOyxLFbVgxFO1evJ0Kq023gzvcgs69RqV1mLfP44
hD18hdcC2ytp8TwhNrERzmBxWjEtD1MphgGXAiJQ0qQEyYlKAYNUyolM8lTnTQR9
Xccwj6ow7pMDIV+DkNuD4Ebiu7dx4WhjyTc4jx9NHSUUDeuff0v4PzFCiXr/x/dN
0Sml2ojt43HPUfLXaepFNwLCqL54zGNNa2gsH0gyl0iwAFMAgNbMcUAx10lCOmDj
d7i37cInvPYgsSr2WUgz7mbiLlQN3Eh8tf5ut+q+OOOq+cRPKCs=
=P5Xt
-----END PGP SIGNATURE-----

--cgmN2P5oJuiMWNP7--


--===============5335809600894783210==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5335809600894783210==--

