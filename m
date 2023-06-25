Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B09E5EB64DC
	for <dm-devel@archiver.kernel.org>; Sun, 25 Jun 2023 16:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687711440;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=xYmJEulojCYBY1Y+jcaQl1fSXpCWjQv3PqKduPWvfw0=;
	b=g7J6K5HXJI4O6FGCYoutKdmyc8PRm4JLrXVO06Dmvf0eadBT/vFi4rxLMhV2Ud8qG4miyF
	ZF1qY9H9GvxtO9azNtDqZV4oidrTeWI0e9stXzKLxMlfvZcW37SebgOBHmqN6s1oba2ip3
	T/8+R78qg/PGzVaBJRdq4A/CQv0pq9I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-SCwer0KtPvWlSiH1nver2w-1; Sun, 25 Jun 2023 12:43:56 -0400
X-MC-Unique: SCwer0KtPvWlSiH1nver2w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EBD92185A78B;
	Sun, 25 Jun 2023 16:43:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A0216492B01;
	Sun, 25 Jun 2023 16:43:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5CD4A1946588;
	Sun, 25 Jun 2023 16:43:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 00A511946587
 for <dm-devel@listman.corp.redhat.com>; Sun, 25 Jun 2023 16:43:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DBD51492B03; Sun, 25 Jun 2023 16:43:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D318E492B01
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 16:43:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B57E31C03D91
 for <dm-devel@redhat.com>; Sun, 25 Jun 2023 16:43:52 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com
 [66.111.4.26]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-8OW_3N9ONBKRLe4Cr-CSsg-1; Sun, 25 Jun 2023 12:43:50 -0400
X-MC-Unique: 8OW_3N9ONBKRLe4Cr-CSsg-1
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
 by mailout.nyi.internal (Postfix) with ESMTP id 13DD95C005C;
 Sun, 25 Jun 2023 12:43:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute3.internal (MEProxy); Sun, 25 Jun 2023 12:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:content-type:date
 :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
 :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
 1687711430; x=1687797830; bh=mnkHX8vpNODUQLBztiQX7CwcPS1+k+UToFx
 uSmIlkMM=; b=DWg4UfKCmReyVxuaHQMjG/fpzgRQULhPnrcuJ4h2U/L55/Q+iUV
 kKb8zl0oNlXOtp9HHy1Le8yVwW6IXMvwHWaWk6+nC/y+WU/4ww4WaCc6mAsxDx6n
 8adzSSi39kujPE6sVRMFxSDKetJ8biVtttc5nkBqYKN2A17zYsEaCko0P0lbksKL
 IWkbpvC7OACKKNqJiQ0fh+NdU+wcx0PJIhAMPINQfLfHUY2mo6sukYlgCOsL1xMW
 uPe1L2sFgTamxMN+ysEK3Y/CuMyh/a3DWajz7muFlrlMVLaYL/LMxv8qelDO9MoX
 wz+w/PR2w94V2WeX+rxvHBrrWQFBGXc4Smg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:content-type:date:date
 :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm2; t=1687711430; x=1687797830; bh=mnkHX8vpNODUQ
 LBztiQX7CwcPS1+k+UToFxuSmIlkMM=; b=jKMynBRarGdJRvrbXYAIfukfzC1gX
 Xwi8SZ70foXcFAsfXq87SFF7h1dhyvtGiQjPHUNhHJw80O0q+2f986gX7EJzQOx8
 s3RxrKXCQF9HoZaKrIXR5b2fCaX3TM+Q+wAULPPf3VRtRmioO+YlPWGVrNrh7lCH
 Lf7paFL6+/+XtQWi6G1SxZYVjgYVE2LRahhBVhU4jmObkoscMy+ZC4SUHqT+m13v
 Hq+7XVY7+f0eYKNFNOTi3VFs5yj9wfDLxmgMS5NqiSeBFe785oEfyWFJQa24lAdX
 Kl8UD1IZeZiuaRULzwoclJ/9AAxeqZa3FAeAoqZqFFulxtJAGFW7vMrAw==
X-ME-Sender: <xms:xW6YZHgCC08tZMUItrXSa5PAoAjre8Mnxlb90fRUN4caAxGAXmqSDg>
 <xme:xW6YZED5fSonD_cG26ecrF4oE36KZpBEaQDruNhp9WwWzOVD1QvWcaik2TCZLvvKX
 EAGuseesKx5WU0>
X-ME-Received: <xmr:xW6YZHH48oOgJWPFs8FakezD5XkYKqnL44KzAKfxAawsDqYDA05kITNYEXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeehtddguddtvdcutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeduieelfeeutedvleehueetffej
 geejgeffkeelveeuleeukeejjeduffetjeekteenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:xW6YZES6uMQQV5I2qBnnaCknZkBKo48-3qwBKsBAgnj2FjUFV98qGw>
 <xmx:xW6YZEwr9KSJO2gIrYNyerK2vC6kSAm9zXGOGf2_RuYLPpURuzmXAg>
 <xmx:xW6YZK5T0-25Oe5FpWVbJJGdMusVdas_dVwr7LXlWgSANH8xUHWw3A>
 <xmx:xm6YZP_VJB2MJuMFB8zyX7-MLBJbv-jR3z9MwBpVNORRvPgak_u0Eg>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 25 Jun 2023 12:43:49 -0400 (EDT)
