Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D60DC7EE2E
	for <dm-devel@archiver.kernel.org>; Fri,  9 Jun 2023 16:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686329755;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=b1cCVbHFTg6Engza54Y5rV4DlM254fMjqVqFaVATezs=;
	b=G87Q1pcjTlkVorL++9VGjy8dPiQJvlWCMdj0jb1ProUHHyWJYZz7KaGO6SEBGSFX/pzTQt
	0j3byCnfX2hPuOtSYl97U5WH3WokzwYKF5set16mS21bCdMPjA5l5Wk0PslK4XYHIPBwj/
	Fyns3xmupntQsLk7zRl3VAIDu30iTKw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-w66omVwWMbO3RAeQBmMt5A-1; Fri, 09 Jun 2023 12:55:52 -0400
X-MC-Unique: w66omVwWMbO3RAeQBmMt5A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2625C802E58;
	Fri,  9 Jun 2023 16:55:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA2192166B25;
	Fri,  9 Jun 2023 16:55:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 75FA719451C1;
	Fri,  9 Jun 2023 16:55:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C9DCC194658C
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Jun 2023 16:55:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B345A10DF8; Fri,  9 Jun 2023 16:55:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AB17310724
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 16:55:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8904385A5BA
 for <dm-devel@redhat.com>; Fri,  9 Jun 2023 16:55:48 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com
 [66.111.4.27]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-nqn6IGckNHmYNKh2TaVYtA-1; Fri, 09 Jun 2023 12:55:46 -0400
X-MC-Unique: nqn6IGckNHmYNKh2TaVYtA-1
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
 by mailout.nyi.internal (Postfix) with ESMTP id 4B65F5C0056;
 Fri,  9 Jun 2023 12:55:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute4.internal (MEProxy); Fri, 09 Jun 2023 12:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 invisiblethingslab.com; h=cc:cc:content-type:content-type:date
 :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
 :references:reply-to:sender:subject:subject:to:to; s=fm1; t=
 1686329746; x=1686416146; bh=jO2lbJWjlD3AhgpqUQ7r9uAT+WfB1wgKDIz
 85pj33i8=; b=CFe8GJvCu68K0tqO7GAJP6Ph6cIOC2pvsTRjyaNHLMrLHIqfIrj
 YNX4nMFHKqrYV/DXSlCwpi/YUqseg+9pvjoePMDxNbtwMAYglhGHcinU27Lv4Nge
 iprtLLfS05YW420koXxSramZzljJ13kMSyGpcQDKMLu+l2UpLKoIW7JUnoBCC9w5
 3WvQIwc30hDHL3STx5A28AG2gToQmSA/81lgiZGC1aVYYYhhynIITnwaqL0kUcit
 UhqG2xxdv1xqUDE5CCezw2JSimg7m0Kw4MwAkbJSKmeaGTvh3NFF6JEgdWq7uHem
 vm82rr1PCA10l657SPM1nZh1AJkv1cwWAsg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:content-type:date:date
 :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
 :message-id:mime-version:references:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm1; t=1686329746; x=1686416146; bh=jO2lbJWjlD3Ah
 gpqUQ7r9uAT+WfB1wgKDIz85pj33i8=; b=w8IbCCCTVKAFYoq8dgC972pYva5Rb
 mmPzwOwxgvYmOjUrELKiPGAM6xKit7KvVC5+LMnxgjZkkmXhX1BMtuM2vE7mcPAk
 GUqBi3l7H46V8uaxggrhYHTiA+8rd8QGK4hoNe2gFaEUH0ZKdpuXoyZ8a4V2r3Ff
 IQDBDuoVWMv/DvmZpg2ksqgOXP5ejpSurUM3D16H09COGtmlebrbEamBJ6dslAX0
 E49uxqb41lq3OyLIbhztPb7oS54B1kP5qaV+P/G5OMka82JA2Ht8ZO3dqTj1P1kq
 9/IbitskUvdGmOc2M5SWosWh4pucYOXQ5ISBq/itbcv/bowxxPPCfBhrQ==
X-ME-Sender: <xms:kVmDZC9XOZM6ptkjSOu_HzwPcmVSxza92St4hphFJ7JJRn_TvOzYbQ>
 <xme:kVmDZCt1CJ2HeRiSmUgAO84fKWAqR7_0tMIbF-CrMahSVI9FsYmjcKo2852XRBJaG
 B9JD3erOYWGja8>
X-ME-Received: <xmr:kVmDZIDd4roaVuvmRuTBFsW_9uyshMMr_FHPRXnUlemwKv8uKEj-qReXJ98>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtkedguddtjecutefuodetggdotefrod
 ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
 necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
 enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghm
 ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
 hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedvjeetgeekhfetudfhgfetffeg
 fffguddvgffhffeifeeikeektdehgeetheffleenucevlhhushhtvghrufhiiigvpedtne
 curfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhg
 shhlrggsrdgtohhm