Date: Sun, 25 Jun 2023 12:43:44 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com
Message-ID: <ZJhuw3MaFjW5Bocw@itl-email>
References: <20230624230950.2272-1-demi@invisiblethingslab.com>
 <20230624230950.2272-4-demi@invisiblethingslab.com>
 <0b22e328-40e1-54d7-367c-96059a3fef7c@gmail.com>
 <ZJhlGCP0gTz7T3gG@itl-email>
 <81c94a1e-b316-c195-402c-01776f3200dc@gmail.com>
MIME-Version: 1.0
In-Reply-To: <81c94a1e-b316-c195-402c-01776f3200dc@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 3/4] dm ioctl: Allow userspace to suppress
 uevent generation
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
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="===============4939505936099087125=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9


--===============4939505936099087125==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xgxcetYBA/qMp0pW"
Content-Disposition: inline


--xgxcetYBA/qMp0pW
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Jun 2023 12:43:44 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2 3/4] dm ioctl: Allow userspace to suppress
 uevent generation

On Sun, Jun 25, 2023 at 06:33:33PM +0200, Milan Broz wrote:
> On 6/25/23 18:02, Demi Marie Obenour wrote:
> > On Sun, Jun 25, 2023 at 03:25:38PM +0200, Milan Broz wrote:
> > > On 6/25/23 01:09, Demi Marie Obenour wrote:
> > > > Userspace can use this to avoid spamming udev with events that udev
> > > > should ignore.
> > >=20
> > > Well, does it also mean that udev will not create /dev/disk/by-* syml=
inks
> > > (as response to the change udev event followed by internal udev blkid=
 scan)?
> >=20
> > In the use-case I have for this feature (block devices for Qubes VMs)
> > the blkid scan is unwanted and there are udev rules to prevent this.
> >=20
> > > If it is a private device, that is ok. But for a visible device I thi=
nk
> > > that it breaks some assumptions in userspace (presence of symlinks me=
ntioned
> > > above etc).
> >=20
> > The devices I am considering are implementation details of a userspace
> > process.  Nobody else should be opening them.  Ideally, no other
> > userspace process would even know they exist, at least without mucking
> > around in /proc or using ptrace.
> >=20
> > > So, what is the exact use for this patch?
> >=20
> > Ephemeral devices that are created, opened, marked for deferred removal,
> > assigned to a Xen VM (needs another patch currently being worked on),
> > and then closed.  udev has no business scanning these devices, and
> > indeed for it to scan them at all would be a security vulnerability
> > since their contents are under guest control.  There are udev rules to
> > ignore these devices, but for udev to even process the event wastes CPU
> > time and delays processing of other events that actually matter.  The
> > only symlink that possibly ought to be created is /dev/disk/by-diskseq
> > and I can just do that myself.
> But this is not clear from the patch header. I guess you also need
> to disable udev inotify on close on write, which will trigger device scan=
 too.
>=20
> BTW we use exactly this scenario in cryptsetup for years with existing fl=
ags
> (DM_UDEV_DISABLE_SUBSYSTEM_RULES_FLAG | DM_UDEV_DISABLE_DISK_RULES_FLAG
> DM_UDEV_DISABLE_OTHER_RULES_FLAG) - just rules are ignored while uevent i=
s still
> sent.
> Anyway, not sure we need another way to disable it; I just asked do you n=
eed it.

How can one set these flags using the raw kernel ioctls?  The code I am
working on does not use libdevmapper at all and just uses the kernel API
directly.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--xgxcetYBA/qMp0pW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmSYbsQACgkQsoi1X/+c
IsG7Lg/+JO5Xx1J/OAEBlAdC5MHRtdJVoYorTf91RrYG3eFJcxMF8EjoKbwFUL+Q
NzQ6bpzZx7QUHKybUCJD9h2OYBz1y5gUllfw8nbffxncrlWLuIEuuFah9pJQSz1P
WQD0g8KFCpW0atLhAaEYJEdU6eABOL53une4H3NShRUZ0UR5Mj3hAWNUuq2GL+QA
VmA1Riz/w8l3ynOucuexpefC+s4UMn1kel4PYVRQkD81UFn5Qn/OtwNbabJwSA2P
XyvQHcEEsKbdsd7hYyxLB1JgPRtp83qLI7uclQofJlFpaxPN/1apjaw049IX1akY
OZOGaUWIG/xyXd9zh7mwHFf37bvjwLEzASEyKKA4btO/Lsql8zpUmxuOkN6/xYoo
5fRVYLle1lXg2l1Pe55Igu65Z/n+zeWq1oxi3WA1zIOFyVOzR6Jp6g4g4u7X7iBO
1HbPca1foLtfdEL47/55ZyikIi4Z1Mu7v5gZDZnwdtRB2oklj1VyWsjFZzPNRo7P
UJY93Ldmjgg26eDukMQNYQGcPXb4+7eo90C9KkaDoWP2ykyWiStmDBZviYrkSp0j
8c1VfdvnieL9maPHq5gH8SyzSK1Q9Z7J1zptSe6+7xrhd3cc3AlJbLvP1EBwU5fX
ZfF4M4f+2H72QR8ATh4akixRJ9FZs64YoRKKYWxVvTiOd5GCCa0=
=CIIC
-----END PGP SIGNATURE-----

--xgxcetYBA/qMp0pW--


--===============4939505936099087125==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============4939505936099087125==--