X-ME-Proxy: <xmx:kVmDZKe7fNwLf_sshCBl8TDwl2n7fLQAEwQz93RdgWpXrtJnN4lmeQ>
 <xmx:kVmDZHO06_1FTNq7mRU6Rkx6aJ9L1U4fwwe96uRP-7r4tPQsPH66ww>
 <xmx:kVmDZEnDZXZLxSX7nDYzpAzBEhRJ6GQyNrKk1n0v0LPOIj5Od2DURw>
 <xmx:klmDZDDm9qAHm16nDZgjqB1d0yGKjkRzPWSz64opTfCUZmIeyAtEIw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 9 Jun 2023 12:55:44 -0400 (EDT)
Date: Fri, 9 Jun 2023 12:55:39 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Message-ID: <ZINZj8ubQj7yFxdR@itl-email>
References: <20230530203116.2008-1-demi@invisiblethingslab.com>
 <20230530203116.2008-14-demi@invisiblethingslab.com>
 <ZH7tizoYl8YVFN9B@Air-de-Roger> <ZH9mZGbM32CDmKGF@itl-email>
 <ZIA9uBJxx2gqA4Cq@Air-de-Roger> <ZICs+WYCPYdu2yoI@itl-email>
 <ZIGRXrSGmgLF/07O@Air-de-Roger> <ZIH0yQCICZRpliSc@itl-email>
 <ZINBqToBZVdfmr0e@Air-de-Roger>
MIME-Version: 1.0
In-Reply-To: <ZINBqToBZVdfmr0e@Air-de-Roger>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v2 13/16] xen-blkback: Implement diskseq
 checks
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
Cc: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
 Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 xen-devel@lists.xenproject.org, Alasdair Kergon <agk@redhat.com>
Content-Type: multipart/mixed; boundary="===============6233396161312301160=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6


--===============6233396161312301160==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Ii0jDpZ9bgT07th0"
Content-Disposition: inline


--Ii0jDpZ9bgT07th0
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 9 Jun 2023 12:55:39 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
	Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 13/16] xen-blkback: Implement diskseq checks

On Fri, Jun 09, 2023 at 05:13:45PM +0200, Roger Pau Monn=C3=A9 wrote:
> On Thu, Jun 08, 2023 at 11:33:26AM -0400, Demi Marie Obenour wrote:
> > On Thu, Jun 08, 2023 at 10:29:18AM +0200, Roger Pau Monn=C3=A9 wrote:
> > > On Wed, Jun 07, 2023 at 12:14:46PM -0400, Demi Marie Obenour wrote:
> > > > On Wed, Jun 07, 2023 at 10:20:08AM +0200, Roger Pau Monn=C3=A9 wrot=
e:
> > > > > On Tue, Jun 06, 2023 at 01:01:20PM -0400, Demi Marie Obenour wrot=
e:
> > > > > > On Tue, Jun 06, 2023 at 10:25:47AM +0200, Roger Pau Monn=C3=A9 =
wrote:
> > > > > > > On Tue, May 30, 2023 at 04:31:13PM -0400, Demi Marie Obenour =
wrote:
> > > > > > > Also, you tie this logic to the "physical-device" watch, which
> > > > > > > strictly implies that the "diskseq" node must be written to x=
enstore
> > > > > > > before the "physical-device" node.  This seems fragile, but I=
 don't
> > > > > > > see much better optiono since the "diskseq" is optional.
> > > > > >=20
> > > > > > What about including the diskseq in the "physical-device" node?=
  Perhaps
> > > > > > use diskseq@major:minor syntax?
> > > > >=20
> > > > > Hm, how would you know whether the blkback instance in the kernel
> > > > > supports the diskseq syntax in physical-device?
> > > >=20
> > > > That=E2=80=99s what the next patch is for =F0=9F=99=82.
> > >=20
> > > Hm, I think we should separate diskseq support from the notify open
> > > stuff: it's possible a different (non-Linux) backend wants to
> > > implement open notify support but doesn't have diskseq.
> >=20
> > I like this idea!  What about having blkback set diskseq to zero?
> > Userspace could then replace it with the actual value.
>=20
> I think it would be better if we used a sysfs node, because blkfront
> has no business is knowing whether diskseq is supported by the
> backend or not.
>=20
> xenstore should be reserved to features exposed between blkfront and
> blkback if possible.  I know we haven't been very good at this
> however.
>=20
> > > > > Can you fetch a disk using a diskseq identifier?
> > > >=20
> > > > Not yet, although I have considered adding this ability.  It would =
be
> > > > one step towards a =E2=80=9Cdiskseqfs=E2=80=9D that userspace could=
 use to open a device
> > > > by diskseq.
> > > >=20
> > > > > Why I understand that this is an extra safety check in order to a=
ssert
> > > > > blkback is opening the intended device, is this attempting to fix=
 some
> > > > > existing issue?
> > > >=20
> > > > Yes, it is.  I have a block script (written in C) that validates the
> > > > device it has opened before passing the information to blkback.  It=
 uses
> > > > the diskseq to do this, but for that protection to be complete, blk=
back
> > > > must also be aware of it.
> > >=20
> > > But if your block script opens the device, and keeps it open until
> > > blkback has also taken a reference to it, there's no way such device
> > > could be removed and recreated in the window you point out above, as
> > > there's always a reference on it taken?
> >=20
> > This assumes that the block script is not killed in the meantime,
> > which is not a safe assumption due to timeouts and the OOM killer.
>=20
> Doesn't seem very reliable to use with delete-on-close either then.

That=E2=80=99s actually the purpose of delete-on-close!  It ensures that if=
 the
block script gets killed, the device is automatically cleaned up.

> > > > > I'm not sure I see how the major:minor numbers would point to a
> > > > > different device than the one specified by the toolstack unless t=
he
> > > > > admin explicitly messes with the devices before blkback has got t=
ime
> > > > > to open them.  But then the admin can already do pretty much
> > > > > everything it wants with the system.
> > > >=20
> > > > Admins typically refer to e.g. device-mapper devices by name, not by
> > > > major:minor number.  If a device is destroyed and recreated right a=
s the
> > > > block script is running, this race condition can occur.
> > >=20
> > > Right, but what about this device recreation happening after the admin
> > > has written the guest config file but before the call to (lib)xl
> > > happens?  blkback would also end up using a different device than
> > > indented, and your proposed approach doesn't fix this.  The only way =
to
> > > solve this would be to reference devices by UUID (iow: diskseq)
> > > directly in the guest config file.
> >=20
> > That would be a good idea, but it is orthogonal to this patch.  My
> > script opens the device and uses various means to check that it did
> > open the correct device.  It then passes the diskseq to blkback.
>=20
> How you do this with losetup?  I guess there's an atomic way to setup
> a loop device and get its diskseq?

It can=E2=80=99t be done with losetup.  I use a C program that directly
issues ioctls to /dev/loop-control and /dev/loop*.  Doing this with
device-mapper requires kernel patches that have been submitted but are
not yet upstream.

> > > Then the block script will open the device by diskseq and pass the
> > > major:minor numbers to blkback.
> >=20
> > Alternatively, the toolstack could write both the diskseq and
> > major:minor numbers and be confident that it is referring to the
> > correct device, no matter how long ago it got that information.
> > This could be quite useful for e.g. one VM exporting a device to
> > another VM by calling losetup(8) and expecting a human to make a
> > decision based on various properties about the device.  In this
> > case there is no upper bound on the race window.
>=20
> Instead of playing with xenstore nodes, it might be better to simply
> have blkback export on sysfs the diskseq of the opened device, and let
> the block script check whether that's correct or not.  That implies
> less code in the kernel side, and doesn't pollute xenstore.

This would require that blkback delay exposing the device to the
frontend until the block script has checked that the diskseq is correct.
Much simpler for the block script to provide the diskseq in xenstore.
If you want to avoid an extra xenstore node, I can make the diskseq part
of the physical-device node.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--Ii0jDpZ9bgT07th0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmSDWY8ACgkQsoi1X/+c
IsG4QxAA2SL5LAC2MiiRag652Tx+P83kIuMlP80Tw9d8diHvH0RXigUlTyFfvfWs
I9kGjhjt+uLbxPwlyKxkEh4V6DqUjfOE7UP1gfIDy7e1kTJAv09LT/lXII5Bw/0f
YihsdqSa9TwI19LxinadkWk213EgtmZPGE0jp6r6DU897mzg6mHsL94mo5PxmAMM
MRRhQRABTHhggZLCx/JghFfb+C8CXO9mf88vAvClPwTs4BAYZrZG1R2g+Z6i8mHb
y5Hk2++ImNB3FNT8j+dZKT9NdEqAXg8CHaOB5XsMcd4FFAeiFkFOCWr4n/4tRxAJ
nJMgOIfAYFguSHz8UY2tenMh460dbtlKaE2YTKiS9vpCw7AZ+hSQIW/pysiTT0DO
ZrLu3Vri6iWiDWOFx9gpoPR13/j07vlJyCG8Xo6yc4E/JPqUXKZrg8pZtiPmaLe7
XLp+aLPyxTEGQqteROkZe6ZxdawI/DLcmHEc9xbR1iBtWCkBK0J9r5tg/N5nySKE
RB40g9w94ZDkFTBDKZ1PrKWgu3FydVA+hZDMXJuNdl6XLOaGZQuaRUAw1pkB3ING
/wxwQAFqkQCO51XPGKnNX3kwSJkedsMTYcLN8dtcsZ69IXq0sBpsbScVTjyYlVqE
kQL6JEfCjZLiTQIVnwoSmcFmtun9Z+cS3t4RSeLUJHFuM9pJ/mo=
=SvFi
-----END PGP SIGNATURE-----

--Ii0jDpZ9bgT07th0--


--===============6233396161312301160==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============6233396161312301160==--

